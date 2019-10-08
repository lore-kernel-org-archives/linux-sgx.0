Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA5AC4360C
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9528F20679
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbfJHEqT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:8177 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfJHEqT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566537"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 16/16] x86/vdso: sgx: Rework __vdso_sgx_enter_enclave() to prefer "no callback"
Date:   Mon,  7 Oct 2019 21:46:13 -0700
Message-Id: <20191008044613.12350-17-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Rework __vdso_sgx_enter_enclave() to prioritize the flow where userspace
is not providing a callback, which is the preferred method of operation.
Using a callback requires a retpoline, and the only known motivation for
employing a callback is to allow the enclave to muck with the stack of
the untrusted runtime.

Opportunistically replace the majority of the local labels with local
symbol names to improve the readability of the code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 120 ++++++++++++++---------
 1 file changed, 71 insertions(+), 49 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index de54e47c83f4..fc5622dcd2fa 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -85,75 +85,97 @@ ENTRY(__vdso_sgx_enter_enclave)
 	mov	%rsp, %rbp
 	.cfi_def_cfa_register	%rbp
 
-1:	/* EENTER <= leaf <= ERESUME */
+.Lenter_enclave:
+	/* EENTER <= leaf <= ERESUME */
 	cmp	$0x2, %eax
-	jb	6f
+	jb	.Linvalid_leaf
 	cmp	$0x3, %eax
-	ja	6f
+	ja	.Linvalid_leaf
 
 	/* Load TCS and AEP */
 	mov	0x10(%rbp), %rbx
-	lea	2f(%rip), %rcx
+	lea	.Lasync_exit_pointer(%rip), %rcx
 
 	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
-2:	enclu
+.Lasync_exit_pointer:
+.Lenclu_eenter_eresume:
+	enclu
 
-	/* EEXIT path */
+	/* EEXIT jumps here unless the enclave is doing something fancy. */
 	xor	%eax, %eax
-3:	mov	%eax, %ecx
-
-	/* Call the exit handler if supplied */
-	mov	0x20(%rbp), %rax
-	test	%rax, %rax
-	jz	7f
-	/* Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
-	 * restored after the exit handler returns. */
+
+	/* Invoke userspace's exit handler if one was provided. */
+.Lhandle_exit:
+	cmp	$0, 0x20(%rbp)
+	jne	.Linvoke_userspace_handler
+
+.Lout:
+	leave
+	.cfi_def_cfa		%rsp, 8
+	ret
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
+	/*
+	 * Align stack per x86_64 ABI. Save the original %rsp in %rbx to be
+	 * restored after the callback returns.
+	 */
 	mov	%rsp, %rbx
 	and	$-0x10, %rsp
-	/* Clear RFLAGS.DF per x86_64 ABI */
-	cld
-	/* Parameters for the exit handler */
+
+	/* Push @e, u_rsp and @tcs as parameters to the callback. */
 	push	0x18(%rbp)
 	push	%rbx
 	push	0x10(%rbp)
-	/* Call *%rax via retpoline */
-	call	40f
-	/* Restore %rsp to its original value left off by the enclave from last
-	 * exit */
+
+	/* Pass the "return" value to the callback via %rcx. */
+	mov	%eax, %ecx
+
+	/* Clear RFLAGS.DF per x86_64 ABI */
+	cld
+
+	/* Load the callback pointer to %rax and invoke it via retpoline. */
+	mov	0x20(%rbp), %rax
+	call	.Lretpoline
+
+	/* Restore %rsp to its post-exit value. */
 	mov	%rbx, %rsp
-	/* Positive return value from the exit handler will be interpreted as
-	 * an ENCLU leaf, while a non-positive value will be interpreted as the
-	 * return value to be passed back to the caller. */
-	jmp	1b
-40:	/* retpoline */
-	call	42f
-41:	pause
-	lfence
-	jmp	41b
-42:	mov	%rax, (%rsp)
-	ret
 
-5:	/* Exception path */
-	mov	0x18(%rbp), %rcx
-	jrcxz	52f
-	mov	%eax, EX_LEAF(%rcx)
-	mov	%di,  EX_TRAPNR(%rcx)
-	mov	%si,  EX_ERROR_CODE(%rcx)
-	mov	%rdx, EX_ADDRESS(%rcx)
-52:	mov	$-EFAULT, %eax
-	jmp	3b
-
-6:	/* Unsupported ENCLU leaf */
+	/*
+	 * If the return from callback is zero or negative, return immediately,
+	 * else re-execute ENCLU with the postive return value interpreted as
+	 * the requested ENCLU leaf.
+	 */
 	cmp	$0, %eax
-	jle	7f
-	mov	$-EINVAL, %eax
+	jle	.Lout
+	jmp	.Lenter_enclave
 
-7:	/* Epilog */
-	leave
-	.cfi_def_cfa		%rsp, 8
+.Lretpoline:
+	call	2f
+1:	pause
+	lfence
+	jmp	1b
+2:	mov	%rax, (%rsp)
 	ret
 	.cfi_endproc
 
-_ASM_VDSO_EXTABLE_HANDLE(2b, 5b)
+_ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
 
 ENDPROC(__vdso_sgx_enter_enclave)
-- 
2.22.0

