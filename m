Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14407C606C6
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 17:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF60B216FD
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 17:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388727AbfGHRdq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 13:33:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:9533 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388360AbfGHRdq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 13:33:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 10:33:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="316776254"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga004.jf.intel.com with ESMTP; 08 Jul 2019 10:33:45 -0700
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
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
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <4ab66e76-63f3-83aa-8993-91624cd4bc3e@intel.com>
Date:   Mon, 8 Jul 2019 10:33:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708172930.GA20791@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/8/2019 10:29 AM, Sean Christopherson wrote:
> On Fri, Jul 05, 2019 at 07:05:49PM +0300, Jarkko Sakkinen wrote:
>> On Wed, Jun 19, 2019 at 03:23:49PM -0700, Sean Christopherson wrote:
>>
>> I still don't get why we need this whole mess and do not simply admit
>> that there are two distinct roles:
>>
>> 1. Creator
>> 2. User
> 
> Because SELinux has existing concepts of EXECMEM and EXECMOD.
> 
>> In the SELinux context Creator needs FILE__WRITE and FILE__EXECUTE but
>> User does not. It just gets the fd from the Creator. I'm sure that all
>> the SGX2 related functionality can be solved somehow in this role
>> playing game.
>>
>> An example would be the usual case where enclave is actually a loader
>> that loads the actual piece of software that one wants to run. Things
>> simply need to be designed in a way the Creator runs the loader part.
>> These are non-trivial problems but oddball security model is not going
>> to make them disappear - on the contrary it will make designing user
>> space only more complicated.
>>
>> I think this is classical example of when something overly complicated
>> is invented in the kernel only to realize that it should be solved in
>> the user space.

Are you talking about changing enclave loaders in user mode? That'd 
break all existing code. I don't think we shall ever consider this approach.

>>
>> It would not be like the only use case where some kind of privileged
>> daemon is used for managing some a kernel provided resource.
>>
>> I think a really good conclusion from this discussion that has taken two
>> months is to realize that nothing needs to be done in this area (except
>> *maybe* noexec check).
> 
> Hmm, IMO we need to support at least equivalents to EXECMEM and EXECMOD.
> 
> That being said, we can do so without functional changes to the SGX uapi,
> e.g. add reserved fields so that the initial uapi can be extended *if* we
> decide to go with the "userspace provides maximal protections" path, and
> use the EPCM permissions as the maximal protections for the initial
> upstreaming.
> 
> That'd give us a minimal implemenation for initial upstreaming and would
> eliminate Cedric's blocking complaint.  The "whole mess" of whitelisting,
> blacklisting and SGX2 support would be deferred until post-upstreaming.
> 
