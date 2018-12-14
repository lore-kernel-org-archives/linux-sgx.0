Return-Path: <SRS0=odJq=OX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9B8C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 18:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C28206DD
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 18:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="xbkk6Bz4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbeLNSoO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Dec 2018 13:44:14 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38658 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730460AbeLNSoO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 14 Dec 2018 13:44:14 -0500
Received: by mail-pf1-f193.google.com with SMTP id q1so3241152pfi.5
        for <linux-sgx@vger.kernel.org>; Fri, 14 Dec 2018 10:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UgS6J86CMwYvBNmo4VnoSUzznIzimIMiXT751GNxMWo=;
        b=xbkk6Bz4KAft7vG8FXpGtekFbLN0kS+YYIsE9hYWlfX8MHBZvO2sMZSgUy26xyvi3t
         mAngJIEs2M2yLKSlsGRxM9UyEJpyDfw9DJsnFcN3nulJmfPfB9P84D1k19ASXmxZpisx
         1V9dw27bwboAJxqCG4aJcVR6NFbwvfzeupnIv3mlNOiGbge8BvR2kojexieRqMydVSkK
         LRj5mJyQwCfsKHnlMPGKiMCY4bJ1EXfFQTzxN8JCEx0NZeX8qoHsjcAqZinIJUEZZJNb
         J0UzVlLP87xWTkXMigvBuI4FaLR6luhEdib/9Y32nriMY1yJHbiXl46brX4nE5+CzpYw
         DbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UgS6J86CMwYvBNmo4VnoSUzznIzimIMiXT751GNxMWo=;
        b=ihLspFEa/y0fuUuFMOJPNbZ4rSZabH4VunqqOjEOEvrkgsNQq2OMz/WKliwEFHD6a7
         Q56OvxqV9aZWBaNCwWysInlP9wvJDEDpEYGplMqTWzR3kj5vtGb1pRXvBK66vV408//T
         mqJxqPcwfTGhOmlQdnWk3X/BQ/0c2Vfk9MidID9fAKlvPV4hojTRTjdk5IAiXfYiHFnC
         6jySYOc0zRYgs3zZEPPIvfIck5fNmB6r2zQ/HFIIha1sBkkJmBsrA2IzR5OGLfNo0faa
         J9i7VaJqG0owDMOiT+/oJjRThoObGWl2mJx5mBA4sBHDE0tvBZjJH7Xv4/wJUncM0Fpa
         p/Pg==
X-Gm-Message-State: AA+aEWbPCF3pc/akgN+4S9JTHc6pvZEItNGYeGQ31K5FdGVT5hltjwsW
        TtN78m0hB0TdAVlAjiJaNb59Hw==
X-Google-Smtp-Source: AFSGD/Ubz6PIlicz+j8UpM2HvGEBHf99bjaHpPYoQlj3mJbCYU20E9PvyVQxbyrXhKpfD9h8KMAQAQ==
X-Received: by 2002:a63:4706:: with SMTP id u6mr3470678pga.95.1544813052931;
        Fri, 14 Dec 2018 10:44:12 -0800 (PST)
Received: from ?IPv6:2600:1010:b040:6acb:bdde:f4f9:c60e:340a? ([2600:1010:b040:6acb:bdde:f4f9:c60e:340a])
        by smtp.gmail.com with ESMTPSA id f67sm15374004pff.29.2018.12.14.10.44.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 10:44:12 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v4 5/5] x86/vdso: Add __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16B92)
In-Reply-To: <20181214170310.GC22063@linux.intel.com>
Date:   Fri, 14 Dec 2018 10:44:10 -0800
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <90D05734-1583-4306-A9A4-18E4A1390F3B@amacapital.net>
References: <20181213213135.12913-1-sean.j.christopherson@intel.com> <20181213213135.12913-6-sean.j.christopherson@intel.com> <cda13cff-1a56-a40f-7d69-f0f1ab752f8e@fortanix.com> <20181214151204.GA22063@linux.intel.com> <20181214153830.GB22063@linux.intel.com> <20181214170310.GC22063@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Dec 14, 2018, at 9:03 AM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
>> On Fri, Dec 14, 2018 at 07:38:30AM -0800, Sean Christopherson wrote:
>>> On Fri, Dec 14, 2018 at 07:12:04AM -0800, Sean Christopherson wrote:
>>>> On Fri, Dec 14, 2018 at 09:55:49AM +0000, Jethro Beekman wrote:
>>>>> On 2018-12-14 03:01, Sean Christopherson wrote:
>>>>> +2:    pop    %rbx
>>>>> +    pop    %r12
>>>>> +    pop    %r13
>>>>> +    pop    %r14
>>>>> +    pop    %r15
>>>>> +    pop    %rbp
>>>>> +    ret
>>>>=20
>>>> x86-64 ABI requires that you call CLD here (enclave may set it).
>>>=20
>>> Ugh.  Technically MXCSR and the x87 CW also need to be preserved.
>>>=20
>>> What if rather than treating the enclave as hostile we require it to be
>>> compliant with the x86-64 ABI like any other function?  That would solve=

