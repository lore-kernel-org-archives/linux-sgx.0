Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MIME_QP_LONG_LINE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C654BC32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 23:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79A1E20830
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 23:01:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="cfUZW+yE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79A1E20830
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbeKGI2d (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Nov 2018 03:28:33 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39819 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbeKGI2d (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 7 Nov 2018 03:28:33 -0500
Received: by mail-pf1-f195.google.com with SMTP id n11-v6so6806490pfb.6
        for <linux-sgx@vger.kernel.org>; Tue, 06 Nov 2018 15:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=T+Gz74XK+/NUrbJf9v/Kr5K1X91pVUW6EhYdApm04EE=;
        b=cfUZW+yEwS75KFV1BBx0vpPxo31fkJM5QiwO5QCTGBiDMmM+xVXNNUbjEg2tjYQBMD
         Vpn29NPcXDPhGpjhZNXDe/nuFkE2kf//03ERZxdHfLBIzSwDQZjqtVF42CyvAXQIJicf
         lGmhGJi1Y2makUWLkUr2yLN9E9Qq3Opmm/bKl/H37d9itxHyBJ2c9/B47LygozsN+Lsn
         8axZ6eiUZFWXi79ZrqEr4Dmt3olZPJ49/2pRaFNJWBqWe++jeWyakjRf0S7oydZgV9jj
         zTWqd+YUUx00NLn+2UO4cGjah6hoAMN7V55t7//okPxPT3F4aL/cI4Bx1HoVe/67shra
         lR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=T+Gz74XK+/NUrbJf9v/Kr5K1X91pVUW6EhYdApm04EE=;
        b=Nfbrj/34Tk5vtDiyjpSzH7/f0LPLaX6AWWE9yjKAeDoaoHXLCfAm0UvFQ+rOG2Rz1A
         vIG0+5WwTD2X869l6VrHKzrtNysXatwHghjnLpBlR/WKUGnBncJvM2hdxN7BbBMzLJHj
         w4oyaLAqUL7yBoZT+iemB10MwxcXAj3uBPAEX477QNz5bmfCvrxa6n93l0AujBti1v2Q
         eBbP+gjll0hZe5Sv4sV2LwPKQZ+3Q5Ra/kJjiRXnMr2YT14xAwSdKOZfsg/XJimjdFuk
         BhwRYeQUgT3cUIx98Scq79xG18ReIQziVSC9YGrWHzeu2MKBcWwrtSj8j3q2+C5S2jyK
         FPdA==
X-Gm-Message-State: AGRZ1gIwdSkLY+bpSwodp4kuXWfod6dQ4WNzD1JA9Ldf+aHRYvPPqa9O
        0PTjSqmsppHx3nYcKUgT9R6o9w==
X-Google-Smtp-Source: AJdET5c+ISWewHsHFr6lVrp9WH0O8ZY5oRzhQRFOMeD6jclIbq5zSo+ybPQKIqaXCah6MoUf9bs1Ig==
X-Received: by 2002:aa7:8603:: with SMTP id p3-v6mr28212719pfn.247.1541545258810;
        Tue, 06 Nov 2018 15:00:58 -0800 (PST)
Received: from ?IPv6:2601:646:c200:7429:8c77:2d31:8ab8:32d8? ([2601:646:c200:7429:8c77:2d31:8ab8:32d8])
        by smtp.gmail.com with ESMTPSA id o12-v6sm65851261pfh.20.2018.11.06.15.00.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Nov 2018 15:00:57 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: RFC: userspace exception fixups
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16A404)
In-Reply-To: <1541541565.8854.13.camel@intel.com>
Date:   Tue, 6 Nov 2018 15:00:56 -0800
Cc:     Andy Lutomirski <luto@kernel.org>,
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
        Carlos O'Donell <carlos@redhat.com>,
        adhemerval.zanella@linaro.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7FF4802E-FBC5-4E6D-A8F6-8A65114F18C7@amacapital.net>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
 <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
 <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
 <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
 <1541518670.7839.31.camel@intel.com> <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com> <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com> <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com> <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com> <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com> <1541541565.8854.13.camel@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106230056.8Ci0IYqiRdZ94vR2oYvpb4VDhl1RWly-g1b86I4gpYk@z>



>> On Nov 6, 2018, at 1:59 PM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>>=20
>>> On Tue, 2018-11-06 at 13:41 -0800, Andy Lutomirski wrote:
>>>> On Tue, Nov 6, 2018 at 1:07 PM Andy Lutomirski <luto@amacapital.net> wr=
ote:
>>>>=20
>>>>=20
>>>>> On Nov 6, 2018, at 1:00 PM, Dave Hansen <dave.hansen@intel.com> wrote:=

>>>>>=20
>>>>>=20
>>>>> On 11/6/18 12:12 PM, Andy Lutomirski wrote:
>>>>> True, but what if we have a nasty enclave that writes to memory just
>>>>> below SP *before* decrementing SP?
>>>> Yeah, that would be unfortunate.  If an enclave did this (roughly):
>>>>=20
>>>>    1. EENTER
>>>>    2. Hardware sets eenter_hwframe->sp =3D %sp
>>>>    3. Enclave runs... wants to do out-call
>>>>    4. Enclave sets up parameters:
>>>>        memcpy(&eenter_hwframe->sp[-offset], arg1, size);
>>>>        ...
>>>>    5. Enclave sets eenter_hwframe->sp -=3D offset
>>>>=20
>>>> If we got a signal between 4 and 5, we'd clobber the copy of 'arg1' tha=
t
>>>> was on the stack.  The enclave could easily fix this by moving ->sp fir=
st.
>>>>=20
>>>> But, this is one of those "fun" parts of the ABI that I think we need t=
o
>>>> talk about.  If we do this, we also basically require that the code
>>>> which handles asynchronous exits must *not* write to the stack.  That's=

>>>> not hard because it's typically just a single ERESUME instruction, but
>>>> it *is* a requirement.
>>> I was assuming that the async exit stuff was completely hidden by the AP=
I. The AEP code would decide whether the exit got fixed up by the kernel (wh=
ich may or may not be easy to tell =E2=80=94 can the
>>> code even tell without kernel help whether it was, say, an IRQ vs #UD?) a=
nd then either do ERESUME or cause sgx_enter_enclave() to return with an app=
ropriate return value.
>> Sean, how does the current SDK AEX handler decide whether to do
>> EENTER, ERESUME, or just bail and consider the enclave dead?  It seems
>> like the *CPU* could give a big hint, but I don't see where there is
>> any architectural indication of why the AEX code got called or any
>> obvious way for the user code to know whether the exit was fixed up by
>> the kernel?
>=20
> The SDK "unconditionally" does ERESUME at the AEP location, but that's
> bit misleading because its signal handler may muck with the context's
> RIP, e.g. to abort the enclave on a fatal fault.
>=20
> On an event/exception from within an enclave, the event is immediately
> delivered after loading synthetic state and changing RIP to the AEP.
> In other words, jamming CPU state is essentially a bunch of vectoring
> ucode preamble, but from software's perspective it's a normal event
> that happens to point at the AEP instead of somewhere in the enclave.
> And because the signals the SDK cares about are all synchronous, the
> SDK can simply hardcode ERESUME at the AEP since all of the fault logic
> resides in its signal handler.  IRQs and whatnot simply trampoline back
> into the enclave.
>=20
> Userspace can do something funky instead of ERESUME, but only *after*
> IRET/RSM/VMRESUME has returned to the AEP location, and in Linux's
> case, after the trap handler has run.
>=20
> Jumping back a bit, how much do we care about preventing userspace
> from doing stupid things?=20

My general feeling is that userspace should be allowed to do apparently stup=
id things. For example, as far as the kernel is concerned, Wine and DOSEMU a=
re just user programs that do stupid things. Linux generally tries to provid=
e a reasonably complete view of architectural behavior. This is in contrast t=
o, say, Windows, where IIUC doing an unapproved WRFSBASE May cause very odd b=
ehavior indeed. So magic fixups that do non-architectural things are not so g=
reat.

The flip side, of course, is that the architecture is arguably inherently er=
ratic here, and it=E2=80=99s apparently impossible to have an SGX library wi=
th sane semantics without some kernel assistance.

So if we can make my straw man API work, perhaps with vDSO or rseq-like help=
, then the official SDK can use it, but less well behaved programs can still=
 mostly work.  (Modulo Linux=E2=80=99s non-support for EINITTOKEN, of course=
.)

Thinking about it some more, the major sticking point may be finding the RIP=
 and stack frame of EENTER in the AEP code or in its fixup. The vDSO can=E2=80=
=99t use TLS without serious hackery.  We could massively abuse WRFSBASE, bu=
t that=E2=80=99s really ugly.

(How does the Windows case work?  If there=E2=80=99s an exception after the u=
ntrusted stack allocation and before EEXIT and SEH tries to handle it, how d=
oes the unwinder figure out where to start?)

>  I did a quick POC on the idea of hardcoding
> fixup for the ENCLU opcode, and the basic idea checks out.  The code
> is fairly minimal and doesn't impact the core functionality of the SDK.
> They'd need to redo their trap handling to move it from the signal
> handler to inline, but their stack shenanigans won't be any more broken
> than they already are.
