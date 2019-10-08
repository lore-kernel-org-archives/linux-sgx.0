Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914EBECE598
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 719FD206C2
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbfJHEqT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:8177 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729638AbfJHEqT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566533"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 15/16] selftests/x86/sgx: Add sub-test for exception behavior with exit handler
Date:   Mon,  7 Oct 2019 21:46:12 -0700
Message-Id: <20191008044613.12350-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a test to verify the kernel and vDSO provide the correct exception
info when using an exit handler, e.g. leaf, trapnr and error_code, and
that the vDSO correctly interprets the return from the exit handler.  To
do so, change the enclave's protections to read-only and iteratively fix
the faults encountered, with various assertions along the way, e.g. the
first fault should always be a !writable fault on the TCS, at least
three total faults should occur, etc...

Suggested-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/defines.h |  2 +
 tools/testing/selftests/x86/sgx/main.c    | 87 ++++++++++++++++++++++-
 2 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/defines.h b/tools/testing/selftests/x86/sgx/defines.h
index ab9671b8a993..199a830e198a 100644
--- a/tools/testing/selftests/x86/sgx/defines.h
+++ b/tools/testing/selftests/x86/sgx/defines.h
@@ -37,7 +37,9 @@ typedef uint64_t u64;
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
 
 #define ENCLU_EENTER	2
+#define ENCLU_ERESUME	3
 
 #define GP_VECTOR 13
+#define PF_VECTOR 14
 
 #endif /* TYPES_H */
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index ae1822b10c6f..8c3f0cd41098 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -337,14 +337,58 @@ static int basic_exit_handler(long rdi, long rsi, long rdx, int ret,
 	return 0;
 }
 
+static int nr_page_faults;
+
+static int mprotect_exit_handler(long rdi, long rsi, long rdx, int ret,
+				 long r8, long r9, void *tcs, long ursp,
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
+	TEST_ASSERT(e->leaf == ENCLU_EENTER || e->leaf == ENCLU_ERESUME,
+		    "Expected #PF on EENTER or ERESUME, leaf = %d\n", e->leaf);
+	TEST_ASSERT(e->error_code & 1, "Unexpected !PRESENT #PF");
+
+	/* The first #PF should be on the TCS, passed in via R9. */
+	if (nr_page_faults == 1)
+		ASSERT_EQ(r9, (e->address & ~0xfff));
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
 /*
  * Test the vDSO API, __vdso_sgx_enter_enclave(), with an exit handler.
  */
-static void test_vdso_with_exit_handler(struct sgx_secs *secs)
+static void test_vdso_with_exit_handler(struct sgx_secs *secs,
+					unsigned long encl_size)
 {
 	struct sgx_enclave_exception exception;
 	uint64_t result = 0;
 	long ret;
+	int r;
 
 	memset(&exception, 0, sizeof(exception));
 
@@ -352,6 +396,45 @@ static void test_vdso_with_exit_handler(struct sgx_secs *secs)
 		       &exception, basic_exit_handler);
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(result, MAGIC);
+
+	/*
+	 * Map the enclave read-only, then re-enter the enclave.  The exit
+	 * handler will service the resulting page faults using mprotect() to
+	 * restore the correct permissions.
+	 */
+	r = mprotect((void *)secs->base, encl_size, PROT_READ);
+	TEST_ASSERT(!r, "mprotect() on enclave failed: %s\n", strerror(errno));
+
+
+	/* Loop on EENTER until it succeeds or it fails unexpectedly. */
+	result = 0;
+	do {
+		/*
+		 * Pass the address of the TCS to the exit handler via R9.
+		 * The first page fault should be on the TCS and R9 should
+		 * not be modified prior to entering the enclave (which
+		 * requires an accessible TCS page).
+		 */
+		ret = sgx_call((void *)&MAGIC, &result, 0, 0, 0, secs->base,
+			       (void *)secs->base, &exception,
+			       mprotect_exit_handler);
+	} while (ret == -EAGAIN);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(result, MAGIC);
+
+	/* Enclave should re-execute cleanly. */
+	result = 0;
+	ret = sgx_call((void *)&MAGIC, &result, 0, 0, 0, 0, (void *)secs->base,
+		       &exception, basic_exit_handler);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(result, MAGIC);
+
+	/*
+	 * At least three faults should occur: one for the TCS, one for the
+	 * executable code, and one for the writable data (@result).
+	 */
+	TEST_ASSERT(nr_page_faults >= 3, "Expected 3+ page faults, only hit %d",
+		    nr_page_faults);
 }
 
 int main(int argc, char *argv[], char *envp[])
@@ -381,7 +464,7 @@ int main(int argc, char *argv[], char *envp[])
 	encl_build(&secs, bin, bin_size, &sigstruct);
 
 	test_vdso_no_exit_handler(&secs);
-	test_vdso_with_exit_handler(&secs);
+	test_vdso_with_exit_handler(&secs, bin_size);
 
 	printf("All tests passed!\n");
 	exit(0);
-- 
2.22.0

