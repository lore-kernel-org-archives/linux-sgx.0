Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EE7C282CE
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 00:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58BEE20859
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 00:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbfDWAh3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 20:37:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:13164 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731026AbfDWAh2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 20:37:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 17:37:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,383,1549958400"; 
   d="scan'208";a="225774539"
Received: from bxing-ubuntu.jf.intel.com ([10.23.30.27])
  by orsmga001.jf.intel.com with ESMTP; 22 Apr 2019 17:37:25 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, Hansen@vger.kernel.org,
        Dave <dave.hansen@intel.com>, Christopherson@vger.kernel.org,
        Sean J <sean.j.christopherson@intel.com>, nhorman@redhat.com,
        npmccallum@redhat.com, Ayoun@vger.kernel.org,
        Serge <serge.ayoun@intel.com>, Katz-zamir@vger.kernel.org,
        Shay <shay.katz-zamir@intel.com>, Huang@vger.kernel.org,
        Haitao <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        Svahn@vger.kernel.org, Kai <kai.svahn@intel.com>, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, Kai <kai.huang@intel.com>,
        rientjes@google.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Cedric Xing <cedric.xing@intel.com>
Subject: [RFC PATCH v1 3/3] selftests/x86: Augment SGX selftest to test new __vdso_sgx_enter_enclave() and its callback interface
Date:   Mon, 22 Apr 2019 17:37:25 -0700
Message-Id:
 <f82e81c9cae31634684964d3fc4e9637e7565c69.1555965327.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1555965327.git.cedric.xing@intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
In-Reply-To: <cover.1555965327.git.cedric.xing@intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <cover.1555965327.git.cedric.xing@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190423003725.J1biAfJ5-BNUmenefdnitTB26pA0L9RSoLzoR4O36mw@z>

