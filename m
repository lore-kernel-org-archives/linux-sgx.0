Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792ACC433E2
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5307C20770
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgIDKpa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 06:45:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:43123 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729872AbgIDKpU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 06:45:20 -0400
IronPort-SDR: TXS6TEAHUWYjp/mF6VfjzI/8DeiZtyGr3KNxo2vwqVsQAU/lNawUM6kSHrNV6hTbVjhqTWSyZF
 WbUHZFHTZOKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="145455662"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="145455662"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 03:44:47 -0700
IronPort-SDR: ZqVdeUvLWrUu5+R5hPeAu0b05UJQ8zAZC3PDe4g3hHhBn75Wvz1GEDRROlQOq7cckpLgnAah/G
 tH3ifIpOsvcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="283026280"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga007.fm.intel.com with ESMTP; 04 Sep 2020 03:44:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v37 2/6] x86/vdso: x86/sgx: Rework __vdso_sgx_enter_enclave() API
Date:   Fri,  4 Sep 2020 03:44:33 -0700
Message-Id: <20200904104437.29555-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904104437.29555-1-sean.j.christopherson@intel.com>
References: <20200904104437.29555-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Rework __vdso_sgx_enter_enclave() to use a struct to hold the input and
output params.  In the new struct, add an opaque "user_data" that can be
used to pass context across the vDSO, an explicit "exit_reason" to avoid
overloading the return value, and a "flags" field to provide a path for
future extensions.

Moving the params into a struct will also make it less painful to use
dedicated exit reasons values in a future patch.

Cc: Nathaniel McCallum <npmccallum@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 73 +++++++++++++-------
 arch/x86/include/uapi/asm/sgx.h          | 85 +++++++++++++++---------
 2 files changed, 103 insertions(+), 55 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 2d88acd408d4e..4fe3d06dd7878 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -7,10 +7,22 @@
 
 #include "extable.h"
 
-#define EX_LEAF		0*8
-#define EX_TRAPNR	0*8+4
-#define EX_ERROR_CODE	0*8+6
-#define EX_ADDRESS	1*8
+/* Offset of 'struct sgx_enclave_run' relative to %rbp. */
+#define SGX_ENCLAVE_RUN_PTR	2*8
+
+/* Offsets into 'struct sgx_enclave_run'. */
+#define SGX_ENCLAVE_RUN_TSC		0*8
+#define SGX_ENCLAVE_RUN_FLAGS		1*8
+#define SGX_ENCLAVE_RUN_EXIT_REASON	1*8 + 4
+#define SGX_ENCLAVE_RUN_USER_HANDLER	2*8
+/* #define SGX_ENCLAVE_RUN_USER_DATA	3*8 */
+#define SGX_ENCLAVE_RUN_EXCEPTION	4*8
+
+/* Offsets into sgx_enter_enclave.exception. */
+#define SGX_EX_LEAF			0*8
+#define SGX_EX_TRAPNR			0*8+4
+#define SGX_EX_ERROR_CODE		0*8+6
+#define SGX_EX_ADDRESS			1*8
 
 .code64
 .section .text, "ax"
@@ -30,12 +42,18 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 .Lenter_enclave:
 	/* EENTER <= leaf <= ERESUME */
 	cmp	$EENTER, %eax
-	jb	.Linvalid_leaf
+	jb	.Linvalid_input
 	cmp	$ERESUME, %eax
-	ja	.Linvalid_leaf
+	ja	.Linvalid_input
+
+	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rcx
+
+	/* No flags are currently defined/supported. */
+	cmpl	$0, SGX_ENCLAVE_RUN_FLAGS(%rcx)
+	jne	.Linvalid_input
 
 	/* Load TCS and AEP */
-	mov	0x10(%rbp), %rbx
+	mov	SGX_ENCLAVE_RUN_TSC(%rcx), %rbx
 	lea	.Lasync_exit_pointer(%rip), %rcx
 
 	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
@@ -44,13 +62,19 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	enclu
 
 	/* EEXIT jumps here unless the enclave is doing something fancy. */
