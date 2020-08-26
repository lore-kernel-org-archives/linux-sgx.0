Return-Path: <SRS0=/5Ao=CE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2166C433E1
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 20:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 857C92076C
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 20:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgHZUUj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Aug 2020 16:20:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:56895 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbgHZUUi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Aug 2020 16:20:38 -0400
IronPort-SDR: ZlQouPIcRLYUT7Lk71aYlAeA68ovBYZzteUmtLJ+tfeM++8C0hHFBq55eCHpqUpnnFwXsx6hS9
 qwrdgxAvAOxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="217928797"
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="217928797"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 13:20:30 -0700
IronPort-SDR: tmEHwWdMsRhLvZbFJkFUkNJdtppmKQpPTRMY+ffWKWhzshgtt1Rv83E1OlXMhPuKOHgPugoBkk
 GLsl3yWVjGtQ==
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="299593322"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 13:20:30 -0700
Date:   Wed, 26 Aug 2020 13:20:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
Message-ID: <20200826202029.GD21459@sjchrist-ice>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818042405.12871-3-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Andy,

Any thoughts on using a struct versus a plethora of params?  If you don't
have a strong opinion, I'd like to push for the struct option as it fixes
the -EFAULT weirdness, satisfies Nathaniel's request, and gives some
flexibility for the future.  The code impact, both to the vDSO and to the
caller, is largely a lateral move, i.e. it's different but in the end
doesn't require any more or less work.

