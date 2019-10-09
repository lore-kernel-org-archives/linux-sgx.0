Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EF9ECE58C
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 19:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6729D218AC
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 19:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbfJITKF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 15:10:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:54691 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728804AbfJITKF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 15:10:05 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 12:10:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,277,1566889200"; 
   d="scan'208";a="192966294"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 09 Oct 2019 12:10:03 -0700
Date:   Wed, 9 Oct 2019 12:10:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 16/16] x86/vdso: sgx: Rework
 __vdso_sgx_enter_enclave() to prefer "no callback"
Message-ID: <20191009191003.GD19952@linux.intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
 <20191008044613.12350-17-sean.j.christopherson@intel.com>
 <15c03e7e-cd98-5ea2-82a1-a11bec4abe2a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15c03e7e-cd98-5ea2-82a1-a11bec4abe2a@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 09, 2019 at 11:00:55AM -0700, Xing, Cedric wrote:
> On 10/7/2019 9:46 PM, Sean Christopherson wrote:
> >Rework __vdso_sgx_enter_enclave() to prioritize the flow where userspace
> >is not providing a callback, which is the preferred method of operation.
> 
> Processors have branch predictors so your "prioritizing" may not get what
> your want.
> 
> But if you still insist, a simple ht/hnt prefixing the original branch
> instruction would have sufficed. Rearrangement of code blocks is indeed
> unnecessary.

Tying into the other thread, it's not a matter of absolute necessity, it's
a matter of us providing the best code possible.

> A caveat though, for any given process, whether it supplies a callback or
> not is usually hard-coded. So either it always takes the callback path, or
> it always takes the other. And the branch predictor will do well in both
> cases. It's usually unwise to apply ht/hnt prefixes.

Readability is the primary concern, performance is secondary concern.  For
a random joe user, this:

   0x0000000000000a20 <+0>:	push   %rbp
   0x0000000000000a21 <+1>:	mov    %rsp,%rbp
   0x0000000000000a24 <+4>:	cmp    $0x2,%eax
   0x0000000000000a27 <+7>:	jb     0xa46 <__vdso_sgx_enter_enclave+38>
   0x0000000000000a29 <+9>:	cmp    $0x3,%eax
   0x0000000000000a2c <+12>:	ja     0xa46 <__vdso_sgx_enter_enclave+38>
   0x0000000000000a2e <+14>:	mov    0x10(%rbp),%rbx
   0x0000000000000a32 <+18>:	lea    0x0(%rip),%rcx        # 0xa39 <__vdso_sgx_enter_enclave+25>
   0x0000000000000a39 <+25>:	enclu  
   0x0000000000000a3c <+28>:	xor    %eax,%eax
   0x0000000000000a3e <+30>:	cmpl   $0x0,0x20(%rbp)
   0x0000000000000a42 <+34>:	jne    0xa6b <__vdso_sgx_enter_enclave+75>
   0x0000000000000a44 <+36>:	leaveq 
   0x0000000000000a45 <+37>:	retq   