-	xor	%eax, %eax
+	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
+
+	/* Set exit_reason. */
+	movl	$0, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
 
 	/* Invoke userspace's exit handler if one was provided. */
 .Lhandle_exit:
-	cmpq	$0, 0x20(%rbp)
+	cmpq	$0, SGX_ENCLAVE_RUN_USER_HANDLER(%rbx)
 	jne	.Linvoke_userspace_handler
 
+	/* Success, in the sense that ENCLU was attempted. */
+	xor	%eax, %eax
+
 .Lout:
 	pop	%rbx
 	leave
@@ -60,28 +84,29 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	/* The out-of-line code runs with the pre-leave stack frame. */
 	.cfi_def_cfa		%rbp, 16
 
-.Linvalid_leaf:
+.Linvalid_input:
 	mov	$(-EINVAL), %eax
 	jmp	.Lout
 
 .Lhandle_exception:
-	mov	0x18(%rbp), %rcx
-	test    %rcx, %rcx
-	je	.Lskip_exception_info
+	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
 
-	/* Fill optional exception info. */
-	mov	%eax, EX_LEAF(%rcx)
-	mov	%di,  EX_TRAPNR(%rcx)
-	mov	%si,  EX_ERROR_CODE(%rcx)
-	mov	%rdx, EX_ADDRESS(%rcx)
-.Lskip_exception_info:
-	mov	$(-EFAULT), %eax
+	/* Set the exit_reason and exception info. */
+	movl	$(-EFAULT), SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
+
+	mov	%eax, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_LEAF)(%rbx)
+	mov	%di,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_TRAPNR)(%rbx)
+	mov	%si,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ERROR_CODE)(%rbx)
+	mov	%rdx, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ADDRESS)(%rbx)
 	jmp	.Lhandle_exit
 
 .Linvoke_userspace_handler:
 	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
 	mov	%rsp, %rcx
 
+	/* Save @e, %rbx is about to be clobbered. */
+	mov	%rbx, %rax
+
 	/* Save the untrusted RSP offset in %rbx (non-volatile register). */
 	mov	%rsp, %rbx
 	and	$0xf, %rbx
@@ -93,20 +118,18 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	and	$-0x10, %rsp
 	push	%rax
 
-	/* Push @e, the "return" value and @tcs as params to the callback. */
-	push	0x18(%rbp)
+	/* Push @e as a param to the callback. */
 	push	%rax
-	push	0x10(%rbp)
 
 	/* Clear RFLAGS.DF per x86_64 ABI */
 	cld
 
 	/* Load the callback pointer to %rax and invoke it via retpoline. */
-	mov	0x20(%rbp), %rax
+	mov	SGX_ENCLAVE_RUN_USER_HANDLER(%rax), %rax
 	call	.Lretpoline
 
 	/* Undo the post-exit %rsp adjustment. */
