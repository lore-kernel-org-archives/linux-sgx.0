Return-Path: <SRS0=F+z5=DI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3003C4727E
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 16:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D4CA20B1F
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 16:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbgJAQQu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Oct 2020 12:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732026AbgJAQQu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Oct 2020 12:16:50 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B83A220759;
        Thu,  1 Oct 2020 16:16:48 +0000 (UTC)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: [PATCH] x86/vdso: Flatten and clean up struct sgx_enclave_run
Date:   Thu,  1 Oct 2020 19:16:42 +0300
Message-Id: <20201001161642.10500-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Reduce the struct size to 64 bytes. It makes sense to have a naturally
aligning struct size and it leaves 24 bytes of spare space for possible
future expansion. Having 256 bytes is over the top without any reasonable
explanation, which does not exist in the commit for the SGX vDSO.

Drop struct sgx_exception. It does not serve any semantic purpose in the
context of this vDSO. Doing this is also consistent with user_handler and
user_data fields, as neither are they encapsulated in an embedded data
structure.

Drop 'flags' from sgx_enclave_run as it is an unused value.'vsgx.S'
literally states this in an inline comment.

Pick more reasonable names for the four fields of the exception. For
example, 'trapnr' should rather be just 'number' because in practice we
deliver only trap and the rest are faults. Also 'vector' would be an
adequate name for this field. Document the fields properly in order to
better explain the values that they have inherited.

Remove 'exit_reason' as it is really a redundant field to save some space.
Instead, have just a field called 'leaf' that tells the last seen ENCLU.

The documentation, selftest and the kernel source code use the terms "user
handler" and "exit handler" in somewhat inconsistent manner. Start using
"AEX handler" consistently as this is the term that Intel SDM volume D uses
for these events.

Cc: Nathaniel McCallum <npmccallum@redhat.com>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
CC: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/entry/vdso/vsgx.S         | 54 ++++++++++----------------
 arch/x86/include/asm/enclu.h       |  1 +
 arch/x86/include/uapi/asm/sgx.h    | 61 +++++++++++-------------------
 tools/testing/selftests/sgx/main.c | 24 ++++++------
 4 files changed, 55 insertions(+), 85 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vsgx.S
index 8f8190ab9ed5..4bbb71253e17 100644
--- a/arch/x86/entry/vdso/vsgx.S
+++ b/arch/x86/entry/vdso/vsgx.S
@@ -7,25 +7,17 @@
 
 #include "extable.h"
 
-/* Offset of 'struct sgx_enclave_run' relative to %rbp. */
-#define SGX_ENCLAVE_RUN_PTR	2*8
-
-/* Offsets into 'struct sgx_enclave_run'. */
-#define SGX_ENCLAVE_RUN_TCS		0*8
-#define SGX_ENCLAVE_RUN_FLAGS		1*8
-#define SGX_ENCLAVE_RUN_EXIT_REASON	1*8 + 4
-#define SGX_ENCLAVE_RUN_USER_HANDLER	2*8
-/* #define SGX_ENCLAVE_RUN_USER_DATA	3*8 */
-#define SGX_ENCLAVE_RUN_EXCEPTION	4*8
-
-#define SGX_SYNCHRONOUS_EXIT		0
-#define SGX_EXCEPTION_EXIT		1
-
-/* Offsets into sgx_enter_enclave.exception. */
-#define SGX_EX_LEAF			0*8
-#define SGX_EX_TRAPNR			0*8+4
-#define SGX_EX_ERROR_CODE		0*8+6
-#define SGX_EX_ADDRESS			1*8
+/* The offset relative to %rbp. */
+#define SGX_ENCLAVE_RUN_OFFSET	2*8
+
+/* The offsets relative to struct sgx_enclave_run. */
+#define SGX_ENCLAVE_RUN_TCS			0*8
+#define SGX_ENCLAVE_RUN_USER_HANDLER		1*8
+
+#define SGX_ENCLAVE_RUN_LEAF			3*8
+#define SGX_ENCLAVE_RUN_EXCEPTION_NUMBER	4*8
+#define SGX_ENCLAVE_RUN_EXCEPTION_INFO		5*8
+#define SGX_ENCLAVE_RUN_EXCEPTION_ADDR		6*8
 
 .code64
 .section .text, "ax"
@@ -49,11 +41,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	cmp	$ERESUME, %eax
 	ja	.Linvalid_input
 
