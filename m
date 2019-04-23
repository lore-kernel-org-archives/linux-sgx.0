Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C368C282CE
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 00:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5101D2077C
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 00:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbfDWAh2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 20:37:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:13158 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729135AbfDWAh1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 20:37:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 17:37:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,383,1549958400"; 
   d="scan'208";a="225774515"
Received: from bxing-ubuntu.jf.intel.com ([10.23.30.27])
  by orsmga001.jf.intel.com with ESMTP; 22 Apr 2019 17:37:25 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, Hansen@vger.kernel.org,
        Dave <dave.hansen@intel.com>, Christopherson@vger.kernel.org,
        Sean J <sean.j.christopherson@intel.com>, nhorman@redhat.com,
        npmccallum@redhat.com, Ayoun@vger.kernel.org,
        Serge <serge.ayoun@intel.com>, Katz-zamir@vger.kernel.org,
        Shay <shay.katz-zamir@intel.com>, Huang@vger.kernel.org,
        Haitao <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        Svahn@vger.kernel.org, Kai <kai.svahn@intel.com>, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, Kai <kai.huang@intel.com>,
        rientjes@google.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Cedric Xing <cedric.xing@intel.com>
Subject: [RFC PATCH v1 1/3] selftests/x86: Fixed Makefile for SGX selftest
Date:   Mon, 22 Apr 2019 17:37:23 -0700
Message-Id:
 <4e463af695c92b6b5693b1f0d00a49b21fbf4656.1555965327.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1555965327.git.cedric.xing@intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
In-Reply-To: <cover.1555965327.git.cedric.xing@intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <cover.1555965327.git.cedric.xing@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190423003723.pHKQYmK4wAqPytghmvC7vKqr-mOPO363GjoeFS0418U@z>

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
+$(OUTPUT)/encl_piggy.o: encl_piggy.S $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
+	$(CC) $(HOST_CFLAGS) -I$(OUTPUT) -c $< -o $@
 
-$(OUTPUT)/sgx_call.o: sgx_call.S
-	$(CC) $(HOST_CFLAGS) -c $< -o $@
-
-$(OUTPUT)/encl_piggy.o: $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
-	$(CC) $(HOST_CFLAGS) -c encl_piggy.S -o $@
-
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

