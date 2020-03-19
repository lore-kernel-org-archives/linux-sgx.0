Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BC8C4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 00:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F7820752
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 00:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgCSAie (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 20:38:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:39210 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSAie (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 20:38:34 -0400
IronPort-SDR: PLO/IHPNv6XPrr4CzR33lbvkr/olIUPZjekq6xrODtOxJToJopWUjsiiW8+S9ZPOqhKEwFhv5G
 uZY163HNNCwQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 17:38:33 -0700
IronPort-SDR: vT8maMTOcWgDmJyN8AhIEyRYNa9iOkBQcsCuCK7QfCe4l+pS+tzcNuOn4b6vDfBgYY8wymh2Pg
 hSB+EsPtqNaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="234013777"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.135.9.124]) ([10.135.9.124])
  by orsmga007.jf.intel.com with ESMTP; 18 Mar 2020 17:38:30 -0700
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
References: <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <254f1e35-4302-e55f-c00d-0f91d9503498@fortanix.com>
 <CAOASepOm8-2UCdEnVMopEprMGWjkYUbUTX++dHaqCafi2ju8mA@mail.gmail.com>
 <20200313164622.GC5181@linux.intel.com>
 <CAOASepN1hxSgxVJAJiAbSmuCTCHd=95Mnvh6BKNSPJs=EpAmbQ@mail.gmail.com>
 <20200313184452.GD5181@linux.intel.com>
 <CAOASepP_oGOenjCvAvLg+e+=fz4H0X=cyD+v5ywD0peeXEEmYg@mail.gmail.com>
 <20200313220820.GE5181@linux.intel.com>
 <CAOASepMicT6CrYyDkoYizh4nAZ+1Zn4rGQh7QjfzSK72Fj6u_g@mail.gmail.com>
 <20200318234057.GE26164@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <858d19ed-868b-b4be-cbac-6cb92349d8fb@intel.com>
Date:   Wed, 18 Mar 2020 17:38:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200318234057.GE26164@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/18/2020 4:40 PM, Sean Christopherson wrote:
> On Sat, Mar 14, 2020 at 10:10:26AM -0400, Nathaniel McCallum wrote:
>> On Fri, Mar 13, 2020 at 6:08 PM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>>>>> 4. sub/add to %rsp rather than save/restore
>>>>>
>>>>> Can you elaborate on why you want to sub/add to %rsp instead of having the
>>>>> enclave unwind the stack?  Preserving %rsp across EEXIT/ERESUME seems more
>>>>> in line with function call semantics, which I assume is desirable?  E.g.
>>>>>
>>>>>    push param3
>>>>>    push param2
>>>>>    push param1
>>>>>
>>>>>    enclu[EEXIT]
>>>>>
>>>>>    add $0x18, %rsp
>>>>
>>>> Before enclave EEXIT, the enclave restores %rsp to the value it had
>>>> before EENTER was called. Then it pushes additional output arguments
>>>> onto the stack. The enclave calls EENCLU[EEXIT].
>>>>
>>>> We are now in __vdso...() on the way back to the caller. However, %rsp
>>>> has a different value than we entered the function with. This breaks
>>>> x86_64 ABI, obviously. The handler needs to fix this up: how does it
>>>> do so?
> 
> Circling back to this request, because I just realized that the above is
> handled by saving %rsp into %rbp and requiring the enclave and handler
> to preserve %rbp at all times.
> 
> So the below discussion on making the %rsp adjustment relative is moot,
> at least with respect to getting out of __vdso() if the enclave has mucked
> with the untrusted stack.
> 
I didn't follow the discussion closely enough to understand the 
motivation behind "add/sub" rather than "restore" %rsp. Now I understand 
and I agree with you that the requested change is unnecessary.

