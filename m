Return-Path: <SRS0=bOfw=5C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56682C0044D
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Mar 2020 00:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 314F72051A
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Mar 2020 00:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733037AbgCQASS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 20:18:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:62281 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732903AbgCQASS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Mar 2020 20:18:18 -0400
IronPort-SDR: YdcuCOhX2edA0ShvmtGnHwY0e2jHbEBPmksqTPFLI2BAGC5SMIe6p951j4+0qAzCY43cJW4T0T
 iohWrhrnMzpQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 17:18:17 -0700
IronPort-SDR: NI5b5CnKThT0AelkDM4a6c4KSP7e2scts3kMDY6YhnC/zZsNZIKkScpL8fbJTsOxwLg7GIgCrl
 xkrNTXi2uCxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,562,1574150400"; 
   d="scan'208";a="244314140"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.135.8.145]) ([10.135.8.145])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2020 17:18:14 -0700
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
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
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <ca2c9ac0-b717-ee96-c7df-4e39f03a9193@intel.com>
Date:   Mon, 16 Mar 2020 17:18:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200316235934.GM24267@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/16/2020 4:59 PM, Sean Christopherson wrote:
> On Mon, Mar 16, 2020 at 04:50:26PM -0700, Xing, Cedric wrote:
>> On 3/16/2020 3:53 PM, Sean Christopherson wrote:
>>> On Mon, Mar 16, 2020 at 11:38:24PM +0200, Jarkko Sakkinen wrote:
>>>>> My suggestions explicitly maintained robustness, and in fact increased
>>>>> it. If you think we've lost capability, please speak with specificity
>>>>> rather than in vague generalities. Under my suggestions we can:
>>>>> 1. call the vDSO from C
>>>>> 2. pass context to the handler
>>>>> 3. have additional stack manipulation options in the handler
>>>>>
>>>>> The cost for this is a net 2 additional instructions. No existing
>>>>> capability is lost.
>>>>
>>>> My vague generality in this case is just that the whole design
>>>> approach so far has been to minimize the amount of wrapping to
>>>> EENTER.
>>>
>>> Yes and no.   If we wanted to minimize the amount of wrapping around the
>>> vDSO's ENCLU then we wouldn't have the exit handler shenanigans in the
>>> first place.  The whole process has been about balancing the wants of each
>>> use case against the overall quality of the API and code.
>>>
>> The design of this vDSO API was NOT to minimize wrapping, but to allow
>> maximal flexibility. More specifically, we strove not to restrict how info
>> was exchanged between the enclave and its host process. After all, calling
>> convention is compiler specific - i.e. the enclave could be built by a
>> different compiler (e.g. MSVC) that doesn't share the same list of CSRs as
>> the host process. Therefore, the API has been implemented to pass through
>> virtually all registers except those used by EENTER itself. Similarly, all
>> registers are passed back from enclave to the caller (or the exit handler)
>> except those used by EEXIT. %rbp is an exception because the vDSO API has to
>> anchor the stack, using either %rsp or %rbp. We picked %rbp to allow the
>> enclave to allocate space on the stack.
> 
> And unless I'm missing something, using %rcx to pass @leaf would still
> satisfy the above, correct?  Ditto for saving/restoring %rbx.
> 
> I.e. a runtime that's designed to work with enclave's using a different
> calling convention wouldn't be able to take advantage of being able to call
> the vDSO from C, but neither would it take on any meaningful burden.
> 
Not exactly.

If called directly from C code, the caller would expect CSRs to be 
preserved. Then who should preserve CSRs? It can't be the enclave 
because it may not follow the same calling convention. Moreover, the 
enclave may run into an exception, in which case it doesn't have the 
ability to restore CSRs. So it has to be done by the vDSO API. That 
means CSRs will be overwritten upon enclave exits, which violates the 
goal of "passing all registers back to the caller except those used by 
EEXIT".
