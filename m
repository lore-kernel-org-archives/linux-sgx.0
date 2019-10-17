Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A184FA372D
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 230B021A49
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392091AbfJQDDq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 23:03:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:45377 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392057AbfJQDDq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 23:03:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 20:03:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="195026841"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 20:03:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v2? v2 07/14] selftests/x86/sgx: Use standard helper function to signal pass/fail
Date:   Wed, 16 Oct 2019 20:03:33 -0700
Message-Id: <20191017030340.18301-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017030340.18301-1-sean.j.christopherson@intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use the various helpers provided by kselftest.h to configure the test
and signal/pass failure.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 140dffe9c765..664a2ed98915 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -17,6 +17,8 @@
 #include <sys/types.h>
 #include <sys/auxv.h>
 
+#include "../../kselftest.h"
+
 #include "defines.h"
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
@@ -336,15 +338,12 @@ static void test_sgx_basic(struct sgx_secs *secs)
 {
 	uint64_t result = 0;
 
-	printf("Input: 0x%lx\n", MAGIC);
-
 	sgx_call_eenter((void *)&MAGIC, &result, (void *)secs->base);
 	if (result != MAGIC) {
-		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
-		exit(1);
+		ksft_test_result_error("0x%lx != 0x%lx\n", result, MAGIC);
+		return;
 	}
-
-	printf("Output: 0x%lx\n", result);
+	ksft_test_result_pass("%s: Passed\n", __func__);
 }
 
 static void test_sgx_vdso(struct sgx_secs *secs)
@@ -354,16 +353,13 @@ static void test_sgx_vdso(struct sgx_secs *secs)
 
 	memset(&exception, 0, sizeof(exception));
 
-	printf("Input: 0x%lx\n", MAGIC);
-
 	sgx_call_vdso((void *)&MAGIC, &result, NULL, NULL, NULL, NULL,
 		      (void *)secs->base, &exception, NULL);
 	if (result != MAGIC) {
-		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
-		exit(1);
+		ksft_test_result_error("0x%lx != 0x%lx\n", result, MAGIC);
+		return;
 	}
-
-	printf("Output: 0x%lx\n", result);
+	ksft_test_result_pass("%s: Passed\n", __func__);
 }
 
 int main(int argc, char *argv[], char *envp[])
@@ -373,6 +369,9 @@ int main(int argc, char *argv[], char *envp[])
 	off_t bin_size;
 	void *bin;
 
+	ksft_print_header();
+	ksft_set_plan(2);
+
 	if (!encl_data_map("encl.bin", &bin, &bin_size))
 		exit(1);
 
@@ -389,5 +388,5 @@ int main(int argc, char *argv[], char *envp[])
 
 	test_sgx_vdso(&secs);
 
-	exit(0);
+	return ksft_exit_pass();
 }
-- 
2.22.0

