Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DADFA3732
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9139D21925
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392126AbfJQDDr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 23:03:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:16893 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392129AbfJQDDq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 23:03:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 20:03:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="195026857"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 20:03:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v2? v2 12/14] selftests/x86/sgx: Add test of vDSO with basic exit handler
Date:   Wed, 16 Oct 2019 20:03:38 -0700
Message-Id: <20191017030340.18301-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017030340.18301-1-sean.j.christopherson@intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a test to verify that nothing explodes when using an exit handler to
control the flow of the vDSO.

Suggested-by: Suggested-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 28 +++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 56e13ae4f1ce..0a4716cef486 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -342,6 +342,31 @@ static void test_sgx_vdso(struct sgx_secs *secs)
 	EXPECT_EQ(exception.leaf, ENCLU_EENTER);
 }
 
+static int basic_exit_handler(long rdi, long rsi, long rdx, long ursp,
+			      long r8, long r9, void *tcs, int ret,
+			      struct sgx_enclave_exception *e)
+{
+	ASSERT_EQ(ret, 0);
+	return 0;
+}
+
+/*
+ * Test the vDSO API, __vdso_sgx_enter_enclave(), with an exit handler.
+ */
+static void test_sgx_vdso_exit_handler(struct sgx_secs *secs)
+{
+	struct sgx_enclave_exception exception;
+	uint64_t result = 0;
+	long ret;
+
+	memset(&exception, 0, sizeof(exception));
+
+	ret = sgx_call_vdso((void *)&MAGIC, &result, NULL, NULL, NULL, NULL,
+			    (void *)secs->base, &exception, basic_exit_handler);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(result, MAGIC);
+}
+
 int main(int argc, char *argv[], char *envp[])
 {
 	struct sgx_sigstruct sigstruct;
@@ -350,7 +375,7 @@ int main(int argc, char *argv[], char *envp[])
 	void *bin;
 
 	ksft_print_header();
-	ksft_set_plan(2);
+	ksft_set_plan(3);
 
 	bin = encl_data_map("encl.bin", &bin_size);
 
@@ -363,6 +388,7 @@ int main(int argc, char *argv[], char *envp[])
 	setup_vdso();
 
 	RUN_TEST(test_sgx_vdso);
+	RUN_TEST(test_sgx_vdso_exit_handler);
 
 	return ksft_exit_pass();
 }
-- 
2.22.0

