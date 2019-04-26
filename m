Return-Path: <SRS0=uXuT=S4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAB7C43218
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Apr 2019 21:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D325B20679
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Apr 2019 21:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfDZVA2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 26 Apr 2019 17:00:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:53184 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfDZVA2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 26 Apr 2019 17:00:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Apr 2019 14:00:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,398,1549958400"; 
   d="scan'208";a="134722526"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga007.jf.intel.com with ESMTP; 26 Apr 2019 14:00:18 -0700
Date:   Fri, 26 Apr 2019 14:00:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>
Subject: Re: [RFC PATCH v2 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave()
 to allow parameter passing on untrusted stack
Message-ID: <20190426210017.GA24467@linux.intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
 <20190424062623.4345-3-cedric.xing@intel.com>
 <20190424190446.GE18442@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E87FD17@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E87FD17@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 25, 2019 at 04:31:40PM -0700, Xing, Cedric wrote:
> > While this may format nicely in .rst (I haven't checked), it's damn near
> > unreadable in its raw form.  Escaping '%' in kernel-doc is unresolved at
> > this point, but this definitely is an argument for allowing the %CONST
> > interpretation to be disabled entirely.
> > 
> 
> I know very little about kernel-doc. Not quite sure which markup means what.
> Or if you don't mind, could you just write up the whole thing (you have
> written half of it in your email already) so I can include it into my next
> revision?

Hmm, at this point I'd say just ignore the comment entirely.  It's
something we need to sort out in the "official" series anyways.

>  
> > longjmp() is probably the only thing that needs to be explicitly marked,
> > I think it would be better to simply say "the callback" instead of using
> > ``callback``, i.e. use regular English instead of referencing the param.
> > 
> 
> Are you suggesting not to mention C++ exception here?

No, I was saying that rather than do the backtick markup on callback,
just say "the callback".  The copious amount of markup makes it difficult
to read the raw text.

>  
> > > -__vdso_sgx_enter_enclave(u32 leaf, void *tcs,
> > > -			 struct sgx_enclave_exception *ex_info)
> > > +typedef int (*sgx_callback)(long rdi, long rsi, long rdx,
> > > +			    struct sgx_enclave_exinfo *exinfo, long r8,
> > > +			    long r9, void *tcs, long ursp);
> > > +int __vdso_sgx_enter_enclave(int leaf, void *tcs,
> > > +			     struct sgx_enclave_exinfo *exinfo,
> > > +			     sgx_callback callback)
> > >  {
> > > -	if (leaf != SGX_EENTER && leaf != SGX_ERESUME)
> > > -		return -EINVAL;
> > > -
> > > -	if (!tcs)
> > > -		return -EINVAL;
> > > -
> > > -	try {
> > > -		ENCLU[leaf];
> > > -	} catch (exception) {
> > > -		if (e)
> > > -			*e = exception;
> > > -		return -EFAULT;
> > > +	while (leaf == EENTER || leaf == ERESUME) {
> > 
> > This gives the impression that looping is the common case.  I'd prefer
> > using 'goto' to show that the common case is a simple fall through
> > whereas
> > the callback case can effectively loop on ENCLU.
> 
> Looping IMO is indeed the common case. Just think of the case of an enclave
> making a sequence of o-calls. 

Except that looping is only done when using a callback, and that most
definitely is not the common case.

> > > +		int rc;
> > > +		try {
> > > +			ENCLU[leaf];
> > > +			rc = 0;
> > > +			if (exinfo)
> > > +				exinfo->leaf = EEXIT;
> > > +		} catch (exception) {
> > > +			rc = -EFAULT;
> > > +			if (exinfo)
> > > +				*exinfo = exception;
> > > +		}
> > > +
> > > +		leaf = callback ? (*callback)(
> > > +			rdi, rsi, rdx, exinfo, r8, r9, tcs, ursp) : rc;
> > >  	}
> > >
> > > -	return 0;
> > > +	return leaf > 0 ? -EINVAL : leaf;
> > >  }
> > >  #endif
> > >  ENTRY(__vdso_sgx_enter_enclave)
> > > -	/* EENTER <= leaf <= ERESUME */
> > > +	/* Prolog */
> > > +	.cfi_startproc
> > > +	push	%rbp
> > > +	.cfi_adjust_cfa_offset	8
> > > +	.cfi_rel_offset		%rbp, 0
> > > +	mov	%rsp, %rbp
> > > +	.cfi_def_cfa_register	%rbp
> > > +
> > > +1:	/* EENTER <= leaf <= ERESUME */
> > >  	cmp	$0x2, %eax
> > > -	jb	bad_input
> > > -
> > > +	jb	6f
> > >  	cmp	$0x3, %eax
> > > -	ja	bad_input
> > > +	ja	6f
> > >
> > > -	/* TCS must be non-NULL */
> > > -	test	%rbx, %rbx
> > > -	je	bad_input
> > > +	/* Load TCS and AEP */
> > > +	mov	0x10(%rbp), %rbx
> > > +	lea	2f(%rip), %rcx
> > >
> > > -	/* Save @exception_info */
> > > -	push	%rcx
> > > +	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> > > +2:	enclu
> > >
> > > -	/* Load AEP for ENCLU */
> > > -	lea	1f(%rip),  %rcx
> > > -1:	enclu
> > > +	/* EEXIT path */
> > > +	xor	%ebx, %ebx
> > > +3:	mov	0x18(%rbp), %rcx
> > 
> > @exinfo is optional, i.e. %ecx needs to be tested before its used.
> > 
> > > +	jrcxz	4f
> 
> The above instruction (i.e. jrcxz) does test %rcx.

I love x86 ISA.

> > I dislike the number of flags and values that are stashed away only to
> > be consumed later, it makes the code hard to follow.  AFAICT, a lot of
> > the shenanigans are done to reuse code because exinfo was overloaded,
> > but that's actually pointless, i.e. it's unnecessarily complex.
> > 
> > Overlading the struct is pointless becase if you make it mandatory when
> > using a callback then it can be nullified (when passed to the callback)
> > to indicate EEXIT.  If it's still optional, then the callback needs an
> > extra param to explicitly indicate EEXIT vs. -EFAULT, otherwise the
> > callback has no indication whatsover of why it was invoked.
> > 
> > My preference is for the latter since it's more explicit and obvious.
> 
> I wouldn't nullify @exinfo at EEXIT because that could be used as a "context"
> pointer to the callback.
> 
> Making it optionally because the callback can still use other registers (e.g.
> %rdi) determine the reason without it. For example, an enclave may set %rdi
> to non-zero to signify o-call/e-ret while zero (as set by AEX) would indicate
> an exception. My intention is not to impose unnecessary restrictions on
> applications.
> > Tangetially related, I'm not opposed to renaming it
> > 'struct sgx_enclave_exception_info' for clarity.
> 
> I'd still prefer sgx_enclave_exinfo to imply its use in both _ex_it and
> _ex_ception cases, for the reason stated above.

Because an enclave *could* choose a different route?  The cost is
essentially one memory access, which is likely offset by the fact that
the callback can directly check %rcx for the exit reason.  You are not
the sole consumer of this code.

> > > +	mov	%eax, EX_LEAF(%rcx)
> > > +	jnc	4f
> > > +	mov	%di, EX_TRAPNR(%rcx)
> > > +	mov	%si, EX_ERROR_CODE(%rcx)
> > > +	mov	%rdx, EX_ADDRESS(%rcx)
> > 
> > My strong preference would be to organize the code to separate the
> > various
> > flows, i.e. happy common case, invalid input, exception handler and
> > callback invocation.  And make the common case a straight shot so that
> > it's more obvious what happens in the happy non-callback case.
> 
> I'd prefer more concise code. After all, this is assembly without
> optimization done by the compiler. If it were for C, I'd agree with you
> because either case would end up in roughly the same code (in terms of code
> size or efficiency) due to the optimizer.

a) You've argued multiple times this isn't performance critical code.

b) A straight shot is optimal for the common case where userspace is not
   using a callback.

