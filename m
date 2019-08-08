Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E37C32757
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 22:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E150321743
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 22:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404325AbfHHWNo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Aug 2019 18:13:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:19058 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404533AbfHHWNo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Aug 2019 18:13:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 15:13:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,363,1559545200"; 
   d="scan'208";a="193247273"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 08 Aug 2019 15:13:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v22 5/6] x86/sgx: Remove the EADD page worker
Date:   Thu,  8 Aug 2019 15:13:39 -0700
Message-Id: <20190808221340.29460-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808221340.29460-1-sean.j.christopherson@intel.com>
References: <20190808221340.29460-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove the work queue approach to adding pages to an enclave.  There
are several benefits to fully adding pages within the context of the
ioctl() call:

  - Simplifies the code base
  - Provides userspace with accurate error information, e.g. the ioctl()
    now fails if EPC allocation fails
  - Paves the way for passing the user's source page directly to EADD
    to eliminate the overhead of allocating a kernel page and copying
    the user data into said kernel page.

The downside to removing the worker is that applications with their own
scheduler, e.g. Go's M:N scheduler, can see a significant reduction in
throughput (10x or more) when building multiple enclaves in parallel,
e.g. in the Go case, spinning up several goroutines with each goroutine
building a different enclave.

Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 191 ++++++-------------------
 arch/x86/kernel/cpu/sgx/driver/main.c  |   4 -
 arch/x86/kernel/cpu/sgx/encl.h         |   2 -
 3 files changed, 40 insertions(+), 157 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 2d876429ba9a..e083625dcd15 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -14,14 +14,6 @@
 #include <linux/suspend.h>
 #include "driver.h"
 
-struct sgx_add_page_req {
-	struct sgx_encl *encl;
-	struct sgx_encl_page *encl_page;
-	struct sgx_secinfo secinfo;
-	unsigned long mrmask;
-	struct list_head list;
-};
-
 static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl,
 					 unsigned int disallowed_flags)
 {
@@ -77,115 +69,6 @@ static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
 	}
 }
 
