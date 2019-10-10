Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575BCECE597
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 21:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C00B20B7C
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 21:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfJJVnG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:43:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:35146 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfJJVnE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 17:43:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 14:43:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="194145503"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 10 Oct 2019 14:43:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 9/9] x86/sgx: Reinstate per EPC section free page counts
Date:   Thu, 10 Oct 2019 14:43:01 -0700
Message-Id: <20191010214301.25669-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191010214301.25669-1-sean.j.christopherson@intel.com>
References: <20191010214301.25669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Track the free page count on a per EPC section basis so that the value
is properly protected by the section's spinlock.

As was pointed out when the change was proposed[*], using a global
non-atomic counter to track the number of free EPC pages is not safe.
The order of non-atomic reads and writes are not guaranteed, i.e.
concurrent RMW operats can write stale data.  This causes a variety
of bad behavior, e.g. livelocks because the free page count wraps and
causes the swap thread to stop reclaiming.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c    | 11 +++++------
 arch/x86/kernel/cpu/sgx/reclaim.c |  4 ++--
 arch/x86/kernel/cpu/sgx/sgx.h     | 18 +++++++++++++++++-
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 48a4f37b5b3c..cc87690fa1ec 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -13,18 +13,17 @@
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 int sgx_nr_epc_sections;
-unsigned long sgx_nr_free_pages;
 
 static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
 
-	if (list_empty(&section->page_list))
+	if (!section->free_cnt)
 		return NULL;
 
 	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
 	list_del_init(&page->list);
-	sgx_nr_free_pages--;
+	section->free_cnt--;
 	return page;
 }
 
@@ -97,7 +96,7 @@ struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
 		schedule();
 	}
 
-	if (sgx_nr_free_pages < SGX_NR_LOW_PAGES)
+	if (!sgx_at_least_N_free_pages(SGX_NR_LOW_PAGES))
 		wake_up(&ksgxswapd_waitq);
 
 	return entry;
@@ -131,7 +130,7 @@ void __sgx_free_page(struct sgx_epc_page *page)
 
 	spin_lock(&section->lock);
 	list_add_tail(&page->list, &section->page_list);
-	sgx_nr_free_pages++;
+	section->free_cnt++;
 	spin_unlock(&section->lock);
 
 }
@@ -218,7 +217,7 @@ static bool __init sgx_alloc_epc_section(u64 addr, u64 size,
 		list_add_tail(&page->list, &section->unsanitized_page_list);
 	}
 
-	sgx_nr_free_pages += nr_pages;
+	section->free_cnt = nr_pages;
 
 	return true;
 
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 3f183dd0e653..8619141f4bed 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -68,7 +68,7 @@ static void sgx_sanitize_section(struct sgx_epc_section *section)
 
 static inline bool sgx_should_reclaim(void)
 {
-	return sgx_nr_free_pages < SGX_NR_HIGH_PAGES &&
+	return !sgx_at_least_N_free_pages(SGX_NR_HIGH_PAGES) &&
 	       !list_empty(&sgx_active_page_list);
 }
 
@@ -430,7 +430,7 @@ void sgx_reclaim_pages(void)
 		section = sgx_epc_section(epc_page);
 		spin_lock(&section->lock);
 		list_add_tail(&epc_page->list, &section->page_list);
-		sgx_nr_free_pages++;
+		section->free_cnt++;
 		spin_unlock(&section->lock);
 	}
 }
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 87e375e8c25e..c7f0277299f6 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -30,6 +30,7 @@ struct sgx_epc_page {
 struct sgx_epc_section {
 	unsigned long pa;
 	void *va;
+	unsigned long free_cnt;
 	struct list_head page_list;
 	struct list_head unsanitized_page_list;
 	spinlock_t lock;
@@ -73,12 +74,27 @@ static inline void *sgx_epc_addr(struct sgx_epc_page *page)
 #define SGX_NR_HIGH_PAGES	64
 
 extern int sgx_nr_epc_sections;
-extern unsigned long sgx_nr_free_pages;
 extern struct task_struct *ksgxswapd_tsk;
 extern struct wait_queue_head(ksgxswapd_waitq);
 extern struct list_head sgx_active_page_list;
 extern spinlock_t sgx_active_page_list_lock;
 
+static inline bool sgx_at_least_N_free_pages(unsigned long threshold)
+{
+	struct sgx_epc_section *section;
+	unsigned long free_cnt = 0;
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_sections; i++) {
+		section = &sgx_epc_sections[i];
+		free_cnt += section->free_cnt;
+		if (free_cnt >= threshold)
+			return true;
+	}
+
+	return false;
+}
+
 bool __init sgx_page_reclaimer_init(void);
 void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
 void sgx_reclaim_pages(void);
-- 
2.22.0

