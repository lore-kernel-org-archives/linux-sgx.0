Return-Path: <SRS0=00MA=DJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CB7C4363D
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Oct 2020 21:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D33A1206DD
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Oct 2020 21:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgJBVMT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJBVMT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Oct 2020 17:12:19 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11E71206DB;
        Fri,  2 Oct 2020 21:12:17 +0000 (UTC)
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
Subject: [PATCH v2] x86/vdso: Flatten and clean up struct sgx_enclave_run
Date:   Sat,  3 Oct 2020 00:12:12 +0300
Message-Id: <20201002211212.620059-1-jarkko.sakkinen@linux.intel.com>
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
structure. Use exception_vector, exception_error_code and exception_addr
as the variables that store vDSO exception fixup provided information.

The documentation, selftest and the kernel source code use the terms "user
handler" and "exit handler" in somewhat inconsistent manner. Use "user
handler" everywhere as the callback is a caller provided, and thus we
don't know what it is doing.

Remove 'exit_reason' as it is a redundant field. Instead, have just a
field called 'leaf' that tells the last seen ENCLU.

Validate the whole reserved (aka padding) area that it contains only
zero bytes. It is an unsafe practice to not validate the full data
structure. As a side-effect, 'flags' can be removed because it can
be added later as one can assume that the reserved area does not
contain random bytes, but instead is always filled with zeros.

Cc: Nathaniel McCallum <npmccallum@redhat.com>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
CC: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
* Rename aex_handler as user handler.
* Refine exception_* naming a just a bit more in struct sgx_enclave_run.
* Add zero validation for the reserved area, as it helps to protect among
  other things, from kernel bugs. This was already experienced with the
  self-test while developing this patch version. This fully removes the
  need to have the 'flags' field in the structure, as formally it had the
  same semantics as just checking the first 4 bytes.
* Fix memory offsets in vsgx.S. There were some mistakes in the previous
  version. This bug was catched by the aformentioned memory validation
  when running the self-test.
* Refine check_result() in the selftest to report all issues before
  returning. Rename it as report_results() and make it a boolean function,
  as the POSIX error code is not used for anything.
 arch/x86/entry/vdso/vsgx.S         | 67 ++++++++++++++++--------------
 arch/x86/include/asm/enclu.h       |  1 +
 arch/x86/include/uapi/asm/sgx.h    | 62 ++++++++++-----------------
 tools/testing/selftests/sgx/main.c | 49 +++++++++++++---------
 4 files changed, 87 insertions(+), 92 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vsgx.S
index 8f8190ab9ed5..23d110aac432 100644
--- a/arch/x86/entry/vdso/vsgx.S
+++ b/arch/x86/entry/vdso/vsgx.S
@@ -7,25 +7,19 @@
 
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
+/* Relative to %rbp. */
+#define SGX_ENCLAVE_OFFSET_OF_RUN		16
+
+/* The offsets relative to struct sgx_enclave_run. */
+#define SGX_ENCLAVE_RUN_TCS			0
+#define SGX_ENCLAVE_RUN_USER_HANDLER		8
+#define SGX_ENCLAVE_RUN_USER_DATA		16 /* unused */
+#define SGX_ENCLAVE_RUN_LEAF			24
+#define SGX_ENCLAVE_RUN_EXCEPTION_VECTOR	28
+#define SGX_ENCLAVE_RUN_EXCEPTION_ERROR_CODE	30
+#define SGX_ENCLAVE_RUN_EXCEPTION_ADDR		32
+#define SGX_ENCLAVE_RUN_RESERVED_START		40
+#define SGX_ENCLAVE_RUN_RESERVED_END		64
 
 .code64
 .section .text, "ax"
@@ -49,12 +43,23 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	cmp	$ERESUME, %eax
 	ja	.Linvalid_input
 
-	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rcx
+	mov	SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rcx
 
-	/* No flags are currently defined/supported. */
-	cmpl	$0, SGX_ENCLAVE_RUN_FLAGS(%rcx)
+	/* Validate that the reserved area contains only zeros. */
+	push	%rax
+	push	%rbx
+	mov	$SGX_ENCLAVE_RUN_RESERVED_START, %rbx
+1:
+	mov	(%rcx, %rbx), %rax
+	cmpq	$0, %rax
 	jne	.Linvalid_input
 