-static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
-				     struct sgx_epc_page *epc_page)
-{
-	struct sgx_encl_page *encl_page = req->encl_page;
-	struct sgx_encl *encl = req->encl;
-	unsigned long page_index = sgx_encl_get_index(encl, encl_page);
-	struct sgx_secinfo secinfo;
-	struct sgx_pageinfo pginfo;
-	struct page *backing;
-	unsigned long addr;
-	int ret;
-	int i;
-
-	if (encl->flags &  SGX_ENCL_DEAD)
-		return false;
-
-	addr = SGX_ENCL_PAGE_ADDR(encl_page);
-
-	backing = sgx_encl_get_backing_page(encl, page_index);
-	if (IS_ERR(backing))
-		return false;
-
-	/*
-	 * The SECINFO field must be 64-byte aligned, copy it to a local
-	 * variable that is guaranteed to be aligned as req->secinfo may
-	 * or may not be 64-byte aligned, e.g. req may have been allocated
-	 * via kzalloc which is not aware of __aligned attributes.
-	 */
-	memcpy(&secinfo, &req->secinfo, sizeof(secinfo));
-
-	pginfo.secs = (unsigned long)sgx_epc_addr(encl->secs.epc_page);
-	pginfo.addr = addr;
-	pginfo.metadata = (unsigned long)&secinfo;
-	pginfo.contents = (unsigned long)kmap_atomic(backing);
-	ret = __eadd(&pginfo, sgx_epc_addr(epc_page));
-	kunmap_atomic((void *)(unsigned long)pginfo.contents);
-
-	put_page(backing);
-
-	if (ret) {
-		if (encls_failed(ret))
-			ENCLS_WARN(ret, "EADD");
-		return false;
-	}
-
-	for_each_set_bit(i, &req->mrmask, 16) {
-		ret = __eextend(sgx_epc_addr(encl->secs.epc_page),
-				sgx_epc_addr(epc_page) + (i * 0x100));
-		if (ret) {
-			if (encls_failed(ret))
-				ENCLS_WARN(ret, "EEXTEND");
-			return false;
-		}
-	}
-
-	encl_page->encl = encl;
-	encl_page->epc_page = epc_page;
-	encl->secs_child_cnt++;
-	sgx_mark_page_reclaimable(encl_page->epc_page);
-
-	return true;
-}
-
-static void sgx_add_page_worker(struct work_struct *work)
-{
-	struct sgx_add_page_req *req;
-	bool skip_rest = false;
-	bool is_empty = false;
-	struct sgx_encl *encl;
-	struct sgx_epc_page *epc_page;
-
-	encl = container_of(work, struct sgx_encl, work);
-
-	do {
-		schedule();
-
-		mutex_lock(&encl->lock);
-		if (encl->flags & SGX_ENCL_DEAD)
-			skip_rest = true;
-
-		req = list_first_entry(&encl->add_page_reqs,
-				       struct sgx_add_page_req, list);
-		list_del(&req->list);
-		is_empty = list_empty(&encl->add_page_reqs);
-		mutex_unlock(&encl->lock);
-
-		if (skip_rest)
-			goto next;
-
-		epc_page = sgx_alloc_page(req->encl_page, true);
-
-		mutex_lock(&encl->lock);
-
-		if (IS_ERR(epc_page)) {
-			sgx_encl_destroy(encl);
-			skip_rest = true;
-		} else if (!sgx_process_add_page_req(req, epc_page)) {
-			sgx_free_page(epc_page);
-			sgx_encl_destroy(encl);
-			skip_rest = true;
-		}
-
-		mutex_unlock(&encl->lock);
-
-next:
-		kfree(req);
-	} while (!is_empty);
-}
-
 static u32 sgx_calc_ssaframesize(u32 miscselect, u64 xfrm)
 {
 	u32 size_max = PAGE_SIZE;
@@ -298,8 +181,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 
 	encl->backing = backing;
 
-	INIT_WORK(&encl->work, sgx_add_page_worker);
-
 	secs_epc = sgx_alloc_page(&encl->secs, true);
 	if (IS_ERR(secs_epc)) {
 		ret = PTR_ERR(secs_epc);
@@ -465,40 +346,42 @@ static int sgx_validate_tcs(struct sgx_encl *encl, struct sgx_tcs *tcs)
 
 static int __sgx_encl_add_page(struct sgx_encl *encl,
 			       struct sgx_encl_page *encl_page,
+			       struct sgx_epc_page *epc_page,
 			       void *data,
 			       struct sgx_secinfo *secinfo,
-			       unsigned int mrmask)
+			       unsigned long mrmask)
 {
-	unsigned long page_index = sgx_encl_get_index(encl, encl_page);
-	struct sgx_add_page_req *req = NULL;
-	struct page *backing;
-	void *backing_ptr;
-	int empty;
+	struct sgx_pageinfo pginfo;
+	int ret;
+	int i;
 
-	req = kzalloc(sizeof(*req), GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
+	pginfo.secs = (unsigned long)sgx_epc_addr(encl->secs.epc_page);
+	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
+	pginfo.metadata = (unsigned long)secinfo;
+	pginfo.contents = (unsigned long)data;
 
-	backing = sgx_encl_get_backing_page(encl, page_index);
-	if (IS_ERR(backing)) {
-		kfree(req);
-		return PTR_ERR(backing);
+	ret = __eadd(&pginfo, sgx_epc_addr(epc_page));
+	if (ret) {
+		if (encls_failed(ret))
+			ENCLS_WARN(ret, "EADD");
+		return -EFAULT;
 	}
 
-	backing_ptr = kmap(backing);
-	memcpy(backing_ptr, data, PAGE_SIZE);
-	kunmap(backing);
+	for_each_set_bit(i, &mrmask, 16) {
+		ret = __eextend(sgx_epc_addr(encl->secs.epc_page),
+				sgx_epc_addr(epc_page) + (i * 0x100));
+		if (ret) {
+			if (encls_failed(ret))
+				ENCLS_WARN(ret, "EEXTEND");
+			return -EFAULT;
+		}
+	}
+
+	encl_page->encl = encl;
+	encl_page->epc_page = epc_page;
+	encl->secs_child_cnt++;
+	sgx_mark_page_reclaimable(encl_page->epc_page);
 
-	memcpy(&req->secinfo, secinfo, sizeof(*secinfo));
-	req->encl = encl;
-	req->encl_page = encl_page;
-	req->mrmask = mrmask;
-	empty = list_empty(&encl->add_page_reqs);
-	list_add_tail(&req->list, &encl->add_page_reqs);
-	if (empty)
-		queue_work(sgx_encl_wq, &encl->work);
-	set_page_dirty(backing);
-	put_page(backing);
 	return 0;
 }
 
@@ -508,6 +391,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 {
 	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
 	struct sgx_encl_page *encl_page;
+	struct sgx_epc_page *epc_page;
 	struct sgx_va_page *va_page;
 	int ret;
 
@@ -521,6 +405,12 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	if (IS_ERR(encl_page))
 		return PTR_ERR(encl_page);
 
+	epc_page = sgx_alloc_page(encl_page, true);
+	if (IS_ERR(epc_page)) {
+		kfree(encl_page);
+		return PTR_ERR(epc_page);
+	}
+
 	mutex_lock(&encl->lock);
 
 	va_page = sgx_encl_grow(encl, SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD);
@@ -534,7 +424,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	if (ret)
 		goto err_out_shrink;
 
-	ret = __sgx_encl_add_page(encl, encl_page, data, secinfo, mrmask);
+	ret = __sgx_encl_add_page(encl, encl_page, epc_page, data, secinfo,
+				  mrmask);
 	if (ret)
 		goto err_out;
 
@@ -548,6 +439,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	sgx_encl_shrink(encl, va_page);
 
 err_out_free:
+	sgx_free_page(epc_page);
 	kfree(encl_page);
 
 	mutex_unlock(&encl->lock);
@@ -591,14 +483,13 @@ static int sgx_encl_page_import_user(void *dst, unsigned long src,
  * @arg:	a user pointer to a struct sgx_enclave_add_page instance
  *
  * Add a page to an uninitialized enclave (EADD), and optionally extend the
- * enclave's measurement with the contents of the page (EEXTEND). Adding is done
- * asynchronously. A success only indicates that the page has been added to a
- * work queue.
+ * enclave's measurement with the contents of the page (EEXTEND).
  *
  * Return:
  *   0 on success,
  *   -EINVAL if other than RWX protection bits have been set
  *   -EACCES if the source page is located in a noexec partition
+ *   -ENOMEM if any memory allocation, including EPC, fails
  *   -errno otherwise
  */
 static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
@@ -701,8 +592,6 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 	if (ret)
 		return ret;
 
-	flush_work(&encl->work);
-
 	mutex_lock(&encl->lock);
 
 	if (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index dfa107247f2d..e740d71e2311 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -32,7 +32,6 @@ static int sgx_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	kref_init(&encl->refcount);
-	INIT_LIST_HEAD(&encl->add_page_reqs);
 	INIT_LIST_HEAD(&encl->va_pages);
 	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
 	mutex_init(&encl->lock);
@@ -81,9 +80,6 @@ static int sgx_release(struct inode *inode, struct file *file)
 	encl->flags |= SGX_ENCL_DEAD;
 	mutex_unlock(&encl->lock);
 
-	if (encl->work.func)
-		flush_work(&encl->work);
-
 	kref_put(&encl->refcount, sgx_encl_release);
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 379fe4c22b5d..79885aae8869 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -81,8 +81,6 @@ struct sgx_encl {
 	unsigned long ssaframesize;
 	struct list_head va_pages;
 	struct radix_tree_root page_tree;
-	struct list_head add_page_reqs;
-	struct work_struct work;
 	struct sgx_encl_page secs;
 	cpumask_t cpumask;
 };
-- 
2.22.0

