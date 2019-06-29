Return-Path: <SRS0=WPzH=U4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F259C5B57D
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Jun 2019 21:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05AED21726
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Jun 2019 21:35:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="b5lnELFW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfF2Vf3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 29 Jun 2019 17:35:29 -0400
Received: from sonic316-13.consmr.mail.gq1.yahoo.com ([98.137.69.37]:38295
        "EHLO sonic316-13.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726923AbfF2Vf2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 29 Jun 2019 17:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1561844127; bh=1h1MVZvMi4XMl3+4DwNQZ4K/UopIpDprk2yK6Bjrn9Y=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=b5lnELFWpTxW7CogHHdCwTW28hVvLewBWJMA16mZD1CCuWTGO76AaSSXmVQIyVjVxEPbqVKnLfehj4WfVtRiHXffNEdQIPV35jG1fcdomyhTFtVBsJwJzOJ2yhbKQg2q6yeULD52UuPbEArjb+fypd48rI63wo+j+MN/hI5Wrr+nNgqnIaubrXE543HXba+yJY7LP7dJb3kk4IRNAVugDXyUZOPY1r2iG2B9N7DffP4yZPu4MmziJNX/vQitNqJ+b61Ati8TITAXUrIT7bULM2QVOvEOHowttbypyaqcNCTsFjWlLb+X6kBqXFfTlNEUahwYgrcnGs8S+KPCh97VoA==
X-YMail-OSG: GAkoY2AVM1lDjxHJDeuSae_lALYp4djtw22FMzxlA0y7AC98148QV1pYvgsg8c0
 RMDrUOqaj0mkFOj4TnVrg.Z_Dlh5WV6vQJii3.sgFfzxWuWXXIrgUxEV1efAwbNdYoSPJxwrAYET
 9n0oed4iteOJv3iK8nOhN1MYyQu7gQA_erEs_.DrEdOhbdFqnPClrtc9sfK9zj5nXYyzmM_bXz3l
 FGbwQI4KQK0jf87W0yMQjUztL.Mc45Jccp3776f7sgpjRZq_1jlm5xizGSru0Us3LEw8J1yBedyT
 N5gTFOf0hp.vyIi5VPwD.SXAcF8K9Cwfb6PdM17FY0X.5.BkYZa1b3_P6tOn8B4FpKjdL4HB3MK1
 tYRrLItZdyLn9EL2GV.dwBy42.nkcrmJBO390Br.h1iNEAvf4XYiKS9SSCF_95geRvXUG_m2XFxD
 zZZwZgzYOljJsDewHfjl6UuhMjcuNzclWC3kKoEb7rN1YkbM.3P6fgT1LYQ5vGFtfOUv9Z5fpRyV
 RF5J7NxwqR8t_IUA_uKy9Or0FwiuA4coziXL4lAIV4q7aAC6jG2dkMHZs3IaX6UYB_KBy5O6Pxt1
 ZKxzyPIjRjLotdvy82ytSAQAYebSxXZ0i2e7EDAvNz1vrSKlXbjShujH4TsadQIIE_VHaThrIoHs
 Tj_OyfC1AvSE18.wdrMakFgLkRjnQ.Nea98.2ScNy.xo8WnqocqhUIT5st7PZoi_OIHgPVf8XYhw
 _LftDvEliz2_EP93yr8yFXkYVyXEeIWSkMMA.lVOlYKqBsNKRLb_pHkScTi4uzTCEy6cYb3K_FHz
 G4ZJF9p14A.SFxowySTGapGqoSn4rhk921MuWvCO41FZ0ZwGWukdP6LDWbJWmeP6HmkECZScyQGn
 nk14oe6dMUqAhfOFuZlOaLdbh1NlrroIKgsbc2.zsX6ssKOze9e6sZvHyBLk3ALdWmVkgBzn1ROv
 oIdP8F0DncX5b3XXw9a0wyQ6aqbmy2B3JyUIHTUqKZUA9XBF6RvxEwX5Tl7.dLhFL_Hs4EA4EmBv
 mt7TTQh7a5hcDhU55W1leFp_c2agWXEh9E3wHGry2EJvYP_9UdeSQiL_4XcF3npb5xjkYmB.qQV7
 nZIGba7eAPzPKxX2mzd_UWpOaNKkLq3fmyTkcYtoDqlxJO0KzvWhWdKmGht4GvnE6EJZPGpaZYa2
 75wBtOMlk5QyvskNFOGcyMUufGCDFsxupYlspltnUb4adaP.g83DSD0pRQUO14_3msqlYzC.ZyoW
 nD8b8oVW9Z5KiAXLe5i.NCKJ7jeUR3stpn.NzXqjkkctZUQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Sat, 29 Jun 2019 21:35:27 +0000
Received: from c-73-223-4-185.hsd1.ca.comcast.net (EHLO [192.168.0.103]) ([73.223.4.185])
          by smtp428.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 81cf90e268c20e028885b90963cab65e;
          Sat, 29 Jun 2019 21:35:26 +0000 (UTC)
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     Stephen Smalley <stephen.smalley@gmail.com>, casey@schaufler-ca.com
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "greg@enjellic.com" <greg@enjellic.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <b08798a5-65f7-f96e-1c04-39dd0e60c114@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551B8D7@ORSMSX116.amr.corp.intel.com>
 <9f525db2-f46b-b4cb-c4e9-b9dbd18ed4d2@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551B975@ORSMSX116.amr.corp.intel.com>
 <f6f16990-0291-c530-61dd-dcd26525285c@schaufler-ca.com>
 <CAB9W1A1RpM_9D_49E1VauuKE1tL=TyfeATomv47HX4FONnjA4A@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <18833f2e-9d18-1f39-6bc5-9242910ab25c@schaufler-ca.com>
Date:   Sat, 29 Jun 2019 14:35:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAB9W1A1RpM_9D_49E1VauuKE1tL=TyfeATomv47HX4FONnjA4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/28/2019 6:37 PM, Stephen Smalley wrote:
> On Fri, Jun 28, 2019 at 1:22 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> On 6/27/2019 5:47 PM, Xing, Cedric wrote:
>>>> From: Casey Schaufler [mailto:casey@schaufler-ca.com]
>>>> Sent: Thursday, June 27, 2019 4:37 PM
>>>>>> This code should not be mixed in with the LSM infrastructure.
>>>>>> It should all be contained in its own module, under security/encla=
ve.
>>>>> lsm_ema is *intended* to be part of the LSM infrastructure.
>>>> That's not going to fly, not for a minute.
>>> Why not, if there's a need for it?
>>>
>>> And what's the concern here if it becomes part of the LSM infrastruct=
ure.
>> The LSM infrastructure provides a framework for hooks
>> and allocation of blobs. That's it. It's a layer for
>> connecting system features like VFS, IPC and the IP stack
>> to the security modules. It does not implement any policy
>> of it's own. We are not going to implement SGX or any other
>> mechanism within the LSM infrastructure.
> I don't think you understand the purpose of this code.  It isn't
> implementing SGX, nor is it needed by SGX.
> It is providing shared infrastructure for security modules, similar to
> lsm_audit.c, so that security modules can enforce W^X or similar
> memory protection guarantees for SGX enclave memory, which has unique
> properties that render the existing mmap and mprotect hooks
> insufficient. They can certainly implement it only for SELinux, but
> then any other security module that wants to provide such guarantees
> will have to replicate that code.

I am not objecting to the purpose of the code.
I *am* objecting to calling it part of the LSM infrastructure.
It needs to be it's own thing, off somewhere else.
It must not use the lsm_ prefix. That's namespace pollution.
The code must not be embedded in the LSM infrastructure code,
that breaks with how everything else works.

=2E.. and the notion that you allocate data for one blob
that gets freed relative to another breaks the data management
model.



