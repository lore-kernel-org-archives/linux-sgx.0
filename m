Return-Path: <SRS0=mvcT=W2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E7DC3A5A6
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Aug 2019 00:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35B7C2173E
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Aug 2019 00:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfH3ARJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:17:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:30403 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfH3ARI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 20:17:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 17:17:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="205917816"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 29 Aug 2019 17:17:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH v3 1/5] x86/sgx: Convert encl->flags from an unsigned int to an atomic
Date:   Thu, 29 Aug 2019 17:17:02 -0700
Message-Id: <20190830001706.29309-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190830001706.29309-1-sean.j.christopherson@intel.com>
References: <20190830001706.29309-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Make encl->flags an atomic to ensure that all enclave state is visible
in memory prior to SGX_ENCL_CREATED being set.  Without a compiler
memory barrier, adding pages and or initializing the enclave could
theoretically consume stale data.

Alternatively, a smp_wmb() + smp_rmb() could be added specifically for
SGX_ENCL_CREATED, but making flags an atomic allows future patches to
introduce similar checks, e.g. to force serialize ioctls, and the
downsides to using an atomic are negligible, e.g. locked transactions
are only introduced in slow paths since most flows can use atomic_read()
to query flags.

Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c  |  3 ++-
 arch/x86/kernel/cpu/sgx/encl.c    | 18 +++++++++++-------
 arch/x86/kernel/cpu/sgx/encl.h    |  2 +-
 arch/x86/kernel/cpu/sgx/ioctl.c   | 16 ++++++++--------
 arch/x86/kernel/cpu/sgx/reclaim.c | 10 +++++-----
 5 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index e740d71e2311..a1da479ffd3a 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -31,6 +31,7 @@ static int sgx_open(struct inode *inode, struct file *file)
 	if (!encl)
 		return -ENOMEM;
 
+	atomic_set(&encl->flags, 0);
 	kref_init(&encl->refcount);
 	INIT_LIST_HEAD(&encl->va_pages);
 	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
@@ -77,7 +78,7 @@ static int sgx_release(struct inode *inode, struct file *file)
 	};
 
 	mutex_lock(&encl->lock);
