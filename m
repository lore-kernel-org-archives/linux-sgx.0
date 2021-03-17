Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5736C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Mar 2021 23:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B219B64F38
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Mar 2021 23:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCQXyI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhCQXyB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 17 Mar 2021 19:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B38B64F01;
        Wed, 17 Mar 2021 23:54:00 +0000 (UTC)
From:   Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list
Date:   Thu, 18 Mar 2021 01:53:30 +0200
Message-Id: <20210317235332.362001-1-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

During normal runtime, the "ksgxd" daemon behaves like a  version of
kswapd just for SGX.  But, before it starts acting like kswapd, its
first job is to initialize enclave memory.

Currently, the SGX boot code places each enclave page on a
epc_section->init_laundry_list.  Once it starts up, the ksgxd code walks
over that list and populates the actual SGX page allocator.

However, the per-section structures are going away to make way for the SGX
NUMA allocator.  There's also little need to have a per-section structure;
the enclave pages are all treated identically, and they can be placed on
the correct allocator list from metadata stored in the enclave page
(struct sgx_epc_page) itself.

Modify sgx_sanitize_section() to take a single page list instead of taking
a section and deriving the list from there.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
---

v5
* Refine the commit message.
* Refine inline comments.
* Encapsulate a sanitization pass into __sgx_sanitize_pages().

v4:
* Open coded sgx_santize_section() to ksgxd().
* Rewrote the commit message.

 arch/x86/kernel/cpu/sgx/main.c | 54 ++++++++++++++++------------------
 arch/x86/kernel/cpu/sgx/sgx.h  |  7 -----
 2 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8df81a3ed945..f3a5cd2d27ef 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -26,39 +26,43 @@ static LIST_HEAD(sgx_active_page_list);
 
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
+static LIST_HEAD(sgx_dirty_page_list);
+
 /*
- * Reset dirty EPC pages to uninitialized state. Laundry can be left with SECS
- * pages whose child pages blocked EREMOVE.
+ * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
+ * from the input list, and made available for the page allocator. SECS pages
+ * prepending their children in the input list are left intact.
  */
-static void sgx_sanitize_section(struct sgx_epc_section *section)
+static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
 {
 	struct sgx_epc_page *page;
 	LIST_HEAD(dirty);
 	int ret;
 
-	/* init_laundry_list is thread-local, no need for a lock: */
-	while (!list_empty(&section->init_laundry_list)) {
+	/* dirty_page_list is thread-local, no need for a lock: */
+	while (!list_empty(dirty_page_list)) {
 		if (kthread_should_stop())
 			return;
 
-		/* needed for access to ->page_list: */
-		spin_lock(&section->lock);
-
-		page = list_first_entry(&section->init_laundry_list,
-					struct sgx_epc_page, list);
+		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
 
 		ret = __eremove(sgx_get_epc_virt_addr(page));
-		if (!ret)
-			list_move(&page->list, &section->page_list);
-		else
+		if (!ret) {
+			/*
+			 * page is now sanitized.  Make it available via the SGX
+			 * page allocator:
+			 */
+			list_del(&page->list);
+			sgx_free_epc_page(page);
+		} else {
+			/* The page is not yet clean - move to the dirty list. */
 			list_move_tail(&page->list, &dirty);
-
-		spin_unlock(&section->lock);
+		}
 
 		cond_resched();
 	}
 
-	list_splice(&dirty, &section->init_laundry_list);
+	list_splice(&dirty, dirty_page_list);
 }
 
 static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
@@ -405,24 +409,17 @@ static bool sgx_should_reclaim(unsigned long watermark)
 
 static int ksgxd(void *p)
 {
-	int i;
-
 	set_freezable();
 
 	/*
 	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
 	 * required for SECS pages, whose child pages blocked EREMOVE.
 	 */
-	for (i = 0; i < sgx_nr_epc_sections; i++)
-		sgx_sanitize_section(&sgx_epc_sections[i]);
-
-	for (i = 0; i < sgx_nr_epc_sections; i++) {
-		sgx_sanitize_section(&sgx_epc_sections[i]);
+	__sgx_sanitize_pages(&sgx_dirty_page_list);
+	__sgx_sanitize_pages(&sgx_dirty_page_list);
 
-		/* Should never happen. */
-		if (!list_empty(&sgx_epc_sections[i].init_laundry_list))
-			WARN(1, "EPC section %d has unsanitized pages.\n", i);
-	}
+	/* sanity check: */
+	WARN_ON(!list_empty(&sgx_dirty_page_list));
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
@@ -637,13 +634,12 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	section->phys_addr = phys_addr;
 	spin_lock_init(&section->lock);
 	INIT_LIST_HEAD(&section->page_list);
-	INIT_LIST_HEAD(&section->init_laundry_list);
 
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
 		section->pages[i].flags = 0;
 		section->pages[i].owner = NULL;
-		list_add_tail(&section->pages[i].list, &section->init_laundry_list);
+		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
 	section->free_cnt = nr_pages;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 5fa42d143feb..bc8af0428640 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -45,13 +45,6 @@ struct sgx_epc_section {
 	spinlock_t lock;
 	struct list_head page_list;
 	unsigned long free_cnt;
-
-	/*
-	 * Pages which need EREMOVE run on them before they can be
-	 * used.  Only safe to be accessed in ksgxd and init code.
-	 * Not protected by locks.
-	 */
-	struct list_head init_laundry_list;
 };
 
 extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
-- 
2.31.0

