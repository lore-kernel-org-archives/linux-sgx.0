Return-Path: <SRS0=YsX3=DN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0023FC4363A
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Oct 2020 02:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADD00206F4
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Oct 2020 02:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgJFC5H (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 22:57:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:61582 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgJFC5H (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 22:57:07 -0400
IronPort-SDR: RVBWPuAIht4PeEoN+qsYU351Vc8dsx9Gc/1R9By0LrB++1dfyb51f/k+cSD6RKFf273c2cgTAn
 SScL/Ocu87yg==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="164395476"
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="164395476"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 19:57:06 -0700
IronPort-SDR: yad9K+r4xWyr5k8OZX+Ip0/ffhgc8llreabNVC1dY+QaO/oGiHiLvk0LJEALlGYugbDKUJRGP0
 wcOasAvbQMcg==
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="315306848"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 19:57:06 -0700
Date:   Mon, 5 Oct 2020 19:57:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20201006025703.GG15803@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 03, 2020 at 07:50:56AM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> +	/* Validate that the reserved area contains only zeros. */
> +	push	%rax
> +	push	%rbx
> +	mov	$SGX_ENCLAVE_RUN_RESERVED_START, %rbx
> +1:
> +	mov	(%rcx, %rbx), %rax
> +	cmpq	$0, %rax
> +	jne	.Linvalid_input
> +
> +	add	$8, %rbx
> +	cmpq	$SGX_ENCLAVE_RUN_RESERVED_END, %rbx
> +	jne	1b
> +	pop	%rbx
> +	pop	%rax

This can more succinctly be (untested):

	movq	SGX_ENCLAVE_RUN_RESERVED_1(%rbp), %rbx	
	orq	SGX_ENCLAVE_RUN_RESERVED_2(%rbp), %rbx	
	orq	SGX_ENCLAVE_RUN_RESERVED_3(%rbp), %rbx	
	jnz	.Linvalid_input

Note, %rbx is getting clobbered anyways, no need to save/restore it.

> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index b6ba036a9b82..3dd2df44d569 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -74,4 +74,102 @@ struct sgx_enclave_provision {
>  	__u64 attribute_fd;
>  };
>  
> +struct sgx_enclave_run;
> +
> +/**
> + * typedef sgx_enclave_user_handler_t - Exit handler function accepted by
> + *					__vdso_sgx_enter_enclave()
> + * @run:	Pointer to the caller provided struct sgx_enclave_run
> + *
> + * The register parameters contain the snapshot of their values at enclave
> + * exit
> + *
> + * Return:
> + *  0 or negative to exit vDSO
> + *  positive to re-enter enclave (must be EENTER or ERESUME leaf)
> + */
> +typedef int (*sgx_enclave_user_handler_t)(long rdi, long rsi, long rdx,
> +					  long rsp, long r8, long r9,
> +					  struct sgx_enclave_run *run);
> +
> +/**
> + * struct sgx_enclave_run - the execution context of __vdso_sgx_enter_enclave()
> + * @tcs:			TCS used to enter the enclave
> + * @user_handler:		User provided callback run on exception
> + * @user_data:			Data passed to the user handler
> + * @leaf:			The ENCLU leaf we were at (EENTER/ERESUME/EEXIT)
> + * @exception_vector:		The interrupt vector of the exception
> + * @exception_error_code:	The exception error code pulled out of the stack
> + * @exception_addr:		The address that triggered the exception
> + * @reserved			Reserved for possible future use
> + */
> +struct sgx_enclave_run {
> +	__u64 tcs;
> +	__u64 user_handler;
> +	__u64 user_data;
> +	__u32 leaf;

I am still very strongly opposed to omitting exit_reason.  It is not at all
difficult to imagine scenarios where 'leaf' alone is insufficient for the
caller or its handler to deduce why the CPU exited the enclave.  E.g. see
Jethro's request for intercepting interrupts.

I don't buy the argument that the N bytes needed for the exit_reason are at
all expensive.

> +	__u16 exception_vector;
> +	__u16 exception_error_code;
> +	__u64 exception_addr;
> +	__u8  reserved[24];

I also think it's a waste of space to bother with multiple reserved fields.
24 bytes isn't so much that it guarantees we'll never run into problems in
the future.  But I care far less about this than I do about exit_reason.

> +};
