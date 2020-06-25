Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF8EC433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 15:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B0972082F
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 15:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405796AbgFYPec (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 11:34:32 -0400
Received: from mga07.intel.com ([134.134.136.100]:6648 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405394AbgFYPec (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 11:34:32 -0400
IronPort-SDR: GGRcZ/wCAo9cc4fdncE0oxucWWfeuyoeEyi2wFF0TEwqr0nljCIE5KheVl/A++0ZL/G+DonI55
 q4pRnvcE+UQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="210031095"
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="210031095"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 08:34:31 -0700
IronPort-SDR: 3GIJns1tWCRZA+fbNw0iIve4yKZPs3ze4nNULoybsh4ybp5i16GWZIEyTN1PDTsIztA71kglHh
 AQ9beHulwVaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="276056189"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 25 Jun 2020 08:34:31 -0700
Date:   Thu, 25 Jun 2020 08:34:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 03/21] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20200625153431.GA3437@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-4-jarkko.sakkinen@linux.intel.com>
 <20200625085931.GB20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625085931.GB20319@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 10:59:31AM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:25AM +0300, Jarkko Sakkinen wrote:
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 66be9bd60307..25d48aae36c1 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -1055,6 +1055,19 @@ access_error(unsigned long error_code, struct vm_area_struct *vma)
> >  	if (error_code & X86_PF_PK)
> >  		return 1;
> >  
> > +	/*
> > +	 * Access is blocked by the Enclave Page Cache Map (EPCM), i.e. the
> > +	 * access is allowed by the PTE but not the EPCM. This usually happens
> > +	 * when the EPCM is yanked out from under us, e.g. by hardware after a
> > +	 * suspend/resume cycle. In any case, software, i.e. the kernel, can't
> > +	 * fix the source of the fault as the EPCM can't be directly modified by
> > +	 * software. Handle the fault as an access error in order to signal
> > +	 * userspace so that userspace can rebuild their enclave(s), even though
> > +	 * userspace may not have actually violated access permissions.
> > +	 */
> 
> Lemme check whether I understand this correctly: userspace must check
> whether the SIGSEGV is generated on an access to an enclave page?

Sort of.  Technically it's that's an accurate statement, but practically
speaking userspace can only access enclave pages when it is executing in
the enclave, and exceptions in enclaves have unique behavior.  Exceptions
in enclaves essentially bounce through a userspace-software-defined
location prior to being delivered to the kernel.  The trampoline is done
by the CPU so that the CPU can scrub the GPRs, XSAVE state, etc... and
hide the true RIP of the exception.  The pre-exception enclave state is
saved into protected memory and restored when userspace resumes the enclave.

Enterring or resuming an enclave can only be done through dedicted ENCLU
instructions, so really it ends up being that the SIGSEGV handler needs to
check the IP that "caused" the fault, which is actually the IP of the
trampoline.

But, that's only the first half of the story...
 
> Also, do I see it correctly that when this happens, dmesg will have
> 
>         printk("%s%s[%d]: segfault at %lx ip %px sp %px error %lx",
> 
> due to:
> 
>        if (likely(show_unhandled_signals))
>                show_signal_msg(regs, error_code, address, tsk);
> 
> which does:
> 
>         if (!unhandled_signal(tsk, SIGSEGV))
>                 return;
> 
> or is the task expected to register a SIGSEGV handler so that the
> segfault doesn't land in dmesg?

Yes, without extra help, any task running an enclave is expected to register
a SIGSEGV handler so that the task can restart the enclave if the EPC is
"lost".

However, building and running enclaves is complex, and the vast majority of
SGX enabled applications are expected to leverage a library of one kind or
another to hand the bulk of the gory details.  But, signal handling in
libraries is a mess, e.g. requires filtering/forwarding, resignaling, etc...

To that end, in v14 of this patch[1], Andy Lutomirski came up with the idea
of adding a vDSO function to provide the low level enclave EENTER/ERESUME and
trampoline, and then teaching the kernel to do exception fixup on the
relevant instructions in the vDSO.  The vDSO's exception fixup then returns
to normal userspace, with a (technically optional) struct holding the details
of the exception.  That allows for synchronous delivery of exceptions in
enclaves, obviates the need for userspace to regsiter a SIGSEGV handler, and
also means the SIGSEGV will never show up in dmesg so long as userspace is
using the vDSO.  The kernel still supports direct EENTER/ERESUME, but AFAIK
everyone is moving (or has moved) to the vDSO interface.

The vDSO stuff is in patches 15-18 of this series.

There's a gigantic thread on all the alternatives that were considered[2].

[1] https://lkml.kernel.org/r/CALCETrXByb2UVuZ6AXUeOd8y90NAikbZuvdN3wf_TjHZ+CxNhA@mail.gmail.com
[2] https://lkml.kernel.org/r/CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com

> 
> If so, are we documenting this?
> 
> If not, then we should not issue any "segfault" messages to dmesg
> because that would be wrong.
> 
> Or maybe I'm not seeing it right but I don't have the hardware to test
> this out...
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
