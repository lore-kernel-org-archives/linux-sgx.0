Return-Path: <SRS0=sJTe=OQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_MED,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF445C64EB1
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 19:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F10720868
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 19:23:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="WObCZGoL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F10720868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbeLGTXO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Dec 2018 14:23:14 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44881 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbeLGTXO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 7 Dec 2018 14:23:14 -0500
Received: by mail-pl1-f194.google.com with SMTP id k8so2241454pls.11
        for <linux-sgx@vger.kernel.org>; Fri, 07 Dec 2018 11:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=tpMgLz8022es6nTdDC6vCIIc+GNybJRH05E0J5Oj2VU=;
        b=WObCZGoLaYqDPSDDilAbJevIjVQAGoAq0HCrkKmpUqL+bMw3yop0+HR0MELHqr/Q16
         ka3Ilw5f+EtP1Bn4SB0X6PfClstVxywWLavqinXG+wKpnfU/HtqBQotTW0R3eA99lrjv
         S4p0UcjNkgACVR16VIVaCuin9dyOGjGDRJYZ2LBcjR7HnHEqquX1yQf+dq1jCwapUQ5H
         06nct7T1hQdvS0c2yc70Cr8+HVVrjwybUjX+IwTIlW34QX5rJY6dyQEP1vlvyGGLqXdF
         LGmlXGRL74+0E+D3DtWb8HXy1rdOeLlww7g54L3lxVJZaiCXwoQ8k02yCK4f1PeAP5bh
         HPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=tpMgLz8022es6nTdDC6vCIIc+GNybJRH05E0J5Oj2VU=;
        b=kqR+acqHuZ6R3L6e0YVZktqnOg4AjcCTC/g4JC8XYHyuCQhCU6bKzJaExEYf1OU1Oq
         M4KFFjjMVHBi/l7+Im6yO9j4K/3nLWb5kRoapDW+5j9lixVwwTPXSOfi55uaXYHpnv3d
         2+uRqTPhHBuTW8IDKS9/+WYrES1Kll4iMkDm3ED5pp/y1NmEFtZDvCR1hamIpZpfZcHq
         GkbL00sEVh/JjgNQV/Zw8xY10KkoDyKJTfD6g8Ey8GXMbEEDgfPdhFrKkBXHGTISm74n
         1ioKeLhUxAYMoBdODws7HDD5Z2d/jtjw+yqh9MzFv+AFwiUuMqzfreBfkLYWhuda5xn+
         lGrw==
X-Gm-Message-State: AA+aEWY2kxqUubr8WVe5QTbD5IGnzxLV8RikQgcIlC+X03HL7HQ/x8Ar
        ZHCPCoHfKM73hcGm9iUAK+p5/A==
X-Google-Smtp-Source: AFSGD/XQLYK0sTtJacSi7NJF8SDvbleyWRHM0FivyT4oYZ6o3Nlhz/AAHEo1lnCAWvhUCb73BQPQUA==
X-Received: by 2002:a17:902:8c91:: with SMTP id t17mr3173993plo.119.1544210593296;
        Fri, 07 Dec 2018 11:23:13 -0800 (PST)
Received: from ?IPv6:2600:1010:b02e:9276:b497:ca3d:93db:f61e? ([2600:1010:b02e:9276:b497:ca3d:93db:f61e])
        by smtp.gmail.com with ESMTPSA id p7sm6260039pfa.22.2018.12.07.11.23.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 11:23:12 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16B92)
In-Reply-To: <20181207190257.GC10404@linux.intel.com>
Date:   Fri, 7 Dec 2018 11:23:10 -0800
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
Message-Id: <EFA99261-BE93-49DA-9A8F-E6FD28069AFC@amacapital.net>
References: <20181206221922.31012-1-sean.j.christopherson@intel.com> <20181206221922.31012-5-sean.j.christopherson@intel.com> <CALCETrXRJ645=08fyeoMQ949fLB1TvhsgERFVx5mAHdViEjq8Q@mail.gmail.com> <20181207165145.GB10404@linux.intel.com> <CALCETrVkEW82PzQZhJ5iS849DLY1gbd8YjH5F7P1J7hgjkjiOQ@mail.gmail.com> <20181207190257.GC10404@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Dec 7, 2018, at 11:02 AM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
>> On Fri, Dec 07, 2018 at 09:56:09AM -0800, Andy Lutomirski wrote:
>> On Fri, Dec 7, 2018 at 8:51 AM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>> I like that the exit handler allows userspace to trap/panic with the ful=
l
>>> call stack in place, and in a dedicated path, i.e. outside of the basic
>>> enter/exit code.  An exit handler probably doesn't fundamentally change
>>> what userspace can do with respect to debugging/reporting, but I think
>>> it would actually simplify some userspace implementations, e.g. I'd use
>>> it in my tests like so:
>>>=20
>>> long fault_handler(struct sgx_enclave_exit_info *exit_info, void *tcs, v=
oid *priv)
>>> {
>>>        if (exit_info->leaf =3D=3D SGX_EEXIT)
>>>                return 0;
>>>=20
>>>        <report exception and die/hang>
>>> }
>>>=20
>>=20
>> Hmm.  That't not totally silly, although you could accomplish almost
>> the same thing by wrapping the vDSO helper in another function.
>=20
> True, but I think there's value in having the option to intercept an
> exception at the exact(ish) point of failure, without having to return
> up the stack.
>=20
> The enclave has full access to the process' memory space, including the
> untrsuted stack.  It's not too far fetched to envision a scenario where
> the enclave corrupts the stack even if the enclave isn't intentionally
> using the stack, e.g. the host passes in variable that a points at the
> stack instead of whatever memory is supposed to be shared between the
> enclave and host.  It'd be nice to have the ability to triage something
> like that without having to e.g. configure breakpoints on the stack.

Ah, I see. You=E2=80=99re saying that, if the non-enclave stare is corrupted=
 such that RIP  is okay and RSP still points somewhere reasonable but the re=
turn address is garbage, then we can at least get to the fault handler and p=
rint something?  This only works if the fault handler pointer itself is okay=
, though, which somewhat limits the usefulness, given that its pointer is qu=
ite likely to be on the stack very close to the return address.

I really wish the ENCLU instruction had seen fit to preserve some registers.=
