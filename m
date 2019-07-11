Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8835EC74A5D
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 610112084B
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfGKQQ2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 12:16:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:37842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbfGKQQ2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 12:16:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 09:16:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="177213537"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga002.jf.intel.com with ESMTP; 11 Jul 2019 09:16:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v21 2/2] x86/sgx: Use mmu_notifier.release() instead of per-vma refcounting
Date:   Thu, 11 Jul 2019 09:16:25 -0700
Message-Id: <20190711161625.15786-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190711161625.15786-1-sean.j.christopherson@intel.com>
References: <20190711161625.15786-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Using per-vma refcounting to track mm_structs associated with an enclave
requires hooking .vm_close(), which in turn prevents the mm from merging
vmas (precisely to allow refcounting).

Avoid refcounting encl_mm altogether by registering an mmu_notifier at
.mmap(), removing the dying encl_mm at mmu_notifier.release() and
protecting mm_list during reclaim via a per-enclave SRCU.

Removing refcounting/vm_close() allows merging of enclave vmas, at the
cost of delaying removal of encl_mm structs from mm_list, i.e. an mm is
disassociated from an enclave when the mm exits or the enclave dies, as
opposed to when the last vma (in a given mm) is closed.

The impact of delying encl_mm removal is its memory footprint and
whatever overhead is incurred during EPC reclaim (to walk an mm's vmas).
Practically speaking, a stale encl_mm will exist for a meaningful amount
of time if and only if the enclave is mapped in a long-lived process and
then passed off to another long-lived process.  It is expected that the
vast majority of use cases will not encounter this condition, e.g. even
using a daemon to build enclaves should not result in a stale encl_mm as
the builder should never need to mmap() the enclave.

Even if there are scenarios that lead to defunct encl_mms, the cost is
likely far outweighed by the benefits of reducing the number of vmas
across all enclaves.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/Kconfig                      |  1 +
 arch/x86/kernel/cpu/sgx/driver/main.c | 26 ++++++++
 arch/x86/kernel/cpu/sgx/encl.c        | 89 ++++++++++++---------------
 arch/x86/kernel/cpu/sgx/encl.h        |  5 +-
 4 files changed, 71 insertions(+), 50 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 17558cf48a8a..2957dc59e622 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1919,6 +1919,7 @@ config INTEL_SGX
 	bool "Intel SGX core functionality"
 	depends on X86_64 && CPU_SUP_INTEL
 	select SRCU
+	select MMU_NOTIFIER
 	---help---
 	  Intel(R) SGX is a set of CPU instructions that can be used by
 	  applications to set aside private regions of code and data, referred
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 27076754f7d8..5571954d7109 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -53,6 +53,32 @@ static int sgx_open(struct inode *inode, struct file *file)
 static int sgx_release(struct inode *inode, struct file *file)
 {
 	struct sgx_encl *encl = file->private_data;
+	struct sgx_encl_mm *encl_mm;
+
+	/*
+	 * Objects can't be *moved* off an RCU protected list (deletion is ok),
+	 * nor can the object be freed until after synchronize_srcu().
+	 */
+restart:
+	spin_lock(&encl->mm_lock);
+	if (list_empty(&encl->mm_list)) {
+		encl_mm = NULL;
+	} else {
+		encl_mm = list_first_entry(&encl->mm_list, struct sgx_encl_mm,
+					   list);
+		list_del_rcu(&encl_mm->list);
+	}
+	spin_unlock(&encl->mm_lock);
+
+	if (encl_mm) {
+		synchronize_srcu(&encl->srcu);
+
+		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
+
+		kfree(encl_mm);
+
+		goto restart;
+	}
 
 	mutex_lock(&encl->lock);
 	encl->flags |= SGX_ENCL_DEAD;
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 64ae7d705eb1..fc12b8c01629 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -132,45 +132,51 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 	return entry;
 }
 
-static void sgx_encl_mm_release_deferred(struct work_struct *work)
+static void sgx_encl_mm_release_deferred(struct rcu_head *rcu)
 {
 	struct sgx_encl_mm *encl_mm =
-		container_of(work, struct sgx_encl_mm, release_work);
+		container_of(rcu, struct sgx_encl_mm, rcu);
 
-	mmdrop(encl_mm->mm);
-	synchronize_srcu(&encl_mm->encl->srcu);
 	kfree(encl_mm);
 }
 
-static void sgx_encl_mm_release(struct kref *ref)
+static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
+				     struct mm_struct *mm)
 {
 	struct sgx_encl_mm *encl_mm =
-		container_of(ref, struct sgx_encl_mm, refcount);
+		container_of(mn, struct sgx_encl_mm, mmu_notifier);
+	struct sgx_encl_mm *tmp = NULL;
 
+	/*
+	 * The enclave itself can remove encl_mm.  Note, objects can't be moved
+	 * off an RCU protected list, but deletion is ok.
+	 */
 	spin_lock(&encl_mm->encl->mm_lock);
-	list_del_rcu(&encl_mm->list);
+	list_for_each_entry(tmp, &encl_mm->encl->mm_list, list) {
+		if (tmp == encl_mm) {
+			list_del_rcu(&encl_mm->list);
+			break;
+		}
+	}
 	spin_unlock(&encl_mm->encl->mm_lock);
 
-	/*
-	 * If the mm has users, then do SRCU synchronization in a worker thread
-	 * to avoid a deadlock with the reclaimer.  The caller holds mmap_sem
-	 * for write, while the reclaimer will acquire mmap_sem for read if it
-	 * is reclaiming from this enclave.  Invoking synchronize_srcu() here
-	 * will hang waiting for the reclaimer to drop its RCU read lock, while
-	 * the reclaimer will get stuck waiting to acquire mmap_sem.  The async
-	 * shenanigans can be avoided if there are no mm users as the reclaimer
-	 * will not acquire mmap_sem in that case.
-	 */
-	if (atomic_read(&encl_mm->mm->mm_users)) {
-		mmgrab(encl_mm->mm);
-		INIT_WORK(&encl_mm->release_work, sgx_encl_mm_release_deferred);
-		schedule_work(&encl_mm->release_work);
-	} else {
+	if (tmp == encl_mm) {
 		synchronize_srcu(&encl_mm->encl->srcu);
-		kfree(encl_mm);
+
+		/*
+		 * Delay freeing encl_mm until after mmu_notifier synchronizes
+		 * its SRCU to ensure encl_mm cannot be dereferenced.
+		 */
+		mmu_notifier_unregister_no_release(mn, mm);
+		mmu_notifier_call_srcu(&encl_mm->rcu,
+				       &sgx_encl_mm_release_deferred);
 	}
 }
 
+static const struct mmu_notifier_ops sgx_mmu_notifier_ops = {
+	.release		= sgx_mmu_notifier_release,
+};
+
 static struct sgx_encl_mm *sgx_encl_find_mm(struct sgx_encl *encl,
 					    struct mm_struct *mm)
 {
@@ -195,6 +201,7 @@ static struct sgx_encl_mm *sgx_encl_find_mm(struct sgx_encl *encl,
 int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 {
 	struct sgx_encl_mm *encl_mm;
+	int ret;
 
 	lockdep_assert_held_exclusive(&mm->mmap_sem);
 
@@ -202,12 +209,11 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 		return -EINVAL;
 
 	/*
-	 * A dying encl_mm can be observed when synchronize_srcu() is called
-	 * asynchronously via sgx_encl_mm_release(), e.g. if mmap() closely
-	 * follows munmap().
+	 * mm_structs are kept on mm_list until the mm or the enclave dies,
+	 * i.e. once an mm is off the list, it's gone for good, therefore it's
+	 * impossible to get a false positive on @mm due to a stale mm_list.
 	 */
-	encl_mm = sgx_encl_find_mm(encl, mm);
-	if (encl_mm && kref_get_unless_zero(&encl_mm->refcount))
+	if (sgx_encl_find_mm(encl, mm))
 		return 0;
 
 	encl_mm = kzalloc(sizeof(*encl_mm), GFP_KERNEL);
@@ -216,18 +222,18 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 
 	encl_mm->encl = encl;
 	encl_mm->mm = mm;
-	kref_init(&encl_mm->refcount);
+	encl_mm->mmu_notifier.ops = &sgx_mmu_notifier_ops;
+
+	ret = __mmu_notifier_register(&encl_mm->mmu_notifier, mm);
+	if (ret) {
+		kfree(encl_mm);
+		return ret;
+	}
 
 	spin_lock(&encl->mm_lock);
 	list_add_rcu(&encl_mm->list, &encl->mm_list);
 	spin_unlock(&encl->mm_lock);
 
-	/*
-	 * Note, in addition to ensuring reclaim sees all encl_mms that have a
-	 * valid mapping, this synchronize_srcu() also ensures that at most one
-	 * matching encl_mm is encountered by the refcouting flows, i.e. a live
-	 * encl_mm isn't hiding behind a dying encl_mm.
-	 */
 	synchronize_srcu(&encl->srcu);
 
 	return 0;
@@ -244,18 +250,6 @@ static void sgx_vma_open(struct vm_area_struct *vma)
 		vma->vm_private_data = NULL;
 }
 
-static void sgx_vma_close(struct vm_area_struct *vma)
-{
-	struct sgx_encl *encl = vma->vm_private_data;
-	struct sgx_encl_mm *encl_mm;
-
-	if (!encl)
-		return;
-
-	encl_mm = sgx_encl_find_mm(encl, vma->vm_mm);
-	kref_put(&encl_mm->refcount, sgx_encl_mm_release);
-}
-
 static unsigned int sgx_vma_fault(struct vm_fault *vmf)
 {
 	unsigned long addr = (unsigned long)vmf->address;
@@ -391,7 +385,6 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
 }
 
 const struct vm_operations_struct sgx_vm_ops = {
-	.close = sgx_vma_close,
 	.open = sgx_vma_open,
 	.fault = sgx_vma_fault,
 	.access = sgx_vma_access,
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index be0f7c08c37b..808faf70f7ae 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -9,6 +9,7 @@
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/mm_types.h>
+#include <linux/mmu_notifier.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 #include <linux/radix-tree.h>
@@ -58,9 +59,9 @@ enum sgx_encl_flags {
 struct sgx_encl_mm {
 	struct sgx_encl *encl;
 	struct mm_struct *mm;
-	struct kref refcount;
 	struct list_head list;
-	struct work_struct release_work;
+	struct mmu_notifier mmu_notifier;
+	struct rcu_head rcu;
 };
 
 struct sgx_encl {
-- 
2.22.0

