Return-Path: <SRS0=vgqt=6B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470C0C2D0EF
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Apr 2020 15:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E29020857
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Apr 2020 15:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgDQPFD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Apr 2020 11:05:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:28629 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgDQPFC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 Apr 2020 11:05:02 -0400
IronPort-SDR: /e6c9H9pH1zJElhn0VQc7J21h9x9zd5iJX0VR4GJfZni89pU2pF8bnarQXAn7rbvK2NF1X+w68
 eR4AnPwhKnTQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 08:05:01 -0700
IronPort-SDR: 0QKEHm6AB5Jhtuh6S0e+0M7cLczaVCBHTXSK1YwOD1pI6C9X2Xa2kDvSGhwMdWFHItxqKaiLjP
 2JjWeCYkXxqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="244728543"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 17 Apr 2020 08:05:01 -0700
Date:   Fri, 17 Apr 2020 08:05:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 v2 1/5] x86/sgx: vdso: Make
 __vdso_sgx_enter_enclave() callable from C code
Message-ID: <20200417150501.GD13233@linux.intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
 <20200330180811.31381-2-sean.j.christopherson@intel.com>
 <20200330210426.GI1384380@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330210426.GI1384380@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 31, 2020 at 12:04:46AM +0300, Jarkko Sakkinen wrote:
> On Mon, Mar 30, 2020 at 11:08:07AM -0700, Sean Christopherson wrote:
> > Make __vdso_sgx_enter_enclave() callable from C by preserving %rbx
> > and taking @leaf in %rcx instead of %rax.  Being able to invoke the vDSO
> > from C reduces the overhead of runtimes that are tightly coupled with
> > their enclaves, e.g. that can rely on the enclave to save and restore
> > non-volatile registers, as the runtime doesn't need an assembly wrapper
> > to preserve non-volatile registers and/or shuffle stack arguments.
> > 
> > Note, both %rcx and %rbx are consumed by EENTER/ERESUME, i.e. consuming
> > them doesn't violate the primary tenet of __vdso_sgx_enter_enclave()
> > that "thou shalt not restrict how information is exchanged between an
> > enclave and its host process".
> > 
> > Suggested-by: Nathaniel McCallum <npmccallum@redhat.com>
> > Cc: Cedric Xing <cedric.xing@intel.com>
> > Cc: Jethro Beekman <jethro@fortanix.com>
> > Cc: Andy Lutomirski <luto@amacapital.net>
> > Cc: linux-sgx@vger.kernel.org
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/entry/vdso/vsgx_enter_enclave.S | 30 ++++++++++++++----------
> >  1 file changed, 18 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > index 34cee2b0ef09..c56064fb36bc 100644
> > --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > @@ -17,22 +17,22 @@
> >  
> >  /**
> >   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> > + * @rdi:	Pass-through value for RDI
> > + * @rsi:	Pass-through value for RSI
> > + * @rdx:	Pass-through value for RDX
> >   * @leaf:	ENCLU leaf, must be EENTER or ERESUME
> > + * @r8:		Pass-through value for R8
> > + * @r9:		Pass-through value for R9
> >   * @tcs:	TCS, must be non-NULL
> >   * @e:		Optional struct sgx_enclave_exception instance
> >   * @handler:	Optional enclave exit handler
> >   *
> > - * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
> > - * x86-64 ABI, i.e. cannot be called from standard C code.
> > - *
> > - * Input ABI:
> > - *  @leaf	%eax
> > - *  @tcs	8(%rsp)
> > - *  @e 		0x10(%rsp)
> > - *  @handler	0x18(%rsp)
> > - *
> > - * Output ABI:
> > - *  @ret	%eax
> > + * **Important!**  __vdso_sgx_enter_enclave() does not ensure full compliance
> 
> I'd simply put **NOTE** here instead of **Important!** as it is more
> common.
> 
> > + * with the x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.
> > + * Except for non-volatile general purpose registers, preserving/setting state
> > + * in accordance with the x86-64 ABI is the responsibility of the enclave and
> > + * its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
> > + * without careful consideration by both the enclave and its runtime.
> 
> Instead "e.g. doesn't explcitly clear EFLAGS.DF after EEXIT" (which is
> somewhat confusing statement) paragraph should be replaced with a simple
> enumerated list of differences.

I don't think the list is that simple, e.g. there is a lot of state that
is defined by the ABI that isn't touched, IMO talking about that state will
add confusion.

I also don't understand what's confusing about stating EFLAGS.DF isn't
cleared.

> Something might be left out but that's cool. Just do your best and it
> can refined over time to be more exact.
> 
> >   *
> >   * All general purpose registers except RAX, RBX and RCX are passed as-is to
> >   * the enclave. RAX, RBX and RCX are consumed by EENTER and ERESUME and are
> > @@ -71,7 +71,9 @@
> >   */
> >  #ifdef SGX_KERNEL_DOC
> >  /* C-style function prototype to coerce kernel-doc into parsing the comment. */
> > -int __vdso_sgx_enter_enclave(int leaf, void *tcs,
> > +int __vdso_sgx_enter_enclave(unsigned long rdi, unsigned long rsi,
> > +			     unsigned long rdx, unsigned int leaf,
> > +			     unsigned long r8,  unsigned long r9, void *tcs,
> >  			     struct sgx_enclave_exception *e,
> >  			     sgx_enclave_exit_handler_t handler);
> >  #endif
> > @@ -83,7 +85,10 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >  	.cfi_rel_offset		%rbp, 0
> >  	mov	%rsp, %rbp
> >  	.cfi_def_cfa_register	%rbp
> > +	push	%rbx
> > +	.cfi_rel_offset		%rbx, -8
> >  
> > +	mov	%ecx, %eax
> >  .Lenter_enclave:
> >  	/* EENTER <= leaf <= ERESUME */
> >  	cmp	$EENTER, %eax
> > @@ -109,6 +114,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >  	jne	.Linvoke_userspace_handler
> >  
> >  .Lout:
> > +	pop	%rbx
> >  	leave
> >  	.cfi_def_cfa		%rsp, 8
> >  	ret
> > -- 
> > 2.24.1
> > 
