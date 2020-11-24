Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFB7C2D0E4
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Nov 2020 21:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA3020715
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Nov 2020 21:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tF7koIwH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388339AbgKXV5U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Nov 2020 16:57:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731713AbgKXV5R (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Nov 2020 16:57:17 -0500
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0310C2151B
        for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2020 21:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606255036;
        bh=NKTa7dLhb4WX8DpX7xxrijkL1HVS8VWwDbB2EYzcFFE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tF7koIwHqUeAdU8NWI/Ej9UosKw2qWRr+G7VezLm2Ut1X1AZtEUzEoKlI4TV5PwqH
         Bw/Tp2DNpIvXuxgWuuypsFuvMLNa0Fa5BE3cwQmoMom9lEscuo35I/08SpNcTxkzrW
         aaPmSsB4q5Zv5pmYvp/7c1DhpM4X37R4HBId+jmA=
Received: by mail-wr1-f53.google.com with SMTP id g14so8665863wrm.13
        for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2020 13:57:15 -0800 (PST)
X-Gm-Message-State: AOAM533Z4A6m9c8ct7KXCW7IOO7DGrtc40kYFLYpm1yIfY1E2Px/KXQf
        dM1oUKQvQdiW9iqOalQ/BgVxskQLgprAvUUwGjGnsg==
X-Google-Smtp-Source: ABdhPJzpjAfkskq+eGhhEjz/1Bf+L0y9f7ytY47+jSjxHLhcliLc+rleBGHbHj5kg0aLz20bkhHnz74/gVM80kgd90E=
X-Received: by 2002:a5d:4e87:: with SMTP id e7mr634055wru.70.1606255034259;
 Tue, 24 Nov 2020 13:57:14 -0800 (PST)
MIME-Version: 1.0
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201121151259.GA3948@wind.enjellic.com> <CALCETrXTjZSg-ccDKF7yX8y+vCCrcn9C_m6ZCGNdWHq73aUHQQ@mail.gmail.com>
 <20201124184039.GA22484@wind.enjellic.com>
In-Reply-To: <20201124184039.GA22484@wind.enjellic.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 24 Nov 2020 13:57:00 -0800
X-Gmail-Original-Message-ID: <CALCETrUDoMKRsB8EHNo1iZB-KxidWB_LCivReE6DvCT2HQ2PzQ@mail.gmail.com>
Message-ID: <CALCETrUDoMKRsB8EHNo1iZB-KxidWB_LCivReE6DvCT2HQ2PzQ@mail.gmail.com>
Subject: Re: [PATCH v40 00/24] Intel SGX foundations
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Mikko Ylinen <mikko.ylinen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 24, 2020 at 10:40 AM Dr. Greg <greg@enjellic.com> wrote:
>
> On Sat, Nov 21, 2020 at 10:36:58AM -0800, Andy Lutomirski wrote:
>

> Intel SGX developer licensing requires that you provide application
> recipients with a full and complete runtime along with the signed
> application.  Our developer license allowed us to substitute our
> runtime for Intel's.

Upstream Linux wants nothing to do with Intel's developer licensing.

> > > Given that this driver is no longer locked to the Intel trust root, by
> > > virtue of being restricted to run only on platforms which support
> > > Flexible Launch Control, there is no longer any legitimate technical
> > > reason to not expose all of the functionality of the hardware.
>
> > I read this three times, and I can't tell what functionality you're
> > referring to.
>
> Yes you do, as I mentioned to Dave in my last e-mail, we have been
> disagreeing about this for a year.

No, I don't.  It's entirely possible that I'm aware of the
functionality you're referring to, but that doesn't mean that your
description quoted above is sufficient for me to have the slightest
idea which functionality you mean right here.

>
> You were at some kind of seminar where SGX was discussed.  Based on
> that you developed a 'manifesto' regarding how Linux should implement
> the technology.  That manifesto indicated there would be no place for
> cryptographic policy control on enclaves.

That's not what I said.  Paraphrasing myself, I said that there is no
place for a driver in upstream Linux that allows only Intel-approved
code to run.  That is not at all the same thing as saying we won't
support cryptographic policy in a way that allows the platform owner
an appropriate degree of control.

Actually supporting launch control (the EINIT-enforced kind) in
upstream Linux will be tricky but is surely possible.  It would
probably help if Intel or firmware vendors had some clear
specification of exactly how they intend for platform owners to select
an SGXLEPUBKEYHASH value.  (A nice spec in which an authenticated UEFI
variable contained the desired SGXLEPUBKEYHASH and lock state might be
an excellent start.)  Supporting this in upstream Linux will also
require decoupling the user code that creates an enclave from the user
code that invokes the LE.  Jarkko already wrote some code for this,
and it could be revived.  If this ends up being inconsistent with
Intel's licensing requirements, then Intel can change their licensing
requirements or people can just ignore Intel and use a different
signing key.

Frankly, using Intel's signing key in SGXLEPUBKEYHASH offers a dubious
degree of protection in the first place -- it assumes that Intel will
never approve a malware enclave, and it also assumes that the lack of
functioning EINITTOKEN revocation won't break the whole scheme.

>
> A well taken and considered point on a locked launch control platform
> but completely irrelevant for this driver, that only operates on
> Flexible Launch Control platforms.  By demanding compliance with only
> that vision you deny platform owners a final measure of defense
> against anonymous code execution.

I am denying Intel the chance to impose their licensing requirements.
The fact that Intel chose to poison the well with their licensing
system and that, as a result, Linux won't support the Intel model of
launch control to protect platform owners is an unfortunate side
effect.

>
> > > The patch that I am including below implements signature based policy
> > > controls for enclave initialization.  It does so in a manner that is
> > > completely transparent to the default behavior of the driver, which is
> > > to initialize any enclave passed to it with the exception of enclaves
> > > that set the PROVISION_KEY attribute bit.
>
> > It's completely unreviewable.  It's an ABI patch, and it does not
> > document what it does, nor does it document why it does it.  It's
> > just a bunch of code.  NAK.
>
> You can certainly NAK-away Andy[0]. I've had sufficent private
> feedback from reasoned and informed individuals that I've made my
> point that this isn't about technical considerations.

Depends on what you mean by "technical".  In the submitting-patches
guide (https://www.kernel.org/doc/html/v5.9/process/submitting-patches.html),
you will find instructions to "describe your changes" and "separate
your changes".  If you can produce a reasonably, reviewable submission
of your code, I will review it.  But I am not going to dig through
your diff to try to find the hidden technical merit.

>
> Here is the link, again, to the patch in 'git am' compliant format.
>
> ftp://ftp.enjellic.com/pub/sgx/kernel/SFLC-v41.patch
>
> I've been watching Linux patches go by for close to 30 years.  If this
> is completely unreviewable garbage, legitimate concerns can be raised
> about what is getting pushed into the kernel.

The kernel review process is by no means perfect.  That does not mean
that you get to apply your unreviewable garbage just because other
people have pulled it off in the past.

> For the LKML record, absent our patch the driver has an open security
> issue with respect to anonymous code execution that should be
> addressed, if that issue is indeed of any concern.

What do you mean?


> The only thing that I can think of is that you disagree with the
> optional capability of blocking the enclave from implementing
> anonymously executable memory.  Absent that ability there is the
> security issue that has now been extensively discussed.

You keep sending a patch that blocks mmap and mprotect on an
initialized enclave.  As far as I can tell, you haven't explained how
it's any better than the code it replaces.  The code it replaces
enforces per-page maximum permissions, and all the infrastructure is
in place for the platform owner to be able to enforce their rules
without breaking ABI.

Your proposal appears to accomplish something a little bit like what
the code in -tip does, except without as much room for future
improvements.  Since you haven't tried to explain why you think it's
better, I can't really evaluate it.