+	add	$8, %rbx
+	cmpq	$SGX_ENCLAVE_RUN_RESERVED_END, %rbx
+	jne	1b
+	pop	%rbx
+	pop	%rax
+
 	/* Load TCS and AEP */
 	mov	SGX_ENCLAVE_RUN_TCS(%rcx), %rbx
 	lea	.Lasync_exit_pointer(%rip), %rcx
@@ -65,10 +70,10 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	enclu
 
 	/* EEXIT jumps here unless the enclave is doing something fancy. */
-	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
+	mov	SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rbx
 
 	/* Set exit_reason. */
-	movl	$SGX_SYNCHRONOUS_EXIT, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
+	movl	$EEXIT, SGX_ENCLAVE_RUN_LEAF(%rbx)
 
 	/* Invoke userspace's exit handler if one was provided. */
 .Lhandle_exit:
@@ -92,15 +97,13 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	jmp	.Lout
 
 .Lhandle_exception:
-	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
-
-	/* Set the exit_reason and exception info. */
-	movl	$SGX_EXCEPTION_EXIT, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
+	mov	SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rbx
 
-	mov	%eax, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_LEAF)(%rbx)
-	mov	%di,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_TRAPNR)(%rbx)
-	mov	%si,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ERROR_CODE)(%rbx)
-	mov	%rdx, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ADDRESS)(%rbx)
+	/* Set the exception info. */
+	mov	%eax, (SGX_ENCLAVE_RUN_LEAF)(%rbx)
+	mov	%di,  (SGX_ENCLAVE_RUN_EXCEPTION_VECTOR)(%rbx)
+	mov	%si,  (SGX_ENCLAVE_RUN_EXCEPTION_ERROR_CODE)(%rbx)
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
index 236dd7190431..3dd2df44d569 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -74,13 +74,10 @@ struct sgx_enclave_provision {
 	__u64 attribute_fd;
 };
 
-#define SGX_SYNCHRONOUS_EXIT	0
-#define SGX_EXCEPTION_EXIT	1
-
 struct sgx_enclave_run;
 
 /**
- * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
+ * typedef sgx_enclave_user_handler_t - Exit handler function accepted by
  *					__vdso_sgx_enter_enclave()
  * @run:	Pointer to the caller provided struct sgx_enclave_run
  *
@@ -91,47 +88,30 @@ struct sgx_enclave_run;
  *  0 or negative to exit vDSO
  *  positive to re-enter enclave (must be EENTER or ERESUME leaf)
  */
-typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
+typedef int (*sgx_enclave_user_handler_t)(long rdi, long rsi, long rdx,
 					  long rsp, long r8, long r9,
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
+ * @user_handler:		User provided callback run on exception
+ * @user_data:			Data passed to the user handler
+ * @leaf:			The ENCLU leaf we were at (EENTER/ERESUME/EEXIT)
+ * @exception_vector:		The interrupt vector of the exception
+ * @exception_error_code:	The exception error code pulled out of the stack
+ * @exception_addr:		The address that triggered the exception
+ * @reserved			Reserved for possible future use
  */
 struct sgx_enclave_run {
 	__u64 tcs;
-	__u32 flags;
-	__u32 exit_reason;
 	__u64 user_handler;
 	__u64 user_data;
-
-	union {
-		struct sgx_enclave_exception exception;
-
-		/* Pad the entire struct to 256 bytes. */
-		__u8 pad[256 - 32];
-	};
+	__u32 leaf;
+	__u16 exception_vector;
+	__u16 exception_error_code;
+	__u64 exception_addr;
+	__u8  reserved[24];
 };
 
 /**
@@ -160,7 +140,7 @@ struct sgx_enclave_run {
  * pre-enclave state, e.g. to retrieve @run.exception and @run.user_handler
  * after an enclave exit.  All other registers are available for use by the
  * enclave and its runtime, e.g. an enclave can push additional data onto the
- * stack (and modify RSP) to pass information to the optional exit handler (see
+ * stack (and modify RSP) to pass information to the optional user handler (see
  * below).
  *
  * Most exceptions reported on ENCLU, including those that occur within the
@@ -170,22 +150,22 @@ struct sgx_enclave_run {
  * reported exceptions, -EFAULT is returned and details about the exception are
  * recorded in @run.exception, the optional sgx_enclave_exception struct.
  *
- * If an exit handler is provided, the handler will be invoked on synchronous
+ * If a user handler is provided, the handler will be invoked on synchronous
  * exits from the enclave and for all synchronously reported exceptions. In
  * latter case, @run.exception is filled prior to invoking the handler.
  *
- * The exit handler's return value is interpreted as follows:
+ * The user handler's return value is interpreted as follows:
  *  >0:		continue, restart __vdso_sgx_enter_enclave() with @ret as @leaf
  *   0:		success, return @ret to the caller
  *  <0:		error, return @ret to the caller
  *
- * The exit handler may transfer control, e.g. via longjmp() or C++ exception,
+ * The user handler may transfer control, e.g. via longjmp() or C++ exception,
  * without returning to __vdso_sgx_enter_enclave().
  *
  * Return:
  *  0 on success (ENCLU reached),
  *  -EINVAL if ENCLU leaf is not allowed,
- *  -errno for all other negative values returned by the userspace exit handler
+ *  -errno for all other negative values returned by the userspace user handler
  */
 typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
 					unsigned long rdx, unsigned int leaf,
diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 0316701d6bbd..26e00f176535 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -123,29 +123,38 @@ static Elf64_Sym *vdso_symtab_get(struct vdso_symtab *symtab, const char *name)
 	return NULL;
 }
 
