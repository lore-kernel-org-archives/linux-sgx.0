Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC04C43461
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4FF92087C
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgIDKpF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 06:45:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:43129 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729930AbgIDKpE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 06:45:04 -0400
IronPort-SDR: guuGhad5eU6tAi662a7kgZzGTuAbPtQjUWiCftbcOmxVCrz0uBQmfXmIsVUnV+vwTU5FiWleRB
 Al6V3MKTHZZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="145455666"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="145455666"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 03:44:48 -0700
IronPort-SDR: QBzi98Hgk9UWni+Vi36Z9WvGjWSSPIRdvNaU+lITfW+yJE/MmvooVr07uhZ5FjWAITLwrD7/GR
 ytzsYYy2qbaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="283026292"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga007.fm.intel.com with ESMTP; 04 Sep 2020 03:44:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v37 6/6] selftests/sgx: Add a smoke test to ensure the user handler is invoked
Date:   Fri,  4 Sep 2020 03:44:37 -0700
Message-Id: <20200904104437.29555-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904104437.29555-1-sean.j.christopherson@intel.com>
References: <20200904104437.29555-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a very simple exit handler and use it as a third variant of the SGX
selftest to verify that the vDSO invokes then user's handler when one is
supplied.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/sgx/main.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 158ea9e2b6d3a..44acb3c720675 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -137,10 +137,21 @@ int check_result(struct sgx_enclave_run *run, int ret, uint64_t result,
 		printf("FAIL: %s(), expected: 0x%lx, got: 0x%lx\n",
 		       test, MAGIC, result);
 		return -EIO;
+	} else if (run->user_data) {
+		printf("FAIL: %s() user data, expected: 0x0, got: 0x%llx\n",
+		       test, run->user_data);
+		return -EIO;
 	}
 	return 0;
 }
 
+static int exit_handler(long rdi, long rsi, long rdx, long ursp, long r8, long r9,
+			struct sgx_enclave_run *run)
+{
+	run->user_data = 0;
+	return 0;
+}
+
 int main(int argc, char *argv[], char *envp[])
 {
 	struct sgx_enclave_run run;
@@ -203,6 +214,14 @@ int main(int argc, char *argv[], char *envp[])
 	if (check_result(&run, ret, result, "eenter"))
 		goto err;
 
+	/* And with an exit handler. */
+	run.user_handler = exit_handler;
+	run.user_data = 0xdeadbeef;
+	ret = eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, EENTER,
+		     0, 0, &run);
+	if (check_result(&run, ret, result, "exit_handler"))
+		goto err;
+
 	printf("SUCCESS\n");
 	encl_delete(&encl);
 	exit(0);
-- 
2.28.0

