Return-Path: <SRS0=kvvX=WP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E9BC3A5A0
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 13:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 169E52085A
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 13:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfHSN2r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Aug 2019 09:28:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:32180 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfHSN2q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Aug 2019 09:28:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 06:28:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="261844530"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.125])
  by orsmga001.jf.intel.com with ESMTP; 19 Aug 2019 06:28:44 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        sean.j.christopherson@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Cedric Xing <cedric.xing@intel.com>
Subject: [PATCH v3 3/7] selftests/x86/sgx: Add -I$(OUTPUT) when compiling encl_piggy.S
Date:   Mon, 19 Aug 2019 16:28:26 +0300
Message-Id: <20190819132830.9056-4-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190819132830.9056-1-jarkko.sakkinen@linux.intel.com>
References: <20190819132830.9056-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

We need to the build output directory to the include path when compiling
encl_piggy.S because otherwise the compiler can't reliably find encl.bin
and encl.ss.

Reported-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/x86/sgx/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index b96aff1a7fba..0b8813cc0b7f 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -24,7 +24,7 @@ $(OUTPUT)/sgx_call.o: sgx_call.S
 	$(CC) $(HOST_CFLAGS) -c $< -o $@
 
 $(OUTPUT)/encl_piggy.o: $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
-	$(CC) $(HOST_CFLAGS) -c encl_piggy.S -o $@
+	$(CC) $(HOST_CFLAGS) -I$(OUTPUT) -c encl_piggy.S -o $@
 
 $(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf $(OUTPUT)/sgxsign
 	$(OBJCOPY) -O binary $< $@
-- 
2.20.1

