Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D9AC43461
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF05120770
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:49:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="ntYngxxL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgIPAtI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgIOLmY (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Sep 2020 07:42:24 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C961CC061352;
        Tue, 15 Sep 2020 04:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZlJ9xoMyG5lWAdTzHhTzZdshYUDqCJLRsY6Rk+VgAbs=; b=ntYngxxLjdl5/aSAHmYTD20sdO
        F+LYh+fEh4W1zRJyB76S/45boYQElsBlyqejfvKwWYXFU78U5wH9WpWaQ8OnhIECKtmF4ukzHPEwh
        OBou+cbIuyiLt+KUZofX9XGn25hw49ahBNFraSxcS5NTHei8ZLRzA8O1OBAqBFN7HqDlFZkY8q9uS
        LXzwDvSnS25Jyja/QWsq7WLj/qFQQz5iK56I8snZ+6IZxUQyUgkhGcHmpk9BZV/zJCw2Otso1c2al
        RWMrgehH1lCfmWxhn4ujnCojlbDbZYIL94LixrIeJYukAoZW9s8PucYdSMy9cAx6Rijf6YM1MwzMn
        JRclK47w==;
Received: from 83-245-197-237.elisa-laajakaista.fi ([83.245.197.237] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko.sakkinen@linux.intel.com>)
        id 1kI8mH-000604-AR; Tue, 15 Sep 2020 14:05:37 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX enclave call
Date:   Tue, 15 Sep 2020 14:05:19 +0300
Message-Id: <20200915110522.893152-22-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
References: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 83.245.197.237
X-SA-Exim-Mail-From: jarkko.sakkinen@linux.intel.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

An SGX runtime must be aware of the exceptions, which happen inside an
enclave. Introduce a vDSO call that wraps EENTER/ERESUME cycle and returns
the CPU exception back to the caller exactly when it happens.

Kernel fixups the exception information to RDI, RSI and RDX. The SGX call
vDSO handler fills this information to the user provided buffer or
alternatively trigger user provided callback at the time of the exception.

The calling convention is custom and does not follow System V x86-64 ABI.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Jethro Beekman <jethro@fortanix.com>
Tested-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/entry/vdso/Makefile             |   2 +
 arch/x86/entry/vdso/vdso.lds.S           |   1 +
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 157 +++++++++++++++++++++++
 arch/x86/include/asm/enclu.h             |   8 ++
 arch/x86/include/uapi/asm/sgx.h          | 128 ++++++++++++++++++
 5 files changed, 296 insertions(+)
 create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
 create mode 100644 arch/x86/include/asm/enclu.h

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 3f183d0b8826..416f9432269d 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -29,6 +29,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)	:= y
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
 vobjs32-y := vdso32/note.o vdso32/system_call.o vdso32/sigreturn.o
 vobjs32-y += vdso32/vclock_gettime.o
+vobjs-$(VDSO64-y)		+= vsgx_enter_enclave.o
 
 # files to link into kernel
 obj-y				+= vma.o extable.o
@@ -100,6 +101,7 @@ $(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS
 CFLAGS_REMOVE_vclock_gettime.o = -pg
 CFLAGS_REMOVE_vdso32/vclock_gettime.o = -pg
 CFLAGS_REMOVE_vgetcpu.o = -pg
+CFLAGS_REMOVE_vsgx_enter_enclave.o = -pg
 
 #
 # X32 processes use x32 vDSO to access 64bit kernel data.
diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso.lds.S
index 36b644e16272..4bf48462fca7 100644
--- a/arch/x86/entry/vdso/vdso.lds.S
+++ b/arch/x86/entry/vdso/vdso.lds.S
@@ -27,6 +27,7 @@ VERSION {
 		__vdso_time;
 		clock_getres;
 		__vdso_clock_getres;
+		__vdso_sgx_enter_enclave;
 	local: *;
 	};
 }
diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
new file mode 100644
index 000000000000..adbd59d41517
--- /dev/null
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -0,0 +1,157 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/linkage.h>
+#include <asm/export.h>
+#include <asm/errno.h>
+#include <asm/enclu.h>
+
+#include "extable.h"
+
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
+#define SGX_SYNCHRONOUS_EXIT		0
+#define SGX_EXCEPTION_EXIT		1
+
+/* Offsets into sgx_enter_enclave.exception. */
+#define SGX_EX_LEAF			0*8
+#define SGX_EX_TRAPNR			0*8+4
+#define SGX_EX_ERROR_CODE		0*8+6
+#define SGX_EX_ADDRESS			1*8
+
+.code64
+.section .text, "ax"
+
+SYM_FUNC_START(__vdso_sgx_enter_enclave)
+	/* Prolog */
+	.cfi_startproc
+	push	%rbp
+	.cfi_adjust_cfa_offset	8
+	.cfi_rel_offset		%rbp, 0
+	mov	%rsp, %rbp
+	.cfi_def_cfa_register	%rbp
+	push	%rbx
+	.cfi_rel_offset		%rbx, -8
+
+	mov	%ecx, %eax
+.Lenter_enclave:
+	/* EENTER <= leaf <= ERESUME */
+	cmp	$EENTER, %eax
+	jb	.Linvalid_input
+	cmp	$ERESUME, %eax
+	ja	.Linvalid_input
+
+	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rcx
+
+	/* No flags are currently defined/supported. */
+	cmpl	$0, SGX_ENCLAVE_RUN_FLAGS(%rcx)
+	jne	.Linvalid_input
+
+	/* Load TCS and AEP */
+	mov	SGX_ENCLAVE_RUN_TSC(%rcx), %rbx
+	lea	.Lasync_exit_pointer(%rip), %rcx
+
+	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
+.Lasync_exit_pointer:
+.Lenclu_eenter_eresume:
+	enclu
+
+	/* EEXIT jumps here unless the enclave is doing something fancy. */
+	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
+
+	/* Set exit_reason. */
+	movl	$SGX_SYNCHRONOUS_EXIT, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
+
+	/* Invoke userspace's exit handler if one was provided. */
+.Lhandle_exit:
+	cmpq	$0, SGX_ENCLAVE_RUN_USER_HANDLER(%rbx)
+	jne	.Linvoke_userspace_handler
+
+	/* Success, in the sense that ENCLU was attempted. */
+	xor	%eax, %eax
+
+.Lout:
+	pop	%rbx
+	leave
+	.cfi_def_cfa		%rsp, 8
+	ret
+
+	/* The out-of-line code runs with the pre-leave stack frame. */
+	.cfi_def_cfa		%rbp, 16
+
+.Linvalid_input:
+	mov	$(-EINVAL), %eax
+	jmp	.Lout
+
+.Lhandle_exception:
+	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
+
+	/* Set the exit_reason and exception info. */
+	movl	$SGX_EXCEPTION_EXIT, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
+
+	mov	%eax, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_LEAF)(%rbx)
+	mov	%di,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_TRAPNR)(%rbx)
+	mov	%si,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ERROR_CODE)(%rbx)
+	mov	%rdx, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ADDRESS)(%rbx)
+	jmp	.Lhandle_exit
+
+.Linvoke_userspace_handler:
+	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
+	mov	%rsp, %rcx
+
+	/* Save @e, %rbx is about to be clobbered. */
+	mov	%rbx, %rax
+
+	/* Save the untrusted RSP offset in %rbx (non-volatile register). */
+	mov	%rsp, %rbx
+	and	$0xf, %rbx
+
+	/*
+	 * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
+	 * _after_ pushing the parameters on the stack, hence the bonus push.
+	 */
+	and	$-0x10, %rsp
+	push	%rax
+
+	/* Push @e as a param to the callback. */
+	push	%rax
+
+	/* Clear RFLAGS.DF per x86_64 ABI */
+	cld
+
+	/* Load the callback pointer to %rax and invoke it via retpoline. */
+	mov	SGX_ENCLAVE_RUN_USER_HANDLER(%rax), %rax
+	call	.Lretpoline
+
+	/* Undo the post-exit %rsp adjustment. */
+	lea	0x10(%rsp, %rbx), %rsp
+
+	/*
+	 * If the return from callback is zero or negative, return immediately,
+	 * else re-execute ENCLU with the postive return value interpreted as
+	 * the requested ENCLU leaf.
+	 */
+	cmp	$0, %eax
+	jle	.Lout
+	jmp	.Lenter_enclave
+
+.Lretpoline:
+	call	2f
+1:	pause
+	lfence
+	jmp	1b
+2:	mov	%rax, (%rsp)
+	ret
+	.cfi_endproc
+
+_ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
+
+SYM_FUNC_END(__vdso_sgx_enter_enclave)
diff --git a/arch/x86/include/asm/enclu.h b/arch/x86/include/asm/enclu.h
new file mode 100644
index 000000000000..06157b3e9ede
--- /dev/null
+++ b/arch/x86/include/asm/enclu.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_ENCLU_H
+#define _ASM_X86_ENCLU_H
+
+#define EENTER	0x02
+#define ERESUME	0x03
+
+#endif /* _ASM_X86_ENCLU_H */
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index d0916fb9629e..1564d7f88597 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -72,4 +72,132 @@ struct sgx_enclave_provision {
 	__u64 attribute_fd;
 };
 
