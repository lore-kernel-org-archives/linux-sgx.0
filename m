Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8635C49ED7
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DAA7214AF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfIPEP3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:15:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:16475 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEP3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:15:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:15:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387076103"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:15:25 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 13/17] x86/sgx: Introduce sgx_can_reclaim()
Date:   Mon, 16 Sep 2019 07:14:13 +0300
Message-Id: <20190916041417.12533-14-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Make sgx_reclaim_evict() idempotennt and rename it to sgx_can_reclaim() and
set SGX_ENCL_PAGE_RECLAIMED in the call site.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 32 +++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 46850d61c940..e2e2ff282eb3 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -121,7 +121,19 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
 	spin_unlock(&sgx_active_page_list_lock);
 }
 
-static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
+/**
+ * sgx_can_reclaim() - Filter out the pages that should not be reclaimed
+ * @epc_page:	a candidate EPC page
+ *
+ * Do not reclaim this page if it has been recently accessed by any mm_struct
+ * *and* if the enclave is still alive.  No need to take the enclave's lock,
+ * worst case scenario reclaiming pages from a dead enclave is delayed slightly.
+ * A live enclave with a recently accessed page is more common and avoiding lock
+ * contention in that case is a boon to performance.
+ *
+ * Return: true if the page should be reclaimed
+ */
+static bool sgx_can_reclaim(struct sgx_epc_page *epc_page)
 {
 	struct sgx_encl_page *page = epc_page->owner;
 	struct sgx_encl *encl = page->encl;
@@ -147,21 +159,9 @@ static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
 
 	srcu_read_unlock(&encl->srcu, idx);
 
-	/*
-	 * Do not reclaim this page if it has been recently accessed by any
-	 * mm_struct *and* if the enclave is still alive.  No need to take
-	 * the enclave's lock, worst case scenario reclaiming pages from a
-	 * dead enclave is delayed slightly.  A live enclave with a recently
-	 * accessed page is more common and avoiding lock contention in that
-	 * case is a boon to performance.
-	 */
 	if (!ret && !(atomic_read(&encl->flags) & SGX_ENCL_DEAD))
 		return false;
 
-	mutex_lock(&encl->lock);
-	page->desc |= SGX_ENCL_PAGE_RECLAIMED;
-	mutex_unlock(&encl->lock);
-
 	return true;
 }
 
@@ -405,8 +405,12 @@ void sgx_reclaim_pages(void)
 		epc_page = chunk[i];
 		encl_page = epc_page->owner;
 
-		if (sgx_reclaimer_evict(epc_page))
+		if (sgx_can_reclaim(epc_page)) {
+			mutex_lock(&encl_page->encl->lock);
+			encl_page->desc |= SGX_ENCL_PAGE_RECLAIMED;
+			mutex_unlock(&encl_page->encl->lock);
 			continue;
+		}
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 
-- 
2.20.1

