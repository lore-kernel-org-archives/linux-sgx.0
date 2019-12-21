Return-Path: <SRS0=9G3N=2L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5C5C2D0D3
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6D962146E
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfLUAb7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Dec 2019 19:31:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:9723 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfLUAb7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Dec 2019 19:31:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 16:31:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="267658125"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Dec 2019 16:31:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 3/4] x86/sgx: Drop unused @encl parameter from __sgx_encl_ewb()
Date:   Fri, 20 Dec 2019 16:31:55 -0800
Message-Id: <20191221003156.27236-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221003156.27236-1-sean.j.christopherson@intel.com>
References: <20191221003156.27236-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove the unused @encl parameter from __sgx_encl_ewb() to help shorten
the line lengths of its call sites.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index c5c0ba92ab63..030b1c24da07 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -223,7 +223,7 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 	mutex_unlock(&encl->lock);
 }
 
-static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
+static int __sgx_encl_ewb(struct sgx_epc_page *epc_page,
 			  struct sgx_va_page *va_page, unsigned int va_offset,
 			  struct sgx_backing *backing)
 {
@@ -292,7 +292,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 	if (sgx_va_page_full(va_page))
 		list_move_tail(&va_page->list, &encl->va_pages);
 
-	ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset, backing);
+	ret = __sgx_encl_ewb(epc_page, va_page, va_offset, backing);
 	if (ret == SGX_NOT_TRACKED) {
 		ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
 		if (ret) {
@@ -300,8 +300,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 				ENCLS_WARN(ret, "ETRACK");
 		}
 
-		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
-				     backing);
+		ret = __sgx_encl_ewb(epc_page, va_page, va_offset, backing);
 		if (ret == SGX_NOT_TRACKED) {
 			/*
 			 * Slow path, send IPIs to kick cpus out of the
@@ -312,8 +311,8 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 			 */
 			on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
 					 sgx_ipi_cb, NULL, 1);
-			ret = __sgx_encl_ewb(encl, epc_page, va_page,
-					     va_offset, backing);
+			ret = __sgx_encl_ewb(epc_page, va_page, va_offset,
+					     backing);
 		}
 	}
 
-- 
2.24.1

