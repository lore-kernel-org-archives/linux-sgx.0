Return-Path: <SRS0=/5Ao=CE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E91C433E1
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 19:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA665207DF
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 19:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgHZT1z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Aug 2020 15:27:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:53645 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgHZT1z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Aug 2020 15:27:55 -0400
IronPort-SDR: lwDmFuUl2+IYZTDMrrWAtactcbqSleyHojxYMChO6aU5AIl9p4asuamvxWa1oMtwz7hUPz5DAR
 EQUccNqdm83w==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="217923849"
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="217923849"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 12:27:55 -0700
IronPort-SDR: yColCKggoQAI7tc8htNGsz4pLkgzkniWBzrbF9PHeXQjn810FmN8amMel8u4RcaTJE4GMplu7F
 mNTTc25r0gSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="281884798"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.213.166.37]) ([10.213.166.37])
  by fmsmga008.fm.intel.com with ESMTP; 26 Aug 2020 12:27:54 -0700
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <2ddc5a5b-0929-b99f-41a0-06b3b53fcc8f@intel.com>
Date:   Wed, 26 Aug 2020 12:27:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200818042405.12871-3-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8/17/2020 9:24 PM, Sean Christopherson wrote:
> Rework __vdso_sgx_enter_enclave() to use a struct to hold the input and
> output params.  In the new struct, add an opaque "user_data" that can be
> used to pass context across the vDSO, and an explicit "exit_reason" to
> avoid overloading the return value.
> In order to pass additional parameters to the exit handler, the exinfo 
structure could be embedded in a user-defined structure while the 
handler could pick it up using "container_of" macro. IMO the original 
interface was neat and suffcient, and we are over-engineering it.

> Moving the params into a struct will also make it less painful to use
> dedicated exit reasons, and to support exiting on interrupts in future
> patches.
> 
My apology for not following discussion lately. What did you mean by 
"dedicated exit reasons" and why was it "painful"? According to another 
thread, I guess we wouldn't have "exiting on interrupts".
