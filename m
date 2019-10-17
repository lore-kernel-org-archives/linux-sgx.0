Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF71FA3734
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F22821925
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392135AbfJQDDr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 23:03:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:16893 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392136AbfJQDDr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 23:03:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 20:03:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="195026864"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 20:03:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v2? v2 14/14] selftests/x86/sgx: Add test for exception behavior with exit handler
Date:   Wed, 16 Oct 2019 20:03:40 -0700
Message-Id: <20191017030340.18301-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017030340.18301-1-sean.j.christopherson@intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a test to verify the kernel and vDSO provide the correct exception
info when using an exit handler, e.g. leaf, trapnr and error_code, and
that the vDSO correctly interprets the return from the exit handler.  To
do so, change the enclave's protections to PROT_NONE and iteratively fix
the faults encountered, with various assertions along the way, e.g. the
first fault should always be on the TCS, at least three total faults
should occur, etc...

Suggested-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/defines.h |  2 +
 tools/testing/selftests/x86/sgx/main.c    | 92 ++++++++++++++++++++++-
 2 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/sgx/defines.h b/tools/testing/selftests/x86/sgx/defines.h
index c4d8b88f3d8a..f9923fe64aff 100644
--- a/tools/testing/selftests/x86/sgx/defines.h
+++ b/tools/testing/selftests/x86/sgx/defines.h
@@ -38,7 +38,9 @@ typedef uint64_t u64;
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
 
 #define ENCLU_EENTER	2
+#define ENCLU_ERESUME	3
 
 #define GP_VECTOR 13
+#define PF_VECTOR 14
 
 #endif /* DEFINES_H */
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 5ebe25dc877c..3f657902ba3f 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -381,6 +381,95 @@ static void test_sgx_vdso_exit_handler(struct sgx_secs *secs)
 	ASSERT_EQ(result, MAGIC);
 }
 
+static int nr_page_faults;
+
+static int mprotect_exit_handler(long rdi, long rsi, long rdx, long ursp,
+				 long r8, long r9, void *tcs, int ret,
+				 struct sgx_enclave_exception *e)
+{
+	int prot, rc;
+
+	if (!ret)
+		return 0;
+
+	++nr_page_faults;
+
+	ASSERT_EQ(ret, -EFAULT);
+	ASSERT_EQ(e->trapnr, PF_VECTOR);
+	ASSERT_RAW(e->leaf == ENCLU_EENTER || e->leaf == ENCLU_ERESUME,
+		    "Expected #PF on EENTER or ERESUME, leaf = %d\n", e->leaf);
+
+	/* The first #PF should be on the TCS, passed in via R9. */
+	if (nr_page_faults == 1) {
+		ASSERT_EQ(r9, (e->address & ~0xfff));
+		ASSERT_TRUE(e->error_code & 0x2);
+	}
+
+	prot = PROT_READ;
+	if (e->error_code & 0x2)
+		prot |= PROT_WRITE;
+	if (e->error_code & 0x10)
+		prot |= PROT_EXEC;
+	rc = mprotect((void *)(e->address & ~0xfff), PAGE_SIZE, prot);
+	ASSERT_EQ(rc, 0);
+
+	/*
+	 * If EENTER faulted, bounce all the way back to the test to verify
+	 * the vDSO is handling the return value correctly.
+	 */
+	if (e->leaf == ENCLU_EENTER)
+		return -EAGAIN;
+
+	/* Else ERESUME faulted, simply do ERESUME again. */
+	return e->leaf;
+}
+
+static void test_sgx_vdso_exception_handler(struct sgx_secs *secs)
+{
+	struct sgx_enclave_exception exception;
+	uint64_t result = 0;
+	int ret;
+
+	memset(&exception, 0, sizeof(exception));
+
+	/*
+	 * Make all pages inaccessible, then re-enter the enclave.  The exit
+	 * handler will service the resulting page faults using mprotect() to
+	 * restore the correct permissions.
+	 */
+	ret = mprotect((void *)secs->base, secs->size, PROT_NONE);
+	ASSERT_RAW(!ret, "mprotect() on enclave failed: %s\n", strerror(errno));
+
+	/* Loop on EENTER until it succeeds or it fails unexpectedly. */
+	result = 0;
+	do {
+		/*
+		 * Pass the address of the TCS to the exit handler via R9.
+		 * The first page fault should be on the TCS and R9 should
+		 * not be modified prior to entering the enclave (whic
+		 * requires an accessible TCS page).
+		 */
+		ret = sgx_call_vdso((void *)&MAGIC, &result, NULL, NULL, NULL,
+				    (void *)secs->base, (void *)secs->base,
+				    &exception, mprotect_exit_handler);
+	} while (ret == -EAGAIN);
+	EXPECT_EQ(ret, 0);
+	EXPECT_EQ(result, MAGIC);
+
+	/* Enclave should re-execute cleanly. */
+	result = 0;
+	ret = sgx_call_vdso((void *)&MAGIC, &result, NULL, NULL, NULL, NULL,
+			    (void *)secs->base, &exception, basic_exit_handler);
+	EXPECT_EQ(ret, 0);
+	EXPECT_EQ(result, MAGIC);
+
+	/*
+	 * At least three faults should occur: one for the TCS, one for the
+	 * executable code, and one for the writable data (@result).
+	 */
+	EXPECT_GE(nr_page_faults, 3);
+}
+
 int main(int argc, char *argv[], char *envp[])
 {
 	struct sgx_sigstruct sigstruct;
@@ -389,7 +478,7 @@ int main(int argc, char *argv[], char *envp[])
 	void *bin;
 
 	ksft_print_header();
-	ksft_set_plan(3);
+	ksft_set_plan(4);
 
 	bin = encl_data_map("encl.bin", &bin_size);
 
@@ -403,6 +492,7 @@ int main(int argc, char *argv[], char *envp[])
 
 	RUN_TEST(test_sgx_vdso);
 	RUN_TEST(test_sgx_vdso_exit_handler);
+	RUN_TEST(test_sgx_vdso_exception_handler);
 
 	return ksft_exit_pass();
 }
-- 
2.22.0

