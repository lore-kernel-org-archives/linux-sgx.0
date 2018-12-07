Return-Path: <SRS0=sJTe=OQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_MED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D45C65BAF
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 20:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 824A1214E0
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 20:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="nzr0wqol"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 824A1214E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbeLGURE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Dec 2018 15:17:04 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42353 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbeLGURE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 7 Dec 2018 15:17:04 -0500
Received: by mail-pg1-f193.google.com with SMTP id d72so2177781pga.9
        for <linux-sgx@vger.kernel.org>; Fri, 07 Dec 2018 12:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=pjVnQ5FDILgERAcDn7BNzHjEa7TnukijT6untP9L3tI=;
        b=nzr0wqol6Zw06x0MaAQzWsQyXEoGKJZE5AX1ZccaGLH1EUgCH77WDm+XQ34TNFN3Tb
         JsZRrYIpG1sbWnyT8rb1NxecasLuhk7HZRefr5sUhY/o8BvPDpEtdvDcBcY8frCoNTWF
         V4+UJEVVVO2tjuIx0QwkKvJ6A4sSJeEOdR9mmJk89+i0hHBMXJV9yUmIKi79yYusv8kl
         DYHoq+VLQT7c89vGXewBBqw05XEbffAnG+jIGVKQl8mYiOBWeg59fu7U6S99zpEAw7Fz
         7bAKZQqrtArEAecL+WiVJaPYmGH1mjOHqtC+JtiHGREEHG2EQ2FX/8AUMYr+dVIfUHes
         Cyog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=pjVnQ5FDILgERAcDn7BNzHjEa7TnukijT6untP9L3tI=;
        b=T9oBmF/ROeCOyIRkp+F4pR1tqhjoe8bkG1kNWfcCZODnHKwJd0fTwCxSpc/8AQi/u5
         uCG1qC5ZSXKaS3dA778SdeAiQX07y8BXQywwaddmecvMnB+VSpgE3RdsoEM/ie5XN9kI
         yp5PzNx4fajLD0QUxeT1/akT+CjCPqGaAb+pHeiY9Vi6eVDaC+Cde4gshK0k+gSEgjTG
         GlIkJZXIdEUyvYEkeeA/C6trkZaio9nCrnnsJgWF2NWVCCd/3RCNf6IBtdvUgGCnUl7r
         sT+uTVGoo7t4/aRyFMJLUBIzHpNTX1J87z6Xgpg40byfaEcMuzvEftzavEoltjGkD9IM
         KZoQ==
X-Gm-Message-State: AA+aEWZYuovnLwQkXD2Ge89suRDY24mDoemynM6/kO7cZmZ2a87JPBm1
        oLGEyw3aJ2UlYJeo8VlYROuDcw==
X-Google-Smtp-Source: AFSGD/Wo5N5ExKrr3cEwrcyoGWbsTZdWpl7wMH9Cey/Ni9LIwxLOiQ7Ajpn+WjKVecGC6Ycdm6CcwQ==
X-Received: by 2002:a62:8949:: with SMTP id v70mr3505778pfd.85.1544213822767;
        Fri, 07 Dec 2018 12:17:02 -0800 (PST)
Received: from ?IPv6:2600:1010:b029:c17c:a5a6:ef43:f7fe:6ce0? ([2600:1010:b029:c17c:a5a6:ef43:f7fe:6ce0])
        by smtp.gmail.com with ESMTPSA id m3sm4965938pgl.69.2018.12.07.12.17.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 12:17:01 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16B92)