c) The performance difference is something like one or two memory accesses.
   That's peanuts compared to how readable the code is by people without
   prior knowledge of exactly what this code is doing.

> > > -	add	$0x8, %rsp
> > > -	xor	%eax, %eax
> > > +4:	/* Call *callback if supplied */
> > > +	mov	0x20(%rbp), %rax
> > > +	test	%rax, %rax
> > > +	/* At this point, %ebx holds the effective return value, which
> > shall be
> > > +	 * returned if no callback is specified */
> > 
> > Use kernel-doc format for multi-line comments.  Missing punctionation at
> > the end.  Blank lines between logical blocks would also help readability.
> > 
> > E.g.:
> > 
> > 4:      /* Call *callback if supplied */
> >         mov     0x20(%rbp), %rax
> >         test    %rax, %rax
> > 
> >         /*
> >          * At this point, %ebx holds the effective return value, which
> > shall be
> >          * returned if no callback is specified.
> >          */
> >         cmovz   %rbx, %rax
> >         jz      7f
> 
> I know very little about kernel-doc. Would you please point me to documents
> describing it? What you suggested here will of course be incorporated into my
> next revision. 

Documentation/doc-guide/kernel-doc.rst

[...]

> > Note, swapping 'long rc' and '... *e' would allow the callback flow
> > to save one memory access, but IMO the exception info belongs at the end
> > since it's optional.
> 
> You have probably misunderstood my code. 'ret' is _not_ passed while @exinfo
> is passed in %rcx. exinfo->leaf implies the reason of the callback.
> 
> Or are you suggesting to add 'ret' as one more parameter to the callback? I
> don't think it necessary because exinfo contains everything the callback
> would ever need.

The latter, because exinfo is optional, as stated above.
