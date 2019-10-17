Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38CCFA3735
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C0D921928
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392098AbfJQDDs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 23:03:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:51165 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392120AbfJQDDs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 23:03:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 20:03:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="195026844"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 20:03:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v2? v2 08/14] selftests/harness: Move operator macros to their own header file
Date:   Wed, 16 Oct 2019 20:03:34 -0700
Message-Id: <20191017030340.18301-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017030340.18301-1-sean.j.christopherson@intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move the operator macros, ASSERT_* and EXTEND_*, to a standalone header
so that they can be reused by other selftests without pulling in the
full harness framework, which is cumbersome to use for testing features
that require a substantial amount of setup, need callbacks, etc...

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 Documentation/dev-tools/kselftest.rst         |   9 +-
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/kselftest_harness.h   | 246 +----------------
 tools/testing/selftests/kselftest_operators.h | 255 ++++++++++++++++++
 4 files changed, 259 insertions(+), 252 deletions(-)
 create mode 100644 tools/testing/selftests/kselftest_operators.h

diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
index 25604904fa6e..09dbeb8ab502 100644
--- a/Documentation/dev-tools/kselftest.rst
+++ b/Documentation/dev-tools/kselftest.rst
@@ -290,12 +290,5 @@ Helpers
 Operators
 ---------
 
-.. kernel-doc:: tools/testing/selftests/kselftest_harness.h
-    :doc: operators
+.. kernel-doc:: tools/testing/selftests/kselftest_operators.h
 
-.. kernel-doc:: tools/testing/selftests/kselftest_harness.h
-    :functions: ASSERT_EQ ASSERT_NE ASSERT_LT ASSERT_LE ASSERT_GT ASSERT_GE
-                ASSERT_NULL ASSERT_TRUE ASSERT_NULL ASSERT_TRUE ASSERT_FALSE
-                ASSERT_STREQ ASSERT_STRNE EXPECT_EQ EXPECT_NE EXPECT_LT
-                EXPECT_LE EXPECT_GT EXPECT_GE EXPECT_NULL EXPECT_TRUE
-                EXPECT_FALSE EXPECT_STREQ EXPECT_STRNE
diff --git a/MAINTAINERS b/MAINTAINERS
index 1eb065d3c209..71d680dff071 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14514,6 +14514,7 @@ F:	include/uapi/linux/seccomp.h
 F:	include/linux/seccomp.h
 F:	tools/testing/selftests/seccomp/*
 F:	tools/testing/selftests/kselftest_harness.h
+F:	tools/testing/selftests/kselftest_operators.h
 F:	Documentation/userspace-api/seccomp_filter.rst
 K:	\bsecure_computing
 K:	\bTIF_SECCOMP\b
diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 5336b26506ab..89af5a7bfd65 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -62,6 +62,8 @@
 #include <sys/wait.h>
 #include <unistd.h>
 
+#include "kselftest_operators.h"
+
 #define TEST_TIMEOUT_DEFAULT 30
 
 /* Utilities exposed to the test definitions */
@@ -343,250 +345,6 @@
 		return test_harness_run(argc, argv); \
 	}
 