is easier to follow for the happy path than this:

   0x0000000000000a20 <+0>:	push   %rbp
   0x0000000000000a21 <+1>:	mov    %rsp,%rbp
   0x0000000000000a24 <+4>:	cmp    $0x2,%eax
   0x0000000000000a27 <+7>:	jb     0xa8e <__vdso_sgx_enter_enclave+110>
   0x0000000000000a29 <+9>:	cmp    $0x3,%eax
   0x0000000000000a2c <+12>:	ja     0xa8e <__vdso_sgx_enter_enclave+110>
   0x0000000000000a2e <+14>:	mov    0x10(%rbp),%rbx
   0x0000000000000a32 <+18>:	lea    0x0(%rip),%rcx        # 0xa39 <__vdso_sgx_enter_enclave+25>
   0x0000000000000a39 <+25>:	enclu  
   0x0000000000000a3c <+28>:	xor    %eax,%eax
   0x0000000000000a3e <+30>:	mov    %eax,%ecx
   0x0000000000000a40 <+32>:	mov    0x20(%rbp),%rax
   0x0000000000000a44 <+36>:	test   %rax,%rax
   0x0000000000000a47 <+39>:	je     0xa98 <__vdso_sgx_enter_enclave+120>
   0x0000000000000a49 <+41>:	mov    %rsp,%rbx
   0x0000000000000a4c <+44>:	and    $0xfffffffffffffff0,%rsp
   0x0000000000000a50 <+48>:	cld    
   0x0000000000000a51 <+49>:	pushq  0x18(%rbp)
   0x0000000000000a54 <+52>:	push   %rbx
   0x0000000000000a55 <+53>:	pushq  0x10(%rbp)
   0x0000000000000a58 <+56>:	callq  0xa62 <__vdso_sgx_enter_enclave+66>
   0x0000000000000a5d <+61>:	mov    %rbx,%rsp
   0x0000000000000a60 <+64>:	jmp    0xa24 <__vdso_sgx_enter_enclave+4>
   0x0000000000000a62 <+66>:	callq  0xa6e <__vdso_sgx_enter_enclave+78>
   0x0000000000000a67 <+71>:	pause  
   0x0000000000000a69 <+73>:	lfence 
   0x0000000000000a6c <+76>:	jmp    0xa67 <__vdso_sgx_enter_enclave+71>
   0x0000000000000a6e <+78>:	mov    %rax,(%rsp)
   0x0000000000000a72 <+82>:	retq   
   0x0000000000000a73 <+83>:	mov    0x18(%rbp),%rcx
   0x0000000000000a77 <+87>:	jrcxz  0xa87 <__vdso_sgx_enter_enclave+103>
   0x0000000000000a79 <+89>:	mov    %eax,(%rcx)
   0x0000000000000a7b <+91>:	mov    %di,0x4(%rcx)
   0x0000000000000a7f <+95>:	mov    %si,0x6(%rcx)
   0x0000000000000a83 <+99>:	mov    %rdx,0x8(%rcx)
   0x0000000000000a87 <+103>:	mov    $0xfffffff2,%eax
   0x0000000000000a8c <+108>:	jmp    0xa3e <__vdso_sgx_enter_enclave+30>
   0x0000000000000a8e <+110>:	cmp    $0x0,%eax
   0x0000000000000a91 <+113>:	jle    0xa98 <__vdso_sgx_enter_enclave+120>
   0x0000000000000a93 <+115>:	mov    $0xffffffea,%eax
   0x0000000000000a98 <+120>:	leaveq 
   0x0000000000000a99 <+121>:	retq  

and much easier to follow than the version where the exception struct is
filled in on a synchronous EEXIT:

   0x0000000000000a20 <+0>:	push   %rbp
   0x0000000000000a21 <+1>:	mov    %rsp,%rbp
   0x0000000000000a24 <+4>:	cmp    $0x2,%eax
   0x0000000000000a27 <+7>:	jb     0xa90 <__vdso_sgx_enter_enclave+112>
   0x0000000000000a29 <+9>:	cmp    $0x3,%eax
   0x0000000000000a2c <+12>:	ja     0xa90 <__vdso_sgx_enter_enclave+112>
   0x0000000000000a2e <+14>:	mov    0x10(%rbp),%rbx
   0x0000000000000a32 <+18>:	lea    0x0(%rip),%rcx        # 0xa39 <__vdso_sgx_enter_enclave+25>
   0x0000000000000a39 <+25>:	enclu  
   0x0000000000000a3c <+28>:	xor    %ebx,%ebx
   0x0000000000000a3e <+30>:	mov    0x18(%rbp),%rcx
   0x0000000000000a42 <+34>:	jrcxz  0xa54 <__vdso_sgx_enter_enclave+52>
   0x0000000000000a44 <+36>:	mov    %eax,(%rcx)
   0x0000000000000a46 <+38>:	jae    0xa54 <__vdso_sgx_enter_enclave+52>
   0x0000000000000a48 <+40>:	mov    %di,0x4(%rcx)
   0x0000000000000a4c <+44>:	mov    %si,0x6(%rcx)
   0x0000000000000a50 <+48>:	mov    %rdx,0x8(%rcx)
   0x0000000000000a54 <+52>:	mov    0x20(%rbp),%rax
   0x0000000000000a58 <+56>:	test   %rax,%rax
   0x0000000000000a5b <+59>:	cmove  %rbx,%rax
   0x0000000000000a5f <+63>:	je     0xa9a <__vdso_sgx_enter_enclave+122>

   ...

   0x0000000000000a9a <+122>:	leaveq 
   0x0000000000000a9b <+123>:	retq   


