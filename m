Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9AFC2D0EB
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 18:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 468082072E
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 18:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgC3SIO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 14:08:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:35626 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgC3SIO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 14:08:14 -0400
IronPort-SDR: BZbxigA1jhjRi5++O9y5ZhF+o4IWpAN4sQ9x/ILKZm9+HbMuyBEgHwnJ//FC7nFwFtF7om2as9
 GFbVE6WC9kxw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 11:08:14 -0700
IronPort-SDR: 47gGfytSwpMhYKcLUl4ZgicslbDjsQ7z+2HnpJposf6/IDcZlDm7Eki6aLk4lbBkfRXXozbsFW
 gWZgHWwTk/iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="283721705"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 30 Mar 2020 11:08:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 v2 2/5] x86/sgx: vdso: Define a typedef for __vdso_sgx_enter_enclave
Date:   Mon, 30 Mar 2020 11:08:08 -0700
Message-Id: <20200330180811.31381-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330180811.31381-1-sean.j.christopherson@intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Define a typedef for the __vdso_sgx_enter_enclave() prototype and move
the entire function comment from the assembly code to the uAPI header,
dropping the kernel doc hack along the way.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 62 ------------------------
 arch/x86/include/uapi/asm/sgx.h          | 61 +++++++++++++++++++++++
 2 files changed, 61 insertions(+), 62 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index c56064fb36bc..be7e467e1efb 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -15,68 +15,6 @@
 .code64
 .section .text, "ax"
 
-/**
- * __vdso_sgx_enter_enclave() - Enter an SGX enclave
- * @rdi:	Pass-through value for RDI
- * @rsi:	Pass-through value for RSI
- * @rdx:	Pass-through value for RDX
- * @leaf:	ENCLU leaf, must be EENTER or ERESUME
- * @r8:		Pass-through value for R8
- * @r9:		Pass-through value for R9
- * @tcs:	TCS, must be non-NULL
- * @e:		Optional struct sgx_enclave_exception instance
- * @handler:	Optional enclave exit handler
- *
- * **Important!**  __vdso_sgx_enter_enclave() does not ensure full compliance
- * with the x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.
- * Except for non-volatile general purpose registers, preserving/setting state
- * in accordance with the x86-64 ABI is the responsibility of the enclave and
- * its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
- * without careful consideration by both the enclave and its runtime.
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
-int __vdso_sgx_enter_enclave(unsigned long rdi, unsigned long rsi,
-			     unsigned long rdx, unsigned int leaf,
-			     unsigned long r8,  unsigned long r9, void *tcs,
-			     struct sgx_enclave_exception *e,
-			     sgx_enclave_exit_handler_t handler);
-#endif
 SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	/* Prolog */
 	.cfi_startproc
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index e196cfd44b70..8ca9ef7ea50a 100644
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
+ * **Important!**  __vdso_sgx_enter_enclave() does not ensure full compliance
+ * with the x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.
+ * Except for non-volatile general purpose registers, preserving/setting state
+ * in accordance with the x86-64 ABI is the responsibility of the enclave and
+ * its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
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
2.24.1

