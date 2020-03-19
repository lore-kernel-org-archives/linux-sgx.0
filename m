Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C145C4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 20:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 784D0206D7
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 20:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgCSUDn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 16:03:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:57747 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgCSUDn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 16:03:43 -0400
IronPort-SDR: coprZXOHY3N/s1cApIUizMrvRg1VGyjfcW8wBdCnuSPA+bIayKoSFjv7OTWW0vDzDuW6+Ubbwt
 hxX1OlDwGB0Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 13:03:42 -0700
IronPort-SDR: qekD5en9hzWrcYyblVzZPoJO9mw6CL8YEeVkutDwp+2+OLLvHm4N+65QcKT6zg5+AU35OG3VAr
 lzkNLcjNv7ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,572,1574150400"; 
   d="scan'208";a="234284215"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.254.176.15]) ([10.254.176.15])
  by orsmga007.jf.intel.com with ESMTP; 19 Mar 2020 13:03:41 -0700
Subject: Re: [PATCH for_v29 3/8] x86/sgx: vdso: Make
 __vdso_sgx_enter_enclave() callable from C code
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
 <20200319011130.8556-4-sean.j.christopherson@intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <9a4878b9-bcad-b279-acd5-2eef03b13af8@intel.com>
Date:   Thu, 19 Mar 2020 13:03:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200319011130.8556-4-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/18/2020 6:11 PM, Sean Christopherson wrote:
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
> 
> Cedric, please go to town on this, you're much better at the userspace
> stack and debugging interactions, e.g. I don't think the CFA directives
> need updating, but my knowledge of that stuff is skeeetchy.
> 
> Note, if the previous patch to make the %rsp restoration relative is
> dropped, then %rbx should be restored relative to %rbp instead of %rsp.
> 
>   arch/x86/entry/vdso/vsgx_enter_enclave.S | 33 ++++++++++++++----------
>   1 file changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index 14f07d5e47ae..7a0565476a29 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -16,25 +16,25 @@
>   
>   /**
>    * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> + * @rdi:	Pass-through value for RDI
> + * @rsi:	Pass-through value for RSI
> + * @rdx:	Pass-through value for RDX
>    * @leaf:	ENCLU leaf, must be EENTER or ERESUME
> + * @r8:		Pass-through value for R8
> + * @r9:		Pass-through value for R9
>    * @tcs:	TCS, must be non-NULL
>    * @e:		Optional struct sgx_enclave_exception instance
>    * @handler:	Optional enclave exit handler
>    *
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
> + * with the x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.
> + * Except for non-volatile general purpose registers, preserving/setting state
> + * in accordance with the x86-64 ABI is the responsibility of the enclave and
> + * its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
> + * without careful consideration by both the enclave and its runtime.
>    *
>    * All general purpose registers except RAX, RBX and RCX are passed as-is to
> - * the enclave. RAX, RBX and RCX are consumed by EENTER and ERESUME and are
> + * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME and are
>    * loaded with @leaf, asynchronous exit pointer, and @tcs respectively.
>    *
>    * RBP and the stack are used to anchor __vdso_sgx_enter_enclave() to the
> @@ -70,9 +70,11 @@
>    */
>   #ifdef SGX_KERNEL_DOC
>   /* C-style function prototype to coerce kernel-doc into parsing the comment. */
> -int __vdso_sgx_enter_enclave(int leaf, void *tcs,
> +int __vdso_sgx_enter_enclave(unsigned long rdi, unsigned long rsi,
> +			     unsigned long rdx, unsigned int leaf,
> +			     unsigned long r8,  unsigned long r9, void *tcs,
>   			     struct sgx_enclave_exception *e,
> -			     sgx_enclave_exit_handler_t handler);
> +			     sgx_enclave_exit_handler_t handler)
>   #endif
>   SYM_FUNC_START(__vdso_sgx_enter_enclave)
>   	/* Prolog */
> @@ -82,7 +84,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>   	.cfi_rel_offset		%rbp, 0
>   	mov	%rsp, %rbp
>   	.cfi_def_cfa_register	%rbp
> +	push	%rbx
A CFI directive is needed here:

	.cfi_rel_offset 	%rbx, -8

>   
> +	mov	%ecx, %eax
>   .Lenter_enclave:
>   	/* EENTER <= leaf <= ERESUME */
>   	cmp	$0x2, %eax
> @@ -108,6 +112,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>   	jne	.Linvoke_userspace_handler
>   
>   .Lout:
> +	pop	%rbx
>   	leave
>   	.cfi_def_cfa		%rsp, 8
>   	ret
> 
