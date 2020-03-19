Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867D4C4332E
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67BB720768
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCSBLh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 21:11:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:30443 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSBLh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 21:11:37 -0400
IronPort-SDR: dgxi80c2uPLU4hM1TbES6z+Clfwa4M0O3Eq7m7AluTJkCOK1aKNy45BfhqYV93vgLPDFn3eCbZ
 80LSS6ZjYK3g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 18:11:35 -0700
IronPort-SDR: IJIs2yg1Qp3yBQgTSzimVGXO0Y2rfVpmEzPd3FPKwEs5Yg2M5ets1gYGbC2nEKXyxmyIxHuMv9
 HY42WbmKiT0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="324358706"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 18 Mar 2020 18:11:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 6/8] selftests/x86: sgx: Pass EENTER to vDSO wrapper instead of hardcoding
Date:   Wed, 18 Mar 2020 18:11:28 -0700
Message-Id: <20200319011130.8556-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319011130.8556-1-sean.j.christopherson@intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Pass EENTER to the vDSO wrapper via %ecx instead of hardcoding it to
make the wrapper compatible with the new vDSO calling convention.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c     | 2 +-
 tools/testing/selftests/x86/sgx/sgx_call.S | 1 -
 tools/testing/selftests/x86/sgx/sgx_call.h | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index c9c37d2bbec8..9b89946a976b 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -367,7 +367,7 @@ int main(int argc, char *argv[], char *envp[])
 	printf("Input: 0x%lx\n", MAGIC);
 
 	result = 0;
-	sgx_call_vdso((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+	sgx_call_vdso((void *)&MAGIC, &result, 0, 2, NULL, NULL,
 		      (void *)secs.base, &exception, NULL);
 	if (result != MAGIC) {
 		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
diff --git a/tools/testing/selftests/x86/sgx/sgx_call.S b/tools/testing/selftests/x86/sgx/sgx_call.S
index e71f44f7a995..79b4c80e4a1c 100644
--- a/tools/testing/selftests/x86/sgx/sgx_call.S
+++ b/tools/testing/selftests/x86/sgx/sgx_call.S
@@ -48,7 +48,6 @@ sgx_call_vdso:
 	.cfi_adjust_cfa_offset	8
 	push	0x48(%rsp)
 	.cfi_adjust_cfa_offset	8
-	mov	$2, %eax
 	call	*eenter(%rip)
 	add	$0x20, %rsp
 	.cfi_adjust_cfa_offset	-0x20
diff --git a/tools/testing/selftests/x86/sgx/sgx_call.h b/tools/testing/selftests/x86/sgx/sgx_call.h
index a4072c5ecce7..02f1ef292823 100644
--- a/tools/testing/selftests/x86/sgx/sgx_call.h
+++ b/tools/testing/selftests/x86/sgx/sgx_call.h
@@ -8,7 +8,7 @@
 
 void sgx_call_eenter(void *rdi, void *rsi, void *entry);
 
-int sgx_call_vdso(void *rdi, void *rsi, long rdx, void *rcx, void *r8, void *r9,
+int sgx_call_vdso(void *rdi, void *rsi, long rdx, long rcx, void *r8, void *r9,
 		  void *tcs, struct sgx_enclave_exception *ei, void *cb);
 
 #endif /* SGX_CALL_H */
-- 
2.24.1

