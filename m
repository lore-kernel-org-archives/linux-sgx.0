Return-Path: <SRS0=/5Ao=CE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB15AC433E1
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 18:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8423220737
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 18:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHZScY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Aug 2020 14:32:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:49834 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgHZScX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Aug 2020 14:32:23 -0400
IronPort-SDR: nEuRht4kRznoGXSMJ3AtEBbcOAjLr5Rg740TFUaG3fsrzEsBd1HvccSMFaFPERIrzKMzyN909C
 5S99NXEueHYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="217917316"
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="217917316"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 11:32:22 -0700
IronPort-SDR: IF0RsA/eh21ufC9zs9U60TzMwPrUXWkc0v3uvR2j53UGXiiPWavYwNWd9xFYk5MHUsBc/nQ6Yg
 la4pHpL6Bshw==
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="444143809"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 11:32:22 -0700
Date:   Wed, 26 Aug 2020 11:32:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the
 vDSO loop on interrupts
Message-ID: <20200826183220.GB21065@sjchrist-ice>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-5-sean.j.christopherson@intel.com>
 <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
 <6109f3e1-0579-67c6-0a02-f9b931ba1fac@fortanix.com>
 <CALCETrW94nC5jtQcn7tCMm4itrGSbpxSadtyQUJ=UcR4bFPJ4Q@mail.gmail.com>
 <8603e74e-6484-6e28-164f-2b0f908d5986@fortanix.com>
 <CALCETrVTxdssjtp1+E8RH5wek2FauJTmJhGqp8taBzXVSm6VFQ@mail.gmail.com>
 <9d3e6c56-c491-3449-9d29-ee566e994d4e@fortanix.com>
 <CALCETrWAKLSGS-UuZcegnPSOLSh-7D9AjB82fZ7+or5hvVzj_w@mail.gmail.com>
 <46938c15-24e7-ee80-0cdc-0b35c5a19697@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46938c15-24e7-ee80-0cdc-0b35c5a19697@fortanix.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 24, 2020 at 03:36:29PM +0200, Jethro Beekman wrote:
> On 2020-08-22 23:55, Andy Lutomirski wrote:
> > On Thu, Aug 20, 2020 at 10:53 AM Jethro Beekman <jethro@fortanix.com> wrote:
> >>
> >> On 2020-08-20 19:44, Andy Lutomirski wrote:
> >>> This is a genuine semantic question: is __vdso_sgx_enter_enclave()
> >>> like read on a pipe (returns -EINTR on a signal) or is it more like a
> >>> restartable syscall or a normal library function that just keeps
> >>> running if your signal handler does nothing?  You could siglongjmp()
> >>> out, but that's a bit gross.
> >>>
> >>> I wouldn't object to an option to __vdso_sgx_enter_enclave() to make
> >>> it return -EINTR if signaled by a non-SA_RESTART signal.  Implementing
> >>> it might be distinctly nontrivial, though.
> >>>
> >>> But this isn't what this patch does, and I suspect we've been talking
> >>> past each other.  This patch makes __vdso_sgx_enter_enclave() return
> >>> if there's an *interrupt*.  If you push a keyboard button, move your
> >>> mouse, get a network interrupt on that core, etc, it will return.
> >>> This is nonsense.
> >>
> >> It's not nontrivial to return on signals, this patch does it. This patch *also* returns when there's a HW interrupt, but that's not important.
> > 
> > Allow me to quote the changelog of the patch:
> > 
> > This allows the user's runtime to switch
> > contexts at opportune times without additional overhead, e.g. when using
> > an M:N threading model (where M user threads run N TCSs, with N > M).
> > 
> > NAK.
> > 
> >>
> >> It sounds like you're saying you want to subdivide AEXs into “interrupts
> >> that lead to user-observable signals” and “other interrupts”, and then
> >> hide the second category from the user. I wouldn't object to that, but I
> >> don't know how to code this. It seems like a lot of work compared to the
> >> obvious solution (this patch).
> > 
> > The obvious solution is NAKked.
> > 
> > Does siglongjmp() really not work for you?
> 
> Allow me to quote the changelog of "[PATCH v36 18/24] x86/vdso: Add support
> for exception fixup in vDSO functions":
> 
> Putting everything together, userspace enclaves will utilize a library
> that must be prepared to handle any and (almost) all exceptions any time
> at least one thread may be executing in an enclave.  Leveraging signals
> to handle the enclave exceptions is unpleasant, to put it mildly, e.g.
> the SGX library must constantly (un)register its signal handler based
> on whether or not at least one thread is executing in an enclave, and
> filter and forward exceptions that aren't related to its enclaves.  This
> becomes particularly nasty when using multiple levels of libraries that
> register signal handlers, e.g. running an enclave via cgo inside of the
> Go runtime.
> 
> 
> If I could use signal handlers I wouldn't use the VDSO call. (Corollary: if I
> wasn't using the VDSO call, I wouldn't have to think about this because what
> I want is already supported).

Jethro, I think what you're requesting is simply not possible.  Or rather,
the SGX vDSO can't provide any additional value relative to what can be
provided by userspace.

What Andy is saying is that having the vDSO take action on interrupts is
undesirable/NAK'd from a kernel perspective, as it's ugly and unreliable.
It happens to mostly work for SIGALRM because there is an interrupt
associated with the expiration of the timer[*].  But even then it will
work if and only if the interrupt arrives while the enclave is running.
If the interrupt arrives just before ENCLU, either on initial entry or
on resume from the callback, SIGALRM will be delivered and the userspace
M:N scheduler that is relying on an exit from the enclave will miss its
"tick".

The vDSO could check for pending signals, but that effectively provides no
value as opposed to checking for signals in the callback (or caller).

The goal of the SGX vDSO is to obviate the need for handling signals that
are due to exceptions that are directly associated with the enclave.  IMO,
the SIGALRM request is completely out of scope as it is not a problem that
is unique to SGX, i.e. wanting to do M:N scheduling in a library without
hooking SIGALRM is a generic request.  The fact that the SGX architcture has
a quirk that allows for a semi-functional hack is not justification for
supporting such a hack in the kernel.

[*] Is it even guaranteed that an interrupt will precede SIGALRM?  Not that
    it matters for this discussion.
