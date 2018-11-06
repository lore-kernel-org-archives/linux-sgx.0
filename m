Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6A8C32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 23:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65C7F20827
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 23:40:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="sv/URmoD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65C7F20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbeKGJHq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Nov 2018 04:07:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731055AbeKGJHq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Nov 2018 04:07:46 -0500
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FBFA208E7
        for <linux-sgx@vger.kernel.org>; Tue,  6 Nov 2018 23:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541547602;
        bh=+uFstgdPuQ7BsxuODoPg3qjcikQEXR5tf05WB+k5kUg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sv/URmoDfGm8gwv8VE4pp24CRfxho3cfscO8RWTGbITTxIxz5aP/nnzP+PrpBR6tL
         bO8/eZq6zmXkeY4Oeg/HodZY8JXcG/CUVjFN1oixYMavvbjyGJa5oMokDZJQ6Wb8IE
         sJv6MJcB1pPtGvz3uRm7ZGWKFXSz0ynUMAiNg2ow=
Received: by mail-wr1-f50.google.com with SMTP id 74-v6so15447759wrb.13
        for <linux-sgx@vger.kernel.org>; Tue, 06 Nov 2018 15:40:02 -0800 (PST)
X-Gm-Message-State: AGRZ1gL67Nev8vmUZDPDRaRbmpmZtG/uZWTISybbTU0AGOH0C3foEP7I
        nJZCGKDaDMlAxang2SOt/quQD/3fVEx0Sbf6mYJJHg==
X-Google-Smtp-Source: AJdET5eApSN83p4uCfdb9YoO+fg+MGmx45YysCtBJod61HLYRnephT2W8JlZ9PtVT5ZEPZVkuCaG9hYqhd/AywTMIlA=
X-Received: by 2002:adf:82c9:: with SMTP id 67-v6mr24043904wrc.131.1541547600631;
 Tue, 06 Nov 2018 15:40:00 -0800 (PST)
MIME-Version: 1.0
References: <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com> <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com> <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com> <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com>
 <1541541565.8854.13.camel@intel.com> <7FF4802E-FBC5-4E6D-A8F6-8A65114F18C7@amacapital.net>
 <20181106233515.GB11101@linux.intel.com>
In-Reply-To: <20181106233515.GB11101@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 6 Nov 2018 15:39:48 -0800
X-Gmail-Original-Message-ID: <CALCETrVySfV64YN7DWf3rsAxfiugJKsRJCNmEn-AKQ4dPYeG4Q@mail.gmail.com>
Message-ID:
 <CALCETrVySfV64YN7DWf3rsAxfiugJKsRJCNmEn-AKQ4dPYeG4Q@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     Andrew Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Carlos O'Donell" <carlos@redhat.com>,
        adhemerval.zanella@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106233948.VWDiSsR_NX3U522xTMKwUH4QDcYTJfFcX86ooNZFG_4@z>

On Tue, Nov 6, 2018 at 3:35 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Nov 06, 2018 at 03:00:56PM -0800, Andy Lutomirski wrote:
> >
> >
> > >> On Nov 6, 2018, at 1:59 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > >>
> > >>> On Tue, 2018-11-06 at 13:41 -0800, Andy Lutomirski wrote:
> > >> Sean, how does the current SDK AEX handler decide whether to do
> > >> EENTER, ERESUME, or just bail and consider the enclave dead?  It seems
> > >> like the *CPU* could give a big hint, but I don't see where there is
> > >> any architectural indication of why the AEX code got called or any
> > >> obvious way for the user code to know whether the exit was fixed up by
> > >> the kernel?
> > >
> > > The SDK "unconditionally" does ERESUME at the AEP location, but that's
> > > bit misleading because its signal handler may muck with the context's
> > > RIP, e.g. to abort the enclave on a fatal fault.
> > >
> > > On an event/exception from within an enclave, the event is immediately
> > > delivered after loading synthetic state and changing RIP to the AEP.
> > > In other words, jamming CPU state is essentially a bunch of vectoring
> > > ucode preamble, but from software's perspective it's a normal event
> > > that happens to point at the AEP instead of somewhere in the enclave.
> > > And because the signals the SDK cares about are all synchronous, the
> > > SDK can simply hardcode ERESUME at the AEP since all of the fault logic
> > > resides in its signal handler.  IRQs and whatnot simply trampoline back
> > > into the enclave.
> > >
> > > Userspace can do something funky instead of ERESUME, but only *after*
> > > IRET/RSM/VMRESUME has returned to the AEP location, and in Linux's
> > > case, after the trap handler has run.
> > >
> > > Jumping back a bit, how much do we care about preventing userspace
> > > from doing stupid things?
> >
> > My general feeling is that userspace should be allowed to do apparently
> > stupid things. For example, as far as the kernel is concerned, Wine and
> > DOSEMU are just user programs that do stupid things. Linux generally tries
> > to provide a reasonably complete view of architectural behavior. This is
> > in contrast to, say, Windows, where IIUC doing an unapproved WRFSBASE May
> > cause very odd behavior indeed. So magic fixups that do non-architectural
> > things are not so great.
>
> Sorry if I'm beating a dead horse, but what if we only did fixup on ENCLU
> with a specific (ignored) prefix pattern?  I.e. effectively make the magic
> fixup opt-in, falling back to signals.  Jamming RIP to skip ENCLU isn't
> that far off the architecture, e.g. EENTER stuffs RCX with the next RIP so
> that the enclave can EEXIT to immediately after the EENTER location.
>

How does that even work, though?  On an AEX, RIP points to the ERESUME
instruction, not the EENTER instruction, so if we skip it we just end
up in lala land.

How averse would everyone be to making enclave entry be a syscall?
The user code would do sys_sgx_enter_enclave(), and the kernel would
stash away the register state (vm86()-style), point RIP to the vDSO's
ENCLU instruction, point RCX to another vDSO ENCLU instruction, and
SYSRET.  The trap handlers would understand what's going on and
restore register state accordingly.

On non-Meltdown hardware (hah!) this would even be fairly fast.

--Andy
