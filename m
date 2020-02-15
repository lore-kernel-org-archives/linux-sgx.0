Return-Path: <SRS0=Eu7F=4D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4EBC2BA83
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Feb 2020 16:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 352CB2083B
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Feb 2020 16:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="vJ/tRDiS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgBOQ46 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 15 Feb 2020 11:56:58 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36047 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgBOQ46 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 15 Feb 2020 11:56:58 -0500
Received: by mail-pg1-f194.google.com with SMTP id d9so6788163pgu.3
        for <linux-sgx@vger.kernel.org>; Sat, 15 Feb 2020 08:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=s2yh5Cuuxtdx7l4MqowreyFFihQLy338R8kSW89UAdc=;
        b=vJ/tRDiScWVGmu1Pcz0PXheuQmj39Q57evTUZqyRwSdPMTUvV7dg83tCVlWrdy57Cr
         UW+Kz4AmVF+2X7bf0pcSHP8csmUSjaQPMjzwsVd7s4JTe3BnW9TPxrLsqIuSsEPkxpJW
         faFLUO3H5RHqUuzurNsYGcNMy1cqtsvXRKn6phv7Rt0UKBIQnL96TbU9Y8+xHEBVc9uS
         C9Hex6y3UZdBm0ns9UZ75HmdGi7EVnOpTc8ErLa5bSffS+xYKedNBipuFpRty1TRgwJ0
         dBVkRPN+CEIn/XSOBI+rQU88GY8WNwqw70LgWgLoPfNadpONIPQ2I8ozJGOyfkeZAUQe
         2x7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=s2yh5Cuuxtdx7l4MqowreyFFihQLy338R8kSW89UAdc=;
        b=rrgQZpqhTm+XQvJvXfyKUmDJlGGvAJpMr7LbIA5+dzR2nWz39880dxn4FXSqUrsttw
         D1JZkZQAX3518N39IRi3zYjumiWUhqS50vNe05QOH+6dxQiV13wkeaw8sSH7sM0q8KIn
         5mNq8gFxXIh2PaAeNiNjUQVCxmlE6HHnSoS9moxVRqycUYLT0mLgM5NXrIb36bkjeTgO
         xUzR+qpkjbvVRlR+oBaFufQoKUomqRt0YewfyVqUWqByaJkcE5BFO3I2cO5CQOGGg/EM
         duy/Gpi3JY69n2tFstbnrCzB0BxIpP67+5NBbB0b+raej3epLnn4MH0LaqUzjAgJAmdC
         GnwA==
X-Gm-Message-State: APjAAAUAjYJO3eNa8xXlAxDTk1E0mVK7ND8aqbT+aLMCVwGlla6cRrS5
        3P/eoAhxeWdw7E2hs4ogENBYcw==
X-Google-Smtp-Source: APXvYqznz92DmqBfK1fg/rH6pdzEPLv2+da6EipQJAMGpTWpVgaJfxuLgnYC8V4LqRcDfc98oUu1Tw==
X-Received: by 2002:a63:5807:: with SMTP id m7mr8719324pgb.83.1581785817824;
        Sat, 15 Feb 2020 08:56:57 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:393a:fee0:9ddb:4055? ([2601:646:c200:1ef2:393a:fee0:9ddb:4055])
        by smtp.gmail.com with ESMTPSA id s124sm11696091pfc.57.2020.02.15.08.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 08:56:56 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
Date:   Sat, 15 Feb 2020 08:56:54 -0800
Message-Id: <033BCE0D-FA8C-40FB-849A-E401A5C6F6A3@amacapital.net>
References: <20200214175211.GE20690@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
In-Reply-To: <20200214175211.GE20690@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: iPhone Mail (17D50)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Feb 14, 2020, at 9:52 AM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
> =EF=BB=BFOn Fri, Feb 14, 2020 at 09:40:00AM -0800, Andy Lutomirski wrote:
>>=20
>>=20
>>>> On Feb 14, 2020, at 9:11 AM, Sean Christopherson <sean.j.christopherson=
@intel.com> wrote:
>>>=20
>>> =EF=BB=BFOn Fri, Feb 14, 2020 at 10:24:10AM +0100, Jethro Beekman wrote:=

>>>>> On 2020-02-13 19:07, Sean Christopherson wrote:
>>>>> On Thu, Feb 13, 2020 at 02:59:52PM +0100, Jethro Beekman wrote:
>>>>>> On 2020-02-09 22:25, Jarkko Sakkinen wrote:
>>>>>>> +/**
>>>>>>> + * struct sgx_enclave_add_pages - parameter structure for the
>>>>>>> + *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
>>>>>>> + * @src:    start address for the page data
>>>>>>> + * @offset:    starting page offset
>>>>>>> + * @length:    length of the data (multiple of the page size)
>>>>>>> + * @secinfo:    address for the SECINFO data
>>>>>>> + * @flags:    page control flags
>>>>>>> + * @count:    number of bytes added (multiple of the page size)
>>>>>>> + */
>>>>>>> +struct sgx_enclave_add_pages {
>>>>>>> +    __u64    src;
>>>>>>> +    __u64    offset;
>>>>>>> +    __u64    length;
>>>>>>> +    __u64    secinfo;
>>>>>>> +    __u64    flags;
>>>>>>> +    __u64    count;
>>>>>>> +};
>>>>>>=20
>>>>>> Compared to the last time I looked at the patch set, this API removes=
 the
>>>>>> ability to measure individual pages chunks. That is not acceptable.
>>>>>=20
>>>>> Why is it not acceptable?  E.g. what specific use case do you have tha=
t
>>>>> _requires_ on measuring partial 4k pages of an enclave?
>>>>=20
>>>> The use case is someone gives me an enclave and I want to load it. If I=
 don't
>>>> load it exactly as the enclave author specified, the enclave hash will b=
e
>>>> different, and it won't work.
>>>=20
>>> And if our ABI says "thou shall measure in 4k chunks", then it's an inva=
lid
>>> enclave if its author generated MRENCLAVE using a different granularity.=

>>=20
>> ISTM, unless there=E2=80=99s a particularly compelling reason, if an encl=
ave is
>> valid, we should be able to load it.
>=20
> That means we have to have a separate ioctl() for EEXTEND, otherwise we
> can't handle EADD[0]->EADD[1]->EADD[2]->EEXTEND[0]->EEXTEND[1]->EEXTEND[2]=
.
>=20
> I think we'd still want to keep the MEASURE flag for SGX_IOC_ENCLAVE_ADD_P=
AGE
> so that we can optimize EADD[0]->EEXTEND[0]->EADD[1]->EEXTEND[1].

Seems reasonable to me. I suppose such as ioctl could also be added later if=
 there=E2=80=99s a need.=
