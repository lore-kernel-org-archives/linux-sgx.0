Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061C5C74A5E
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA0792084B
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfGKQQ2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 12:16:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:37842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbfGKQQ2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 12:16:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 09:16:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="177213536"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga002.jf.intel.com with ESMTP; 11 Jul 2019 09:16:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v21 1/2] x86/sgx: Use SRCU to protect mm_list during reclaim
Date:   Thu, 11 Jul 2019 09:16:24 -0700
Message-Id: <20190711161625.15786-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190711161625.15786-1-sean.j.christopherson@intel.com>
References: <20190711161625.15786-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Reclaiming enclaves faces a bit of a conundrum when it comes to lock
ordering.  The reclaim flows need to take mmap_sem for read, e.g. to age
and zap PTEs on arbitrary mm_structs.  But reclaim must first walk the
enclave's list of mm_structs, which could be modified asynchronously to
reclaim.  Because modifying the list of mm_structs is done in reaction
to vma changes, i.e. with mmap_sem held exclusively, taking enclave's
mm_lock to protect the list walk in reclaim would lead to deadlocks due
to conflicting lock ordering.  To avoid this, SGX currently uses a
custom walker that drops mm_lock and restarts the walk as needed.

Use SRCU to protect reclaim instead of using a custom walker to avoid
the aforementioned lock issues.  Using SRCU improves readability in the
reclaimer by eliminating the need to juggle mm_lock during reclaim since
it can take mmap_sem() underneath srcu_read_lock().  And since relcaim
doesn't drop its SRCU read lock, there is no need to grab a reference to
encl_mm.

Not taking a reference to encl_mm is not just an optimization, it's also
functionally necessary and a major motivation to moving to SRCu. Putting
the reference can invoke sgx_encl_mm_release(), which calls
synchronize_srcu() and will deadlock if done while holding the SRCU read
lock.  Not taking a reference paves the way for additional refcounting
improvements that would be extremely difficult to implement when using
the custom walker due to cyclical dependencies on the refcount.

Speaking of sgx_encl_mm_release(), the whole purpose of using SRCU is
that sgx_encl_mm_release() is blocked (if called on another cpu) by
synchronize_srcu(), which in turn prevents mmdrop() from freeing the
mm_struct while reclaim is in the SRCU critical section.  Ultimately,
reclaim just needs to ensure mm_struct isn't freed so that it can call
mmget_not_zero() to prevent the page tables from being dropped while it
accesses PTEs, i.e. it doesn't matter if the encl_mm is dying, reclaim
just needs to make sure it's not fully dead.

To avoid calling synchronize_rcu() while holding rcu_read_lock(), use
mmput_async() in the reclaimer, e.g. __mmput() closes all VMAs, thus
triggering sgx_encl_mm_release() and synchronize_srcu().  Alternatively
sgx_encl_mm_release() could always call synchronize_rcu() in a worker
thread (see below), but doing __mmput() in a worker thread is desirable
from an SGX performance perspective, i.e. doesn't stall the reclaimer
CPU to release the mm.

And finally, the last deadlock scenario is if sgx_encl_mm_release() is
invoked on an in-use mm_struct, e.g. via munmap().

CPU0                     CPU1
munmap()
down_write(&mmap_sem)
                         srcu_read_lock()

synchronize_srcu()
                         down_read(&mmap_sem) <- deadlock

