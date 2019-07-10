Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBE0C74A36
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 17:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BB49208E4
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 17:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfGJRyz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Jul 2019 13:54:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:12276 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbfGJRyz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Jul 2019 13:54:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 10:54:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="365009302"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.255.93.70]) ([10.255.93.70])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jul 2019 10:54:54 -0700
Subject: Re: [RFC PATCH v3 4/4] x86/sgx: Implement SGX specific hooks in
 SELinux
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
References: <cover.1561588012.git.cedric.xing@intel.com>
 <cover.1562542383.git.cedric.xing@intel.com>
 <3a9efc8d3c27490dbcfe802ce3facddd62f47872.1562542383.git.cedric.xing@intel.com>
 <20190710154915.GA4331@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <e34f4799-2a50-1cd5-d6aa-1deba8f768dd@intel.com>
Date:   Wed, 10 Jul 2019 10:54:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710154915.GA4331@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/10/2019 8:49 AM, Sean Christopherson wrote:
> On Sun, Jul 07, 2019 at 04:41:34PM -0700, Cedric Xing wrote:
>> selinux_enclave_init() determines if an enclave is allowed to launch, using the
>> criteria described earlier. This implementation does NOT accept SIGSTRUCT in
>> anonymous memory. The backing file is also cached in struct
>> file_security_struct and will serve as the base for decisions for anonymous
>> pages.
> 
> Did we ever reach a consensus on whether sigstruct must reside in a file?

No. We reached the opposite agreement of *not* requiring sigstruct to 
reside in a file at the interface level - i.e., security_enclave_init() 
takes a VMA but *not* a file struct as input.

At the implementation level, an LSM may require sigstruct to reside in a 
file. But that's a per-LSM decision.

>> +	/* Store SIGSTRUCT file for future use */
>> +	if (atomic_long_cmpxchg(&fsec->encl_ss, 0, (long)src->vm_file))
>> +		return -EEXIST;
>> +
>> +	get_file(src->vm_file);
> 
> My understanding is that Andy is strongly against pinning a file for the
> duration of the enclave, has that changed?

I think everyone including Andy prefers not to pin any files. But it's a 
trade-off among code simplicity, auditing accuracy and memory 
consumption. I think the latest suggestion from Stephen was to keep 
files open, for SELinux. Again, that's a per-LSM decision.
