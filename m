Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9844C32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 21:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACB952086B
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 21:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2jw2xbR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACB952086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbeKGHJY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Nov 2018 02:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbeKGHJX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Nov 2018 02:09:23 -0500
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E44AC20892
        for <linux-sgx@vger.kernel.org>; Tue,  6 Nov 2018 21:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541540527;
        bh=ZLGkX2/fHbuTlmD8ZeECMFUn49KO4EBC58hjYDf9KcA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b2jw2xbRZRGQCjAwxzxyeX8sn4EodFrMDjIm5BinxRgOrWkFgz9RHiEVqScoFpnhQ
         jRxqmmk1hcOouqMSQxMiSor7rjp9I0/O+vSgm+iD8OZ7XHZyFjzwf2ajxwgBvpw7le
         mZIrMbOZHbIfWPI3fCxLwGK2pOmfsN98rGCLUmY8=
Received: by mail-wr1-f54.google.com with SMTP id z13-v6so12836800wrs.3
        for <linux-sgx@vger.kernel.org>; Tue, 06 Nov 2018 13:42:06 -0800 (PST)
X-Gm-Message-State: AGRZ1gLoFQxm1Yr3+O4bk3I9AVGBZHFS3+azmDzwhBlKg/rOCbGfKsxH
        9yV5S0EYzBdI+3zNk0Pgaw7SHgcohhmTJpEN4qCepQ==
X-Google-Smtp-Source: AJdET5fh4kf8macwnRGOooVWINWbfhYcFzYwCKEd4bVAsTQ7vbWB+ZrUDsY7Swh2aDpR4eXNyl0tL2lWPt0YAyljYx8=
X-Received: by 2002:adf:b1db:: with SMTP id r27-v6mr25013353wra.95.1541540525308;
 Tue, 06 Nov 2018 13:42:05 -0800 (PST)
MIME-Version: 1.0
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
In-Reply-To: <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 6 Nov 2018 13:41:53 -0800
X-Gmail-Original-Message-ID: <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com>
Message-ID:
 <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andrew Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106214153.GlFDfRUDml7-X_R3eWlMPCl6YO2P4csFMXpZgxwfwPQ@z>

On Tue, Nov 6, 2018 at 1:07 PM Andy Lutomirski <luto@amacapital.net> wrote:
>
>
>
> > On Nov 6, 2018, at 1:00 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> >
> >> On 11/6/18 12:12 PM, Andy Lutomirski wrote:
> >> True, but what if we have a nasty enclave that writes to memory just
> >> below SP *before* decrementing SP?
> >
> > Yeah, that would be unfortunate.  If an enclave did this (roughly):
> >
> >    1. EENTER
> >    2. Hardware sets eenter_hwframe->sp =3D %sp
> >    3. Enclave runs... wants to do out-call
> >    4. Enclave sets up parameters:
> >        memcpy(&eenter_hwframe->sp[-offset], arg1, size);
> >        ...
> >    5. Enclave sets eenter_hwframe->sp -=3D offset
> >
> > If we got a signal between 4 and 5, we'd clobber the copy of 'arg1' tha=
t
> > was on the stack.  The enclave could easily fix this by moving ->sp fir=
st.
> >
> > But, this is one of those "fun" parts of the ABI that I think we need t=
o
> > talk about.  If we do this, we also basically require that the code
> > which handles asynchronous exits must *not* write to the stack.  That's
> > not hard because it's typically just a single ERESUME instruction, but
> > it *is* a requirement.
> >
>
> I was assuming that the async exit stuff was completely hidden by the API=
. The AEP code would decide whether the exit got fixed up by the kernel (wh=
ich may or may not be easy to tell =E2=80=94 can the code even tell without=
 kernel help whether it was, say, an IRQ vs #UD?) and then either do ERESUM=
E or cause sgx_enter_enclave() to return with an appropriate return value.
>
>

Sean, how does the current SDK AEX handler decide whether to do
EENTER, ERESUME, or just bail and consider the enclave dead?  It seems
like the *CPU* could give a big hint, but I don't see where there is
any architectural indication of why the AEX code got called or any
obvious way for the user code to know whether the exit was fixed up by
the kernel?