In-Reply-To: <20181207200935.GE10404@linux.intel.com>
Date:   Fri, 7 Dec 2018 12:16:59 -0800
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-sgx@vger.kernel.org, haitao.huang@linux.intel.com,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4CEB5945-9562-40FA-8CCA-A1675D55B001@amacapital.net>
References: <20181206221922.31012-1-sean.j.christopherson@intel.com> <20181206221922.31012-5-sean.j.christopherson@intel.com> <CALCETrXRJ645=08fyeoMQ949fLB1TvhsgERFVx5mAHdViEjq8Q@mail.gmail.com> <20181207165145.GB10404@linux.intel.com> <CALCETrVkEW82PzQZhJ5iS849DLY1gbd8YjH5F7P1J7hgjkjiOQ@mail.gmail.com> <20181207190257.GC10404@linux.intel.com> <EFA99261-BE93-49DA-9A8F-E6FD28069AFC@amacapital.net> <20181207200935.GE10404@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Dec 7, 2018, at 12:09 PM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
>> On Fri, Dec 07, 2018 at 11:23:10AM -0800, Andy Lutomirski wrote:
>>=20
>>>> On Dec 7, 2018, at 11:02 AM, Sean Christopherson <sean.j.christopherson=
@intel.com> wrote:
>>>>=20
>>>> On Fri, Dec 07, 2018 at 09:56:09AM -0800, Andy Lutomirski wrote:
>>>> On Fri, Dec 7, 2018 at 8:51 AM Sean Christopherson
>>>> <sean.j.christopherson@intel.com> wrote:
>>>>> I like that the exit handler allows userspace to trap/panic with the f=
ull
>>>>> call stack in place, and in a dedicated path, i.e. outside of the basi=
c
>>>>> enter/exit code.  An exit handler probably doesn't fundamentally chang=
e
>>>>> what userspace can do with respect to debugging/reporting, but I think=

>>>>> it would actually simplify some userspace implementations, e.g. I'd us=
e
>>>>> it in my tests like so:
>>>>>=20
>>>>> long fault_handler(struct sgx_enclave_exit_info *exit_info, void *tcs,=
 void *priv)
>>>>> {
>>>>>       if (exit_info->leaf =3D=3D SGX_EEXIT)
>>>>>               return 0;
>>>>>=20
>>>>>       <report exception and die/hang>
>>>>> }
>>>>>=20
>>>>=20
>>>> Hmm.  That't not totally silly, although you could accomplish almost
>>>> the same thing by wrapping the vDSO helper in another function.
>>>=20
>>> True, but I think there's value in having the option to intercept an
>>> exception at the exact(ish) point of failure, without having to return
>>> up the stack.
>>>=20
>>> The enclave has full access to the process' memory space, including the
>>> untrsuted stack.  It's not too far fetched to envision a scenario where
>>> the enclave corrupts the stack even if the enclave isn't intentionally
>>> using the stack, e.g. the host passes in variable that a points at the
>>> stack instead of whatever memory is supposed to be shared between the
>>> enclave and host.  It'd be nice to have the ability to triage something
>>> like that without having to e.g. configure breakpoints on the stack.
>>=20
>> Ah, I see. You=E2=80=99re saying that, if the non-enclave stare is corrup=
ted such
>> that RIP  is okay and RSP still points somewhere reasonable but the retur=
n
>> address is garbage, then we can at least get to the fault handler and pri=
nt
>> something?
>=20
> Yep.  Even for something more subtle like GPR corruption it could dump the=

> entire call stack before attempting to return back up.
>=20
>> This only works if the fault handler pointer itself is okay, though, whic=
h
>> somewhat limits the usefulness, given that its pointer is quite likely to=

>> be on the stack very close to the return address.
>=20
> Yeah, it's not a silver bullet by any means, but it does seem useful for a=
t
> least some scenarios.  Even exploding when invoking the handler instead of=

> at a random point might prove useful, e.g. "calling my exit handler explod=
ed,
> maybe my enclave corrupted the stack!".

Here=E2=80=99s another idea: calculate some little hash or other checksum of=
 RSP, RBP, and perhaps a couple words on the stack, and do:

call __vdso_enclave_corrupted_state

If you get a mismatch after return. That function could be:

call __vdso_enclave_corrupted_state:
  ud2

And now the debug trace makes it very clear what happened.

This may or may not be worth the effort. But ISTM the enclave is almost as l=
ikely to corrupt the host state and the. EEXIT as it is to corrupt the host s=
tate and then fault.

BTW, I read through Fortanix=E2=80=99s documentation of the Windows SGX call=
ing conventions, and it seems to want RSI and RDI as out params.  Letting th=
e vDSO be used to invoke Windows-targeted enclaves seems useful.

>=20
>> I really wish the ENCLU instruction had seen fit to preserve some registe=
rs.
>=20
> Speaking of preserving registers, the asm blob needs to mark RBX as
> clobbered since it's modified for EEXIT.

Have fun with that.  The x86_32 compiler seems to really like having its PIC=
 register preserved, and you may get some lovely compiler errors.=
