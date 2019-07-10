Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A19DC74A35
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 18:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB7D0208C4
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 18:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfGJSIi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Jul 2019 14:08:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:38814 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727315AbfGJSIi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Jul 2019 14:08:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 11:08:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="365013629"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.255.93.70]) ([10.255.93.70])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jul 2019 11:08:37 -0700
Subject: Re: [RFC PATCH v2 0/3] An alternative __vdso_sgx_enter_enclave() to
 allow enclave/host parameter passing using untrusted stack
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        kai.svahn@intel.com, kai.huang@intel.com
References: <cover.1555965327.git.cedric.xing@intel.com>
 <20190424062623.4345-1-cedric.xing@intel.com>
 <20190710111719.nnoedfo4wvbfghq7@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <686e47d2-f45c-6828-39d1-48374925de6c@intel.com>
Date:   Wed, 10 Jul 2019 11:08:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710111719.nnoedfo4wvbfghq7@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/10/2019 4:17 AM, Jarkko Sakkinen wrote:
> On Tue, Apr 23, 2019 at 11:26:20PM -0700, Cedric Xing wrote:
>> The current proposed __vdso_sgx_enter_enclave() requires enclaves to preserve
>> %rsp, which prohibits enclaves from allocating space on the untrusted stack.
>> However, there are existing enclaves (e.g. those built with current Intel SGX
>> SDK libraries) relying on the untrusted stack for passing parameters to
>> untrusted functions (aka. o-calls), which requires allocating space on the
>> untrusted stack by enclaves. And given its simplicity and convenience, it could
>> be desired by future SGX applications as well.
>>
>> This patchset introduces a new ABI for __vdso_sgx_enter_enclave() to anchor its
>> stack frame on %rbp (instead of %rsp), so as to allow enclaves to "push" onto
>> the untrusted stack by decrementing the untrusted %rsp. Additionally, this new
>> __vdso_sgx_enter_enclave() will take one more parameter - a callback function,
>> to be invoked upon all enclave exits (both AEX and normal exits). The callback
>> function will be given the value of %rsp left off by the enclave, so that data
>> "pushed" by the enclave (if any) could be addressed/accessed.  Please note that
>> the callback function is optional, and if not supplied (i.e. null),
>> __vdso_sgx_enter_enclave() will just return (i.e. behave the same as the
>> current implementation) after the enclave exits (or AEX due to exceptions).
>>
>> The SGX selftest is augmented by two new tests. One exercises the new callback
>> interface, and serves as a simple example to showcase how to use it; while the
>> other validates the hand-crafted CFI directives in __vdso_sgx_enter_enclave()
>> by single-stepping through it and unwinding call stack at every instruction.
> 
> Why does the SDK anyway use real enclaves when step debugging? I don't
> think kernel needs to scale to that. For me it looks more like a bad
> architectural choice in the SDK implementation than anything else.

Intel's SGX SDK *does* support simulation mode for debugging enclaves 
outside of SGX mode, or even on non-SGX platforms. But nothing can 
replace the real SGX environment, hence SGX ISA supports debugging real 
enclaves.

> You should design SDK in a way that it doesn't run the code inside real
> enclave at first. It is just the sanest development model to use. The
> current SDK has an unacceptable requirement that the workstation used to
> develop code destined to run inside enclave must possess an appropriate
> hardware. I don't think that is acceptable no matter what kind of API
> kernel provides to invoke enclaves.

SDK supports simulation on non-SGX platforms.

> I think "real" debug enclaves are only good for production testing when
> you have more or less ready to release/deploy something but still want
> to be able to get a memory dump of the enclave on occassion.

That's true.

> With these conclusions I think the current vDSO API is sufficient for
> Linux.

The new vDSO API is to support data exchange on stack. It has nothing to 
do with debugging. BTW, the community has closed on this.

The CFI directives are for stack unwinding. They don't affect what the 
code does so you can just treat them as NOPs if you don't understand 
what they do. However, they are useful to not only debuggers but also 
exception handling code. libunwind also has a setjmp()/longjmp() 
implementation based on CFI directives.

> /Jarkko
> 
