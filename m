Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A446C32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 16:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26C7A2081D
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 16:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="a1liUfpu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26C7A2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389449AbeKGCXp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:23:45 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33382 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389214AbeKGCXp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 6 Nov 2018 21:23:45 -0500
Received: by mail-pg1-f194.google.com with SMTP id q5-v6so6080755pgv.0
        for <linux-sgx@vger.kernel.org>; Tue, 06 Nov 2018 08:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fuTYZ0EUURoM2npeeIQL7Ud5k/6P95lXaguV2MbS8Ks=;
        b=a1liUfpuFJJmS06nU/EjBdoWCE3hJsy7OELbBpdzO9qBINWaExkerGXPukA2B6Vckm
         uQjTGSavGI9BxMFjKgA0zSLUCe+QgFIvr7btS831iBlLMi12pYZhxdS+1hKLflPNqshm
         ZB9GOHMVrE6QLsWgkdEb6scSl1nmFe9WDpsL/Hp3As5A2KVrC7PVoWcT3QPMVcs8ZkhS
         b2Ni2DR9+lg3U07J6DlElfqLGyFhNFn3qvMJnOhnsg1OZE9FwnzzE70kY5s4LohszlDs
         dnI6jaaGFyBSicX8AoIvApjRObCMLmht+ZCXjVNxJZh7p4HkwvXCAdsxmMQamdR4ypgn
         aXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fuTYZ0EUURoM2npeeIQL7Ud5k/6P95lXaguV2MbS8Ks=;
        b=boYAswQtpjf8LRmUiGUOHO8dYM+2AxumnOOiQozYsltrQ7tKfZpBOseDmbt1CRT1lA
         yV+xyMvQDrBzpTjjnQshAYd7KK5Ba/VSfbtJkrh/uM6XafDQAo2jUAmkeqKQGaVHyVx8
         AqamsiZOZJUpQOk1mDP9BTWp8qnbnDr6P/xIgasyh+jsdPIt6Jaosi2qvhHgtUl4d+Ys
         VgeKyaFYn7JUwK5dFNPHYFfYdqs7FrBJw0lEMr5dNURbO6798K8H++F1sJiluXwhIcML
         DEUD3bdsor+XrVmPY2RzfBsHqbN2CGGpI1bcrA9w+vgpM5WH+Hadtf/Jx9NFSGZoOoro
         u3Uw==
X-Gm-Message-State: AGRZ1gJnqAQxZEl3BDTKaePT2PpZ0kqMqqwDRJtt/a7zRJObQoBUKMSw
        w/uvmPJaVsLWzwsQEBvvpIlK0g==
X-Google-Smtp-Source: AJdET5ewp8P0a3cow3VwO66aaPT5T67qfqdfTA0/4oDjmvqaX2Rx4QQgXdh/BvW4ZtHvcB99jiYIAA==
X-Received: by 2002:a62:995c:: with SMTP id d89-v6mr26698555pfe.11.1541523457476;
        Tue, 06 Nov 2018 08:57:37 -0800 (PST)
Received: from ?IPv6:2601:646:c200:7429:41cb:cc75:c7b0:b9a? ([2601:646:c200:7429:41cb:cc75:c7b0:b9a])
        by smtp.gmail.com with ESMTPSA id 7-v6sm48620961pgk.31.2018.11.06.08.57.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Nov 2018 08:57:36 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: RFC: userspace exception fixups
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16A404)
In-Reply-To: <1541518670.7839.31.camel@intel.com>
Date:   Tue, 6 Nov 2018 08:57:35 -0800
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
Message-Id: <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com> <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com> <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com> <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com> <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com> <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com> <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com> <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com> <1541518670.7839.31.camel@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106165735.Y36A-qoND7-y9Se-2kZGX7YtTpm1QGKP9RjHgGlz_RU@z>



