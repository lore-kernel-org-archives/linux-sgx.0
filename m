Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1F4C433DB
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Mar 2021 16:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D5D64F1A
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Mar 2021 16:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhCMQCD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Mar 2021 11:02:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233877AbhCMQBx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Mar 2021 11:01:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BD1764F1F;
        Sat, 13 Mar 2021 16:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615651312;
        bh=wmiEWoBzQNM3kPcwlo3+3IWPepCWiqpC8Zche8xBDYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IM6sBEa8fGiwbXLenDS/vV4tPQvACmAhui6k27fpOxzCFX+gWm++txshNnyhPcbtK
         TICkUL39V6AJpSW9TYyO8wbCpVuGDKzA19vz6qSBelNmDCUSgh3C5CeywjUOAxWy+D
         XDSvugAm+OUehdlXbJOMuidYSfN3NxkfZjJuL93JJPXu7R3eMyX5qVbfH+4ro/PrmW
         oqB3815FNbu2txcdAhTlIv0iv2Jis5+6r6FUcuLgklflOS0VH94CRubQvaYFAfFzrJ
         7Xm6QKhSOxmLewWU/L+VbtNvIfIdMcKQcb3y4KLAdfdX8qrEJS+cMc9OC046lgk9oc
         QfD/h91OdJpwQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] x86/sgx: Replace section local dirty page lists with a global list
Date:   Sat, 13 Mar 2021 18:01:18 +0200
Message-Id: <20210313160119.1318533-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313160119.1318533-1-jarkko@kernel.org>
References: <20210313160119.1318533-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Reset initialized EPC pages in sgx_dirty_page_list to uninitialized state,
and free them using sgx_free_epc_page(). Do two passes, as for SECS pages
the first round can fail, if all child pages have not yet been removed.
The driver puts all pages on startup first to sgx_dirty_page_list, as the
initialization could be triggered by kexec(), meaning that pages have been
reserved for active enclaves before the operation.

The section local lists are redundant, as sgx_free_epc_page() figures
out the correction by using epc_page->section.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---

v4:
* Open coded sgx_santize_section() to ksgxd().
* Rewrote the commit message.

 arch/x86/kernel/cpu/sgx/main.c | 81 ++++++++++++++++------------------
 arch/x86/kernel/cpu/sgx/sgx.h  |  7 ---
 2 files changed, 37 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 65004fb8a91f..cb4561444b96 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -27,39 +27,10 @@ static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
 /*
- * Reset dirty EPC pages to uninitialized state. Laundry can be left with SECS
- * pages whose child pages blocked EREMOVE.
+ * When the driver initialized, EPC pages go first here, as they could be
+ * initialized to an active enclave, on kexec entry.
  */
-static void sgx_sanitize_section(struct sgx_epc_section *section)
-{
-	struct sgx_epc_page *page;
-	LIST_HEAD(dirty);
-	int ret;
-
-	/* init_laundry_list is thread-local, no need for a lock: */
-	while (!list_empty(&section->init_laundry_list)) {
-		if (kthread_should_stop())
-			return;
-
-		/* needed for access to ->page_list: */
-		spin_lock(&section->lock);
-
-		page = list_first_entry(&section->init_laundry_list,
-					struct sgx_epc_page, list);
-
-		ret = __eremove(sgx_get_epc_virt_addr(page));
-		if (!ret)
-			list_move(&page->list, &section->page_list);
-		else
-			list_move_tail(&page->list, &dirty);
-
-		spin_unlock(&section->lock);
-
-		cond_resched();
-	}
-
-	list_splice(&dirty, &section->init_laundry_list);
-}
+static LIST_HEAD(sgx_dirty_page_list);
 
 static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
 {
@@ -400,25 +371,48 @@ static bool sgx_should_reclaim(unsigned long watermark)
 
 static int ksgxd(void *p)
 {
-	int i;
+	struct sgx_epc_page *page;
+	LIST_HEAD(dirty);
+	int i, ret;
 
 	set_freezable();
 
 	/*
-	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
-	 * required for SECS pages, whose child pages blocked EREMOVE.
+	 * Reset initialized EPC pages in sgx_dirty_page_list to uninitialized state,
+	 * and free them using sgx_free_epc_page(). Do two passes, as for SECS pages the
+	 * first round can fail, if all child pages have not yet been removed.  The
+	 * driver puts all pages on startup first to sgx_dirty_page_list, as the
+	 * initialization could be triggered by kexec(), meaning that pages have been
+	 * reserved for active enclaves before the operation.
 	 */
-	for (i = 0; i < sgx_nr_epc_sections; i++)
-		sgx_sanitize_section(&sgx_epc_sections[i]);
 
-	for (i = 0; i < sgx_nr_epc_sections; i++) {
-		sgx_sanitize_section(&sgx_epc_sections[i]);
+	/* sgx_dirty_page_list is thread-local to ksgxd, no need for a lock: */
+	for (i = 0; i < 2 && !list_empty(&sgx_dirty_page_list); i++) {
+		while (!list_empty(&sgx_dirty_page_list)) {
+			if (kthread_should_stop())
+				return 0;
+
+			page = list_first_entry(&sgx_dirty_page_list, struct sgx_epc_page, list);
+
+			ret = __eremove(sgx_get_epc_virt_addr(page));
+			if (!ret) {
+				/* The page is clean - move to the free list. */
+				list_del(&page->list);
+				sgx_free_epc_page(page);
+			} else {
+				/* The page is not yet clean - move to the dirty list. */
+				list_move_tail(&page->list, &dirty);
+			}
+
+			cond_resched();
+		}
 
-		/* Should never happen. */
-		if (!list_empty(&sgx_epc_sections[i].init_laundry_list))
-			WARN(1, "EPC section %d has unsanitized pages.\n", i);
+		list_splice(&dirty, &sgx_dirty_page_list);
 	}
 
+	if (!list_empty(&sgx_dirty_page_list))
+		WARN(1, "EPC section %d has unsanitized pages.\n", i);
+
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
 			continue;
@@ -632,13 +626,12 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
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
2.30.2

