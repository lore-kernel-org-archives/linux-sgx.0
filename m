Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66855C742A2
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 19:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359E820863
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 19:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfGKTtH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 15:49:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:39776 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfGKTtG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 15:49:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 12:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="168730721"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga003.jf.intel.com with ESMTP; 11 Jul 2019 12:49:06 -0700
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
 <686e47d2-f45c-6828-39d1-48374925de6c@intel.com>
 <20190710224628.epjxwlpqqxdurmzo@linux.intel.com>
 <a2d2ba5c-c7b3-a76b-594f-df2e14234b1d@intel.com>
 <20190711093621.4wstj7bc7w6wxxj2@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <f24c8440-2397-0015-745b-c338d9496a53@intel.com>
Date:   Thu, 11 Jul 2019 12:49:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190711093621.4wstj7bc7w6wxxj2@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/11/2019 2:36 AM, Jarkko Sakkinen wrote:
> On Wed, Jul 10, 2019 at 03:54:20PM -0700, Xing, Cedric wrote:
>> On 7/10/2019 3:46 PM, Jarkko Sakkinen wrote:
>>> On Wed, Jul 10, 2019 at 11:08:37AM -0700, Xing, Cedric wrote:
>>>>> With these conclusions I think the current vDSO API is sufficient for
>>>>> Linux.
>>>>
>>>> The new vDSO API is to support data exchange on stack. It has nothing to do
>>>> with debugging. BTW, the community has closed on this.
>>>
>>> And how that is useful?
>>
>> There is a lengthy discussion on its usefulness so I don't want to repeat.
>> In short, it allows using untrusted stack as a convenient method to exchange
>> data with the enclave. It is currently being used by Intel's SGX SDK for
>> e/o-calls parameters.
>>
>>>> The CFI directives are for stack unwinding. They don't affect what the code
>>>> does so you can just treat them as NOPs if you don't understand what they
>>>> do. However, they are useful to not only debuggers but also exception
>>>> handling code. libunwind also has a setjmp()/longjmp() implementation based
>>>> on CFI directives.
>>>
>>> Of course I won't merge code of which usefulness I don't understand.
>>
>> Sure.
>>
>> Any other questions I can help with?
> 
> I dissected my concerns in other email. We can merge this feature after
> v21 if it makes sense.

Sent out v3 of vDSO changes last night. I hope your concerns have been 
properly addressed.

The new vDSO API is a community consensus. I can help on whatever 
technical problems you may have but I don't see a reason you should 
reject it.

> /Jarkko
> 
