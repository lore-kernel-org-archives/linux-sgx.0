Return-Path: <SRS0=OrTC=YP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF2ECA9EB7
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 22:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 928932086D
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 22:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732738AbfJVWtY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Oct 2019 18:49:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:58904 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731185AbfJVWtY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Oct 2019 18:49:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 15:49:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,218,1569308400"; 
   d="scan'208";a="372690702"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 22 Oct 2019 15:49:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 3/3] x86/sgx: Move reclaim logic out of sgx_free_page()
Date:   Tue, 22 Oct 2019 15:49:22 -0700
Message-Id: <20191022224922.28144-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022224922.28144-1-sean.j.christopherson@intel.com>
References: <20191022224922.28144-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move the reclaim logic out of sgx_free_page() and into a standalone
helper to avoid taking sgx_active_page_list_lock when the page is known
to be unreclaimable, which is the vast majority of flows that free EPC
pages.

Movig reclaim logic to a separate function also eliminates any
possibility of silently leaking a page because it is unexpectedly
reclaimable (and being actively reclaimed).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I really don't like the sgx_unmark_...() name, but couldn't come up with
anything better.  Suggestions welcome...

 arch/x86/kernel/cpu/sgx/encl.c    |  3 ++-
 arch/x86/kernel/cpu/sgx/main.c    | 32 ++++++++-----------------------
 arch/x86/kernel/cpu/sgx/reclaim.c | 32 +++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h     |  3 ++-
 4 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 8045f1ddfd62..22186d89042a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -474,9 +474,10 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 			 * The page and its radix tree entry cannot be freed
 			 * if the page is being held by the reclaimer.
 			 */
-			if (sgx_free_page(entry->epc_page))
+			if (sgx_unmark_page_reclaimable(entry->epc_page))
 				continue;
 
+			sgx_free_page(entry->epc_page);
 			encl->secs_child_cnt--;
 			entry->epc_page = NULL;
 		}
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8e7557d3ff03..cfd8480ef563 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -108,45 +108,29 @@ struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
  * sgx_free_page() - Free an EPC page
  * @page:	pointer a previously allocated EPC page
  *
- * EREMOVE an EPC page and insert it back to the list of free pages. If the
- * page is reclaimable, delete it from the active page list.
- *
- * Return:
- *   0 on success,
- *   -EBUSY if a reclaim is in progress
+ * EREMOVE an EPC page and insert it back to the list of free pages. The page
+ * must not be reclaimable.
  */
-int sgx_free_page(struct sgx_epc_page *page)
+void sgx_free_page(struct sgx_epc_page *page)
 {
 	struct sgx_epc_section *section = sgx_epc_section(page);
 	int ret;
 
 	/*
-	 * Remove the page from the active list if necessary.  If the page
-	 * is actively being reclaimed, i.e. RECLAIMABLE is set but the
-	 * page isn't on the active list, return -EBUSY as we can't free
-	 * the page at this time since it is "owned" by the reclaimer.
+	 * Don't take sgx_active_page_list_lock when asserting the page isn't
+	 * reclaimable, missing a WARN in the very rare case is preferable to
+	 * unnecessarily taking a global lock in the common case.
 	 */
-	spin_lock(&sgx_active_page_list_lock);
-	if (page->desc & SGX_EPC_PAGE_RECLAIMABLE) {
-		if (list_empty(&page->list)) {
-			spin_unlock(&sgx_active_page_list_lock);
-			return -EBUSY;
-		}
-		list_del(&page->list);
-		page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
-	}
-	spin_unlock(&sgx_active_page_list_lock);
+	WARN_ON_ONCE(page->desc & SGX_EPC_PAGE_RECLAIMABLE);
 
 	ret = __eremove(sgx_epc_addr(page));
 	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
-		return -EIO;
+		return;
 
 	spin_lock(&section->lock);
 	list_add_tail(&page->list, &section->page_list);
 	atomic_inc(&sgx_nr_free_pages);
 	spin_unlock(&section->lock);
-
-	return 0;
 }
 
 static void __init sgx_free_epc_section(struct sgx_epc_section *section)
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 8067ce1915a4..e64c810883ec 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -125,6 +125,38 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
 	spin_unlock(&sgx_active_page_list_lock);
 }
 
+/**
+ * sgx_unmark_page_reclaimable() - Remove a page from the reclaim list
+ * @page:	EPC page
+ *
+ * Clear the reclaimable flag and remove the page from the active page list.
+ *
+ * Return:
+ *   0 on success,
+ *   -EBUSY if the page is in the process of being reclaimed
+ */
+int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
+{
+	/*
+	 * Remove the page from the active list if necessary.  If the page
+	 * is actively being reclaimed, i.e. RECLAIMABLE is set but the
+	 * page isn't on the active list, return -EBUSY as we can't free
+	 * the page at this time since it is "owned" by the reclaimer.
+	 */
+	spin_lock(&sgx_active_page_list_lock);
+	if (page->desc & SGX_EPC_PAGE_RECLAIMABLE) {
+		if (list_empty(&page->list)) {
+			spin_unlock(&sgx_active_page_list_lock);
+			return -EBUSY;
+		}
+		list_del(&page->list);
+		page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+	}
+	spin_unlock(&sgx_active_page_list_lock);
+
+	return 0;
+}
+
 static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
 {
 	struct sgx_encl_page *page = epc_page->owner;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 45753f236a83..f6d23ef7c74a 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -81,10 +81,11 @@ extern spinlock_t sgx_active_page_list_lock;
 
 bool __init sgx_page_reclaimer_init(void);
 void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
+int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
 void sgx_reclaim_pages(void);
 
 struct sgx_epc_page *sgx_try_alloc_page(void);
 struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
-int sgx_free_page(struct sgx_epc_page *page);
+void sgx_free_page(struct sgx_epc_page *page);
 
 #endif /* _X86_SGX_H */
-- 
2.22.0

