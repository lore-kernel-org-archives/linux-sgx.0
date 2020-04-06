Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118ACC2BB1D
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 20:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3DC120748
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 20:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgDFU4c (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 16:56:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:60185 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgDFU4c (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 16:56:32 -0400
IronPort-SDR: AGJZTfg4YN1epx0kE7x9z6kQ1uaBk+MMr/fGGrGtdUipFN8ijN8I8S5XI0tFtdLBNPw1TKhpvm
 WrEWoNZKDIiQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 13:56:31 -0700
IronPort-SDR: Iy/OaoOZiobVZdxY97yAr7Ba5bTewy2/Oydb6Ob7kBf80IaDkSvvu3KjtR788rGdQkhwWTb4Nr
 T1SZhQmIEG1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,352,1580803200"; 
   d="scan'208";a="241888477"
Received: from hmer-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.225])
  by fmsmga007.fm.intel.com with ESMTP; 06 Apr 2020 13:56:29 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v4] x86/sgx: Fix deadlock and race conditions between fork() and EPC reclaim
Date:   Mon,  6 Apr 2020 23:56:26 +0300
Message-Id: <20200406205626.33264-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Drop the synchronize_srcu() from sgx_encl_mm_add() and replace it with a
mm_list versioning concept to avoid deadlock when adding a mm during
dup_mmap()/fork(), and to ensure copied PTEs are zapped.

When dup_mmap() runs, it holds mmap_sem for write in both the old mm and
new mm.  Invoking synchronize_srcu() while holding mmap_sem of a mm that
is already attached to the enclave will deadlock if the reclaimer is in
the process of walking mm_list, as the reclaimer will try to acquire
mmap_sem (of the old mm) while holding encl->srcu for read.

 INFO: task ksgxswapd:181 blocked for more than 120 seconds.
 ksgxswapd       D    0   181      2 0x80004000
 Call Trace:
  __schedule+0x2db/0x700
  schedule+0x44/0xb0
  rwsem_down_read_slowpath+0x370/0x470
  down_read+0x95/0xa0
  sgx_reclaim_pages+0x1d2/0x7d0
  ksgxswapd+0x151/0x2e0
  kthread+0x120/0x140
  ret_from_fork+0x35/0x40

 INFO: task fork_consistenc:18824 blocked for more than 120 seconds.
 fork_consistenc D    0 18824  18786 0x00004320
 Call Trace:
  __schedule+0x2db/0x700
  schedule+0x44/0xb0
  schedule_timeout+0x205/0x300
  wait_for_completion+0xb7/0x140
  __synchronize_srcu.part.22+0x81/0xb0
  synchronize_srcu_expedited+0x27/0x30
  synchronize_srcu+0x57/0xe0
  sgx_encl_mm_add+0x12b/0x160
  sgx_vma_open+0x22/0x40
  dup_mm+0x521/0x580
  copy_process+0x1a56/0x1b50
  _do_fork+0x85/0x3a0
  __x64_sys_clone+0x8e/0xb0
  do_syscall_64+0x57/0x1b0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Furthermore, doing synchronize_srcu() in sgx_encl_mm_add() does not
prevent the new mm from having stale PTEs pointing at the EPC page to be
reclaimed.  dup_mmap() calls vm_ops->open()/sgx_encl_mm_add() _after_
PTEs are copied to the new mm, i.e. blocking fork() until reclaim zaps
the old mm is pointless as the stale PTEs have already been created in
the new mm.

All other flows that walk mm_list can safely race with dup_mmap() or are
protected by a different mechanism.  Add comments to all srcu readers
that don't check the list version to document why its ok for the flow to
ignore the version.

Note, synchronize_srcu() is still needed when removing a mm from an
enclave, as the srcu readers must complete their walk before the mm can
be freed.  Removing a mm is never done while holding mmap_sem.

Cc: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
v4:
* Reverted to v2.
* Added smp_wmb() with accompanying comment about reordering.
v3:
* Sanitized version list version handling in sgx_reclaimer_block().
  With the fences it was quite complicted given that the version
  was read both in the beginning and end of the loop.
* Removed comment before cpumask_clear() because technically it is
  not part of this bug fix.
