Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75F9C32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 18:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71C8720830
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 18:20:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="XkgAtVTX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71C8720830
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388236AbeKGDrB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Nov 2018 22:47:01 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:41121 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbeKGDrA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 6 Nov 2018 22:47:00 -0500
Received: by mail-pg1-f182.google.com with SMTP id 70so592028pgh.8
        for <linux-sgx@vger.kernel.org>; Tue, 06 Nov 2018 10:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qDsnffpMgE1JXvMM5u4+JhNGpY4R62QM++WVmvsfdyg=;
        b=XkgAtVTXtJUS8OXK4wzkaLQMNdJLS4+AX8nS4VD1MGxBKiLTxZGGPUTTZTLGytlSiC
         V3GVIDzihnzJ0lub49J1WajK7ovl2yT8qehmBvsZCgu/ML9/NBuUqBwfGsWQLuqsxMGV
         AjmCSn8z0wd/TE2OSUIplOF3Fpf9P+YYP70C8RBS14OSIK5stZw14HPJAPCKaUkmcj9R
         ZFkrZLI8AfLzNwizlDlgAMeimICJKcpKBsx01l5rB0oYf7Vtblo315MzY2swjuXeGuHJ
         C+UnJlS5+xq6C65TeSBAL33rxp25w8j2rzUYMKAzx9rt7+9iIR38o07xHMDf6uP3P3q3
         5AEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qDsnffpMgE1JXvMM5u4+JhNGpY4R62QM++WVmvsfdyg=;
        b=kTS9XU61pAu4IccwkCL2sLxVhoqdJg8fUKPrM4LPhtB2da/Yap2/qwzhZNN8qnmtiN
         GXfFFVQaopRJgwkSpb086dDpV5LrTu1Vv/WrZ4pxkORgtEikk2dS8coOVY2/EI1Kx/7+
         wjS8os4xmXih0uIdpjI/5ipLei1StwbD0EPFBcA2e6xDpHGeqzR7m/GNekq6uv34geHo
         PAsG37lcbyhy9vupFb2rsW8vsCsh7Y7w9utq8ANt4VnJmT8IZlh3mEVzWZXaJKbfsXOK
         DqC/VgvRYqiT9zPJGwsZVsCez/5wMlsRebWYUjwm8jTwP0Kq0VwYiTBjM8P6dw3QBbhT
         4Wpw==
X-Gm-Message-State: AGRZ1gKfWw0c7vWBFREcpnBr/F1PnxaW/FuVP4i794k/+ezECh+Zbsvq
        2OP+NWv62WBF1SLrnBNwbmjnCg==
X-Google-Smtp-Source: AJdET5e+3QCorx17GkkVkhyx1wXs2RjtEk/ZJrIoAq19hkp8sShj+kHCmdfdzex8OFz7JNn6l5AY9Q==
X-Received: by 2002:a62:4784:: with SMTP id p4-v6mr26843289pfi.257.1541528430750;
        Tue, 06 Nov 2018 10:20:30 -0800 (PST)
Received: from ?IPv6:2600:1010:b022:50cc:40e8:641b:7bb4:fb59? ([2600:1010:b022:50cc:40e8:641b:7bb4:fb59])
        by smtp.gmail.com with ESMTPSA id v84-v6sm5926910pfd.182.2018.11.06.10.20.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Nov 2018 10:20:29 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: RFC: userspace exception fixups
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16A404)
In-Reply-To: <1541524750.7839.51.camel@intel.com>
Date:   Tue, 6 Nov 2018 10:20:27 -0800
Cc:     Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>,
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
        Carlos O'Donell <carlos@redhat.com>,
        adhemerval.zanella@linaro.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com> <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com> <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com> <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com> <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com> <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com> <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com> <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com> <1541518670.7839.31.camel@intel.com> <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net> <1541524750.7839.51.camel@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106182027.LMQdyQOpjbJvnEHM_Z4lh4eTKt7Yg5a2cGhoiuen3mA@z>




> On Nov 6, 2018, at 9:19 AM, Sean Christopherson <sean.j.christopherson@int=
el.com> wrote:
>=20
>> On Tue, 2018-11-06 at 08:57 -0800, Andy Lutomirski wrote:
>>=20
>> So I guess the non-enclave code basically can=E2=80=99t trust its stack p=
ointer
>> because of these shenanigans. And the AEP code has to live with the fact
>> that its RSP is basically arbitrary and probably can=E2=80=99t even be un=
wound
>> by a debugger?
>=20
> The SDK provides a Python GDB plugin to hook into the out-call flow and
> do more stack shenanigans.  =46rom what I can tell it's fudging the stack
> to make it look like a normal stack frame so the debugger can do it's
> thing.
>=20
>> And the EENTER code has to deal with the fact that its red zone can be
>> blatantly violated by the enclave?
>=20
> That's my understanding of things.  So yeah, if it wasn't obvious before,
> the trusted and untrusted parts of the SDK are very tightly coupled.

Yuck. Just how far does this right coupling go?  If there are enclaves that p=
lay with, say, FSBASE or GSBASE, we=E2=80=99re going to start having problem=
s. And the SGX handling of PKRU is complicated at best.

I almost feel like the right solution is to call into SGX on its own private=
 stack or maybe even its own private address space.=20=
