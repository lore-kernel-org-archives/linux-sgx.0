Return-Path: <SRS0=ZaoB=VG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F45DC606D4
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 00:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23AC3216C4
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 00:02:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="Fcg/07gN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfGIACF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 20:02:05 -0400
Received: from sonic309-23.consmr.mail.bf2.yahoo.com ([74.6.129.197]:39492
        "EHLO sonic309-23.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725864AbfGIACE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 8 Jul 2019 20:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1562630521; bh=0bABuSM8vXX/kRlsageKPfgn55dZl7H1znqPEjOgo/Q=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=Fcg/07gN9ycliYqt0CrIE94dmIDMoQLbZVYzwxxEAVJr7ukVg8XppfUtpiYVp1sshOk4CcrCQGA89a4Q5aB/4MwU1HncDyeGtdWGfqzcQOreHCFg0VTpSqEFblUz4fDXOpC2tjTSg5crQJnWgws3VX0hS9mvJ1aVRneJ/N/QWB1qGYczgJjKl+R36TEFJSAIfPCaSRPXj87iK1a8X1Y68vcNeOeyirj9wtSUXBP3QF0CT9yN52QOirVr+r+hFSmxpE6wFkPIOAgFT0q6yquxp9Vw9tba+K9wO1UaI4KB07/upf2qqdmsWL3NXwJH472jyQCwJ+BVv0zLl7bt8hcSZg==
X-YMail-OSG: KBZNYx0VM1kMefjnITkys91Y53xZrTpuIYQsj3ZTgPXTF8HVxd9fblRRORolD6h
 Vn.9JpG.x4tuX9RHes0gvoVCg8S15jnd6e.t.NDr.Ov.J9RZDNHZPHPM2a7GRM7Ar18.LK5Oq0pv
 _T0hayBEp.ioEMmIrPmSlbfI8m5FdLBWtAjE89Vj_vQGjNpkBeVwzn.mMWd7V6TH8_dKti5T5syj
 ZJsStHWawY4qUwMcFRKtCy3i.sLIKofR36xFZ8Wa479RPEpqf91ujWcflDOLw.bv_sLeAjAHkMTs
 3icoj1P2BLR6t9KtD1bYOIqlcnhADRqLZUfHfh99bFhsBHx9WyLp8DDen9YMgHQ4HbauFa5n61fI
 hwTzh_HzzS.R6l60JwfqyEtdcmzMFyXRR5G29T2YKC0L8GEhE37L1uJPCKAl2RTL1BlYC_7KuUUE
 FLn5TDmTqhFpUu8Tm8T0IZoISfEMHpAFvxFVOZW9UmxinM_UBYWTWM0R.jE_WTsTPyGR99prSCpN
 iSEe0V3TW4oq.tH1cc5xOtWxzlfcvA1HzUp5jY0aD1YelejV4a7OF8b1MAkz_mcJHlN2CO7eEEXU
 SdV9LgIi_lkobJAA7RaOcF_5QSE5M6aak.hBETARcTUXMbt5gQcv3KMHJ9YYtnP4WTORVHKe1bk9
 mU29VWjkf1oq4jlLURossMmfk5FkvysgAuKoz_HocTnICTgR9us.9aHTe5Ip9ZDQvzxbaWwreSEs
 twKhVFAHHdfBRXo4QrKG5FMETL_n_RQsAdzlvFO5E2Ns2DB93jyDaN6cszyqK_DopUJLY3Ejpfjv
 W4nOaXJPK6veTH.vBLCritlIeug--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Tue, 9 Jul 2019 00:02:01 +0000
Received: by smtp409.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID fa96bfe426bb012e6c874f9d1fca7ee3;
          Tue, 09 Jul 2019 00:02:01 +0000 (UTC)
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     "Dr. Greg" <greg@enjellic.com>, casey@schaufler-ca.com
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <stephen.smalley@gmail.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
References: <CAB9W1A1RpM_9D_49E1VauuKE1tL=TyfeATomv47HX4FONnjA4A@mail.gmail.com>
 <18833f2e-9d18-1f39-6bc5-9242910ab25c@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D585@ORSMSX116.amr.corp.intel.com>
 <f59529e4-6cc8-2405-d7db-2519727f9a80@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D7F7@ORSMSX116.amr.corp.intel.com>
 <63c92ab6-dc8d-826b-b8bf-05ad262f06e4@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551DBF7@ORSMSX116.amr.corp.intel.com>
 <9e45df1b-3aac-e851-4ef2-5b262f5139bd@schaufler-ca.com>
 <20190703094651.GA29601@wind.enjellic.com>
 <012fc47d-4e9d-3398-0d9d-d9298a758c8d@schaufler-ca.com>
 <20190707133023.GA4521@wind.enjellic.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <256013f7-292d-7014-9abb-61755f07eb25@schaufler-ca.com>
Date:   Mon, 8 Jul 2019 17:02:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190707133023.GA4521@wind.enjellic.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/7/2019 6:30 AM, Dr. Greg wrote:
> On Wed, Jul 03, 2019 at 08:32:10AM -0700, Casey Schaufler wrote:
>
> Good morning, I hope the weekend has been enjoyable for everyone.
>
>>>> On 7/2/2019 12:42 AM, Xing, Cedric wrote:
>>>>> ...
>>>>> Guess this discussion will never end if we don't get into
>>>>> code. Guess it'd be more productive to talk over phone then come ba=
ck
>>>>> to this thread with a conclusion. Will that be ok with you?
>>>> I don't think that a phone call is going to help. Talking code
>>>> issues tends to muddle them in my brain. If you can give me a few
>>>> days I will propose a rough version of how I think your code should
>>>> be integrated into the LSM environment. I'm spending more time
>>>> trying (unsuccessfully :( ) to discribe the issues in English than
>>>> it will probably take in C.
>>> While Casey is off writing his rosetta stone,
>> I'd hardly call it that. More of an effort to round the corners on
>> the square peg. And Cedric has some ideas on how to approach that.
> Should we infer from this comment that, of the two competing
> strategies, Cedric's is the favored architecture?

With Cedric's latest patches I'd say there's only one
strategy. There's still some refinement to do, but we're
getting there.


>>> let me suggest that the
>>> most important thing we need to do is to take a little time, step bac=
k
>>> and look at the big picture with respect to what we are trying to
>>> accomplish and if we are going about it in a way that makes any sense=

>>> from an engineering perspective.
>>>
>>> This conversation shouldn't be about SGX, it should be about the best=

>>> way for the kernel/LSM to discipline a Trusted Execution Environment
>>> (TEE).  As I have noted previously, a TEE is a 'blackbox' that, by
>>> design, is intended to allow execution of code and processing of data=

>>> in a manner that is resistant to manipulation or inspection by
>>> untrusted userspace, the kernel and/or the hardware itself.
>>>
>>> Given that fact, if we are to be intellectually honest, we need to as=
k
>>> ourselves how effective we believe we can be in controlling any TEE
>>> with kernel based mechanisms.  This is particularly the case if the
>>> author of any code running in the TEE has adversarial intent.
>>>
>>> Here is the list of controls that we believe an LSM can, effectively,=

>>> implement against a TEE:
>>>
>>> 1.) Code provenance and origin.
>>>
>>> 2.) Cryptographic verification of dynamically executable content.
>>>
>>> 2.) The ability of a TEE to implement anonymous executable content.
>>>
>>> If people are in agreement with this concept, it is difficult to
>>> understand why we should be implementing complex state machines and
>>> the like, whether it is in the driver or the LSM.  Security code has
>>> to be measured with a metric of effectiveness, otherwise we are
>>> engaging in security theater.
>>>
>>> I believe that if we were using this lens, we would already have a
>>> mainline SGX driver, since we seem to have most of the needed LSM
>>> infrastructure and any additional functionality would be a straight
>>> forward implementation.  Most importantly, the infrastructure would
>>> not be SGX specific, which would seem to be a desirable political
>>> concept.
>> Generality introduced in the absence of multiple instances
>> often results in unnecessary complexity, unused interfaces
>> and feature compromise. Guessing what other TEE systems might
>> do, and constraining SGX to those models (or the other way around)
>> is a well established road to ruin. The LSM infrastructure is
>> a fine example. For the first ten years the "general" mechanism
>> had a single user. I'd say to hold off on the general until there
>> is more experience with the specific. It's easier to construct
>> a general mechanism around things that work than to fit things
>> that need to work into some preconceived notion of generality.=20
> All well taken points from an implementation perspective, but they
> elide the point I was trying to make.  Which is the fact that without
> any semblance of a discussion regarding the requirements needed to
> implement a security architecture around the concept of a TEE, this
> entire process, despite Cedric's well intentioned efforts, amounts to
> pounding a square solution into the round hole of a security problem.

Lead with code. I love a good requirements document, but
one of the few places where I agree with the agile folks is
that working code speaks loudly.

> Which, as I noted in my e-mail, is tantamount to security theater.

Not buying that. Not rejecting it, either. Without code
to judge it's kind of hard to say.

> Everyone wants to see this driver upstream.  If we would have had a
> reasoned discussion regarding what it means to implement proper
> controls around a TEE, when we started to bring these issues forward
> last November, we could have possibly been on the road to having a
> driver with reasoned security controls and one that actually delivers
> the security guarantees the hardware was designed to deliver.
>
> Best wishes for a productive week to everyone.
>
> Dr. Greg
>
> As always,
> Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
> 4206 N. 19th Ave.           Specializing in information infra-structure=

> Fargo, ND  58102            development.
> PH: 701-281-1686            EMAIL: greg@enjellic.com
> -----------------------------------------------------------------------=
-------
> "Any intelligent fool can make things bigger and more complex... It
>  takes a touch of genius - and a lot of courage to move in the opposite=

>  direction."
>                                 -- Albert Einstein

