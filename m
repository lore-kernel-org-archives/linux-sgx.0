Return-Path: <SRS0=gA9u=YE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27519C4360C
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 035382053B
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfJKAlE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 20:41:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:44340 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbfJKAlD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 20:41:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 17:41:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,282,1566889200"; 
   d="scan'208";a="198542993"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 10 Oct 2019 17:41:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 2/5] selftests/x86/sgx: Add check to verify exit handler stack alignment
Date:   Thu, 10 Oct 2019 17:40:56 -0700
Message-Id: <20191011004059.28581-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191011004059.28581-1-sean.j.christopherson@intel.com>
References: <20191011004059.28581-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add an assembly trampoline to the basic exit handler to snapshot the
pre-CALL %rsp in order to verify that the stack is 16-byte aligned as
required by the x86_64 ABI.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/defines.h |  1 +
 tools/testing/selftests/x86/sgx/main.c    | 20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/defines.h b/tools/testing/selftests/x86/sgx/defines.h
index 199a830e198a..8ddd3cfd1070 100644
--- a/tools/testing/selftests/x86/sgx/defines.h
+++ b/tools/testing/selftests/x86/sgx/defines.h
@@ -15,6 +15,7 @@ typedef uint64_t u64;
 
 #define __aligned(x) __attribute__((__aligned__(x)))
 #define __packed __attribute__((packed))
+#define __used __attribute__((__used__))
 
 /* Derived from asm-generic/bitsperlong.h. */
 #if __x86_64__
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 029502d81ac9..f46e5c8fdac4 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -331,14 +331,28 @@ static void test_vdso_no_exit_handler(struct sgx_secs *secs)
 	ASSERT_EQ(exception.leaf, ENCLU_EENTER);
 }
 
-static int basic_exit_handler(long rdi, long rsi, long rdx, int ret,
-			      long r8, long r9, void *tcs, long ursp,
-			      struct sgx_enclave_exception *e)
+static int __used __basic_exit_handler(long rdi, long rsi, long rdx, int ret,
+				       long r8, long r9, void *tcs, long ursp,
+				       struct sgx_enclave_exception *e)
 {
+	TEST_ASSERT(!(r9 & 0xf), "Pre-CALL RSP not 16-byte aligned: %lx\n", r9);
 	ASSERT_EQ(ret, 0);
 	return 0;
 }
 
+extern void *basic_exit_handler;
+
+static void __used basic_exit_handler_trampoline(void)
+{
+	/* Load the pre-CALL %rsp into %r9 to verify correct alignment. */
+	asm volatile("1:\n\t"
+		     "lea 0x8(%%rsp), %%r9\n\t"
+		     "jmp __basic_exit_handler\n\t"
+		     "basic_exit_handler: .quad 1b\n\t"
+		     ".global basic_exit_handler"
+		     ::: "memory");
+}
+
 static int nr_page_faults;
 
 static int mprotect_exit_handler(long rdi, long rsi, long rdx, int ret,
-- 
2.22.0

