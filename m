Return-Path: <SRS0=25jF=6C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83199C38A2B
	for <linux-sgx@archiver.kernel.org>; Sat, 18 Apr 2020 04:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E192223F
	for <linux-sgx@archiver.kernel.org>; Sat, 18 Apr 2020 04:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgDREgM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 18 Apr 2020 00:36:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:25561 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgDREgL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 18 Apr 2020 00:36:11 -0400
IronPort-SDR: BWGCN3ScX6U8Ir3A2I4tyFU3BN9YUSN1R9wZ/mXRduHb2LyT/3fvdqw5Na3Ta8FSzRxaNDQFcq
 9yPwZFRc+rBQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 21:36:10 -0700
IronPort-SDR: V8TqS/88gUU76Byj0DpVrMtMxY49AknoyGFtn+c0wwTCCS9G7jNKGFu1TWsZn6+1M026hAcBl8
 /kogwlWdsu+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,397,1580803200"; 
   d="scan'208";a="289459977"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 17 Apr 2020 21:36:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 v3 1/2] x86/sgx: vdso: Make __vdso_sgx_enter_enclave() callable from C code
Date:   Fri, 17 Apr 2020 21:36:08 -0700
Message-Id: <20200418043609.29406-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200418043609.29406-1-sean.j.christopherson@intel.com>
References: <20200418043609.29406-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Make __vdso_sgx_enter_enclave() callable from C by preserving %rbx
and taking @leaf in %rcx instead of %rax.  Being able to invoke the vDSO
from C reduces the overhead of runtimes that are tightly coupled with
their enclaves, e.g. that can rely on the enclave to save and restore
non-volatile registers, as the runtime doesn't need an assembly wrapper
to preserve non-volatile registers and/or shuffle stack arguments.

Note, both %rcx and %rbx are consumed by EENTER/ERESUME, i.e. consuming
them doesn't violate the primary tenet of __vdso_sgx_enter_enclave()
that "thou shalt not restrict how information is exchanged between an
enclave and its host process".

Define a typedef for the __vdso_sgx_enter_enclave() prototype and move
the entire function comment from the assembly code to the uAPI header,
dropping the kernel doc hack along the way.

Update the selftest to pass EENTER to the vDSO wrapper via %ecx instead
of hardcoding it to make the wrapper compatible with the new vDSO
calling convention.

Suggested-by: Nathaniel McCallum <npmccallum@redhat.com>
Cc: Cedric Xing <cedric.xing@intel.com>
Cc: Jethro Beekman <jethro@fortanix.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: linux-sgx@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 64 ++----------------------
 arch/x86/include/uapi/asm/sgx.h          | 61 ++++++++++++++++++++++
 tools/testing/selftests/sgx/call.S       |  1 -
 tools/testing/selftests/sgx/defines.h    |  1 +
 tools/testing/selftests/sgx/main.c       |  2 +-
 tools/testing/selftests/sgx/main.h       |  2 +-
 6 files changed, 68 insertions(+), 63 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 34cee2b0ef09..be7e467e1efb 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -15,66 +15,6 @@
 .code64
 .section .text, "ax"
 
-/**
- * __vdso_sgx_enter_enclave() - Enter an SGX enclave
- * @leaf:	ENCLU leaf, must be EENTER or ERESUME
- * @tcs:	TCS, must be non-NULL
- * @e:		Optional struct sgx_enclave_exception instance
- * @handler:	Optional enclave exit handler
- *
- * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
- * x86-64 ABI, i.e. cannot be called from standard C code.
- *
- * Input ABI:
- *  @leaf	%eax
- *  @tcs	8(%rsp)
- *  @e 		0x10(%rsp)
- *  @handler	0x18(%rsp)
- *
- * Output ABI:
- *  @ret	%eax
- *
- * All general purpose registers except RAX, RBX and RCX are passed as-is to
- * the enclave. RAX, RBX and RCX are consumed by EENTER and ERESUME and are
- * loaded with @leaf, asynchronous exit pointer, and @tcs respectively.
- *
- * RBP and the stack are used to anchor __vdso_sgx_enter_enclave() to the
- * pre-enclave state, e.g. to retrieve @e and @handler after an enclave exit.
- * All other registers are available for use by the enclave and its runtime,
- * e.g. an enclave can push additional data onto the stack (and modify RSP) to
- * pass information to the optional exit handler (see below).
- *
- * Most exceptions reported on ENCLU, including those that occur within the
- * enclave, are fixed up and reported synchronously instead of being delivered
- * via a standard signal. Debug Exceptions (#DB) and Breakpoints (#BP) are
- * never fixed up and are always delivered via standard signals. On synchrously
- * reported exceptions, -EFAULT is returned and details about the exception are
- * recorded in @e, the optional sgx_enclave_exception struct.
-
- * If an exit handler is provided, the handler will be invoked on synchronous
- * exits from the enclave and for all synchronously reported exceptions. In
- * latter case, @e is filled prior to invoking the handler.
- *
- * The exit handler's return value is interpreted as follows:
- *  >0:		continue, restart __vdso_sgx_enter_enclave() with @ret as @leaf
- *   0:		success, return @ret to the caller
- *  <0:		error, return @ret to the caller
- *
- * The exit handler may transfer control, e.g. via longjmp() or C++ exception,
- * without returning to __vdso_sgx_enter_enclave().
- *
- * Return:
- *  0 on success,
- *  -EINVAL if ENCLU leaf is not allowed,
- *  -EFAULT if an exception occurs on ENCLU or within the enclave
- *  -errno for all other negative values returned by the userspace exit handler
- */
-#ifdef SGX_KERNEL_DOC
-/* C-style function prototype to coerce kernel-doc into parsing the comment. */
-int __vdso_sgx_enter_enclave(int leaf, void *tcs,
-			     struct sgx_enclave_exception *e,
-			     sgx_enclave_exit_handler_t handler);
-#endif
 SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	/* Prolog */
 	.cfi_startproc