v2:
* Remove smp_wmb() as x86 does not reorder writes in the pipeline.
* Refine comments to be more to the point and more maintainable when
  things might change.
* Replace the ad hoc (goto-based) loop construct with a proper loop
  construct.
 arch/x86/kernel/cpu/sgx/encl.c    | 17 +++++++++++--
 arch/x86/kernel/cpu/sgx/encl.h    |  1 +
 arch/x86/kernel/cpu/sgx/reclaim.c | 40 +++++++++++++++++++++----------
 3 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index e0124a2f22d5..1646c3d1839c 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -196,6 +196,9 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 	struct sgx_encl_mm *encl_mm;
 	int ret;
 
+	/* mm_list can be accessed only by a single thread at a time. */
+	lockdep_assert_held_write(&mm->mmap_sem);
+
 	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD)
 		return -EINVAL;
 
@@ -221,11 +224,21 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 		return ret;
 	}
 
+	/*
+	 * The page reclaimer uses list version for synchronization instead of
+	 * synchronize_scru() because otherwise we could conflict with
+	 * dup_mmap().
+	 */
+
 	spin_lock(&encl->mm_lock);
+
 	list_add_rcu(&encl_mm->list, &encl->mm_list);
-	spin_unlock(&encl->mm_lock);
 
-	synchronize_srcu(&encl->srcu);
+	/* Even if the CPU does not reorder writes, a compiler might. */
+	smp_wmb();
+	encl->mm_list_version++;
+
+	spin_unlock(&encl->mm_lock);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 44b353aa8866..f0f72e591244 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -74,6 +74,7 @@ struct sgx_encl {
 	struct mutex lock;
 	struct list_head mm_list;
 	spinlock_t mm_lock;
+	unsigned long mm_list_version;
 	struct file *backing;
 	struct kref refcount;
 	struct srcu_struct srcu;
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 39f0ddefbb79..5e089f0db201 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -184,28 +184,39 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 	struct sgx_encl_page *page = epc_page->owner;
 	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
 	struct sgx_encl *encl = page->encl;
+	unsigned long mm_list_version;
 	struct sgx_encl_mm *encl_mm;
 	struct vm_area_struct *vma;
 	int idx, ret;
 
-	idx = srcu_read_lock(&encl->srcu);
+	do {
+		mm_list_version = encl->mm_list_version;
 
-	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
-		if (!mmget_not_zero(encl_mm->mm))
-			continue;
+		/*
+		 * Fence the read. This guarantees that we don't mutate the old
+		 * list with a new version.
+		 */
+		smp_rmb();
 
-		down_read(&encl_mm->mm->mmap_sem);
+		idx = srcu_read_lock(&encl->srcu);
 
-		ret = sgx_encl_find(encl_mm->mm, addr, &vma);
-		if (!ret && encl == vma->vm_private_data)
-			zap_vma_ptes(vma, addr, PAGE_SIZE);
+		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
+			if (!mmget_not_zero(encl_mm->mm))
+				continue;
 
-		up_read(&encl_mm->mm->mmap_sem);
+			down_read(&encl_mm->mm->mmap_sem);
 
-		mmput_async(encl_mm->mm);
-	}
+			ret = sgx_encl_find(encl_mm->mm, addr, &vma);
+			if (!ret && encl == vma->vm_private_data)
+				zap_vma_ptes(vma, addr, PAGE_SIZE);
 
-	srcu_read_unlock(&encl->srcu, idx);
+			up_read(&encl_mm->mm->mmap_sem);
+
+			mmput_async(encl_mm->mm);
+		}
+
+		srcu_read_unlock(&encl->srcu, idx);
+	} while (unlikely(encl->mm_list_version != mm_list_version));
 
 	mutex_lock(&encl->lock);
 
@@ -250,6 +261,11 @@ static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
 	struct sgx_encl_mm *encl_mm;
 	int idx;
 
+	/*
+	 * Can race with sgx_encl_mm_add(), but ETRACK has already been
+	 * executed, which means that the CPUs running in the new mm will enter
+	 * into the enclave with a fresh epoch.
+	 */
 	cpumask_clear(cpumask);
 
 	idx = srcu_read_lock(&encl->srcu);
-- 
2.25.1

