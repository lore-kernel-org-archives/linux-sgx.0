Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177E4C4CECF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7A3B214C6
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfIPEPd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:15:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:16475 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEPd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:15:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:15:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387076111"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:15:30 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 14/17] x86/sgx: Replace section->free_cnt with a global sgx_nr_free_pages
Date:   Mon, 16 Sep 2019 07:14:14 +0300
Message-Id: <20190916041417.12533-15-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Replace section specific counters with a single gloal counter for free
pages. In effect, remove sgx_calc_free_cnt().

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c    | 11 ++++++-----
 arch/x86/kernel/cpu/sgx/reclaim.c | 18 ++----------------
 arch/x86/kernel/cpu/sgx/sgx.h     |  3 +--
 3 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4c03e5f33414..f37d28023b97 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -14,19 +14,20 @@
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 int sgx_nr_epc_sections;
+unsigned long sgx_nr_free_pages;
 
 static struct sgx_epc_page *sgx_section_try_take_page(
 	struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
 
-	if (!section->free_cnt)
+	if (list_empty(&section->page_list))
 		return NULL;
 
 	page = list_first_entry(&section->page_list, struct sgx_epc_page,
 				list);
 	list_del_init(&page->list);
-	section->free_cnt--;
+	sgx_nr_free_pages--;
 	return page;
 }
 
@@ -90,7 +91,7 @@ struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
 		schedule();
 	}
 
-	if (sgx_calc_free_cnt() < SGX_NR_LOW_PAGES)
+	if (sgx_nr_free_pages < SGX_NR_LOW_PAGES)
 		wake_up(&ksgxswapd_waitq);
 
 	return entry;
@@ -136,7 +137,7 @@ int __sgx_free_page(struct sgx_epc_page *page)
 
 	spin_lock(&section->lock);
 	list_add_tail(&page->list, &section->page_list);
-	section->free_cnt++;
+	sgx_nr_free_pages++;
 	spin_unlock(&section->lock);
 
 	return 0;
@@ -202,7 +203,7 @@ static __init int sgx_init_epc_section(u64 addr, u64 size, unsigned long index,
 			goto out;
 		page->desc = (addr + (i << PAGE_SHIFT)) | index;
 		list_add_tail(&page->list, &section->unsanitized_page_list);
-		section->free_cnt++;
+		sgx_nr_free_pages++;
 	}
 
 	return 0;
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index e2e2ff282eb3..e06e9489a5d1 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -64,7 +64,7 @@ static void sgx_sanitize_section(struct sgx_epc_section *section)
 
 static inline bool sgx_should_reclaim(void)
 {
-	return sgx_calc_free_cnt() < SGX_NR_HIGH_PAGES &&
+	return sgx_nr_free_pages < SGX_NR_HIGH_PAGES &&
 	       !list_empty(&sgx_active_page_list);
 }
 
@@ -440,22 +440,8 @@ void sgx_reclaim_pages(void)
 			spin_lock(&section->lock);
 			list_add_tail(&epc_page->list,
 				      &section->page_list);
-			section->free_cnt++;
+			sgx_nr_free_pages++;
 			spin_unlock(&section->lock);
 		}
 	}
 }
-
-unsigned long sgx_calc_free_cnt(void)
-{
-	struct sgx_epc_section *section;
-	unsigned long free_cnt = 0;
-	int i;
-
-	for (i = 0; i < sgx_nr_epc_sections; i++) {
-		section = &sgx_epc_sections[i];
-		free_cnt += section->free_cnt;
-	}
-
-	return free_cnt;
-}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 9b08690262b5..56d0bde3f4d8 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -30,7 +30,6 @@ struct sgx_epc_section {
 	void *va;
 	struct list_head page_list;
 	struct list_head unsanitized_page_list;
-	unsigned long free_cnt;
 	spinlock_t lock;
 };
 
@@ -72,6 +71,7 @@ static inline void *sgx_epc_addr(struct sgx_epc_page *page)
 #define SGX_NR_HIGH_PAGES	64
 
 extern int sgx_nr_epc_sections;
+extern unsigned long sgx_nr_free_pages;
 extern struct task_struct *ksgxswapd_tsk;
 extern struct wait_queue_head(ksgxswapd_waitq);
 extern struct list_head sgx_active_page_list;
@@ -79,7 +79,6 @@ extern spinlock_t sgx_active_page_list_lock;
 
 int sgx_page_reclaimer_init(void);
 void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
-unsigned long sgx_calc_free_cnt(void);
 void sgx_reclaim_pages(void);
 
 struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
-- 
2.20.1

