Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF468C06511
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 19:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD0B321721
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 19:54:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="tdV9Mpul"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGATyB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 15:54:01 -0400
Received: from sonic316-12.consmr.mail.gq1.yahoo.com ([98.137.69.36]:44592
        "EHLO sonic316-12.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbfGATyB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Jul 2019 15:54:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1562010838; bh=OlZPxP24xoTomViUU3FGMuQYbKXJlhRk1vpbNqzmMJ8=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=tdV9MpulgYXCJU3HRmg8qA/L1dUQXDxaKAzti4cvQBJZxn335EE2pbMGk8s+h8DdPc34V83L8C+wtB1tzL0FGSGD3gdnMlbsmTbDFvpKsUe1/W81rBIllEs3Or0xv6iGTGkq4+ib1vucJQdyJodVRq2JkDmVscUeJet0LG2E7QUGFpVntcZHAchXoyMVbJJ0NfnvvxCHFscS5sAx4ynDWzADgiLlsWWGc0IQRnCYowXhSBOmLgfabrBhkgT74YurUTxYxcXZ2hwCVcp5uHPrYWLU6wfnH7HjSg+6kwrIYeBa67jfIxA30i3VSdJePMpARDz6z0wbppP34nqXX6ZmVA==
X-YMail-OSG: TP5BE.gVM1ntXkGRSgP8gJtPHqrt0Fz2XpQgroiG5OCLa.EYqzBI0BetwOuKBFS
 S7Y8I96_91ED947RmbavcyYkcw54pGVE0h1TBsR.Ot60G1LqEMb6P8YahqbwJgJk1fDQLiayrPjh
 EMgs.4RqKM.tloMocalFLxXD.srceGdRW6S5dTrssyRuGwIAfitQdf4TJBKIZNjcevkJ3HZIVUGF
 piRKk_zJGtDr.HLMsGPyH2_UFHEN5qH6C0W34O59J265pKOiC6Yb8H627Q8nSyaXYgTr2G0C33yl
 ZK5HHuf3vOEosP9ZZtpUHQWrvV5LEexVaKMsFDsDILt38OlBymIMIOmvfeHNBkW5J0nfSrjR30Um
 lI3r54VaCDoFC11WpqwO.wkN8mdpGVZJ8A1UquTIdIfB8tpJ0Iwc43GnipdwCjE2PsaHzS1IzVA_
 nlw1klaCP1ofe960T_SZbdPVSPtcaADKBoRU9p6OUFkk0Ss9o21PazkDph4mo33rWD3KRKbfgNIp
 1LV9nvc8gjKkEBvCeBkQos8kAESqxvpKYtvkzPeGSIuHEnt7BkVT15GtUY8Qu.CdZkFAPC6YZ8Dq
 nW4DrSGJFJPfrdlJJsKD5SCzvJGc3NFoNZPAIPWXpy8Sv9_KcxveWrbIDLcZUTxJNYF85MiaEMrz
 gVV1FUdmj9RU3WZQ4pOKVEJMveO92q91qc71BWEkvePepu2DGE4xgCuKPScXpueUyVoWIl0wKB0b
 IBT0onBhyEVvi927PcAfogXlRSm7Br1znbABGzgOnEJIp1Je4yKdQfVQqg7.vEgn6byYV7kZnEbo
 YLY6H1Jb3H7OdQKnMjiO_iesOFAGPSrw9dKu7EhKFcVG0iXbZhULyUxb2IilMZ3iColHz6TRk3rS
 CMI4QuVDcoATaRgJWknyYipXtQxx10aI9.au_upaObVQSAWsyJ4w1gOwJYUSRETRQtYn6jywmVNs
 jaDfrpx8XaIHXg65lWqAZdZxlWsjsoQbyPK.mjRdUa5aLMh_dFMu2mL.YQn9AOF04i5vjEJprJUt
 mYAv_.iJilLh8cSTlxSfjoO7LaiHVDGTYAJ.kRj1KgmPEJD92FsQl2Ol23c3hnrPfAUaHWk64VLW
 xb06n7gE8HXPzWHWJoyOifbnAHzCgT5p7jP7QgrFcmUWJix6uLJuHnXPNZ29gk9gw6Uwb3VoIgYH
 uJI5vwMTza7eYzNIKfpzZPoKbe08K6zgAq2CCYadGw2kcjhfZg_W4X.OxmP7xN4tIo6ze2r_8mj7
 as3jpwKQtYeXEvTw-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Mon, 1 Jul 2019 19:53:58 +0000
Received: from c-73-223-4-185.hsd1.ca.comcast.net (EHLO [192.168.0.103]) ([73.223.4.185])
          by smtp420.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID e789977e2a7f5ae10864b88979783299;
          Mon, 01 Jul 2019 19:53:58 +0000 (UTC)
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <stephen.smalley@gmail.com>,
        casey@schaufler-ca.com
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
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
 <18833f2e-9d18-1f39-6bc5-9242910ab25c@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D585@ORSMSX116.amr.corp.intel.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <f59529e4-6cc8-2405-d7db-2519727f9a80@schaufler-ca.com>
Date:   Mon, 1 Jul 2019 12:53:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551D585@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/1/2019 10:57 AM, Xing, Cedric wrote:
>> From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
>> owner@vger.kernel.org] On Behalf Of Casey Schaufler
>>
>> On 6/28/2019 6:37 PM, Stephen Smalley wrote:
>>> On Fri, Jun 28, 2019 at 1:22 PM Casey Schaufler <casey@schaufler-
>> ca.com> wrote:
>>>> On 6/27/2019 5:47 PM, Xing, Cedric wrote:
>>>>>> From: Casey Schaufler [mailto:casey@schaufler-ca.com]
>>>>>> Sent: Thursday, June 27, 2019 4:37 PM
>>>>>>>> This code should not be mixed in with the LSM infrastructure.
>>>>>>>> It should all be contained in its own module, under
>> security/enclave.
>>>>>>> lsm_ema is *intended* to be part of the LSM infrastructure.
>>>>>> That's not going to fly, not for a minute.
>>>>> Why not, if there's a need for it?
>>>>>
>>>>> And what's the concern here if it becomes part of the LSM
>> infrastructure.
>>>> The LSM infrastructure provides a framework for hooks and allocation=

