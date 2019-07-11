Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479B4C74A46
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 04:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20C14206B8
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 04:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGKEVk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 00:21:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:22501 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfGKEVj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 00:21:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 21:21:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,476,1557212400"; 
   d="scan'208";a="186293861"
Received: from hmendezc-mobl1.amr.corp.intel.com (HELO ubt18m.amr.corp.intel.com) ([10.252.143.173])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jul 2019 21:21:38 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Cedric Xing <cedric.xing@intel.com>, luto@kernel.org,
        jethro@fortanix.com, greg@enjellic.com,
        jarkko.sakkinen@linux.intel.com, sean.j.christopherson@intel.com
Subject: [RFC PATCH v3 3/3] selftests/x86: Augment SGX selftest to test new __vdso_sgx_enter_enclave() and its callback interface
Date:   Wed, 10 Jul 2019 21:21:33 -0700
Message-Id: <bbc02489ca70bb347af43c9d49cce01f154b08b7.1562813643.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1562813643.git.cedric.xing@intel.com>
References: <cover.1562813643.git.cedric.xing@intel.com>
In-Reply-To: <cover.1562813643.git.cedric.xing@intel.com>
References: <20190424062623.4345-1-cedric.xing@intel.com> <cover.1562813643.git.cedric.xing@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This patch augments SGX selftest with two new tests.

