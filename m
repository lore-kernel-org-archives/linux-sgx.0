Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5368C10F14
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 17:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC756218AC
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 17:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfJJRt7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 13:49:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:31513 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfJJRt7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 13:49:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 10:49:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="184493000"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga007.jf.intel.com with ESMTP; 10 Oct 2019 10:49:58 -0700
Subject: Re: [PATCH for_v23 16/16] x86/vdso: sgx: Rework
 __vdso_sgx_enter_enclave() to prefer "no callback"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
 <20191008044613.12350-17-sean.j.christopherson@intel.com>
 <15c03e7e-cd98-5ea2-82a1-a11bec4abe2a@intel.com>
 <20191009191003.GD19952@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <ff6afbe4-1fa9-a632-b5bf-2cdadbb50f37@intel.com>
Date:   Thu, 10 Oct 2019 10:49:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191009191003.GD19952@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/9/2019 12:10 PM, Sean Christopherson wrote:
> On Wed, Oct 09, 2019 at 11:00:55AM -0700, Xing, Cedric wrote:
>> On 10/7/2019 9:46 PM, Sean Christopherson wrote:
>>> -	/* Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
>>> -	 * restored after the exit handler returns. */
>>> +
>>> +	/* Invoke userspace's exit handler if one was provided. */
>>> +.Lhandle_exit:
>>> +	cmp	$0, 0x20(%rbp)
>>> +	jne	.Linvoke_userspace_handler
>>> +
>>> +.Lout:
>>> +	leave
>>> +	.cfi_def_cfa		%rsp, 8
>>> +	ret
>>> +
>>> +.Linvalid_leaf:
>>
>> Please set frame pointer back to %rbp here, or stack unwinding will fail.
> 
> Sorry, coffee isn't doing it's job, what's getting crushed, and where?

The frame pointer was %rbp but you changed it to %rsp 3 lines ago. 
That's correct after "leave" and execution won't pass "ret". But the 
unwinder doesn't know. So you have to restore frame pointer after "ret", by
	.cfi_def_cfa		%rbp, 16

As you mentioned in the stack alignment case, we just can't rely on code 
review to catch such bugs. We need a test case to make sure all CFI 
directives are correct, which was also a request from Andy.

>>> +.Lhandle_exception:
>>> +	mov	0x18(%rbp), %rcx
>>> +	test    %rcx, %rcx
>>> +	je	.Lskip_exception_info
>>
>> A single "jrcxz .Lskip_exception_info" is equivalent to the above 2
>> instructions combined.
> 
> Both implementations take a single uop on CPUs that support SGX.  IMO,
> using the simpler and more common instructions is more universally
> readable.

I'm not sure the processor could combine 2 instructions ("test"+"je") 
into just 1 uop. And "jrcxz" is also a broadly used instruction.

>>> +	/* Push @e, u_rsp and @tcs as parameters to the callback. */
>>>   	push	0x18(%rbp)
>>>   	push	%rbx
>>>   	push	0x10(%rbp)
>>> -	/* Call *%rax via retpoline */
>>> -	call	40f
>>> -	/* Restore %rsp to its original value left off by the enclave from last
>>> -	 * exit */
>>> +
>>> +	/* Pass the "return" value to the callback via %rcx. */
>>> +	mov	%eax, %ecx
>>
>> @e (ex_info) is almost always needed by every callback as it also serves as
>> the "context pointer". The return value on the other hand is insignificant
>> because it could be deduced from @e->EX_LEAF anyway. So I'd retain %rcx and
>> push %rax to the stack instead, given the purpose of this patch is to
>> squeeze out a bit performance.
> 
> Please take this up in patch 02/16, which actually introduced this change.

My apology but willing to pull all related discussions into a single thread.

If you adhere to the convention of "%rcx containing @e", then the code 
here could be
	push	%rax		// for stack alignment
	push	%rax		// return value
	push	%rbx		// u_rsp
	push	0x10(%rsp)	// tcs
				// %rcx left unchanged pointing to @e
>>> +	/* Clear RFLAGS.DF per x86_64 ABI */
>>> +	cld
>>> +
>>> +	/* Load the callback pointer to %rax and invoke it via retpoline. */
>>> +	mov	0x20(%rbp), %rax
>>
>> Per X86_64 ABI, %rsp shall be 16 bytes aligned before "call". But %rsp here
>> doesn't look aligned properly.
> 
> Argh, I probably botched it back in patch 02/16 too.  I'll see if I can
> add a check to verify %rsp alignment in the selftest, verifying via code
> inspection is bound to be error prone.
> 
>>> +	call	.Lretpoline
