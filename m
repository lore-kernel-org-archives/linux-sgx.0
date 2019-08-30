Return-Path: <SRS0=mvcT=W2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DD0C3A5A8
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Aug 2019 00:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1BDB2173E
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Aug 2019 00:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfH3ARJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:17:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:30403 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfH3ARJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 20:17:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 17:17:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="205917820"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 29 Aug 2019 17:17:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH v3 2/5] x86/sgx: Reject concurrent ioctls on single enclave
Date:   Thu, 29 Aug 2019 17:17:03 -0700
Message-Id: <20190830001706.29309-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190830001706.29309-1-sean.j.christopherson@intel.com>
References: <20190830001706.29309-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Except for ENCLAVE_SET_ATTRIBUTE, all SGX ioctls() must be executed
serially to successfully initialize an enclave, e.g. the kernel already
strictly requires ECREATE->EADD->EINIT, and concurrent EADDs will result
in an unstable MRENCLAVE.  Explicitly enforce serialization by returning
EINVAL if userspace attempts an ioctl while a different ioctl for the
same enclave is in progress.

The primary beneficiary of explicit serialization is sgx_encl_grow() as
it no longer has to deal with dropping and reacquiring encl->lock when
a new VA page needs to be allocated.  Eliminating the lock juggling in
sgx_encl_grow() paves the way for fixing a lock ordering bug in
ENCLAVE_ADD_PAGE without having to also juggle mm->mmap_sem.

Serializing ioctls also fixes a race between ENCLAVE_CREATE and
ENCLAVE_SET_ATTRIBUTE, as the latter does not take encl->lock, e.g.
concurrent updates to allowed_attributes could result in a stale
value.  The race could also be fixed by taking encl->lock or making
allowed_attributes atomic, but both add unnecessary overhead with this
change applied.

Note, manipulating the list of VA pages (encl->va_pages) during EADD
must be done while holding encl->lock, the list of VA pages is visible
to the reclaimer after the first EADD completes.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.h  |  1 +
 arch/x86/kernel/cpu/sgx/ioctl.c | 99 ++++++++++++++++-----------------
 2 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index ffc09e1a0fc6..c7608964d69e 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -56,6 +56,7 @@ enum sgx_encl_flags {
 	SGX_ENCL_INITIALIZED	= BIT(1),
 	SGX_ENCL_DEBUG		= BIT(2),
 	SGX_ENCL_DEAD		= BIT(3),
+	SGX_ENCL_IOCTL		= BIT(4),
 };
 
 struct sgx_encl_mm {
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index d05cf051ca45..1aa881e69ac1 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -14,8 +14,7 @@
 #include <linux/suspend.h>
 #include "driver.h"
 
-static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl,
-					 unsigned int disallowed_flags)
+static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 {
 	struct sgx_va_page *va_page = NULL;
 	void *err;
@@ -23,36 +22,19 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl,
 	BUILD_BUG_ON(SGX_VA_SLOT_COUNT !=
 		(SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
 
-	if (atomic_read(&encl->flags) & disallowed_flags)
-		return ERR_PTR(-EFAULT);
-
 	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT)) {
-		mutex_unlock(&encl->lock);
-
 		va_page = kzalloc(sizeof(*va_page), GFP_KERNEL);
-		if (!va_page) {
-			mutex_lock(&encl->lock);
+		if (!va_page)
 			return ERR_PTR(-ENOMEM);
-		}
 
 		va_page->epc_page = sgx_alloc_va_page();
-		mutex_lock(&encl->lock);
-
 		if (IS_ERR(va_page->epc_page)) {
 			err = ERR_CAST(va_page->epc_page);
 			kfree(va_page);
 			return err;
-		} else if (atomic_read(&encl->flags) & disallowed_flags) {
-			sgx_free_page(va_page->epc_page);
-			kfree(va_page);
-			return ERR_PTR(-EFAULT);
-		} else if (encl->page_cnt % SGX_VA_SLOT_COUNT) {
-			sgx_free_page(va_page->epc_page);
-			kfree(va_page);
-			va_page = NULL;
-		} else {
-			list_add(&va_page->list, &encl->va_pages);
 		}
+
+		WARN_ON_ONCE(encl->page_cnt % SGX_VA_SLOT_COUNT);
 	}
 	encl->page_cnt++;
 	return va_page;
@@ -174,13 +156,14 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	struct file *backing;
 	long ret;
 
-	mutex_lock(&encl->lock);
+	if (atomic_read(&encl->flags) & SGX_ENCL_CREATED)
+		return -EINVAL;
 
-	va_page = sgx_encl_grow(encl, SGX_ENCL_CREATED | SGX_ENCL_DEAD);
-	if (IS_ERR(va_page)) {
-		ret = PTR_ERR(va_page);
-		goto err_out_unlock;
-	}
+	va_page = sgx_encl_grow(encl);
+	if (IS_ERR(va_page))
+		return PTR_ERR(va_page);
+	else if (va_page)
+		list_add(&va_page->list, &encl->va_pages);
 
 	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);
 	if (sgx_validate_secs(secs, ssaframesize)) {
@@ -230,12 +213,11 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 
 	/*
 	 * Set SGX_ENCL_CREATED only after the enclave is fully prepped.  This
-	 * allows other flows to check if the enclave has been created without
-	 * taking encl->lock.
+	 * allows setting and checking enclave creation without having to take
+	 * encl->lock.
 	 */
 	atomic_or(SGX_ENCL_CREATED, &encl->flags);
 
-	mutex_unlock(&encl->lock);
 	return 0;
 
 err_out:
@@ -249,8 +231,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 err_out_shrink:
 	sgx_encl_shrink(encl, va_page);
 
-err_out_unlock:
-	mutex_unlock(&encl->lock);
 	return ret;
 }
 
