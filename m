Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A9CC4360C
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 816BC20679
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfJHEqR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:8175 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfJHEqQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566506"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 06/16] x86/vdso: sgx: Rewrite __vdso_sgx_enter_enclave() function comment
Date:   Mon,  7 Oct 2019 21:46:03 -0700
Message-Id: <20191008044613.12350-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Rewrite the function comment for __vdso_sgx_enter_enclave() to eliminate
dependencies on markup (which currently doesn't work correctly anyways),
bring the comments up-to-date, and use phrasing and mood that is more
consistent with the rest of the kernel.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 74 +++++++++++++++---------
 1 file changed, 46 insertions(+), 28 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 4dfb943172ed..de54e47c83f4 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -18,39 +18,57 @@
  * __vdso_sgx_enter_enclave() - Enter an SGX enclave
  * @leaf:	ENCLU leaf, must be EENTER or ERESUME
  * @tcs:	TCS, must be non-NULL
- * @ex_info:	Optional struct sgx_enclave_exception instance
- * @callback:	Optional callback function to be called on enclave exit or
- *		exception
+ * @e:		Optional struct sgx_enclave_exception instance
+ * @handler:	Optional enclave exit handler
  *
  * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
- * x86-64 ABI, i.e. cannot be called from standard C code. As noted above,
- * input parameters must be passed via ``%eax``, ``8(%rsp)``, ``0x10(%rsp)`` and
- * ``0x18(%rsp)``, with the return value passed via ``%eax``. All other
- * registers will be passed through to the enclave as is. All registers except
- * ``%rbp`` must be treated as volatile from the caller's perspective, including
- * but not limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc... Conversely, the
- * enclave being run **must** preserve the untrusted ``%rbp``.
+ * x86-64 ABI, i.e. cannot be called from standard C code.
  *
- * ``callback`` has the following signature:
- * int callback(long rdi, long rsi, long rdx,
- *		struct sgx_enclave_exinfo *exinfo, long r8, long r9,
- *		void *tcs, long ursp);
- * ``callback`` **shall** follow x86_64 ABI. All GPRs **except** ``%rax``,
- * ``%rbx`` and ``rcx`` are passed through to ``callback``. ``%rdi``, ``%rsi``,
- * ``%rdx``, ``%r8``, ``%r9``, along with the value of ``%rsp`` when the enclave
- * exited/excepted, can be accessed directly as input parameters, while other
- * GPRs can be accessed in assembly if needed.  A positive value returned from
- * ``callback`` will be treated as an ENCLU leaf (e.g. EENTER/ERESUME) to
- * reenter the enclave (without popping the extra data pushed by the enclave off
- * the stack), while 0 (zero) or a negative return value will be passed back to
- * the caller of __vdso_sgx_enter_enclave(). It is also safe to leave
- * ``callback`` via ``longjmp()`` or by throwing a C++ exception.
+ * Input ABI:
+ *  @leaf	%eax
+ *  @tcs	8(%rsp)
+ *  @e 		0x10(%rsp)
+ *  @handler	0x18(%rsp)
+ *
+ * Output ABI:
+ *  @ret	%eax
+ *
+ * All general purpose registers except RAX, RBX and RCX are passed as-is to
+ * the enclave. RAX, RBX and RCX are consumed by EENTER and ERESUME and are
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
+ * The userspace exit handler is responsible for unwinding the stack, e.g. to
+ * pop @e, u_rsp and @tcs, prior to returning to __vdso_sgx_enter_enclave().
+ * The exit handler may also transfer control, e.g. via longjmp() or a C++
+ * exception, without returning to __vdso_sgx_enter_enclave().
  *
  * Return:
- *    0 on success,
- *    -EINVAL if ENCLU leaf is not allowed,
- *    -EFAULT if ENCL or the enclave faults or non-positive value is returned
- *     from the callback.
+ *  0 on success,
+ *  -EINVAL if ENCLU leaf is not allowed,
+ *  -EFAULT if an exception occurs on ENCLU or within the enclave
+ *  -errno for all other negative values returned by the userspace exit handler
  */
 #ifdef SGX_KERNEL_DOC
 /* C-style function prototype to coerce kernel-doc into parsing the comment. */
-- 
2.22.0

