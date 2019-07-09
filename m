Return-Path: <SRS0=ZaoB=VG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7943C73C53
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 20:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 881F02073D
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 20:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbfGIUl3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Jul 2019 16:41:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:10570 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728955AbfGIUl3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Jul 2019 16:41:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 13:41:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,471,1557212400"; 
   d="scan'208";a="168099604"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga003.jf.intel.com with ESMTP; 09 Jul 2019 13:41:27 -0700
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
 <20190709162203.gzyvulah5u7eksip@linux.intel.com>
 <20190709170917.GD25369@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <512391ba-fe0d-e758-ae32-09660c1264f7@intel.com>
Date:   Tue, 9 Jul 2019 13:41:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190709170917.GD25369@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/9/2019 10:09 AM, Sean Christopherson wrote:
> On Tue, Jul 09, 2019 at 07:22:03PM +0300, Jarkko Sakkinen wrote:
>> On Mon, Jul 08, 2019 at 10:29:30AM -0700, Sean Christopherson wrote:
>>> On Fri, Jul 05, 2019 at 07:05:49PM +0300, Jarkko Sakkinen wrote:
>>>> On Wed, Jun 19, 2019 at 03:23:49PM -0700, Sean Christopherson wrote:
>>>>
>>>> I still don't get why we need this whole mess and do not simply admit
>>>> that there are two distinct roles:
>>>>
>>>> 1. Creator
>>>> 2. User
>>>
>>> Because SELinux has existing concepts of EXECMEM and EXECMOD.
>>
>> What is the official documentation for those? I've only found some
>> explanations from discussions and some RHEL sysadmin guides.
> 
> No clue.  My knowledge was gleaned from the code and from Stephen's
> feedback.
> 
> 
> The high level breakdown:
> 
>    - FILE__EXECUTE: required to gain X on a mapping to a regular file
> 
> 
>    - FILE__EXECUTE + FILE__WRITE: required to gain WX or W->X on a shared
>                                   mapping to a regular file
> 
>    - FILE__EXECMOD: required to gain W->X on a private mapping of a regular
>                     file
> 
>    - PROCESS__EXECMEM: required to gain WX on a private mapping to a regular
>                        file, OR to gain X on an anonymous mapping.
> 
> 
> Translating those to SGX, with a lot of input from Stephen, I ended up
> with the following:
> 
>    - FILE__ENCLAVE_EXECUTE: equivalent to FILE__EXECUTE, required to gain X
>                             on an enclave page loaded from a regular file
> 
>    - PROCESS2__ENCLAVE_EXECDIRTY: hybrid of EXECMOD and EXECUTE+WRITE,
>                                   required to gain W->X on an enclave page

EXECMOD basically indicates a file containing self-modifying code. Your 
ENCLAVE_EXECDIRTY is however a process permission, which is illogical.

>    - PROCESS2__ENCLAVE_EXECANON: subset of EXECMEM, required to gain X on
>                                  an enclave page that is loaded from an
>                                  anonymous mapping
>                         
>    - PROCESS2__ENCLAVE_MAPWX: subset of EXECMEM, required to gain WX on an
>                               enclave page
> 
> 
> 
>>> That being said, we can do so without functional changes to the SGX uapi,
>>> e.g. add reserved fields so that the initial uapi can be extended *if* we
>>> decide to go with the "userspace provides maximal protections" path, and
>>> use the EPCM permissions as the maximal protections for the initial
>>> upstreaming.
>>>
>>> That'd give us a minimal implemenation for initial upstreaming and would
>>> eliminate Cedric's blocking complaint.  The "whole mess" of whitelisting,
>>> blacklisting and SGX2 support would be deferred until post-upstreaming.
>>
>> I'd like that approach more too.
>>
>> /Jarkko
