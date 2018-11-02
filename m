Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC4AC65C22
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 23:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63AC32081F
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 23:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wD37VH3a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63AC32081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbeKCIqQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 04:46:16 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38039 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbeKCIqQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 3 Nov 2018 04:46:16 -0400
Received: by mail-oi1-f196.google.com with SMTP id v83-v6so2932742oia.5
        for <linux-sgx@vger.kernel.org>; Fri, 02 Nov 2018 16:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jfYvcq+Fk861HVzgrZI/Rl6MCadmc/WXcbYl1AODkY=;
        b=wD37VH3aZ1yqxWfmHtL2lxtgMfTbh/SVuukLl7ppDBpwVGPugJSO2A07VVghuijE4Q
         zo6Fr6NSUqGrkAuxhEWMNSn7+dvSnzjiP/A5l9aDdUEDAZSafCLZmZewZLO0ThfuIrFT
         MaV6nC+c50TQh+oJmGwOpRsootk2GPngD9wUq/hkw6vvvRAznQ4VZCoyGHKI2Nd21kEa
         Av1CmfMjXaNYoAZm0xnT1c5BGjn+EVJU0TO/4te2GuKcaHwoDgm3JBGfqwx43+RfTxFh
         mPQw4u7icrLDC7jkj4Rf3r0xRA+M5zQBEuwUdE8VBPeuL849aptz0+BPgKoCOKHnwwvS
         /Xrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jfYvcq+Fk861HVzgrZI/Rl6MCadmc/WXcbYl1AODkY=;
        b=QJizPekw4XvhdDZBSnDzb4Yrw9AUFHWjhuwTdvttktCI6icdn1iI3waHv/t0y7d57w
         pQEny3TnOmCHA/qkjBGfGrPNZ/Py1JZx77L4OKaD75BaxXFtFNW6nQnLnGLkqTSBrmMb
         9V9jpCr1NETjNfq6aptqnhie/4boLdQOH46SND13E1lX54nbzqHZZjATrTq09a7btNgc
         dpVh8GeQc3+dD02xrcx7lZilebCUuqmtfY3wSyHNoY+Y+x2B/y3DngU7XSUNW2JJbGio
         9AMd4LF+ABR1lfsJeqFdNqSiRRUlQZIE5vWBnBoecBa7XdxGZrGkVT0/1+467ka3UODh
         7hCQ==
X-Gm-Message-State: AGRZ1gJYSkMO1qHQMyi3gcV3v+vVxdl7RPXeWils6UspCCEDZUdNLyzD
        owNIrsuQWiGlrH/EOVem1eVQLG3Ow4AO2lAzPukCsA==
X-Google-Smtp-Source: AJdET5er+s6zSIGVaVrke+9ZR1pnUbItdXG6XAO6H8RVyp1T7GnsnKinwrzu66Ws9dZpjVG/7QeoF6zkIOaQuD47yJM=
X-Received: by 2002:aca:efd6:: with SMTP id n205-v6mr7538990oih.3.1541201822909;
 Fri, 02 Nov 2018 16:37:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
 <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
 <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
 <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
In-Reply-To: <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Sat, 3 Nov 2018 00:36:36 +0100
Message-ID:
 <CAG48ez2J9wRNDs0vhNVvVG4swjF8cA5n4T0vQnKixdPCaXVpHQ@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     Andy Lutomirski <luto@kernel.org>
Cc:     sean.j.christopherson@intel.com,
        Dave Hansen <dave.hansen@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        dalias@libc.org, Dave Hansen <dave.hansen@linux.intel.com>,
        jethro@fortanix.com, jarkko.sakkinen@linux.intel.com,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        andriy.shevchenko@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        carlos@redhat.com, adhemerval.zanella@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181102233636.zpeoStiZ-feAGK78bICJg4_Q8sLiHX9f8fDZ49sjOwU@z>

On Sat, Nov 3, 2018 at 12:32 AM Andy Lutomirski <luto@kernel.org> wrote:
> On Fri, Nov 2, 2018 at 4:28 PM Jann Horn <jannh@google.com> wrote:
> > On Fri, Nov 2, 2018 at 11:04 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > > On Fri, Nov 02, 2018 at 08:02:23PM +0100, Jann Horn wrote:
> > > > On Fri, Nov 2, 2018 at 7:27 PM Sean Christopherson
> > > > <sean.j.christopherson@intel.com> wrote:
> > > > > On Fri, Nov 02, 2018 at 10:48:38AM -0700, Andy Lutomirski wrote:
> > > > > > This whole mechanism seems very complicated, and it's not clear
> > > > > > exactly what behavior user code wants.
> > > > >
> > > > > No argument there.  That's why I like the approach of dumping the
> > > > > exception to userspace without trying to do anything intelligent in
> > > > > the kernel.  Userspace can then do whatever it wants AND we don't
> > > > > have to worry about mucking with stacks.
> > > > >
> > > > > One of the hiccups with the VDSO approach is that the enclave may
> > > > > want to use the untrusted stack, i.e. the stack that has the VDSO's
> > > > > stack frame.  For example, Intel's SDK uses the untrusted stack to
> > > > > pass parameters for EEXIT, which means an AEX might occur with what
> > > > > is effectively a bad stack from the VDSO's perspective.
> > > >
> > > > What exactly does "uses the untrusted stack to pass parameters for
> > > > EEXIT" mean? I guess you're saying that the enclave is writing to
> > > > RSP+[0...some_positive_offset], and the written data needs to be
> > > > visible to the code outside the enclave afterwards?
> > >
> > > As is, they actually do it the other way around, i.e. negative offsets
> > > relative to the untrusted %RSP.  Going into the enclave there is no
> > > reserved space on the stack.  The SDK uses EEXIT like a function call,
> > > i.e. pushing parameters on the stack and making an call outside of the
> > > enclave, hence the name out-call.  This allows the SDK to handle any
> > > reasonable out-call without a priori knowledge of the application's
> > > maximum out-call "size".
> >
> > But presumably this is bounded to be at most 128 bytes (the red zone
> > size), right? Otherwise this would be incompatible with
> > non-sigaltstack signal delivery.
>
>
> I think Sean is saying that the enclave also updates RSP.

Ah, bleh, of course.
