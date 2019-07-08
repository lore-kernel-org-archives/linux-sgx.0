Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB86C606B0
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 23:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C265B2082A
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 23:53:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="ZeVk1Nfm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfGHXxs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 19:53:48 -0400
Received: from sonic310-23.consmr.mail.bf2.yahoo.com ([74.6.135.197]:39912
        "EHLO sonic310-23.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725939AbfGHXxs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 8 Jul 2019 19:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1562630026; bh=aaU3QEOexX5/RpFIIQjF/8s6bTWRrRAGnfopCw/bYsg=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject; b=ZeVk1NfmdB13Oamn9baqC2dnrpFwM9OvbMQ27PA+Ptzc8amF3H3namUeSAZKMqc4xhMImu9ZpVepnU6PFyZmf6yaP5DqmzTVtgcBXai/HBg/8pdCmlYT+W66F+YxmrX480OgxzriGmxHTg3ZcD2gRvkuptdqST1KPfQ9JyFNcdNVMgZ8P1PQdNgkisffs36wi3CaQg93KOCz9yFIIcR8GrfVgCosu10sqDBWT1kntPU647bh2IJUnanzetMfztd3w7gKlXTyEiI64oiquK0ID3TNVDPbRyefzLYILJPLIa5IptmSMiRqoQFLt9Bm/GjlIguzJbR98Zdh/rthEi+kqg==
X-YMail-OSG: ahQj6TYVM1mtG5HnBuDAFJIuHhtwUhw6jsYnB5QZq7ZyjuV9gciruMSA72yUeAW
 VVRYr1Wfb.SOM6k8duwE63Uc_IgtNez1MD8aBeTPRspXEXtfqPMIXr6opmU_mpFCEiu0.80zExGM
 qG6S.CajY2NYc7fX6KuJjGDKrqjfqdJbt97wY6twyASJfYTfXm_puMIChd79oA0waf_Yh6MDOt_t
 H2FBFOM667n_jeSY_2gc7BoG3vgzBLv85clfZlOmwjVYIjWvwMvUsT_TcaTXCmze0idBrZrfwx1q
 rLe_yNpda5fGBjxmVrIIwBsVLFPz0PoJn0v46kOgUo136UwtP.EqA.HBF__5qQ04MNdgUS1cp_fj
 sPnOyKLfnbUTykbxuHB6baYiHRX.YBtkK2VZ_CtXdaRUAudfOSnM7pqrLANENAXE4wmWo4831807
 PwcHypz_0.Yq0nGkuci7qOVFy9GHS8AFJ37GQPj3Ro3OXWfIhKiE8i1QWDJ3LDQwNUEBNVuqpPYF
 sM.PYkRt6Y8uYs0fD_Khev5KSM9ZZRtagvlyAM8E0k2uk_WF2FH12CTnDqoLAEWsfAtlFw.ICc06
 08wYW4aN32IM8MHdFZlz3kkXWPy_NQ9MV7he7oFwId5sJA8jdorq_RQffUgzSgiEHFL9e5MgBYrW
 7LeZVx.v4XxCW8OkZzeQXrbi1cnVnIVY4QHqU3dHSAago36pwmuZvQOjh5ty.Ka_DkHrMWEhKEXH
 8znaWjKvyGxwZJq6mQEbphGx2thp1e.G3ILiuM6cmBWBVerI0t8YH.GLfkrX0yhtRZAyvUqIIwDu
 H8oaRRr9p6gmAZs1vOgaWNkKdF.UOhZvAhPR6A5J9iXcjl9U1hgxcZWV5lGF0tTjqWJjjjwJ4ZCE
 seouKd85A1aqYkRsBNE3ztMh9Ki9_YRIA7TlOtu6ePlkClsWwuwvsZa1Fcz1jRnVe57zXkLUhLwQ
 2f86yTWm5VxbYivbe5WBaf6v2VETxz3V6hP7Ga74dyuMIm_PKIJ8VOgOM_T1imVfPGbVwDOKwzJy
 FPb5.J5us3UkoKzo4FhekuaIXXaWABROZVsjiNH_XhFSIEp42B2gSAOEEhJKEZ9b4utF9u3ZL8.g
 xIXS9Zzb3Ym2ixMYrHmIFp61JemNCsMfmgRKhNhSNh4N1R7RGyN3PxL0LvDwCyyR4FLXnw7PXU6a
 WoP0XHFsjvH4U88NoUgIGXPlyacIAd1cmH_W.p3U9sx2Hkw3tAXXGy_W_nGEe7Hhvf9nOw8OIKWr
 TCA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Mon, 8 Jul 2019 23:53:46 +0000
Received: by smtp432.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID f0fcb9de2197ac8dc1d60d3d32ef7f8d;
          Mon, 08 Jul 2019 23:53:45 +0000 (UTC)
Subject: Re: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
To:     "Xing, Cedric" <cedric.xing@intel.com>, linux-sgx@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        casey@schaufler-ca.com
References: <cover.1562542383.git.cedric.xing@intel.com>
 <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
 <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
 <ce4dcce2-88fb-ccec-f173-fc567d9ca006@intel.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <decc7ae6-a89f-1ae5-6289-f3dcaa6390b0@schaufler-ca.com>
Date:   Mon, 8 Jul 2019 16:53:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ce4dcce2-88fb-ccec-f173-fc567d9ca006@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/8/2019 10:16 AM, Xing, Cedric wrote:
> On 7/8/2019 9:26 AM, Casey Schaufler wrote:
>> In this scheme you use an ema LSM to manage your ema data.
>> A quick sketch looks like:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0sgx_something_in() calls
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 security_enclave_load() cal=
ls
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ema=
_enclave_load()
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sel=
inux_enclave_load()
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 oth=
erlsm_enclave_load()
>>
>> Why is this better than:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0sgx_something_in() calls
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ema_enclave_load()
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 security_enclave_load() cal=
ls
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sel=
inux_enclave_load()
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 oth=
erlsm_enclave_load()
>
> Are you talking about moving EMA somewhere outside LSM?

Yes. That's what I've been saying all along.

> If so, where?

I tried to make it obvious. Put the call to your EMA code
on the line before you call security_enclave_load().

>
>>
>> If you did really want ema to behave like an LSM
>> you would put the file data that SELinux is managing
>> into the ema portion of the blob and provide interfaces
>> for the SELinux (or whoever) to use that. Also, it's
>> an abomination (as I've stated before) for ema to
>> rely on SELinux to provide a file_free() hook for
>> ema's data. If you continue down the LSM route, you
>> need to provide an ema_file_free() hook. You can't
>> count on SELinux to do it for you. If there are multiple
>> LSMs (coming soon!) that use the ema data, they'll all
>> try to free it, and then Bad Things can happen.
>
> I'm afraid you have misunderstood the code. What is kept open and gets =
closed in selinux_file_free() is the sigstruct file. SELinux uses it to d=
etermine the page permissions for enclave pages from anonymous sources. I=
t is a policy choice made inside SELinux and has nothing to do with EMA.

OK.

>
> There's indeed an ema_file_free_security() to free the EMA map for encl=
aves being closed. EMA does *NOT* rely on any other LSMs to free data for=
 it. The only exception is when an LSM fails enclave_load(), it has to ca=
ll ema_remove_range() to remove the range being added, which was *not* re=
quired originally in v2.

OK.

>
>>> +/**
>>> + * ema - Enclave Memory Area structure for LSM modules
>>
>> LSM modules is redundant. "LSM" or "LSMs" would be better.
>
> Noted
>
>>> diff --git a/security/Makefile b/security/Makefile
>>> index c598b904938f..b66d03a94853 100644
>>> --- a/security/Makefile
>>> +++ b/security/Makefile
>>> @@ -28,6 +28,7 @@ obj-$(CONFIG_SECURITY_YAMA)=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 +=3D yama/
>>> =C2=A0 obj-$(CONFIG_SECURITY_LOADPIN)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 +=3D loadpin/
>>> =C2=A0 obj-$(CONFIG_SECURITY_SAFESETID)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 +=3D safesetid/
>>> =C2=A0 obj-$(CONFIG_CGROUP_DEVICE)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 +=3D device_cgroup.o
>>> +obj-$(CONFIG_INTEL_SGX)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 +=3D commonema.o
>>
>> The config option and the file name ought to match,
>> or at least be closer.
>
> Just trying to match file names as "capability" uses commoncap.c.

Fine, then you should be using CONFIG_SECURITY_EMA.

>
> Like I said, this feature could potentially be used by TEEs other than =
SGX. For now, SGX is the only user so it is tied to CONFIG_INTEL_SGX. I c=
an rename it to ema.c or enclave.c. Do you have a preference?

Make
	CONFIG_SECURITY_EMA
	depends on CONFIG_INTEL_SGX

When another TEE (maybe MIPS_SSRPQ) comes along you can have

	CONFIG_SECURITY_EMA
	depends on CONFIG_INTEL_SGX || CONFIG_MIPS_SSRPQ
=C2=A0

>
>>> diff --git a/security/commonema.c b/security/commonema.c
>>
>> Put this in a subdirectory. Please.
>
> Then why is commoncap.c located in this directory? I'm just trying to m=
atch the existing convention.

commoncap is not optional. It is a base part of the
security subsystem. ema is optional.


>
>>> +static struct lsm_blob_sizes ema_blob_sizes __lsm_ro_after_init =3D =
{
>>> +=C2=A0=C2=A0=C2=A0 .lbs_file =3D sizeof(atomic_long_t),
>>> +};
>>
>> If this is ema's data ema must manage it. You *must* have
>> a file_free().
>
> There is one indeed - ema_file_free_security().

I see it now.

>
>>
>>> +
>>> +static atomic_long_t *_map_file(struct file *encl)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return (void *)((char *)(encl->f_security) + ema_=
blob_sizes.lbs_file);
>>
>> I don't trust all the casting going on here, especially since
>> you don't end up with the type you should be returning.
>
> Will change.
>
>>> +}
>>> +
>>> +static struct ema_map *_alloc_map(void)
>>
>> Function header comments, please.
>
> Will add.

