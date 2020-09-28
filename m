Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661D0C2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 23:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2078F2076A
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 23:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="cSPZKswN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgI1Xib (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:38:31 -0400
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:17899 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgI1Xia (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 28 Sep 2020 19:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1601336310;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0LzZbRFl/CyU9nd3qjv74lv4REKcZF26xakkDStIRxg=;
  b=cSPZKswN/TBYpB4qIRrlCWlbmE1qtC9umR0IKGwM2tMiMlLNPgRXzd+p
   WKDwNvBnpNqMtuL47qCRJtT9ymKobIyTFxAN1PCcuoIaTY9kYS4GsKTp3
   tAJqSX69HKPWKIcObo6PhzTnGQjv8t3oyCvDFFpMtkatAAiFiRbs4Hfsz
   8=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: e+CimQ0poSeBPYJpvoJ5c8XZ5T4rkFR0OV3pAgxkdjnmShDp5A6Y4yHlKdIuJ0RgL1KiinY5dS
 uTw0GBAvPRmNgTd7hS0FZu9XD5XCZztSImN2q4kvAhcscjnQkrC1Ex4yJkYkxLFwf854o+Xznk
 sXUGmRZPvNqaA2D/oE9Hi7xnfteWZv3iKwX5/N+MPGi4f5maTc7Rvv/2OJK/OwWj2M9IZn8jRV
 cdJpUQpfQPGHxbKxkSYVx++qensJMeKDAqsmeKFVk80+tlSwdUAfVPh/kD4ZvL0RfCRLEkenTi
 FvY=
X-SBRS: None
X-MesageID: 27814137
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.77,315,1596513600"; 
   d="scan'208";a="27814137"
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
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
        Yu-cheng Yu <yu-cheng.yu@intel.com>
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
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <761f457d-bbb0-4b8f-e472-6705bc1d3cd1@citrix.com>
Date:   Tue, 29 Sep 2020 00:38:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALCETrViotikw5HcDnvuY8nm28bAcdMQjcVs88kXVf8sjb0C_w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 FTLPEX02CL05.citrite.net (10.13.108.178)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 28/09/2020 23:41, Andy Lutomirski wrote:
> On Mon, Sep 28, 2020 at 3:18 PM Dave Hansen <dave.hansen@intel.com> wrote:
>> On 9/28/20 3:06 PM, H.J. Lu wrote:
>>>> I'm open to do either solution. My thinking was to initially do things
>>>> vsgx.S local (i.e. consider ALTERNATIVE post upstreaming) and use the
>>>> above solution but I'm also fine doing ALTERNATIVE. Dave kindly briefed
>>>> on details how that thing works and it should be perfectly usable for
>>>> our use case.
>>>>
>>> Since SHSTK and IBT are enabled per process, not the whole machine,
>>> are you going to patch vDSO on a per-process basis?
>> No.
>>
>> Retpolines mitigate Spectre v2 attacks.  If you're not vulnerable to
>> Spectre v2, you don't need retpolines.
>>
>> All processors which support CET *also* have hardware mitigations
>> against Spectre v2 and don't need retpolines.  Here's all of the
>> possibilities:
>>
>> CET=y, BUG_SPECTRE_V2=y: does not exist
>> CET=n, BUG_SPECTRE_V2=y: vulnerable, use retpoline
>> CET=y, BUG_SPECTRE_V2=n: no retpoline, not vulnerable
>> CET=n, BUG_SPECTRE_V2=n: no retpoline, not vulnerable
> Just to confirm: does this mean that the CPU mitigates against user
> code mistraining the branch predictors for CPL0?

If (and only if) you have eIBRS enabled.

eIBRS should be available on all CET-capable hardware, and Linux ought
to use it by default.

> Because this is the
> vDSO, and the situation we're actually concerned about is user code
> mistraining its own branch predictors.  This could happen
> cross-process or within the same process.

There is nothing (in Intel parts) which prevents mode same-mode training
of indirect branches, either in user or kernel space.

However, an IBPB on context switch should prevent cross-process trailing
attacks.

~Andrew
