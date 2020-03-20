Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293EBC4332B
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 17:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015C520775
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 17:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCTRr1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 13:47:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:24109 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgCTRr1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Mar 2020 13:47:27 -0400
IronPort-SDR: vGJWeQXvfFpfQO9sAdruIKAP6PyZXjFecVY27vX1srrwuN6LvgDzv1aWJobW7kXcW3aMjEgI6+
 uV1q1gsQAsiQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 10:47:27 -0700
IronPort-SDR: 4zVTUrEcukyRW++nT8A5RCusFyG5oFLmEBwhN7YZCQkLXZ25Q2a9Efx9adWFKf6NZK/ZQL0yk8
 8XqvfSwKycDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="356475247"
Received: from aklimker-mobl1.ger.corp.intel.com (HELO localhost) ([10.255.197.99])
  by fmsmga001.fm.intel.com with ESMTP; 20 Mar 2020 10:47:24 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 1/2] Revert "selftests/x86: Recurse into subdirectories"
Date:   Fri, 20 Mar 2020 19:47:15 +0200
Message-Id: <20200320174716.27944-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This reverts commit 565ceeb112045102d62493efb951e237d030e7e1.
---
 tools/testing/selftests/x86/Makefile | 44 ----------------------------
 1 file changed, 44 deletions(-)

diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index dee6dadeba61..5d49bfec1e9a 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -10,8 +10,6 @@ CAN_BUILD_I386 := $(shell ./check_cc.sh $(CC) trivial_32bit_program.c -m32)
 CAN_BUILD_X86_64 := $(shell ./check_cc.sh $(CC) trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh $(CC) trivial_program.c -no-pie)
 
-SUBDIRS := sgx
-
 TARGETS_C_BOTHBITS := single_step_syscall sysret_ss_attrs syscall_nt test_mremap_vdso \
 			check_initial_reg_state sigreturn iopl ioperm \
 			protection_keys test_vdso test_vsyscall mov_ss_trap \
@@ -61,48 +59,6 @@ endif
 
 ifeq ($(CAN_BUILD_X86_64),1)
 all: all_64
-	@for DIR in $(SUBDIRS); do \
-		BUILD_TARGET=$(OUTPUT)/$$DIR; \
-		mkdir $$BUILD_TARGET  -p; \
-		make OUTPUT=$$BUILD_TARGET -C $$DIR $@; \
-	done
-
-DEFAULT_RUN_TESTS := $(RUN_TESTS)
-override define RUN_TESTS
-	$(DEFAULT_RUN_TESTS)
-	@for TARGET in $(SUBDIRS); do \
-		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
-		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests; \
-	done;
-endef
-
-DEFAULT_INSTALL_RULE := $(INSTALL_RULE)
-override define INSTALL_RULE
-	$(DEFAULT_INSTALL_RULE)
-	@for TARGET in $(SUBDIRS); do \
-		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
-		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install; \
-	done;
-endef
-
-DEFAULT_EMIT_TESTS := $(EMIT_TESTS)
-override define EMIT_TESTS
-	$(DEFAULT_EMIT_TESTS)
-	@for TARGET in $(SUBDIRS); do \
-		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
-		$(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests; \
-	done;
-endef
-
-DEFAULT_CLEAN := $(CLEAN)
-override define CLEAN
-	$(DEFAULT_CLEAN)
-	@for TARGET in $(SUBDIRS); do \
-		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
-		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean; \
-	done;
-endef
-
 TEST_PROGS += $(BINARIES_64)
 EXTRA_CFLAGS += -DCAN_BUILD_64
 $(foreach t,$(TARGETS_C_64BIT_ALL),$(eval $(call gen-target-rule-64,$(t))))
-- 
2.25.1

