Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96230C4CECF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75AD4214AF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfIPEPM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:15:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:4080 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEPM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:15:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:15:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387076057"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:15:08 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 09/17] x86/sgx: Move SGX_ENCL_DEAD check to sgx_reclaimer_write()
Date:   Mon, 16 Sep 2019 07:14:09 +0300
Message-Id: <20190916041417.12533-10-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Do enclave state checks only in sgx_reclaimer_write(). Checking the
enclave state is not part of the sgx_encl_ewb() flow. The check is done
differently for SECS and for addressable pages.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 69 +++++++++++++++----------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index e758a06919e4..a3e36f959c74 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -308,47 +308,45 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 
 	encl_page->desc &= ~SGX_ENCL_PAGE_RECLAIMED;
 
-	if (!(atomic_read(&encl->flags) & SGX_ENCL_DEAD)) {
-		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
-					   list);
-		va_offset = sgx_alloc_va_slot(va_page);
-		if (sgx_va_page_full(va_page))
-			list_move_tail(&va_page->list, &encl->va_pages);
+	va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
+				   list);
+	va_offset = sgx_alloc_va_slot(va_page);
+	if (sgx_va_page_full(va_page))
+		list_move_tail(&va_page->list, &encl->va_pages);
+
+	ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
+			     page_index);
+	if (ret == SGX_NOT_TRACKED) {
+		ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
+		if (ret) {
+			if (encls_failed(ret) ||
+			    encls_returned_code(ret))
+				ENCLS_WARN(ret, "ETRACK");
+		}
 
 		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
 				     page_index);
 		if (ret == SGX_NOT_TRACKED) {
-			ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
-			if (ret) {
-				if (encls_failed(ret) ||
-				    encls_returned_code(ret))
-					ENCLS_WARN(ret, "ETRACK");
-			}
-
-			ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
-					     page_index);
-			if (ret == SGX_NOT_TRACKED) {
-				/*
-				 * Slow path, send IPIs to kick cpus out of the
-				 * enclave.  Note, it's imperative that the cpu
-				 * mask is generated *after* ETRACK, else we'll
-				 * miss cpus that entered the enclave between
-				 * generating the mask and incrementing epoch.
-				 */
-				on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
-						 sgx_ipi_cb, NULL, 1);
-				ret = __sgx_encl_ewb(encl, epc_page, va_page,
-						     va_offset, page_index);
-			}
+			/*
+			 * Slow path, send IPIs to kick cpus out of the
+			 * enclave.  Note, it's imperative that the cpu
+			 * mask is generated *after* ETRACK, else we'll
+			 * miss cpus that entered the enclave between
+			 * generating the mask and incrementing epoch.
+			 */
+			on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
+					 sgx_ipi_cb, NULL, 1);
+			ret = __sgx_encl_ewb(encl, epc_page, va_page,
+					     va_offset, page_index);
 		}
+	}
 
-		if (ret)
-			if (encls_failed(ret) || encls_returned_code(ret))
-				ENCLS_WARN(ret, "EWB");
+	if (ret)
+		if (encls_failed(ret) || encls_returned_code(ret))
+			ENCLS_WARN(ret, "EWB");
 
-		encl_page->desc |= va_offset;
-		encl_page->va_page = va_page;
-	}
+	encl_page->desc |= va_offset;
+	encl_page->va_page = va_page;
 }
 
 static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
@@ -359,10 +357,11 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
 
 	mutex_lock(&encl->lock);
 
-	sgx_encl_ewb(epc_page, SGX_ENCL_PAGE_INDEX(encl_page));
 	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
 		ret = __eremove(sgx_epc_addr(epc_page));
 		WARN(ret, "EREMOVE returned %d\n", ret);
+	} else {
+		sgx_encl_ewb(epc_page, SGX_ENCL_PAGE_INDEX(encl_page));
 	}
 
 	encl_page->epc_page = NULL;
-- 
2.20.1

