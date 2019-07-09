Return-Path: <SRS0=ZaoB=VG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C48C73C63
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 23:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 078FD20844
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 23:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfGIXLH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Jul 2019 19:11:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:65435 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfGIXLH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Jul 2019 19:11:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 16:11:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,472,1557212400"; 
   d="scan'208";a="168132289"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga003.jf.intel.com with ESMTP; 09 Jul 2019 16:11:06 -0700
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
 <20190708172930.GA20791@linux.intel.com>
 <20190709162203.gzyvulah5u7eksip@linux.intel.com>
 <20190709170917.GD25369@linux.intel.com>
 <512391ba-fe0d-e758-ae32-09660c1264f7@intel.com>
 <20190709222534.GG25369@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <35b9dd93-4988-d998-056c-aeae36076bc0@intel.com>
Date:   Tue, 9 Jul 2019 16:11:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190709222534.GG25369@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/9/2019 3:25 PM, Sean Christopherson wrote:
> On Tue, Jul 09, 2019 at 01:41:28PM -0700, Xing, Cedric wrote:
>> On 7/9/2019 10:09 AM, Sean Christopherson wrote:
>>> Translating those to SGX, with a lot of input from Stephen, I ended up
>>> with the following:
>>>
>>>    - FILE__ENCLAVE_EXECUTE: equivalent to FILE__EXECUTE, required to gain X
>>>                             on an enclave page loaded from a regular file
>>>
>>>    - PROCESS2__ENCLAVE_EXECDIRTY: hybrid of EXECMOD and EXECUTE+WRITE,
>>>                                   required to gain W->X on an enclave page
>>
>> EXECMOD basically indicates a file containing self-modifying code. Your
>> ENCLAVE_EXECDIRTY is however a process permission, which is illogical.
> 
> How is it illogical?  If a PROCESS wants to EXECute a DIRTY ENCLAVE page,
> then it needs PROCESS2__ENCLAVE_EXECDIRTY
Just think of the purpose of FILE__EXECMOD. It indicates to LSM the file 
has self-modifying code, hence W->X transition should be considered 
"normal" and allowed, regardless which process that file is loaded into.

The same thing for enclaves here. Whether an enclave contains 
self-modifying code is specific to that enclave, regardless which 
process it is loaded into.

But what are you doing is quite the opposite, and that's I mean by 
"illogical".