>>> the EFLAGS.DF, MXCSR and x87 issues without adding unnecessary overhead.=

>>> And we wouldn't have to save/restore R12-R15.  It'd mean we couldn't use=

>>> the stack's red zone to hold @regs and @e, but that's poor form anyways.=

>>=20
>> Grr, except the processor crushes R12-R15, FCW and MXCSR on asynchronous
>> exits.  But not EFLAGS.DF, that's real helpful.
>=20
> I can think of three options that are at least somewhat reasonable:
>=20
>  1) Save/restore MXCSR and FCW
>=20
>     + 100% compliant with the x86-64 ABI
>     + Callable from any code
>     + Minimal documentation required
>     - Restoring MXCSR/FCW is likely unnecessary 99% of the time
>     - Slow
>=20
>  2) Clear EFLAGS.DF but not save/restore MXCSR and FCW
>=20
>     + Mostly compliant with the x86-64 ABI
>     + Callable from any code that doesn't use SIMD registers
>     - Need to document deviations from x86-64 ABI
>=20
>  3) Require the caller to save/restore everything.
>=20
>     + Fast
>     + Userspace can pass all GPRs to the enclave (minus EAX, RBX and RCX)
>     - Completely custom ABI
>     - For all intents and purposes must be called from an assembly wrapper=

>=20
> Option (3) actually isn't all that awful.  RCX can be used to pass an
> optional pointer to a 'struct sgx_enclave_exception' and we can still
> return standard error codes, e.g. -EFAULT.

I like 3, but:

>=20
> E.g.:
>=20
> /**
> * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> *
> * %eax:    ENCLU leaf, must be EENTER or ERESUME
> * %rbx:    TCS, must be non-NULL
> * %rcx:    Optional pointer to 'struct sgx_enclave_exception'
> *
> * Return:
> *  0 on a clean entry/exit to/from the enclave
> *  -EINVAL if ENCLU leaf is not allowed or if TCS is NULL
> *  -EFAULT if ENCLU or the enclave faults
> */
> ENTRY(__vdso_sgx_enter_enclave)
>    /* EENTER <=3D leaf <=3D ERESUME */
>    cmp    $0x2, %eax
>    jb    bad_input
>=20
>    cmp    $0x3, %eax
>    ja    bad_input
>=20
>    /* TCS must be non-NULL */
>    test    %rbx, %rbx
>    je    bad_input
>=20
>    /* save @exception pointer */
>    push    %rcx
>=20
>    /* load leaf, TCS and AEP for ENCLU */
>    lea    1f(%rip),  %rcx
> 1:    enclu
>=20
>    add    0x8, %rsp
>    xor    %eax, %eax
>    ret
>=20
> bad_input:
>    mov     $(-EINVAL), %rax
>    ret
>=20
> .pushsection .fixup, "ax"
> 2:    pop    %rcx   =20
>    test    %rcx, %rcx
>    je    3f
>=20
>    mov    %eax, EX_LEAF(%rcx)
>    mov    %di,  EX_TRAPNR(%rcx)
>    mov    %si,  EX_ERROR_CODE(%rcx)
>    mov    %rdx, EX_ADDRESS(%rcx)
> 3:    mov     $(-EFAULT), %rax
>    ret

I=E2=80=99m not totally sold on -EFAULT as the error code.  That usually ind=
icates a bad pointer.  I=E2=80=99m not sure I have a better suggestion.

> .popsection
>=20
> _ASM_VDSO_EXTABLE_HANDLE(1b, 3b)
>=20
> ENDPROC(__vdso_sgx_enter_enclave)