-/**
- * DOC: operators
- *
- * Operators for use in TEST() and TEST_F().
- * ASSERT_* calls will stop test execution immediately.
- * EXPECT_* calls will emit a failure warning, note it, and continue.
- */
-
-/**
- * ASSERT_EQ(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * ASSERT_EQ(expected, measured): expected == measured
- */
-#define ASSERT_EQ(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, ==, 1)
-
-/**
- * ASSERT_NE(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * ASSERT_NE(expected, measured): expected != measured
- */
-#define ASSERT_NE(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, !=, 1)
-
-/**
- * ASSERT_LT(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * ASSERT_LT(expected, measured): expected < measured
- */
-#define ASSERT_LT(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, <, 1)
-
-/**
- * ASSERT_LE(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * ASSERT_LE(expected, measured): expected <= measured
- */
-#define ASSERT_LE(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, <=, 1)
-
-/**
- * ASSERT_GT(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * ASSERT_GT(expected, measured): expected > measured
- */
-#define ASSERT_GT(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, >, 1)
-
-/**
- * ASSERT_GE(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * ASSERT_GE(expected, measured): expected >= measured
- */
-#define ASSERT_GE(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, >=, 1)
-
-/**
- * ASSERT_NULL(seen)
- *
- * @seen: measured value
- *
- * ASSERT_NULL(measured): NULL == measured
- */
-#define ASSERT_NULL(seen) \
-	__EXPECT(NULL, "NULL", seen, #seen, ==, 1)
-
-/**
- * ASSERT_TRUE(seen)
- *
- * @seen: measured value
- *
- * ASSERT_TRUE(measured): measured != 0
- */
-#define ASSERT_TRUE(seen) \
-	__EXPECT(0, "0", seen, #seen, !=, 1)
-
-/**
- * ASSERT_FALSE(seen)
- *
- * @seen: measured value
- *
- * ASSERT_FALSE(measured): measured == 0
- */
-#define ASSERT_FALSE(seen) \
-	__EXPECT(0, "0", seen, #seen, ==, 1)
-
-/**
- * ASSERT_STREQ(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * ASSERT_STREQ(expected, measured): !strcmp(expected, measured)
- */
-#define ASSERT_STREQ(expected, seen) \
-	__EXPECT_STR(expected, seen, ==, 1)
-
-/**
- * ASSERT_STRNE(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * ASSERT_STRNE(expected, measured): strcmp(expected, measured)
- */
-#define ASSERT_STRNE(expected, seen) \
-	__EXPECT_STR(expected, seen, !=, 1)
-
-/**
- * EXPECT_EQ(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * EXPECT_EQ(expected, measured): expected == measured
- */
-#define EXPECT_EQ(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, ==, 0)
-
-/**
- * EXPECT_NE(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * EXPECT_NE(expected, measured): expected != measured
- */
-#define EXPECT_NE(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, !=, 0)
-
-/**
- * EXPECT_LT(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * EXPECT_LT(expected, measured): expected < measured
- */
-#define EXPECT_LT(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, <, 0)
-
-/**
- * EXPECT_LE(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * EXPECT_LE(expected, measured): expected <= measured
- */
-#define EXPECT_LE(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, <=, 0)
-
-/**
- * EXPECT_GT(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * EXPECT_GT(expected, measured): expected > measured
- */
-#define EXPECT_GT(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, >, 0)
-
-/**
- * EXPECT_GE(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * EXPECT_GE(expected, measured): expected >= measured
- */
-#define EXPECT_GE(expected, seen) \
-	__EXPECT(expected, #expected, seen, #seen, >=, 0)
-
-/**
- * EXPECT_NULL(seen)
- *
- * @seen: measured value
- *
- * EXPECT_NULL(measured): NULL == measured
- */
-#define EXPECT_NULL(seen) \
-	__EXPECT(NULL, "NULL", seen, #seen, ==, 0)
-
-/**
- * EXPECT_TRUE(seen)
- *
- * @seen: measured value
- *
- * EXPECT_TRUE(measured): 0 != measured
- */
-#define EXPECT_TRUE(seen) \
-	__EXPECT(0, "0", seen, #seen, !=, 0)
-
-/**
- * EXPECT_FALSE(seen)
- *
- * @seen: measured value
- *
- * EXPECT_FALSE(measured): 0 == measured
- */
-#define EXPECT_FALSE(seen) \
-	__EXPECT(0, "0", seen, #seen, ==, 0)
-
-/**
- * EXPECT_STREQ(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * EXPECT_STREQ(expected, measured): !strcmp(expected, measured)
- */
-#define EXPECT_STREQ(expected, seen) \
-	__EXPECT_STR(expected, seen, ==, 0)
-
-/**
- * EXPECT_STRNE(expected, seen)
- *
- * @expected: expected value
- * @seen: measured value
- *
- * EXPECT_STRNE(expected, measured): strcmp(expected, measured)
- */
-#define EXPECT_STRNE(expected, seen) \
-	__EXPECT_STR(expected, seen, !=, 0)
-
 #define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))
 
 /* Support an optional handler after and ASSERT_* or EXPECT_*.  The approach is
diff --git a/tools/testing/selftests/kselftest_operators.h b/tools/testing/selftests/kselftest_operators.h
new file mode 100644
index 000000000000..6ae5b547313f
--- /dev/null
+++ b/tools/testing/selftests/kselftest_operators.h
@@ -0,0 +1,255 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * See documentation in Documentation/dev-tools/kselftest.rst
+ */
+
+#ifndef __KSELFTEST_OPERATORS_H
+#define __KSELFTEST_OPERATORS_H
+
+/**
+ * DOC:
+ *
+ * Operators for use in Test Harness's TEST() and TEST_F(), or with a custom
+ * implementation of __EXPECT().
+ * ASSERT_* calls will stop test execution immediately.
+ * EXPECT_* calls will emit a failure warning, note it, and continue.
+ */
+
+/**
+ * ASSERT_EQ(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * ASSERT_EQ(expected, measured): expected == measured
+ */
+#define ASSERT_EQ(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, ==, 1)
+
+/**
+ * ASSERT_NE(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * ASSERT_NE(expected, measured): expected != measured
+ */
+#define ASSERT_NE(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, !=, 1)
+
+/**
+ * ASSERT_LT(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * ASSERT_LT(expected, measured): expected < measured
+ */
+#define ASSERT_LT(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, <, 1)
+
+/**
+ * ASSERT_LE(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * ASSERT_LE(expected, measured): expected <= measured
+ */
+#define ASSERT_LE(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, <=, 1)
+
+/**
+ * ASSERT_GT(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * ASSERT_GT(expected, measured): expected > measured
+ */
+#define ASSERT_GT(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, >, 1)
+
+/**
+ * ASSERT_GE(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * ASSERT_GE(expected, measured): expected >= measured
+ */
+#define ASSERT_GE(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, >=, 1)
+
+/**
+ * ASSERT_NULL(seen)
+ *
+ * @seen: measured value
+ *
+ * ASSERT_NULL(measured): NULL == measured
+ */
+#define ASSERT_NULL(seen) \
+	__EXPECT(NULL, "NULL", seen, #seen, ==, 1)
+
+/**
+ * ASSERT_TRUE(seen)
+ *
+ * @seen: measured value
+ *
+ * ASSERT_TRUE(measured): measured != 0
+ */
+#define ASSERT_TRUE(seen) \
+	__EXPECT(0, "0", seen, #seen, !=, 1)
+
+/**
+ * ASSERT_FALSE(seen)
+ *
+ * @seen: measured value
+ *
+ * ASSERT_FALSE(measured): measured == 0
+ */
+#define ASSERT_FALSE(seen) \
+	__EXPECT(0, "0", seen, #seen, ==, 1)
+
+/**
+ * ASSERT_STREQ(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * ASSERT_STREQ(expected, measured): !strcmp(expected, measured)
+ */
+#define ASSERT_STREQ(expected, seen) \
+	__EXPECT_STR(expected, seen, ==, 1)
+
+/**
+ * ASSERT_STRNE(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * ASSERT_STRNE(expected, measured): strcmp(expected, measured)
+ */
+#define ASSERT_STRNE(expected, seen) \
+	__EXPECT_STR(expected, seen, !=, 1)
+
+/**
+ * EXPECT_EQ(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * EXPECT_EQ(expected, measured): expected == measured
+ */
+#define EXPECT_EQ(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, ==, 0)
+
+/**
+ * EXPECT_NE(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * EXPECT_NE(expected, measured): expected != measured
+ */
+#define EXPECT_NE(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, !=, 0)
+
+/**
+ * EXPECT_LT(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * EXPECT_LT(expected, measured): expected < measured
+ */
+#define EXPECT_LT(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, <, 0)
+
+/**
+ * EXPECT_LE(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * EXPECT_LE(expected, measured): expected <= measured
+ */
+#define EXPECT_LE(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, <=, 0)
+
+/**
+ * EXPECT_GT(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * EXPECT_GT(expected, measured): expected > measured
+ */
+#define EXPECT_GT(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, >, 0)
+
+/**
+ * EXPECT_GE(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * EXPECT_GE(expected, measured): expected >= measured
+ */
+#define EXPECT_GE(expected, seen) \
+	__EXPECT(expected, #expected, seen, #seen, >=, 0)
+
+/**
+ * EXPECT_NULL(seen)
+ *
+ * @seen: measured value
+ *
+ * EXPECT_NULL(measured): NULL == measured
+ */
+#define EXPECT_NULL(seen) \
+	__EXPECT(NULL, "NULL", seen, #seen, ==, 0)
+
+/**
+ * EXPECT_TRUE(seen)
+ *
+ * @seen: measured value
+ *
+ * EXPECT_TRUE(measured): 0 != measured
+ */
+#define EXPECT_TRUE(seen) \
+	__EXPECT(0, "0", seen, #seen, !=, 0)
+
+/**
+ * EXPECT_FALSE(seen)
+ *
+ * @seen: measured value
+ *
+ * EXPECT_FALSE(measured): 0 == measured
+ */
+#define EXPECT_FALSE(seen) \
+	__EXPECT(0, "0", seen, #seen, ==, 0)
+
+/**
+ * EXPECT_STREQ(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * EXPECT_STREQ(expected, measured): !strcmp(expected, measured)
+ */
+#define EXPECT_STREQ(expected, seen) \
+	__EXPECT_STR(expected, seen, ==, 0)
+
+/**
+ * EXPECT_STRNE(expected, seen)
+ *
+ * @expected: expected value
+ * @seen: measured value
+ *
+ * EXPECT_STRNE(expected, measured): strcmp(expected, measured)
+ */
+#define EXPECT_STRNE(expected, seen) \
+	__EXPECT_STR(expected, seen, !=, 0)
+
+#endif  /* __KSELFTEST_OPERATORS_H */
+
-- 
2.22.0

