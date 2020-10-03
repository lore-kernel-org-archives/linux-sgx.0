Return-Path: <SRS0=MzOG=DK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06185C46466
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 04:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C03E123447
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 04:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgJCEwN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Oct 2020 00:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgJCEvy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Oct 2020 00:51:54 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E11A72220D;
        Sat,  3 Oct 2020 04:51:52 +0000 (UTC)
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
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v39 21/24] x86/vdso: Implement a vDSO for Intel SGX enclave call
Date:   Sat,  3 Oct 2020 07:50:56 +0300
Message-Id: <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

The calling convention supports providing the parameters in standard RDI
RSI, RDX, RCX, R8 and R9 registers, i.e. it is possible to declare the vDSO
as a C prototype, but other than that there is no specific support for
SystemV ABI. Storing XSAVE etc. is all responsibility of the enclave and
the associated run-time.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Jethro Beekman <jethro@fortanix.com>
Tested-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Cedric Xing <cedric.xing@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/entry/vdso/Makefile    |   2 +
 arch/x86/entry/vdso/vdso.lds.S  |   1 +
 arch/x86/entry/vdso/vsgx.S      | 157 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/enclu.h    |   9 ++
 arch/x86/include/uapi/asm/sgx.h |  98 ++++++++++++++++++++
 5 files changed, 267 insertions(+)
 create mode 100644 arch/x86/entry/vdso/vsgx.S
 create mode 100644 arch/x86/include/asm/enclu.h

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 3f183d0b8826..27e7635e31d3 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -29,6 +29,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)	:= y
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
 vobjs32-y := vdso32/note.o vdso32/system_call.o vdso32/sigreturn.o
 vobjs32-y += vdso32/vclock_gettime.o
+vobjs-$(VDSO64-y)		+= vsgx.o
 
 # files to link into kernel
 obj-y				+= vma.o extable.o
