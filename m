Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1813FC49ED7
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF9F3214AF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfIPEPT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:15:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:16475 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEPT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:15:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:15:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387076073"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:15:16 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 10/17] x86/sgx: Free VA slot when the EWB flow fails
Date:   Mon, 16 Sep 2019 07:14:10 +0300
Message-Id: <20190916041417.12533-11-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Call sgx_free_va_slot() when the EWB flow fails. Otherwise, they will
leak in the failure case.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index a3e36f959c74..4ae6122c18e5 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -341,12 +341,15 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 		}
 	}
 
-	if (ret)
+	if (ret) {
 		if (encls_failed(ret) || encls_returned_code(ret))
 			ENCLS_WARN(ret, "EWB");
 
-	encl_page->desc |= va_offset;
-	encl_page->va_page = va_page;
+		sgx_free_va_slot(va_page, va_offset);
+	} else {
+		encl_page->desc |= va_offset;
+		encl_page->va_page = va_page;
+	}
 }
 
 static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
-- 
2.20.1

