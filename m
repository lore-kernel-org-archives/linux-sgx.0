Return-Path: <SRS0=YHr7=A3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39431C433E3
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1586A20787
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgGPN6b (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:58:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:44442 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbgGPN6b (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Jul 2020 09:58:31 -0400
IronPort-SDR: SbwXdayH7KGCuLdpZRF+Xv+7bXd0WenIrCPVWWh/rUF8cXvvM4q9ucoBhAbqVZupUuOLaTjl/g
 1jCG58WIep6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="128946235"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="128946235"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 06:58:26 -0700
IronPort-SDR: aw4Qp1t26oEuapbs/VYpSRn6ZpFdSVJ8UyNph8fQmu6osGzCrPoPEXdhD4s+jewrEktrHfmeEq
 7f0bdr6Ktoog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="325150831"
Received: from lettner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.212])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2020 06:58:15 -0700
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
Subject: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX enclave call
Date:   Thu, 16 Jul 2020 16:53:00 +0300
Message-Id: <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 131 +++++++++++++++++++++++
 arch/x86/include/asm/enclu.h             |   8 ++
 arch/x86/include/uapi/asm/sgx.h          |  98 +++++++++++++++++
 5 files changed, 240 insertions(+)
 create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
 create mode 100644 arch/x86/include/asm/enclu.h

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index ebe82b7aecda..f71ad5ebd0c4 100644
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
index 000000000000..be7e467e1efb
--- /dev/null
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -0,0 +1,131 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/linkage.h>
+#include <asm/export.h>
+#include <asm/errno.h>
+#include <asm/enclu.h>
+
+#include "extable.h"
+
+#define EX_LEAF		0*8
+#define EX_TRAPNR	0*8+4
+#define EX_ERROR_CODE	0*8+6
+#define EX_ADDRESS	1*8
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
+	jb	.Linvalid_leaf
+	cmp	$ERESUME, %eax
+	ja	.Linvalid_leaf
+
+	/* Load TCS and AEP */
+	mov	0x10(%rbp), %rbx
+	lea	.Lasync_exit_pointer(%rip), %rcx
+
+	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
+.Lasync_exit_pointer:
+.Lenclu_eenter_eresume:
+	enclu
+
+	/* EEXIT jumps here unless the enclave is doing something fancy. */
+	xor	%eax, %eax
+
+	/* Invoke userspace's exit handler if one was provided. */
+.Lhandle_exit:
+	cmp	$0, 0x20(%rbp)
+	jne	.Linvoke_userspace_handler
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
+.Linvalid_leaf:
+	mov	$(-EINVAL), %eax
+	jmp	.Lout
+
+.Lhandle_exception:
+	mov	0x18(%rbp), %rcx
+	test    %rcx, %rcx
+	je	.Lskip_exception_info
+
+	/* Fill optional exception info. */
+	mov	%eax, EX_LEAF(%rcx)
+	mov	%di,  EX_TRAPNR(%rcx)
+	mov	%si,  EX_ERROR_CODE(%rcx)
+	mov	%rdx, EX_ADDRESS(%rcx)
+.Lskip_exception_info:
+	mov	$(-EFAULT), %eax
+	jmp	.Lhandle_exit
+
+.Linvoke_userspace_handler:
+	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
+	mov	%rsp, %rcx
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
+	/* Push @e, the "return" value and @tcs as params to the callback. */
+	push	0x18(%rbp)
+	push	%rax
+	push	0x10(%rbp)
+
+	/* Clear RFLAGS.DF per x86_64 ABI */
+	cld
+
+	/* Load the callback pointer to %rax and invoke it via retpoline. */
+	mov	0x20(%rbp), %rax
+	call	.Lretpoline
+
+	/* Undo the post-exit %rsp adjustment. */
+	lea	0x20(%rsp, %rbx), %rsp
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
index 57d0d30c79b3..3760e5d5dc0c 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -74,4 +74,102 @@ struct sgx_enclave_set_attribute {
 	__u64 attribute_fd;
 };
 
+/**
+ * struct sgx_enclave_exception - structure to report exceptions encountered in
+ *				  __vdso_sgx_enter_enclave()
+ *
+ * @leaf:	ENCLU leaf from \%eax at time of exception
+ * @trapnr:	exception trap number, a.k.a. fault vector
+ * @error_code:	exception error code
+ * @address:	exception address, e.g. CR2 on a #PF
+ * @reserved:	reserved for future use
+ */
+struct sgx_enclave_exception {
+	__u32 leaf;
+	__u16 trapnr;
+	__u16 error_code;
+	__u64 address;
+	__u64 reserved[2];
+};
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
+ * @tcs:	Thread Control Structure used to enter enclave
+ * @ret:	0 on success (EEXIT), -EFAULT on an exception
+ * @e:		Pointer to struct sgx_enclave_exception (as provided by caller)
+ */
+typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
+					  long ursp, long r8, long r9,
+					  void *tcs, int ret,
+					  struct sgx_enclave_exception *e);
+
+/**
+ * __vdso_sgx_enter_enclave() - Enter an SGX enclave
+ * @rdi:	Pass-through value for RDI
+ * @rsi:	Pass-through value for RSI
+ * @rdx:	Pass-through value for RDX
+ * @leaf:	ENCLU leaf, must be EENTER or ERESUME
+ * @r8:		Pass-through value for R8
+ * @r9:		Pass-through value for R9
+ * @tcs:	TCS, must be non-NULL
+ * @e:		Optional struct sgx_enclave_exception instance
+ * @handler:	Optional enclave exit handler
+ *
+ * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance with the
+ * x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.  Except for
+ * non-volatile general purpose registers, preserving/setting state in
+ * accordance with the x86-64 ABI is the responsibility of the enclave and its
+ * runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
+ * without careful consideration by both the enclave and its runtime.
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
+
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
+ *  0 on success,
+ *  -EINVAL if ENCLU leaf is not allowed,
+ *  -EFAULT if an exception occurs on ENCLU or within the enclave
+ *  -errno for all other negative values returned by the userspace exit handler
+ */
+typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
+					unsigned long rdx, unsigned int leaf,
+					unsigned long r8,  unsigned long r9,
+					void *tcs,
+					struct sgx_enclave_exception *e,
+					sgx_enclave_exit_handler_t handler);
+
 #endif /* _UAPI_ASM_X86_SGX_H */
-- 
2.25.1