@@ -83,7 +23,10 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	.cfi_rel_offset		%rbp, 0
 	mov	%rsp, %rbp
 	.cfi_def_cfa_register	%rbp
+	push	%rbx
+	.cfi_rel_offset		%rbx, -8
 
+	mov	%ecx, %eax
 .Lenter_enclave:
 	/* EENTER <= leaf <= ERESUME */
 	cmp	$EENTER, %eax
@@ -109,6 +52,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	jne	.Linvoke_userspace_handler
 
 .Lout:
+	pop	%rbx
 	leave
 	.cfi_def_cfa		%rsp, 8
 	ret
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index e196cfd44b70..3760e5d5dc0c 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -111,4 +111,65 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
 					  void *tcs, int ret,
 					  struct sgx_enclave_exception *e);
 
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
diff --git a/tools/testing/selftests/sgx/call.S b/tools/testing/selftests/sgx/call.S
index c37f55a607c8..77131e83db42 100644
--- a/tools/testing/selftests/sgx/call.S
+++ b/tools/testing/selftests/sgx/call.S
@@ -37,7 +37,6 @@ sgx_call_vdso:
 	.cfi_adjust_cfa_offset	8
 	push	0x48(%rsp)
 	.cfi_adjust_cfa_offset	8
-	mov	$2, %eax
 	call	*eenter(%rip)
 	add	$0x20, %rsp
 	.cfi_adjust_cfa_offset	-0x20
diff --git a/tools/testing/selftests/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
index 1802cace7527..be8969922804 100644
--- a/tools/testing/selftests/sgx/defines.h
+++ b/tools/testing/selftests/sgx/defines.h
@@ -15,6 +15,7 @@
 #define __packed __attribute__((packed))
 
 #include "../../../../arch/x86/kernel/cpu/sgx/arch.h"
+#include "../../../../arch/x86/include/asm/enclu.h"
 #include "../../../../arch/x86/include/uapi/asm/sgx.h"
 
 #endif /* DEFINES_H */
diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 9238cce47f77..f6bb40f22884 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -171,7 +171,7 @@ int main(int argc, char *argv[], char *envp[])
 
 	eenter = addr + eenter_sym->st_value;
 
-	sgx_call_vdso((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+	sgx_call_vdso((void *)&MAGIC, &result, 0, EENTER, NULL, NULL,
 		      (void *)encl.encl_base, &exception, NULL);
 	if (result != MAGIC)
 		goto err;
diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/sgx/main.h
index 6e1ae292bd25..999422cc7343 100644
--- a/tools/testing/selftests/sgx/main.h
+++ b/tools/testing/selftests/sgx/main.h
@@ -32,7 +32,7 @@ bool encl_load(const char *path, struct encl *encl);
 bool encl_measure(struct encl *encl);
 bool encl_build(struct encl *encl);
 
-int sgx_call_vdso(void *rdi, void *rsi, long rdx, void *rcx, void *r8, void *r9,
+int sgx_call_vdso(void *rdi, void *rsi, long rdx, u32 leaf, void *r8, void *r9,
 		  void *tcs, struct sgx_enclave_exception *ei, void *cb);
 
 #endif /* MAIN_H */
-- 
2.26.0

