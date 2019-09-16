Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B779DC4CECF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9406E214AF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfIPEPY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:15:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:16475 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEPY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:15:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387076090"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:15:22 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 12/17] x86/sgx: Open code sgx_reclaimer_get() and sgx_reclaimer_put()
Date:   Mon, 16 Sep 2019 07:14:12 +0300
Message-Id: <20190916041417.12533-13-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Open code sgx_reclaimer_get() and sgx_reclaimer_put(). They are legacy
from the callback interface. Wrapping a function call inside a function
does not make sense.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index c2a85db68307..46850d61c940 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -121,22 +121,6 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
 	spin_unlock(&sgx_active_page_list_lock);
 }
 
-bool sgx_reclaimer_get(struct sgx_epc_page *epc_page)
-{
-	struct sgx_encl_page *encl_page = epc_page->owner;
-	struct sgx_encl *encl = encl_page->encl;
-
-	return kref_get_unless_zero(&encl->refcount) != 0;
-}
-
-void sgx_reclaimer_put(struct sgx_epc_page *epc_page)
-{
-	struct sgx_encl_page *encl_page = epc_page->owner;
-	struct sgx_encl *encl = encl_page->encl;
-
-	kref_put(&encl->refcount, sgx_encl_release);
-}
-
 static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
 {
 	struct sgx_encl_page *page = epc_page->owner;
@@ -392,6 +376,7 @@ void sgx_reclaim_pages(void)
 {
 	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];
 	struct sgx_epc_section *section;
+	struct sgx_encl_page *encl_page;
 	struct sgx_epc_page *epc_page;
 	int cnt = 0;
 	int i;
@@ -404,8 +389,9 @@ void sgx_reclaim_pages(void)
 		epc_page = list_first_entry(&sgx_active_page_list,
 					    struct sgx_epc_page, list);
 		list_del_init(&epc_page->list);
+		encl_page = epc_page->owner;
 
-		if (sgx_reclaimer_get(epc_page))
+		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
 			chunk[cnt++] = epc_page;
 		else
 			/* The owner is freeing the page. No need to add the
@@ -417,10 +403,12 @@ void sgx_reclaim_pages(void)
 
 	for (i = 0; i < cnt; i++) {
 		epc_page = chunk[i];
+		encl_page = epc_page->owner;
+
 		if (sgx_reclaimer_evict(epc_page))
 			continue;
 
-		sgx_reclaimer_put(epc_page);
+		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 
 		spin_lock(&sgx_active_page_list_lock);
 		list_add_tail(&epc_page->list, &sgx_active_page_list);
@@ -437,13 +425,14 @@ void sgx_reclaim_pages(void)
 
 	for (i = 0; i < cnt; i++) {
 		epc_page = chunk[i];
+		encl_page = epc_page->owner;
+
 		if (epc_page) {
 			sgx_reclaimer_write(epc_page);
-			sgx_reclaimer_put(epc_page);
+			kref_put(&encl_page->encl->refcount, sgx_encl_release);
 			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
 
 			section = sgx_epc_section(epc_page);
-
 			spin_lock(&section->lock);
 			list_add_tail(&epc_page->list,
 				      &section->page_list);
-- 
2.20.1

