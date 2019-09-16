Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D30C49ED7
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 201FE214AF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfIPEPH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:15:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:4080 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEPH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:15:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:15:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387076034"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:15:03 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 08/17] x86/sgx: Calculate page index in sgx_reclaimer_write()
Date:   Mon, 16 Sep 2019 07:14:08 +0300
Message-Id: <20190916041417.12533-9-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move page index calculation for backing storage to sgx_reclaimer_write()
as it somewhat simplifies the flow and makes it also easier to control
as the high level write logic is consolidated to a single function.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 33 +++++++++----------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 353888256b2b..e758a06919e4 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -222,26 +222,15 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 
 static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
 			  struct sgx_va_page *va_page, unsigned int va_offset,
-			  unsigned int pt)
+			  unsigned int page_index)
 {
-	struct sgx_encl_page *encl_page = epc_page->owner;
 	struct sgx_pageinfo pginfo;
 	unsigned long pcmd_offset;
 	struct page *backing;
-	pgoff_t page_index;
 	pgoff_t pcmd_index;
 	struct page *pcmd;
 	int ret;
 
-	if (pt != SGX_SECINFO_SECS && pt != SGX_SECINFO_TCS &&
-	    pt != SGX_SECINFO_REG)
-		return -EINVAL;
-
-	if (pt == SGX_SECINFO_SECS)
-		page_index = PFN_DOWN(encl->size);
-	else
-		page_index = SGX_ENCL_PAGE_INDEX(encl_page);
-
 	pcmd_index = sgx_pcmd_index(encl, page_index);
 	pcmd_offset = sgx_pcmd_offset(page_index);
 
@@ -308,7 +297,8 @@ static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
 	return cpumask;
 }
 
-static void sgx_encl_ewb(struct sgx_epc_page *epc_page, unsigned int pt)
+static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
+			 unsigned int page_index)
 {
 	struct sgx_encl_page *encl_page = epc_page->owner;
 	struct sgx_encl *encl = encl_page->encl;
@@ -325,7 +315,8 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, unsigned int pt)
 		if (sgx_va_page_full(va_page))
 			list_move_tail(&va_page->list, &encl->va_pages);
 
-		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset, pt);
+		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
+				     page_index);
 		if (ret == SGX_NOT_TRACKED) {
 			ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
 			if (ret) {
@@ -335,7 +326,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, unsigned int pt)
 			}
 
 			ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
-					     pt);
+					     page_index);
 			if (ret == SGX_NOT_TRACKED) {
 				/*
 				 * Slow path, send IPIs to kick cpus out of the
@@ -347,7 +338,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, unsigned int pt)
 				on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
 						 sgx_ipi_cb, NULL, 1);
 				ret = __sgx_encl_ewb(encl, epc_page, va_page,
-						     va_offset, pt);
+						     va_offset, page_index);
 			}
 		}
 
@@ -364,17 +355,11 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
 {
 	struct sgx_encl_page *encl_page = epc_page->owner;
 	struct sgx_encl *encl = encl_page->encl;
-	unsigned int pt;
 	int ret;
 
-	if (encl_page->desc & SGX_ENCL_PAGE_TCS)
-		pt = SGX_SECINFO_TCS;
-	else
-		pt = SGX_SECINFO_REG;
-
 	mutex_lock(&encl->lock);
 
-	sgx_encl_ewb(epc_page, pt);
+	sgx_encl_ewb(epc_page, SGX_ENCL_PAGE_INDEX(encl_page));
 	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
 		ret = __eremove(sgx_epc_addr(epc_page));
 		WARN(ret, "EREMOVE returned %d\n", ret);
@@ -386,7 +371,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
 	if (!encl->secs_child_cnt &&
 	    (atomic_read(&encl->flags) &
 	     (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED))) {
-		sgx_encl_ewb(encl->secs.epc_page, SGX_SECINFO_SECS);
+		sgx_encl_ewb(encl->secs.epc_page, PFN_DOWN(encl->size));
 		sgx_free_page(encl->secs.epc_page);
 
 		encl->secs.epc_page = NULL;
-- 
2.20.1

