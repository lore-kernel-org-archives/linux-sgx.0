Return-Path: <SRS0=E9YI=32=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2425FC33CAC
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Feb 2020 16:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3D93217BA
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Feb 2020 16:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgBFQP6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Feb 2020 11:15:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:1531 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbgBFQP6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 6 Feb 2020 11:15:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 08:15:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="220485811"
Received: from dgbrowne-mobl.ger.corp.intel.com (HELO localhost) ([10.252.14.106])
  by orsmga007.jf.intel.com with ESMTP; 06 Feb 2020 08:15:56 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] x86/sgx: Sanitize pages in two rounds
Date:   Thu,  6 Feb 2020 18:15:50 +0200
Message-Id: <20200206161550.5920-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

WARN_ONCE() can trigger after kexec() on systems with multiple EPC
sections. This can happen when an enclave has a SECS page in some section
and child pages in a section processed after the section containing the
SECS page. CPU does not allow to remove SECS before all of its children
have been removed.

Fix this by removing the tail from sgx_sanitize_section() and iterate
sections in two rounds by calling the resulting function.

Finally, report to the user space only after all processing has been
done and not in the middle of processing as before. This improves the
quality of reporting as kernel can tell how many unsanitized pages in
each section was left unprocessed.

Cc: x86@kernel.org
Reported-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
This is a patch to fix the issue in the version 25 of the SGX patch set.

Apply against https://github.com/jsakkine-intel/linux-sgx.git.
 arch/x86/kernel/cpu/sgx/reclaim.c | 38 ++++++++++++++-----------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index a33f1c45477a..5a88e1c388b5 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -18,10 +18,6 @@ DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
 LIST_HEAD(sgx_active_page_list);
 DEFINE_SPINLOCK(sgx_active_page_list_lock);
 
-/*
- * Reset all pages to uninitialized state. Pages could be in initialized on
- * kmemexec.
- */
 static void sgx_sanitize_section(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page, *tmp;
@@ -47,23 +43,6 @@ static void sgx_sanitize_section(struct sgx_epc_section *section)
 
 		cond_resched();
 	}
-
-	list_for_each_entry_safe(page, tmp, &secs_list, list) {
-		if (kthread_should_stop())
-			return;
-
-		ret = __eremove(sgx_epc_addr(page));
-		if (!WARN_ON_ONCE(ret)) {
-			spin_lock(&section->lock);
-			list_move(&page->list, &section->page_list);
-			spin_unlock(&section->lock);
-		} else {
-			list_del(&page->list);
-			kfree(page);
-		}
-
-		cond_resched();
-	}
 }
 
 static int ksgxswapd(void *p)
@@ -72,9 +51,26 @@ static int ksgxswapd(void *p)
 
 	set_freezable();
 
+	/*
+	 * Reset all pages to uninitialized state. Pages could be in initialized
+	 * on kmemexec.
+	 */
+	for (i = 0; i < sgx_nr_epc_sections; i++)
+		sgx_sanitize_section(&sgx_epc_sections[i]);
+
+	/*
+	 * 2nd round for the SECS pages as they cannot be removed when they
+	 * still hold child pages.
+	 */
 	for (i = 0; i < sgx_nr_epc_sections; i++)
 		sgx_sanitize_section(&sgx_epc_sections[i]);
 
+	/* Check that all pages were removed. */
+	for (i = 0; i < sgx_nr_epc_sections; i++) {
+		if (!list_empty(&sgx_epc_sections[i].unsanitized_page_list))
+			WARN(1, "EPC section %d has unsanitized pages.\n", i);
+	}
+
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
 			continue;
-- 
2.20.1