>>>> of blobs. That's it. It's a layer for connecting system features lik=
e
>>>> VFS, IPC and the IP stack to the security modules. It does not
>>>> implement any policy of it's own. We are not going to implement SGX
>>>> or any other mechanism within the LSM infrastructure.
>>> I don't think you understand the purpose of this code.  It isn't
>>> implementing SGX, nor is it needed by SGX.
>>> It is providing shared infrastructure for security modules, similar t=
o
>>> lsm_audit.c, so that security modules can enforce W^X or similar
>>> memory protection guarantees for SGX enclave memory, which has unique=

>>> properties that render the existing mmap and mprotect hooks
>>> insufficient. They can certainly implement it only for SELinux, but
>>> then any other security module that wants to provide such guarantees
>>> will have to replicate that code.
>> I am not objecting to the purpose of the code.
>> I *am* objecting to calling it part of the LSM infrastructure.
>> It needs to be it's own thing, off somewhere else.
>> It must not use the lsm_ prefix. That's namespace pollution.
>> The code must not be embedded in the LSM infrastructure code, that
>> breaks with how everything else works.
> If you understand the purpose,

The purpose is to support the SGX hardware, is it not?
If you don't have SGX hardware (e.g. MIPS, ARM, s390) you
don't need this code.

> then why are you objecting the lsm_ prefix as they are APIs to be used =
by all LSM modules?

We name interfaces based on what they provide, not who consumes them.
As your code provides enclave services, that is how they should be named.=


>  Or what should be the prefix in your mind?

I'm pretty sure that I've consistently suggested "enclave".=20

> Or what kind of APIs do you think can qualify the lsm_ prefix?

Code that implements the LSM infrastructure. There is one LSM
blob allocation interface, lsm_inode_alloc(), that is used in
early set-up that is exported. As I've mentioned more than once,
enclave/page management is not an LSM infrastructure function,
it's a memory management function.

> And I'd like to clarify that it doesn't break anything, but is just a b=
it different, in that security_enclave_load() and security_file_free() ca=
ll into those APIs.

There should be nothing in security_enclave_load() except calls to the en=
clave_load()
hooks (e.g. selinux_enclave_load()). There should be nothing in security_=
file_free()
except file blob management calls to the file_free() hooks (e.g. apparmor=
_file_free()).=20

> But there's a need for them because otherwise code/data would have to b=
e duplicated among LSMs

There's plenty of code duplication among the LSMs, because a lot
of what they do is the same thing. Someday there may be an effort
to address some of that, but I don't think it's on anybody's radar.
As for data duplication, there's a reason we use lots of pointers.

> and the logic would be harder to comprehend.

Keeping the layering clean is critical to comprehension.
There's a lot of VFS code that could have been implemented
within the LSM infrastructure, but I don't think that anyone
would argue that it should have been.

> So that's a trade-off.

I remain completely unconvinced that your proposal
represents a good way to implement you scheme.

> Then what's the practical drawback of doing that?

Name space pollution.
Layering violation.
Architecture specific implementation detail in a
general infrastructure.

> If no, why would we want to pay for the cost for not doing that?

Modularity and maintainability come directly to mind.

>> ... and the notion that you allocate data for one blob that gets freed=

>> relative to another breaks the data management model.
> What do you mean here?

You're freeing the EMA data from security_file_free().
If selinux wants to free EMA data it has allocated in
selinux_enclave_load() in selinux_file_free() that's fine,
but the LSM infrastructure has no need to know about it.
EMA needs to manage its own data, just like VFS does.
The LSM infrastructure provides blob management so that
the security modules can extend data if they want to.

> EMA blobs are allocated/freed *not* relative to any other blobs.

In the code you proposed they are freed in security_file_free().
That is for file blob management.=20


