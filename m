Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878AAC4346E
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 01:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A462076B
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 01:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgIYBAu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 21:00:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:46732 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgIYBAt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 21:00:49 -0400
IronPort-SDR: HGcMQqGooSiD1UK+7erO6E7afNMjk1S9cQ2Ma71Wh9SMYhJMaspShrO+rOfdD/eJUbERanCzEO
 tuNkKGc5Zsiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="225534844"
X-IronPort-AV: E=Sophos;i="5.77,300,1596524400"; 
   d="scan'208";a="225534844"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 18:00:49 -0700
IronPort-SDR: EMAqhhT3m7DUP4pkNG+dkY/YO5bWIT5zkiinbu37ngVl5odtY4WJnCS+kJ5wWmvQA/trC5+SOy
 4aJ7SZhEdUkA==
X-IronPort-AV: E=Sophos;i="5.77,300,1596524400"; 
   d="scan'208";a="455605694"
Received: from ralfseng-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.47.148])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 18:00:42 -0700
Date:   Fri, 25 Sep 2020 04:00:40 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200925010031.GH119995@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <20200924180407.GO5030@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924180407.GO5030@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 08:04:07PM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 02:28:39PM +0300, Jarkko Sakkinen wrote:
> > diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > new file mode 100644
> > index 000000000000..adbd59d41517
> > --- /dev/null
> > +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> 
> Why not simply
> 
> arch/x86/entry/vdso/sgx.S
> 
> ?

I renamed it as vsgx.S (for the sake of convention).

> > @@ -0,0 +1,157 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#include <linux/linkage.h>
> > +#include <asm/export.h>
> > +#include <asm/errno.h>
> > +#include <asm/enclu.h>
> > +
> > +#include "extable.h"
> > +
> > +/* Offset of 'struct sgx_enclave_run' relative to %rbp. */
> > +#define SGX_ENCLAVE_RUN_PTR	2*8
> > +
> > +/* Offsets into 'struct sgx_enclave_run'. */
> > +#define SGX_ENCLAVE_RUN_TSC		0*8
> > +#define SGX_ENCLAVE_RUN_FLAGS		1*8
> > +#define SGX_ENCLAVE_RUN_EXIT_REASON	1*8 + 4
> > +#define SGX_ENCLAVE_RUN_USER_HANDLER	2*8
> > +/* #define SGX_ENCLAVE_RUN_USER_DATA	3*8 */
> 
> What's with that guy? Left here as documentation showing what's at 3*8
> offset?

Yes.

> > +#define SGX_ENCLAVE_RUN_EXCEPTION	4*8
> > +
> > +#define SGX_SYNCHRONOUS_EXIT		0
> > +#define SGX_EXCEPTION_EXIT		1
> 
> Those are in ...uapi/asm/sgx.h too. Unify?

I have not authored this patch but what I would propose is to use just
raw value in the place of these constants. It is practially just a
boolean value.

I can also add sgx_vdso.h to uapi directory. I just don't see the point.

Holding on for feedback with this one.

> > +
> > +/* Offsets into sgx_enter_enclave.exception. */
> > +#define SGX_EX_LEAF			0*8
> > +#define SGX_EX_TRAPNR			0*8+4
> > +#define SGX_EX_ERROR_CODE		0*8+6
> > +#define SGX_EX_ADDRESS			1*8
> > +
> > +.code64
> > +.section .text, "ax"
> > +
> > +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > +	/* Prolog */
> > +	.cfi_startproc
> 
> Are the CFI annotations for userspace?

Yes, for stack unwinding. However, I would leave them out. Holding on
for further feedback with this tho.

> > +	push	%rbp
> > +	.cfi_adjust_cfa_offset	8
> > +	.cfi_rel_offset		%rbp, 0
> > +	mov	%rsp, %rbp
> > +	.cfi_def_cfa_register	%rbp
> > +	push	%rbx
> > +	.cfi_rel_offset		%rbx, -8
> > +
> > +	mov	%ecx, %eax
> > +.Lenter_enclave:
> > +	/* EENTER <= leaf <= ERESUME */
> > +	cmp	$EENTER, %eax
> > +	jb	.Linvalid_input
> > +	cmp	$ERESUME, %eax
> > +	ja	.Linvalid_input
> > +
> > +	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rcx
> > +
> > +	/* No flags are currently defined/supported. */
> > +	cmpl	$0, SGX_ENCLAVE_RUN_FLAGS(%rcx)
> > +	jne	.Linvalid_input
> > +
> > +	/* Load TCS and AEP */
> 
> 		TSC
> 
> I can see why you would write "TCS" though - there's a thread control
> structure thing too in that patch.

