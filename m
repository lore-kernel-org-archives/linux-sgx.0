Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31F3C3A5A7
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 00:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89A1A2173E
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 00:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfH0ANb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 20:13:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:1582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727563AbfH0ANb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 20:13:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 17:11:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,435,1559545200"; 
   d="scan'208";a="171021245"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 26 Aug 2019 17:11:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH 3/4] x86/sgx: Reject concurrent ioctls on single enclave
Date:   Mon, 26 Aug 2019 17:11:27 -0700
Message-Id: <20190827001128.25066-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827001128.25066-1-sean.j.christopherson@intel.com>
References: <20190827001128.25066-1-sean.j.christopherson@intel.com>
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
value.  The race could also be fixed by taking encl->lock, but that
is less desirable as doing so would unnecessarily interfere with EPC
page reclaim.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c |  1 +
 arch/x86/kernel/cpu/sgx/encl.h   |  1 +
 arch/x86/kernel/cpu/sgx/ioctl.c  | 91 ++++++++++++++------------------
 3 files changed, 43 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index e740d71e2311..7ebd66050400 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -32,6 +32,7 @@ static int sgx_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	kref_init(&encl->refcount);
+	atomic_set(&encl->in_ioctl, 0);
 	INIT_LIST_HEAD(&encl->va_pages);
 	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
 	mutex_init(&encl->lock);
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 37b5c4bcda7a..1505ff204703 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -67,6 +67,7 @@ struct sgx_encl_mm {
 };
 
 struct sgx_encl {
+	atomic_t in_ioctl;
 	unsigned int flags;
 	u64 secs_attributes;
 	u64 allowed_attributes;
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 103851babc75..170ed538b02b 100644
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
@@ -23,36 +22,20 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl,
 	BUILD_BUG_ON(SGX_VA_SLOT_COUNT !=
 		(SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
 
-	if (encl->flags & disallowed_flags)
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
-		} else if (encl->flags & disallowed_flags) {
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
+		list_add(&va_page->list, &encl->va_pages);
 	}
 	encl->page_cnt++;
 	return va_page;
@@ -183,13 +166,12 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	struct file *backing;
 	long ret;
 
-	mutex_lock(&encl->lock);
+	if (is_encl_created(encl))
+		return -EINVAL;
 
-	va_page = sgx_encl_grow(encl, SGX_ENCL_CREATED | SGX_ENCL_DEAD);
-	if (IS_ERR(va_page)) {
-		ret = PTR_ERR(va_page);
-		goto err_out_unlock;
-	}
+	va_page = sgx_encl_grow(encl);
+	if (IS_ERR(va_page))
+		return PTR_ERR(va_page);
 
 	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);
 	if (sgx_validate_secs(secs, ssaframesize)) {
@@ -239,13 +221,12 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 
 	/*
 	 * Set SGX_ENCL_CREATED only after the enclave is fully prepped.  This
-	 * allows other flows to check if the enclave has been created without
-	 * taking encl->lock.  Pairs with smp_rmb() in is_encl_created().
+	 * allows setting and checking enclave creation without having to take
+	 * encl->lock.  Pairs with smp_rmb() in is_encl_created().
 	 */
 	smp_wmb();
 	encl->flags |= SGX_ENCL_CREATED;
 
-	mutex_unlock(&encl->lock);
 	return 0;
 
 err_out:
@@ -259,8 +240,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 err_out_shrink:
 	sgx_encl_shrink(encl, va_page);
 
-err_out_unlock:
-	mutex_unlock(&encl->lock);
 	return ret;
 }
 
@@ -280,9 +259,8 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
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
@@ -414,14 +392,14 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
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
 	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
 				encl_page);
 	if (ret)
@@ -440,13 +418,13 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 			  PFN_DOWN(encl_page->desc));
 
 err_out_shrink:
+	mutex_unlock(&encl->lock);
 	sgx_encl_shrink(encl, va_page);
 
 err_out_free:
 	sgx_free_page(epc_page);
 	kfree(encl_page);
 
-	mutex_unlock(&encl->lock);
 	return ret;
 }
 
@@ -482,9 +460,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
  *   -ENOMEM if any memory allocation, including EPC, fails,
  *   -errno otherwise
  */
-static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
+static long sgx_ioc_enclave_add_page(struct sgx_encl *encl, void __user *arg)
 {
-	struct sgx_encl *encl = filep->private_data;
 	struct sgx_enclave_add_page addp;
 	struct sgx_secinfo secinfo;
 
@@ -612,9 +589,8 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
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
@@ -668,9 +644,9 @@ static long sgx_ioc_enclave_init(struct file *filep, void __user *arg)
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
@@ -697,16 +673,31 @@ static long sgx_ioc_enclave_set_attribute(struct file *filep, void __user *arg)
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
+	struct sgx_encl *encl = filep->private_data;
+	int ret;
+
+	if (!atomic_add_unless(&encl->in_ioctl, 1, 1))
+		return -EINVAL;
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
+	atomic_dec(&encl->in_ioctl);
+
+	return ret;
 }
-- 
2.22.0