-	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rcx
-
-	/* No flags are currently defined/supported. */
-	cmpl	$0, SGX_ENCLAVE_RUN_FLAGS(%rcx)
-	jne	.Linvalid_input
+	mov	SGX_ENCLAVE_RUN_OFFSET(%rbp), %rcx
 
 	/* Load TCS and AEP */
 	mov	SGX_ENCLAVE_RUN_TCS(%rcx), %rbx
@@ -65,10 +53,10 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	enclu
 
 	/* EEXIT jumps here unless the enclave is doing something fancy. */
-	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
+	mov	SGX_ENCLAVE_RUN_OFFSET(%rbp), %rbx
 
 	/* Set exit_reason. */
-	movl	$SGX_SYNCHRONOUS_EXIT, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
+	movl	$EEXIT, SGX_ENCLAVE_RUN_LEAF(%rbx)
 
 	/* Invoke userspace's exit handler if one was provided. */
 .Lhandle_exit:
@@ -92,15 +80,13 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	jmp	.Lout
 
 .Lhandle_exception:
-	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
-
-	/* Set the exit_reason and exception info. */
-	movl	$SGX_EXCEPTION_EXIT, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
+	mov	SGX_ENCLAVE_RUN_OFFSET(%rbp), %rbx
 
-	mov	%eax, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_LEAF)(%rbx)
-	mov	%di,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_TRAPNR)(%rbx)
-	mov	%si,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ERROR_CODE)(%rbx)
-	mov	%rdx, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ADDRESS)(%rbx)
+	/* Set the exception info. */
+	mov	%eax, (SGX_ENCLAVE_RUN_LEAF)(%rbx)
+	mov	%di,  (SGX_ENCLAVE_RUN_EXCEPTION_NUMBER)(%rbx)
+	mov	%si,  (SGX_ENCLAVE_RUN_EXCEPTION_INFO)(%rbx)
+	mov	%rdx, (SGX_ENCLAVE_RUN_EXCEPTION_ADDR)(%rbx)
 	jmp	.Lhandle_exit
 
 .Linvoke_userspace_handler:
diff --git a/arch/x86/include/asm/enclu.h b/arch/x86/include/asm/enclu.h
index 06157b3e9ede..b1314e41a744 100644
--- a/arch/x86/include/asm/enclu.h
+++ b/arch/x86/include/asm/enclu.h
@@ -4,5 +4,6 @@
 
 #define EENTER	0x02
 #define ERESUME	0x03
