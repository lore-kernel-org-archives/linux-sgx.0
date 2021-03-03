Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C1FC468C6
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Mar 2021 00:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84C9864F20
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Mar 2021 00:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240258AbhCDAtX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447611AbhCCPEg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 3 Mar 2021 10:04:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18FBA64EBA;
        Wed,  3 Mar 2021 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614783835;
        bh=yBmvpmeOGLU5Fa1QOt1rSOHLX/6JKqEaU3YnvsAyAi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fqj+3P+BrklhB1SVcdd+y8co6kKBS4uL15BR6h3Va06+eOgXWAmcb4P0U0G24bMiR
         /I5tAxA3ZwlShWkzbWWQw2moIyJ47YJwv7tBdkd/atn8Dh9PKdvgtmSM+htR7NuvuV
         u8kQh+IjLoVSjRJ7Fpw6z2WXv/Dz0Yx+Vi/qw6czYY8DsJ31GIHrW1eQmmiDVb19pH
         6Je/E2qVZl/S1/6gC2mlhpqesjRzM4d4wg8nH13CYQbJ/NeUsz9R8wymbXEpEMBWcp
         S4GWtbYC+8JmaUmcRw/W30ISfClv50iDLkCFE1zWXAeKe2bZXKaXDy2Hbb6Q3BN/q4
         FmFbt5WQqvQqA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] x86/sgx: Replace section->page_list with a global free page list
Date:   Wed,  3 Mar 2021 17:03:22 +0200
Message-Id: <20210303150323.433207-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210303150323.433207-1-jarkko@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Background
==========

EPC section is covered by one or more SRAT entries that are associated with
one and only one PXM (NUMA node). The current implementation overheats a
single NUMA node, because sgx_alloc_epc_page() always starts looking for
pages from the same EPC section everytime.

Only within a section it does pick pages in FIFO fashion, i.e. the oldest
freed in that section is the EPC page given back to the caller.  That does
not do any good, as the pages in the same node are performance-wise equal.

Solution
========

Replace local lists with a single global free page list, from which pages
are borrowed in FIFO fashion.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 84 +++++++++++-----------------------
 arch/x86/kernel/cpu/sgx/sgx.h  |  6 ---
 2 files changed, 27 insertions(+), 63 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index a649010949c2..58474480f5be 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -18,14 +18,15 @@ static int sgx_nr_epc_sections;
 static struct task_struct *ksgxd_tsk;
 static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
 
-/*
- * These variables are part of the state of the reclaimer, and must be accessed
- * with sgx_reclaimer_lock acquired.
- */
+/* The reclaimer lock protected variables prepend the lock. */
 static LIST_HEAD(sgx_active_page_list);
-
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
+/* The free page list lock protected variables prepend the lock. */
+static unsigned long sgx_nr_free_pages;
+static LIST_HEAD(sgx_free_page_list);
+static DEFINE_SPINLOCK(sgx_free_page_list_lock);
+
 /*
  * Reset dirty EPC pages to uninitialized state. Laundry can be left with SECS
  * pages whose child pages blocked EREMOVE.
@@ -379,21 +380,9 @@ static void sgx_reclaim_pages(void)
 	}
 }
 
-static unsigned long sgx_nr_free_pages(void)
-{
-	unsigned long cnt = 0;
-	int i;
-
-	for (i = 0; i < sgx_nr_epc_sections; i++)
-		cnt += sgx_epc_sections[i].free_cnt;
-
-	return cnt;
-}
-
 static bool sgx_should_reclaim(unsigned long watermark)
 {
-	return sgx_nr_free_pages() < watermark &&
-	       !list_empty(&sgx_active_page_list);
+	return sgx_nr_free_pages < watermark && !list_empty(&sgx_active_page_list);
 }
 
 static int ksgxd(void *p)
@@ -445,50 +434,34 @@ static bool __init sgx_page_reclaimer_init(struct list_head *laundry)
 	return true;
 }
 
-static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
-{
-	struct sgx_epc_page *page;
-
-	spin_lock(&section->lock);
-
-	if (list_empty(&section->page_list)) {
-		spin_unlock(&section->lock);
-		return NULL;
-	}
-
-	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
-	list_del_init(&page->list);
-	section->free_cnt--;
-
-	spin_unlock(&section->lock);
-	return page;
-}
-
 /**
  * __sgx_alloc_epc_page() - Allocate an EPC page
  *
- * Iterate through EPC sections and borrow a free EPC page to the caller. When a
- * page is no longer needed it must be released with sgx_free_epc_page().
+ * Borrow a free EPC page to the caller in FIFO fashion: the callers gets oldest
+ * freed page.
  *
  * Return:
- *   an EPC page,
- *   -errno on error
+ * - an EPC page:	Free EPC pages were available.
+ * - ERR_PTR(-ENOMEM):	Run out of EPC pages.
  */
 struct sgx_epc_page *__sgx_alloc_epc_page(void)
 {
-	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
-	int i;
 
-	for (i = 0; i < sgx_nr_epc_sections; i++) {
-		section = &sgx_epc_sections[i];
+	spin_lock(&sgx_free_page_list_lock);
 
-		page = __sgx_alloc_epc_page_from_section(section);
-		if (page)
-			return page;
+	if (list_empty(&sgx_free_page_list)) {
+		spin_unlock(&sgx_free_page_list_lock);
+		return NULL;
 	}
 
-	return ERR_PTR(-ENOMEM);
+	page = list_first_entry(&sgx_free_page_list, struct sgx_epc_page, list);
+	list_del_init(&page->list);
+	sgx_nr_free_pages--;
+
+	spin_unlock(&sgx_free_page_list_lock);
+
+	return page;
 }
 
 /**
@@ -593,7 +566,6 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
  */
 void sgx_free_epc_page(struct sgx_epc_page *page)
 {
-	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
 	int ret;
 
 	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
@@ -602,10 +574,10 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
 		return;
 
-	spin_lock(&section->lock);
-	list_add_tail(&page->list, &section->page_list);
-	section->free_cnt++;
-	spin_unlock(&section->lock);
+	spin_lock(&sgx_free_page_list_lock);
+	list_add_tail(&page->list, &sgx_free_page_list);
+	sgx_nr_free_pages++;
+	spin_unlock(&sgx_free_page_list_lock);
 }
 
 static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
@@ -627,8 +599,6 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	}
 
 	section->phys_addr = phys_addr;
-	spin_lock_init(&section->lock);
-	INIT_LIST_HEAD(&section->page_list);
 
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
@@ -637,7 +607,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		list_add_tail(&section->pages[i].list, laundry);
 	}
 
-	section->free_cnt = nr_pages;
+	sgx_nr_free_pages += nr_pages;
 	return true;
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index bc8af0428640..41ca045a574a 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -34,17 +34,11 @@ struct sgx_epc_page {
  * physical memory e.g. for memory areas of the each node. This structure is
  * used to store EPC pages for one EPC section and virtual memory area where
  * the pages have been mapped.
- *
- * 'lock' must be held before accessing 'page_list' or 'free_cnt'.
  */
 struct sgx_epc_section {
 	unsigned long phys_addr;
 	void *virt_addr;
 	struct sgx_epc_page *pages;
-
-	spinlock_t lock;
-	struct list_head page_list;
-	unsigned long free_cnt;
 };
 
 extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
-- 
2.30.1

