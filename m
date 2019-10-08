Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701CAECE597
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 461A220679
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbfJHEqT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:8177 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfJHEqS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566530"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 14/16] selftests/x86/sgx: Add test of vDSO with basic exit handler
Date:   Mon,  7 Oct 2019 21:46:11 -0700
Message-Id: <20191008044613.12350-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
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
 tools/testing/selftests/x86/sgx/main.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 2676570493f2..ae1822b10c6f 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -329,6 +329,31 @@ static void test_vdso_no_exit_handler(struct sgx_secs *secs)
 	ASSERT_EQ(exception.leaf, ENCLU_EENTER);
 }
 
+static int basic_exit_handler(long rdi, long rsi, long rdx, int ret,
+			      long r8, long r9, void *tcs, long ursp,
+			      struct sgx_enclave_exception *e)
+{
+	ASSERT_EQ(ret, 0);
+	return 0;
+}
+
+/*
+ * Test the vDSO API, __vdso_sgx_enter_enclave(), with an exit handler.
+ */
+static void test_vdso_with_exit_handler(struct sgx_secs *secs)
+{
+	struct sgx_enclave_exception exception;
+	uint64_t result = 0;
+	long ret;
+
+	memset(&exception, 0, sizeof(exception));
+
+	ret = sgx_call((void *)&MAGIC, &result, 0, 0, 0, 0, (void *)secs->base,
+		       &exception, basic_exit_handler);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(result, MAGIC);
+}
+
 int main(int argc, char *argv[], char *envp[])
 {
 	struct sgx_sigstruct sigstruct;
@@ -356,6 +381,7 @@ int main(int argc, char *argv[], char *envp[])
 	encl_build(&secs, bin, bin_size, &sigstruct);
 
 	test_vdso_no_exit_handler(&secs);
+	test_vdso_with_exit_handler(&secs);
 
 	printf("All tests passed!\n");
 	exit(0);
-- 
2.22.0

