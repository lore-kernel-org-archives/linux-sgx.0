Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBA9ECE58E
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCEB020679
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbfJHEqR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:8176 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfJHEqR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566515"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 09/16] selftests/x86/sgx: Add helper function and macros to assert results
Date:   Mon,  7 Oct 2019 21:46:06 -0700
Message-Id: <20191008044613.12350-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Borrow code and ideas from the KVM selftests for asserting and reporting
test results and failures.  Update the existing test assertions to use
the new functionality.  Defer other updates, e.g. error handling, to
future patches.

Change the license to GPL-2.0-only to accommodate the borrowed code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 52 ++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 3a0d76c40bcc..0c964bc1fca0 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -1,9 +1,10 @@
-// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// SPDX-License-Identifier: GPL-2.0-only
 // Copyright(c) 2016-18 Intel Corporation.
 
 #include <elf.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <stdarg.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdint.h>
@@ -24,6 +25,47 @@
 #define PAGE_SIZE  4096
 
 static const uint64_t MAGIC = 0x1122334455667788ULL;
+
+void __attribute__((noinline)) test_assert(bool exp, const char *exp_str,
+					   const char *file, unsigned int line,
+					   const char *fmt, ...)
+{
+	va_list ap;
+
+	if (exp)
+		return;
+
+	va_start(ap, fmt);
+
+	fprintf(stderr, "==== SGX Selftest Assertion Failure ====\n");
+	if (exp_str)
+		fprintf(stderr, "  %s:%u: %s\n", file, line, exp_str);
+	if (fmt) {
+		if (exp_str)
+			fputs("  ", stderr);
+		else
+			fprintf(stderr, "  %s:%u: ", file, line);
+		vfprintf(stderr, fmt, ap);
+		fputs("\n", stderr);
+	}
+	va_end(ap);
+	exit(1);
+}
+
+#define TEST_ASSERT(e, fmt, ...) \
+	test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
+
+#define ASSERT_EQ(a, b)							     \
+do {									     \
+	typeof(a) __a = (a);						     \
+	typeof(b) __b = (b);						     \
+	test_assert(__a == __b, NULL, __FILE__, __LINE__,		     \
+		    "%s == %s failed.\n"				     \
+		    "\t%s is %#lx\n"					     \
+		    "\t%s is %#lx",					     \
+		    #a, #b, #a, (unsigned long)__a, #b, (unsigned long)__b); \
+} while (0)
+
 void *eenter;
 
 struct vdso_symtab {
@@ -346,15 +388,11 @@ int main(int argc, char *argv[], char *envp[])
 	if (!encl_build(&secs, bin, bin_size, &sigstruct))
 		exit(1);
 
-	printf("Input: 0x%lx\n", MAGIC);
 	sgx_call((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
 		 (void *)secs.base, &exception, NULL);
 
-	if (result != MAGIC) {
-		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
-		exit(1);
-	}
+	ASSERT_EQ(result, MAGIC);
 
-	printf("Output: 0x%lx\n", result);
+	printf("All tests passed!\n");
 	exit(0);
 }
-- 
2.22.0

