Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 156AFC742D7
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 07:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E485B2054F
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 07:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfGMHAe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 03:00:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:2585 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfGMHAe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 03:00:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 00:00:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,485,1557212400"; 
   d="scan'208";a="186748712"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.254.24.170]) ([10.254.24.170])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jul 2019 00:00:33 -0700
Subject: Re: [RFC PATCH v3 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave() to
 allow parameter passing on untrusted stack
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, luto@kernel.org, jethro@fortanix.com,
        greg@enjellic.com
References: <20190424062623.4345-1-cedric.xing@intel.com>
 <cover.1562813643.git.cedric.xing@intel.com>
 <742dfe18ee4128ccccf8313b6c6cb3ee8b961712.1562813643.git.cedric.xing@intel.com>
 <20190711095317.v6tlrx2vt4tkibb3@linux.intel.com>
 <20190711154231.GA15067@linux.intel.com>
 <20190711175550.s5u46chozj5acjjr@linux.intel.com>
 <20190711175813.GM15067@linux.intel.com>
 <20190712031605.qzlcgtbvfy6lqygt@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <91b0f691-e247-f531-b8dd-f22835723a4e@intel.com>
Date:   Sat, 13 Jul 2019 00:00:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712031605.qzlcgtbvfy6lqygt@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/11/2019 8:16 PM, Jarkko Sakkinen wrote:
> On Thu, Jul 11, 2019 at 10:58:13AM -0700, Sean Christopherson wrote:
>>> The way to do this right would be to write a documentation block before
>>> kdoc's for the functions. It is described in the last section of
>>>
>>> https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt0
>>>
>>> I.e. organize the file as
>>>
>>> 1. Documentation block describing the theory of operation.
>>> 2. Functions and their associated documentations.
>>
>> The kernel doc parser straight up doesn't work on asm functions, hence the
>> shenanigans to coerce it into thinking it's parsing a normal C function.
> 
> Aah. I think I was too hazy with my comment. Looked it from patchwork and
> the documentation is mostly just fine.
> 
> For this patch this cruft nees to be removed:
> 
> - *                           %SGX_IOC_ENCLAVE_INIT ioctl
> + *			     %SGX_IOC_ENCLAVE_INIT ioctl
> 
> These make squashing the patch properly nasty.
> 
> Also there is one unwanted rename. Did not find anything else obviously
> wrong.

Reformatted the comments. Tested with kernel-doc. Now v4 could be 
converted and displayed nicely as man pages.

> /Jarkko
> 
