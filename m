Return-Path: <SRS0=LTc5=DG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C222C4727C
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 15:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE10B207F7
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 15:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="TsSA7kCU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgI2PCI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 29 Sep 2020 11:02:08 -0400
Received: from esa3.hc3370-68.iphmx.com ([216.71.145.155]:4421 "EHLO
        esa3.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728630AbgI2PCI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 29 Sep 2020 11:02:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1601391728;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=XBRFpyrJEpRvy0QyVLarqAoZTQbT30+k+3nuuWCz/Iw=;
  b=TsSA7kCUK0NptaTiWDOFaYIPvaRzcfj6Nvzv+Gh2v/nu77sgQF/v0Fed
   7p8ukE+XIf2Ov7+3207i6uxAQTWHHolLFA02aYwsmw/anK7Y2NaW+96Cx
   h90vTrllf/5batjFwp0AHLMLuVhjuBksEyJgbxqEoO++H9ijKfCQCaFHR
   0=;
Authentication-Results: esa3.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: Jd2HVx8w/fgPfAhKp7DcsnFnYm5g5DfeQLHIgzBcGvwx0QI2eNU4djtRAcdl400sod5qVJgps0
 Dksi2wWFfnImnrnR/AmZpYUpauh19L7tSHN2ST/P0EClIymfVPNcV4QnaeQ7Vftre3Fj/QDHyB
 sCGGLudIhmEqsGcqC1d9VRpZE5aNdS/NdoU/GP8yFNjGC8zlmeDv0P+CMPwOTEsNd0oD6qCzvu
 71oZ0ntIwwNgz59YTyuMAd7UK6ko0zzyz6LwHlwoPPTecAeDBLMDgU2d7pjYf/jIwGhFkgTNBk
 PJ0=
X-SBRS: None
X-MesageID: 27846890
X-Ironport-Server: esa3.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.77,319,1596513600"; 
   d="scan'208";a="27846890"
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>
CC:     "H.J. Lu" <hjl.tools@gmail.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        <linux-sgx@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        <asapek@google.com>, Borislav Petkov <bp@alien8.de>,
        <chenalexchen@google.com>, Conrad Parker <conradparker@google.com>,
        <cyhanish@google.com>, "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        "Patrick Uiterwijk" <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, <yaozhangx@google.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
 <20200928005842.GC6704@linux.intel.com>
 <85bc15d5-93cd-e332-ae9a-1e1e66e1181d@citrix.com>
 <CAMe9rOpzXW0cSD=9E7drGEHH=pcm_NqvPiaR0pBJzYLeAt0_3g@mail.gmail.com>
 <CALCETrU4Rhc0fwzzKLSUgan2YmSovxVFYOZEmFnBHC4DbZ5RfQ@mail.gmail.com>
 <20200928215635.GF2705@linux.intel.com>
 <CAMe9rOoyxtf_kUCdb-TN+NmZsQNmFY8NLMObSdCB5bBVq1x+cQ@mail.gmail.com>
 <24b9f250-0f75-1a7d-688d-787ca53b388c@intel.com>
 <CALCETrViotikw5HcDnvuY8nm28bAcdMQjcVs88kXVf8sjb0C_w@mail.gmail.com>
 <761f457d-bbb0-4b8f-e472-6705bc1d3cd1@citrix.com>
 <f8a3826b-8e19-12a3-3280-21ba59616df8@intel.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <ac70e206-5ef8-b6c3-9a37-0e34b7c2f35d@citrix.com>
Date:   Tue, 29 Sep 2020 16:01:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f8a3826b-8e19-12a3-3280-21ba59616df8@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 FTLPEX02CL05.citrite.net (10.13.108.178)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 29/09/2020 15:10, Dave Hansen wrote:
> On 9/28/20 4:38 PM, Andrew Cooper wrote:
>>>> CET=y, BUG_SPECTRE_V2=y: does not exist
>>>> CET=n, BUG_SPECTRE_V2=y: vulnerable, use retpoline
>>>> CET=y, BUG_SPECTRE_V2=n: no retpoline, not vulnerable
>>>> CET=n, BUG_SPECTRE_V2=n: no retpoline, not vulnerable
>>> Just to confirm: does this mean that the CPU mitigates against user
>>> code mistraining the branch predictors for CPL0?
>> If (and only if) you have eIBRS enabled.
>>
>> eIBRS should be available on all CET-capable hardware, and Linux ought
>> to use it by default.
> You're totally right, of course.  I was (wrongly) thinking about this
> VDSO retpoline as kernel code.
>
> There's another wrinkle here.  Let's say we're vulnerable to a
> Spectre-v2-style attack and we want to mitigate it on CET hardware that
> has enhanced IBRS.  I'm not sure how reliable of a mitigation retpolines
> are on enhanced IBRS hardware.  Intel has recommended _against_ using
> them in some cases:
>
>> https://software.intel.com/security-software-guidance/api-app/sites/default/files/Retpoline-A-Branch-Target-Injection-Mitigation.pdf
> "On processors that support enhanced IBRS, it should be used for
> mitigation instead of retpoline."
> I actually authored that bit of the whitepaper, and I recall that this
> was not simply a recommendation based on performance advantages of using
> enhanced IBRS.  I can dig through some old email if we decide that we
> want to explore using a retpoline on enhanced IBRS hardware.

If only life were simple.

In light of https://arxiv.org/abs/2008.02307 which managed to
demonstrate that the original KAISER was actually a speculative attack
and nothing to do with the prefetch instruction, a discussion about
same-mode training happened.

The updated recommendation given was to continue using retpoline as well
as eIBRS to prevent same-mode training of the syscall indirect branch. 
Josh (CC'd) has been doing a lot of work to find and fix other
speculative leaks in this area.

For Skylake uarch and later, even if an RSB underflow leads to a BTB
lookup, it still requires an interrupt/NMI to hit one of two instruction
boundaries to empty the RSB, and an attacker with that level of control
probably has more interesting things to be trying to do.

Without retpoline (or something even more expensive such as IRET-ing
around), an attacker can still create speculative type confusion between
different system calls, when eIBRS is active.

Once you mix CET-SS in, this breaks, unless you're prepared to update
the retpoline gadget to include a WRSS to modify the shadow stack
alongside the regular stack.  Add this to the large pile of fun for
whomever has the privileg^W chore of implementing supervisor CET support.

>
> But, let's take a step back.  The changelog for this patch needs to at
> least have:
>
> 1. What is the attack being mitigated by the retpoline?
> 2. Do we actually want to mitigate it?
> 3. What options are there to mitigate it?
> 4. Which option does this patch use and why?
>
> Right now, there's not even a comment about this.

I agree.  The reason for using a retpoline here in the first place is
unclear.

~Andrew
