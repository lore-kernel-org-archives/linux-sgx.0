Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90646C74A36
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 21:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 674BC208E4
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 21:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="cGFGKkMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfGJVOR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Jul 2019 17:14:17 -0400
Received: from sonic301-38.consmr.mail.ne1.yahoo.com ([66.163.184.207]:34981
        "EHLO sonic301-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727287AbfGJVOR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 10 Jul 2019 17:14:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1562793254; bh=L/oM7WHNBHyqqbXDeNtzrh4jL9FqrMVaT4KURs4JwDs=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject; b=cGFGKkMZ91u1BKl4EhRF3lKWtLowWl+hts9bsG+2Mo0nYRWHS/qkFGwp3QIBtfxpwKzZDXOKZrMxpryRnIjRyGdy86IRu8bD75Z5TGhXD4io2YPTJMH7P9uWDlIwJ9bT0gyE1+wcsFN2wUvsdI5fhHqqV7y7tM1tCRexBSlS4aI0Ose+bg1nLssZOB0QIn9fOYTaFEU6ZjbBT/qEhEZersczqXoYISt08/b6dMt8MDIe7D1i1bOA9LT1KXM8pUEajXkwWxqUrrbOmRrHCaVIgtbXshnFOLydnzrUekU/HJx4Amga5Orabb0mT1c9iW2ckpa7VURAjuyU7pQVbBAIfQ==
X-YMail-OSG: axjE8SQVM1mAIVlPaNMJiIKe7LDEzjO..WXcA2VzXbfnuFRRz7rjEztmEIH1ywX
 huMShnvTXAweY2gfsU2zxJ6OSXUMfkGpLBRrHAKmWuwX6NzPa5juV4zn3S9zPWufSK73tFw0vEpq
 6XVI3ll7JaF9D_80FMhW1Y.CzUtJW9dr6KX3OepO_W0G0cz3plVUq.8LqepK7GMY0vhvw8d28Xx9
 IdY_uqCJygykIIji4Wid9dvSp6DSyxVd5IsaUQlCfOd7Ty7meMbSkhZ7HjQIrY.rR8AUdFwo4Rhm
 I3znzBBOtdxwI8dpi.mAxexeS1_jCaETEapMLyOoh7PR63QwdRpJ5UiSiCRqF_EEFr6PPTYnS5Rv
 RvypRI.GoBb6EuRY7xtLiIH7EOko58p1OcSsSKikQbCOxbB.D6MIo6lwCfri55DnNXJEKMEV3BJL
 oYwAAi2u9pY5QRQWDVPHQMcLdwwmQ1rLmTfCx0EkMFWQ6HgEXTaeB4gIMKNDFHQLLqkWkx0A_UG1
 4ysYymstQ5SeuZzfDXBBEXvDLgPtQz8Un1m7k0VMfaKtAkKgpAwkYDy4Dw2DTyCn5Pf_yKPC1SVk
 lDqwX7iae2owUidk1QvOJsmJkFZ.ubJBSkURYTI6Df_CbFXKYQdq9ETnWEVeMxnbPJhK1K8o8ofZ
 .qH1D.l0Drsy6q1U61wyQudl4CnBeAVonI5_oI9Ja999lQhmDuXq_NqD9sPXfXkVaqM39nmb5iG1
 pO3DN_FgLnMx.euz40CbB3IPmkFCx8iZzZVWRZ7tqje1X3yO6hIACRnrzWyDDsQiCqS4tZAZcyYd
 1FhFvG_nMblIf69co6IelN.bsjK5Z0tEFHELIOmU..gWBrbVzPOSgoQ7_tvyoEbqZnSzEEBYIe24
 YFQc.1QHYuZM2lP6QYy7_C0Jm0eru2X4tmHhzZcjK_O97chgxK9lFWR2mxKgBszr0M0LDYAANFFt
 BLDvpnUvXvFbzOkcfD2al.g9mD9rJSJzeY1ou4MKmm0KMaCXIHs155oN7jFm3ZIyKkvbi8iox8ma
 9huAV.3alj5xLCbxoopGqpiQsycfI5eVnfu.aD8XvvX1kbS7Gx.GhzcVkDlUKZA7eC3JnTdPm_M7
 chJJdHat_zn2LUW26sX_EJ9RZQt6Txg.7LxA9r5c6c9yZoHPKXi83WnfrvSbRJwZ4opnXfL_oS7N
 BdIdtPCxl9axQ_wZQgn8OjfS3iMQlSKEy8z_1N.Cx3z29260hkzKNeLnpVVbVMSaxdCqJnL5A9fc
 Lh57ZsfiTXoTMEuYEU8U-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Wed, 10 Jul 2019 21:14:14 +0000
Received: by smtp429.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 0128fc8cb26b7a97608a9ff2aef06799;
          Wed, 10 Jul 2019 21:14:14 +0000 (UTC)
Subject: Re: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
To:     "Xing, Cedric" <cedric.xing@intel.com>, linux-sgx@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        casey@schaufler-ca.com
References: <cover.1562542383.git.cedric.xing@intel.com>
 <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
 <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
 <ce4dcce2-88fb-ccec-f173-fc567d9ca006@intel.com>
 <decc7ae6-a89f-1ae5-6289-f3dcaa6390b0@schaufler-ca.com>
 <1f5b5fc1-9a95-9748-f9dc-0486c6ae30d8@intel.com>
 <34552999-160e-4f60-8d7e-37f51c895ef4@schaufler-ca.com>
 <e2a0d952-b4d4-f8f3-ee58-eba63f30dc66@intel.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <594ebd19-652d-ab6f-e098-515d50e80ce6@schaufler-ca.com>
Date:   Wed, 10 Jul 2019 14:14:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e2a0d952-b4d4-f8f3-ee58-eba63f30dc66@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/9/2019 5:55 PM, Xing, Cedric wrote:
> On 7/9/2019 5:10 PM, Casey Schaufler wrote:
>> On 7/9/2019 3:13 PM, Xing, Cedric wrote:
>>> On 7/8/2019 4:53 PM, Casey Schaufler wrote:
>>>> On 7/8/2019 10:16 AM, Xing, Cedric wrote:
>>>>> On 7/8/2019 9:26 AM, Casey Schaufler wrote:
>>>>>> In this scheme you use an ema LSM to manage your ema data.
>>>>>> A quick sketch looks like:
>>>>>>
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_something_in() calls
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 security_en=
clave_load() calls
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ema_enclave_load()
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 selinux_enclave_load()
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 otherlsm_enclave_load()
>>>>>>
>>>>>> Why is this better than:
>>>>>>
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_something_in() calls
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ema_enclave=
_load()
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 security_en=
clave_load() calls
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 selinux_enclave_load()
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 otherlsm_enclave_load()
>>>>>
>>>>> Are you talking about moving EMA somewhere outside LSM?
>>>>
>>>> Yes. That's what I've been saying all along.
>>>>
>>>>> If so, where?
>>>>
>>>> I tried to make it obvious. Put the call to your EMA code
>>>> on the line before you call security_enclave_load().
>>>
>>> Sorry but I'm still confused.
>>>
>>> EMA code is used by LSMs only. Making it callable from other parts of=
 the kernel IMHO is probably not a good idea. And more importantly I don'=
t understand the motivation behind it. Would you please elaborate?
>>
>> LSM modules implement additional access control restrictions.
>> The EMA code does not do that, it provides management of data
>> that is used by security modules. It is not one itself. VFS
>> also performs this role, but no one would consider making VFS
>> a security module.
>
> You are right.

So far, so good ...

> EMA is more like a helper library than a real LSM.

Then you should use it as such.

> But the practical problem is, it has a piece of initialization code, to=
 basically request some space in the file blob from the LSM infrastructur=
e.

The security modules that want to use EMA should
request that space.

> That cannot be done by any LSMs at runtime.

Sure it can. And it has to. What if you don't
have any security modules that use the EMA data?
Surely you don't want to be allocating blob space
for EMA data if no one is going to use it.

> So it has to either be done in LSM infrastructure directly, or make its=
elf an LSM to make its initialization function invoked by LSM infrastruct=
ure automatically.

That is not true. The security module that wants to use
the EMA data can call whatever allocation function you use.
Or, the call can be made from the code just before you call
the security hook, which would be identical to calling it
as a "first" hook.

> You have objected to the former, so I switched to the latter. Are you n=
ow objecting to the latter as well? Then what are you suggesting, really?=


Call your allocation function just before you call
security_enclave_load(). There is no way that selinux_enclave_load()
could tell the difference.

> VFS is a completely different story. It's the file system abstraction s=
o it has a natural place to live in the kernel, and its initialization do=
esn't depend on the LSM infrastructure. EMA on the other hand, shall belo=
ng to LSM because it is both produced and consumed within LSM.

And this is the enclave abstraction, or rather, should be
according to at least half the people joining in on the
thread. It does not belong in the LSM infrastructure because
it is it's own thing, with its own state and data, which it
needs to maintain in its own way and place. It needs interfaces
so that security modules can use that information appropriately.
It needs a hook or two so that the enclave abstraction can ask
the security modules to make decisions.

>
> And, Stephen, do you have an opinion on this?
>
>>>>>>> +/**
>>>>>>> + * ema - Enclave Memory Area structure for LSM modules
>>>>>>
>>>>>> LSM modules is redundant. "LSM" or "LSMs" would be better.
>>>>>
>>>>> Noted
>>>>>
>>>>>>> diff --git a/security/Makefile b/security/Makefile
>>>>>>> index c598b904938f..b66d03a94853 100644
>>>>>>> --- a/security/Makefile
>>>>>>> +++ b/security/Makefile
>>>>>>> @@ -28,6 +28,7 @@ obj-$(CONFIG_SECURITY_YAMA)=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 +=3D yama/
>>>>>>> =C2=A0=C2=A0=C2=A0 obj-$(CONFIG_SECURITY_LOADPIN)=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 +=3D loadpin/
>>>>>>> =C2=A0=C2=A0=C2=A0 obj-$(CONFIG_SECURITY_SAFESETID)=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 +=3D safesetid/
>>>>>>> =C2=A0=C2=A0=C2=A0 obj-$(CONFIG_CGROUP_DEVICE)=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 +=3D device_cgroup.o
>>>>>>> +obj-$(CONFIG_INTEL_SGX)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 +=3D commonema.o
>>>>>>
>>>>>> The config option and the file name ought to match,
>>>>>> or at least be closer.
>>>>>
>>>>> Just trying to match file names as "capability" uses commoncap.c.
>>>>
>>>> Fine, then you should be using CONFIG_SECURITY_EMA.
>>>>
>>>>>
>>>>> Like I said, this feature could potentially be used by TEEs other t=
han SGX. For now, SGX is the only user so it is tied to CONFIG_INTEL_SGX.=
 I can rename it to ema.c or enclave.c. Do you have a preference?
>>>>
>>>> Make
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CONFIG_SECURITY_EMA
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0depends on CONFIG_INTEL_SGX
>>>>
>>>> When another TEE (maybe MIPS_SSRPQ) comes along you can have
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CONFIG_SECURITY_EMA
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0depends on CONFIG_INTEL_SGX || CONFIG_=
MIPS_SSRPQ
>>>
>>> Your suggestions are reasonable. Given such config change wouldn't af=
fect any code, can we do it later,
>>
>> That doesn't make the current options any less confusing,
>> and it will be easier to make the change now than at some
>> point in the future.
>>
>>> e.g., when additional TEEs come online and make use of these new hook=
s? After all, security_enclave_init() will need amendment anyway as one o=
f its current parameters is of type 'struct sgx_sigstruct', which will ne=
ed to be replaced with something more generic. At the time being, I'd lik=
e to keep things intuitive so as not to confuse reviewers.
>>
>> Reviewers (including me) are already confused by the inconsistency.
>
> OK. Let me make this change.

Thank you.

>>>>>
>>>>>>> diff --git a/security/commonema.c b/security/commonema.c
>>>>>>
>>>>>> Put this in a subdirectory. Please.
>>>>>
>>>>> Then why is commoncap.c located in this directory? I'm just trying =
to match the existing convention.
>>>>
>>>> commoncap is not optional. It is a base part of the
>>>> security subsystem. ema is optional.
>>>
>>> Alright. I'd move it into a sub-folder and rename it to ema.c. Would =
you be ok with that?
>>
>> Sounds fine.
>
> This is another part that confuses me. Per you comment here, I think yo=
u are OK with EMA being part of LSM

Ah. Being in the security directory does not mean it's
a part of the LSM system. Keys and integrity are security
subsystems that are related to, but not part of, the LSM
sub-system.

> (I mean, living somewhere under security/). But your other comment of c=
alling ema_enclave_load() alongside security_enclave_load() made me think=
 EMA and LSM were separate. What do you want really?

Please stop asking the same question over and over.
You're not going to get a different answer from what
you've gotten already. Look back at it what's already
been said.


