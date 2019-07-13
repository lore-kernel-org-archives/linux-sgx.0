Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9122DC742A7
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 06:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7055B20848
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 06:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfGMGv3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 02:51:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:55267 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfGMGv3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 02:51:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 23:51:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,485,1557212400"; 
   d="scan'208";a="318200502"
Received: from bxing-ubuntu.jf.intel.com ([10.23.30.27])
  by orsmga004.jf.intel.com with ESMTP; 12 Jul 2019 23:51:27 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        jarkko.sakkinen@linux.intel.com
Cc:     cedric.xing@intel.com, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, kai.svahn@intel.com, kai.huang@intel.com
Subject: [RFC PATCH v4 1/3] selftests/x86/sgx: Fix Makefile for SGX selftest
Date:   Fri, 12 Jul 2019 23:51:25 -0700
Message-Id: <757d44a0e67bfa09d97eea918bc0d20383b5e80e.1563000446.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1563000446.git.cedric.xing@intel.com>
References: <cover.1563000446.git.cedric.xing@intel.com>
In-Reply-To: <cover.1563000446.git.cedric.xing@intel.com>
References: <cover.1562813643.git.cedric.xing@intel.com> <cover.1563000446.git.cedric.xing@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The original x86/sgx/Makefile didn't work when "x86/sgx" was specified as the
test target, nor did it work with "run_tests" as the make target. Yet another
problem was that it breaks 32-bit only build. This patch fixes those problems,
along with adjustments to compiler/linker options and simplifications to the
build rules.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 tools/testing/selftests/x86/sgx/Makefile | 45 +++++++++---------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index 1fd6f2708e81..3af15d7c8644 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -2,47 +2,34 @@ top_srcdir = ../../../../..
 
 include ../../lib.mk
 
-HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC
-ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
+ifeq ($(shell $(CC) -dumpmachine | cut --delimiter=- -f1),x86_64)
+all: all_64
+endif
+
+HOST_CFLAGS := -Wall -Werror -g $(INCLUDES)
+ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIE \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
 
 TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
 all_64: $(TEST_CUSTOM_PROGS)
 
-$(TEST_CUSTOM_PROGS): $(OUTPUT)/main.o $(OUTPUT)/sgx_call.o \
-		      $(OUTPUT)/encl_piggy.o
+$(TEST_CUSTOM_PROGS): main.c sgx_call.S $(OUTPUT)/encl_piggy.o
 	$(CC) $(HOST_CFLAGS) -o $@ $^
 
-$(OUTPUT)/main.o: main.c
-	$(CC) $(HOST_CFLAGS) -c $< -o $@
-
-$(OUTPUT)/sgx_call.o: sgx_call.S
-	$(CC) $(HOST_CFLAGS) -c $< -o $@
-
-$(OUTPUT)/encl_piggy.o: $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
-	$(CC) $(HOST_CFLAGS) -c encl_piggy.S -o $@
+$(OUTPUT)/encl_piggy.o: encl_piggy.S $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
+	$(CC) $(HOST_CFLAGS) -I$(OUTPUT) -c $< -o $@
 
-$(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf $(OUTPUT)/sgxsign
+$(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf
 	objcopy --remove-section=.got.plt -O binary $< $@
 
-$(OUTPUT)/encl.elf: $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o
-	$(CC) $(ENCL_CFLAGS) -T encl.lds -o $@ $^
+$(OUTPUT)/encl.elf: encl.lds encl.c encl_bootstrap.S
+	$(CC) $(ENCL_CFLAGS) -T $^ -o $@
 
-$(OUTPUT)/encl.o: encl.c
-	$(CC) $(ENCL_CFLAGS) -c $< -o $@
-
-$(OUTPUT)/encl_bootstrap.o: encl_bootstrap.S
-	$(CC) $(ENCL_CFLAGS) -c $< -o $@
-
-$(OUTPUT)/encl.ss: $(OUTPUT)/encl.bin  $(OUTPUT)/sgxsign
-	$(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
+$(OUTPUT)/encl.ss: $(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin
+	$^ $@
 
 $(OUTPUT)/sgxsign: sgxsign.c
 	$(CC) -o $@ $< -lcrypto
 
-EXTRA_CLEAN := $(OUTPUT)/sgx-selftest $(OUTPUT)/sgx-selftest.o \
-	       $(OUTPUT)/sgx_call.o $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss \
-	       $(OUTPUT)/encl.elf $(OUTPUT)/encl.o $(OUTPUT)/encl_bootstrap.o \
-	       $(OUTPUT)/sgxsign
-
-.PHONY: clean
+EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(addprefix $(OUTPUT)/,	\
+		encl.elf encl.bin encl.ss encl_piggy.o sgxsign)
-- 
2.17.1