Given the changes to __vdso_sgx_enter_enclave(), the selftest is augmented to
test the newly added callback interface. This addtional test marks the whole
enclave range as PROT_READ, and calls mprotect() upon #PFs to add necessary PTE
permissions per PFEC (#PF Error Code) until the enclave finishes.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c     | 123 ++++++++++++++++++---
 tools/testing/selftests/x86/sgx/sgx_call.S |  40 ++++++-
 2 files changed, 142 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index e2265f841fb0..234cfbad14a5 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -9,6 +9,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <errno.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
@@ -18,6 +19,10 @@
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
 
+#define _Q(x)	__Q(x)
+#define __Q(x)	#x
+#define ERRLN	"Line " _Q(__LINE__)
+
 static const uint64_t MAGIC = 0x1122334455667788ULL;
 
 struct vdso_symtab {
@@ -138,7 +143,7 @@ static bool encl_create(int dev_fd, unsigned long bin_size,
 	base = mmap(NULL, secs->size, PROT_READ | PROT_WRITE | PROT_EXEC,
 		    MAP_SHARED, dev_fd, 0);
 	if (base == MAP_FAILED) {
-		perror("mmap");
+		perror(ERRLN);
 		return false;
 	}
 
@@ -224,24 +229,113 @@ static bool encl_load(struct sgx_secs *secs, unsigned long bin_size)
 	return false;
 }
 
-void sgx_call(void *rdi, void *rsi, void *tcs,
-	      struct sgx_enclave_exception *exception,
-	      void *eenter);
+int sgx_call(void *rdi, void *rsi, long rdx, void *rcx, void *r8, void *r9,
+	     void *tcs, struct sgx_enclave_exinfo *ei, void *cb, void *eenter);
+
+static void show_enclave_exinfo(const struct sgx_enclave_exinfo *exinfop,
+				const char *header)
+{
+	printf("%s: leaf:%d", header, exinfop->leaf);
+	if (exinfop->leaf != 4)
+		printf(" trap#:%d ec:%d addr:0x%llx\n", exinfop->trapnr,
+			exinfop->error_code, exinfop->address);
+	else printf("\n");
+}
+
+static void test1(void *eenter, struct sgx_secs *secs)
+{
+	uint64_t result = 0;
+	struct sgx_enclave_exinfo exinfo;
+
+	printf("[1] Entering the enclave without callback.\n");
+
+	printf("Input: 0x%lx\n Expect: Same as input\n", MAGIC);
+	sgx_call((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+		 (void *)secs->base, &exinfo, NULL, eenter);
+	if (result != MAGIC) {
+		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
+		exit(1);
+	}
+	printf(" Output: 0x%lx\n", result);
+
+	printf("Input: Null TCS\n Expect: #PF at EENTER\n");
+	sgx_call((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+		 NULL, &exinfo, NULL, eenter);
+	show_enclave_exinfo(&exinfo, " Exit");
+	if (exinfo.leaf != 2 /*EENTER*/ || exinfo.trapnr != 14 /*#PF*/)
+		exit(1);
+}
+
+static int enclave_ex_callback(long rdi, long rsi, long rdx,
+	struct sgx_enclave_exinfo *ei, long r8, long r9, void *tcs, long ursp)
+{
+	show_enclave_exinfo(ei, "  callback");
+
+	switch (ei->leaf)
+	{
+	case 4:
+		return 0;
+	case 3:
+	case 2:
+		if (ei->trapnr != 14 /*#PF*/ || (ei->error_code & 1) == 0) {
+			fprintf(stderr, ERRLN ": Unexpected exception\n");
+			exit(1);
+		}
+
+		if (mprotect((void*)(ei->address & -0x1000), 0x1000,
+			     ((ei->error_code & 2) ? PROT_WRITE : 0) |
+			     ((ei->error_code & 0x10) ? PROT_EXEC : 0) |
+			     PROT_READ)) {
+			perror(ERRLN);
+			exit(1);
+		}
+
+		return ei->leaf == 2 ? -EAGAIN : ei->leaf;
+	}
+	return -EINVAL;
+}
+
+static void test2(void *eenter, struct sgx_secs *secs)
+{
+	uint64_t result = 0;
+	struct sgx_enclave_exinfo exinfo;
+
+	printf("[2] Entering the enclave with callback.\n");
+
+	printf("Input: 0x%lx\n Expect: Same as input\n", MAGIC);
+	sgx_call((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+		 (void *)secs->base, &exinfo, enclave_ex_callback, eenter);
+	if (result != MAGIC) {
+		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
+		exit(1);
+	}
+	printf(" Output: 0x%lx\n", result);
+
+	printf("Input: Read-only enclave (0x%lx-0x%lx)\n"
+	       " Expect: #PFs to be fixed by callback\n",
+	       secs->base, secs->base + (encl_bin_end - encl_bin) - 1);
+	if (mprotect((void*)secs->base, encl_bin_end - encl_bin, PROT_READ)) {
+		perror(ERRLN);
+		exit(1);
+	}
+	while (sgx_call((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+			(void*)secs->base, &exinfo, enclave_ex_callback,
+			eenter) == -EAGAIN);
+	show_enclave_exinfo(&exinfo, " Exit");
+	if (exinfo.leaf != 4 /*EEXIT*/)
+		exit(1);
+}
 
 int main(int argc, char *argv[], char *envp[])
 {
 	unsigned long bin_size = encl_bin_end - encl_bin;
 	unsigned long ss_size = encl_ss_end - encl_ss;
-	struct sgx_enclave_exception exception;
 	Elf64_Sym *eenter_sym;
 	struct vdso_symtab symtab;
 	struct sgx_secs secs;
-	uint64_t result = 0;
 	void *eenter;
 	void *addr;
 
-	memset(&exception, 0, sizeof(exception));
-
 	addr = vdso_get_base_addr(envp);
 	if (!addr)
 		exit(1);
@@ -266,14 +360,7 @@ int main(int argc, char *argv[], char *envp[])
 	if (!encl_load(&secs, bin_size))
 		exit(1);
 
-	printf("Input: 0x%lx\n", MAGIC);
-	sgx_call((void *)&MAGIC, &result, (void *)secs.base, &exception,
-		 eenter);
-	if (result != MAGIC) {
-		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
-		exit(1);
-	}
-
-	printf("Output: 0x%lx\n", result);
-	exit(0);
+	test1(eenter, &secs);
+	test2(eenter, &secs);
+	return 0;
 }
diff --git a/tools/testing/selftests/x86/sgx/sgx_call.S b/tools/testing/selftests/x86/sgx/sgx_call.S
index 14bd0a044199..da8f687a60d2 100644
--- a/tools/testing/selftests/x86/sgx/sgx_call.S
+++ b/tools/testing/selftests/x86/sgx/sgx_call.S
@@ -7,9 +7,43 @@
 
 	.global sgx_call
 sgx_call:
+	.cfi_startproc
+	push	%r15
+	.cfi_adjust_cfa_offset	8
+	.cfi_rel_offset		%r15, 0
+	push	%r14
+	.cfi_adjust_cfa_offset	8
+	.cfi_rel_offset		%r14, 0
+	push	%r13
+	.cfi_adjust_cfa_offset	8
+	.cfi_rel_offset		%r13, 0
+	push	%r12
+	.cfi_adjust_cfa_offset	8
+	.cfi_rel_offset		%r12, 0
 	push	%rbx
-	mov	$0x02, %rax
-	mov	%rdx, %rbx
-	call	*%r8
+	.cfi_adjust_cfa_offset	8
+	.cfi_rel_offset		%rbx, 0
+	push	$0
+	.cfi_adjust_cfa_offset	8
+	push	0x48(%rsp)
+	.cfi_adjust_cfa_offset	8
+	push	0x48(%rsp)
+	.cfi_adjust_cfa_offset	8
+	push	0x48(%rsp)
+	.cfi_adjust_cfa_offset	8
+	mov	$2, %eax
+	call	*0x68(%rsp)
+	add	$0x20, %rsp
+	.cfi_adjust_cfa_offset	-0x20
 	pop	%rbx
+	.cfi_adjust_cfa_offset	-8
+	pop	%r12
+	.cfi_adjust_cfa_offset	-8
+	pop	%r13
+	.cfi_adjust_cfa_offset	-8
+	pop	%r14
+	.cfi_adjust_cfa_offset	-8
+	pop	%r15
+	.cfi_adjust_cfa_offset	-8
 	ret
+	.cfi_endproc
-- 
2.17.1

