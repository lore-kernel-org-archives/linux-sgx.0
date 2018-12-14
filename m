Return-Path: <SRS0=odJq=OX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39C3C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 18:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F15E9204FD
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 18:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbeLNSha (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Dec 2018 13:37:30 -0500
Received: from mga18.intel.com ([134.134.136.126]:50238 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbeLNSh3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Dec 2018 13:37:29 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Dec 2018 10:37:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,354,1539673200"; 
   d="scan'208";a="118889160"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga001.jf.intel.com with ESMTP; 14 Dec 2018 10:37:28 -0800
Date:   Fri, 14 Dec 2018 10:37:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v4 5/5] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181214183728.GD22063@linux.intel.com>
References: <20181213213135.12913-1-sean.j.christopherson@intel.com>
 <20181213213135.12913-6-sean.j.christopherson@intel.com>
 <cda13cff-1a56-a40f-7d69-f0f1ab752f8e@fortanix.com>
 <20181214151204.GA22063@linux.intel.com>
 <20181214153830.GB22063@linux.intel.com>
 <20181214170310.GC22063@linux.intel.com>
 <20181214182039.GA3883@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181214182039.GA3883@localhost>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 14, 2018 at 10:20:39AM -0800, Josh Triplett wrote:
> On Fri, Dec 14, 2018 at 09:03:11AM -0800, Sean Christopherson wrote:
> > On Fri, Dec 14, 2018 at 07:38:30AM -0800, Sean Christopherson wrote:
> > > On Fri, Dec 14, 2018 at 07:12:04AM -0800, Sean Christopherson wrote:
> > > > On Fri, Dec 14, 2018 at 09:55:49AM +0000, Jethro Beekman wrote:
> > > > > On 2018-12-14 03:01, Sean Christopherson wrote:
> > > > > >+2:	pop	%rbx
> > > > > >+	pop	%r12
> > > > > >+	pop	%r13
> > > > > >+	pop	%r14
> > > > > >+	pop	%r15
> > > > > >+	pop	%rbp
> > > > > >+	ret
> > > > > 
> > > > > x86-64 ABI requires that you call CLD here (enclave may set it).
> > > > 
> > > > Ugh.  Technically MXCSR and the x87 CW also need to be preserved.
> > > > 
> > > > What if rather than treating the enclave as hostile we require it to be
> > > > compliant with the x86-64 ABI like any other function?  That would solve
> > > > the EFLAGS.DF, MXCSR and x87 issues without adding unnecessary overhead.
> > > > And we wouldn't have to save/restore R12-R15.  It'd mean we couldn't use
> > > > the stack's red zone to hold @regs and @e, but that's poor form anyways.
> > > 
> > > Grr, except the processor crushes R12-R15, FCW and MXCSR on asynchronous
> > > exits.  But not EFLAGS.DF, that's real helpful.
> > 
> > I can think of three options that are at least somewhat reasonable:
> > 
> >   1) Save/restore MXCSR and FCW
> > 
> >      + 100% compliant with the x86-64 ABI
> >      + Callable from any code
> >      + Minimal documentation required
> >      - Restoring MXCSR/FCW is likely unnecessary 99% of the time
> >      - Slow
> > 
> >   2) Clear EFLAGS.DF but not save/restore MXCSR and FCW
> > 
> >      + Mostly compliant with the x86-64 ABI
> >      + Callable from any code that doesn't use SIMD registers
> >      - Need to document deviations from x86-64 ABI
> > 
> >   3) Require the caller to save/restore everything.
> > 
> >      + Fast
> >      + Userspace can pass all GPRs to the enclave (minus EAX, RBX and RCX)
> >      - Completely custom ABI
> >      - For all intents and purposes must be called from an assembly wrapper
> > 
> > 
> > Option (3) actually isn't all that awful.  RCX can be used to pass an
> > optional pointer to a 'struct sgx_enclave_exception' and we can still
> > return standard error codes, e.g. -EFAULT.
> 
> Entering and exiting a syscall requires an assembly wrapper, and that
> doesn't seem completely unreasonable. It's an easy bit of inline
> assembly.

The code I posted had a few typos (stupid AT&T syntax), but with those
fixed the idea checks out.

My initial reaction to a barebones ABI was that it would be a
"documentation nightmare", but it's not too bad if it returns actual
error codes and fills in a struct on exceptions instead of stuffing
registers.  And with the MXCSR/FCW issues it might actually be less
documentation in the long run since we can simply say that all state
is the caller's responsibility.

I *really* like that we basically eliminate bikeshedding on which GPRs
to pass to/from the enclave.