>>>> In the current code, __vdso..() saves the value of %rsp, calls the
>>>> handler and then restores %rsp. The handler can fix up the stack by
>>>> setting the correct value to %rbx and returning without restoring it.
>>>
>>> Ah, you're referring to the patch where the handler decides to return all
>>> the way back to the caller of __vdso...().
>>>
>>>> But this requires internal knowledge of the __vdso...() function,
>>>> which could theoretically change in the future.
>>>>
>>>> If instead the __vdso...() only did add/sub, then the handler could do:
>>>> 1. pop return address
>>>> 2. pop handler stack params
>>>> 3. pop enclave additional output stack params
>>>> 4. push handler stack params
>>>> 5. push return address
> 
> Per above, this is unnecessary when returning to the caller of __vdso().
> It would be necessary if the enclave wasn't smart enough to do it's own
> stack cleanup, but that seems like a very bizarre contract between the
> enclave and its runtime.
> 
> The caveat is if %rbx is saved/restored by __vdso().  If we want a
> traditional frame pointer, then %rbx would be restored from the stack
> before %rsp itself is restored (from %rbp), in which case the exit handler
> would need to adjust %rsp using a sequence similar to what you listed
> above.
> 
> If __vdso() uses a non-standard frame pointer, e.g.
> 
>    push %rbp
>    push %rbx
>    mov  %rsp, %rbp
> 
> then %rbx would come off the stack after %rsp is restored from %rbp, i.e.
> would be guaranteed to be restored to the pre-EENTER value (unless the
> enclave or handler mucks with %rbp).
> 
> Anyways, we can discuss how to implement the frame pointer in the context
> of the patches, just wanted to point this out here for completeness.
> 
%rbx can always be restored as long as it is saved at a fixed offset 
from %rbp. For example, given the standard prolog below:

	push	%rbp
	mov	%rsp, %rbp
	push	%rbx

It can be paired with the following standard epilog:

	mov	-8(%rbp), %rbx
	leave
	ret

Alternatively, given "red zone" of 128 bytes, the following epilog will 
also work:

	leave
	mov	-0x10(%rsp), %rbx
	ret

In no cases do we have to worry about enclave mucking the stack as long 
as %rbp is preserved.

>>>> While this is more work, it is standard calling convention work that
>>>> doesn't require internal knowledge of __vdso..(). Alternatively, if we
>>>> don't like the extra work, we can document the %rbx hack explicitly
>>>> into the handler documentation and make it part of the interface. But
>>>> we need some explicit way for the handler to pop enclave output stack
>>>> params that doesn't depend on internal knowledge of the __vdso...()
>>>> invariants.
>>>
>>> IIUC, this is what you're suggesting?  Having to align the stack makes this
>>> a bit annoying, but it's not bad by any means.
>>>
>>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
>>> index 94a8e5f99961..05d54f79b557 100644
>>> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
>>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
>>> @@ -139,8 +139,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>>>          /* Pass the untrusted RSP (at exit) to the callback via %rcx. */
>>>          mov     %rsp, %rcx
>>>
>>> -       /* Save the untrusted RSP in %rbx (non-volatile register). */
>>> +       /* Save the untrusted RSP offset in %rbx (non-volatile register). */
>>>          mov     %rsp, %rbx
>>> +       and     $0xf, %rbx
>>>
>>>          /*
>>>           * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
>>> @@ -161,8 +162,8 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>>>          mov     0x20(%rbp), %rax
>>>          call    .Lretpoline
>>>
>>> -       /* Restore %rsp to its post-exit value. */
>>> -       mov     %rbx, %rsp
>>> +       /* Undo the post-exit %rsp adjustment. */
>>> +       lea     0x20(%rsp,%rbx), %rsp
>>>

Per discussion above, this is useful only if the enclave has problem 
cleaning up its own mess left on the untrusted stack, and the exit 
handler wants to EENTER the enclave again by returning to __vdso...(). 
It sounds very uncommon to me, and more like a bug than an expected 
behavior. Are there any existing code doing this or any particular 
application that needs this. If no, I'd say not to do it.
