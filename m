Return-Path: <SRS0=/5Ao=CE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735C9C433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 23:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43AD120791
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 23:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgHZX0P (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Aug 2020 19:26:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:49135 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgHZX0O (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Aug 2020 19:26:14 -0400
IronPort-SDR: vEWhV/yPmgf+kk+/jePXTHRgkpcQbkBhlYpJnktufiwWh8DQPWn/BnZF62q8y2C75btE76FGcg
 vlV1jaWtiahg==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="153818012"
X-IronPort-AV: E=Sophos;i="5.76,357,1592895600"; 
   d="scan'208";a="153818012"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 16:26:12 -0700
IronPort-SDR: LSnH9D6tdJmWtUIPlQEOzaWnBLPEfAnnVUzmiQwDcoo4Moxde5UMugNE3L/cQot//EdgS4WmK5
 JU6ULHg3yRQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,357,1592895600"; 
   d="scan'208";a="281941080"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.213.166.37]) ([10.213.166.37])
  by fmsmga008.fm.intel.com with ESMTP; 26 Aug 2020 16:26:12 -0700
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
 <2ddc5a5b-0929-b99f-41a0-06b3b53fcc8f@intel.com>
 <20200826201511.GB21459@sjchrist-ice>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <a4ccd8e1-0c0f-8664-b0c2-d7a30bd5c31a@intel.com>
Date:   Wed, 26 Aug 2020 16:26:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200826201511.GB21459@sjchrist-ice>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8/26/2020 1:15 PM, Sean Christopherson wrote:
> On Wed, Aug 26, 2020 at 12:27:54PM -0700, Xing, Cedric wrote:
>> On 8/17/2020 9:24 PM, Sean Christopherson wrote:
>>> Rework __vdso_sgx_enter_enclave() to use a struct to hold the input and
>>> output params.  In the new struct, add an opaque "user_data" that can be
>>> used to pass context across the vDSO, and an explicit "exit_reason" to
>>> avoid overloading the return value.
>>> In order to pass additional parameters to the exit handler, the exinfo
>> structure could be embedded in a user-defined structure while the handler
>> could pick it up using "container_of" macro. IMO the original interface was
>> neat and suffcient, and we are over-engineering it.
> 
> container_of/offsetof shenanigans were my original suggestion as well.
> Nathaniel's argument is that using such tricks is less than pleasent in a
> Rust environment.
> 
> https://lkml.kernel.org/r/CAOASepOFh-vOrNZEVDFrDSuHs+9GEzzpXUTG-fZMuyjWAkpRWw@mail.gmail.com
> 
I don't know much about rust but there seem to be offsetof/container_of 
solutions in rust. Here's one: 
https://gist.github.com/resilar/baefbfbf0d733c69d70970d829938875.

After countless discussions along this upstream journey, I thought we 
had agreed that simplicity was the priority. And for simplicity we were 
even willing to give up compliance to x86_64 ABI. Then how do you 
justify treating rust better than other programming languages? This 
looks a hard sell to me.

>>> Moving the params into a struct will also make it less painful to use
>>> dedicated exit reasons, and to support exiting on interrupts in future
>>> patches.
>>>
>> My apology for not following discussion lately. What did you mean by
>> "dedicated exit reasons" and why was it "painful"? According to another
>> thread, I guess we wouldn't have "exiting on interrupts".
> 
> Currently the vDSO returns -EFAULT if the enclave encounters an exception,
> which is kludgy for two reasons:
> 
>   1. EFAULT traditionally means "bad address", whereas an exception could be
>      a #UD in the enclave.
> 
>   2. Returning -EFAULT provides weird semantics as it implies the vDSO call
>      failed, which is not the case.  The vDSO itself was successful, i.e. it
>      did the requested EENTER/ERESUME operation, and should really return '0'.
> 
EFAULT is descriptive enough for me. And more importantly 
detailed/specific info is always available in exinfo.

IMO, the purpose of return code is for the caller/handler to branch on. 
If 2 cases share the same execution path, then there's no need to 
distinguish them. In the case of SGX, most (if not all) exceptions are 
handled in the same way - nested EENTER, then what's point of 
distinguishing them? Please note that detailed info is always available 
in exinfo to cover corner cases.

Moreover, even the vDSO API itself cannot tell between faults at 
EENTER/ERESUME (the vDSO itself failes) vs. faults inside the enclave 
(vDSO succeeded but the enclave fails). I don't think you can be 
accurate without complicating the code significantly.

> The proposed solution for #1 is to define arbitrary return values to
> differentiate between synchronous (EEXIT) exits and asynchronous exits due
> to exceptions.  But that doesn't address #2, and gets especially awkward when
> dealing with the call back return, which is also overloaded to use positive
> return values for ENCLU leafs.
> 
> Passing a "run" struct makes it trivially easy to different the return value
> of the vDSO function from the enclave exit reason, and to avoid collisions
> with the return value from the userspace callback.
> 
When a callback is configured, the vDSO NEVER returns to caller directly 
- i.e. all return codes must be from the callback but NOT the vDSO. I 
don't see any collisions here.