-	lea	0x20(%rsp, %rbx), %rsp
+	lea	0x10(%rsp, %rbx), %rsp
 
 	/*
 	 * If the return from callback is zero or negative, return immediately,
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 934de08bc2f4a..608daccc46553 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -74,6 +74,28 @@ struct sgx_enclave_provision {
 	__u64 attribute_fd;
 };
 
+struct sgx_enclave_run;
+
+/**
+ * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
+ *					__vdso_sgx_enter_enclave()
+ *
+ * @rdi:	RDI at the time of enclave exit
+ * @rsi:	RSI at the time of enclave exit
+ * @rdx:	RDX at the time of enclave exit
+ * @ursp:	RSP at the time of enclave exit (untrusted stack)
+ * @r8:		R8 at the time of enclave exit
+ * @r9:		R9 at the time of enclave exit
+ * @r:		Pointer to struct sgx_enclave_run (as provided by caller)
+ *
+ * Return:
+ *  0 or negative to exit vDSO
+ *  positive to re-enter enclave (must be EENTER or ERESUME leaf)
+ */
+typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
+					  long ursp, long r8, long r9,
+					  struct sgx_enclave_run *r);
+
 /**
  * struct sgx_enclave_exception - structure to report exceptions encountered in
  *				  __vdso_sgx_enter_enclave()
@@ -82,34 +104,42 @@ struct sgx_enclave_provision {
  * @trapnr:	exception trap number, a.k.a. fault vector
  * @error_code:	exception error code
  * @address:	exception address, e.g. CR2 on a #PF
- * @reserved:	reserved for future use
  */
 struct sgx_enclave_exception {
 	__u32 leaf;
 	__u16 trapnr;
 	__u16 error_code;
 	__u64 address;
-	__u64 reserved[2];
 };
 
 /**
- * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
- *					__vdso_sgx_enter_enclave()
+ * struct sgx_enclave_run - Control structure for __vdso_sgx_enter_enclave()
  *
- * @rdi:	RDI at the time of enclave exit
- * @rsi:	RSI at the time of enclave exit
- * @rdx:	RDX at the time of enclave exit
- * @ursp:	RSP at the time of enclave exit (untrusted stack)
- * @r8:		R8 at the time of enclave exit
- * @r9:		R9 at the time of enclave exit
- * @tcs:	Thread Control Structure used to enter enclave
- * @ret:	0 on success (EEXIT), -EFAULT on an exception
- * @e:		Pointer to struct sgx_enclave_exception (as provided by caller)
+ * @tcs:		Thread Control Structure used to enter enclave
+ * @flags:		Control flags
+ * @exit_reason:	Cause of exit from enclave, e.g. EEXIT vs. exception
+ * @user_handler:	User provided exit handler (optional)
+ * @user_data:		User provided opaque value (optional)
+ * @exception:		Valid on exit due to exception
  */
-typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
-					  long ursp, long r8, long r9,
-					  void *tcs, int ret,
-					  struct sgx_enclave_exception *e);
+struct sgx_enclave_run {
+	__u64 tcs;
+	__u32 flags;
+	__u32 exit_reason;
+
+	union {
+		sgx_enclave_exit_handler_t user_handler;
+		__u64 __user_handler;
+	};
+	__u64 user_data;
+
+	union {
+		struct sgx_enclave_exception exception;
+
+		/* Pad the entire struct to 256 bytes. */
+		__u8 pad[256 - 32];
+	};
+};
 
 /**
  * __vdso_sgx_enter_enclave() - Enter an SGX enclave
@@ -119,16 +149,14 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
  * @leaf:	ENCLU leaf, must be EENTER or ERESUME
  * @r8:		Pass-through value for R8
  * @r9:		Pass-through value for R9
- * @tcs:	TCS, must be non-NULL
- * @e:		Optional struct sgx_enclave_exception instance
- * @handler:	Optional enclave exit handler
+ * @r:		struct sgx_enclave_run, must be non-NULL
  *
  * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance with the
- * x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.  Except for
- * non-volatile general purpose registers, preserving/setting state in
- * accordance with the x86-64 ABI is the responsibility of the enclave and its
- * runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
- * without careful consideration by both the enclave and its runtime.
+ * x86-64 ABI, e.g. doesn't handle XSAVE state.  Except for non-volatile
+ * general purpose registers, EFLAGS.DF, and RSP alignment, preserving/setting
+ * state in accordance with the x86-64 ABI is the responsibility of the enclave
+ * and its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C
+ * code without careful consideration by both the enclave and its runtime.
  *
  * All general purpose registers except RAX, RBX and RCX are passed as-is to
  * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME and are
@@ -160,16 +188,13 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
  * without returning to __vdso_sgx_enter_enclave().
  *
  * Return:
- *  0 on success,
+ *  0 on success (ENCLU reached),
  *  -EINVAL if ENCLU leaf is not allowed,
- *  -EFAULT if an exception occurs on ENCLU or within the enclave
  *  -errno for all other negative values returned by the userspace exit handler
  */
 typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
 					unsigned long rdx, unsigned int leaf,
 					unsigned long r8,  unsigned long r9,
-					void *tcs,
-					struct sgx_enclave_exception *e,
-					sgx_enclave_exit_handler_t handler);
+					struct sgx_enclave_run *r);
 
 #endif /* _UAPI_ASM_X86_SGX_H */
-- 
2.28.0

