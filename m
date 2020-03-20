Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF61C4332D
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 17:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 217F72072C
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 17:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCTRrf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 13:47:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:21595 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbgCTRre (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Mar 2020 13:47:34 -0400
IronPort-SDR: gC2qMM5tvmQ4bRhwvRgkTttNwt4fFKBOxUlJ6FlyNWSLTOmpaoBHuiMqDanqs2YyssUNGob26Z
 7QTJ7e9iCkSQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 10:47:33 -0700
IronPort-SDR: j3dzngyOGG39U6Zh8r9Z7EUYqUJ22j6AF0FntRcwy2ahtmzygI/34NsnZIU/w6l4FL2/80tESe
 eu0WrCUWvzSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="239291166"
Received: from aklimker-mobl1.ger.corp.intel.com (HELO localhost) ([10.255.197.99])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2020 10:47:30 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 2/2] selftests/x86/sgx: Move to selftests/sgx
Date:   Fri, 20 Mar 2020 19:47:16 +0200
Message-Id: <20200320174716.27944-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200320174716.27944-1-jarkko.sakkinen@linux.intel.com>
References: <20200320174716.27944-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move selftest under the top level selftests directory so that we don't
need to clutter x86/Makefile. The changes made for x86/Makefile caused
also issues with packaging the selftests. Finally, SGX assets need their
own tailored compilation environment.

With this change BuildRoot nicely packages both standard x86 selftests
and our SGX test.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/Makefile                     |  1 +
 tools/testing/selftests/{x86 => }/sgx/.gitignore     |  0
 tools/testing/selftests/{x86 => }/sgx/Makefile       | 12 +++++++++---
 tools/testing/selftests/{x86 => }/sgx/call.S         |  0
 tools/testing/selftests/{x86 => }/sgx/defines.h      |  4 ++--
 tools/testing/selftests/{x86 => }/sgx/encl.c         |  0
 tools/testing/selftests/{x86 => }/sgx/encl.lds       |  0
 .../testing/selftests/{x86 => }/sgx/encl_bootstrap.S |  0
 tools/testing/selftests/{x86 => }/sgx/main.c         |  0
 tools/testing/selftests/{x86 => }/sgx/main.h         |  0
 tools/testing/selftests/{x86 => }/sgx/sign.c         |  0
 11 files changed, 12 insertions(+), 5 deletions(-)
 rename tools/testing/selftests/{x86 => }/sgx/.gitignore (100%)
 rename tools/testing/selftests/{x86 => }/sgx/Makefile (83%)
 rename tools/testing/selftests/{x86 => }/sgx/call.S (100%)
 rename tools/testing/selftests/{x86 => }/sgx/defines.h (71%)
 rename tools/testing/selftests/{x86 => }/sgx/encl.c (100%)
 rename tools/testing/selftests/{x86 => }/sgx/encl.lds (100%)
 rename tools/testing/selftests/{x86 => }/sgx/encl_bootstrap.S (100%)
 rename tools/testing/selftests/{x86 => }/sgx/main.c (100%)
 rename tools/testing/selftests/{x86 => }/sgx/main.h (100%)
 rename tools/testing/selftests/{x86 => }/sgx/sign.c (100%)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6ec503912bea..183a050b5bda 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -63,6 +63,7 @@ TARGETS += user
 TARGETS += vm
 TARGETS += x86
 TARGETS += zram
+TARGETS += sgx
 #Please keep the TARGETS list alphabetically sorted
 # Run "make quicktest=1 run_tests" or
 # "make quicktest=1 kselftest" from top level Makefile
diff --git a/tools/testing/selftests/x86/sgx/.gitignore b/tools/testing/selftests/sgx/.gitignore
similarity index 100%
rename from tools/testing/selftests/x86/sgx/.gitignore
rename to tools/testing/selftests/sgx/.gitignore
diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
similarity index 83%
rename from tools/testing/selftests/x86/sgx/Makefile
rename to tools/testing/selftests/sgx/Makefile
index 789ebbbfddcb..d9c3b3a1983b 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -1,6 +1,11 @@
-top_srcdir = ../../../../..
+top_srcdir = ../../../..
 
