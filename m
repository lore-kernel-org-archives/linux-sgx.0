Return-Path: <SRS0=ZaoB=VG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCAF4C73C53
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 21:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E6C3208C4
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 21:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfGIVQz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Jul 2019 17:16:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:30709 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfGIVQz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Jul 2019 17:16:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 14:16:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,472,1557212400"; 
   d="scan'208";a="168107261"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga003.jf.intel.com with ESMTP; 09 Jul 2019 14:16:53 -0700
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     "Dr. Greg" <greg@enjellic.com>,
        Stephen Smalley <stephen.smalley@gmail.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>
References: <960B34DE67B9E140824F1DCDEC400C0F6551D585@ORSMSX116.amr.corp.intel.com>
 <f59529e4-6cc8-2405-d7db-2519727f9a80@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D7F7@ORSMSX116.amr.corp.intel.com>
 <63c92ab6-dc8d-826b-b8bf-05ad262f06e4@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551DBF7@ORSMSX116.amr.corp.intel.com>
 <9e45df1b-3aac-e851-4ef2-5b262f5139bd@schaufler-ca.com>
 <20190703094651.GA29601@wind.enjellic.com>
 <012fc47d-4e9d-3398-0d9d-d9298a758c8d@schaufler-ca.com>
 <20190707133023.GA4521@wind.enjellic.com>
 <256013f7-292d-7014-9abb-61755f07eb25@schaufler-ca.com>
 <20190709015252.GC24799@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <d3d023e6-7236-e804-88c8-0c3b92025c77@intel.com>
Date:   Tue, 9 Jul 2019 14:16:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190709015252.GC24799@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/8/2019 6:52 PM, Sean Christopherson wrote:
> On Mon, Jul 08, 2019 at 05:02:00PM -0700, Casey Schaufler wrote:
>> On 7/7/2019 6:30 AM, Dr. Greg wrote:
>>> On Wed, Jul 03, 2019 at 08:32:10AM -0700, Casey Schaufler wrote:
>>>
>>> Good morning, I hope the weekend has been enjoyable for everyone.
>>>
>>>>>> On 7/2/2019 12:42 AM, Xing, Cedric wrote:
>>>>>>> ...
>>>>>>> Guess this discussion will never end if we don't get into
>>>>>>> code. Guess it'd be more productive to talk over phone then come back
>>>>>>> to this thread with a conclusion. Will that be ok with you?
>>>>>> I don't think that a phone call is going to help. Talking code
>>>>>> issues tends to muddle them in my brain. If you can give me a few
>>>>>> days I will propose a rough version of how I think your code should
>>>>>> be integrated into the LSM environment. I'm spending more time
>>>>>> trying (unsuccessfully :( ) to discribe the issues in English than
>>>>>> it will probably take in C.
>>>>> While Casey is off writing his rosetta stone,
>>>> I'd hardly call it that. More of an effort to round the corners on
>>>> the square peg. And Cedric has some ideas on how to approach that.
>>> Should we infer from this comment that, of the two competing
>>> strategies, Cedric's is the favored architecture?
>>
>> With Cedric's latest patches I'd say there's only one
>> strategy. There's still some refinement to do, but we're
>> getting there.
> 
> Dynamic tracking has an unsolvable race condition.  If process A maps a
> page W and process B maps the same page X, then the result of W^X checks
> depends on the order of mprotect() calls between A and B.

I don't quite understand where the term "dynamic tracking" came from. 
What's done in the patch is just to track which page was contributed by 
which file. It's been done for all file mappings in Linux.

Back to the "race condition". A similar situation already exists in 
SELinux, between EXECMOD and EXECMEM. Say a file does *not* have EXECMOD 
but the calling process has EXECMEM. Then WX could be granted to a fresh 
private mapping (because of EXECMEM). However, once the mapping has been 
written to, X should have been revoked (because of lack of EXECMOD) but 
will still be retained until dropped by an explicit mprotect(). 
Afterwards, mprotect(X) will be denied. That's not the same situation as 
in this enclave case but they do share one thing in common - X should 
have been revoked from an existing mapping but it isn't, which is just a 
policy choice.

Nothing is unsolvable. Here are 2 options.
(1) We argue that it doesn't matter, similar to the EXECMOD/EXECMEM case 
on regular file mappings described above; or
(2) EXECMOD is required for both W->X and X->W transitions, hence W 
requested by the 2nd process will be denied because X has been granted 
to the 1st process while EXECMOD is absent.

Please note that #2 is effectively the same concept as 
PROCESS2__ENCLAVE_EXECDIRTY in Sean's patch, except that EXECMOD is per 
file while ENCLAVE_EXECDIRTY is per process.
