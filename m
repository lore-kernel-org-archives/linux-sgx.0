Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737F2ECE596
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46A682084D
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbfJHEqS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:8176 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729613AbfJHEqR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566524"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 12/16] selftests/x86/sgx: Move existing sub-test to a separate helper
Date:   Mon,  7 Oct 2019 21:46:09 -0700
Message-Id: <20191008044613.12350-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move the basic test of running the enclave using the vDSO to a separate
helper in preparation for introducing new sub-tests and variations on
the existing test.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index b7b32cf144f4..93b8d7781782 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -307,14 +307,28 @@ void load_sigstruct(const char *path, struct sgx_sigstruct *sigstruct)
 int sgx_call(void *rdi, void *rsi, long rdx, long rcx, long r8, long r9,
 	     void *tcs, struct sgx_enclave_exception *ei, void *cb);
 
-int main(int argc, char *argv[], char *envp[])
+/*
+ * Test the vDSO API, __vdso_sgx_enter_enclave(), without an exit handler.
+ */
+static void test_vdso_no_exit_handler(struct sgx_secs *secs)
 {
 	struct sgx_enclave_exception exception;
+	uint64_t result = 0;
+
+	memset(&exception, 0, sizeof(exception));
+
+	/* Verify the enclave copies MAGIC to result. */
+	sgx_call((void *)&MAGIC, &result, 0, 0, 0, 0, (void *)secs->base,
+		 &exception, NULL);
+	ASSERT_EQ(result, MAGIC);
+}
+
+int main(int argc, char *argv[], char *envp[])
+{
 	struct sgx_sigstruct sigstruct;
 	struct vdso_symtab symtab;
 	Elf64_Sym *eenter_sym;
 	struct sgx_secs secs;
-	uint64_t result = 0;
 	off_t bin_size;
 	void *bin;
 	void *addr;
@@ -323,8 +337,6 @@ int main(int argc, char *argv[], char *envp[])
 
 	load_sigstruct("encl.ss", &sigstruct);
 
-	memset(&exception, 0, sizeof(exception));
-
 	addr = vdso_get_base_addr();
 	ASSERT_NE(addr, NULL);
 
@@ -337,10 +349,7 @@ int main(int argc, char *argv[], char *envp[])
 
 	encl_build(&secs, bin, bin_size, &sigstruct);
 
-	sgx_call((void *)&MAGIC, &result, 0, 0, 0, 0, (void *)secs.base,
-		 &exception, NULL);
-
-	ASSERT_EQ(result, MAGIC);
+	test_vdso_no_exit_handler(&secs);
 
 	printf("All tests passed!\n");
 	exit(0);
-- 
2.22.0

