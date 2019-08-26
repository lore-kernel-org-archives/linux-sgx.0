Return-Path: <SRS0=p0kK=WW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D4CC3A59E
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 06:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C4F32173E
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 06:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbfHZGdc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 02:33:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:38013 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfHZGdb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 02:33:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Aug 2019 23:33:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="184848064"
Received: from chlopez-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.38.177])
  by orsmga006.jf.intel.com with ESMTP; 25 Aug 2019 23:33:26 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christoherson <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH RFC] x86/sgx: Convert sgx_reclaim_pages() to sgx_reclaim_page()
Date:   Mon, 26 Aug 2019 09:33:23 +0300
Message-Id: <20190826063323.22196-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Convert sgx_reclaim_pages() to sgx_reclaim_page(), which reclaims only a
signle page and returns it back to the caller instead of freeing it.

A simpler flow will allow also simplify sgx_alloc_page() flow and make it
constant time. With this change it is easer to pin backing storage before
the pages are blocked, which stabilizes the EBLOCK/EWB/ETRACK flow: only an
EPCM conflict could cause a EWB to fail.

Because sgx_alloc_page() operations run in parallel on different threads
ETRACK's will still group multiple EBLOCK operations. ksgxswapd can be
improved in future with multi-threading (e.g.a work queue).

Cc: Sean Christoherson <sean.j.christopherson@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
Untested because I do not want to spend much time on this unless the
high level idea is welcomed.
 arch/x86/kernel/cpu/sgx/main.c    | 14 ++---
 arch/x86/kernel/cpu/sgx/reclaim.c | 87 ++++++++++++++-----------------
 arch/x86/kernel/cpu/sgx/sgx.h     |  2 +-
 3 files changed, 46 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index e4f751651a65..7399ccd71fc1 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -71,8 +71,9 @@ static struct sgx_epc_page *sgx_try_alloc_page(void *owner)
 struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
 {
 	struct sgx_epc_page *entry;
+	int i;
 
-	for ( ; ; ) {
+	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
 		entry = sgx_try_alloc_page(owner);
 		if (entry)
 			break;
@@ -85,13 +86,12 @@ struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		if (signal_pending(current)) {
-			entry = ERR_PTR(-ERESTARTSYS);
-			break;
-		}
+		entry = sgx_reclaim_page();
 
-		sgx_reclaim_pages();
-		schedule();
+		if (PTR_ERR(entry) == -EBUSY)
+			continue;
+		else
+			return entry;
 	}
 
 	if (sgx_calc_free_cnt() < SGX_NR_LOW_PAGES)
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 3f10a8ff00b7..7908af4cbe70 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -69,6 +69,7 @@ static inline bool sgx_should_reclaim(void)
 
 static int ksgxswapd(void *p)
 {
+	struct sgx_epc_page *epc_page;
 	int i;
 
 	set_freezable();
@@ -83,8 +84,11 @@ static int ksgxswapd(void *p)
 		wait_event_freezable(ksgxswapd_waitq, kthread_should_stop() ||
 						      sgx_should_reclaim());
 
-		if (sgx_should_reclaim())
-			sgx_reclaim_pages();
+		if (sgx_should_reclaim()) {
+			epc_page = sgx_reclaim_page();
+			if (!PTR_ERR_OR_ZERO(epc_page))
+				sgx_free_page(epc_page);
+		}
 
 		cond_resched();
 	}
@@ -390,73 +394,58 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
 }
 
 /**
- * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
- * Takes a fixed chunk of pages from the global list of consumed EPC pages and
- * tries to swap them. Only the pages that are either being freed by the
- * consumer or actively used are skipped.
+ * sgx_reclaim_page() - Reclaim an EPC page
+ *
+ * Take an EPC page from the LRU list of active pages and write it to the
+ * regular memory unless it has been recently accessed or is being freed by the
+ * owner.
+ *
+ * Return:
+ *   an &sgx_epc_page on success,
+ *   -ENOMEM when the list is empty,
+ *   -EBUSY when the page is not available,
+ *   -errno otherwise
  */
-void sgx_reclaim_pages(void)
+struct sgx_epc_page *sgx_reclaim_page(void)
 {
-	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];
 	struct sgx_epc_page *epc_page;
-	struct sgx_epc_section *section;
-	int i, j;
 
 	spin_lock(&sgx_active_page_list_lock);
-	for (i = 0, j = 0; i < SGX_NR_TO_SCAN; i++) {
-		if (list_empty(&sgx_active_page_list))
-			break;
 
-		epc_page = list_first_entry(&sgx_active_page_list,
-					    struct sgx_epc_page, list);
-		list_del_init(&epc_page->list);
+	if (list_empty(&sgx_active_page_list)) {
+		spin_unlock(&sgx_active_page_list_lock);
+		return ERR_PTR(-ENOMEM);
+	}
 
-		if (sgx_reclaimer_get(epc_page))
-			chunk[j++] = epc_page;
-		else
-			/* The owner is freeing the page. No need to add the
-			 * page back to the list of reclaimable pages.
-			 */
-			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+	epc_page = list_first_entry(&sgx_active_page_list,
+				    struct sgx_epc_page, list);
+	list_del_init(&epc_page->list);
+
+	if (!sgx_reclaimer_get(epc_page)) {
+		epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+		spin_unlock(&sgx_active_page_list_lock);
+		return ERR_PTR(-EBUSY);
 	}
-	spin_unlock(&sgx_active_page_list_lock);
 
-	for (i = 0; i < j; i++) {
-		epc_page = chunk[i];
-		if (sgx_reclaimer_evict(epc_page))
-			continue;
+	spin_unlock(&sgx_active_page_list_lock);
 
+	if (!sgx_reclaimer_evict(epc_page)) {
 		sgx_reclaimer_put(epc_page);
 
 		spin_lock(&sgx_active_page_list_lock);
 		list_add_tail(&epc_page->list, &sgx_active_page_list);
 		spin_unlock(&sgx_active_page_list_lock);
 
-		chunk[i] = NULL;
-	}
-
-	for (i = 0; i < j; i++) {
-		epc_page = chunk[i];
-		if (epc_page)
-			sgx_reclaimer_block(epc_page);
+		return ERR_PTR(-EBUSY);
 	}
 
-	for (i = 0; i < j; i++) {
-		epc_page = chunk[i];
-		if (epc_page) {
-			sgx_reclaimer_write(epc_page);
-			sgx_reclaimer_put(epc_page);
-			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+	sgx_reclaimer_block(epc_page);
+	sgx_reclaimer_write(epc_page);
+	sgx_reclaimer_put(epc_page);
 
-			section = sgx_epc_section(epc_page);
+	epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
 
-			spin_lock(&section->lock);
-			list_add_tail(&epc_page->list,
-				      &section->page_list);
-			section->free_cnt++;
-			spin_unlock(&section->lock);
-		}
-	}
+	return epc_page;
 }
 
 unsigned long sgx_calc_free_cnt(void)
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index f0ff7bd3d18e..faed25b2ccd6 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -79,7 +79,7 @@ extern spinlock_t sgx_active_page_list_lock;
 int sgx_page_reclaimer_init(void);
 void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
 unsigned long sgx_calc_free_cnt(void);
-void sgx_reclaim_pages(void);
+struct sgx_epc_page *sgx_reclaim_page(void);
 
 struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
 int __sgx_free_page(struct sgx_epc_page *page);
-- 
2.20.1