@@ -270,9 +250,8 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
  *   0 on success,
  *   -errno otherwise
  */
-static long sgx_ioc_enclave_create(struct file *filep, void __user *arg)
+static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
 {
-	struct sgx_encl *encl = filep->private_data;
 	struct sgx_enclave_create ecreate;
 	struct page *secs_page;
 	struct sgx_secs *secs;
@@ -404,14 +383,21 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 		return PTR_ERR(epc_page);
 	}
 
-	mutex_lock(&encl->lock);
-
-	va_page = sgx_encl_grow(encl, SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD);
+	va_page = sgx_encl_grow(encl);
 	if (IS_ERR(va_page)) {
 		ret = PTR_ERR(va_page);
 		goto err_out_free;
 	}
 
+	mutex_lock(&encl->lock);
+
+	/*
+	 * Adding to encl->va_pages must be done under encl->lock.  Ditto for
+	 * deleting (via sgx_encl_shrink()) in the error path.
+	 */
+	if (va_page)
+		list_add(&va_page->list, &encl->va_pages);
+
 	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
 				encl_page);
 	if (ret)
@@ -431,12 +417,12 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 
 err_out_shrink:
 	sgx_encl_shrink(encl, va_page);
+	mutex_unlock(&encl->lock);
 
 err_out_free:
 	sgx_free_page(epc_page);
 	kfree(encl_page);
 
-	mutex_unlock(&encl->lock);
 	return ret;
 }
 
@@ -472,9 +458,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
  *   -ENOMEM if any memory allocation, including EPC, fails,
  *   -errno otherwise
  */
-static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
+static long sgx_ioc_enclave_add_page(struct sgx_encl *encl, void __user *arg)
 {
-	struct sgx_encl *encl = filep->private_data;
 	struct sgx_enclave_add_page addp;
 	struct sgx_secinfo secinfo;
 
@@ -602,9 +587,8 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
  *   SGX error code on EINIT failure,
  *   -errno otherwise
  */
-static long sgx_ioc_enclave_init(struct file *filep, void __user *arg)
+static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 {
-	struct sgx_encl *encl = filep->private_data;
 	struct sgx_einittoken *einittoken;
 	struct sgx_sigstruct *sigstruct;
 	struct sgx_enclave_init einit;
@@ -658,9 +642,9 @@ static long sgx_ioc_enclave_init(struct file *filep, void __user *arg)
  *
  * Return: 0 on success, -errno otherwise
  */
-static long sgx_ioc_enclave_set_attribute(struct file *filep, void __user *arg)
+static long sgx_ioc_enclave_set_attribute(struct sgx_encl *encl,
+					  void __user *arg)
 {
-	struct sgx_encl *encl = filep->private_data;
 	struct sgx_enclave_set_attribute params;
 	struct file *attribute_file;
 	int ret;
@@ -687,16 +671,31 @@ static long sgx_ioc_enclave_set_attribute(struct file *filep, void __user *arg)
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
+	struct sgx_encl *encl = filep->private_data;
+	int ret;
+
+	if (atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags) & SGX_ENCL_IOCTL)
+		return -EBUSY;
+
 	switch (cmd) {
 	case SGX_IOC_ENCLAVE_CREATE:
-		return sgx_ioc_enclave_create(filep, (void __user *)arg);
+		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
+		break;
 	case SGX_IOC_ENCLAVE_ADD_PAGE:
-		return sgx_ioc_enclave_add_page(filep, (void __user *)arg);
+		ret = sgx_ioc_enclave_add_page(encl, (void __user *)arg);
+		break;
 	case SGX_IOC_ENCLAVE_INIT:
-		return sgx_ioc_enclave_init(filep, (void __user *)arg);
+		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
+		break;
 	case SGX_IOC_ENCLAVE_SET_ATTRIBUTE:
-		return sgx_ioc_enclave_set_attribute(filep, (void __user *)arg);
+		ret = sgx_ioc_enclave_set_attribute(encl, (void __user *)arg);
+		break;
 	default:
-		return -ENOIOCTLCMD;
+		ret = -ENOIOCTLCMD;
+		break;
 	}
+
+	atomic_andnot(SGX_ENCL_IOCTL, &encl->flags);
+
+	return ret;
 }
-- 
2.22.0

