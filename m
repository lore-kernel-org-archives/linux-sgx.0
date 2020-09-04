Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C6CC433E2
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 15:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46AC82074D
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 15:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgIDPnL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:43:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:19085 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgIDPnA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 11:43:00 -0400
IronPort-SDR: p9xmSDNAIlh23kCeho+ZVp069ytm3qwqW25j+qfijcXvjwmInWIJHC+IUXzMluEgt0zUOEBo8P
 2H5LLFsxHNzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="242583712"
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="242583712"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 08:43:00 -0700
IronPort-SDR: PayzwNAr2UPix6o5IUOUsXl1ZaD37ERr2k0+n5HX2aAqCpz6NHTWraUNiFg2SDLV5jn96pJs3A
 RjHohir+mn3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="302669637"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga006.jf.intel.com with ESMTP; 04 Sep 2020 08:43:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v37] selftests/sgx: Remove unused ENCLU macro now that vDSO is used
Date:   Fri,  4 Sep 2020 08:42:59 -0700
Message-Id: <20200904154259.1857-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove an unused ENCLU macro from call.S now that the file doesn't do
ENCLU directly and always bounces through the vDSO.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/sgx/call.S | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/sgx/call.S b/tools/testing/selftests/sgx/call.S
index c4837965dfbb..f640532cda93 100644
--- a/tools/testing/selftests/sgx/call.S
+++ b/tools/testing/selftests/sgx/call.S
@@ -5,12 +5,6 @@
 
 	.text
 
-	.macro ENCLU
-	.byte 0x0f, 0x01, 0xd7
-	.endm
-
-	.text
-
 	.global sgx_call_vdso
 sgx_call_vdso:
 	.cfi_startproc
-- 
2.28.0