On Mon, Aug 17, 2020 at 09:24:03PM -0700, Sean Christopherson wrote:
> Rework __vdso_sgx_enter_enclave() to use a struct to hold the input and
> output params.  In the new struct, add an opaque "user_data" that can be
> used to pass context across the vDSO, and an explicit "exit_reason" to
> avoid overloading the return value.
> 
> Moving the params into a struct will also make it less painful to use
> dedicated exit reasons, and to support exiting on interrupts in future
> patches.
> 
> Cc: Nathaniel McCallum <npmccallum@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 72 ++++++++++++-------
>  arch/x86/include/uapi/asm/sgx.h          | 90 ++++++++++++++++--------
>  2 files changed, 107 insertions(+), 55 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index 2d88acd408d4e..aaae6d6e28ac3 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -7,9 +7,21 @@
>  
>  #include "extable.h"
>  
> -#define EX_LEAF		0*8
> -#define EX_TRAPNR	0*8+4
> -#define EX_ERROR_CODE	0*8+6
> +/* Offset of 'struct sgx_enter_enclave' relative to %rbp. */
> +#define RUN_OFFSET	2*8
> +
> +/* Offsets into 'struct sgx_enter_enclave'. */
> +#define TCS_OFFEST		0*8
> +#define FLAGS_OFFSET		1*8
> +#define EXIT_LEAF_OFFSET	2*8
> +#define EXIT_REASON_OFFSET	2*8 + 4
> +#define USER_HANDLER_OFFSET	3*8
> +/* #define USER_DATA_OFFSET	4*8 */
> +#define EXCEPTION_OFFSET	5*8
> +
> +/* Offsets into sgx_enter_enclave.exception. */
> +#define EX_TRAPNR	0*8
> +#define EX_ERROR_CODE	0*8+2
>  #define EX_ADDRESS	1*8
>  
>  .code64
> @@ -30,12 +42,18 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  .Lenter_enclave:
>  	/* EENTER <= leaf <= ERESUME */
>  	cmp	$EENTER, %eax
> -	jb	.Linvalid_leaf
> +	jb	.Linvalid_input
>  	cmp	$ERESUME, %eax
> -	ja	.Linvalid_leaf
> +	ja	.Linvalid_input
> +
> +	mov	RUN_OFFSET(%rbp), %rcx
> +
> +	/* No flags are currently defined/supported. */
> +	cmpq	$0, FLAGS_OFFSET(%rcx)
> +	jne	.Linvalid_input
>  
>  	/* Load TCS and AEP */
> -	mov	0x10(%rbp), %rbx
> +	mov	TCS_OFFEST(%rcx), %rbx
>  	lea	.Lasync_exit_pointer(%rip), %rcx
>  
>  	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> @@ -44,13 +62,21 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	enclu
>  
>  	/* EEXIT jumps here unless the enclave is doing something fancy. */
> -	xor	%eax, %eax
> +	mov	RUN_OFFSET(%rbp), %rbx
> +
> +	/* Set exit_reason. */
> +	movl	$0, EXIT_REASON_OFFSET(%rbx)
>  
>  	/* Invoke userspace's exit handler if one was provided. */
>  .Lhandle_exit:
> -	cmpq	$0, 0x20(%rbp)
> +	mov	%eax, EXIT_LEAF_OFFSET(%rbx)
> +
> +	cmpq	$0, USER_HANDLER_OFFSET(%rbx)
>  	jne	.Linvoke_userspace_handler
>  
> +	/* Success, in the sense that ENCLU was attempted. */
> +	xor	%eax, %eax
> +
>  .Lout:
>  	pop	%rbx
>  	leave
> @@ -60,28 +86,28 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	/* The out-of-line code runs with the pre-leave stack frame. */
>  	.cfi_def_cfa		%rbp, 16
>  
> -.Linvalid_leaf:
> +.Linvalid_input:
>  	mov	$(-EINVAL), %eax
>  	jmp	.Lout
>  
>  .Lhandle_exception:
> -	mov	0x18(%rbp), %rcx
> -	test    %rcx, %rcx
> -	je	.Lskip_exception_info
> +	mov	RUN_OFFSET(%rbp), %rbx
>  
> -	/* Fill optional exception info. */
> -	mov	%eax, EX_LEAF(%rcx)
> -	mov	%di,  EX_TRAPNR(%rcx)
> -	mov	%si,  EX_ERROR_CODE(%rcx)
> -	mov	%rdx, EX_ADDRESS(%rcx)
> -.Lskip_exception_info:
> -	mov	$(-EFAULT), %eax
> +	/* Set the exit_reason and exception info. */
> +	movl	$(-EFAULT), EXIT_REASON_OFFSET(%rbx)
> +
> +	mov	%di,  (EXCEPTION_OFFSET + EX_TRAPNR)(%rbx)
> +	mov	%si,  (EXCEPTION_OFFSET + EX_ERROR_CODE)(%rbx)
> +	mov	%rdx, (EXCEPTION_OFFSET + EX_ADDRESS)(%rbx)
>  	jmp	.Lhandle_exit
>  
>  .Linvoke_userspace_handler:
>  	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
>  	mov	%rsp, %rcx
>  
> +	/* Save @e, %rbx is about to be clobbered. */
> +	mov	%rbx, %rax
> +
>  	/* Save the untrusted RSP offset in %rbx (non-volatile register). */
>  	mov	%rsp, %rbx
>  	and	$0xf, %rbx
> @@ -93,20 +119,18 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	and	$-0x10, %rsp
>  	push	%rax
>  
> -	/* Push @e, the "return" value and @tcs as params to the callback. */
> -	push	0x18(%rbp)
> +	/* Push @e as a param to the callback. */
>  	push	%rax
> -	push	0x10(%rbp)
>  
>  	/* Clear RFLAGS.DF per x86_64 ABI */
>  	cld
>  
>  	/* Load the callback pointer to %rax and invoke it via retpoline. */
> -	mov	0x20(%rbp), %rax
> +	mov	USER_HANDLER_OFFSET(%rax), %rax
>  	call	.Lretpoline
>  
>  	/* Undo the post-exit %rsp adjustment. */
> -	lea	0x20(%rsp, %rbx), %rsp
> +	lea	0x10(%rsp, %rbx), %rsp
>  
>  	/*
>  	 * If the return from callback is zero or negative, return immediately,
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 3760e5d5dc0c7..d3b107aac279d 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -74,6 +74,28 @@ struct sgx_enclave_set_attribute {
>  	__u64 attribute_fd;
>  };
>  
> +struct sgx_enclave_run;
> +
> +/**
> + * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
> + *					__vdso_sgx_enter_enclave()
> + *
> + * @rdi:	RDI at the time of enclave exit
> + * @rsi:	RSI at the time of enclave exit
> + * @rdx:	RDX at the time of enclave exit
> + * @ursp:	RSP at the time of enclave exit (untrusted stack)
> + * @r8:		R8 at the time of enclave exit
> + * @r9:		R9 at the time of enclave exit
> + * @r:		Pointer to struct sgx_enclave_run (as provided by caller)
> + *
> + * Return:
> + *  0 or negative to exit vDSO
> + *  positive to re-enter enclave (must be EENTER or ERESUME leaf)
> + */
> +typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
> +					  long ursp, long r8, long r9,
> +					  struct sgx_enclave_run *r);
> +
>  /**
>   * struct sgx_enclave_exception - structure to report exceptions encountered in
>   *				  __vdso_sgx_enter_enclave()
> @@ -85,31 +107,43 @@ struct sgx_enclave_set_attribute {
>   * @reserved:	reserved for future use
>   */
>  struct sgx_enclave_exception {
> -	__u32 leaf;
>  	__u16 trapnr;
>  	__u16 error_code;
> +	__u32 reserved;
>  	__u64 address;
> -	__u64 reserved[2];
>  };
>  
>  /**
> - * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
> - *					__vdso_sgx_enter_enclave()
> + * struct sgx_enclave_run - Control structure for __vdso_sgx_enter_enclave()
>   *
> - * @rdi:	RDI at the time of enclave exit
> - * @rsi:	RSI at the time of enclave exit
> - * @rdx:	RDX at the time of enclave exit
> - * @ursp:	RSP at the time of enclave exit (untrusted stack)
> - * @r8:		R8 at the time of enclave exit
> - * @r9:		R9 at the time of enclave exit
> - * @tcs:	Thread Control Structure used to enter enclave
> - * @ret:	0 on success (EEXIT), -EFAULT on an exception
> - * @e:		Pointer to struct sgx_enclave_exception (as provided by caller)
> + * @tcs:		Thread Control Structure used to enter enclave
> + * @flags:		Control flags
> + * @exit_leaf:		ENCLU leaf from \%eax at time of exit
> + * @exit_reason:	Cause of exit from enclave, e.g. EEXIT vs. exception
> + * @user_handler:	User provided exit handler (optional)
> + * @user_data:		User provided opaque value (optional)
> + * @exception:		Valid on exit due to exception
>   */
> -typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
> -					  long ursp, long r8, long r9,
> -					  void *tcs, int ret,
> -					  struct sgx_enclave_exception *e);
> +struct sgx_enclave_run {
> +	__u64 tcs;
> +	__u64 flags;
> +
> +	__u32 exit_leaf;
> +	__u32 exit_reason;
> +
> +	union {
> +		sgx_enclave_exit_handler_t user_handler;
> +		__u64 __user_handler;
> +	};
> +	__u64 user_data;
> +
> +	union {
> +		struct sgx_enclave_exception exception;
> +
> +		/* Pad the entire struct to 256 bytes. */
> +		__u8 pad[256 - 40];
> +	};
> +};
>  
>  /**
>   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> @@ -119,16 +153,14 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
>   * @leaf:	ENCLU leaf, must be EENTER or ERESUME
>   * @r8:		Pass-through value for R8
>   * @r9:		Pass-through value for R9
> - * @tcs:	TCS, must be non-NULL
> - * @e:		Optional struct sgx_enclave_exception instance
> - * @handler:	Optional enclave exit handler
> + * @r:		struct sgx_enclave_run, must be non-NULL
>   *
>   * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance with the
> - * x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.  Except for
> - * non-volatile general purpose registers, preserving/setting state in
> - * accordance with the x86-64 ABI is the responsibility of the enclave and its
> - * runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
> - * without careful consideration by both the enclave and its runtime.
> + * x86-64 ABI, e.g. doesn't handle XSAVE state.  Except for non-volatile
> + * general purpose registers, EFLAGS.DF, and RSP alignment, preserving/setting
> + * state in accordance with the x86-64 ABI is the responsibility of the enclave
> + * and its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C
> + * code without careful consideration by both the enclave and its runtime.
>   *
>   * All general purpose registers except RAX, RBX and RCX are passed as-is to
>   * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME and are
> @@ -160,16 +192,12 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
>   * without returning to __vdso_sgx_enter_enclave().
>   *
>   * Return:
> - *  0 on success,
> + *  0 on success (ENCLU reached),
>   *  -EINVAL if ENCLU leaf is not allowed,
> - *  -EFAULT if an exception occurs on ENCLU or within the enclave
> - *  -errno for all other negative values returned by the userspace exit handler
>   */
>  typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
>  					unsigned long rdx, unsigned int leaf,
>  					unsigned long r8,  unsigned long r9,
> -					void *tcs,
> -					struct sgx_enclave_exception *e,
> -					sgx_enclave_exit_handler_t handler);
> +					struct sgx_enclave_run *r);
>  
>  #endif /* _UAPI_ASM_X86_SGX_H */
> -- 
> 2.28.0
> 
