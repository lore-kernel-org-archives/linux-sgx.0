Return-Path: <SRS0=vgqt=6B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6B4C2D0EF
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Apr 2020 18:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BD4E2220A
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Apr 2020 18:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgDQS5q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Apr 2020 14:57:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:42934 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbgDQS5p (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 Apr 2020 14:57:45 -0400
IronPort-SDR: 3N+b6A/P+bBYRqOl03I1B0k3BG1pJdOOnfByOR968H+alycSYru+iZi5rgM25UKjVnoiZaOSHN
 gdlsdHN6GmGA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:57:45 -0700
IronPort-SDR: 5BDJa3/tyA4UNmUbqjgJeSJHzi5r6AOrs799INpC4Q9znJP4dd+weCuYSaiSH2Gie/jpj2owD7
 IeGmZmhdxxag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="333277554"
Received: from mkrotovx-mobl.ccr.corp.intel.com (HELO localhost) ([10.252.43.28])
  by orsmga001.jf.intel.com with ESMTP; 17 Apr 2020 11:57:43 -0700
Date:   Fri, 17 Apr 2020 21:57:42 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 v2 1/5] x86/sgx: vdso: Make
 __vdso_sgx_enter_enclave() callable from C code
Message-ID: <20200417185742.GA42307@linux.intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
 <20200330180811.31381-2-sean.j.christopherson@intel.com>
 <20200330210426.GI1384380@linux.intel.com>
 <20200417150501.GD13233@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417150501.GD13233@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 17, 2020 at 08:05:01AM -0700, Sean Christopherson wrote:
> On Tue, Mar 31, 2020 at 12:04:46AM +0300, Jarkko Sakkinen wrote:
> > On Mon, Mar 30, 2020 at 11:08:07AM -0700, Sean Christopherson wrote:
> > > Make __vdso_sgx_enter_enclave() callable from C by preserving %rbx
> > > and taking @leaf in %rcx instead of %rax.  Being able to invoke the vDSO
> > > from C reduces the overhead of runtimes that are tightly coupled with
> > > their enclaves, e.g. that can rely on the enclave to save and restore
> > > non-volatile registers, as the runtime doesn't need an assembly wrapper
> > > to preserve non-volatile registers and/or shuffle stack arguments.
> > > 
> > > Note, both %rcx and %rbx are consumed by EENTER/ERESUME, i.e. consuming
> > > them doesn't violate the primary tenet of __vdso_sgx_enter_enclave()
> > > that "thou shalt not restrict how information is exchanged between an
> > > enclave and its host process".
> > > 
> > > Suggested-by: Nathaniel McCallum <npmccallum@redhat.com>
> > > Cc: Cedric Xing <cedric.xing@intel.com>
> > > Cc: Jethro Beekman <jethro@fortanix.com>
> > > Cc: Andy Lutomirski <luto@amacapital.net>
> > > Cc: linux-sgx@vger.kernel.org
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  arch/x86/entry/vdso/vsgx_enter_enclave.S | 30 ++++++++++++++----------
> > >  1 file changed, 18 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > index 34cee2b0ef09..c56064fb36bc 100644
> > > --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > @@ -17,22 +17,22 @@
> > >  
> > >  /**
> > >   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> > > + * @rdi:	Pass-through value for RDI
> > > + * @rsi:	Pass-through value for RSI
> > > + * @rdx:	Pass-through value for RDX
> > >   * @leaf:	ENCLU leaf, must be EENTER or ERESUME
> > > + * @r8:		Pass-through value for R8
> > > + * @r9:		Pass-through value for R9
> > >   * @tcs:	TCS, must be non-NULL
> > >   * @e:		Optional struct sgx_enclave_exception instance
> > >   * @handler:	Optional enclave exit handler
> > >   *
> > > - * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
> > > - * x86-64 ABI, i.e. cannot be called from standard C code.
> > > - *
> > > - * Input ABI:
> > > - *  @leaf	%eax
> > > - *  @tcs	8(%rsp)
> > > - *  @e 		0x10(%rsp)
> > > - *  @handler	0x18(%rsp)
> > > - *
> > > - * Output ABI:
> > > - *  @ret	%eax
> > > + * **Important!**  __vdso_sgx_enter_enclave() does not ensure full compliance
> > 
> > I'd simply put **NOTE** here instead of **Important!** as it is more
> > common.
> > 
> > > + * with the x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.
> > > + * Except for non-volatile general purpose registers, preserving/setting state
> > > + * in accordance with the x86-64 ABI is the responsibility of the enclave and
> > > + * its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
> > > + * without careful consideration by both the enclave and its runtime.
> > 
> > Instead "e.g. doesn't explcitly clear EFLAGS.DF after EEXIT" (which is
> > somewhat confusing statement) paragraph should be replaced with a simple
> > enumerated list of differences.
> 
> I don't think the list is that simple, e.g. there is a lot of state that
> is defined by the ABI that isn't touched, IMO talking about that state will
> add confusion.
> 
> I also don't understand what's confusing about stating EFLAGS.DF isn't
> cleared.

Too much time was has passed since the last version, and too many
patches have been reviewed since.

Please just refresh the way you feel best and I will make conclusions
based on that. It's faster that way in the end.

/Jarkko