-include ../../lib.mk
+include ../lib.mk
+
+.PHONY: all clean
+
+CAN_BUILD_X86_64 := $(shell ../x86/check_cc.sh $(CC) \
+			    ../x86/trivial_64bit_program.c)
 
 ifndef OBJCOPY
 OBJCOPY := $(CROSS_COMPILE)objcopy
@@ -13,7 +18,9 @@ ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 
 TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx $(OUTPUT)/encl.bin
 
+ifeq ($(CAN_BUILD_X86_64), 1)
 all: $(TEST_CUSTOM_PROGS)
+endif
 
 $(OUTPUT)/test_sgx: $(OUTPUT)/main.o $(OUTPUT)/sign.o $(OUTPUT)/call.o
 	$(CC) $(HOST_CFLAGS) -o $@ $^ -lcrypto
@@ -40,4 +47,3 @@ EXTRA_CLEAN := \
 	$(OUTPUT)/test_sgx \
 	$(OUTPUT)/test_sgx.o \
 
-.PHONY: clean
diff --git a/tools/testing/selftests/x86/sgx/call.S b/tools/testing/selftests/sgx/call.S
similarity index 100%
rename from tools/testing/selftests/x86/sgx/call.S
rename to tools/testing/selftests/sgx/call.S
diff --git a/tools/testing/selftests/x86/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
similarity index 71%
rename from tools/testing/selftests/x86/sgx/defines.h
rename to tools/testing/selftests/sgx/defines.h
index 0f91175088f6..8f4d17cf8cee 100644
--- a/tools/testing/selftests/x86/sgx/defines.h
+++ b/tools/testing/selftests/sgx/defines.h
@@ -13,7 +13,7 @@
 #define __aligned(x) __attribute__((__aligned__(x)))
 #define __packed __attribute__((packed))
 
-#include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
-#include "../../../../../arch/x86/include/uapi/asm/sgx.h"
+#include "../../../../arch/x86/kernel/cpu/sgx/arch.h"
+#include "../../../../arch/x86/include/uapi/asm/sgx.h"
 
 #endif /* DEFINES_H */
diff --git a/tools/testing/selftests/x86/sgx/encl.c b/tools/testing/selftests/sgx/encl.c
similarity index 100%
rename from tools/testing/selftests/x86/sgx/encl.c
rename to tools/testing/selftests/sgx/encl.c
diff --git a/tools/testing/selftests/x86/sgx/encl.lds b/tools/testing/selftests/sgx/encl.lds
similarity index 100%
rename from tools/testing/selftests/x86/sgx/encl.lds
rename to tools/testing/selftests/sgx/encl.lds
diff --git a/tools/testing/selftests/x86/sgx/encl_bootstrap.S b/tools/testing/selftests/sgx/encl_bootstrap.S
similarity index 100%
rename from tools/testing/selftests/x86/sgx/encl_bootstrap.S
rename to tools/testing/selftests/sgx/encl_bootstrap.S
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/sgx/main.c
similarity index 100%
rename from tools/testing/selftests/x86/sgx/main.c
rename to tools/testing/selftests/sgx/main.c
diff --git a/tools/testing/selftests/x86/sgx/main.h b/tools/testing/selftests/sgx/main.h
similarity index 100%
rename from tools/testing/selftests/x86/sgx/main.h
rename to tools/testing/selftests/sgx/main.h
diff --git a/tools/testing/selftests/x86/sgx/sign.c b/tools/testing/selftests/sgx/sign.c
similarity index 100%
rename from tools/testing/selftests/x86/sgx/sign.c
rename to tools/testing/selftests/sgx/sign.c
-- 
2.25.1

