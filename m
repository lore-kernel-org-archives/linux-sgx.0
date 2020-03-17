Return-Path: <SRS0=bOfw=5C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF46C1975A
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Mar 2020 22:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B54B206EC
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Mar 2020 22:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgCQWXe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Mar 2020 18:23:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:35870 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgCQWXe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Mar 2020 18:23:34 -0400
IronPort-SDR: hYlK0UY0fUzbNOdCN7Am68g3pbMhIsgMV5u8dv9ycu3XH6aqsBsSRA6M/ksiJCJzFIFHAfqBNe
 yYqd0vd5mZ6Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 15:23:33 -0700
IronPort-SDR: 43PSZtYE1nZk6hpve9vVDs0R1jAEkP4vD0F2F2ds1DE1l8P07WGBrdIO43zsY9dDliaRF9ivHE
 imWhp15r1E0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,565,1574150400"; 
   d="scan'208";a="445645858"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.135.41.245]) ([10.135.41.245])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2020 15:23:32 -0700
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
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
 <fa773504-4cc1-5cbd-c018-890f7a5d3152@intel.com>
 <20200316235934.GM24267@linux.intel.com>
 <ca2c9ac0-b717-ee96-c7df-4e39f03a9193@intel.com>
 <CAOASepN7n1XUGPQHwk2Vcu-dyyBJ7dwhM_mF_RcJa71PcNiLmA@mail.gmail.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <a447fb5c-b3bd-ef82-ee5f-33be69796a27@intel.com>
Date:   Tue, 17 Mar 2020 15:23:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAOASepN7n1XUGPQHwk2Vcu-dyyBJ7dwhM_mF_RcJa71PcNiLmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/17/2020 9:50 AM, Nathaniel McCallum wrote:
> On Mon, Mar 16, 2020 at 8:18 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>>
>> On 3/16/2020 4:59 PM, Sean Christopherson wrote:
>>> On Mon, Mar 16, 2020 at 04:50:26PM -0700, Xing, Cedric wrote:
>>>> On 3/16/2020 3:53 PM, Sean Christopherson wrote:
>>>>> On Mon, Mar 16, 2020 at 11:38:24PM +0200, Jarkko Sakkinen wrote:
>>>>>>> My suggestions explicitly maintained robustness, and in fact increased
>>>>>>> it. If you think we've lost capability, please speak with specificity
>>>>>>> rather than in vague generalities. Under my suggestions we can:
>>>>>>> 1. call the vDSO from C
>>>>>>> 2. pass context to the handler
>>>>>>> 3. have additional stack manipulation options in the handler
>>>>>>>
>>>>>>> The cost for this is a net 2 additional instructions. No existing
>>>>>>> capability is lost.
>>>>>>
>>>>>> My vague generality in this case is just that the whole design
>>>>>> approach so far has been to minimize the amount of wrapping to
>>>>>> EENTER.
>>>>>
>>>>> Yes and no.   If we wanted to minimize the amount of wrapping around the
>>>>> vDSO's ENCLU then we wouldn't have the exit handler shenanigans in the
>>>>> first place.  The whole process has been about balancing the wants of each
>>>>> use case against the overall quality of the API and code.
>>>>>
>>>> The design of this vDSO API was NOT to minimize wrapping, but to allow
>>>> maximal flexibility. More specifically, we strove not to restrict how info
>>>> was exchanged between the enclave and its host process. After all, calling
>>>> convention is compiler specific - i.e. the enclave could be built by a
>>>> different compiler (e.g. MSVC) that doesn't share the same list of CSRs as
>>>> the host process. Therefore, the API has been implemented to pass through
>>>> virtually all registers except those used by EENTER itself. Similarly, all
>>>> registers are passed back from enclave to the caller (or the exit handler)
>>>> except those used by EEXIT. %rbp is an exception because the vDSO API has to
>>>> anchor the stack, using either %rsp or %rbp. We picked %rbp to allow the
>>>> enclave to allocate space on the stack.
>>>
>>> And unless I'm missing something, using %rcx to pass @leaf would still
>>> satisfy the above, correct?  Ditto for saving/restoring %rbx.
>>>
>>> I.e. a runtime that's designed to work with enclave's using a different
>>> calling convention wouldn't be able to take advantage of being able to call
>>> the vDSO from C, but neither would it take on any meaningful burden.
>>>
>> Not exactly.
>>
>> If called directly from C code, the caller would expect CSRs to be
>> preserved.
> 
> Correct. This requires collaboration between the caller of the vDSO
> and the enclave.
> 
>> Then who should preserve CSRs?
> 
> The enclave.
> 
>> It can't be the enclave
>> because it may not follow the same calling convention.
> 
> This is incorrect. You are presuming there is not tight integration
> between the caller of the vDSO and the enclave. In my case, the
> integration is total and complete. We have working code today that
> does this.
> 
>> Moreover, the
>> enclave may run into an exception, in which case it doesn't have the
>> ability to restore CSRs.
> 
> There are two solutions to this:
> 1. Write the handler in assembly and don't return to C on AEX.
> 2. The caller can simply preserve the registers. Nothing stops that.
> 
> We have implemented #1.
> 
What if the enclave cannot proceed due to an unhandled exception so the 
execution has to get back to the C caller of the vDSO API?

It seems to me the caller has to preserve CSRs by itself, otherwise it 
cannot continue execution after any enclave exception. Passing @leaf in 
%ecx will allow saving/restoring CSRs in C by setjmp()/longjmp(), with 
the help of an exit handler. But if the C caller has already preserved 
CSRs, why preserve CSRs again inside the enclave? It looks to me things 
can be simplified only if the host process handles no enclave exceptions 
(or exceptions inside the enclave will crash the calling thread). Thus 
the only case of enclave EEXIT'ing back to its caller is considered 
valid, hence the enclave will always be able to restore CSRs, so that 
neither vDSO nor its caller has to preserve CSRs.

Is my understanding correct?
