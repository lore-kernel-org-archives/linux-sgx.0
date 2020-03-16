Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BDBC0044D
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 23:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B16C720663
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 23:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732903AbgCPXua (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 19:50:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:48604 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732880AbgCPXua (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Mar 2020 19:50:30 -0400
IronPort-SDR: a0VW147DNNTPEJ9pBmK1H3FA88R5wWrGFORlDgFtDafmfZsnhCu1PO/vX7qzUHbinDpGFVWTZp
 8cufbfXuivTA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 16:50:29 -0700
IronPort-SDR: q1sPZdqkQk97Glbiq8/TcTPYanScaycXSHVMTujifIDlFbwviaBLGG5ggXttyLHvGZ4ABUsBst
 DJyQzTV4eXiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,562,1574150400"; 
   d="scan'208";a="244307367"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.135.8.145]) ([10.135.8.145])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2020 16:50:26 -0700
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
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
        Jethro Beekman <jethro@fortanix.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <20200315012523.GC208715@linux.intel.com>
 <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
 <94ce05323c4de721c4a6347223885f2ad9f541af.camel@linux.intel.com>
 <CAOASepM1pp1emPwSdFcaRkZfFm6sNmwPCJH+iFMiaJpFjU0VxQ@mail.gmail.com>
 <5dc2ec4bc9433f9beae824759f411c32b45d4b74.camel@linux.intel.com>
 <20200316225322.GJ24267@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <fa773504-4cc1-5cbd-c018-890f7a5d3152@intel.com>
Date:   Mon, 16 Mar 2020 16:50:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200316225322.GJ24267@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/16/2020 3:53 PM, Sean Christopherson wrote:
> On Mon, Mar 16, 2020 at 11:38:24PM +0200, Jarkko Sakkinen wrote:
>> On Mon, 2020-03-16 at 10:01 -0400, Nathaniel McCallum wrote:
>>> On Mon, Mar 16, 2020 at 9:56 AM Jarkko Sakkinen
>>> <jarkko.sakkinen@linux.intel.com> wrote:
>>>> On Sun, 2020-03-15 at 13:53 -0400, Nathaniel McCallum wrote:
>>>>> On Sat, Mar 14, 2020 at 9:25 PM Jarkko Sakkinen
>>>>> <jarkko.sakkinen@linux.intel.com> wrote:
>>>>>> On Wed, Mar 11, 2020 at 01:30:07PM -0400, Nathaniel McCallum wrote:
>>>>>>> Currently, the selftest has a wrapper around
>>>>>>> __vdso_sgx_enter_enclave() which preserves all x86-64 ABI callee-saved
>>>>>>> registers (CSRs), though it uses none of them. Then it calls this
>>>>>>> function which uses %rbx but preserves none of the CSRs. Then it jumps
>>>>>>> into an enclave which zeroes all these registers before returning.
>>>>>>> Thus:
>>>>>>>
>>>>>>>    1. wrapper saves all CSRs
>>>>>>>    2. wrapper repositions stack arguments
>>>>>>>    3. __vdso_sgx_enter_enclave() modifies, but does not save %rbx
>>>>>>>    4. selftest zeros all CSRs
>>>>>>>    5. wrapper loads all CSRs
>>>>>>>
>>>>>>> I'd like to propose instead that the enclave be responsible for saving
>>>>>>> and restoring CSRs. So instead of the above we have:
>>>>>>>    1. __vdso_sgx_enter_enclave() saves %rbx
>>>>>>>    2. enclave saves CSRs
>>>>>>>    3. enclave loads CSRs
>>>>>>>    4. __vdso_sgx_enter_enclave() loads %rbx
>>>>>>>
>>>>>>> I know that lots of other stuff happens during enclave transitions,
>>>>>>> but at the very least we could reduce the number of instructions
>>>>>>> through this critical path.
>>>>>>
>>>>>> What Jethro said and also that it is a good general principle to cut
>>>>>> down the semantics of any vdso as minimal as possible.
>>>>>>
>>>>>> I.e. even if saving RBX would make somehow sense it *can* be left
>>>>>> out without loss in terms of what can be done with the vDSO.
>>>>>
>>>>> Please read the rest of the thread. Sean and I have hammered out some
>>>>> sensible and effective changes.
>>>>
>>>> Have skimmed through that discussion but it comes down how much you get
>>>> by obviously degrading some of the robustness. Complexity of the calling
>>>> pattern is not something that should be emphasized as that is something
>>>> that is anyway hidden inside the runtime.
>>>
>>> My suggestions explicitly maintained robustness, and in fact increased
>>> it. If you think we've lost capability, please speak with specificity
>>> rather than in vague generalities. Under my suggestions we can:
>>> 1. call the vDSO from C
>>> 2. pass context to the handler
>>> 3. have additional stack manipulation options in the handler
>>>
>>> The cost for this is a net 2 additional instructions. No existing
>>> capability is lost.
>>
>> My vague generality in this case is just that the whole design
>> approach so far has been to minimize the amount of wrapping to
>> EENTER.
> 
> Yes and no.   If we wanted to minimize the amount of wrapping around the
> vDSO's ENCLU then we wouldn't have the exit handler shenanigans in the
> first place.  The whole process has been about balancing the wants of each
> use case against the overall quality of the API and code.
> 
The design of this vDSO API was NOT to minimize wrapping, but to allow 
maximal flexibility. More specifically, we strove not to restrict how 
info was exchanged between the enclave and its host process. After all, 
calling convention is compiler specific - i.e. the enclave could be 
built by a different compiler (e.g. MSVC) that doesn't share the same 
list of CSRs as the host process. Therefore, the API has been 
implemented to pass through virtually all registers except those used by 
EENTER itself. Similarly, all registers are passed back from enclave to 
the caller (or the exit handler) except those used by EEXIT. %rbp is an 
exception because the vDSO API has to anchor the stack, using either 
%rsp or %rbp. We picked %rbp to allow the enclave to allocate space on 
the stack.