Avoid deadlock in this scenario by synchronizing SRCU via a worker
thread.  SRCU ensures only the liveliness of the mm_struct itself,
which is guaranteed by an mmgrab() prior to scheduling the work.
The reclaimer is responsible for checking mm_users and the VMAs to
ensure it doesn't touch stale PTEs, i.e. delaying synchronization does
not affect the reclaimer's responsiblities.  The delay does add one new
wrinkle in that sgx_encl_mm_add() and sgx_vma_open() can see a dying
encl_mm.  Previously this was prevented by virtue of sgx_vma_close()
being mutually exclusive (the caller must hold down_write(&mmap_sem)).
Handle such a case by using kref_get_unless_zero().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/Kconfig                      |   1 +
 arch/x86/kernel/cpu/sgx/driver/main.c |  34 ++----
 arch/x86/kernel/cpu/sgx/encl.c        | 165 ++++++++++++++------------
 arch/x86/kernel/cpu/sgx/encl.h        |   9 +-
 arch/x86/kernel/cpu/sgx/reclaim.c     |  71 ++++-------
 5 files changed, 124 insertions(+), 156 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a0fd17c32521..17558cf48a8a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1918,6 +1918,7 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 config INTEL_SGX
 	bool "Intel SGX core functionality"
 	depends on X86_64 && CPU_SUP_INTEL
+	select SRCU
 	---help---
 	  Intel(R) SGX is a set of CPU instructions that can be used by
 	  applications to set aside private regions of code and data, referred
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index c7fc32e26105..27076754f7d8 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -25,6 +25,7 @@ u32 sgx_xsave_size_tbl[64];
 static int sgx_open(struct inode *inode, struct file *file)
 {
 	struct sgx_encl *encl;
+	int ret;
 
 	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
 	if (!encl)
@@ -38,6 +39,12 @@ static int sgx_open(struct inode *inode, struct file *file)
 	INIT_LIST_HEAD(&encl->mm_list);
 	spin_lock_init(&encl->mm_lock);
 
+	ret = init_srcu_struct(&encl->srcu);
+	if (ret) {
+		kfree(encl);
+		return ret;
+	}
+
 	file->private_data = encl;
 
 	return 0;
@@ -65,25 +72,6 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
 }
 #endif
 
-static int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
-{
-	struct sgx_encl_mm *encl_mm;
-
-	encl_mm = kzalloc(sizeof(*encl_mm), GFP_KERNEL);
-	if (!encl_mm)
-		return -ENOMEM;
-
-	encl_mm->encl = encl;
-	encl_mm->mm = mm;
-	kref_init(&encl_mm->refcount);
-
-	spin_lock(&encl->mm_lock);
-	list_add(&encl_mm->list, &encl->mm_list);
-	spin_unlock(&encl->mm_lock);
-
-	return 0;
-}
-
 /**
  * sgx_calc_vma_prot() - Calculate VMA prot bits
  * @encl:	an enclave
@@ -129,11 +117,9 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC) & ~vm_prot_bits)
 		return -EACCES;
 
-	if (!sgx_encl_get_mm(encl, vma->vm_mm)) {
-		ret = sgx_encl_mm_add(encl, vma->vm_mm);
-		if (ret)
-			return ret;
-	}
+	ret = sgx_encl_mm_add(encl, vma->vm_mm);
+	if (ret)
+		return ret;
 
 	if (!(vm_prot_bits & VM_READ))
 		vma->vm_flags &= ~VM_MAYREAD;
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 853ea8ef3ada..64ae7d705eb1 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -132,62 +132,116 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 	return entry;
 }
 
-void sgx_encl_mm_release(struct kref *ref)
+static void sgx_encl_mm_release_deferred(struct work_struct *work)
+{
+	struct sgx_encl_mm *encl_mm =
+		container_of(work, struct sgx_encl_mm, release_work);
+
+	mmdrop(encl_mm->mm);
+	synchronize_srcu(&encl_mm->encl->srcu);
+	kfree(encl_mm);
+}
+
+static void sgx_encl_mm_release(struct kref *ref)
 {
 	struct sgx_encl_mm *encl_mm =
 		container_of(ref, struct sgx_encl_mm, refcount);
 
 	spin_lock(&encl_mm->encl->mm_lock);
-	list_del(&encl_mm->list);
+	list_del_rcu(&encl_mm->list);
 	spin_unlock(&encl_mm->encl->mm_lock);
 
-	kfree(encl_mm);
+	/*
+	 * If the mm has users, then do SRCU synchronization in a worker thread
+	 * to avoid a deadlock with the reclaimer.  The caller holds mmap_sem
+	 * for write, while the reclaimer will acquire mmap_sem for read if it
+	 * is reclaiming from this enclave.  Invoking synchronize_srcu() here
+	 * will hang waiting for the reclaimer to drop its RCU read lock, while
+	 * the reclaimer will get stuck waiting to acquire mmap_sem.  The async
+	 * shenanigans can be avoided if there are no mm users as the reclaimer
+	 * will not acquire mmap_sem in that case.
+	 */
+	if (atomic_read(&encl_mm->mm->mm_users)) {
+		mmgrab(encl_mm->mm);
+		INIT_WORK(&encl_mm->release_work, sgx_encl_mm_release_deferred);
+		schedule_work(&encl_mm->release_work);
+	} else {
+		synchronize_srcu(&encl_mm->encl->srcu);
+		kfree(encl_mm);
+	}
 }
 
-struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
-				    struct mm_struct *mm)
+static struct sgx_encl_mm *sgx_encl_find_mm(struct sgx_encl *encl,
+					    struct mm_struct *mm)
 {
 	struct sgx_encl_mm *encl_mm = NULL;
-	struct sgx_encl_mm *prev_mm = NULL;
-	int iter;
+	struct sgx_encl_mm *tmp;
+	int idx;
 
-	while (true) {
-		encl_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
-		if (prev_mm)
-			kref_put(&prev_mm->refcount, sgx_encl_mm_release);
-		prev_mm = encl_mm;
+	idx = srcu_read_lock(&encl->srcu);
 
-		if (iter == SGX_ENCL_MM_ITER_DONE)
+	list_for_each_entry_rcu(tmp, &encl->mm_list, list) {
+		if (tmp->mm == mm) {
+			encl_mm = tmp;
 			break;
-
-		if (iter == SGX_ENCL_MM_ITER_RESTART)
-			continue;
-
-		if (mm == encl_mm->mm)
-			return encl_mm;
+		}
 	}
 
-	return NULL;
+	srcu_read_unlock(&encl->srcu, idx);
+
+	return encl_mm;
 }
 
-
-static void sgx_vma_open(struct vm_area_struct *vma)
+int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 {
-	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_encl_mm *encl_mm;
 
-	if (!encl)
-		return;
+	lockdep_assert_held_exclusive(&mm->mmap_sem);
 
 	if (encl->flags & SGX_ENCL_DEAD)
-		goto error;
+		return -EINVAL;
 
-	if (WARN_ON_ONCE(!sgx_encl_get_mm(encl, vma->vm_mm)))
-		goto error;
+	/*
+	 * A dying encl_mm can be observed when synchronize_srcu() is called
+	 * asynchronously via sgx_encl_mm_release(), e.g. if mmap() closely
+	 * follows munmap().
+	 */
+	encl_mm = sgx_encl_find_mm(encl, mm);
+	if (encl_mm && kref_get_unless_zero(&encl_mm->refcount))
+		return 0;
 
-	return;
+	encl_mm = kzalloc(sizeof(*encl_mm), GFP_KERNEL);
+	if (!encl_mm)
+		return -ENOMEM;
 
-error:
-	vma->vm_private_data = NULL;
+	encl_mm->encl = encl;
+	encl_mm->mm = mm;
+	kref_init(&encl_mm->refcount);
+
+	spin_lock(&encl->mm_lock);
+	list_add_rcu(&encl_mm->list, &encl->mm_list);
+	spin_unlock(&encl->mm_lock);
+
+	/*
+	 * Note, in addition to ensuring reclaim sees all encl_mms that have a
+	 * valid mapping, this synchronize_srcu() also ensures that at most one
+	 * matching encl_mm is encountered by the refcouting flows, i.e. a live
+	 * encl_mm isn't hiding behind a dying encl_mm.
+	 */
+	synchronize_srcu(&encl->srcu);
+
+	return 0;
+}
+
+static void sgx_vma_open(struct vm_area_struct *vma)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+
+	if (!encl)
+		return;
+
+	if (sgx_encl_mm_add(encl, vma->vm_mm))
+		vma->vm_private_data = NULL;
 }
 
 static void sgx_vma_close(struct vm_area_struct *vma)