The first test exercises the newly added callback interface, by marking the
whole enclave range as PROT_READ, then calling mprotect() upon #PFs to add
necessary PTE permissions per PFEC (#PF Error Code) until the enclave finishes.
This test also serves as an example to demonstrate the callback interface.

The second test single-steps through __vdso_sgx_enter_enclave() to make sure
the call stack can be unwound at every instruction within that vDSO API. Its
purpose is to validate the hand-crafted CFI directives in the assembly.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 tools/testing/selftests/x86/sgx/Makefile   |   6 +-
 tools/testing/selftests/x86/sgx/main.c     | 323 ++++++++++++++++++---
 tools/testing/selftests/x86/sgx/sgx_call.S |  40 ++-
 3 files changed, 322 insertions(+), 47 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index 3af15d7c8644..31f937e220c4 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -14,16 +14,16 @@ TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
 all_64: $(TEST_CUSTOM_PROGS)
 
 $(TEST_CUSTOM_PROGS): main.c sgx_call.S $(OUTPUT)/encl_piggy.o
-	$(CC) $(HOST_CFLAGS) -o $@ $^
+	$(CC) $(HOST_CFLAGS) -o $@ $^ -lunwind -ldl -Wl,--defsym,__image_base=0 -pie
 
 $(OUTPUT)/encl_piggy.o: encl_piggy.S $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
 	$(CC) $(HOST_CFLAGS) -I$(OUTPUT) -c $< -o $@
 
 $(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf
-	objcopy --remove-section=.got.plt -O binary $< $@
+	objcopy -O binary $< $@
 
 $(OUTPUT)/encl.elf: encl.lds encl.c encl_bootstrap.S
-	$(CC) $(ENCL_CFLAGS) -T $^ -o $@
+	$(CC) $(ENCL_CFLAGS) -T $^ -o $@ -Wl,--build-id=none
 
 $(OUTPUT)/encl.ss: $(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin
 	$^ $@
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index e2265f841fb0..d3e53c71306d 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 // Copyright(c) 2016-18 Intel Corporation.
 
+#define _GNU_SOURCE
 #include <elf.h>
 #include <fcntl.h>
 #include <stdbool.h>
@@ -9,16 +10,31 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <errno.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
-#include <sys/time.h>
+#include <sys/auxv.h>
+#include <signal.h>
+#include <sys/ucontext.h>
+
+#define UNW_LOCAL_ONLY
+#include <libunwind.h>
+
 #include "encl_piggy.h"
 #include "defines.h"
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
 
-static const uint64_t MAGIC = 0x1122334455667788ULL;
+#define _Q(x)	__Q(x)
+#define __Q(x)	#x
+#define ERRLN	"Line " _Q(__LINE__)
+
+#define X86_EFLAGS_TF	(1ul << 8)
+
+extern char __image_base[];
+size_t eenter;
+static size_t vdso_base;
 
 struct vdso_symtab {
 	Elf64_Sym *elf_symtab;
@@ -26,20 +42,11 @@ struct vdso_symtab {
 	Elf64_Word *elf_hashtab;
 };
 
-static void *vdso_get_base_addr(char *envp[])
+static void vdso_init(void)
 {
-	Elf64_auxv_t *auxv;
-	int i;
-
-	for (i = 0; envp[i]; i++);
-	auxv = (Elf64_auxv_t *)&envp[i + 1];
-
-	for (i = 0; auxv[i].a_type != AT_NULL; i++) {
-		if (auxv[i].a_type == AT_SYSINFO_EHDR)
-			return (void *)auxv[i].a_un.a_val;
-	}
-
-	return NULL;
+	vdso_base = getauxval(AT_SYSINFO_EHDR);
+	if (!vdso_base)
+		exit(1);
 }
 
 static Elf64_Dyn *vdso_get_dyntab(void *addr)
@@ -66,8 +73,9 @@ static void *vdso_get_dyn(void *addr, Elf64_Dyn *dyntab, Elf64_Sxword tag)
 	return NULL;
 }
 
-static bool vdso_get_symtab(void *addr, struct vdso_symtab *symtab)
+static bool vdso_get_symtab(struct vdso_symtab *symtab)
 {
+	void *addr = (void *)vdso_base;
 	Elf64_Dyn *dyntab = vdso_get_dyntab(addr);
 
 	symtab->elf_symtab = vdso_get_dyn(addr, dyntab, DT_SYMTAB);
@@ -138,7 +146,7 @@ static bool encl_create(int dev_fd, unsigned long bin_size,
 	base = mmap(NULL, secs->size, PROT_READ | PROT_WRITE | PROT_EXEC,
 		    MAP_SHARED, dev_fd, 0);
 	if (base == MAP_FAILED) {
-		perror("mmap");
+		perror(ERRLN);
 		return false;
 	}
 
@@ -224,35 +232,271 @@ static bool encl_load(struct sgx_secs *secs, unsigned long bin_size)
 	return false;
 }
 
-void sgx_call(void *rdi, void *rsi, void *tcs,
-	      struct sgx_enclave_exception *exception,
-	      void *eenter);
+int sgx_call(void *rdi, void *rsi, long rdx, void *rcx, void *r8, void *r9,
+	     void *tcs, struct sgx_enclave_exinfo *ei, void *cb);
+
+static void show_enclave_exinfo(const struct sgx_enclave_exinfo *exinfop,
+				const char *header)
+{
+	static const char * const enclu_leaves[] = {
+		"EREPORT",
+		"EGETKEY",
+		"EENTER",
+		"ERESUME",
+		"EEXIT"
+	};
+	static const char * const exception_names[] = {
+		"#DE",
+		"#DB",
+		"NMI",
+		"#BP",
+		"#OF",
+		"#BR",
+		"#UD",
+		"#NM",
+		"#DF",
+		"CSO",
+		"#TS",
+		"#NP",
+		"#SS",
+		"#GP",
+		"#PF",
+		"Unknown",
+		"#MF",
+		"#AC",
+		"#MC",
+		"#XM",
+		"#VE",
+		"Unknown",
+		"Unknown",
+		"Unknown",
+		"Unknown",
+		"Unknown",
+		"Unknown",
+		"Unknown",
+		"Unknown",
+		"Unknown",
+		"Unknown",
+		"Unknown"
+	};
+
+	printf("%s: leaf:%s(%d)", header,
+		enclu_leaves[exinfop->leaf], exinfop->leaf);
+	if (exinfop->leaf != 4)
+		printf(" trap:%s(%d) ec:%d addr:0x%llx\n",
+			exception_names[exinfop->trapnr], exinfop->trapnr,
+			exinfop->error_code, exinfop->address);
+	else
+		printf("\n");
+}
+
+static const uint64_t MAGIC = 0x1122334455667788ULL;
 
-int main(int argc, char *argv[], char *envp[])
+static void test1(struct sgx_secs *secs)
+{
+	uint64_t result = 0;
+	struct sgx_enclave_exinfo exinfo;
+
+	printf("[1] Entering the enclave without callback.\n");
+
+	printf("Input: 0x%lx\n Expect: Same as input\n", MAGIC);
+	sgx_call((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+		 (void *)secs->base, &exinfo, NULL);
+	show_enclave_exinfo(&exinfo, " Exit");
+	if (result != MAGIC) {
+		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
+		exit(1);
+	}
+	printf(" Output: 0x%lx\n", result);
+
+	printf("Input: Null TCS\n Expect: #PF at EENTER\n");
+	sgx_call((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+		 NULL, &exinfo, NULL);
+	show_enclave_exinfo(&exinfo, " Exit");
+	if (exinfo.leaf != 2 /*EENTER*/ || exinfo.trapnr != 14 /*#PF*/)
+		exit(1);
+}
+
+static int test2_callback(long rdi, long rsi, long rdx,
+			  struct sgx_enclave_exinfo *ei, long r8, long r9,
+			  void *tcs, long ursp)
+{
+	show_enclave_exinfo(ei, "  callback");
+
+	switch (ei->leaf) {
+	case 4:
+		return 0;
+	case 3:
+	case 2:
+		switch (ei->trapnr) {
+		case 1:	/*#DB*/
+			break;
+		case 14:/*#PF*/
+			if ((ei->error_code & 1) == 0) {
+				fprintf(stderr, ERRLN
+					": Unexpected #PF error code\n");
+				exit(1);
+			}
+			if (mprotect((void *)(ei->address & -0x1000), 0x1000,
+				     ((ei->error_code & 2) ? PROT_WRITE : 0) |
+				     ((ei->error_code & 0x10) ? PROT_EXEC : 0) |
+				     PROT_READ)) {
+				perror(ERRLN);
+				exit(1);
+			}
+			break;
+		default:
+			fprintf(stderr, ERRLN ": Unexpected exception\n");
+			exit(1);
+		}
+		return ei->leaf == 2 ? -EAGAIN : ei->leaf;
+	}
+	return -EINVAL;
+}
+
+static void test2(struct sgx_secs *secs)
+{
+	uint64_t result = 0;
+	struct sgx_enclave_exinfo exinfo;
+
+	printf("[2] Entering the enclave with callback.\n");
+
+	printf("Input: 0x%lx\n Expect: Same as input\n", MAGIC);
+	sgx_call((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+		 (void *)secs->base, &exinfo, test2_callback);
+	if (result != MAGIC) {
+		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
+		exit(1);
+	}
+	printf(" Output: 0x%lx\n", result);
+
+	printf("Input: Read-only enclave (0x%lx-0x%lx)\n"
+	       " Expect: #PFs to be fixed by callback\n",
+	       secs->base, secs->base + (encl_bin_end - encl_bin) - 1);
+	if (mprotect((void *)secs->base, encl_bin_end - encl_bin, PROT_READ)) {
+		perror(ERRLN);
+		exit(1);
+	}
+	while (sgx_call((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+			(void *)secs->base, &exinfo, test2_callback) == -EAGAIN)
+		;
+	show_enclave_exinfo(&exinfo, " Exit");
+	if (exinfo.leaf != 4 /*EEXIT*/)
+		exit(1);
+}
+
+static struct test3_proc_context {
+	unw_word_t	ip, bx, sp, bp, r12, r13, r14, r15;
+} test3_ctx;
+
+static unw_word_t test3_getcontext(unw_cursor_t *cursor,
+				   struct test3_proc_context *ctxp)
+{
+	unw_get_reg(cursor, UNW_REG_IP, &ctxp->ip);
+	unw_get_reg(cursor, UNW_REG_SP, &ctxp->sp);
+	unw_get_reg(cursor, UNW_X86_64_RBX, &ctxp->bx);
+	unw_get_reg(cursor, UNW_X86_64_RBP, &ctxp->bp);
+	unw_get_reg(cursor, UNW_X86_64_R12, &ctxp->r12);
+	unw_get_reg(cursor, UNW_X86_64_R13, &ctxp->r13);
+	unw_get_reg(cursor, UNW_X86_64_R14, &ctxp->r14);
+	unw_get_reg(cursor, UNW_X86_64_R15, &ctxp->r15);
+	return ctxp->ip;
+}
+
+static void test3_sigtrap(int sig, siginfo_t *info, ucontext_t *ctxp)
+{
+	static int in_vdso_eenter;
+	static size_t caller;
+
+	unw_cursor_t cursor;
+	unw_context_t uc;
+	struct test3_proc_context pc;
+
+	if (ctxp->uc_mcontext.gregs[REG_RIP] == eenter) {
+		in_vdso_eenter = 1;
+		caller = *(size_t *)(ctxp->uc_mcontext.gregs[REG_RSP]);
+		printf("  trace started at ip:%llx (vdso:0x%llx)\n",
+			ctxp->uc_mcontext.gregs[REG_RIP],
+			ctxp->uc_mcontext.gregs[REG_RIP] - vdso_base);
+	}
+
+	if (!in_vdso_eenter)
+		return;
+
+	if (ctxp->uc_mcontext.gregs[REG_RIP] == caller) {
+		in_vdso_eenter = 0;
+		ctxp->uc_mcontext.gregs[REG_EFL] &= ~X86_EFLAGS_TF;
+		printf("  trace ended successfully at ip:%llx (executable:0x%llx)\n",
+			ctxp->uc_mcontext.gregs[REG_RIP],
+			ctxp->uc_mcontext.gregs[REG_RIP] -
+				(size_t)__image_base);
+		return;
+	}
+
+	unw_getcontext(&uc);
+	unw_init_local(&cursor, &uc);
+	while (unw_step(&cursor) > 0 &&
+	       test3_getcontext(&cursor, &pc) != test3_ctx.ip)
+		;
+
+	if (memcmp(&pc, &test3_ctx, sizeof(pc))) {
+		fprintf(stderr, ERRLN ": Error unwinding\n");
+		exit(1);
+	}
+}
+
+static void test3_set_tf(void)
+{
+	__asm__ ("pushfq; orl %0, (%%rsp); popfq" : : "i"(X86_EFLAGS_TF));
+}
+
+static void test3(struct sgx_secs *secs)
+{
+	unw_cursor_t cursor;
+	unw_context_t uc;
+	struct sigaction sa = {
+		.sa_sigaction = (void (*)(int, siginfo_t*, void*))test3_sigtrap,
+		.sa_flags = SA_SIGINFO,
+	};
+
+	unw_getcontext(&uc);
+	unw_init_local(&cursor, &uc);
+	if (unw_step(&cursor) > 0)
+		test3_getcontext(&cursor, &test3_ctx);
+	else {
+		fprintf(stderr, ERRLN ": error initializing unwind context\n");
+		exit(1);
+	}
+
+	if (sigaction(SIGTRAP, &sa, NULL) < 0) {
+		perror(ERRLN);
+		exit(1);
+	}
+
+	test3_set_tf();
+	test1(secs);
+
+	test3_set_tf();
+	test2(secs);
+}
+
+int main(void)
 {
 	unsigned long bin_size = encl_bin_end - encl_bin;
 	unsigned long ss_size = encl_ss_end - encl_ss;
-	struct sgx_enclave_exception exception;
 	Elf64_Sym *eenter_sym;
 	struct vdso_symtab symtab;
 	struct sgx_secs secs;
-	uint64_t result = 0;
-	void *eenter;
-	void *addr;
-
-	memset(&exception, 0, sizeof(exception));
 
-	addr = vdso_get_base_addr(envp);
-	if (!addr)
-		exit(1);
+	vdso_init();
 
-	if (!vdso_get_symtab(addr, &symtab))
+	if (!vdso_get_symtab(&symtab))
 		exit(1);
 
 	eenter_sym = vdso_symtab_get(&symtab, "__vdso_sgx_enter_enclave");
 	if (!eenter_sym)
 		exit(1);
-	eenter = addr + eenter_sym->st_value;
+	eenter = vdso_base + eenter_sym->st_value;
 
 	printf("Binary size %lu (0x%lx), SIGSTRUCT size %lu\n", bin_size,
 	       bin_size, ss_size);
@@ -266,14 +510,11 @@ int main(int argc, char *argv[], char *envp[])
 	if (!encl_load(&secs, bin_size))
 		exit(1);
 
-	printf("Input: 0x%lx\n", MAGIC);
-	sgx_call((void *)&MAGIC, &result, (void *)secs.base, &exception,
-		 eenter);
-	if (result != MAGIC) {
-		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
-		exit(1);
-	}
+	printf("--- Functional Tests ---\n");
+	test1(&secs);
+	test2(&secs);
 
-	printf("Output: 0x%lx\n", result);
-	exit(0);
+	printf("--- Unwind Tests ---\n");
+	test3(&secs);
+	return 0;
 }
diff --git a/tools/testing/selftests/x86/sgx/sgx_call.S b/tools/testing/selftests/x86/sgx/sgx_call.S
index 14bd0a044199..ca2c0c947758 100644
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
+	call	*eenter(%rip)
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

