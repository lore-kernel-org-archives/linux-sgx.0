Return-Path: <SRS0=odJq=OX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992B3C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 18:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE671206BA
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 18:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbeLNSYz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Dec 2018 13:24:55 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:56112 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729752AbeLNSYy (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 14 Dec 2018 13:24:54 -0500
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 939343A3B5A
        for <linux-sgx@vger.kernel.org>; Fri, 14 Dec 2018 19:20:57 +0100 (CET)
X-Originating-IP: 134.134.139.75
Received: from localhost (jfdmzpr06-ext.jf.intel.com [134.134.139.75])
        (Authenticated sender: josh@joshtriplett.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 16D4EFF80A;
        Fri, 14 Dec 2018 18:20:43 +0000 (UTC)
Date:   Fri, 14 Dec 2018 10:20:39 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Message-ID: <20181214182039.GA3883@localhost>
References: <20181213213135.12913-1-sean.j.christopherson@intel.com>
 <20181213213135.12913-6-sean.j.christopherson@intel.com>
 <cda13cff-1a56-a40f-7d69-f0f1ab752f8e@fortanix.com>
 <20181214151204.GA22063@linux.intel.com>
 <20181214153830.GB22063@linux.intel.com>
 <20181214170310.GC22063@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181214170310.GC22063@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 14, 2018 at 09:03:11AM -0800, Sean Christopherson wrote:
> On Fri, Dec 14, 2018 at 07:38:30AM -0800, Sean Christopherson wrote:
> > On Fri, Dec 14, 2018 at 07:12:04AM -0800, Sean Christopherson wrote:
> > > On Fri, Dec 14, 2018 at 09:55:49AM +0000, Jethro Beekman wrote:
> > > > On 2018-12-14 03:01, Sean Christopherson wrote:
> > > > >+2:	pop	%rbx
> > > > >+	pop	%r12
> > > > >+	pop	%r13
> > > > >+	pop	%r14
> > > > >+	pop	%r15
> > > > >+	pop	%rbp
> > > > >+	ret
> > > > 
> > > > x86-64 ABI requires that you call CLD here (enclave may set it).
> > > 
> > > Ugh.  Technically MXCSR and the x87 CW also need to be preserved.
> > > 
> > > What if rather than treating the enclave as hostile we require it to be
> > > compliant with the x86-64 ABI like any other function?  That would solve
> > > the EFLAGS.DF, MXCSR and x87 issues without adding unnecessary overhead.
> > > And we wouldn't have to save/restore R12-R15.  It'd mean we couldn't use
> > > the stack's red zone to hold @regs and @e, but that's poor form anyways.
> > 
> > Grr, except the processor crushes R12-R15, FCW and MXCSR on asynchronous
> > exits.  But not EFLAGS.DF, that's real helpful.
> 
> I can think of three options that are at least somewhat reasonable:
> 
>   1) Save/restore MXCSR and FCW
> 
>      + 100% compliant with the x86-64 ABI
>      + Callable from any code
>      + Minimal documentation required
>      - Restoring MXCSR/FCW is likely unnecessary 99% of the time
>      - Slow
> 
>   2) Clear EFLAGS.DF but not save/restore MXCSR and FCW
> 
>      + Mostly compliant with the x86-64 ABI
>      + Callable from any code that doesn't use SIMD registers
>      - Need to document deviations from x86-64 ABI
> 
>   3) Require the caller to save/restore everything.
> 
>      + Fast
>      + Userspace can pass all GPRs to the enclave (minus EAX, RBX and RCX)
>      - Completely custom ABI
>      - For all intents and purposes must be called from an assembly wrapper
> 
> 
> Option (3) actually isn't all that awful.  RCX can be used to pass an
> optional pointer to a 'struct sgx_enclave_exception' and we can still
> return standard error codes, e.g. -EFAULT.

Entering and exiting a syscall requires an assembly wrapper, and that
doesn't seem completely unreasonable. It's an easy bit of inline
assembly.
