Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DB7FA3730
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B40D21925
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392057AbfJQDDq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 23:03:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:16893 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392120AbfJQDDq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 23:03:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 20:03:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="195026854"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 20:03:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v2? v2 11/14] selftests/x86/sgx: Add a check on the vDSO exception reporting mechanism
Date:   Wed, 16 Oct 2019 20:03:37 -0700
Message-Id: <20191017030340.18301-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017030340.18301-1-sean.j.christopherson@intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a check to verify that an exception on EENTER is correctly reported.
Although the type of exception doesn't truly matter, e.g. a page fault
is no more or less interesting than a general protection fault, use an
unaligned TCS to trigger a #GP to avoid complications on platforms that
report EPCM related #PFs as #GPs, e.g. SGX1 systems.

Suggested-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/defines.h | 4 ++++
 tools/testing/selftests/x86/sgx/main.c    | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/x86/sgx/defines.h b/tools/testing/selftests/x86/sgx/defines.h
index 1e67f2f29f42..b303bcaeb8dd 100644
--- a/tools/testing/selftests/x86/sgx/defines.h
+++ b/tools/testing/selftests/x86/sgx/defines.h
@@ -36,4 +36,8 @@ typedef uint64_t u64;
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
 
+#define ENCLU_EENTER	2
+
+#define GP_VECTOR 13
+
 #endif /* DEFINES_H */
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 24647050657a..56e13ae4f1ce 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -334,6 +334,12 @@ static void test_sgx_vdso(struct sgx_secs *secs)
 	sgx_call_vdso((void *)&MAGIC, &result, NULL, NULL, NULL, NULL,
 		      (void *)secs->base, &exception, NULL);
 	EXPECT_EQ(result, MAGIC);
+
+	/* Verify a #GP is reported if the TCS isn't 4k aligned. */
+	sgx_call_vdso((void *)&MAGIC, &result, NULL, NULL, NULL, NULL,
+		      (void *)(secs->base | 0xfff), &exception, NULL);
+	EXPECT_EQ(exception.trapnr, GP_VECTOR);
+	EXPECT_EQ(exception.leaf, ENCLU_EENTER);
 }
 
 int main(int argc, char *argv[], char *envp[])
-- 
2.22.0

