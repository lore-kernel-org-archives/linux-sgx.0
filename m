Return-Path: <SRS0=FsvD=WO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD89EC3A589
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Aug 2019 16:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A18712087E
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Aug 2019 16:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfHRQof (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 18 Aug 2019 12:44:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:6776 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfHRQof (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 18 Aug 2019 12:44:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Aug 2019 09:44:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,401,1559545200"; 
   d="scan'208";a="261613691"
Received: from hjamouss-mobl.ger.corp.intel.com (HELO localhost) ([10.252.39.36])
  by orsmga001.jf.intel.com with ESMTP; 18 Aug 2019 09:44:32 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Cedric Xing <cedric.xing@intel.com>
Subject: [PATCH v2 4/7] selftests/x86/sgx: Fix EXTRA_CLEAN
Date:   Sun, 18 Aug 2019 19:44:04 +0300
Message-Id: <20190818164408.31808-5-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190818164408.31808-1-jarkko.sakkinen@linux.intel.com>
References: <20190818164408.31808-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

1. Add missing build products to EXTRA_CLEAN.
2. Remove non-existent build products from EXTRA_CLEAN.

Reported-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/x86/sgx/Makefile | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index 0b8813cc0b7f..0f1c50c347d7 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -38,9 +38,14 @@ $(OUTPUT)/encl.ss: $(OUTPUT)/encl.bin  $(OUTPUT)/sgxsign
 $(OUTPUT)/sgxsign: sgxsign.c
 	$(CC) -o $@ $< -lcrypto
 
-EXTRA_CLEAN := $(OUTPUT)/sgx-selftest $(OUTPUT)/sgx-selftest.o \
-	       $(OUTPUT)/sgx_call.o $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss \
-	       $(OUTPUT)/encl.elf $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o \
-	       $(OUTPUT)/sgxsign
+EXTRA_CLEAN := \
+	$(OUTPUT)/encl.bin \
+	$(OUTPUT)/encl_piggy.o \
+	$(OUTPUT)/encl.elf \
+	$(OUTPUT)/encl.ss \
+	$(OUTPUT)/sgx_call.o \
+	$(OUTPUT)/sgxsign \
+	$(OUTPUT)/test_sgx \
+	$(OUTPUT)/test_sgx.o \
 
 .PHONY: clean
-- 
2.20.1

