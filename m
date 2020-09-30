Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21F8C4727C
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 18:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9016F2076A
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 18:09:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="XEO05EYO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgI3SJl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 14:09:41 -0400
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:38649 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI3SJk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 30 Sep 2020 14:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1601489380;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=LaADTRAfwO0zAeS/EokRJrk+XNpOAbTOKo/sRgzwei4=;
  b=XEO05EYOJkvHfCm7NS9RPMp/7rzJAgu6x7T0fXTpF1coW/Wsx/izVBfk
   YTIP27yz7GazBpiJ3rvTb2A1CZduRlrmACO3sLDKk/+BsQmD0kj3peERQ
   eO0Spe3ne1LamYDOJvaMlhJ2GfGrKEsSzWjnH84dupTsKbCxr06TzBqi7
   8=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: 0MDI8uIe+C4eAxVHrnH07uhWVEk8H5wrRvHoSas/Z2/irabd6C0ZtTMNlTY002k8ev1YCcUCdB
 cgnt7y29W6U8TtMLboWL1yvDaQiQO048sdScDploQ3qVc9ZLrFepoA5nseIKD/lAfCCSHLSSKp
 asUpWCiw9sS6g0QKGWJIa4dnWG8UHk7Pzk3u8xD9n8kuZwLpSPojCJQ0bC5HA+c37puzAhhQKz
 TkPsgh/SLnb0eIZ+BxN5NxicehVXUXKutF0SJy0ixsxwKW7j0kdo8LpPtg3u+TvZ7x8kj8cuDs
 EE4=
X-SBRS: None
X-MesageID: 28002573
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.77,322,1596513600"; 
   d="scan'208";a="28002573"
Subject: Re: [PATCH] x86/vdso: Remove retpoline from SGX vDSO call
To:     Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     <linux-sgx@vger.kernel.org>, <x86@kernel.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Cedric Xing" <cedric.xing@intel.com>
References: <20200930140108.48075-1-jarkko.sakkinen@linux.intel.com>
 <92578646-83a4-606c-b251-4d80cb62399c@intel.com>
 <20200930142017.GA49393@linux.intel.com>
 <112ad81e-16ab-d6e0-09e7-3658874434f7@intel.com>
 <20200930152806.GA52739@linux.intel.com>
 <20200930154349.GB32672@linux.intel.com>
 <17231664-3735-2d57-fbfa-9af838e224ab@intel.com>
 <f5021328-2fab-a404-108f-e28e26e6996c@fortanix.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <cc222137-e488-c48a-ca66-000e74944eea@citrix.com>
Date:   Wed, 30 Sep 2020 19:09:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f5021328-2fab-a404-108f-e28e26e6996c@fortanix.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 FTLPEX02CL05.citrite.net (10.13.108.178)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 30/09/2020 18:01, Jethro Beekman wrote:
> On 2020-09-30 18:28, Dave Hansen wrote:
>> On 9/30/20 8:43 AM, Sean Christopherson wrote:
>>>>> Do you recall why you added it in the first place?  What was the
>>>>> motivation for it?  Were you responding to a review comment?
>>>> Absolutely cannot recall it :-) I even cannot recall the exact time when
>>>> we landed the vDSO in the first place. Too much stuff has happend during
>>>> the long three year upstreaming cycle. I will try to backtrack this
>>>> info.
>>> It originated in a comment from Andy when we were discussing the legitimacy
>>> of the callback.  From that point on it got taken as gospel that the indirect
>>> call would be implemented as a retpoline.
>>>
>>> https://lkml.kernel.org/r/CALCETrVBR+2HjTqX=W4r9GOq69Xg36v4gmCKqK0wUjzAqBJnrw@mail.gmail.com
>> OK, so that was Andy L. saying:
>>
>>> But I have a real argument for dropping exit_handler: in this new age
>>> of Spectre, the indirect call is a retpoline, and it's therefore quite
>>> slow.  So I'm not saying NAK, but I do think it's unnecessary.
>> It sounds like we were never able to jettison the indirect call.  So,
>> we've got a kernel-provided indirect call that's only ever executed by
>> userspace.  A quick grep didn't show any other indirect branches in the
>> VDSO, so there might not be good precedent for what to do.
>>
>> The problem with the VDSO is that even if userspace is compiled to the
>> gills with mitigations, this VDSO branch won't be mitigated since it
>> comes from the kernel.
>>
>> So, here's the big question for me:  How does a security-sensitive
>> userspace *binary* make mitigated indirect calls these days?
>>
>> Seems like the kind of thing for which Intel should have a good writeup.  :)
>>
> If by "these days" you mean also protecting against LVI, then it'd be like so, I think:
>
> lfence 
> callq  *%rax
>
> (at least this is what the LLVM LVI hardening pass does)

The problem is that "what to do about speculation" is exceedingly
complicated.

The 2017/8 code samples to beat Spectre v2 are one of:

1) Retpoline (not totally safe on Skylake uarch, but pretty good)
2) (legacy) IBRS and CALL *reg/mem (Intel)
3) LFENCE; CALL *reg/mem (AMD)

Later (i.e. this year), there is finally public documentation from all
vendors concerning straight-line speculation, so the code fragments now
need to be:

1) Retpoline (not totally safe on Skylake uarch, but pretty good)
2) (legacy) IBRS and CALL *reg/mem; LFENCE (Intel)
3) LFENCE; CALL *reg/mem; LFENCE (AMD)

to avoid potential speculative type confusion in the remainder of the
basic block.

Same goes for indirect JMP (Intel and AMD) and RET (AMD only), although
as there is no architectural execution, you can use INT3/INT1 to halt
speculation with lower code volume than LFENCE.


As noted, to avoid LVI poisoning of the branch target, a leading LFENCE
is needed (or one of the even more complicated variations), including
ahead of the RET of a retpoline.  However in practice, its only code
inside the enclave which is possibly worth protecting in this way.


Intel hardware mitigations, eIBRS, comes recommended with switching back
to a plain CALL *reg/mem, until a recent paper where it was demonstrated
that even with eIBRS active, you can still get speculative type
confusion due to same-mode training.  If same-mode training is a
problem, the recommendation is to use eIBRS and Retpoline.

AMD hardware mitigations, simply called IBRS, is programmed in the same
way as eIBRS (i.e. turn it on at the start of day and leave it on), does
guarantee to to protect against same-mode training.


As for the VDSO, it is userspace, and there's no way that it will have
WRSS generally enabled.  Therefore, it cannot use a retpoline gadget
even with the "fix up the shadow stack" variation when CET is in use. 
Any of the other variations ought to be CET-safe.


What, if anything, userspace does to protect against Spectre attacks is
a matter of every piece of compiled code in every library loaded, and
the risk profile of the application itself.  A browser with a javascript
sandbox is liable to try and take more care than something like cowsay.


Honestly, my advice would be to leave it unprotected for now.  Anyone
who managed to figure out the rest of the practical userspace issues
will probably have a much better idea of what can/should be done in this
case.

If that doesn't sit well with people, then the next best would probably
be LFENCE; CALL *reg/mem; LFENCE to cover as many of the corner cases as
possible without being incompatible with CET.  Its not as if this
callback is the slow aspect of entering/exiting SGX mode.

~Andrew