@@ -100,6 +101,7 @@ $(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS
 CFLAGS_REMOVE_vclock_gettime.o = -pg
 CFLAGS_REMOVE_vdso32/vclock_gettime.o = -pg
 CFLAGS_REMOVE_vgetcpu.o = -pg
+CFLAGS_REMOVE_vsgx.o = -pg
 
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
diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vsgx.S
new file mode 100644
index 000000000000..5c047e588f16
--- /dev/null
+++ b/arch/x86/entry/vdso/vsgx.S
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
+	mov	SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rcx
+
+	/* Validate that the reserved area contains only zeros. */
+	push	%rax
+	push	%rbx
+	mov	$SGX_ENCLAVE_RUN_RESERVED_START, %rbx
+1:
+	mov	(%rcx, %rbx), %rax
+	cmpq	$0, %rax
+	jne	.Linvalid_input
+
+	add	$8, %rbx
+	cmpq	$SGX_ENCLAVE_RUN_RESERVED_END, %rbx
+	jne	1b
+	pop	%rbx
+	pop	%rax
+
+	/* Load TCS and AEP */
+	mov	SGX_ENCLAVE_RUN_TCS(%rcx), %rbx
+	lea	.Lasync_exit_pointer(%rip), %rcx
+
+	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
+.Lasync_exit_pointer:
+.Lenclu_eenter_eresume:
+	enclu
+
+	/* EEXIT jumps here unless the enclave is doing something fancy. */
+	mov	SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rbx
+
+	/* Set exit_reason. */
+	movl	$EEXIT, SGX_ENCLAVE_RUN_LEAF(%rbx)
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
+	mov	SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rbx
+
+	/* Set the exception info. */
+	mov	%eax, (SGX_ENCLAVE_RUN_LEAF)(%rbx)
+	mov	%di,  (SGX_ENCLAVE_RUN_EXCEPTION_VECTOR)(%rbx)
+	mov	%si,  (SGX_ENCLAVE_RUN_EXCEPTION_ERROR_CODE)(%rbx)
+	mov	%rdx, (SGX_ENCLAVE_RUN_EXCEPTION_ADDR)(%rbx)
+	jmp	.Lhandle_exit
+
+.Linvoke_userspace_handler:
+	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
+	mov	%rsp, %rcx
+
+	/* Save struct sgx_enclave_exception %rbx is about to be clobbered. */
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
+	/* Push struct sgx_enclave_exception as a param to the callback. */
+	push	%rax
+
+	/* Clear RFLAGS.DF per x86_64 ABI */
+	cld
+
+	/*
+	 * Load the callback pointer to %rax and lfence for LVI (load value
+	 * injection) protection before making the call.
+	 */
+	mov	SGX_ENCLAVE_RUN_USER_HANDLER(%rax), %rax
+	lfence
+	call	*%rax
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
+	.cfi_endproc
+
+_ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
+
+SYM_FUNC_END(__vdso_sgx_enter_enclave)
diff --git a/arch/x86/include/asm/enclu.h b/arch/x86/include/asm/enclu.h
new file mode 100644
index 000000000000..b1314e41a744
--- /dev/null
+++ b/arch/x86/include/asm/enclu.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_ENCLU_H
+#define _ASM_X86_ENCLU_H
+
+#define EENTER	0x02
+#define ERESUME	0x03
+#define EEXIT	0x04
+
+#endif /* _ASM_X86_ENCLU_H */
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index b6ba036a9b82..3dd2df44d569 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -74,4 +74,102 @@ struct sgx_enclave_provision {
 	__u64 attribute_fd;
 };
 
+struct sgx_enclave_run;
+
+/**
+ * typedef sgx_enclave_user_handler_t - Exit handler function accepted by
+ *					__vdso_sgx_enter_enclave()
+ * @run:	Pointer to the caller provided struct sgx_enclave_run
+ *
+ * The register parameters contain the snapshot of their values at enclave
+ * exit
+ *
+ * Return:
+ *  0 or negative to exit vDSO
+ *  positive to re-enter enclave (must be EENTER or ERESUME leaf)
+ */
+typedef int (*sgx_enclave_user_handler_t)(long rdi, long rsi, long rdx,
+					  long rsp, long r8, long r9,
+					  struct sgx_enclave_run *run);
+
+/**
+ * struct sgx_enclave_run - the execution context of __vdso_sgx_enter_enclave()
+ * @tcs:			TCS used to enter the enclave
+ * @user_handler:		User provided callback run on exception
+ * @user_data:			Data passed to the user handler
+ * @leaf:			The ENCLU leaf we were at (EENTER/ERESUME/EEXIT)
+ * @exception_vector:		The interrupt vector of the exception
+ * @exception_error_code:	The exception error code pulled out of the stack
+ * @exception_addr:		The address that triggered the exception
+ * @reserved			Reserved for possible future use
+ */
+struct sgx_enclave_run {
+	__u64 tcs;
+	__u64 user_handler;
+	__u64 user_data;
+	__u32 leaf;
+	__u16 exception_vector;
+	__u16 exception_error_code;
+	__u64 exception_addr;
+	__u8  reserved[24];
+};
+
+/**
+ * typedef vdso_sgx_enter_enclave_t - Prototype for __vdso_sgx_enter_enclave(),
+ *				      a vDSO function to enter an SGX enclave.
+ * @rdi:	Pass-through value for RDI
+ * @rsi:	Pass-through value for RSI
+ * @rdx:	Pass-through value for RDX
+ * @leaf:	ENCLU leaf, must be EENTER or ERESUME
+ * @r8:		Pass-through value for R8
+ * @r9:		Pass-through value for R9
+ * @run:	struct sgx_enclave_run, must be non-NULL
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
+ * loaded with @leaf, asynchronous exit pointer, and @run.tcs respectively.
+ *
+ * RBP and the stack are used to anchor __vdso_sgx_enter_enclave() to the
+ * pre-enclave state, e.g. to retrieve @run.exception and @run.user_handler
+ * after an enclave exit.  All other registers are available for use by the
+ * enclave and its runtime, e.g. an enclave can push additional data onto the
+ * stack (and modify RSP) to pass information to the optional user handler (see
+ * below).
+ *
+ * Most exceptions reported on ENCLU, including those that occur within the
+ * enclave, are fixed up and reported synchronously instead of being delivered
+ * via a standard signal. Debug Exceptions (#DB) and Breakpoints (#BP) are
+ * never fixed up and are always delivered via standard signals. On synchrously
+ * reported exceptions, -EFAULT is returned and details about the exception are
+ * recorded in @run.exception, the optional sgx_enclave_exception struct.
+ *
+ * If a user handler is provided, the handler will be invoked on synchronous
+ * exits from the enclave and for all synchronously reported exceptions. In
+ * latter case, @run.exception is filled prior to invoking the handler.
+ *
+ * The user handler's return value is interpreted as follows:
+ *  >0:		continue, restart __vdso_sgx_enter_enclave() with @ret as @leaf
+ *   0:		success, return @ret to the caller
+ *  <0:		error, return @ret to the caller
+ *
+ * The user handler may transfer control, e.g. via longjmp() or C++ exception,
+ * without returning to __vdso_sgx_enter_enclave().
+ *
+ * Return:
+ *  0 on success (ENCLU reached),
+ *  -EINVAL if ENCLU leaf is not allowed,
+ *  -errno for all other negative values returned by the userspace user handler
+ */
+typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
+					unsigned long rdx, unsigned int leaf,
+					unsigned long r8,  unsigned long r9,
+					struct sgx_enclave_run *run);
+
 #endif /* _UAPI_ASM_X86_SGX_H */
-- 
2.25.1