+#define EEXIT	0x04
 
 #endif /* _ASM_X86_ENCLU_H */
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 236dd7190431..71e44406da13 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -96,42 +96,25 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
 					  struct sgx_enclave_run *run);
 
 /**
- * struct sgx_enclave_exception - structure to report exceptions encountered in
- *				  __vdso_sgx_enter_enclave()
- * @leaf:	ENCLU leaf from \%eax at time of exception
- * @trapnr:	exception trap number, a.k.a. fault vector
- * @error_code:	exception error code
- * @address:	exception address, e.g. CR2 on a #PF
- */
-struct sgx_enclave_exception {
-	__u32 leaf;
-	__u16 trapnr;
-	__u16 error_code;
-	__u64 address;
-};
-
-/**
- * struct sgx_enclave_run - Control structure for __vdso_sgx_enter_enclave()
- * @tcs:		Thread Control Structure used to enter enclave
- * @flags:		Control flags
- * @exit_reason:	Cause of exit from enclave, e.g. EEXIT vs. exception
- * @user_handler:	User provided exit handler (optional)
- * @user_data:		User provided opaque value (optional)
- * @exception:		Valid on exit due to exception
+ * struct sgx_enclave_run - the execution context of __vdso_sgx_enter_enclave()
+ * @tcs:			TCS used to enter the enclave
+ * @aex_handler:		Handler for asynchronous exit (AEX)
+ * @aex_data:			Data passed to the AEX handler
+ * @leaf:			The ENCLU leaf we were at (EENTER/ERESUME/EEXIT)
+ * @exception_number:		The exception number that triggered AEX
+ * @exception_info:		The associated info pulled out from the stack
+ * @exception_addr:		The address that triggered the exception
+ * @reserved			Reserved for possible future use
  */
 struct sgx_enclave_run {
 	__u64 tcs;
-	__u32 flags;
-	__u32 exit_reason;
-	__u64 user_handler;
-	__u64 user_data;
-
-	union {
-		struct sgx_enclave_exception exception;
-
-		/* Pad the entire struct to 256 bytes. */
-		__u8 pad[256 - 32];
-	};
+	__u64 aex_handler;
+	__u64 aex_data;
+	__u32 leaf;
+	__u16 exception_number;
+	__u16 exception_info;
+	__u64 exception_addr;
+	__u64 reserved[3];
 };
 
 /**
@@ -157,10 +140,10 @@ struct sgx_enclave_run {
  * loaded with @leaf, asynchronous exit pointer, and @run.tcs respectively.
  *
  * RBP and the stack are used to anchor __vdso_sgx_enter_enclave() to the
- * pre-enclave state, e.g. to retrieve @run.exception and @run.user_handler
+ * pre-enclave state, e.g. to retrieve @run.exception and @run.aex_handler
  * after an enclave exit.  All other registers are available for use by the
  * enclave and its runtime, e.g. an enclave can push additional data onto the
- * stack (and modify RSP) to pass information to the optional exit handler (see
+ * stack (and modify RSP) to pass information to the optional AEX handler (see
  * below).
  *
  * Most exceptions reported on ENCLU, including those that occur within the
@@ -170,22 +153,22 @@ struct sgx_enclave_run {
  * reported exceptions, -EFAULT is returned and details about the exception are
  * recorded in @run.exception, the optional sgx_enclave_exception struct.
  *
- * If an exit handler is provided, the handler will be invoked on synchronous
+ * If an AEX handler is provided, the handler will be invoked on synchronous
  * exits from the enclave and for all synchronously reported exceptions. In
  * latter case, @run.exception is filled prior to invoking the handler.
  *
- * The exit handler's return value is interpreted as follows:
+ * The AEX handler's return value is interpreted as follows:
  *  >0:		continue, restart __vdso_sgx_enter_enclave() with @ret as @leaf
  *   0:		success, return @ret to the caller
  *  <0:		error, return @ret to the caller
  *
- * The exit handler may transfer control, e.g. via longjmp() or C++ exception,
+ * The AEX handler may transfer control, e.g. via longjmp() or C++ exception,
  * without returning to __vdso_sgx_enter_enclave().
  *
  * Return:
  *  0 on success (ENCLU reached),
  *  -EINVAL if ENCLU leaf is not allowed,
- *  -errno for all other negative values returned by the userspace exit handler
+ *  -errno for all other negative values returned by the userspace AEX handler
  */
 typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
 					unsigned long rdx, unsigned int leaf,
diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 0316701d6bbd..cc9e71b29861 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -129,26 +129,26 @@ int check_result(struct sgx_enclave_run *run, int ret, uint64_t result,
 	if (ret) {
 		printf("FAIL: %s() returned: %d\n", test, ret);
 		return ret;
-	} else if (run->exit_reason != SGX_SYNCHRONOUS_EXIT) {
-		printf("FAIL: %s() exit reason, expected: %u, got: %u\n",
-		       test, SGX_SYNCHRONOUS_EXIT, run->exit_reason);
+	} else if (run->leaf != EEXIT) {
+		printf("FAIL: %s() leaf, expected: %u, got: %u\n", test, EEXIT,
+		       run->leaf);
 		return -EIO;
 	} else if (result != MAGIC) {
-		printf("FAIL: %s(), expected: 0x%lx, got: 0x%lx\n",
-		       test, MAGIC, result);
+		printf("FAIL: %s(), expected: 0x%lx, got: 0x%lx\n", test, MAGIC,
+		       result);
 		return -EIO;
-	} else if (run->user_data) {
+	} else if (run->aex_data) {
 		printf("FAIL: %s() user data, expected: 0x0, got: 0x%llx\n",
-		       test, run->user_data);
+		       test, run->aex_data);
 		return -EIO;
 	}
 	return 0;
 }
 
-static int exit_handler(long rdi, long rsi, long rdx, long ursp, long r8, long r9,
+static int aex_handler(long rdi, long rsi, long rdx, long ursp, long r8, long r9,
 			struct sgx_enclave_run *run)
 {
-	run->user_data = 0;
+	run->aex_data = 0;
 	return 0;
 }
 
@@ -215,11 +215,11 @@ int main(int argc, char *argv[], char *envp[])
 		goto err;
 
 	/* And with an exit handler. */
-	run.user_handler = (__u64)exit_handler;
-	run.user_data = 0xdeadbeef;
+	run.aex_handler = (__u64)aex_handler;
+	run.aex_data = 0xdeadbeef;
 	ret = eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, EENTER,
 		     0, 0, &run);
-	if (check_result(&run, ret, result, "exit_handler"))
+	if (check_result(&run, ret, result, "aex_handler"))
 		goto err;
 
 	printf("SUCCESS\n");
-- 
2.25.1

