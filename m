Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C76C5ECE59B
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A8DF2084D
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfJHEqS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:8176 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfJHEqS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566527"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 13/16] selftests/x86/sgx: Add a test of the vDSO exception reporting mechanism
Date:   Mon,  7 Oct 2019 21:46:10 -0700
Message-Id: <20191008044613.12350-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a sub-test to verify that an exception on EENTER is correctly
reported.  Although the type of exception doesn't truly matter, e.g. a
page fault (#PF) is no more or less interesting than a general protection
fault (#GP), use an unaligned TCS to trigger a #GP to avoid errors on
platforms that report EPCM related #PFs as #GPs, e.g. SGX1 systems.

Suggested-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/defines.h | 4 ++++
 tools/testing/selftests/x86/sgx/main.c    | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/x86/sgx/defines.h b/tools/testing/selftests/x86/sgx/defines.h
index 3ff73a9d9b93..ab9671b8a993 100644
--- a/tools/testing/selftests/x86/sgx/defines.h
+++ b/tools/testing/selftests/x86/sgx/defines.h
@@ -36,4 +36,8 @@ typedef uint64_t u64;
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
 
+#define ENCLU_EENTER	2
+
+#define GP_VECTOR 13
+
 #endif /* TYPES_H */
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 93b8d7781782..2676570493f2 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -321,6 +321,12 @@ static void test_vdso_no_exit_handler(struct sgx_secs *secs)
 	sgx_call((void *)&MAGIC, &result, 0, 0, 0, 0, (void *)secs->base,
 		 &exception, NULL);
 	ASSERT_EQ(result, MAGIC);
+
+	/* Verify a #GP is reported if the TCS isn't 4k aligned. */
+	sgx_call((void *)&MAGIC, &result, 0, 0, 0, 0,
+		 (void *)(secs->base | 0xfff), &exception, NULL);
+	ASSERT_EQ(exception.trapnr, GP_VECTOR);
+	ASSERT_EQ(exception.leaf, ENCLU_EENTER);
 }
 
 int main(int argc, char *argv[], char *envp[])
-- 
2.22.0