@@ -198,13 +252,8 @@ static void sgx_vma_close(struct vm_area_struct *vma)
 	if (!encl)
 		return;
 
-	encl_mm = sgx_encl_get_mm(encl, vma->vm_mm);
-	if (!WARN_ON_ONCE(!encl_mm)) {
-		kref_put(&encl_mm->refcount, sgx_encl_mm_release);
-
-		/* Release kref for the VMA. */
-		kref_put(&encl_mm->refcount, sgx_encl_mm_release);
-	}
+	encl_mm = sgx_encl_find_mm(encl, vma->vm_mm);
+	kref_put(&encl_mm->refcount, sgx_encl_mm_release);
 }
 
 static unsigned int sgx_vma_fault(struct vm_fault *vmf)
@@ -476,46 +525,6 @@ struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index)
 	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
 }
 
-/**
- * sgx_encl_next_mm() - Iterate to the next mm
- * @encl:	an enclave
- * @mm:		an mm list entry
- * @iter:	iterator status
- *
- * Return: the enclave mm or NULL
- */
-struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
-				     struct sgx_encl_mm *encl_mm, int *iter)
-{
-	struct list_head *entry;
-
-	WARN(!encl, "%s: encl is NULL", __func__);
-	WARN(!iter, "%s: iter is NULL", __func__);
-
-	spin_lock(&encl->mm_lock);
-
-	entry = encl_mm ? encl_mm->list.next : encl->mm_list.next;
-	WARN(!entry, "%s: entry is NULL", __func__);
-
-	if (entry == &encl->mm_list) {
-		spin_unlock(&encl->mm_lock);
-		*iter = SGX_ENCL_MM_ITER_DONE;
-		return NULL;
-	}
-
-	encl_mm = list_entry(entry, struct sgx_encl_mm, list);
-
-	if (!kref_get_unless_zero(&encl_mm->refcount)) {
-		spin_unlock(&encl->mm_lock);
-		*iter = SGX_ENCL_MM_ITER_RESTART;
-		return NULL;
-	}
-
-	spin_unlock(&encl->mm_lock);
-	*iter = SGX_ENCL_MM_ITER_NEXT;
-	return encl_mm;
-}
-
 static int sgx_encl_test_and_clear_young_cb(pte_t *ptep, pgtable_t token,
 					    unsigned long addr, void *data)
 {
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 04f9ae7db68c..be0f7c08c37b 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -12,6 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 #include <linux/radix-tree.h>
+#include <linux/srcu.h>
 #include <linux/workqueue.h>
 
 /**
@@ -59,6 +60,7 @@ struct sgx_encl_mm {
 	struct mm_struct *mm;
 	struct kref refcount;
 	struct list_head list;
+	struct work_struct release_work;
 };
 
 struct sgx_encl {
@@ -72,6 +74,7 @@ struct sgx_encl {
 	spinlock_t mm_lock;
 	struct file *backing;
 	struct kref refcount;
+	struct srcu_struct srcu;
 	unsigned long base;
 	unsigned long size;
 	unsigned long ssaframesize;
@@ -117,11 +120,7 @@ void sgx_encl_destroy(struct sgx_encl *encl);
 void sgx_encl_release(struct kref *ref);
 pgoff_t sgx_encl_get_index(struct sgx_encl *encl, struct sgx_encl_page *page);
 struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index);
-struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
-				     struct sgx_encl_mm *encl_mm, int *iter);
-void sgx_encl_mm_release(struct kref *ref);
-struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
-				    struct mm_struct *mm);
+int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
 struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index f192ade93245..e9427220415b 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -140,23 +140,13 @@ static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
 {
 	struct sgx_encl_page *page = epc_page->owner;
 	struct sgx_encl *encl = page->encl;
-	struct sgx_encl_mm *encl_mm = NULL;
-	struct sgx_encl_mm *prev_mm = NULL;
+	struct sgx_encl_mm *encl_mm;
 	bool ret = true;
-	int iter;
+	int idx;
 
-	while (true) {
-		encl_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
-		if (prev_mm)
-			kref_put(&prev_mm->refcount, sgx_encl_mm_release);
-		prev_mm = encl_mm;
-
-		if (iter == SGX_ENCL_MM_ITER_DONE)
-			break;
-
-		if (iter == SGX_ENCL_MM_ITER_RESTART)
-			continue;
+	idx = srcu_read_lock(&encl->srcu);
 
+	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
 		if (!mmget_not_zero(encl_mm->mm))
 			continue;
 
@@ -164,14 +154,14 @@ static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
 		ret = !sgx_encl_test_and_clear_young(encl_mm->mm, page);
 		up_read(&encl_mm->mm->mmap_sem);
 
-		mmput(encl_mm->mm);
+		mmput_async(encl_mm->mm);
 
-		if (!ret || (encl->flags & SGX_ENCL_DEAD)) {
-			kref_put(&encl_mm->refcount, sgx_encl_mm_release);
+		if (!ret || (encl->flags & SGX_ENCL_DEAD))
 			break;
-		}
 	}
 
+	srcu_read_unlock(&encl->srcu, idx);
+
 	/*
 	 * Do not reclaim this page if it has been recently accessed by any
 	 * mm_struct *and* if the enclave is still alive.  No need to take
@@ -195,24 +185,13 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 	struct sgx_encl_page *page = epc_page->owner;
 	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
 	struct sgx_encl *encl = page->encl;
-	struct sgx_encl_mm *encl_mm = NULL;
-	struct sgx_encl_mm *prev_mm = NULL;
+	struct sgx_encl_mm *encl_mm;
 	struct vm_area_struct *vma;
-	int iter;
-	int ret;
+	int idx, ret;
 
-	while (true) {
-		encl_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
-		if (prev_mm)
-			kref_put(&prev_mm->refcount, sgx_encl_mm_release);
-		prev_mm = encl_mm;
-
-		if (iter == SGX_ENCL_MM_ITER_DONE)
-			break;
-
-		if (iter == SGX_ENCL_MM_ITER_RESTART)
-			continue;
+	idx = srcu_read_lock(&encl->srcu);
 
+	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
 		if (!mmget_not_zero(encl_mm->mm))
 			continue;
 
@@ -224,9 +203,11 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 
 		up_read(&encl_mm->mm->mmap_sem);
 
-		mmput(encl_mm->mm);
+		mmput_async(encl_mm->mm);
 	}
 
+	srcu_read_unlock(&encl->srcu, idx);
+
 	mutex_lock(&encl->lock);
 
 	if (!(encl->flags & SGX_ENCL_DEAD)) {
@@ -289,32 +270,24 @@ static void sgx_ipi_cb(void *info)
 static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
 {
 	cpumask_t *cpumask = &encl->cpumask;
-	struct sgx_encl_mm *encl_mm = NULL;
-	struct sgx_encl_mm *prev_mm = NULL;
-	int iter;
+	struct sgx_encl_mm *encl_mm;
+	int idx;
 
 	cpumask_clear(cpumask);
 
-	while (true) {
-		encl_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
-		if (prev_mm)
-			kref_put(&prev_mm->refcount, sgx_encl_mm_release);
-		prev_mm = encl_mm;
-
-		if (iter == SGX_ENCL_MM_ITER_DONE)
-			break;
-
-		if (iter == SGX_ENCL_MM_ITER_RESTART)
-			continue;
+	idx = srcu_read_lock(&encl->srcu);
 
+	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
 		if (!mmget_not_zero(encl_mm->mm))
 			continue;
 
 		cpumask_or(cpumask, cpumask, mm_cpumask(encl_mm->mm));
 
-		mmput(encl_mm->mm);
+		mmput_async(encl_mm->mm);
 	}
 
+	srcu_read_unlock(&encl->srcu, idx);
+
 	return cpumask;
 }
 
-- 
2.22.0

