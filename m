Return-Path: <SRS0=vX2d=WM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EA7C3A59C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 16:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B52A82086C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 16:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfHPQIO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Aug 2019 12:08:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:39936 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbfHPQIO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Aug 2019 12:08:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 09:08:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,393,1559545200"; 
   d="scan'208";a="178801713"
Received: from ppiatekx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.24])
  by fmsmga007.fm.intel.com with ESMTP; 16 Aug 2019 09:08:12 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Cedric Xing <cedric.xing@intel.com>
Subject: [PATCH v2] selftests/x86/sgx: Fix objcopy call in the Makefile
Date:   Fri, 16 Aug 2019 19:08:09 +0300
Message-Id: <20190816160809.15627-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use $(OBJCOPY) to point to the correct objcopy binary. Do not discard
.got.plt because we need to detect libcalls and fail the compilation if
they exist.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Reported-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
- Was missing the part that creates OBJCOPY if it does not exist (e.g.
  predefined by a cross compilation environment or simply doing a host
  compilation)
 tools/testing/selftests/x86/sgx/Makefile | 6 +++++-
 tools/testing/selftests/x86/sgx/encl.lds | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index 10136b73096b..fdd67478c52b 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -2,6 +2,10 @@ top_srcdir = ../../../../..
 
 include ../../lib.mk
 
+ifndef OBJCOPY
+OBJCOPY := $(CROSS_COMPILE)objcopy
+endif
+
 HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC -z noexecstack
 ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
@@ -23,7 +27,7 @@ $(OUTPUT)/encl_piggy.o: $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
 	$(CC) $(HOST_CFLAGS) -c encl_piggy.S -o $@
 
 $(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf $(OUTPUT)/sgxsign
-	objcopy --remove-section=.got.plt -O binary $< $@
+	$(OBJCOPY) -O binary $< $@
 
 $(OUTPUT)/encl.elf: $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o
 	$(CC) $(ENCL_CFLAGS) -T encl.lds -o $@ $^
diff --git a/tools/testing/selftests/x86/sgx/encl.lds b/tools/testing/selftests/x86/sgx/encl.lds
index 2ee01ac3ec79..9a56d3064104 100644
--- a/tools/testing/selftests/x86/sgx/encl.lds
+++ b/tools/testing/selftests/x86/sgx/encl.lds
@@ -31,3 +31,4 @@ ASSERT(!DEFINED(.altinstructions), "ALTERNATIVES are not supported in enclaves")
 ASSERT(!DEFINED(.altinstr_replacement), "ALTERNATIVES are not supported in enclaves")
 ASSERT(!DEFINED(.discard.retpoline_safe), "RETPOLINE ALTERNATIVES are not supported in enclaves")
 ASSERT(!DEFINED(.discard.nospec), "RETPOLINE ALTERNATIVES are not supported in enclaves")
+ASSERT(!DEFINED(.got.plt), "Libcalls are not supported in enclaves")
-- 
2.20.1

