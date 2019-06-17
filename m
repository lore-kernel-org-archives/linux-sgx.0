Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E888C31E5C
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 544DC2085A
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfFQWYt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:24:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:43046 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbfFQWYt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jun 2019 18:24:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:24:47 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 17 Jun 2019 15:24:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: [RFC PATCH v3 01/12] x86/sgx: Add mm to enclave at mmap()
Date:   Mon, 17 Jun 2019 15:24:27 -0700
Message-Id: <20190617222438.2080-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617222438.2080-1-sean.j.christopherson@intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The enclave mm tracking is currently broken:

  - Adding current->mm during ECREATE is wrong as there is no guarantee
    that the current process has mmap()'d the enclave, i.e. there may
    never be an associated sgx_vma_close() to drop the encl_mm.

  - Adding mm's at sgx_vma_open() is wrong as vm_ops->open is called
    only when splitting or duplicating a vma.  If userspace performs a
    single mmap() on the enclave then SGX will fail to track the mm.
    This bug is partially hidden by tracking current->mm at ECREATE.

Rework the tracking to get/add the mm at mmap().  A side effect of the
bug fix is that sgx_vma_{open,close}() should never encounter a vma with
an associated enclave and no associated encl_mm, i.e. WARN if an encl_mm
cannot be found in either condition.

Change the WARN() on a non-empty mm_list to a WARN_ONCE().  The warning
will fire over and over (and over) if the mm tracking is broken, which
hampers debug/triage far more than it helps.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 14 ----------
 arch/x86/kernel/cpu/sgx/driver/main.c  | 26 ++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.c         | 38 +++++---------------------
 arch/x86/kernel/cpu/sgx/encl.h         |  4 +--
 4 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index d17c60dca114..3552d642b26f 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -276,7 +276,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 {
 	unsigned long encl_size = secs->size + PAGE_SIZE;
 	struct sgx_epc_page *secs_epc;
-	struct sgx_encl_mm *encl_mm;
 	unsigned long ssaframesize;
 	struct sgx_pageinfo pginfo;
 	struct sgx_secinfo secinfo;
@@ -311,12 +310,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 
 	INIT_WORK(&encl->work, sgx_add_page_worker);
 
-	encl_mm = sgx_encl_mm_add(encl, current->mm);
-	if (IS_ERR(encl_mm)) {
-		ret = PTR_ERR(encl_mm);
-		goto err_out;
-	}
-
 	secs_epc = sgx_alloc_page(&encl->secs, true);
 	if (IS_ERR(secs_epc)) {
 		ret = PTR_ERR(secs_epc);
@@ -369,13 +362,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 		encl->backing = NULL;
 	}
 
-	if (!list_empty(&encl->mm_list)) {
-		encl_mm = list_first_entry(&encl->mm_list, struct sgx_encl_mm,
-					   list);
-		list_del(&encl_mm->list);
-		kfree(encl_mm);
-	}
-
 	mutex_unlock(&encl->lock);
 	return ret;
 }
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 87735ce8b5ba..03eca4bccee1 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -60,9 +60,35 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
 }
 #endif
 
+static int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
+{
+	struct sgx_encl_mm *encl_mm;
+
+	encl_mm = kzalloc(sizeof(*encl_mm), GFP_KERNEL);
+	if (!encl_mm)
+		return -ENOMEM;
+
+	encl_mm->encl = encl;
+	encl_mm->mm = mm;
+	kref_init(&encl_mm->refcount);
+
+	spin_lock(&encl->mm_lock);
+	list_add(&encl_mm->list, &encl->mm_list);
+	spin_unlock(&encl->mm_lock);
+
+	return 0;
+}
+
 static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct sgx_encl *encl = file->private_data;
+	int ret;
+
+	if (!sgx_encl_get_mm(encl, vma->vm_mm)) {
+		ret = sgx_encl_mm_add(encl, vma->vm_mm);
+		if (ret)
+			return ret;
+	}
 
 	vma->vm_ops = &sgx_vm_ops;
 	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 6b190eccd02e..6e9f3a41a40d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -132,26 +132,6 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 	return entry;
 }
 
-struct sgx_encl_mm *sgx_encl_mm_add(struct sgx_encl *encl,
-				    struct mm_struct *mm)
-{
-	struct sgx_encl_mm *encl_mm;
-
-	encl_mm = kzalloc(sizeof(*encl_mm), GFP_KERNEL);
-	if (!encl_mm)
-		return ERR_PTR(-ENOMEM);
-
-	encl_mm->encl = encl;
-	encl_mm->mm = mm;
-	kref_init(&encl_mm->refcount);
-
-	spin_lock(&encl->mm_lock);
-	list_add(&encl_mm->list, &encl->mm_list);
-	spin_unlock(&encl->mm_lock);
-
-	return encl_mm;
-}
-
 void sgx_encl_mm_release(struct kref *ref)
 {
 	struct sgx_encl_mm *encl_mm =
@@ -164,8 +144,8 @@ void sgx_encl_mm_release(struct kref *ref)
 	kfree(encl_mm);
 }
 
-static struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
-					   struct mm_struct *mm)
+struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
+				    struct mm_struct *mm)
 {
 	struct sgx_encl_mm *encl_mm = NULL;
 	struct sgx_encl_mm *prev_mm = NULL;
@@ -190,10 +170,10 @@ static struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
 	return NULL;
 }
 
+
 static void sgx_vma_open(struct vm_area_struct *vma)
 {
 	struct sgx_encl *encl = vma->vm_private_data;
-	struct sgx_encl_mm *encl_mm;
 
 	if (!encl)
 		return;
@@ -201,12 +181,8 @@ static void sgx_vma_open(struct vm_area_struct *vma)
 	if (encl->flags & SGX_ENCL_DEAD)
 		goto error;
 
-	encl_mm = sgx_encl_get_mm(encl, vma->vm_mm);
-	if (!encl_mm) {
-		encl_mm = sgx_encl_mm_add(encl, vma->vm_mm);
-		if (IS_ERR(encl_mm))
-			goto error;
-	}
+	if (WARN_ON_ONCE(!sgx_encl_get_mm(encl, vma->vm_mm)))
+		goto error;
 
 	kref_get(&encl->refcount);
 	return;
@@ -224,7 +200,7 @@ static void sgx_vma_close(struct vm_area_struct *vma)
 		return;
 
 	encl_mm = sgx_encl_get_mm(encl, vma->vm_mm);
-	if (encl_mm) {
+	if (!WARN_ON_ONCE(!encl_mm)) {
 		kref_put(&encl_mm->refcount, sgx_encl_mm_release);
 
 		/* Release kref for the VMA. */
@@ -468,7 +444,7 @@ void sgx_encl_release(struct kref *ref)
 	if (encl->backing)
 		fput(encl->backing);
 
-	WARN(!list_empty(&encl->mm_list), "sgx: mm_list non-empty");
+	WARN_ONCE(!list_empty(&encl->mm_list), "sgx: mm_list non-empty");
 
 	kfree(encl);
 }
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index c557f0374d74..7b339334d875 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -120,9 +120,9 @@ pgoff_t sgx_encl_get_index(struct sgx_encl *encl, struct sgx_encl_page *page);
 struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index);
 struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
 				     struct sgx_encl_mm *encl_mm, int *iter);
-struct sgx_encl_mm *sgx_encl_mm_add(struct sgx_encl *encl,
-				    struct mm_struct *mm);
 void sgx_encl_mm_release(struct kref *ref);
+struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
+				    struct mm_struct *mm);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
 struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
-- 
2.21.0

