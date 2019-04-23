Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80822C10F03
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 20:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50605217D9
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 20:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfDWULn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Apr 2019 16:11:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:22906 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfDWULm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Apr 2019 16:11:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Apr 2019 13:11:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,386,1549958400"; 
   d="scan'208";a="145232471"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga007.fm.intel.com with ESMTP; 23 Apr 2019 13:11:41 -0700
Date:   Tue, 23 Apr 2019 13:11:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Cedric Xing <cedric.xing@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave <dave.hansen@intel.com>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge <serge.ayoun@intel.com>,
        Shay <shay.katz-zamir@intel.com>,
        Haitao <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kai <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai <kai.huang@intel.com>, David Rientjes <rientjes@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [RFC PATCH v1 3/3] selftests/x86: Augment SGX selftest to test
 new __vdso_sgx_enter_enclave() and its callback interface
Message-ID: <20190423201140.GB12691@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <cover.1555965327.git.cedric.xing@intel.com>
 <f82e81c9cae31634684964d3fc4e9637e7565c69.1555965327.git.cedric.xing@intel.com>
 <CALCETrWpMxoX00SfnCgYdNbT5JmnzHNJ+73NmUjebBEjk7DuJA@mail.gmail.com>
 <20190423185937.GD10720@linux.intel.com>
 <CALCETrWcJw7+tSni3zp4kO=r6gVGkVDnc2477fPg0ErUzvJAKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWcJw7+tSni3zp4kO=r6gVGkVDnc2477fPg0ErUzvJAKg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 23, 2019 at 12:07:26PM -0700, Andy Lutomirski wrote:
> On Tue, Apr 23, 2019 at 11:59 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Mon, Apr 22, 2019 at 06:29:06PM -0700, Andy Lutomirski wrote:
> > > What's not tested here is running this code with EFLAGS.TF set and
> > > making sure that it unwinds correctly.  Also, Jarkko, unless I missed
> > > something, the vDSO extable code likely has a bug.  If you run the
> > > instruction right before ENCLU with EFLAGS.TF set, then do_debug()
> > > will eat the SIGTRAP and skip to the exception handler.  Similarly, if
> > > you put an instruction breakpoint on ENCLU, it'll get skipped.  Or is
> > > the code actually correct and am I just remembering wrong?
> >
> > The code is indeed broken, and I don't see a sane way to make it not
> > broken other than to never do vDSO fixup on #DB or #BP.  But that's
> > probably the right thing to do anyways since an attached debugger is
> > likely the intended recipient the 99.9999999% of the time.
> >
> > The crux of the matter is that it's impossible to identify whether or
> > not a #DB/#BP originated from within an enclave, e.g. an INT3 in an
> > enclave will look identical to an INT3 at the AEP.  Even if hardware
> > provided a magic flag, #DB still has scenarios where the intended
> > recipient is ambiguous, e.g. data breakpoint encountered in the enclave
> > but on an address outside of the enclave, breakpoint encountered in the
> > enclave and a code breakpoint on the AEP, etc...
> 
> Ugh.  It sounds like ignoring the fixup for #DB is the right call.
> But what happens if the enclave contains an INT3 or ICEBP instruction?
>  Are they magically promoted to #GP, perhaps?

#UD for opt-out, a.k.a. non-debug, enclaves.  Delivered "normally" for
opt-in debug enclaves, except they're fault-like instead of trap-like.

> As a maybe possible alternative, if we made it so that the AEX address
> was not the same as the ENCLU, could we usefully distinguish these
> exceptions based on RIP?

Not really, because a user could set a code breakpoint on the AEX or
insert an INT3, e.g. to break on exit from the enclave.

Theoretically the kernel could cross-reference addresses to determine
whether or not a DRx match occurred on an enclave address, but a) that'd
be pretty ugly to implement and b) there would still be ambiguity, e.g. if
there's a code breakpoint on the AEX and a #DB occurs in the enclave, then
DR6 will record both the in-enclave DRx match and the AEX (non-enclave)
DRx match.

> I suppose it's also worth considering
> whether page faults from *inside* the enclave should result in SIGSEGV
> or result in a fixup.  We certainly want page faults from the ENCLU
> instruction itself to get fixed up, but maybe we want most exceptions
> inside the enclave to work a bit differently.  Of course, if we do
> this, we need to make sure that the semantics of returning from the
> signal handler are reasonable.

Hmm, I'm pretty sure any fault that is 100% in the domain of the enclave
should result in fixup.

Here are a few use cases off the top of my head that would require the
enclave's runtime to intercept the signal, either to reenter the enclave
or to feed the fault into the enclave's handler:

  - Handle EPC invalidation, e.g. due to VM migration, while a thread is
    in the enclave since the resulting #PF can occur inside the enclave.

  - During enclave development, configure the runtime to call into the
    enclave on any exception so that the enclave can dump register state.

  - Implement copy-on-write or lazy allocation using SGX2 instructions,
    which would require feeding the #PF back into the enclave.  Purely
    theoretical AFAIK, but lazy allocation in particular could be
    interesting, e.g. don't allocate .bss pages at startup time.

  - An enclave and its runtime might feed #UDs back into the enclave,
    e.g. to run an unmodified binary in an enclave by wrapping it in a
    shim of sorts.
