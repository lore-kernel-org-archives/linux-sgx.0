Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8566EC74A45
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 04:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68D4F21019
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 04:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfGKEVi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 00:21:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:22501 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfGKEVi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 00:21:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 21:21:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,476,1557212400"; 
   d="scan'208";a="186293852"
Received: from hmendezc-mobl1.amr.corp.intel.com (HELO ubt18m.amr.corp.intel.com) ([10.252.143.173])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jul 2019 21:21:36 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Cedric Xing <cedric.xing@intel.com>, luto@kernel.org,
        jethro@fortanix.com, greg@enjellic.com,
        jarkko.sakkinen@linux.intel.com, sean.j.christopherson@intel.com
Subject: [RFC PATCH v3 1/3] selftests/x86: Fixed Makefile for SGX selftest
Date:   Wed, 10 Jul 2019 21:21:31 -0700
Message-Id: <b5e13136a753af4ca302570337353e7aff6f760e.1562813643.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1562813643.git.cedric.xing@intel.com>
References: <cover.1562813643.git.cedric.xing@intel.com>
In-Reply-To: <cover.1562813643.git.cedric.xing@intel.com>
References: <20190424062623.4345-1-cedric.xing@intel.com> <cover.1562813643.git.cedric.xing@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The original x86/sgx/Makefile doesn't work when 'x86/sgx' is specified as the
test target. This patch fixes that problem, along with minor changes to the
dependencies between 'x86' and 'x86/sgx' in selftests/x86/Makefile.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 tools/testing/selftests/x86/Makefile     | 12 +++----
 tools/testing/selftests/x86/sgx/Makefile | 45 +++++++++---------------
 2 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index 4fc9a42f56ea..1294c5f5b6ca 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -70,11 +70,11 @@ all_32: $(BINARIES_32)
 
 all_64: $(BINARIES_64)
 
-all_64: $(SUBDIRS_64)
-	@for DIR in $(SUBDIRS_64); do			\
-		BUILD_TARGET=$(OUTPUT)/$$DIR;		\
-		mkdir $$BUILD_TARGET  -p;		\
-		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;	\
+all_64: | $(SUBDIRS_64)
+	@for DIR in $|; do					\
+		BUILD_TARGET=$(OUTPUT)/$$DIR;			\
+		mkdir $$BUILD_TARGET  -p;			\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$DIR $@;	\
 	done
 
 EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
@@ -90,7 +90,7 @@ ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
 all: warn_32bit_failure
 
 warn_32bit_failure:
-	@echo "Warning: you seem to have a broken 32-bit build" 2>&1; 	\
+	@echo "Warning: you seem to have a broken 32-bit build" 2>&1;	\
 	echo "environment.  This will reduce test coverage of 64-bit" 2>&1; \
 	echo "kernels.  If you are using a Debian-like distribution," 2>&1; \
 	echo "try:"; 2>&1; \
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

