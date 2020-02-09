Return-Path: <SRS0=oRrW=35=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404FDC2BA83
	for <linux-sgx@archiver.kernel.org>; Sun,  9 Feb 2020 21:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AE272080C
	for <linux-sgx@archiver.kernel.org>; Sun,  9 Feb 2020 21:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgBIV1Y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 9 Feb 2020 16:27:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:54556 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbgBIV1Y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 9 Feb 2020 16:27:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Feb 2020 13:27:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,422,1574150400"; 
   d="scan'208";a="405398839"
Received: from jradtke-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.22.75])
  by orsmga005.jf.intel.com with ESMTP; 09 Feb 2020 13:27:18 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v26 11/22] selftests/x86: Recurse into subdirectories
Date:   Sun,  9 Feb 2020 23:25:58 +0200
Message-Id: <20200209212609.7928-12-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Recurse into a list of subdirectories defined by SUBDIRS when running
x86 selftests. Override run_tests, install, emit_tests and clean
targets to implement this behaviour.

A possible alternative would be to add "x86/sgx" to TARGETS. However,
this would be problematic because detecting 64-bit build would have
to duplicated.

The implementation is derived from the makefiles of powerpc and sparc64
selftests.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/x86/Makefile | 44 ++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index 5d49bfec1e9a..dee6dadeba61 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -10,6 +10,8 @@ CAN_BUILD_I386 := $(shell ./check_cc.sh $(CC) trivial_32bit_program.c -m32)
 CAN_BUILD_X86_64 := $(shell ./check_cc.sh $(CC) trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh $(CC) trivial_program.c -no-pie)
 
+SUBDIRS := sgx
+
 TARGETS_C_BOTHBITS := single_step_syscall sysret_ss_attrs syscall_nt test_mremap_vdso \
 			check_initial_reg_state sigreturn iopl ioperm \
 			protection_keys test_vdso test_vsyscall mov_ss_trap \
@@ -59,6 +61,48 @@ endif
 
 ifeq ($(CAN_BUILD_X86_64),1)
 all: all_64
+	@for DIR in $(SUBDIRS); do \
+		BUILD_TARGET=$(OUTPUT)/$$DIR; \
+		mkdir $$BUILD_TARGET  -p; \
+		make OUTPUT=$$BUILD_TARGET -C $$DIR $@; \
+	done
+
+DEFAULT_RUN_TESTS := $(RUN_TESTS)
+override define RUN_TESTS
+	$(DEFAULT_RUN_TESTS)
+	@for TARGET in $(SUBDIRS); do \
+		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests; \
+	done;
+endef
+
+DEFAULT_INSTALL_RULE := $(INSTALL_RULE)
+override define INSTALL_RULE
+	$(DEFAULT_INSTALL_RULE)
+	@for TARGET in $(SUBDIRS); do \
+		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install; \
+	done;
+endef
+
+DEFAULT_EMIT_TESTS := $(EMIT_TESTS)
+override define EMIT_TESTS
+	$(DEFAULT_EMIT_TESTS)
+	@for TARGET in $(SUBDIRS); do \
+		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
+		$(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests; \
+	done;
+endef
+
+DEFAULT_CLEAN := $(CLEAN)
+override define CLEAN
+	$(DEFAULT_CLEAN)
+	@for TARGET in $(SUBDIRS); do \
+		BUILD_TARGET=$(OUTPUT)/$$TARGET; \
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean; \
+	done;
+endef
+
 TEST_PROGS += $(BINARIES_64)
 EXTRA_CFLAGS += -DCAN_BUILD_64
 $(foreach t,$(TARGETS_C_64BIT_ALL),$(eval $(call gen-target-rule-64,$(t))))
-- 
2.20.1

