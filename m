Return-Path: <SRS0=QZjA=S2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB03C10F11
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Apr 2019 19:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 037BE20835
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Apr 2019 19:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfDXTEr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:04:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:52492 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfDXTEr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Apr 2019 15:04:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Apr 2019 12:04:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,390,1549958400"; 
   d="scan'208";a="318655424"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga005.jf.intel.com with ESMTP; 24 Apr 2019 12:04:46 -0700
Date:   Wed, 24 Apr 2019 12:04:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, kai.svahn@intel.com, kai.huang@intel.com,
        jarkko.sakkinen@linux.intel.com
Subject: Re: [RFC PATCH v2 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave()
 to allow parameter passing on untrusted stack
Message-ID: <20190424190446.GE18442@linux.intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
 <20190424062623.4345-3-cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424062623.4345-3-cedric.xing@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 23, 2019 at 11:26:22PM -0700, Cedric Xing wrote:
> The previous __vdso_sgx_enter_enclave() requires enclaves to preserve %rsp,
> which prohibits enclaves from allocating and passing parameters for
> untrusted function calls (aka. o-calls).
> 
> This patch addresses the problem above by introducing a new ABI that preserves
> %rbp instead of %rsp. Then __vdso_sgx_enter_enclave() can anchor its frame
> using %rbp so that enclaves are allowed to allocate space on the untrusted
> stack by decrementing %rsp. Please note that the stack space allocated in such
> way will be part of __vdso_sgx_enter_enclave()'s frame so will be freed after
> __vdso_sgx_enter_enclave() returns. Therefore, __vdso_sgx_enter_enclave() has
> been revised to take a callback function as an optional parameter, which if
> supplied, will be invoked upon enclave exits (both AEX (Asynchronous Enclave
> eXit) and normal exits), with the value of %rsp left off by the enclave as a
> parameter to the callback.

AIUI, you and Andy had an off-list discussion regarding rewriting
__vdso_sgx_enter_enclave() vs. providing a second vDSO function.  Can you
please summarize the discussion so that it's clear why you're pursuing a
single function?

In the end I probably agree that's it's desirable to have a single ABI and
vDSO function since the cost is basically that the non-callback case needs
to pass params via the stack instead of registers, but I do miss the
simplicity of separate implementations.

> Here's the summary of API/ABI changes in this patch. More details could be
> found in arch/x86/entry/vdso/vsgx_enter_enclave.S.
> * 'struct sgx_enclave_exception' is renamed to 'struct sgx_enclave_exinfo'
>   because it is filled upon both AEX (i.e. exceptions) and normal enclave
>   exits.
> * __vdso_sgx_enter_enclave() anchors its frame using %rbp (instead of %rsp in
>   the previous implementation).
> * __vdso_sgx_enter_enclave() takes one more parameter - a callback function to
>   be invoked upon enclave exits. This callback is optional, and if not
>   supplied, will cause __vdso_sgx_enter_enclave() to return upon enclave exits
>   (same behavior as previous implementation).
> * The callback function is given as a parameter the value of %rsp at enclave
>   exit to address data "pushed" by the enclave. A positive value returned by
>   the callback will be treated as an ENCLU leaf for re-entering the enclave,
>   while a zero or negative value will be passed through as the return
>   value of __vdso_sgx_enter_enclave() to its caller. It's also safe to
>   leave callback by longjmp() or by throwing a C++ exception.
> 
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 175 ++++++++++++++++-------
>  arch/x86/include/uapi/asm/sgx.h          |  14 +-
>  2 files changed, 128 insertions(+), 61 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index fe0bf6671d6d..debecb0d785c 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -19,83 +19,150 @@
>   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
>   *
>   * @leaf:	**IN \%eax** - ENCLU leaf, must be EENTER or ERESUME
> - * @tcs:	**IN \%rbx** - TCS, must be non-NULL
> - * @ex_info:	**IN \%rcx** - Optional 'struct sgx_enclave_exception' pointer
> + * @tcs:	**IN 0x08(\%rsp)** - TCS, must be non-NULL
> + * @ex_info:	**IN 0x10(\%rsp)** - Optional 'struct sgx_enclave_exinfo'
> + *				     pointer
> + * @callback:	**IN 0x18(\%rsp)** - Optional callback function to be called on
> + *				     enclave exit or exception
>   *
>   * Return:
>   *  **OUT \%eax** -
> - *  %0 on a clean entry/exit to/from the enclave, %-EINVAL if ENCLU leaf is
> - *  not allowed or if TCS is NULL, %-EFAULT if ENCLU or the enclave faults
> + *  %0 on a clean entry/exit to/from the enclave, %-EINVAL if ENCLU leaf is not
> + *  allowed, %-EFAULT if ENCLU or the enclave faults, or a non-positive value
> + *  returned from ``callback`` (if one is supplied).
>   *
>   * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
> - * x86-64 ABI, i.e. cannot be called from standard C code.   As noted above,
> - * input parameters must be passed via ``%eax``, ``%rbx`` and ``%rcx``, with
> - * the return value passed via ``%eax``.  All registers except ``%rsp`` must
> - * be treated as volatile from the caller's perspective, including but not
> - * limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc...  Conversely, the enclave
> - * being run **must** preserve the untrusted ``%rsp`` and stack.
> + * x86-64 ABI, i.e. cannot be called from standard C code. As noted above,
> + * input parameters must be passed via ``%eax``, ``8(%rsp)``, ``0x10(%rsp)`` and
> + * ``0x18(%rsp)``, with the return value passed via ``%eax``. All other
> + * registers will be passed through to the enclave as is. All registers except
> + * ``%rbp`` must be treated as volatile from the caller's perspective, including

Hmm, this is my fault since I wrote the original comment, but stating
"All registers except %rbp must be treated as volatile" is confusing, e.g.
at first I thought it meant that the assembly blob was mucking with the
registers and that they couldn't be used to pass information out of the
enclave.

Maybe something like:

 * Register ABI:
 *  - As noted above, input parameters are passed via %eax and the stack.
 *  - The return value is passed via %eax.
 *  - %rbx and %rcx must be treated as volatile as they are modified as part of
 *    enclaves transitions and are used as scratch regs.
 *  - %rbp **must** be preserved by the enclave in all cases, as it is used to
 *    reference paramaters when handling enclave exits.
 *  - %rdx, %rdi, %rsi and %r8-%r15 may be freely modified by the enclave
 *    and will not be passed back to the caller untouched.
 *  - %rsp is saved/restored across __vdso_sgx_enter_enclave(), but is passed
 *    as-is to the callback if one is provided, i.e. the enclave may use u_rsp
 *    to pass information to its associated callback.
 *
 * Callback ABI:
 *  <more information about callback ABI>
 * 

> + * but not limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc... Conversely, the
> + * enclave being run **must** preserve the untrusted ``%rbp``.
> + *
> + * ``callback`` has the following signature:
> + * int callback(long rdi, long rsi, long rdx,
> + *		struct sgx_enclave_exinfo *exinfo, long r8, long r9,
> + *		void *tcs, long ursp);
> + * ``callback`` **shall** follow x86_64 ABI. All GPRs **except** ``%rax``,
> + * ``%rbx`` and ``rcx`` are passed through to ``callback``. ``%rdi``, ``%rsi``,
> + * ``%rdx``, ``%r8``, ``%r9``, along with the value of ``%rsp`` when the enclave
> + * exited/excepted, can be accessed directly as input parameters, while other
> + * GPRs can be accessed in assembly if needed.  A positive value returned from
> + * ``callback`` will be treated as an ENCLU leaf (e.g. EENTER/ERESUME) to
> + * reenter the enclave (without popping the extra data pushed by the enclave off
> + * the stack), while 0 (zero) or a negative return value will be passed back to
> + * the caller of __vdso_sgx_enter_enclave(). It is also safe to leave
> + * ``callback`` via ``longjmp()`` or by throwing a C++ exception.
>   */

While this may format nicely in .rst (I haven't checked), it's damn near
unreadable in its raw form.  Escaping '%' in kernel-doc is unresolved at
this point, but this definitely is an argument for allowing the %CONST
interpretation to be disabled entirely.

longjmp() is probably the only thing that needs to be explicitly marked,
I think it would be better to simply say "the callback" instead of using
``callback``, i.e. use regular English instead of referencing the param.

> -__vdso_sgx_enter_enclave(u32 leaf, void *tcs,
> -			 struct sgx_enclave_exception *ex_info)
> +typedef int (*sgx_callback)(long rdi, long rsi, long rdx,
> +			    struct sgx_enclave_exinfo *exinfo, long r8,
> +			    long r9, void *tcs, long ursp);
> +int __vdso_sgx_enter_enclave(int leaf, void *tcs,
> +			     struct sgx_enclave_exinfo *exinfo,
> +			     sgx_callback callback)
>  {
> -	if (leaf != SGX_EENTER && leaf != SGX_ERESUME)
> -		return -EINVAL;
> -
> -	if (!tcs)
> -		return -EINVAL;
> -
> -	try {
> -		ENCLU[leaf];
> -	} catch (exception) {
> -		if (e)
> -			*e = exception;
> -		return -EFAULT;
> +	while (leaf == EENTER || leaf == ERESUME) {

This gives the impression that looping is the common case.  I'd prefer
using 'goto' to show that the common case is a simple fall through whereas
the callback case can effectively loop on ENCLU.

> +		int rc;
> +		try {
> +			ENCLU[leaf];
> +			rc = 0;
> +			if (exinfo)
> +				exinfo->leaf = EEXIT;
> +		} catch (exception) {
> +			rc = -EFAULT;
> +			if (exinfo)
> +				*exinfo = exception;
> +		}
> +
> +		leaf = callback ? (*callback)(
> +			rdi, rsi, rdx, exinfo, r8, r9, tcs, ursp) : rc;
>  	}
>  
> -	return 0;
> +	return leaf > 0 ? -EINVAL : leaf;
>  }
>  #endif
>  ENTRY(__vdso_sgx_enter_enclave)
> -	/* EENTER <= leaf <= ERESUME */
> +	/* Prolog */
> +	.cfi_startproc
> +	push	%rbp
> +	.cfi_adjust_cfa_offset	8
> +	.cfi_rel_offset		%rbp, 0
> +	mov	%rsp, %rbp
> +	.cfi_def_cfa_register	%rbp
> +
> +1:	/* EENTER <= leaf <= ERESUME */
>  	cmp	$0x2, %eax
> -	jb	bad_input
> -
> +	jb	6f
>  	cmp	$0x3, %eax
> -	ja	bad_input
> +	ja	6f
>  
> -	/* TCS must be non-NULL */
> -	test	%rbx, %rbx
> -	je	bad_input
> +	/* Load TCS and AEP */
> +	mov	0x10(%rbp), %rbx
> +	lea	2f(%rip), %rcx
>  
> -	/* Save @exception_info */
> -	push	%rcx
> +	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> +2:	enclu
>  
> -	/* Load AEP for ENCLU */
> -	lea	1f(%rip),  %rcx
> -1:	enclu
> +	/* EEXIT path */
> +	xor	%ebx, %ebx
> +3:	mov	0x18(%rbp), %rcx

@exinfo is optional, i.e. %ecx needs to be tested before its used.

> +	jrcxz	4f

I dislike the number of flags and values that are stashed away only to
be consumed later, it makes the code hard to follow.  AFAICT, a lot of
the shenanigans are done to reuse code because exinfo was overloaded,
but that's actually pointless, i.e. it's unnecessarily complex.

Overlading the struct is pointless becase if you make it mandatory when
using a callback then it can be nullified (when passed to the callback)
to indicate EEXIT.  If it's still optional, then the callback needs an
extra param to explicitly indicate EEXIT vs. -EFAULT, otherwise the
callback has no indication whatsover of why it was invoked.

My preference is for the latter since it's more explicit and obvious.

Tangetially related, I'm not opposed to renaming it
'struct sgx_enclave_exception_info' for clarity.

> +	mov	%eax, EX_LEAF(%rcx)
> +	jnc	4f
> +	mov	%di, EX_TRAPNR(%rcx)
> +	mov	%si, EX_ERROR_CODE(%rcx)
> +	mov	%rdx, EX_ADDRESS(%rcx)

My strong preference would be to organize the code to separate the various
flows, i.e. happy common case, invalid input, exception handler and
callback invocation.  And make the common case a straight shot so that
it's more obvious what happens in the happy non-callback case.

>  
> -	add	$0x8, %rsp
> -	xor	%eax, %eax
> +4:	/* Call *callback if supplied */
> +	mov	0x20(%rbp), %rax
> +	test	%rax, %rax
> +	/* At this point, %ebx holds the effective return value, which shall be
> +	 * returned if no callback is specified */

Use kernel-doc format for multi-line comments.  Missing punctionation at
the end.  Blank lines between logical blocks would also help readability.

E.g.:

4:      /* Call *callback if supplied */
        mov     0x20(%rbp), %rax
        test    %rax, %rax

        /*
         * At this point, %ebx holds the effective return value, which shall be
         * returned if no callback is specified.
         */
        cmovz   %rbx, %rax
        jz      7f

> +	cmovz	%rbx, %rax
> +	jz	7f
> +	/* Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
> +	 * restored after *callback returns. */
> +	mov	%rsp, %rbx
> +	and	$-0x10, %rsp
> +	/* Clear RFLAGS.DF per x86_64 ABI */
> +	cld
> +	/* Parameters for *callback */
> +	push	%rbx
> +	push	0x10(%rbp)
> +	/* Call *%rax via retpoline */
> +	call	40f

Another case of stashing a value it consuming it later.  This one is
especially brutal since %rax was loaded with CMOVcc, which means the
reader needs to backtrack even further to understand what %rax contains
at this point.

> +	/* Restore %rsp to its original value left off by the enclave from last
> +	 * exit */
> +	mov	%rbx, %rsp
> +	/* Positive return value from *callback will be interpreted as an ENCLU
> +	 * leaf, while a non-positive value will be interpreted as the return
> +	 * value to be passed back to the caller. */

Please use imperative mood in the comments, i.e. simply state what the
code is doing.  E.g. "will be interpreted" makes it sound like something
else is processing the callback's return value.

> +	jmp	1b
> +40:	/* retpoline */
> +	call	42f
> +41:	pause
> +	lfence
> +	jmp	41b
> +42:	mov	%rax, (%rsp)
>  	ret
>  
> -bad_input:
> -	mov     $(-EINVAL), %rax
> -	ret
> +5:	/* Exception path */
> +	mov	$-EFAULT, %ebx
> +	stc
> +	jmp	3b
>  
> -.pushsection .fixup, "ax"
> -	/* Re-load @exception_info and fill it (if it's non-NULL) */
> -2:	pop	%rcx
> -	test    %rcx, %rcx
> -	je      3f
> +6:	/* Unsupported ENCLU leaf */
> +	cmp	$0, %eax
> +	jle	7f
> +	mov	$-EINVAL, %eax
>  
> -	mov	%eax, EX_LEAF(%rcx)
> -	mov	%di,  EX_TRAPNR(%rcx)
> -	mov	%si,  EX_ERROR_CODE(%rcx)
> -	mov	%rdx, EX_ADDRESS(%rcx)
> -3:	mov	$(-EFAULT), %rax
> +7:	/* Epilog */
> +	leave
> +	.cfi_def_cfa		%rsp, 8
>  	ret
> -.popsection
> +	.cfi_endproc
>  
> -_ASM_VDSO_EXTABLE_HANDLE(1b, 2b)
> +_ASM_VDSO_EXTABLE_HANDLE(2b, 5b)
>  
>  ENDPROC(__vdso_sgx_enter_enclave)

Putting everything together, sans comments, I'd prefer something like the
following.  Pasted in raw code as that'll hopefully be easier to review
and discuss than a diff.

Note, swapping 'long rc' and '... *e' would allow the callback flow
to save one memory access, but IMO the exception info belongs at the end
since it's optional.

#ifdef SGX_KERNEL_DOC
typedef int (*sgx_callback)(long rdi, long rsi, long rdx, long ret, long r8,
			    long r9, void *tcs, long ursp,
			    struct sgx_enclave_exception_info *e);
int __vdso_sgx_enter_enclave(int leaf, void *tcs,
				struct sgx_enclave_exception_info *e,
				sgx_callback callback)
{
	int ret;

enter_enclave:
	if (leaf != EENTER && leaf != ERESUME) {
		ret = -EINVAL;
		goto out;
	}

	try {
		ENCLU[leaf];
		ret = 0;
	} catch (exception) {
		ret = -EFAULT;
		if (e)
			*e = exception;
	}
	if (callback)
		goto do_callback;
out:
	return ret;

do_callback:
	leaf = (*callback)(rdi, rsi, rdx, ret, r8, r9, e, tcs, ursp);
	if (leaf <= 0)
		goto out;
	goto enter_enclave;
}
#endif
ENTRY(__vdso_sgx_enter_enclave)
	/* Prolog */
	.cfi_startproc
	push	%rbp
	.cfi_adjust_cfa_offset	8
	.cfi_rel_offset		%rbp, 0
	mov	%rsp, %rbp
	.cfi_def_cfa_register	%rbp

1:	/* EENTER <= leaf <= ERESUME */
	cmp	$0x2, %eax
	jb	5f
	cmp	$0x3, %eax
	ja	5f

	/* Load TCS and AEP */
	mov	0x10(%rbp), %rbx
	lea	2f(%rip), %rcx

	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
2:	enclu

	/* EEXIT branches here unless the enclave is doing something fancy. */
	xor	%eax, %eax

3:	cmp	$0, 0x20(%rbp)
	jne	8f

4:	leave
	.cfi_def_cfa		%rsp, 8
	ret

5:	mov	$(-EINVAL), %rax
	jmp	4b

6:	mov	0x18(%rbp), %rcx
	test    %rcx, %rcx
	je	7f

	/* Fill optional exception info. */
	mov	%eax, EX_LEAF(%rcx)
	mov	%di,  EX_TRAPNR(%rcx)
	mov	%si,  EX_ERROR_CODE(%rcx)
	mov	%rdx, EX_ADDRESS(%rcx)
7:	mov	$(-EFAULT), %rax
	jmp	3b

8:	/*
	 * Align stack per x86_64 ABI.  Save the original %rsp in %rbx to be
	 * restored after the callback returns.
	 */
	mov	%rsp, %rbx
	and	$-0x10, %rsp

	/* Push @e, u_rsp and @tcs as parameters to the callback. */
	push	0x18(%rbp)
	push	%rbx
	push	0x10(%rbp)

	/* Pass the "return value" to the callback via %rcx. */
	mov	%rax, %rcx

	/* Clear RFLAGS.DF per x86_64 ABI */
	cld

	/* Load the callback pointer to %rax and invoke it via retpoline. */
	mov	0x20(%rbp), %rax
	call	40f

	/* Restore %rsp to its post-exit value. */
	mov	%rbx, %rsp

	/*
	 * If the return from callback is zero or negative, return immediately,
	 * otherwise attempt to re-execute ENCLU with the return interpreted as
	 * the requested ENCLU leaf.
	 */
	cmp	$0, %eax
	jle	4b
	jmp	1b

40:	/* retpoline */
	call	42f
41:	pause
	lfence
	jmp	41b
42:	mov	%rax, (%rsp)
	ret
	.cfi_endproc

_ASM_VDSO_EXTABLE_HANDLE(2b, 6b)

ENDPROC(__vdso_sgx_enter_enclave)
