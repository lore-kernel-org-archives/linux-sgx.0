Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085B8C73C63
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 02:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D02132064B
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 02:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfGJCEf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Jul 2019 22:04:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:62718 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfGJCEf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Jul 2019 22:04:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 19:04:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,472,1557212400"; 
   d="scan'208";a="168165043"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga003.jf.intel.com with ESMTP; 09 Jul 2019 19:04:33 -0700
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
To:     "Dr. Greg" <greg@idfusion.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
 <20190708172930.GA20791@linux.intel.com>
 <20190710012811.GA18755@wind.enjellic.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <120cfcee-af82-83cd-fb73-a39ecddff2af@intel.com>
Date:   Tue, 9 Jul 2019 19:04:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710012811.GA18755@wind.enjellic.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/9/2019 6:28 PM, Dr. Greg wrote:
> On Mon, Jul 08, 2019 at 10:29:30AM -0700, Sean Christopherson wrote:
> 
> Good evening to everyone.
> 
>> That being said, we can do so without functional changes to the SGX
>> uapi, e.g. add reserved fields so that the initial uapi can be
>> extended *if* we decide to go with the "userspace provides maximal
>> protections" path, and use the EPCM permissions as the maximal
>> protections for the initial upstreaming.
>>
>> That'd give us a minimal implemenation for initial upstreaming and
>> would eliminate Cedric's blocking complaint.  The "whole mess" of
>> whitelisting, blacklisting and SGX2 support would be deferred until
>> post-upstreaming.
> 
> Are we convinced the 'mess' will be any easier to clean up after the
> driver is upstreamed?
> 
> The primary problem is that we haven't addressed the issue of what
> this technology is designed to do and its implications with respect to
> the kernel.  As a result we are attempting to implement controls which
> we are comfortable with and understand rather then those that are
> relevant.

I don't think it's about easier or harder to clean up the mess, but a 
divide-and-conquer strategy. After all, SGX and LSM are kind of 
orthogonal as long as SGX doesn't compromise the protection provided by LSM.

Let's step back and look at what started this lengthy discussion. The 
primary problem of v20 was that the SGX module allows executable enclave 
pages to be created from non-executable regular pages, which could be 
exploited by adversaries to grant executable permissions to pages that 
would otherwise be denied without SGX. And that could be fixed simply by 
capping EPCM permissions to whatever allowed on the source page, without 
touching LSM. Of course the drawback is loss of functionality - i.e. 
self-modifying enclaves cannot be loaded unless the calling process has 
EXECMEM. But that should suffice, as most SGX1 applications don't 
contain self-modifying code anyway.

Then we could switch our focus back to LSM and work out what's relevant, 
especially for SGX2 and beyond.

> Have a good evening.
> 
> Dr. Greg
> 
> As always,
> Dr. Greg Wettstein, Ph.D, Worker
> IDfusion, LLC               Implementing SGX secured and modeled
> 4206 N. 19th Ave.           intelligent network endpoints.
> Fargo, ND  58102
> PH: 701-281-1686            EMAIL: greg@idfusion.net
> ------------------------------------------------------------------------------
> "Courage is not the absence of fear, but rather the judgement that
>   something else is more important than fear."
>                                  -- Ambrose Redmoon
> 