Renamed.

> > +	mov	SGX_ENCLAVE_RUN_TSC(%rcx), %rbx
> > +	lea	.Lasync_exit_pointer(%rip), %rcx
> > +
> > +	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> > +.Lasync_exit_pointer:
> > +.Lenclu_eenter_eresume:
> > +	enclu
> > +
> > +	/* EEXIT jumps here unless the enclave is doing something fancy. */
> > +	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
> > +
> > +	/* Set exit_reason. */
> > +	movl	$SGX_SYNCHRONOUS_EXIT, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
> > +
> > +	/* Invoke userspace's exit handler if one was provided. */
> > +.Lhandle_exit:
> > +	cmpq	$0, SGX_ENCLAVE_RUN_USER_HANDLER(%rbx)
> > +	jne	.Linvoke_userspace_handler
> > +
> > +	/* Success, in the sense that ENCLU was attempted. */
> > +	xor	%eax, %eax
> > +
> > +.Lout:
> > +	pop	%rbx
> > +	leave
> > +	.cfi_def_cfa		%rsp, 8
> > +	ret
> > +
> > +	/* The out-of-line code runs with the pre-leave stack frame. */
> > +	.cfi_def_cfa		%rbp, 16
> > +
> > +.Linvalid_input:
> > +	mov	$(-EINVAL), %eax
> > +	jmp	.Lout
> > +
> > +.Lhandle_exception:
> > +	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
> > +
> > +	/* Set the exit_reason and exception info. */
> > +	movl	$SGX_EXCEPTION_EXIT, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
> > +
> > +	mov	%eax, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_LEAF)(%rbx)
> > +	mov	%di,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_TRAPNR)(%rbx)
> > +	mov	%si,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ERROR_CODE)(%rbx)
> > +	mov	%rdx, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ADDRESS)(%rbx)
> > +	jmp	.Lhandle_exit
> > +
> > +.Linvoke_userspace_handler:
> > +	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
> > +	mov	%rsp, %rcx
> > +
> > +	/* Save @e, %rbx is about to be clobbered. */
> 
> I've been wondering what that "@e" thing is and I believe I've found it at the
> end: "... @e, the optional sgx_enclave_exception struct"
> 
> Yes?
> 
> Please rewrite what that "e" is here - I think you wanna say "struct
> sgx_enclave_run.exception" instead to clarify.

I agree. Open coded them as "struct sgx_enclave_exception".

> 
> ...
> 
> > diff --git a/arch/x86/include/asm/enclu.h b/arch/x86/include/asm/enclu.h
> > new file mode 100644
> > index 000000000000..06157b3e9ede
> > --- /dev/null
> > +++ b/arch/x86/include/asm/enclu.h
> > @@ -0,0 +1,8 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_X86_ENCLU_H
> > +#define _ASM_X86_ENCLU_H
> > +
> > +#define EENTER	0x02
> > +#define ERESUME	0x03
> > +
> > +#endif /* _ASM_X86_ENCLU_H */
> > diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> > index d0916fb9629e..1564d7f88597 100644
> > --- a/arch/x86/include/uapi/asm/sgx.h
> > +++ b/arch/x86/include/uapi/asm/sgx.h
> 
> Are all those defines being added to the uapi header, also actually
> needed by userspace?

I'd remove the two constants, as it is clearly just a boolean value.

> > @@ -72,4 +72,132 @@ struct sgx_enclave_provision {
> >  	__u64 attribute_fd;
> >  };
> >  
> > +#define SGX_SYNCHRONOUS_EXIT	0
> > +#define SGX_EXCEPTION_EXIT	1
> > +
> > +struct sgx_enclave_run;
> > +
> > +/**
> > + * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
> > + *					__vdso_sgx_enter_enclave()
> > + *
> > + * @rdi:	RDI at the time of enclave exit
> > + * @rsi:	RSI at the time of enclave exit
> > + * @rdx:	RDX at the time of enclave exit
> > + * @ursp:	RSP at the time of enclave exit (untrusted stack)
> > + * @r8:		R8 at the time of enclave exit
> > + * @r9:		R9 at the time of enclave exit
> 
> I'm sure you can avoid that "at the time of enclave exit" repetition.

I edited this as

/**
 * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
 *					__vdso_sgx_enter_enclave()
 * @rdi:	RDI snapshot
 * @rsi:	RSI snapshot
 * @rdx:	RDX snapshot
 * @rsp:	RSP snapshot (untrusted stack)
 * @r8:		R8 snapshot
 * @r9:		R9 snapshot
 * @run:	Pointer to the caller provided struct sgx_enclave_run
 *
 * Return:
 *  0 or negative to exit vDSO
 *  positive to re-enter enclave (must be EENTER or ERESUME leaf)
 */
typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
					  long rsp, long r8, long r9,
					  struct sgx_enclave_run *run);


> > +/**
> > + * typedef vdso_sgx_enter_enclave_t - Prototype for __vdso_sgx_enter_enclave(),
> > + *				      a vDSO function to enter an SGX enclave.
> > + *
> > + * @rdi:	Pass-through value for RDI
> > + * @rsi:	Pass-through value for RSI
> > + * @rdx:	Pass-through value for RDX
> > + * @leaf:	ENCLU leaf, must be EENTER or ERESUME
> > + * @r8:		Pass-through value for R8
> > + * @r9:		Pass-through value for R9
> > + * @r:		struct sgx_enclave_run, must be non-NULL
> > + *
> > + * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance with the
> > + * x86-64 ABI, e.g. doesn't handle XSAVE state.  Except for non-volatile
> > + * general purpose registers, EFLAGS.DF, and RSP alignment, preserving/setting
> > + * state in accordance with the x86-64 ABI is the responsibility of the enclave
> > + * and its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C
> > + * code without careful consideration by both the enclave and its runtime.
> > + *
> > + * All general purpose registers except RAX, RBX and RCX are passed as-is to
> > + * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME and are
> > + * loaded with @leaf, asynchronous exit pointer, and @tcs respectively.
> 
> That tcs is probably struct sgx_enclave_run.tcs?

Yes.

> > + * RBP and the stack are used to anchor __vdso_sgx_enter_enclave() to the
> > + * pre-enclave state, e.g. to retrieve @e and @handler after an enclave exit.
> 
> Expand @e and do you mean "@user_handler" with "@handler"?

I replaced this and similar fields as @run.user_handler and so forth.

> 
> > + * All other registers are available for use by the enclave and its runtime,
> > + * e.g. an enclave can push additional data onto the stack (and modify RSP) to
> > + * pass information to the optional exit handler (see below).
> > + *
> > + * Most exceptions reported on ENCLU, including those that occur within the
> > + * enclave, are fixed up and reported synchronously instead of being delivered
> > + * via a standard signal. Debug Exceptions (#DB) and Breakpoints (#BP) are
> > + * never fixed up and are always delivered via standard signals. On synchrously
> > + * reported exceptions, -EFAULT is returned and details about the exception are
> > + * recorded in @e, the optional sgx_enclave_exception struct.
> > + *
> > + * If an exit handler is provided, the handler will be invoked on synchronous
> > + * exits from the enclave and for all synchronously reported exceptions. In
> > + * latter case, @e is filled prior to invoking the handler.
> > + *
> > + * The exit handler's return value is interpreted as follows:
> > + *  >0:		continue, restart __vdso_sgx_enter_enclave() with @ret as @leaf
> > + *   0:		success, return @ret to the caller
> > + *  <0:		error, return @ret to the caller
> > + *
> > + * The exit handler may transfer control, e.g. via longjmp() or C++ exception,
> > + * without returning to __vdso_sgx_enter_enclave().
> > + *
> > + * Return:
> > + *  0 on success (ENCLU reached),
> > + *  -EINVAL if ENCLU leaf is not allowed,
> > + *  -errno for all other negative values returned by the userspace exit handler
> > + */
> > +typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
> > +					unsigned long rdx, unsigned int leaf,
> > +					unsigned long r8,  unsigned long r9,
> > +					struct sgx_enclave_run *r);
> > +
> >  #endif /* _UAPI_ASM_X86_SGX_H */
> > -- 
> > 2.25.1
> > 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

Also, I renamed 'r' as 'run' in some places.

End result:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git/tree/arch/x86/include/uapi/asm/sgx.h

I'm wondering this sentence:

"The calling convention is custom and does not follow System V x86-64 ABI."

AFAIK, now the vDSO is fully C-callable but waiting for feedback before
removing it.

/Jarkko
