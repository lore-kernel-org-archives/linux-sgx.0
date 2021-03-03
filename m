Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFAFC15520
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Mar 2021 00:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94DA964F4C
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Mar 2021 00:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbhCDAtX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447610AbhCCPEh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 3 Mar 2021 10:04:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BA2464EE9;
        Wed,  3 Mar 2021 15:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614783832;
        bh=MO/4TL7dKn9BPVSY9M+hxMlpKkSMe6bLuTcinRADrCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKzhxaB5TmNpFMODWSdY/R4EV5QySIRdQSeX6UofNa7UD4WmROYsBLAU3gZovwPiq
         JcPj1m8HmhaCvtVj8hzC7U89azQ1rAxfFj3vWC1xqza6xe/cUCZ95ubIt8u6gHxlf7
         xHSuXPpuU/NIFqWBxJv8gguEubWm3+KdS/MYLApnDHMnPD1S2VdFw7WXkHEZYSr79B
         fiKMqPa/rogG9PvO6IVNUwg/BluQ6TXC9nS/boL2ET27Bh6BeZXjtJkjSj5hEJjyrI
         SGsX/3+QJUrziqYnSO7XfAd2nRCR4ybM+KsNnWWt4L4HOixfb1EORqkT9ulpdlUoBi
         sM5oj+jb6DvuA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/5] x86/sgx: Replace section->init_laundry_list with a temp list
Date:   Wed,  3 Mar 2021 17:03:21 +0200
Message-Id: <20210303150323.433207-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210303150323.433207-1-jarkko@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Build a local laundry list in sgx_init(), and transfer its ownsership to
ksgxd for sanitization, thus getting rid of useless member in struct
sgx_epc_section.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 64 ++++++++++++++++++----------------
 arch/x86/kernel/cpu/sgx/sgx.h  |  7 ----
 2 files changed, 34 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ed99c60024dc..a649010949c2 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -30,35 +30,33 @@ static DEFINE_SPINLOCK(sgx_reclaimer_lock);
  * Reset dirty EPC pages to uninitialized state. Laundry can be left with SECS
  * pages whose child pages blocked EREMOVE.
  */
-static void sgx_sanitize_section(struct sgx_epc_section *section)
+static void sgx_sanitize_section(struct list_head *laundry)
 {
 	struct sgx_epc_page *page;
 	LIST_HEAD(dirty);
 	int ret;
 
 	/* init_laundry_list is thread-local, no need for a lock: */
-	while (!list_empty(&section->init_laundry_list)) {
+	while (!list_empty(laundry)) {
 		if (kthread_should_stop())
 			return;
 
-		/* needed for access to ->page_list: */
-		spin_lock(&section->lock);
-
-		page = list_first_entry(&section->init_laundry_list,
-					struct sgx_epc_page, list);
+		page = list_first_entry(laundry, struct sgx_epc_page, list);
 
 		ret = __eremove(sgx_get_epc_virt_addr(page));
-		if (!ret)
-			list_move(&page->list, &section->page_list);
-		else
+		if (!ret) {
+			/* The page is clean - move to the free list. */
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
+	list_splice(&dirty, laundry);
 }
 
 static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
@@ -400,6 +398,7 @@ static bool sgx_should_reclaim(unsigned long watermark)
 
 static int ksgxd(void *p)
 {
+	struct list_head *laundry = p;
 	int i;
 
 	set_freezable();
@@ -408,16 +407,13 @@ static int ksgxd(void *p)
 	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
 	 * required for SECS pages, whose child pages blocked EREMOVE.
 	 */
-	for (i = 0; i < sgx_nr_epc_sections; i++)
-		sgx_sanitize_section(&sgx_epc_sections[i]);
+	sgx_sanitize_section(laundry);
+	sgx_sanitize_section(laundry);
 
-	for (i = 0; i < sgx_nr_epc_sections; i++) {
-		sgx_sanitize_section(&sgx_epc_sections[i]);
+	if (!list_empty(laundry))
+		WARN(1, "EPC section %d has unsanitized pages.\n", i);
 
-		/* Should never happen. */
-		if (!list_empty(&sgx_epc_sections[i].init_laundry_list))
-			WARN(1, "EPC section %d has unsanitized pages.\n", i);
-	}
+	kfree(laundry);
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
@@ -436,11 +432,11 @@ static int ksgxd(void *p)
 	return 0;
 }
 
-static bool __init sgx_page_reclaimer_init(void)
+static bool __init sgx_page_reclaimer_init(struct list_head *laundry)
 {
 	struct task_struct *tsk;
 
-	tsk = kthread_run(ksgxd, NULL, "ksgxd");
+	tsk = kthread_run(ksgxd, laundry, "ksgxd");
 	if (IS_ERR(tsk))
 		return false;
 
@@ -614,7 +610,8 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 
 static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 					 unsigned long index,
-					 struct sgx_epc_section *section)
+					 struct sgx_epc_section *section,
+					 struct list_head *laundry)
 {
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	unsigned long i;
@@ -632,13 +629,12 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	section->phys_addr = phys_addr;
 	spin_lock_init(&section->lock);
 	INIT_LIST_HEAD(&section->page_list);
-	INIT_LIST_HEAD(&section->init_laundry_list);
 
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
 		section->pages[i].flags = 0;
 		section->pages[i].owner = NULL;
-		list_add_tail(&section->pages[i].list, &section->init_laundry_list);
+		list_add_tail(&section->pages[i].list, laundry);
 	}
 
 	section->free_cnt = nr_pages;
@@ -656,7 +652,7 @@ static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
 	       ((high & GENMASK_ULL(19, 0)) << 32);
 }
 
-static bool __init sgx_page_cache_init(void)
+static bool __init sgx_page_cache_init(struct list_head *laundry)
 {
 	u32 eax, ebx, ecx, edx, type;
 	u64 pa, size;
@@ -679,7 +675,7 @@ static bool __init sgx_page_cache_init(void)
 
 		pr_info("EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
 
-		if (!sgx_setup_epc_section(pa, size, i, &sgx_epc_sections[i])) {
+		if (!sgx_setup_epc_section(pa, size, i, &sgx_epc_sections[i], laundry)) {
 			pr_err("No free memory for an EPC section\n");
 			break;
 		}
@@ -697,18 +693,25 @@ static bool __init sgx_page_cache_init(void)
 
 static int __init sgx_init(void)
 {
+	struct list_head *laundry;
 	int ret;
 	int i;
 
 	if (!cpu_feature_enabled(X86_FEATURE_SGX))
 		return -ENODEV;
 
-	if (!sgx_page_cache_init()) {
+	laundry = kzalloc(sizeof(*laundry), GFP_KERNEL);
+	if (!laundry)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(laundry);
+
+	if (!sgx_page_cache_init(laundry)) {
 		ret = -ENOMEM;
 		goto err_page_cache;
 	}
 
-	if (!sgx_page_reclaimer_init()) {
+	if (!sgx_page_reclaimer_init(laundry)) {
 		ret = -ENOMEM;
 		goto err_page_cache;
 	}
@@ -728,6 +731,7 @@ static int __init sgx_init(void)
 		memunmap(sgx_epc_sections[i].virt_addr);
 	}
 
+	kfree(laundry);
 	return ret;
 }
 
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
2.30.1