-int check_result(struct sgx_enclave_run *run, int ret, uint64_t result,
-		 const char *test)
+bool report_results(struct sgx_enclave_run *run, int ret, uint64_t result,
+		  const char *test)
 {
+	bool valid = true;
+
 	if (ret) {
 		printf("FAIL: %s() returned: %d\n", test, ret);
-		return ret;
-	} else if (run->exit_reason != SGX_SYNCHRONOUS_EXIT) {
-		printf("FAIL: %s() exit reason, expected: %u, got: %u\n",
-		       test, SGX_SYNCHRONOUS_EXIT, run->exit_reason);
-		return -EIO;
-	} else if (result != MAGIC) {
-		printf("FAIL: %s(), expected: 0x%lx, got: 0x%lx\n",
-		       test, MAGIC, result);
-		return -EIO;
-	} else if (run->user_data) {
+		valid = false;
+	}
+
+	if (run->leaf != EEXIT) {
+		printf("FAIL: %s() leaf, expected: %u, got: %u\n", test, EEXIT,
+		       run->leaf);
+		valid = false;
+	}
+
+	if (result != MAGIC) {
+		printf("FAIL: %s(), expected: 0x%lx, got: 0x%lx\n", test, MAGIC,
+		       result);
+		valid = false;
+	}
+
+	if (run->user_data) {
 		printf("FAIL: %s() user data, expected: 0x0, got: 0x%llx\n",
 		       test, run->user_data);
-		return -EIO;
+		valid = false;
 	}
-	return 0;
+
+	return valid;
 }
 
-static int exit_handler(long rdi, long rsi, long rdx, long ursp, long r8, long r9,
+static int user_handler(long rdi, long rsi, long rdx, long ursp, long r8, long r9,
 			struct sgx_enclave_run *run)
 {
 	run->user_data = 0;
@@ -163,6 +172,8 @@ int main(int argc, char *argv[], char *envp[])
 	void *addr;
 	int ret;
 
+	memset(&run, 0, sizeof(run));
+
 	if (!encl_load("test_encl.elf", &encl))
 		goto err;
 
@@ -203,7 +214,7 @@ int main(int argc, char *argv[], char *envp[])
 	eenter = addr + eenter_sym->st_value;
 
 	ret = sgx_call_vdso((void *)&MAGIC, &result, 0, EENTER, NULL, NULL, &run);
-	if (check_result(&run, ret, result, "sgx_call_vdso"))
+	if (!report_results(&run, ret, result, "sgx_call_vdso"))
 		goto err;
 
 
@@ -211,15 +222,15 @@ int main(int argc, char *argv[], char *envp[])
 	result = 0;
 	ret = eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, EENTER,
 		     0, 0, &run);
-	if (check_result(&run, ret, result, "eenter"))
+	if (!report_results(&run, ret, result, "eenter"))
 		goto err;
 
 	/* And with an exit handler. */
-	run.user_handler = (__u64)exit_handler;
+	run.user_handler = (__u64)user_handler;
 	run.user_data = 0xdeadbeef;
 	ret = eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, EENTER,
 		     0, 0, &run);
-	if (check_result(&run, ret, result, "exit_handler"))
+	if (!report_results(&run, ret, result, "user_handler"))
 		goto err;
 
 	printf("SUCCESS\n");
-- 
2.25.1

