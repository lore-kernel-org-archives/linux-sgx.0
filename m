Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA7FC74A42
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 04:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 163C8206B8
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 04:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfGKEVi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 00:21:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:22501 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfGKEVi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 00:21:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 21:21:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,476,1557212400"; 
   d="scan'208";a="186293855"
Received: from hmendezc-mobl1.amr.corp.intel.com (HELO ubt18m.amr.corp.intel.com) ([10.252.143.173])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jul 2019 21:21:37 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Cedric Xing <cedric.xing@intel.com>, luto@kernel.org,
        jethro@fortanix.com, greg@enjellic.com,
        jarkko.sakkinen@linux.intel.com, sean.j.christopherson@intel.com
Subject: [RFC PATCH v3 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave() to allow parameter passing on untrusted stack
Date:   Wed, 10 Jul 2019 21:21:32 -0700
Message-Id: <742dfe18ee4128ccccf8313b6c6cb3ee8b961712.1562813643.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1562813643.git.cedric.xing@intel.com>
References: <cover.1562813643.git.cedric.xing@intel.com>
MIME-Version: 1.0
In-Reply-To: <cover.1562813643.git.cedric.xing@intel.com>
References: <20190424062623.4345-1-cedric.xing@intel.com> <cover.1562813643.git.cedric.xing@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The previous __vdso_sgx_enter_enclave() requires enclaves to preserve %rsp,
which prohibits enclaves from allocating and passing parameters for
untrusted function calls (aka. o-calls) on the untrusted stack.

This patch addresses the problem above by introducing a new ABI that preserves
%rbp instead of %rsp. Then __vdso_sgx_enter_enclave() can anchor its frame
using %rbp so that enclaves are allowed to allocate space on the untrusted
stack by decrementing %rsp. Please note that the stack space allocated in such
way will be part of __vdso_sgx_enter_enclave()'s frame so will be freed after
__vdso_sgx_enter_enclave() returns. Therefore, __vdso_sgx_enter_enclave() has
been revised to take a callback function as an optional parameter, which if
supplied, will be invoked upon enclave exits (both AEX (Asynchronous Enclave
eXit) and normal exits), with the value of %rsp left off by the enclave as a
parameter to the callback.

Here's the summary of API/ABI changes in this patch. More details could be
found in arch/x86/entry/vdso/vsgx_enter_enclave.S.
  * 'struct sgx_enclave_exception' is renamed to 'struct sgx_enclave_exinfo'
    because it is filled upon both AEX (i.e. exceptions) and normal enclave
    exits.
  * __vdso_sgx_enter_enclave() anchors its frame using %rbp (instead of %rsp in
    the previous implementation).
  * __vdso_sgx_enter_enclave() takes one more parameter - a callback function
    to be invoked upon enclave exits. This callback is optional, and if not
    supplied, will cause __vdso_sgx_enter_enclave() to return upon enclave
    exits (same behavior as previous implementation).
  * The callback function is given as a parameter the value of %rsp at enclave
    exit to address data "pushed" by the enclave. A positive value returned by
    the callback will be treated as an ENCLU leaf for re-entering the enclave,
    while a zero or negative value will be passed through as the return
    value of __vdso_sgx_enter_enclave() to its caller. It's also safe to
    leave callback by longjmp() or by throwing a C++ exception.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 214 ++++++++++++++++-------
 arch/x86/include/uapi/asm/sgx.h          |  14 +-
 2 files changed, 157 insertions(+), 71 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index fe0bf6671d6d..62f28c01b3c8 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -14,88 +14,174 @@
 .code64
 .section .text, "ax"
 
-#ifdef SGX_KERNEL_DOC
 /**
  * __vdso_sgx_enter_enclave() - Enter an SGX enclave
  *
- * @leaf:	**IN \%eax** - ENCLU leaf, must be EENTER or ERESUME
- * @tcs:	**IN \%rbx** - TCS, must be non-NULL
- * @ex_info:	**IN \%rcx** - Optional 'struct sgx_enclave_exception' pointer
+ * Parameters:
+ *	@leaf, passed in %eax, must be either EENTER(2) or ERESUME(3)
+ *	@tcs, passed on stack at 8(%rsp), is the linear address of TCS
+ *	@exinfo, passed on stack at 0x10(%rsp), is optional, and if non-NULL,
+ *	shall point to an sgx_enclave_exinfo structure to receive information
+ *	about the enclave exit
+ *	@callback, passed on stack at 0x18(%rsp), is optiona, and if non-NULL,
+ *	points to a callback function that will be invoked after the enclave
+ *	exits
  *
- * Return:
- *  **OUT \%eax** -
- *  %0 on a clean entry/exit to/from the enclave, %-EINVAL if ENCLU leaf is
- *  not allowed or if TCS is NULL, %-EFAULT if ENCLU or the enclave faults
+ * Returns:
+ *	$0 (zero) on a clean exit from the enclave
+ *	$-EINVAL will be returned if leaf isn't either EENTER or ERESUME
+ *	Other negative values could also be returned as the return value from
+ *	the callback function
  *
- * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
- * x86-64 ABI, i.e. cannot be called from standard C code.   As noted above,
- * input parameters must be passed via ``%eax``, ``%rbx`` and ``%rcx``, with
- * the return value passed via ``%eax``.  All registers except ``%rsp`` must
- * be treated as volatile from the caller's perspective, including but not
- * limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc...  Conversely, the enclave
- * being run **must** preserve the untrusted ``%rsp`` and stack.
+ * IMPORTANT! This API is **not** compliant with x86-64 ABI but adopts a
+ * proprietary calling convention, described below:
+ *   · As noted above, input parameters are passed via %eax and the stack.
+ *   · The return value is passed via %eax.
+ *   · %rbx and %rcx must be treated as volatile as they are modified as part
+ *     of enclaves transitions and are used as scratch regs.
+ *   · %rdx, %rdi, %rsi and %r8-%r15 are passed as is and may be freely
+ *     modified by the enclave. Values left in those registers will not be
+ *     altered either, so will be visiable to the callback or the caller (if no
+ *     callback is specified).
+ *   · %rsp is saved/restored across __vdso_sgx_enter_enclave().
+ *
+ * A callback function, if supplied, shall have the following signature:
+ *
+ *	int callback(long rdi, long rsi, long rdx,
+ *		     struct sgx_enclave_exinfo *exinfo, long r8, long r9,
+ *		     void *tcs, long ursp);
+ *
+ * Callback functions shall comply to x86_64 ABI.
+ *   · All registers left off by the enclave are passed as is except %rax, %rbx
+ *     and %rcx. %rdi, %rsi, %r8 and %9 could be accessed as function
+ *     parameters, while other registers could be access in assembly code if
+ *     needed.
+ *   · Positive return values from the callback will be interpreted as ENCLU
+ *     leafs to re-enter the enclave. Currently only EENTER(2) and ERESUME(3)
+ *     are supported, while all other positive return values will result in
+ *     $-EINVAL returned to the caller of __vdso_sgx_enter_enclave().
+ *   · $0 (zero) or negative return values will be passed back to the caller of
+ *     __vdso_sgx_enter_enclave() as is.
+ *
+ * Pseudo-code:
+ *
+ * typedef int (*sgx_callback)(long rdi, long rsi, long rdx,
+ *			       struct sgx_enclave_exinfo *exinfo, long r8,
+ *			       long r9, void *tcs, long ursp);
+ *
+ * int __vdso_sgx_enter_enclave(int leaf, void *tcs,
+ *				struct sgx_enclave_exinfo *exinfo,
+ *				sgx_callback callback)
+ * {
+ *	while (leaf == EENTER || leaf == ERESUME) {
+ *		int rc;
+ *		try {
+ *			ENCLU[leaf];
+ *			rc = 0;
+ *			if (exinfo)
+ *				exinfo->leaf = EEXIT;
+ *		} catch (exception) {
+ *			rc = -EFAULT;
+ *			if (exinfo)
+ *				*exinfo = exception;
+ *		}
+ *
+ *		leaf = !callback ? rc: (*callback)(rdi, rsi, rdx, exinfo,
+ *						   r8, r9, tcs, ursp);
+ *	}
+ *
+ *	return leaf > 0 ? -EINVAL : leaf;
+ * }
  */
-__vdso_sgx_enter_enclave(u32 leaf, void *tcs,
-			 struct sgx_enclave_exception *ex_info)
-{
-	if (leaf != SGX_EENTER && leaf != SGX_ERESUME)
-		return -EINVAL;
-
-	if (!tcs)
-		return -EINVAL;
-
-	try {
-		ENCLU[leaf];
-	} catch (exception) {
-		if (e)
-			*e = exception;
-		return -EFAULT;
-	}
-
-	return 0;
-}
-#endif
 ENTRY(__vdso_sgx_enter_enclave)
-	/* EENTER <= leaf <= ERESUME */
+	/* Prolog */
+	.cfi_startproc
+	push	%rbp
+	.cfi_adjust_cfa_offset	8
+	.cfi_rel_offset		%rbp, 0
+	mov	%rsp, %rbp
+	.cfi_def_cfa_register	%rbp
+
+1:	/* EENTER <= leaf <= ERESUME */
 	cmp	$0x2, %eax
-	jb	bad_input
-
+	jb	6f
 	cmp	$0x3, %eax
-	ja	bad_input
+	ja	6f
 
-	/* TCS must be non-NULL */
-	test	%rbx, %rbx
-	je	bad_input
+	/* Load TCS and AEP */
+	mov	0x10(%rbp), %rbx
+	lea	2f(%rip), %rcx
 
-	/* Save @exception_info */
-	push	%rcx
+	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
+2:	enclu
 
-	/* Load AEP for ENCLU */
-	lea	1f(%rip),  %rcx
-1:	enclu
+	/* EEXIT path */
+	xor	%ebx, %ebx
+3:	mov	0x18(%rbp), %rcx
+	jrcxz	4f
+	mov	%eax, EX_LEAF(%rcx)
+	jnc	4f
+	mov	%di, EX_TRAPNR(%rcx)
+	mov	%si, EX_ERROR_CODE(%rcx)
+	mov	%rdx, EX_ADDRESS(%rcx)
 
-	add	$0x8, %rsp
-	xor	%eax, %eax
+4:	/* Call *callback if supplied */
+	mov	0x20(%rbp), %rax
+	test	%rax, %rax
+	/*
+	 * At this point, %ebx holds the effective return value, which shall be
+	 * returned if no callback is specified
+	 */
+	cmovz	%rbx, %rax
+	jz	7f
+	/*
+	 * Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
+	 * restored after *callback returns.
+	 */
+	mov	%rsp, %rbx
+	and	$-0x10, %rsp
+	/* Clear RFLAGS.DF per x86_64 ABI */
+	cld
+	/* Parameters for *callback */
+	push	%rbx
+	push	0x10(%rbp)
+	/* Call *%rax via retpoline */
+	call	40f
+	/*
+	 * Restore %rsp to its original value left off by the enclave from last
+	 * exit
+	 */
+	mov	%rbx, %rsp
+	/*
+	 * Positive return value from *callback will be interpreted as an ENCLU
+	 * leaf, while a non-positive value will be interpreted as the return
+	 * value to be passed back to the caller.
+	 */
+	jmp	1b
+40:	/* retpoline */
+	call	42f
+41:	pause
+	lfence
+	jmp	41b
+42:	mov	%rax, (%rsp)
 	ret
 
-bad_input:
-	mov     $(-EINVAL), %rax
-	ret
+5:	/* Exception path */
+	mov	$-EFAULT, %ebx
+	stc
+	jmp	3b
 
-.pushsection .fixup, "ax"
-	/* Re-load @exception_info and fill it (if it's non-NULL) */
-2:	pop	%rcx
-	test    %rcx, %rcx
-	je      3f
+6:	/* Unsupported ENCLU leaf */
+	cmp	$0, %eax
+	jle	7f
+	mov	$-EINVAL, %eax
 
-	mov	%eax, EX_LEAF(%rcx)
-	mov	%di,  EX_TRAPNR(%rcx)
-	mov	%si,  EX_ERROR_CODE(%rcx)
-	mov	%rdx, EX_ADDRESS(%rcx)
-3:	mov	$(-EFAULT), %rax
+7:	/* Epilog */
+	leave
+	.cfi_def_cfa		%rsp, 8
 	ret
-.popsection
+	.cfi_endproc
 
-_ASM_VDSO_EXTABLE_HANDLE(1b, 2b)
+_ASM_VDSO_EXTABLE_HANDLE(2b, 5b)
 
 ENDPROC(__vdso_sgx_enter_enclave)
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 9ed690a38c70..50d2b5143e5e 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -24,7 +24,7 @@
 
 /**
  * struct sgx_enclave_create - parameter structure for the
- *                             %SGX_IOC_ENCLAVE_CREATE ioctl
+ *			       %SGX_IOC_ENCLAVE_CREATE ioctl
  * @src:	address for the SECS page data
  */
 struct sgx_enclave_create  {
@@ -33,7 +33,7 @@ struct sgx_enclave_create  {
 
 /**
  * struct sgx_enclave_add_page - parameter structure for the
- *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
+ *				 %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
  * @addr:	address within the ELRANGE
  * @src:	address for the page data
  * @secinfo:	address for the SECINFO data
@@ -49,7 +49,7 @@ struct sgx_enclave_add_page {
 
 /**
  * struct sgx_enclave_init - parameter structure for the
- *                           %SGX_IOC_ENCLAVE_INIT ioctl
+ *			     %SGX_IOC_ENCLAVE_INIT ioctl
  * @sigstruct:	address for the SIGSTRUCT data
  */
 struct sgx_enclave_init {
@@ -66,16 +66,16 @@ struct sgx_enclave_set_attribute {
 };
 
 /**
- * struct sgx_enclave_exception - structure to report exceptions encountered in
- *				  __vdso_sgx_enter_enclave()
+ * struct sgx_enclave_exinfo - structure to report exceptions encountered in
+ *			       __vdso_sgx_enter_enclave()
  *
- * @leaf:	ENCLU leaf from \%eax at time of exception
+ * @leaf:	ENCLU leaf from \%eax at time of exception/exit
  * @trapnr:	exception trap number, a.k.a. fault vector
  * @error_code:	exception error code
  * @address:	exception address, e.g. CR2 on a #PF
  * @reserved:	reserved for future use
  */
-struct sgx_enclave_exception {
+struct sgx_enclave_exinfo {
 	__u32 leaf;
 	__u16 trapnr;
 	__u16 error_code;
-- 
2.17.1

