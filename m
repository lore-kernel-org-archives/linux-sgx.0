Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370DCC32789
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 23:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE652081F
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 23:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zhzgU7QS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEE652081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbeKCIl6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 04:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbeKCIl6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Nov 2018 04:41:58 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E78F20848
        for <linux-sgx@vger.kernel.org>; Fri,  2 Nov 2018 23:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541201566;
        bh=4dxCewbtnfxDrWK9IPS49qvQeMRU68tFk5tBneTDDsY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zhzgU7QSrzSf2prnSRUXgIBdnLOvhN9QSq1dEiz5Tepy+L7PLTUCzt5VLFJMn+GOu
         bHuJoNXc73Sx/EG9RAgOLHkZX6HaH0XIsjanLPUAFmgFOramoKDjWSsu9uKz0l9Eov
         sM1CMnC2JuoMrFPZMH4uA9XKdkmO0HHt9tUsLRwA=
Received: by mail-wm1-f52.google.com with SMTP id a8-v6so3135699wmf.1
        for <linux-sgx@vger.kernel.org>; Fri, 02 Nov 2018 16:32:46 -0700 (PDT)
X-Gm-Message-State: AGRZ1gJEekPgXqUl0p75RZY5EsG2RcBSjyeZLOUkeBQDdGpYVcaUdGJs
        7ZvaxfnpbqXse6aOl6qbg6eM6tAzzOlDT8xy8eI7mg==
X-Google-Smtp-Source: AJdET5ePaYIz/UnhkHufxcoUBhx2oWNda7nTMmoQIOK9UEhBQjXJy2Xrk4xJRf7zym9ps+lfg4q5PxSS+M7rEWvCxtE=
X-Received: by 2002:a1c:410a:: with SMTP id o10-v6mr10379wma.19.1541201564661;
 Fri, 02 Nov 2018 16:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
 <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
 <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
In-Reply-To: <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 2 Nov 2018 16:32:32 -0700
X-Gmail-Original-Message-ID: <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
Message-ID:
 <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     Jann Horn <jannh@google.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <20181102233232.JjPcI3jgoR3Aqv8fPl390OAvc4CKlYi7j8YPHbof0TQ@z>

On Fri, Nov 2, 2018 at 4:28 PM Jann Horn <jannh@google.com> wrote:
>
> On Fri, Nov 2, 2018 at 11:04 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > On Fri, Nov 02, 2018 at 08:02:23PM +0100, Jann Horn wrote:
> > > On Fri, Nov 2, 2018 at 7:27 PM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > > On Fri, Nov 02, 2018 at 10:48:38AM -0700, Andy Lutomirski wrote:
> > > > > This whole mechanism seems very complicated, and it's not clear
> > > > > exactly what behavior user code wants.
> > > >
> > > > No argument there.  That's why I like the approach of dumping the
> > > > exception to userspace without trying to do anything intelligent in
> > > > the kernel.  Userspace can then do whatever it wants AND we don't
> > > > have to worry about mucking with stacks.
> > > >
> > > > One of the hiccups with the VDSO approach is that the enclave may
> > > > want to use the untrusted stack, i.e. the stack that has the VDSO's
> > > > stack frame.  For example, Intel's SDK uses the untrusted stack to
> > > > pass parameters for EEXIT, which means an AEX might occur with what
> > > > is effectively a bad stack from the VDSO's perspective.
> > >
> > > What exactly does "uses the untrusted stack to pass parameters for
> > > EEXIT" mean? I guess you're saying that the enclave is writing to
> > > RSP+[0...some_positive_offset], and the written data needs to be
> > > visible to the code outside the enclave afterwards?
> >
> > As is, they actually do it the other way around, i.e. negative offsets
> > relative to the untrusted %RSP.  Going into the enclave there is no
> > reserved space on the stack.  The SDK uses EEXIT like a function call,
> > i.e. pushing parameters on the stack and making an call outside of the
> > enclave, hence the name out-call.  This allows the SDK to handle any
> > reasonable out-call without a priori knowledge of the application's
> > maximum out-call "size".
>
> But presumably this is bounded to be at most 128 bytes (the red zone
> size), right? Otherwise this would be incompatible with
> non-sigaltstack signal delivery.


I think Sean is saying that the enclave also updates RSP.

One might reasonably wonder how the SDX knows the offset from RSP to
the function ID.  Presumably using RBP?

Anyway, it seems like this is a mess and it's going to be quite hard
to do this in the vDSO due to a lack of any sane way to store the
return address.