+#define SGX_SYNCHRONOUS_EXIT	0
+#define SGX_EXCEPTION_EXIT	1
+
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
+/**
+ * struct sgx_enclave_exception - structure to report exceptions encountered in
+ *				  __vdso_sgx_enter_enclave()
+ *
+ * @leaf:	ENCLU leaf from \%eax at time of exception
+ * @trapnr:	exception trap number, a.k.a. fault vector
+ * @error_code:	exception error code
+ * @address:	exception address, e.g. CR2 on a #PF
+ */
+struct sgx_enclave_exception {
+	__u32 leaf;
+	__u16 trapnr;
+	__u16 error_code;
+	__u64 address;
+};
+
+/**
+ * struct sgx_enclave_run - Control structure for __vdso_sgx_enter_enclave()
+ *
+ * @tcs:		Thread Control Structure used to enter enclave
+ * @flags:		Control flags
+ * @exit_reason:	Cause of exit from enclave, e.g. EEXIT vs. exception
+ * @user_handler:	User provided exit handler (optional)
+ * @user_data:		User provided opaque value (optional)
+ * @exception:		Valid on exit due to exception
+ */
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
+
+/**
+ * typedef vdso_sgx_enter_enclave_t - Prototype for __vdso_sgx_enter_enclave(),
+ *				      a vDSO function to enter an SGX enclave.
+ *
+ * @rdi:	Pass-through value for RDI
+ * @rsi:	Pass-through value for RSI
+ * @rdx:	Pass-through value for RDX
+ * @leaf:	ENCLU leaf, must be EENTER or ERESUME
+ * @r8:		Pass-through value for R8
+ * @r9:		Pass-through value for R9
+ * @r:		struct sgx_enclave_run, must be non-NULL
+ *
+ * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance with the
+ * x86-64 ABI, e.g. doesn't handle XSAVE state.  Except for non-volatile
+ * general purpose registers, EFLAGS.DF, and RSP alignment, preserving/setting
+ * state in accordance with the x86-64 ABI is the responsibility of the enclave
+ * and its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C
+ * code without careful consideration by both the enclave and its runtime.
+ *
+ * All general purpose registers except RAX, RBX and RCX are passed as-is to
+ * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME and are
+ * loaded with @leaf, asynchronous exit pointer, and @tcs respectively.
+ *
+ * RBP and the stack are used to anchor __vdso_sgx_enter_enclave() to the
+ * pre-enclave state, e.g. to retrieve @e and @handler after an enclave exit.
+ * All other registers are available for use by the enclave and its runtime,
+ * e.g. an enclave can push additional data onto the stack (and modify RSP) to
+ * pass information to the optional exit handler (see below).
+ *
+ * Most exceptions reported on ENCLU, including those that occur within the
+ * enclave, are fixed up and reported synchronously instead of being delivered
+ * via a standard signal. Debug Exceptions (#DB) and Breakpoints (#BP) are
+ * never fixed up and are always delivered via standard signals. On synchrously
+ * reported exceptions, -EFAULT is returned and details about the exception are
+ * recorded in @e, the optional sgx_enclave_exception struct.
+ *
+ * If an exit handler is provided, the handler will be invoked on synchronous
+ * exits from the enclave and for all synchronously reported exceptions. In
+ * latter case, @e is filled prior to invoking the handler.
+ *
+ * The exit handler's return value is interpreted as follows:
+ *  >0:		continue, restart __vdso_sgx_enter_enclave() with @ret as @leaf
+ *   0:		success, return @ret to the caller
+ *  <0:		error, return @ret to the caller
+ *
+ * The exit handler may transfer control, e.g. via longjmp() or C++ exception,
+ * without returning to __vdso_sgx_enter_enclave().
+ *
+ * Return:
+ *  0 on success (ENCLU reached),
+ *  -EINVAL if ENCLU leaf is not allowed,
+ *  -errno for all other negative values returned by the userspace exit handler
+ */
+typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
+					unsigned long rdx, unsigned int leaf,
+					unsigned long r8,  unsigned long r9,
+					struct sgx_enclave_run *r);
+
 #endif /* _UAPI_ASM_X86_SGX_H */
-- 
2.25.1

