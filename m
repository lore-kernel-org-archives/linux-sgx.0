Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC666C4CEC7
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C488520873
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbfIPEOs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:14:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:4080 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEOs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:14:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:14:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387075942"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:14:45 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 04/17] x86/sgx: Rename 'j' as 'cnt' in sgx_reclaim_pages()
Date:   Mon, 16 Sep 2019 07:14:04 +0300
Message-Id: <20190916041417.12533-5-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

It is better to have more descriptive name than 'j' for the associated
local variable in sgx_reclaim_pages() as it does not represent just a
trivial loop index like 'i' does. Thus, rename it as 'cnt'.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 213406756443..cfda38a9b05c 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -403,12 +403,13 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
 void sgx_reclaim_pages(void)
 {
 	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];
-	struct sgx_epc_page *epc_page;
 	struct sgx_epc_section *section;
-	int i, j;
+	struct sgx_epc_page *epc_page;
+	int cnt = 0;
+	int i;
 
 	spin_lock(&sgx_active_page_list_lock);
-	for (i = 0, j = 0; i < SGX_NR_TO_SCAN; i++) {
+	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
 		if (list_empty(&sgx_active_page_list))
 			break;
 
@@ -417,7 +418,7 @@ void sgx_reclaim_pages(void)
 		list_del_init(&epc_page->list);
 
 		if (sgx_reclaimer_get(epc_page))
-			chunk[j++] = epc_page;
+			chunk[cnt++] = epc_page;
 		else
 			/* The owner is freeing the page. No need to add the
 			 * page back to the list of reclaimable pages.
@@ -426,7 +427,7 @@ void sgx_reclaim_pages(void)
 	}
 	spin_unlock(&sgx_active_page_list_lock);
 
-	for (i = 0; i < j; i++) {
+	for (i = 0; i < cnt; i++) {
 		epc_page = chunk[i];
 		if (sgx_reclaimer_evict(epc_page))
 			continue;
@@ -440,13 +441,13 @@ void sgx_reclaim_pages(void)
 		chunk[i] = NULL;
 	}
 
-	for (i = 0; i < j; i++) {
+	for (i = 0; i < cnt; i++) {
 		epc_page = chunk[i];
 		if (epc_page)
 			sgx_reclaimer_block(epc_page);
 	}
 
-	for (i = 0; i < j; i++) {
+	for (i = 0; i < cnt; i++) {
 		epc_page = chunk[i];
 		if (epc_page) {
 			sgx_reclaimer_write(epc_page);
-- 
2.20.1

