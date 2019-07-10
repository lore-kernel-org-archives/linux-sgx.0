Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530E7C73C65
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 00:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B5282081C
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 00:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="pO+ga9x+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfGJAKW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Jul 2019 20:10:22 -0400
Received: from sonic316-13.consmr.mail.gq1.yahoo.com ([98.137.69.37]:39597
        "EHLO sonic316-13.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfGJAKW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 9 Jul 2019 20:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1562717421; bh=QEK8IJH58HYXbi6QcbjrjnIod/RVNRBU9m31kdZ8dsw=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject; b=pO+ga9x+zBG3eaQxb6gvs0UeP+KtEHMI1G61ZgDXvzRqxnqe43N1sln56/ULkSlgzZTaj2MlP3uqQVuvawSxFJvUIOsrDF2BZPFkEQTHEauubuqNeBhNSBFfBE5KVHnfrJV/r8Ngm+ykKDGCNvR8GuJOpBP3/pICp3C9VJSjsfcJdm+lgxR8T2ZzSejYXDNfDrQZ4n4TNd9q4D0E/JWCCumku3OUAZgLeOJZGeErGehP74d19/YvZ5tZpejlewWHbiRSp6l/JswXj90dIJin8ZNqj6MnWoPV/TDIYHOSz/EjtQEZQKkI2Mo9KCqIRIrQpt4zSlMeNG/sF6mJX0GSlg==
X-YMail-OSG: EQD_jbwVM1m9Yt8l316s0HwYJa.rBGNGBHqxyIYRDr9yLmpQlkRADA6Z9ixEgP6
 r6bcboxu7MnKPd0zKZFQhGoQp0y0uzjCrT3rcP4em.8DkvNH0fT_OC70jUIgylhkcYxYD_uGH_El
 K4lron9N_.uhT0gIs9mJaeN_bbWOhH3nSfuYWu0ncRLeU1DeFBWD5F7sF0v2jAeW0MwSm9ZTxEpk
 XWnQVT.ppMq6udSwfo3yHqVCtU5RvZkbanjFkPX7LcksMdDOWxVM2mLuTZUPQRMhhZMylOa6yBvU
 y2esFRWwrClvo.O2jx3vKPzVfEhTBLx0yw.d__wtPe2Pdn9Hk_U4WpuoihkwnFuVYrtXnVBjON0k
 zZGf7tB.z9fZfSPdtvvUSPNeBpS6If1iDQ_rAynuCKoZVkRRx01hgKB50DVHZDOch0GKoew8ynoG
 bvUH4..mhJR71OtMCqFN3H4LRF8Kxc9huOsZApm.C3lDDUm6BskDE.zuPaeOtw5aGWkoGVOaFcwB
 Pdr72mANBdf4UtSWMVafO6Mn.5A7tPzdrF82CSbMhflXD82KFI7y1cNZS4fMUKW6Uvkdnp3RH3zX
 MtKUFHJxlbhXZQX8Ez9TAU_gGbGHJSfc_a89GDnvjw4aw.WzyXGfiBEmoK2QFWrbLOf2yEtdL7h5
 qFf43Q5RSQtNz7ycQG7CumwzuasuTS7.gzpn6ZyKN8PoZHDg8QmUkR723puCgWThIw18mERv3K1g
 4wuBtwraRG5q1H0i0v_LbQoxAr3u3rPJqU4A4xpdrsmXIPmH9djIswdb0qoCOhdj8.NKEu1R.ZPR
 8mqdF6dN2MioX8tduoeLUIOPquYyoFBRnB9WO9H5yNFhUR_uCD_30eR66.QdLh6XFMm_veawJCps
 nwmiyFp.Ghb2ix_Q8z7i3B4cnFBldehwXibcP_AJKjW7MpsJDL4U2cCBrsLYbMwM9m0Eciw.vT16
 QCKbXNAvWVJ.p1HTzfI_A5OCANy_LlYEnLBoXqeetfw1WiHIONpPpcXMp6phEcDWgPLSPHe8kc69
 GjPdCWqgoHkUvXB2EcZS_qlAkBYnA2yWm.QbkH4SUrvXcqic1BG2zx3LXMJzcxZjTreHdlVGAuSp
 r5f_c4_2IR6DNoB6J_1pNfZNmBF7Rik06Uyy4lrqBp78t2BQPvkAKLGzVrsyl.94TTbQhJIyPEcx
 1jj8UwYoJ2SoWUo817Add5FtCv44q_mC.gilyCvhjoYE16WVnEippr7RTqdwzE2PwzAPDW9WJXgn
 Jo3LGO.whZ03.
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Wed, 10 Jul 2019 00:10:21 +0000
Received: by smtp428.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 384beb4a60bf01dd00226d24882b8126;
          Wed, 10 Jul 2019 00:10:17 +0000 (UTC)
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
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <34552999-160e-4f60-8d7e-37f51c895ef4@schaufler-ca.com>
Date:   Tue, 9 Jul 2019 17:10:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1f5b5fc1-9a95-9748-f9dc-0486c6ae30d8@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/9/2019 3:13 PM, Xing, Cedric wrote:
> On 7/8/2019 4:53 PM, Casey Schaufler wrote:
>> On 7/8/2019 10:16 AM, Xing, Cedric wrote:
>>> On 7/8/2019 9:26 AM, Casey Schaufler wrote:
>>>> In this scheme you use an ema LSM to manage your ema data.
>>>> A quick sketch looks like:
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_something_in() calls
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 security_enclave_lo=
ad() calls
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ema_enclave_load()
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 selinux_enclave_load()
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 otherlsm_enclave_load()
>>>>
>>>> Why is this better than:
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_something_in() calls
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ema_enclave_load()
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 security_enclave_lo=
ad() calls
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 selinux_enclave_load()
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 otherlsm_enclave_load()
>>>
>>> Are you talking about moving EMA somewhere outside LSM?
>>
>> Yes. That's what I've been saying all along.
>>
>>> If so, where?
>>
>> I tried to make it obvious. Put the call to your EMA code
>> on the line before you call security_enclave_load().
>
> Sorry but I'm still confused.
>
> EMA code is used by LSMs only. Making it callable from other parts of t=
he kernel IMHO is probably not a good idea. And more importantly I don't =
understand the motivation behind it. Would you please elaborate?

LSM modules implement additional access control restrictions.
The EMA code does not do that, it provides management of data
that is used by security modules. It is not one itself. VFS
also performs this role, but no one would consider making VFS
a security module.

>>>>> +/**
>>>>> + * ema - Enclave Memory Area structure for LSM modules
>>>>
>>>> LSM modules is redundant. "LSM" or "LSMs" would be better.
>>>
>>> Noted
>>>
>>>>> diff --git a/security/Makefile b/security/Makefile
>>>>> index c598b904938f..b66d03a94853 100644
>>>>> --- a/security/Makefile
>>>>> +++ b/security/Makefile
>>>>> @@ -28,6 +28,7 @@ obj-$(CONFIG_SECURITY_YAMA)=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 +=3D yama/
>>>>> =C2=A0=C2=A0 obj-$(CONFIG_SECURITY_LOADPIN)=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 +=3D loadpin/
>>>>> =C2=A0=C2=A0 obj-$(CONFIG_SECURITY_SAFESETID)=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 +=3D safesetid/
>>>>> =C2=A0=C2=A0 obj-$(CONFIG_CGROUP_DEVICE)=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 +=3D device_cgroup.o
>>>>> +obj-$(CONFIG_INTEL_SGX)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 +=3D commonema.o
>>>>
>>>> The config option and the file name ought to match,
>>>> or at least be closer.
>>>
>>> Just trying to match file names as "capability" uses commoncap.c.
>>
>> Fine, then you should be using CONFIG_SECURITY_EMA.
>>
>>>
>>> Like I said, this feature could potentially be used by TEEs other tha=
n SGX. For now, SGX is the only user so it is tied to CONFIG_INTEL_SGX. I=
 can rename it to ema.c or enclave.c. Do you have a preference?
>>
>> Make
>> =C2=A0=C2=A0=C2=A0=C2=A0CONFIG_SECURITY_EMA
>> =C2=A0=C2=A0=C2=A0=C2=A0depends on CONFIG_INTEL_SGX
>>
>> When another TEE (maybe MIPS_SSRPQ) comes along you can have
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0CONFIG_SECURITY_EMA
>> =C2=A0=C2=A0=C2=A0=C2=A0depends on CONFIG_INTEL_SGX || CONFIG_MIPS_SSR=
PQ
>
> Your suggestions are reasonable. Given such config change wouldn't affe=
ct any code, can we do it later,

That doesn't make the current options any less confusing,
and it will be easier to make the change now than at some
point in the future.

> e.g., when additional TEEs come online and make use of these new hooks?=
 After all, security_enclave_init() will need amendment anyway as one of =
its current parameters is of type 'struct sgx_sigstruct', which will need=
 to be replaced with something more generic. At the time being, I'd like =
to keep things intuitive so as not to confuse reviewers.

Reviewers (including me) are already confused by the inconsistency.

>
>>>
>>>>> diff --git a/security/commonema.c b/security/commonema.c
>>>>
>>>> Put this in a subdirectory. Please.
>>>
>>> Then why is commoncap.c located in this directory? I'm just trying to=
 match the existing convention.
>>
>> commoncap is not optional. It is a base part of the
>> security subsystem. ema is optional.
>
> Alright. I'd move it into a sub-folder and rename it to ema.c. Would yo=
u be ok with that?

Sounds fine.


