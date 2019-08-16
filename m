Return-Path: <SRS0=vX2d=WM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E5AC3A59C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 16:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 358F9205F4
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 16:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfHPQ0o (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Aug 2019 12:26:44 -0400
Received: from mga04.intel.com ([192.55.52.120]:46993 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfHPQ0n (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Aug 2019 12:26:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 09:26:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,393,1559545200"; 
   d="scan'208";a="206296158"
Received: from ppiatekx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.24])
  by fmsmga002.fm.intel.com with ESMTP; 16 Aug 2019 09:26:41 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Cedric Xing <cedric.xing@intel.com>
Subject: [PATCH] selftests/x86/sgx: Do not generate object files
Date:   Fri, 16 Aug 2019 19:26:35 +0300
Message-Id: <20190816162635.17159-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Invoke GCC in a way that it generates and links the binary in a single
step because we do not need the side products. Additionally, add a
missing dependency to encls.lds (i.e. make did not do anything if
encls.lds was changed).

Reported-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/x86/sgx/Makefile | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index fdd67478c52b..b96aff1a7fba 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -29,14 +29,8 @@ $(OUTPUT)/encl_piggy.o: $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
 $(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf $(OUTPUT)/sgxsign
 	$(OBJCOPY) -O binary $< $@
 
-$(OUTPUT)/encl.elf: $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o
-	$(CC) $(ENCL_CFLAGS) -T encl.lds -o $@ $^
-
-$(OUTPUT)/encl.o: encl.c
-	$(CC) $(ENCL_CFLAGS) -c $< -o $@
-
-$(OUTPUT)/encl_bootstrap.o: encl_bootstrap.S
-	$(CC) $(ENCL_CFLAGS) -c $< -o $@
+$(OUTPUT)/encl.elf: encl.lds encl.c encl_bootstrap.S
+	$(CC) $(ENCL_CFLAGS) -T $^ -o $@
 
 $(OUTPUT)/encl.ss: $(OUTPUT)/encl.bin  $(OUTPUT)/sgxsign
 	$(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
-- 
2.20.1