> >Using a callback requires a retpoline, and the only known motivation for
> >employing a callback is to allow the enclave to muck with the stack of
> >the untrusted runtime.
> >
> >Opportunistically replace the majority of the local labels with local
> >symbol names to improve the readability of the code.
> >
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  arch/x86/entry/vdso/vsgx_enter_enclave.S | 120 ++++++++++++++---------
> >  1 file changed, 71 insertions(+), 49 deletions(-)
> >
> >diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >index de54e47c83f4..fc5622dcd2fa 100644
> >--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >@@ -85,75 +85,97 @@ ENTRY(__vdso_sgx_enter_enclave)
> >  	mov	%rsp, %rbp
> >  	.cfi_def_cfa_register	%rbp
> >-1:	/* EENTER <= leaf <= ERESUME */
> >+.Lenter_enclave:
> >+	/* EENTER <= leaf <= ERESUME */
> >  	cmp	$0x2, %eax
> >-	jb	6f
> >+	jb	.Linvalid_leaf
> >  	cmp	$0x3, %eax
> >-	ja	6f
> >+	ja	.Linvalid_leaf
> >  	/* Load TCS and AEP */
> >  	mov	0x10(%rbp), %rbx
> >-	lea	2f(%rip), %rcx
> >+	lea	.Lasync_exit_pointer(%rip), %rcx
> >  	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> >-2:	enclu
> >+.Lasync_exit_pointer:
> >+.Lenclu_eenter_eresume:
> >+	enclu
> >-	/* EEXIT path */
> >+	/* EEXIT jumps here unless the enclave is doing something fancy. */
> >  	xor	%eax, %eax
> >-3:	mov	%eax, %ecx
> >-
> >-	/* Call the exit handler if supplied */
> >-	mov	0x20(%rbp), %rax
> >-	test	%rax, %rax
> >-	jz	7f
> 
> >-	/* Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
> >-	 * restored after the exit handler returns. */
> >+
> >+	/* Invoke userspace's exit handler if one was provided. */
> >+.Lhandle_exit:
> >+	cmp	$0, 0x20(%rbp)
> >+	jne	.Linvoke_userspace_handler
> >+
> >+.Lout:
> >+	leave
> >+	.cfi_def_cfa		%rsp, 8
> >+	ret
> >+
> >+.Linvalid_leaf:
> 
> Please set frame pointer back to %rbp here, or stack unwinding will fail.

Sorry, coffee isn't doing it's job, what's getting crushed, and where?

> >+	mov	$(-EINVAL), %eax
> >+	jmp	.Lout
> >+
> >+.Lhandle_exception:
> >+	mov	0x18(%rbp), %rcx
> >+	test    %rcx, %rcx
> >+	je	.Lskip_exception_info
> 
> A single "jrcxz .Lskip_exception_info" is equivalent to the above 2
> instructions combined.

Both implementations take a single uop on CPUs that support SGX.  IMO,
using the simpler and more common instructions is more universally
readable.

> >+
> >+	/* Fill optional exception info. */
> >+	mov	%eax, EX_LEAF(%rcx)
> >+	mov	%di,  EX_TRAPNR(%rcx)
> >+	mov	%si,  EX_ERROR_CODE(%rcx)
> >+	mov	%rdx, EX_ADDRESS(%rcx)
> >+.Lskip_exception_info:
> >+	mov	$(-EFAULT), %eax
> >+	jmp	.Lhandle_exit
> >+
> >+.Linvoke_userspace_handler:
> >+	/*
> >+	 * Align stack per x86_64 ABI. Save the original %rsp in %rbx to be
> >+	 * restored after the callback returns.
> >+	 */
> >  	mov	%rsp, %rbx
> >  	and	$-0x10, %rsp
> >-	/* Clear RFLAGS.DF per x86_64 ABI */
> >-	cld
> >-	/* Parameters for the exit handler */
> >+
> >+	/* Push @e, u_rsp and @tcs as parameters to the callback. */
> >  	push	0x18(%rbp)
> >  	push	%rbx
> >  	push	0x10(%rbp)
> >-	/* Call *%rax via retpoline */
> >-	call	40f
> >-	/* Restore %rsp to its original value left off by the enclave from last
> >-	 * exit */
> >+
> >+	/* Pass the "return" value to the callback via %rcx. */
> >+	mov	%eax, %ecx
> 
> @e (ex_info) is almost always needed by every callback as it also serves as
> the "context pointer". The return value on the other hand is insignificant
> because it could be deduced from @e->EX_LEAF anyway. So I'd retain %rcx and
> push %rax to the stack instead, given the purpose of this patch is to
> squeeze out a bit performance.

Please take this up in patch 02/16, which actually introduced this change.
> 
> >+
> >+	/* Clear RFLAGS.DF per x86_64 ABI */
> >+	cld
> >+
> >+	/* Load the callback pointer to %rax and invoke it via retpoline. */
> >+	mov	0x20(%rbp), %rax
> 
> Per X86_64 ABI, %rsp shall be 16 bytes aligned before "call". But %rsp here
> doesn't look aligned properly.

Argh, I probably botched it back in patch 02/16 too.  I'll see if I can
add a check to verify %rsp alignment in the selftest, verifying via code
inspection is bound to be error prone.

> >+	call	.Lretpoline
