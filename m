Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E234C43331
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 21:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A32020714
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 21:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgC3VEv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 17:04:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:39685 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728317AbgC3VEv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 17:04:51 -0400
IronPort-SDR: ENsdSigNrUUbGNVXjstmQyE//yPrcA1EjQFwpMQ7nqu8GaudnE9RqhfPZZJMU0++XkM6xEPAk5
 yorqYmE7CzvQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 14:04:50 -0700
IronPort-SDR: vSFukAajEdjtPf09eeWDbR7fwDqwXdylaFJvXqx7UTt8CezrOcEJUULUtMQZm9lZmyySPBxabN
 fN8acGM8WA3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="395263041"
Received: from plachner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.35.129])
  by orsmga004.jf.intel.com with ESMTP; 30 Mar 2020 14:04:47 -0700
Date:   Tue, 31 Mar 2020 00:04:46 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 v2 1/5] x86/sgx: vdso: Make
 __vdso_sgx_enter_enclave() callable from C code
Message-ID: <20200330210426.GI1384380@linux.intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
 <20200330180811.31381-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330180811.31381-2-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 30, 2020 at 11:08:07AM -0700, Sean Christopherson wrote:
> Make __vdso_sgx_enter_enclave() callable from C by preserving %rbx
> and taking @leaf in %rcx instead of %rax.  Being able to invoke the vDSO
> from C reduces the overhead of runtimes that are tightly coupled with
> their enclaves, e.g. that can rely on the enclave to save and restore
> non-volatile registers, as the runtime doesn't need an assembly wrapper
> to preserve non-volatile registers and/or shuffle stack arguments.
> 
> Note, both %rcx and %rbx are consumed by EENTER/ERESUME, i.e. consuming
> them doesn't violate the primary tenet of __vdso_sgx_enter_enclave()
> that "thou shalt not restrict how information is exchanged between an
> enclave and its host process".
> 
> Suggested-by: Nathaniel McCallum <npmccallum@redhat.com>
> Cc: Cedric Xing <cedric.xing@intel.com>
> Cc: Jethro Beekman <jethro@fortanix.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: linux-sgx@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 30 ++++++++++++++----------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index 34cee2b0ef09..c56064fb36bc 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -17,22 +17,22 @@
>  
>  /**
>   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> + * @rdi:	Pass-through value for RDI
> + * @rsi:	Pass-through value for RSI
> + * @rdx:	Pass-through value for RDX
>   * @leaf:	ENCLU leaf, must be EENTER or ERESUME
> + * @r8:		Pass-through value for R8
> + * @r9:		Pass-through value for R9
>   * @tcs:	TCS, must be non-NULL
>   * @e:		Optional struct sgx_enclave_exception instance
>   * @handler:	Optional enclave exit handler
>   *
> - * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
> - * x86-64 ABI, i.e. cannot be called from standard C code.
> - *
> - * Input ABI:
> - *  @leaf	%eax
> - *  @tcs	8(%rsp)
> - *  @e 		0x10(%rsp)
> - *  @handler	0x18(%rsp)
> - *
> - * Output ABI:
> - *  @ret	%eax
> + * **Important!**  __vdso_sgx_enter_enclave() does not ensure full compliance

I'd simply put **NOTE** here instead of **Important!** as it is more
common.

> + * with the x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.
> + * Except for non-volatile general purpose registers, preserving/setting state
> + * in accordance with the x86-64 ABI is the responsibility of the enclave and
> + * its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
> + * without careful consideration by both the enclave and its runtime.

Instead "e.g. doesn't explcitly clear EFLAGS.DF after EEXIT" (which is
somewhat confusing statement) paragraph should be replaced with a simple
enumerated list of differences.

Something might be left out but that's cool. Just do your best and it
can refined over time to be more exact.

>   *
>   * All general purpose registers except RAX, RBX and RCX are passed as-is to
>   * the enclave. RAX, RBX and RCX are consumed by EENTER and ERESUME and are
> @@ -71,7 +71,9 @@
>   */
>  #ifdef SGX_KERNEL_DOC
>  /* C-style function prototype to coerce kernel-doc into parsing the comment. */
> -int __vdso_sgx_enter_enclave(int leaf, void *tcs,
> +int __vdso_sgx_enter_enclave(unsigned long rdi, unsigned long rsi,
> +			     unsigned long rdx, unsigned int leaf,
> +			     unsigned long r8,  unsigned long r9, void *tcs,
>  			     struct sgx_enclave_exception *e,
>  			     sgx_enclave_exit_handler_t handler);
>  #endif
> @@ -83,7 +85,10 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	.cfi_rel_offset		%rbp, 0
>  	mov	%rsp, %rbp
>  	.cfi_def_cfa_register	%rbp
> +	push	%rbx
> +	.cfi_rel_offset		%rbx, -8
>  
> +	mov	%ecx, %eax
>  .Lenter_enclave:
>  	/* EENTER <= leaf <= ERESUME */
>  	cmp	$EENTER, %eax
> @@ -109,6 +114,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	jne	.Linvoke_userspace_handler
>  
>  .Lout:
> +	pop	%rbx
>  	leave
>  	.cfi_def_cfa		%rsp, 8
>  	ret
> -- 
> 2.24.1
> 
