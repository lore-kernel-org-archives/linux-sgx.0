Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7177BC73C65
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 00:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38FE320693
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 00:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfGJAz2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Jul 2019 20:55:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:36947 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfGJAz2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Jul 2019 20:55:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 17:55:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,472,1557212400"; 
   d="scan'208";a="168152739"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga003.jf.intel.com with ESMTP; 09 Jul 2019 17:55:27 -0700
Subject: Re: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
To:     Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
References: <cover.1562542383.git.cedric.xing@intel.com>
 <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
 <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
 <ce4dcce2-88fb-ccec-f173-fc567d9ca006@intel.com>
 <decc7ae6-a89f-1ae5-6289-f3dcaa6390b0@schaufler-ca.com>
 <1f5b5fc1-9a95-9748-f9dc-0486c6ae30d8@intel.com>
 <34552999-160e-4f60-8d7e-37f51c895ef4@schaufler-ca.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <e2a0d952-b4d4-f8f3-ee58-eba63f30dc66@intel.com>
Date:   Tue, 9 Jul 2019 17:55:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <34552999-160e-4f60-8d7e-37f51c895ef4@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/9/2019 5:10 PM, Casey Schaufler wrote:
> On 7/9/2019 3:13 PM, Xing, Cedric wrote:
>> On 7/8/2019 4:53 PM, Casey Schaufler wrote:
>>> On 7/8/2019 10:16 AM, Xing, Cedric wrote:
>>>> On 7/8/2019 9:26 AM, Casey Schaufler wrote:
>>>>> In this scheme you use an ema LSM to manage your ema data.
>>>>> A quick sketch looks like:
>>>>>
>>>>>       sgx_something_in() calls
>>>>>           security_enclave_load() calls
>>>>>               ema_enclave_load()
>>>>>               selinux_enclave_load()
>>>>>               otherlsm_enclave_load()
>>>>>
>>>>> Why is this better than:
>>>>>
>>>>>       sgx_something_in() calls
>>>>>           ema_enclave_load()
>>>>>           security_enclave_load() calls
>>>>>               selinux_enclave_load()
>>>>>               otherlsm_enclave_load()
>>>>
>>>> Are you talking about moving EMA somewhere outside LSM?
>>>
>>> Yes. That's what I've been saying all along.
>>>
>>>> If so, where?
>>>
>>> I tried to make it obvious. Put the call to your EMA code
>>> on the line before you call security_enclave_load().
>>
>> Sorry but I'm still confused.
>>
>> EMA code is used by LSMs only. Making it callable from other parts of the kernel IMHO is probably not a good idea. And more importantly I don't understand the motivation behind it. Would you please elaborate?
> 
> LSM modules implement additional access control restrictions.
> The EMA code does not do that, it provides management of data
> that is used by security modules. It is not one itself. VFS
> also performs this role, but no one would consider making VFS
> a security module.

You are right. EMA is more like a helper library than a real LSM. But 
the practical problem is, it has a piece of initialization code, to 
basically request some space in the file blob from the LSM 
infrastructure. That cannot be done by any LSMs at runtime. So it has to 
either be done in LSM infrastructure directly, or make itself an LSM to 
make its initialization function invoked by LSM infrastructure 
automatically. You have objected to the former, so I switched to the 
latter. Are you now objecting to the latter as well? Then what are you 
suggesting, really?

VFS is a completely different story. It's the file system abstraction so 
it has a natural place to live in the kernel, and its initialization 
doesn't depend on the LSM infrastructure. EMA on the other hand, shall 
belong to LSM because it is both produced and consumed within LSM.

And, Stephen, do you have an opinion on this?

>>>>>> +/**
>>>>>> + * ema - Enclave Memory Area structure for LSM modules
>>>>>
>>>>> LSM modules is redundant. "LSM" or "LSMs" would be better.
>>>>
>>>> Noted
>>>>
>>>>>> diff --git a/security/Makefile b/security/Makefile
>>>>>> index c598b904938f..b66d03a94853 100644
>>>>>> --- a/security/Makefile
>>>>>> +++ b/security/Makefile
>>>>>> @@ -28,6 +28,7 @@ obj-$(CONFIG_SECURITY_YAMA)        += yama/
>>>>>>     obj-$(CONFIG_SECURITY_LOADPIN)        += loadpin/
>>>>>>     obj-$(CONFIG_SECURITY_SAFESETID)       += safesetid/
>>>>>>     obj-$(CONFIG_CGROUP_DEVICE)        += device_cgroup.o
>>>>>> +obj-$(CONFIG_INTEL_SGX)            += commonema.o
>>>>>
>>>>> The config option and the file name ought to match,
>>>>> or at least be closer.
>>>>
>>>> Just trying to match file names as "capability" uses commoncap.c.
>>>
>>> Fine, then you should be using CONFIG_SECURITY_EMA.
>>>
>>>>
>>>> Like I said, this feature could potentially be used by TEEs other than SGX. For now, SGX is the only user so it is tied to CONFIG_INTEL_SGX. I can rename it to ema.c or enclave.c. Do you have a preference?
>>>
>>> Make
>>>      CONFIG_SECURITY_EMA
>>>      depends on CONFIG_INTEL_SGX
>>>
>>> When another TEE (maybe MIPS_SSRPQ) comes along you can have
>>>
>>>      CONFIG_SECURITY_EMA
>>>      depends on CONFIG_INTEL_SGX || CONFIG_MIPS_SSRPQ
>>
>> Your suggestions are reasonable. Given such config change wouldn't affect any code, can we do it later,
> 
> That doesn't make the current options any less confusing,
> and it will be easier to make the change now than at some
> point in the future.
> 
>> e.g., when additional TEEs come online and make use of these new hooks? After all, security_enclave_init() will need amendment anyway as one of its current parameters is of type 'struct sgx_sigstruct', which will need to be replaced with something more generic. At the time being, I'd like to keep things intuitive so as not to confuse reviewers.
> 
> Reviewers (including me) are already confused by the inconsistency.

OK. Let me make this change.

>>>>
>>>>>> diff --git a/security/commonema.c b/security/commonema.c
>>>>>
>>>>> Put this in a subdirectory. Please.
>>>>
>>>> Then why is commoncap.c located in this directory? I'm just trying to match the existing convention.
>>>
>>> commoncap is not optional. It is a base part of the
>>> security subsystem. ema is optional.
>>
>> Alright. I'd move it into a sub-folder and rename it to ema.c. Would you be ok with that?
> 
> Sounds fine.

This is another part that confuses me. Per you comment here, I think you 
are OK with EMA being part of LSM (I mean, living somewhere under 
security/). But your other comment of calling ema_enclave_load() 
alongside security_enclave_load() made me think EMA and LSM were 
separate. What do you want really?
