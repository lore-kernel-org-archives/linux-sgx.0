Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903BFFA372F
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 731C721928
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392133AbfJQDDr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 23:03:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:45377 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392126AbfJQDDq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 23:03:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 20:03:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="195026847"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 20:03:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v2? v2 09/14] selftests/x86/sgx: Use kselftest operators to check test results
Date:   Wed, 16 Oct 2019 20:03:35 -0700
Message-Id: <20191017030340.18301-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017030340.18301-1-sean.j.christopherson@intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use kselftest's operators, e.g. ASSERT_EQ, EXPECT_EQ, etc... to check
test results.  Implement a custom __EXPECT() macro instead of using the
framework defined in kselftest_harness.h.  The harness framework is
designed for tests that are short and sweet, e.g. true unit tests, and
don't work well with SGX's need for a large, run-once setup.  The
harness code will also be problematic when tests for the vDSO's callback
code are added in the future.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 52 ++++++++++++++++++++------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 664a2ed98915..f1bd74913ec3 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -18,6 +18,7 @@
 #include <sys/auxv.h>
 
 #include "../../kselftest.h"
+#include "../../kselftest_operators.h"
 
 #include "defines.h"
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
@@ -26,6 +27,41 @@
 
 #define PAGE_SIZE  4096
 
+#define EXPECT_FAILED(_assert, fmt, ...)			\
+do {								\
+	if (_assert)						\
+		ksft_exit_fail_msg(fmt, ##__VA_ARGS__);		\
+	else							\
+		ksft_test_result_fail(fmt, ##__VA_ARGS__);	\
+} while (0)
+
+#define __EXPECT(_expected, _expected_str, _seen, _seen_str, _t, _assert)     \
+do {									      \
+	/* Avoid multiple evaluation of the cases */			      \
+	__typeof__(_expected) __exp = (_expected);			      \
+	__typeof__(_seen) __seen = (_seen);				      \
+	if (passed && !(__exp _t __seen)) {				      \
+		unsigned long long __exp_print = (uintptr_t)__exp;	      \
+		unsigned long long __seen_print = (uintptr_t)__seen;	      \
+		EXPECT_FAILED(_assert,					      \
+			      "Expected '%s (%llu) %s %s (%llu)' at %s:%u\n", \
+			      _expected_str, __exp_print, #_t, _seen_str,     \
+			      __seen_print, __FILE__, __LINE__);	      \
+		passed = false;						      \
+	}								      \
+} while (0)
+
+#define RUN_TEST(test_name)						\
+({									\
+	passed = true;							\
+									\
+	test_name(&secs);						\
+	if (passed)							\
+		ksft_test_result_pass("%s: Passed\n", #test_name);	\
+})
+
+static bool passed = true;
+
 static const uint64_t MAGIC = 0x1122334455667788ULL;
 void *eenter;
 
@@ -339,11 +375,7 @@ static void test_sgx_basic(struct sgx_secs *secs)
 	uint64_t result = 0;
 
 	sgx_call_eenter((void *)&MAGIC, &result, (void *)secs->base);
-	if (result != MAGIC) {
-		ksft_test_result_error("0x%lx != 0x%lx\n", result, MAGIC);
-		return;
-	}
-	ksft_test_result_pass("%s: Passed\n", __func__);
+	EXPECT_EQ(result, MAGIC);
 }
 
 static void test_sgx_vdso(struct sgx_secs *secs)
@@ -355,11 +387,7 @@ static void test_sgx_vdso(struct sgx_secs *secs)
 
 	sgx_call_vdso((void *)&MAGIC, &result, NULL, NULL, NULL, NULL,
 		      (void *)secs->base, &exception, NULL);
-	if (result != MAGIC) {
-		ksft_test_result_error("0x%lx != 0x%lx\n", result, MAGIC);
-		return;
-	}
-	ksft_test_result_pass("%s: Passed\n", __func__);
+	EXPECT_EQ(result, MAGIC);
 }
 
 int main(int argc, char *argv[], char *envp[])
@@ -381,12 +409,12 @@ int main(int argc, char *argv[], char *envp[])
 	if (!encl_build(&secs, bin, bin_size, &sigstruct))
 		exit(1);
 
-	test_sgx_basic(&secs);
+	RUN_TEST(test_sgx_basic);
 
 	if (!setup_vdso())
 		exit(1);
 
-	test_sgx_vdso(&secs);
+	RUN_TEST(test_sgx_vdso);
 
 	return ksft_exit_pass();
 }
-- 
2.22.0

