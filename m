Return-Path: <SRS0=RnOm=7L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D0DC433E3
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 973F62074D
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgE2RyN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 May 2020 13:54:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:51589 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727995AbgE2RyN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 May 2020 13:54:13 -0400
IronPort-SDR: STFjqM8/LLDoh8g+4tn8Hk2fn4tZtQcFCaHVoQUzTsgHjKPDz3fZjSyQ9ebCfhTqZm73WI47jv
 oz8h503Qx9XQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:54:09 -0700
IronPort-SDR: sNFY45LoKwNd9Q0nGxdo1e/UBNcVFa8KccohghfB7+nk9t4heND7HUokZZs+j5l3WvrDpZyF7l
 gG1eKyRnwz5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="271292336"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 29 May 2020 10:54:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v31 6/6] x86/sgx: Drop the message that fires when there are too many EPC sections
Date:   Fri, 29 May 2020 10:54:07 -0700
Message-Id: <20200529175407.2109-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200529175407.2109-1-sean.j.christopherson@intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Terminate the section loop with '<' instead of '<=' and drop the
associated pr_warn in sgx_page_cache_init().  Per Boris, there's no
point in warning the user if they can't do anything about it.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ba5486a1ef6f4..c51a3ad7fcce0 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -692,7 +692,7 @@ static bool __init sgx_page_cache_init(void)
 	u64 pa, size;
 	int i;
 
-	for (i = 0; i <= ARRAY_SIZE(sgx_epc_sections); i++) {
+	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
 		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
 			    &eax, &ebx, &ecx, &edx);
 
@@ -705,11 +705,6 @@ static bool __init sgx_page_cache_init(void)
 			break;
 		}
 
-		if (i == ARRAY_SIZE(sgx_epc_sections)) {
-			pr_warn("No free slot for an EPC section\n");
-			break;
-		}
-
 		pa = sgx_calc_section_metric(eax, ebx);
 		size = sgx_calc_section_metric(ecx, edx);
 
-- 
2.26.0

