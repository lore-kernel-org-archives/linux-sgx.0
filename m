Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F78C742A4
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 23:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5430E21019
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 23:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfGKXlZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 19:41:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:64953 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbfGKXlZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 19:41:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 16:41:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="168778951"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga003.jf.intel.com with ESMTP; 11 Jul 2019 16:41:24 -0700
Subject: Re: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
To:     Stephen Smalley <sds@tycho.nsa.gov>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>
References: <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
 <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
 <ce4dcce2-88fb-ccec-f173-fc567d9ca006@intel.com>
 <decc7ae6-a89f-1ae5-6289-f3dcaa6390b0@schaufler-ca.com>
 <1f5b5fc1-9a95-9748-f9dc-0486c6ae30d8@intel.com>
 <34552999-160e-4f60-8d7e-37f51c895ef4@schaufler-ca.com>
 <e2a0d952-b4d4-f8f3-ee58-eba63f30dc66@intel.com>
 <4c3e21dd-8890-e3cb-0db7-c154ac7201e1@tycho.nsa.gov>
 <20190711151245.GD7645@linux.intel.com>
 <27e55a96-d5c4-69ed-a88d-7a3c26fb7f75@tycho.nsa.gov>
 <20190711162506.GF15067@linux.intel.com>
 <47feea29-68c2-83ee-497a-83b616d2f90c@tycho.nsa.gov>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <36b634f8-c119-91b2-c9b3-952e2b4e56a8@intel.com>
Date:   Thu, 11 Jul 2019 16:41:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <47feea29-68c2-83ee-497a-83b616d2f90c@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/11/2019 9:32 AM, Stephen Smalley wrote:
> On 7/11/19 12:25 PM, Sean Christopherson wrote:
>> On Thu, Jul 11, 2019 at 12:11:06PM -0400, Stephen Smalley wrote:
>>> On 7/11/19 11:12 AM, Sean Christopherson wrote:
>>>> On Thu, Jul 11, 2019 at 09:51:19AM -0400, Stephen Smalley wrote:
>>>>> I'd also feel better if there was clear consensus among all of the
>>>>> @intel.com participants that this is the right approach. To date 
>>>>> that has
>>>>> seemed elusive.
>>>>
>>>> That's a very kind way to phrase things :-)
>>>>
>>>> For initial upstreaming, we've agreed that there is no need to 
>>>> extend the
>>>> uapi, i.e. we can punt on deciding between on-the-fly tracking and 
>>>> having
>>>> userspace specify maximal permissions until we add SGX2 support.
>>>>
>>>> The last open (knock on wood) for initial upstreaming is whether 
>>>> SELinux
>>>> would prefer to have new enclave specific permissions or reuse the
>>>> existing PROCESS__EXECMEM, FILE__EXECUTE and FILE__EXECMOD permissions.
>>>> My understanding is that enclave specific permissions are preferred.
>>>
>>> I was left unclear on this topic after the email exchanges with Cedric.
>>> There are at least three options:
>>>
>>> 1) Reuse the existing EXECMEM, EXECUTE, and EXECMOD permissions.  Pros:
>>> Existing distro policies will be applied in the expected manner with 
>>> respect
>>> to the introduction of executable code into the system, consistent 
>>> control
>>> will be provided over the enclave and the host process, no change for
>>> users/documentation wrt policy.  Cons: Existing permissions don't map
>>> exactly to SGX semantics, no ability to distinguish executable content
>>> within the enclave versus the host process at the LSM level (argued 
>>> earlier
>>> by Cedric to be unnecessary and perhaps meaningless), need to allow
>>> FILE__EXECUTE or other checks on sigstruct files that may not actually
>>> contain code.
>>>
>>> 2) Define new permissions within existing security classes (e.g. 
>>> process2,
>>> file). Pros: Can tailor permission names and definitions to SGX 
>>> semantics,
>>> ability to distinguish enclave versus host process execute access, no 
>>> need
>>> to grant FILE__EXECUTE to sigstruct files, class matches the target 
>>> object,
>>> permissions computed and cached upon existing checks (i.e. when a 
>>> process
>>> accesses a file, all of the permissions to that file are computed and 
>>> then
>>> cached at once, including the enclave-related ones).  Cons: Typical 
>>> distro
>>> policies (unlike Android) allow unknown permissions by default for 
>>> forward
>>> kernel compatibility reasons, so existing policies will permit these new
>>> permissions by default and enforcement will only truly take effect once
>>> policies are updated, adding new permissions to existing classes 
>>> requires an
>>> update to the base policy (so they can't be shipped as a third party 
>>> policy
>>> module alongside the SGX driver or installed as a local module by an 
>>> admin,
>>> for example), documentation/user education required for new permissions.
>>>
>>> 3) Define new permissions in new security classes (e.g. enclave). Pros
>>> relative to #2: New classes and permissions can be defined and 
>>> installed in
>>> third party or local policy module without requiring a change to the 
>>> base
>>> policy.  Cons relative to #2: Class won't correspond to the target 
>>> object,
>>> permissions won't be computed and cached upon existing checks (only when
>>> performing the checks against the new classes).
>>>
>>> Combinations are also possible, of course.
>>
>> What's the impact on distros/ecosystems if we go with #1 for now and 
>> later
>> decide to switch to #2 after upstreaming?  I.e. can we take a minimal-ish
>> approach now without painting ourselves into a corner?
> 
> Yes, I think that's fine.

I can't agree more on this. It's easier to add new things than to take 
existing things out. We can just wait until usages come up that really 
require new permissions.
