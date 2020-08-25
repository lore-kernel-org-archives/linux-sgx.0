Return-Path: <SRS0=1rnR=CD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745D5C433E1
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Aug 2020 07:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4080020578
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Aug 2020 07:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgHYHiz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Aug 2020 03:38:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:32539 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729194AbgHYHiy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 25 Aug 2020 03:38:54 -0400
IronPort-SDR: zpbUxiD4oFYl6hC6OHKtob/QT2UfwL6TTg3Z44WsOeXElW7Lnc4x2mKOMjB0z/fxeD6AFptfBy
 RNVmn2jJUmuQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="157112858"
X-IronPort-AV: E=Sophos;i="5.76,351,1592895600"; 
   d="scan'208";a="157112858"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 00:38:53 -0700
IronPort-SDR: P7ynHV0HRJlN/6AZzQiXVCE9DWvIUIrumNDMTgxmXuGBUnw1PYEL6reqtrozPvkCGa7H5f518b
 mbArHMW/ZsmQ==
X-IronPort-AV: E=Sophos;i="5.76,351,1592895600"; 
   d="scan'208";a="499765684"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 00:38:50 -0700
Date:   Tue, 25 Aug 2020 00:38:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
Message-ID: <20200825073848.GA2847@sjchrist-ice>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
 <74e185a6-909a-af54-9a09-e8f9c8809703@fortanix.com>
 <20200824235458.GA15046@sjchrist-ice>
 <8acaeafb-ee45-7fda-1773-cc384bcbdf0e@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8acaeafb-ee45-7fda-1773-cc384bcbdf0e@fortanix.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 25, 2020 at 09:36:15AM +0200, Jethro Beekman wrote:
> On 2020-08-25 01:54, Sean Christopherson wrote:
> > On Mon, Aug 24, 2020 at 03:36:11PM +0200, Jethro Beekman wrote:
> >> On 2020-08-18 06:24, Sean Christopherson wrote:
> >>>  /**
> >>>   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> >>> @@ -119,16 +153,14 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
> >>>   * @leaf:	ENCLU leaf, must be EENTER or ERESUME
> >>>   * @r8:		Pass-through value for R8
> >>>   * @r9:		Pass-through value for R9
> >>> - * @tcs:	TCS, must be non-NULL
> >>> - * @e:		Optional struct sgx_enclave_exception instance
> >>> - * @handler:	Optional enclave exit handler
> >>> + * @r:		struct sgx_enclave_run, must be non-NULL
> >>>   *
> >>>   * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance with the
> >>> - * x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.  Except for
> >>> - * non-volatile general purpose registers, preserving/setting state in
> >>> - * accordance with the x86-64 ABI is the responsibility of the enclave and its
> >>> - * runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
> >>> - * without careful consideration by both the enclave and its runtime.
> >>> + * x86-64 ABI, e.g. doesn't handle XSAVE state.  Except for non-volatile
> >>> + * general purpose registers, EFLAGS.DF, and RSP alignment, preserving/setting
> >>> + * state in accordance with the x86-64 ABI is the responsibility of the enclave
> >>> + * and its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C
> >>> + * code without careful consideration by both the enclave and its runtime.
> >>>   *
> >>>   * All general purpose registers except RAX, RBX and RCX are passed as-is to
> >>>   * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME and are
> >>> @@ -160,16 +192,12 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
> >>>   * without returning to __vdso_sgx_enter_enclave().
> >>>   *
> >>>   * Return:
> >>> - *  0 on success,
> >>> + *  0 on success (ENCLU reached),
> >>>   *  -EINVAL if ENCLU leaf is not allowed,
> >>> - *  -EFAULT if an exception occurs on ENCLU or within the enclave
> >>> - *  -errno for all other negative values returned by the userspace exit handler
> >>>   */
> >>>  typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
> >>>  					unsigned long rdx, unsigned int leaf,
> >>>  					unsigned long r8,  unsigned long r9,
> >>> -					void *tcs,
> >>> -					struct sgx_enclave_exception *e,
> >>> -					sgx_enclave_exit_handler_t handler);
> >>> +					struct sgx_enclave_run *r);
> >>>  
> >>>  #endif /* _UAPI_ASM_X86_SGX_H */
> >>>
> >>
> >> I think this should return void now, not int? Then, the “return” section of
> >> the documentation is also no longer correct.
> > 
> > No, it returns -EINVAL if the leaf is bogus (and if unsupported flags are
> > specified, if a @flags param is ever added).
> > 
> 
> Ok, but if I read the code correctly, contrary to the docs, -EFAULT is not
> returned but passed in struct sgx_enclave_run:

The -EFAULT and -errno lines are removed from the "Return:" section of the
above documentation.  Did I miss one?

> 
> -.Lskip_exception_info:
> -	mov	$(-EFAULT), %eax
> +	/* Set the exit_reason and exception info. */
> +	movl	$(-EFAULT), EXIT_REASON_OFFSET(%rbx)
> 
> --
> Jethro Beekman | Fortanix
> 


