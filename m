Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C62C65C22
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 17:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 463DB2082E
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 17:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="G1feXU/x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 463DB2082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbeKCC44 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 22:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbeKCC44 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Nov 2018 22:56:56 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC97920837
        for <linux-sgx@vger.kernel.org>; Fri,  2 Nov 2018 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541180936;
        bh=Y8GIf69pP+m9DmfderzUT/vxmSKPqCH2CKDT3DPFHI4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=G1feXU/x8bYG3sPyl7o3s0fGdQD/+jtb2/WVbZFJOxYaIvJp92HE4C2XiFlkYE+jm
         XxMby6W9p7hYnkMBuYoIIlDM4vpGDFNmoffDylrzXA+jWu6G03ngRUFUvvmFRI3S8w
         h7EanP/o/A9HhZBrRYGSGpnsSQW8EKBZKoOskaUU=
Received: by mail-wm1-f53.google.com with SMTP id b203-v6so2579196wme.5
        for <linux-sgx@vger.kernel.org>; Fri, 02 Nov 2018 10:48:55 -0700 (PDT)
X-Gm-Message-State: AGRZ1gIN456/YhLi2wlK+gGNsZOVFvEV6D7nNgfwve5UTmfvrTtrWTaC
        1MvMI1z+RILTzMThU+9/JEs3dYD8UAicwOBFBzBxVQ==
X-Google-Smtp-Source: AJdET5ffUcZqAJb9vBc3zWV3Mc+URA6oKsdH0OYNxrH9qhxk+pLL5aUIRFoG4p0Efyha5GR3JrAsSbCb892rUFl7hOk=
X-Received: by 2002:a1c:4b1a:: with SMTP id y26-v6mr5393wma.82.1541180934370;
 Fri, 02 Nov 2018 10:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx> <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx> <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com>
In-Reply-To: <20181102173350.GF7393@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 2 Nov 2018 10:48:38 -0700
X-Gmail-Original-Message-ID: <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
Message-ID:
 <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>,
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
Message-ID: <20181102174838.xMuHSfTipWjlgIMN7NLM4wKPSlaEy3ukQCNbdfLhdFo@z>

On Fri, Nov 2, 2018 at 10:33 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Nov 02, 2018 at 10:13:23AM -0700, Dave Hansen wrote:
> > On 11/2/18 10:06 AM, Sean Christopherson wrote:
> > > On Fri, Nov 02, 2018 at 09:56:44AM -0700, Dave Hansen wrote:
> > >> On 11/2/18 9:30 AM, Sean Christopherson wrote:
> > >>> What if rather than having userspace register an address for fixup, the
> > >>> kernel instead unconditionally does fixup on the ENCLU opcode?
> > >>
> > >> The problem is knowing what to do for the fixup.  If we have a simple
> > >> action to take that's universal, like backing up %RIP, or setting some
> > >> other register state, it's not bad.
> > >
> > > Isn't the EENTER/RESUME behavior universal?  Or am I missing something?
> >
> > Could someone write down all the ways we get in and out of the enclave?
> >
> > I think we always get in from userspace calling EENTER or ERESUME.  We
> > can't ever enter directly from the kernel, like via an IRET from what I
> > understand.
>
> Correct, the only way to get into the enclave is EENTER or ERESUME.
> My understanding is that even SMIs bounce through the AEX target
> before transitioning to SMM.
>
> > We get *out* from exceptions, hardware interrupts, or enclave-explicit
> > EEXITs.  Did I miss any?  Remind me where the hardware lands the control
> > flow in each of those exit cases.
>
> And VMExits.  There are basically two cases: EEXIT and everything else.
> EEXIT is a glorified indirect jump, e.g. %RBX holds the target %RIP.
> Everything else is an Asynchronous Enclave Exit (AEX).  On an AEX, %RIP
> is set to a value specified by EENTER/ERESUME, %RBP and %RSP are
> restored to pre-enclave values and all other registers are loaded with
> synthetic state.  The actual interrupt/exception/VMExit then triggers,
> e.g. the %RIP on the stack for an exception is always the AEX target,
> not the %RIP inside the enclave that actually faulted.

So what exactly happens when an enclave accesses non-enclave memory
and takes a page fault, for example?  The SDM says that the #PF vector
and error code are stored in the SSA frame where the kernel can't see
them.  Is a real #PF then delivered?

I guess that, if the memory in question gets faulted in, then the
kernel resumes exection at the AEP address, which does ERESUME, and
the enclave resumes.  But if the access is bad, then the kernel
delivers a signal (or uses some other new mechanism), and then what
happens?  Is the enclave just considered dead?  Is user code supposed
to EENTER back into the enclave to tell it that it got an error?

This whole mechanism seems very complicated, and it's not clear
exactly what behavior user code wants.
