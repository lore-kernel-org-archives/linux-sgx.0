Return-Path: <SRS0=bOfw=5C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3C5C10F29
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Mar 2020 05:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 527A720663
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Mar 2020 05:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgCQFPo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Mar 2020 01:15:44 -0400
Received: from mga04.intel.com ([192.55.52.120]:35512 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgCQFPn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Mar 2020 01:15:43 -0400
IronPort-SDR: fj4Q1kw5mjblip6FdfFbbTlpyA+DliWU5xVwNTuU5JgToRudqk8dDbhN5ROGMR9A8vuUvF3FuO
 ua8WLXxVShOQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 22:15:43 -0700
IronPort-SDR: rl6ZxK/8BkYcbQ88ZsePzi7q5zfSU6WeX9i9rCEeRL4itABfRErBO+dp3aNLV0Rubh/AZ6pnL6
 9JOh7ua99nxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="237808260"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 16 Mar 2020 22:15:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH] x86/sgx: Fix deadlock and race conditions between fork() and EPC reclaim
Date:   Mon, 16 Mar 2020 22:15:39 -0700
Message-Id: <20200317051539.10447-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c    | 22 +++++++++++++++++++--
 arch/x86/kernel/cpu/sgx/encl.h    |  1 +
 arch/x86/kernel/cpu/sgx/reclaim.c | 33 +++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index d6a19bdd1921..b9a7c56f7c25 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -196,6 +196,12 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 	struct sgx_encl_mm *encl_mm;
 	int ret;
 
+	/*
+	 * This flow relies on mmap_sem to provide mutual exclusivity (for a
+	 * given mm) to prevent duplicate instances of an encl_mm on the list.
+	 */
+	lockdep_assert_held_write(&mm->mmap_sem);
+
 	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD)
 		return -EINVAL;
 
@@ -223,10 +229,22 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 
 	spin_lock(&encl->mm_lock);
 	list_add_rcu(&encl_mm->list, &encl->mm_list);
+	/*
+	 * Ensure the mm is added to the list before updating the version.
+	 * Pairs with the smp_rmb() in sgx_reclaimer_block().
+	 */
+	smp_wmb();
+	encl->mm_list_version++;
 	spin_unlock(&encl->mm_lock);
 
-	synchronize_srcu(&encl->srcu);
-
+	/*
+	 * DO NOT call synchronize_srcu()!  When this is called via dup_mmap(),
+	 * mmap_sem is held for write in both the old mm and new mm, and the
+	 * reclaimer may be holding srcu for read while waiting on down_read()
+	 * for the old mm's mmap_sem, i.e. synchronizing will deadlock.
+	 * Incrementing the list version ensures readers that must not race
+	 * with a mm being added will see the updated list.
+	 */
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
index 39f0ddefbb79..3b4b849c5b2e 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -155,6 +155,11 @@ static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
 	bool ret = true;
 	int idx;
 
+	/*
+	 * Note, this can race with sgx_encl_mm_add(), but worst case scenario
+	 * a page will be reclaimed immediately after it's accessed in the new
+	 * process/mm.
+	 */
 	idx = srcu_read_lock(&encl->srcu);
 
 	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
@@ -184,10 +189,20 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 	struct sgx_encl_page *page = epc_page->owner;
 	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
 	struct sgx_encl *encl = page->encl;
+	unsigned long mm_list_version;
 	struct sgx_encl_mm *encl_mm;
 	struct vm_area_struct *vma;
 	int idx, ret;
 
+retry:
+	mm_list_version = encl->mm_list_version;
+	/*
+	 * Ensure the list version is read before walking the list to prevent
+	 * beginning the walk with the old list using the new version.  Pairs
+	 * with the smp_wmb() in sgx_encl_mm_add().
+	 */
+	smp_rmb();
+
 	idx = srcu_read_lock(&encl->srcu);
 
 	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
@@ -207,6 +222,19 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 
 	srcu_read_unlock(&encl->srcu, idx);
 
+	/*
+	 * Redo the zapping if a mm was added to the list while zapping was in
+	 * progress.  dup_mmap() copies the PTEs for VM_PFNMAP VMAs, i.e. the
+	 * new mm won't take a page fault and so won't see that the page is
+	 * tagged RECLAIMED.  Note, vm_ops->open()/sgx_encl_mm_add() is called
+	 * _after_ PTEs are copied, and dup_mmap() holds the old mm's mmap_sem
+	 * for write, so the version check is only needed to protect against
+	 * dup_mmap() running after the list walk started but before the old
+	 * mm's PTEs were zapped.
+	 */
+	if (unlikely(encl->mm_list_version != mm_list_version))
+		goto retry;
+
 	mutex_lock(&encl->lock);
 
 	if (!(atomic_read(&encl->flags) & SGX_ENCL_DEAD)) {
@@ -250,6 +278,11 @@ static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
 	struct sgx_encl_mm *encl_mm;
 	int idx;
 
+	/*
+	 * Note, this can race with sgx_encl_mm_add(), but ETRACK has already
+	 * been executed, so CPUs running in the new mm will enter the enclave
+	 * in a different epoch.
+	 */
 	cpumask_clear(cpumask);
 
 	idx = srcu_read_lock(&encl->srcu);
-- 
2.24.1

