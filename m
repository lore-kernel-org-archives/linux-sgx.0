Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CF2C43461
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D756620770
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgIDKpe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 06:45:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:43129 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729795AbgIDKpF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 06:45:05 -0400
IronPort-SDR: Zqjvamxcfu70yQbQ3EGkjx5dKzsDzJlQo/pasmm4N1xz2nPyVcm9Q6mKYVzXmBA3HIwue/SQvu
 cF38oNSIqpqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="145455664"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="145455664"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 03:44:47 -0700
IronPort-SDR: SDpwdtTAk0I10/4M1YKzaJ6khTq4xJiGG/9wkkkrUgcTRS5koH5Lq9IMPEX9M/7BSdfaVdNJNk
 dZnPaf93Nb+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="283026286"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga007.fm.intel.com with ESMTP; 04 Sep 2020 03:44:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v37 4/6] selftests/sgx: Update the SGX selftest to match the reworked vDSO API
Date:   Fri,  4 Sep 2020 03:44:35 -0700
Message-Id: <20200904104437.29555-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904104437.29555-1-sean.j.christopherson@intel.com>
References: <20200904104437.29555-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Update the call to __vdso_sgx_enter_enclave() to use the sgx_enclave_run
struct instead of cramming parameters into the function call itself.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/sgx/call.S | 10 +++-------
 tools/testing/selftests/sgx/main.c | 11 +++++------
 tools/testing/selftests/sgx/main.h |  2 +-
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/sgx/call.S b/tools/testing/selftests/sgx/call.S
index 77131e83db424..c4837965dfbb4 100644
--- a/tools/testing/selftests/sgx/call.S
+++ b/tools/testing/selftests/sgx/call.S
@@ -31,15 +31,11 @@ sgx_call_vdso:
 	.cfi_rel_offset		%rbx, 0
 	push	$0
 	.cfi_adjust_cfa_offset	8
-	push	0x48(%rsp)
-	.cfi_adjust_cfa_offset	8
-	push	0x48(%rsp)
-	.cfi_adjust_cfa_offset	8
-	push	0x48(%rsp)
+	push	0x38(%rsp)
 	.cfi_adjust_cfa_offset	8
 	call	*eenter(%rip)
-	add	$0x20, %rsp
-	.cfi_adjust_cfa_offset	-0x20
+	add	$0x10, %rsp
+	.cfi_adjust_cfa_offset	-0x10
 	pop	%rbx
 	.cfi_adjust_cfa_offset	-8
 	pop	%r12
diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 8d95569e7a66f..17f36e590fbd2 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -125,7 +125,7 @@ static Elf64_Sym *vdso_symtab_get(struct vdso_symtab *symtab, const char *name)
 
 int main(int argc, char *argv[], char *envp[])
 {
-	struct sgx_enclave_exception exception;
+	struct sgx_enclave_run run;
 	struct vdso_symtab symtab;
 	Elf64_Sym *eenter_sym;
 	uint64_t result = 0;
@@ -156,7 +156,8 @@ int main(int argc, char *argv[], char *envp[])
 		}
 	}
 
-	memset(&exception, 0, sizeof(exception));
+	memset(&run, 0, sizeof(run));
+	run.tcs = encl.encl_base;
 
 	addr = vdso_get_base_addr(envp);
 	if (!addr)
@@ -171,8 +172,7 @@ int main(int argc, char *argv[], char *envp[])
 
 	eenter = addr + eenter_sym->st_value;
 
-	sgx_call_vdso((void *)&MAGIC, &result, 0, EENTER, NULL, NULL,
-		      (void *)encl.encl_base, &exception, NULL);
+	sgx_call_vdso((void *)&MAGIC, &result, 0, EENTER, NULL, NULL, &run);
 	if (result != MAGIC) {
 		printf("FAIL: sgx_call_vdso(), expected: 0x%lx, got: 0x%lx\n",
 		       MAGIC, result);
@@ -181,8 +181,7 @@ int main(int argc, char *argv[], char *envp[])
 
 	/* Invoke the vDSO directly. */
 	result = 0;
-	eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, EENTER, 0, 0,
-	       (void *)encl.encl_base, &exception, NULL);
+	eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, EENTER, 0, 0, &run);
 	if (result != MAGIC) {
 		printf("FAIL: eenter(), expected: 0x%lx, got: 0x%lx\n",
 		       MAGIC, result);
diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/sgx/main.h
index 999422cc73438..2b4777942500f 100644
--- a/tools/testing/selftests/sgx/main.h
+++ b/tools/testing/selftests/sgx/main.h
@@ -33,6 +33,6 @@ bool encl_measure(struct encl *encl);
 bool encl_build(struct encl *encl);
 
 int sgx_call_vdso(void *rdi, void *rsi, long rdx, u32 leaf, void *r8, void *r9,
-		  void *tcs, struct sgx_enclave_exception *ei, void *cb);
+		  struct sgx_enclave_run *run);
 
 #endif /* MAIN_H */
-- 
2.28.0

