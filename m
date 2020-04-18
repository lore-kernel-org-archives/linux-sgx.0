Return-Path: <SRS0=25jF=6C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B10C38A2C
	for <linux-sgx@archiver.kernel.org>; Sat, 18 Apr 2020 04:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E612F21D91
	for <linux-sgx@archiver.kernel.org>; Sat, 18 Apr 2020 04:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgDREgM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 18 Apr 2020 00:36:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:25561 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgDREgM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 18 Apr 2020 00:36:12 -0400
IronPort-SDR: 8pbUu6gTzmw2iOQaCO6JjorA+j17yhGw/gLkkdtWPyHllB/n8MaMKK92XilgLb8c8oNn0QZ5gS
 Dbx9rUwT5y4g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 21:36:11 -0700
IronPort-SDR: uep3E1Dq6EVBReWcaEsc0VrciWjoDr9ZljvYgxoaGEajFwdCfYlY90ec/zE782+0LkN0d60LDL
 jboSvTNoCkiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,397,1580803200"; 
   d="scan'208";a="289459980"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 17 Apr 2020 21:36:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 v3 2/2] selftests/sgx: Add selftest to invoke __vsgx_enter_enclave() from C
Date:   Fri, 17 Apr 2020 21:36:09 -0700
Message-Id: <20200418043609.29406-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200418043609.29406-1-sean.j.christopherson@intel.com>
References: <20200418043609.29406-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a selftest to call __vsgx_enter_enclave() from C.  Stop clearing
non-volatile registers in the enclave's trampoline code to avoid
clobbering the untrusted runtime's state when the vDSO is called from C.

Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/sgx/main.c             | 18 +++++++++++++++---
 .../selftests/sgx/test_encl_bootstrap.S        |  6 +-----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index f6bb40f22884..5394b2f6af8e 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -19,7 +19,7 @@
 #include "main.h"
 
 static const uint64_t MAGIC = 0x1122334455667788ULL;
-void *eenter;
+vdso_sgx_enter_enclave_t eenter;
 
 struct vdso_symtab {
 	Elf64_Sym *elf_symtab;
@@ -173,15 +173,27 @@ int main(int argc, char *argv[], char *envp[])
 
 	sgx_call_vdso((void *)&MAGIC, &result, 0, EENTER, NULL, NULL,
 		      (void *)encl.encl_base, &exception, NULL);
-	if (result != MAGIC)
+	if (result != MAGIC) {
+		printf("FAIL: sgx_call_vdso(), expected: 0x%lx, got: 0x%lx\n",
+		       MAGIC, result);
 		goto err;
+	}
+
+	/* Invoke the vDSO directly. */
+	result = 0;
+	eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, EENTER, 0, 0,
+	       (void *)encl.encl_base, &exception, NULL);
+	if (result != MAGIC) {
+		printf("FAIL: eenter(), expected: 0x%lx, got: 0x%lx\n",
+		       MAGIC, result);
+		goto err;
+	}
 
 	printf("SUCCESS\n");
 	encl_delete(&encl);
 	exit(0);
 
 err:
-	printf("FAILURE\n");
 	encl_delete(&encl);
 	exit(1);
 }
diff --git a/tools/testing/selftests/sgx/test_encl_bootstrap.S b/tools/testing/selftests/sgx/test_encl_bootstrap.S
index 6a5d734cbf16..6836ea86126e 100644
--- a/tools/testing/selftests/sgx/test_encl_bootstrap.S
+++ b/tools/testing/selftests/sgx/test_encl_bootstrap.S
@@ -54,7 +54,7 @@ encl_entry:
 
 	pop	%rbx # pop the enclave base address
 
-	# Clear GPRs.
+	/* Clear volatile GPRs, except RAX (EEXIT leaf). */
 	xor     %rcx, %rcx
 	xor     %rdx, %rdx
 	xor     %rdi, %rdi
@@ -63,10 +63,6 @@ encl_entry:
 	xor     %r9, %r9
 	xor     %r10, %r10
 	xor     %r11, %r11
-	xor     %r12, %r12
-	xor     %r13, %r13
-	xor     %r14, %r14
-	xor     %r15, %r15
 
 	# Reset status flags.
 	add     %rdx, %rdx # OF = SF = AF = CF = 0; ZF = PF = 1
-- 
2.26.0

