Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE2DC2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 23:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30FB1207D8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 23:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="P9dMx0qu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgI1Xws (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:52:48 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:27036 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgI1Xwr (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 28 Sep 2020 19:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1601337167;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=9havvRmmnKCNOTaJIQHciec4LD86I1g+WXR70O2VXJg=;
  b=P9dMx0quCAmhKnVymvBqsRvqqQnELoTBqlI7eYEuW2UTMCAm19FbOQ1m
   yKLiae1LfO58RMtu8x9UfhWy+h4XNvGaq2CNMQC8K3ynVrGA7sS5ZN9cP
   a5PU2kN9L/9FoMaignvJwmj8eyvwju02tYkAvgdkuS+48CHjveUE+BCZM
   w=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: 8d4z3LX7+XoKNY4TVCAIRG8YMWjcRRGpOgZxIDEyjuje0amF5lXR9SmLIqXia/b+NM0FbXAXVE
 TSLJz6nRD/C5S6dQn7IkF8DaYGLF/LM2+YkQkmAvGW2j2q135qMSzFkA6r6C4XuPqMj9gyYO0X
 zWZrQ8ad2SUcyzkkb0Ldq0B5uecctWxWaTbKba7rzjAvJ/6ck0frHPesLBbACneXNryYEgQz4q
 x31TpJbzn8MxO1hmZqbr+cL0Jxwj1shSDV1TUp5nAntQzH+gH9edKdnQqXMjrcUIxZFV+ZkcsS
 HiE=
X-SBRS: None
X-MesageID: 28144873
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.77,315,1596513600"; 
   d="scan'208";a="28144873"
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     <x86@kernel.org>, <linux-sgx@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        <akpm@linux-foundation.org>, <andriy.shevchenko@linux.intel.com>,
        <asapek@google.com>, <bp@alien8.de>, <chenalexchen@google.com>,
        <conradparker@google.com>, <cyhanish@google.com>,
        <dave.hansen@intel.com>, <haitao.huang@intel.com>,
        <josh@joshtriplett.org>, <kai.huang@intel.com>,
        <kai.svahn@intel.com>, <kmoy@google.com>, <ludloff@google.com>,
        <luto@kernel.org>, <nhorman@redhat.com>, <npmccallum@redhat.com>,
        <puiterwijk@redhat.com>, <rientjes@google.com>,
        <tglx@linutronix.de>, <yaozhangx@google.com>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
 <20200928005842.GC6704@linux.intel.com>
 <85bc15d5-93cd-e332-ae9a-1e1e66e1181d@citrix.com>
 <20200928204258.GA2705@linux.intel.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <7a3e45a5-513a-1d77-fa64-8f4a9f67e3ab@citrix.com>
Date:   Tue, 29 Sep 2020 00:52:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200928204258.GA2705@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 FTLPEX02CL05.citrite.net (10.13.108.178)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 28/09/2020 21:42, Jarkko Sakkinen wrote:
> On Mon, Sep 28, 2020 at 05:44:35PM +0100, Andrew Cooper wrote:
>> On 28/09/2020 01:58, Jarkko Sakkinen wrote:
>>> On Fri, Sep 25, 2020 at 07:23:59PM +0100, Andrew Cooper wrote:
>>>> On 15/09/2020 12:28, Jarkko Sakkinen wrote:
>>>>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
>>>>> new file mode 100644
>>>>> index 000000000000..adbd59d41517
>>>>> --- /dev/null
>>>>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
>>>>> @@ -0,0 +1,157 @@
>>>>> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
>>>>> <snip>
>>>>> +.Lretpoline:
>>>>> +	call	2f
>>>>> +1:	pause
>>>>> +	lfence
>>>>> +	jmp	1b
>>>>> +2:	mov	%rax, (%rsp)
>>>>> +	ret
>>>> I hate to throw further spanners in the work, but this is not compatible
>>>> with CET, and the user shadow stack work in progress.
>>> CET goes beyond my expertise. Can you describe, at least rudimentary,
>>> how this code is not compatible?
>> CET Shadow Stacks detect attacks which modify the return address on the
>> stack.
>>
>> Retpoline *is* a ROP gadget.  It really does modify the return address
>> on the stack, even if its purpose is defensive (vs Spectre v2) rather
>> than malicious.
> Aah. I get that, yes.
>
> Kernel is full of retpoline but I presume that ring-0 does not use CET.

No-one has implemented support CET-SS support for Linux itself yet, but
other kernels do have it working.

~Andrew
