Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53F6FA3733
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBB2E21928
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392129AbfJQDDr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 23:03:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:51163 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392098AbfJQDDr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 23:03:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 20:03:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="195026827"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 20:03:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v2? v2 03/14] selftests/x86/sgx: Sanitize the types for sgx_vdso_call()'s input params
Date:   Wed, 16 Oct 2019 20:03:29 -0700
Message-Id: <20191017030340.18301-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017030340.18301-1-sean.j.christopherson@intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Convert the @rdx parameter for sgx_vdso_call() from 'long' to 'void *'
to make it consistent with all other register params.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c     | 2 +-
 tools/testing/selftests/x86/sgx/sgx_call.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index ad284539d418..fa93521ed4d3 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -356,7 +356,7 @@ int main(int argc, char *argv[], char *envp[])
 
 	printf("Input: 0x%lx\n", MAGIC);
 
-	sgx_call_vdso((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+	sgx_call_vdso((void *)&MAGIC, &result, NULL, NULL, NULL, NULL,
 		      (void *)secs.base, &exception, NULL);
 	if (result != MAGIC) {
 		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
diff --git a/tools/testing/selftests/x86/sgx/sgx_call.h b/tools/testing/selftests/x86/sgx/sgx_call.h
index a4072c5ecce7..2bf239aff0a8 100644
--- a/tools/testing/selftests/x86/sgx/sgx_call.h
+++ b/tools/testing/selftests/x86/sgx/sgx_call.h
@@ -8,7 +8,8 @@
 
 void sgx_call_eenter(void *rdi, void *rsi, void *entry);
 
-int sgx_call_vdso(void *rdi, void *rsi, long rdx, void *rcx, void *r8, void *r9,
+
+int sgx_call_vdso(void *rdi, void *rsi, void *rdx, void *rcx, void *r8, void *r9,
 		  void *tcs, struct sgx_enclave_exception *ei, void *cb);
 
 #endif /* SGX_CALL_H */
-- 
2.22.0

