Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE9BC742DF
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 06:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D170F204FD
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 06:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfGMGva (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 02:51:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:55267 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfGMGv3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 02:51:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 23:51:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,485,1557212400"; 
   d="scan'208";a="318200504"
Received: from bxing-ubuntu.jf.intel.com ([10.23.30.27])
  by orsmga004.jf.intel.com with ESMTP; 12 Jul 2019 23:51:27 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        jarkko.sakkinen@linux.intel.com
Cc:     cedric.xing@intel.com, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, kai.svahn@intel.com, kai.huang@intel.com
Subject: [RFC PATCH v4 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave() to allow parameter passing on untrusted stack
Date:   Fri, 12 Jul 2019 23:51:26 -0700
Message-Id: <e3987c04e44c3d366d762c22d6e692e043d0580b.1563000446.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1563000446.git.cedric.xing@intel.com>
References: <cover.1563000446.git.cedric.xing@intel.com>
In-Reply-To: <cover.1563000446.git.cedric.xing@intel.com>
References: <cover.1562813643.git.cedric.xing@intel.com> <cover.1563000446.git.cedric.xing@intel.com>
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
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 310 +++++++++++++++++------
 arch/x86/include/uapi/asm/sgx.h          |  14 +-
 2 files changed, 242 insertions(+), 82 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index fe0bf6671d6d..a96542ba6945 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -6,96 +6,256 @@
 
 #include "extable.h"
 
-#define EX_LEAF		0*8
-#define EX_TRAPNR	0*8+4
-#define EX_ERROR_CODE	0*8+6
-#define EX_ADDRESS	1*8
+#define EX_LEAF     0*8
+#define EX_TRAPNR   0*8+4
+#define EX_ERROR_CODE   0*8+6
+#define EX_ADDRESS  1*8
 
 .code64
 .section .text, "ax"
 
 #ifdef SGX_KERNEL_DOC
 /**
- * __vdso_sgx_enter_enclave() - Enter an SGX enclave
+ * typedef sgx_ex_callback - Callback function for __vdso_sgx_enter_enclave()
  *
- * @leaf:	**IN \%eax** - ENCLU leaf, must be EENTER or ERESUME
- * @tcs:	**IN \%rbx** - TCS, must be non-NULL
- * @ex_info:	**IN \%rcx** - Optional 'struct sgx_enclave_exception' pointer
+ * @rdi:    value of %%rdi register at enclave exit
+ * @rsi:    value of %%rsi register at enclave exit
+ * @rdx:    value of %%rdx register at enclave exit
+ * @exinfo: pointer to a sgx_enclave_exinfo structure, which was passed to
+ *      __vdso_sgx_enter_enclave() as input
+ * @r8:     value of %%r8 register at enclave exit
+ * @r9:     value of %%r9 register at enclave exit
+ * @tcs:    TCS used by __vdso_sgx_enter_enclave() to enter the enclave,
+ *      could be used to re-enter the
+ *      enclave
+ * @ursp:   value of %%rsp register at enclave exit
+ *
+ * This is the callback function to be invoked upon enclave exits, including
+ * normal exits (as result of EEXIT), and asynchronous exits (AEX) due to
+ * exceptions occurred at EENTER or within the enclave.
+ *
+ * This callback is expected to follow x86_64 ABI.
  *
  * Return:
- *  **OUT \%eax** -
- *  %0 on a clean entry/exit to/from the enclave, %-EINVAL if ENCLU leaf is
- *  not allowed or if TCS is NULL, %-EFAULT if ENCLU or the enclave faults
- *
- * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
- * x86-64 ABI, i.e. cannot be called from standard C code.   As noted above,
- * input parameters must be passed via ``%eax``, ``%rbx`` and ``%rcx``, with
- * the return value passed via ``%eax``.  All registers except ``%rsp`` must
- * be treated as volatile from the caller's perspective, including but not
- * limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc...  Conversely, the enclave
- * being run **must** preserve the untrusted ``%rsp`` and stack.
+ *
+ * EENTER(2) - causes __vdso_sgx_enter_enclave() to issue ENCLU[EENTER] on the
+ * same TCS. All GPRs left off by this callback function will be passed through
+ * back to the enclave, except %%rax, %%rbx and %%rcx, which are clobbered by
+ * ENCLU[EENTER] instruction.
+ *
+ * ERESUME(3) - causes __vdso_sgx_enter_enclave() to issue ENCLU[ERESUME] on
+ * the same TCS.
+ *
+ * 0 (zero) or negative returned values will be returned back to
+ * __vdso_sgx_enter_enclave()'s caller as is.
+ *
+ * All other values will cause -EINVAL to be returned to
+ * __vdso_sgx_enter_enclave()'s caller.
+ *
+ * Note: All general purpose registers (GPRs) left off by the enclave are
+ * passed through to this function, except %%rax, %%rbx and %%rcx, which are
+ * used internally by __vdso_sgx_enter_enclave(). Some of those registers are
+ * accessible as function parameters (i.e. @rdi, @rsi, @rdx, @r8, @r9 and
+ * @ursp), while others can be accessed only from assembly code.
  */
-__vdso_sgx_enter_enclave(u32 leaf, void *tcs,
-			 struct sgx_enclave_exception *ex_info)
-{
-	if (leaf != SGX_EENTER && leaf != SGX_ERESUME)
-		return -EINVAL;
+typedef int sgx_ex_callback(long rdi, long rsi, long rdx,
+                struct sgx_enclave_exinfo *exinfo,
+                long r8, long r9, void *tcs, long ursp);
 
-	if (!tcs)
-		return -EINVAL;
+/**
+ * __vdso_sgx_enter_enclave() - Enter an SGX enclave and capture exceptions
+ *
+ * @leaf:
+ *  passed in %%eax, must be either EENTER(2) or ERESUME(3)
+ * @tcs:
+ *  passed on stack at 8(%%rsp), is the linear address of TCS
+ * @exinfo:
+ *  passed on stack at 0x10(%%rsp), optional, and if non-NULL, shall point
+ *  to an sgx_enclave_exinfo structure to receive information about the
+ *  enclave exit
+ * @callback:
+ *  passed on stack at 0x18(%%rsp), optional, and if non-NULL, points to a
+ *  callback function to be invoked at enclave exits
+ *
+ * __vdso_sgx_enter_enclave() issues either ENCLU[EENTER] or ENCLU[ERESUME] on
+ * @tcs depending on @leaf.
+ *
+ * IMPORTANT! This API is not compliant with x86-64 ABI but adopts a
+ * proprietary calling convention. Please see NOTES section below for details.
+ *
+ * On an enclave exit, @exinfo->leaf will be set to the ENCLU leaf at exit, if
+ * @exinfo is not NULL. That is, @exinfo->leaf may be one of the following:
+ *
+ *   * EEXIT:   Normal exit due to ENCLU[EEXIT] within the enclave. All other
+ *      members will remain intact.
+ *
+ *   * ERESUME: Asynchronous exit due to exceptions within the enclave.
+ *      @exinfo->trapnr, @exinfo->error_code and @exinfo->address are
+ *      set to the trap number, error code and fault address,
+ *      respectively.
+ *
+ *   * EENTER:  Exception occurred when trying to enter the enclave.
+ *      @exinfo->trapnr, @exinfo->error_code and @exinfo->address are
+ *      set to the trap number, error code and fault address,
+ *      accordingly.
+ *
+ * If @callback is NULL, 0 (zero) is returned if the enclave has been entered
+ * and exited normally, or -EFAULT if any exception has occurred, or -EINVAL if
+ * @leaf on input is neither EENTER or ERESUME.
+ *
+ * If @callback is not NULL, it is invoked at enclave exit, and then actions
+ * will be taken depending on its return value - i.e. positive value will be
+ * treated as ENCLU leaf to re-enter the enclave, while 0 (zero) or negative
+ * values will be returned back to the caller as is. Unrecognized leaf values
+ * will cause -EINVAL to be returned.
+ *
+ * Return:
+ *
+ * 0 (zero) is returned on a successful entry and normal exit from the enclave.
+ *
+ * -EINVAL is returned if @leaf is neither EENTER nor ERESUME, or if @callback
+ * is not NULL and returns a positive value that is neither EENTER nor ERESUME
+ * after the enclave exits.
+ *
+ * -EFAULT is returned if an exception has occurred at EENTER or during
+ * execution of the enclave and @callback is NULL, or if @callback is not NULL
+ * and it returns -EFAULT after the enclave exits.
+ *
+ * Other values may be returned as the return value from @callback if it is not
+ * NULL.
+ *
+ * Note: __vdso_sgx_enter_enclave() adopts a proprietary calling convention,
+ * described below:
+ *
+ *    * As noted above, input parameters are passed via %%eax and the stack.
+ *
+ *    * %%rbx and %%rcx must be treated as volatile as they are modified as part
+ *  of enclaves transitions and are used as scratch regs.
+ *
+ *    * %%rdx, %%rdi, %%rsi and %%r8-%%r15 are passed as is and may be freely
+ *  modified by the enclave. Values left in those registers will not be
+ *  altered either, so will be visiable to the callback or the caller (if no
+ *  callback is specified).
+ *
+ *    * %%rsp could be decremented by the enclave to allocate temporary space on
+ *      the untrusted stack. Temporary space allocated this way is retained in
+ *      the context of @callback, and will be freed (i.e. %%rsp will be
+ *      restored) before __vdso_sgx_enter_enclave() returns.
+ */
+int __vdso_sgx_enter_enclave(int leaf, void *tcs,
+                 struct sgx_enclave_exinfo *exinfo,
+                 sgx_ex_callback *callback);
+{
+     while (leaf == EENTER || leaf == ERESUME) {
+    int rc;
+    try {
+        ENCLU[leaf];
+        rc = 0;
+        if (exinfo)
+            exinfo->leaf = EEXIT;
+    } catch (exception) {
+        rc = -EFAULT;
+        if (exinfo)
+            *exinfo = exception;
+    }
 
-	try {
-		ENCLU[leaf];
-	} catch (exception) {
-		if (e)
-			*e = exception;
-		return -EFAULT;
-	}
+    leaf = !callback ? rc: (*callback)(rdi, rsi, rdx, exinfo,
+                       r8, r9, tcs, ursp);
+     }
 
-	return 0;
+     return leaf > 0 ? -EINVAL : leaf;
 }
 #endif
+
 ENTRY(__vdso_sgx_enter_enclave)
-	/* EENTER <= leaf <= ERESUME */
-	cmp	$0x2, %eax
-	jb	bad_input
-
-	cmp	$0x3, %eax
-	ja	bad_input
-
-	/* TCS must be non-NULL */
-	test	%rbx, %rbx
-	je	bad_input
-
-	/* Save @exception_info */
-	push	%rcx
-
-	/* Load AEP for ENCLU */
-	lea	1f(%rip),  %rcx
-1:	enclu
-
-	add	$0x8, %rsp
-	xor	%eax, %eax
-	ret
-
-bad_input:
-	mov     $(-EINVAL), %rax
-	ret
-
-.pushsection .fixup, "ax"
-	/* Re-load @exception_info and fill it (if it's non-NULL) */
-2:	pop	%rcx
-	test    %rcx, %rcx
-	je      3f
-
-	mov	%eax, EX_LEAF(%rcx)
-	mov	%di,  EX_TRAPNR(%rcx)
-	mov	%si,  EX_ERROR_CODE(%rcx)
-	mov	%rdx, EX_ADDRESS(%rcx)
-3:	mov	$(-EFAULT), %rax
-	ret
-.popsection
-
-_ASM_VDSO_EXTABLE_HANDLE(1b, 2b)
+    /* Prolog */
+    .cfi_startproc
+    push    %rbp
+    .cfi_adjust_cfa_offset  8
+    .cfi_rel_offset     %rbp, 0
+    mov %rsp, %rbp
+    .cfi_def_cfa_register   %rbp
+
+1:  /* EENTER <= leaf <= ERESUME */
+    cmp $0x2, %eax
+    jb  6f
+    cmp $0x3, %eax
+    ja  6f
+
+    /* Load TCS and AEP */
+    mov 0x10(%rbp), %rbx
+    lea 2f(%rip), %rcx
+
+    /* Single ENCLU serving as both EENTER and AEP (ERESUME) */
+2:  enclu
+
+    /* EEXIT path */
+    xor %ebx, %ebx
+3:  mov 0x18(%rbp), %rcx
+    jrcxz   4f
+    mov %eax, EX_LEAF(%rcx)
+    jnc 4f
+    mov %di, EX_TRAPNR(%rcx)
+    mov %si, EX_ERROR_CODE(%rcx)
+    mov %rdx, EX_ADDRESS(%rcx)
+
+4:  /* Call *callback if supplied */
+    mov 0x20(%rbp), %rax
+    test    %rax, %rax
+    /*
+     * At this point, %ebx holds the effective return value, which shall be
+     * returned if no callback is specified
+     */
+    cmovz   %rbx, %rax
+    jz  7f
+    /*
+     * Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
+     * restored after *callback returns.
+     */
+    mov %rsp, %rbx
+    and $-0x10, %rsp
+    /* Clear RFLAGS.DF per x86_64 ABI */
+    cld
+    /* Parameters for *callback */
+    push    %rbx
+    push    0x10(%rbp)
+    /* Call *%rax via retpoline */
+    call    40f
+    /*
+     * Restore %rsp to its original value left off by the enclave from last
+     * exit
+     */
+    mov %rbx, %rsp
+    /*
+     * Positive return value from *callback will be interpreted as an ENCLU
+     * leaf, while a non-positive value will be interpreted as the return
+     * value to be passed back to the caller.
+     */
+    jmp 1b
+40: /* retpoline */
+    call    42f
+41: pause
+    lfence
+    jmp 41b
+42: mov %rax, (%rsp)
+    ret
+
+5:  /* Exception path */
+    mov $-EFAULT, %ebx
+    stc
+    jmp 3b
+
+6:  /* Unsupported ENCLU leaf */
+    cmp $0, %eax
+    jle 7f
+    mov $-EINVAL, %eax
+
+7:  /* Epilog */
+    leave
+    .cfi_def_cfa        %rsp, 8
+    ret
+    .cfi_endproc
+
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