> On Nov 6, 2018, at 7:37 AM, Sean Christopherson <sean.j.christopherson@int=
el.com> wrote:
>=20
>> On Fri, 2018-11-02 at 16:32 -0700, Andy Lutomirski wrote:
>>> On Fri, Nov 2, 2018 at 4:28 PM Jann Horn <jannh@google.com> wrote:
>>>=20
>>>=20
>>> On Fri, Nov 2, 2018 at 11:04 PM Sean Christopherson
>>> <sean.j.christopherson@intel.com> wrote:
>>>>=20
>>>>> On Fri, Nov 02, 2018 at 08:02:23PM +0100, Jann Horn wrote:
>>>>>=20
>>>>> On Fri, Nov 2, 2018 at 7:27 PM Sean Christopherson
>>>>> <sean.j.christopherson@intel.com> wrote:
>>>>>>=20
>>>>>>> On Fri, Nov 02, 2018 at 10:48:38AM -0700, Andy Lutomirski wrote:
>>>>>>>=20
>>>>>>> This whole mechanism seems very complicated, and it's not clear
>>>>>>> exactly what behavior user code wants.
>>>>>> No argument there.  That's why I like the approach of dumping the
>>>>>> exception to userspace without trying to do anything intelligent in
>>>>>> the kernel.  Userspace can then do whatever it wants AND we don't
>>>>>> have to worry about mucking with stacks.
>>>>>>=20
>>>>>> One of the hiccups with the VDSO approach is that the enclave may
>>>>>> want to use the untrusted stack, i.e. the stack that has the VDSO's
>>>>>> stack frame.  For example, Intel's SDK uses the untrusted stack to
>>>>>> pass parameters for EEXIT, which means an AEX might occur with what
>>>>>> is effectively a bad stack from the VDSO's perspective.
>>>>> What exactly does "uses the untrusted stack to pass parameters for
>>>>> EEXIT" mean? I guess you're saying that the enclave is writing to
>>>>> RSP+[0...some_positive_offset], and the written data needs to be
>>>>> visible to the code outside the enclave afterwards?
>>>> As is, they actually do it the other way around, i.e. negative offsets
>>>> relative to the untrusted %RSP.  Going into the enclave there is no
>>>> reserved space on the stack.  The SDK uses EEXIT like a function call,
>>>> i.e. pushing parameters on the stack and making an call outside of the
>>>> enclave, hence the name out-call.  This allows the SDK to handle any
>>>> reasonable out-call without a priori knowledge of the application's
>>>> maximum out-call "size".
>>> But presumably this is bounded to be at most 128 bytes (the red zone
>>> size), right? Otherwise this would be incompatible with
>>> non-sigaltstack signal delivery.
>>=20
>> I think Sean is saying that the enclave also updates RSP.
>=20
> Yeah, the enclave saves/restores RSP from/to the current save state area.
>=20
>> One might reasonably wonder how the SDX knows the offset from RSP to
>> the function ID.  Presumably using RBP?
>=20
> Here's pseudocode for how the SDK uses the untrusted stack, minus a
> bunch of error checking and gory details.
>=20
> The function ID and a pointer to a marshalling struct are passed to
> the untrusted runtime via normal register params, e.g. RDI and RSI.
> The marshalling struct is what's actually allocated on the untrusted
> stack, like alloca() but more complex and explicit.  The marshalling
> struct size is not artificially restricted by the SDK, e.g. AFAIK it
> could span multiple 4k pages.
>=20
>=20
> int sgx_out_call(const unsigned int func_index, void *marshalling_struct)
> {
>    struct sgx_encl_tls *tls =3D get_encl_tls();
>=20
>    %RBP =3D tls->save_state_area[SSA_RBP];
>    %RSP =3D tls->save_state_area[SSA_RSP];
>    %RDI =3D func_index;
>    %RSI =3D marshalling_struct;
>=20
>    EEXIT
>=20
>    /* magic elsewhere to get back here on an EENTER(OUT_CALL_RETURN) */
>    return %RAX
> }
>=20
> void *sgx_alloc_untrusted_stack(size_t size)
> {
>    struct sgx_encl_tls *tls =3D get_encl_tls();
>    struct sgx_out_call_context *context;
>    void *tmp;
>=20
>    /* create a frame on the trusted stack to hold the out-call context */
>    tls->trusted_stack -=3D sizeof(struct sgx_out_call_context);
>=20
>    /* save the untrusted %RSP into the out-call context */
>    context =3D (struct sgx_out_call_context *)tls->trusted_stack;
>    context->untrusted_stack =3D tls->save_state_area[SSA_RSP];
>=20
>    /* allocate space on the untrusted stack */
>    tmp =3D (void *)(tls->save_state_area[SSA_RSP] - size);
>    tls->save_state_area[SSA_RSP] =3D tmp;
>=20
>    return tmp;
> }
>=20
> void sgx_pop_untrusted_stack(void)
> {
>    struct sgx_encl_tls *tls =3D get_encl_tls();
>    struct sgx_out_call_context *context;
>=20
>    /* retrieve the current out-call context from the trusted stack */
>    context =3D (struct sgx_out_call_context *)tls->trusted_stack;
>=20
>    /* restore untrusted %RSP */
>    tls->save_state_area[SSA_RSP] =3D context->untrusted_stack;
>=20
>    /* pop the out-call context frame */
>    tls->trusted_stack +=3D sizeof(struct sgx_out_call_context);
> }
>=20
> int sgx_main(void)
> {
>    struct my_out_call_struct *params;
>=20
>    params =3D sgx_alloc_untrusted_stack(sizeof(*params));
>=20
>    params->0..N =3D XYZ;
>=20
>    ret =3D sgx_out_call(DO_WORK, params);
>=20
>    sgx_pop_untrusted_stack();
>=20
>    return ret;
> }

So I guess the non-enclave code basically can=E2=80=99t trust its stack poin=
ter because of these shenanigans. And the AEP code has to live with the fact=
 that its RSP is basically arbitrary and probably can=E2=80=99t even be unwo=
und by a debugger?  And the EENTER code has to deal with the fact that its r=
ed zone can be blatantly violated by the enclave?

I=E2=80=99m assuming it=E2=80=99s way too late for the SGX SDK to be changed=
 to use a normal RPC mechanism? I=E2=80=99m a bit disappointed that enclaves=
 can even manipulate outside state like this. I assume Intel had some reason=
 for making it possible, but still.=
