Return-Path: <SRS0=QZjA=S2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063B5C282CE
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Apr 2019 06:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0DD218DA
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Apr 2019 06:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbfDXG00 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Apr 2019 02:26:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:4222 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729713AbfDXG0Z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Apr 2019 02:26:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Apr 2019 23:26:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,388,1549958400"; 
   d="scan'208";a="145368051"
Received: from bxing-ubuntu.jf.intel.com ([10.23.30.27])
  by fmsmga007.fm.intel.com with ESMTP; 23 Apr 2019 23:26:24 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     cedric.xing@intel.com, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, kai.svahn@intel.com, kai.huang@intel.com,
        jarkko.sakkinen@linux.intel.com
Subject: [RFC PATCH v2 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave() to allow parameter passing on untrusted stack
Date:   Tue, 23 Apr 2019 23:26:22 -0700
Message-Id: <20190424062623.4345-3-cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190424062623.4345-1-cedric.xing@intel.com>
References: <20190424062623.4345-1-cedric.xing@intel.com>
In-Reply-To: <cover.1555965327.git.cedric.xing@intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The previous __vdso_sgx_enter_enclave() requires enclaves to preserve %rsp,
which prohibits enclaves from allocating and passing parameters for
untrusted function calls (aka. o-calls).

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
* __vdso_sgx_enter_enclave() takes one more parameter - a callback function to
  be invoked upon enclave exits. This callback is optional, and if not
  supplied, will cause __vdso_sgx_enter_enclave() to return upon enclave exits
  (same behavior as previous implementation).
* The callback function is given as a parameter the value of %rsp at enclave
  exit to address data "pushed" by the enclave. A positive value returned by
  the callback will be treated as an ENCLU leaf for re-entering the enclave,
  while a zero or negative value will be passed through as the return
  value of __vdso_sgx_enter_enclave() to its caller. It's also safe to
  leave callback by longjmp() or by throwing a C++ exception.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 175 ++++++++++++++++-------
 arch/x86/include/uapi/asm/sgx.h          |  14 +-
 2 files changed, 128 insertions(+), 61 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index fe0bf6671d6d..debecb0d785c 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -19,83 +19,150 @@
  * __vdso_sgx_enter_enclave() - Enter an SGX enclave
  *
  * @leaf:	**IN \%eax** - ENCLU leaf, must be EENTER or ERESUME
- * @tcs:	**IN \%rbx** - TCS, must be non-NULL
- * @ex_info:	**IN \%rcx** - Optional 'struct sgx_enclave_exception' pointer
+ * @tcs:	**IN 0x08(\%rsp)** - TCS, must be non-NULL
+ * @ex_info:	**IN 0x10(\%rsp)** - Optional 'struct sgx_enclave_exinfo'
+ *				     pointer
+ * @callback:	**IN 0x18(\%rsp)** - Optional callback function to be called on
+ *				     enclave exit or exception
  *
  * Return:
  *  **OUT \%eax** -
- *  %0 on a clean entry/exit to/from the enclave, %-EINVAL if ENCLU leaf is
- *  not allowed or if TCS is NULL, %-EFAULT if ENCLU or the enclave faults
+ *  %0 on a clean entry/exit to/from the enclave, %-EINVAL if ENCLU leaf is not
+ *  allowed, %-EFAULT if ENCLU or the enclave faults, or a non-positive value
+ *  returned from ``callback`` (if one is supplied).
  *
  * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
- * x86-64 ABI, i.e. cannot be called from standard C code.   As noted above,
- * input parameters must be passed via ``%eax``, ``%rbx`` and ``%rcx``, with
- * the return value passed via ``%eax``.  All registers except ``%rsp`` must
- * be treated as volatile from the caller's perspective, including but not
- * limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc...  Conversely, the enclave
- * being run **must** preserve the untrusted ``%rsp`` and stack.
+ * x86-64 ABI, i.e. cannot be called from standard C code. As noted above,
+ * input parameters must be passed via ``%eax``, ``8(%rsp)``, ``0x10(%rsp)`` and
+ * ``0x18(%rsp)``, with the return value passed via ``%eax``. All other
+ * registers will be passed through to the enclave as is. All registers except
+ * ``%rbp`` must be treated as volatile from the caller's perspective, including
+ * but not limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc... Conversely, the
+ * enclave being run **must** preserve the untrusted ``%rbp``.
+ *
+ * ``callback`` has the following signature:
+ * int callback(long rdi, long rsi, long rdx,
+ *		struct sgx_enclave_exinfo *exinfo, long r8, long r9,
+ *		void *tcs, long ursp);
+ * ``callback`` **shall** follow x86_64 ABI. All GPRs **except** ``%rax``,
+ * ``%rbx`` and ``rcx`` are passed through to ``callback``. ``%rdi``, ``%rsi``,
+ * ``%rdx``, ``%r8``, ``%r9``, along with the value of ``%rsp`` when the enclave
+ * exited/excepted, can be accessed directly as input parameters, while other
+ * GPRs can be accessed in assembly if needed.  A positive value returned from
+ * ``callback`` will be treated as an ENCLU leaf (e.g. EENTER/ERESUME) to
+ * reenter the enclave (without popping the extra data pushed by the enclave off
+ * the stack), while 0 (zero) or a negative return value will be passed back to
+ * the caller of __vdso_sgx_enter_enclave(). It is also safe to leave
+ * ``callback`` via ``longjmp()`` or by throwing a C++ exception.
  */
-__vdso_sgx_enter_enclave(u32 leaf, void *tcs,
-			 struct sgx_enclave_exception *ex_info)
+typedef int (*sgx_callback)(long rdi, long rsi, long rdx,
+			    struct sgx_enclave_exinfo *exinfo, long r8,
+			    long r9, void *tcs, long ursp);
+int __vdso_sgx_enter_enclave(int leaf, void *tcs,
+			     struct sgx_enclave_exinfo *exinfo,
+			     sgx_callback callback)
 {
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
+	while (leaf == EENTER || leaf == ERESUME) {
+		int rc;
+		try {
+			ENCLU[leaf];
+			rc = 0;
+			if (exinfo)
+				exinfo->leaf = EEXIT;
+		} catch (exception) {
+			rc = -EFAULT;
+			if (exinfo)
+				*exinfo = exception;
+		}
+
+		leaf = callback ? (*callback)(
+			rdi, rsi, rdx, exinfo, r8, r9, tcs, ursp) : rc;
 	}
 
-	return 0;
+	return leaf > 0 ? -EINVAL : leaf;
 }
 #endif
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
+	/* At this point, %ebx holds the effective return value, which shall be
+	 * returned if no callback is specified */
+	cmovz	%rbx, %rax
+	jz	7f
+	/* Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
+	 * restored after *callback returns. */
+	mov	%rsp, %rbx
+	and	$-0x10, %rsp
+	/* Clear RFLAGS.DF per x86_64 ABI */
+	cld
+	/* Parameters for *callback */
+	push	%rbx
+	push	0x10(%rbp)
+	/* Call *%rax via retpoline */
+	call	40f
+	/* Restore %rsp to its original value left off by the enclave from last
+	 * exit */
+	mov	%rbx, %rsp
+	/* Positive return value from *callback will be interpreted as an ENCLU
+	 * leaf, while a non-positive value will be interpreted as the return
+	 * value to be passed back to the caller. */
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