-	encl->flags |= SGX_ENCL_DEAD;
+	atomic_or(SGX_ENCL_DEAD, &encl->flags);
 	mutex_unlock(&encl->lock);
 
 	kref_put(&encl->refcount, sgx_encl_release);
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 08ca0cfb1742..b6cd2a800eb2 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -107,6 +107,7 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 {
 	struct sgx_epc_page *epc_page;
 	struct sgx_encl_page *entry;
+	unsigned int encl_flags;
 
 	/* If process was forked, VMA is still there but vm_private_data is set
 	 * to NULL.
@@ -114,8 +115,9 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 	if (!encl)
 		return ERR_PTR(-EFAULT);
 
-	if ((encl->flags & SGX_ENCL_DEAD) ||
-	    !(encl->flags & SGX_ENCL_INITIALIZED))
+	encl_flags = atomic_read(&encl->flags);
+	if ((encl_flags & SGX_ENCL_DEAD) ||
+	    !(encl_flags & SGX_ENCL_INITIALIZED))
 		return ERR_PTR(-EFAULT);
 
 	entry = radix_tree_lookup(&encl->page_tree, addr >> PAGE_SHIFT);
@@ -217,7 +219,7 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 	struct sgx_encl_mm *encl_mm;
 	int ret;
 
-	if (encl->flags & SGX_ENCL_DEAD)
+	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD)
 		return -EINVAL;
 
 	/*
@@ -395,6 +397,7 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
 	struct sgx_encl_page *entry = NULL;
 	unsigned long align;
 	char data[sizeof(unsigned long)];
+	unsigned int encl_flags;
 	int offset;
 	int cnt;
 	int ret = 0;
@@ -406,9 +409,10 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
 	if (!encl)
 		return -EFAULT;
 
-	if (!(encl->flags & SGX_ENCL_DEBUG) ||
-	    !(encl->flags & SGX_ENCL_INITIALIZED) ||
-	    (encl->flags & SGX_ENCL_DEAD))
+	encl_flags = atomic_read(&encl->flags);
+	if (!(encl_flags & SGX_ENCL_DEBUG) ||
+	    !(encl_flags & SGX_ENCL_INITIALIZED) ||
+	    (encl_flags & SGX_ENCL_DEAD))
 		return -EFAULT;
 
 	for (i = 0; i < len; i += cnt) {
@@ -495,7 +499,7 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 	struct radix_tree_iter iter;
 	void **slot;
 
-	encl->flags |= SGX_ENCL_DEAD;
+	atomic_or(SGX_ENCL_DEAD, &encl->flags);
 
 	radix_tree_for_each_slot(slot, &encl->page_tree, &iter, 0) {
 		entry = *slot;
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 37b5c4bcda7a..ffc09e1a0fc6 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -67,7 +67,7 @@ struct sgx_encl_mm {
 };
 
 struct sgx_encl {
-	unsigned int flags;
+	atomic_t flags;
 	u64 secs_attributes;
 	u64 allowed_attributes;
 	unsigned int page_cnt;
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 1740eca4f163..d05cf051ca45 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -23,7 +23,7 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl,
 	BUILD_BUG_ON(SGX_VA_SLOT_COUNT !=
 		(SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
 
-	if (encl->flags & disallowed_flags)
+	if (atomic_read(&encl->flags) & disallowed_flags)
 		return ERR_PTR(-EFAULT);
 
 	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT)) {
@@ -42,7 +42,7 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl,
 			err = ERR_CAST(va_page->epc_page);
 			kfree(va_page);
 			return err;
-		} else if (encl->flags & disallowed_flags) {
+		} else if (atomic_read(&encl->flags) & disallowed_flags) {
 			sgx_free_page(va_page->epc_page);
 			kfree(va_page);
 			return ERR_PTR(-EFAULT);
@@ -219,7 +219,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	}
 
 	if (secs->attributes & SGX_ATTR_DEBUG)
-		encl->flags |= SGX_ENCL_DEBUG;
+		atomic_or(SGX_ENCL_DEBUG, &encl->flags);
 
 	encl->secs.encl = encl;
 	encl->secs_attributes = secs->attributes;
@@ -233,7 +233,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	 * allows other flows to check if the enclave has been created without
 	 * taking encl->lock.
 	 */
-	encl->flags |= SGX_ENCL_CREATED;
+	atomic_or(SGX_ENCL_CREATED, &encl->flags);
 
 	mutex_unlock(&encl->lock);
 	return 0;
@@ -478,7 +478,7 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 	struct sgx_enclave_add_page addp;
 	struct sgx_secinfo secinfo;
 
-	if (!(encl->flags & SGX_ENCL_CREATED))
+	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
 		return -EINVAL;
 
 	if (copy_from_user(&addp, arg, sizeof(addp)))
@@ -544,7 +544,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 	mutex_lock(&encl->lock);
 
-	if (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
+	if (atomic_read(&encl->flags) & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
 		ret = -EFAULT;
 		goto err_out;
 	}
@@ -579,7 +579,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 	} else if (encls_returned_code(ret)) {
 		pr_debug("EINIT returned %d\n", ret);
 	} else {
-		encl->flags |= SGX_ENCL_INITIALIZED;
+		atomic_or(SGX_ENCL_INITIALIZED, &encl->flags);
 	}
 
 err_out:
@@ -611,7 +611,7 @@ static long sgx_ioc_enclave_init(struct file *filep, void __user *arg)
 	struct page *initp_page;
 	int ret;
 
-	if (!(encl->flags & SGX_ENCL_CREATED))
+	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
 		return -EINVAL;
 
 	if (copy_from_user(&einit, arg, sizeof(einit)))
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 3f10a8ff00b7..e7a559c41f86 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -156,7 +156,7 @@ static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
 
 		mmput_async(encl_mm->mm);
 
-		if (!ret || (encl->flags & SGX_ENCL_DEAD))
+		if (!ret || (atomic_read(&encl->flags) & SGX_ENCL_DEAD))
 			break;
 	}
 
@@ -170,7 +170,7 @@ static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
 	 * accessed page is more common and avoiding lock contention in that
 	 * case is a boon to performance.
 	 */
-	if (!ret && !(encl->flags & SGX_ENCL_DEAD))
+	if (!ret && !(atomic_read(&encl->flags) & SGX_ENCL_DEAD))
 		return false;
 
 	mutex_lock(&encl->lock);
@@ -210,7 +210,7 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 
 	mutex_lock(&encl->lock);
 
-	if (!(encl->flags & SGX_ENCL_DEAD)) {
+	if (!(atomic_read(&encl->flags) & SGX_ENCL_DEAD)) {
 		ret = __eblock(sgx_epc_addr(epc_page));
 		if (encls_failed(ret))
 			ENCLS_WARN(ret, "EBLOCK");
@@ -314,7 +314,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, unsigned int pt)
 
 	encl_page->desc &= ~SGX_ENCL_PAGE_RECLAIMED;
 
-	if (!(encl->flags & SGX_ENCL_DEAD)) {
+	if (!(atomic_read(&encl->flags) & SGX_ENCL_DEAD)) {
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		va_offset = sgx_alloc_va_slot(va_page);
@@ -383,7 +383,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
 	encl->secs_child_cnt--;
 
 	if (!encl->secs_child_cnt &&
-	    (encl->flags & (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED)))
+	    (atomic_read(&encl->flags) & (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED)))
 		sgx_encl_ewb(encl->secs.epc_page, SGX_SECINFO_SECS);
 
 	mutex_unlock(&encl->lock);
-- 
2.22.0

