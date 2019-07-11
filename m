Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17896C74A35
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 13:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B28A621019
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 13:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="oAKLcxs5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfGKNva (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 09:51:30 -0400
Received: from upbd19pa07.eemsg.mail.mil ([214.24.27.82]:1869 "EHLO
        upbd19pa07.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfGKNva (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 11 Jul 2019 09:51:30 -0400
X-EEMSG-check-017: 239234729|UPBD19PA07_EEMSG_MP7.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by upbd19pa07.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 11 Jul 2019 13:51:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1562853083; x=1594389083;
  h=subject:to:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=G+PxTH7OWqumi/+6Ta1blxd2svt+HpJmw4haoB36jNg=;
  b=oAKLcxs5x8puzO4pJSV/bbjNruYNm5lPxOOkxtfVNxUMgVxy1Na2ynae
   ZgkXf1Qm7mrrZUp9m7zwd7KQSi2bpYmij+BBwRyEgm9HpmXKi2GnI+tG0
   o57n9zcy9asLyxszqgn7UETUoYjg4SS8/HSQiPYOFgH3d0ta9X0kfQEjG
   RgqnQ+urYYvKXGBo/nLQmDaEh+hRZrQYr+iy7iSH4SnSTvg0TQa5ozb0V
   McbxhkMsFvMdDjsz+sORYfCrJfryN2WNgKpdd1M85d8VBFitCx3vBcym3
   hrqyhruqBGvPdVzHuzehj7OfGS7mn+JpzZ+rlk6cHAgVfAhX/EzpXexGw
   w==;
X-IronPort-AV: E=Sophos;i="5.63,478,1557187200"; 
   d="scan'208";a="25601961"
IronPort-PHdr: =?us-ascii?q?9a23=3AplT6SB+jBRv3HP9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B+0eMfIJqq85mqBkHD//Il1AaPAdyBra4UwLSG+4nbGkU4qa6bt34DdJEeHz?=
 =?us-ascii?q?Qksu4x2zIaPcieFEfgJ+TrZSFpVO5LVVti4m3peRMNQJW2aFLduGC94iAPER?=
 =?us-ascii?q?vjKwV1Ov71GonPhMiryuy+4ZLebxhWiDanbr5/Lxq6oATSu8ILnYZsN6E9xw?=
 =?us-ascii?q?fTrHBVYepW32RoJVySnxb4+Mi9+YNo/jpTtfw86cNOSL32cKskQ7NWCjQmKH?=
 =?us-ascii?q?0169bwtRbfVwuP52ATXXsQnxFVHgXK9hD6XpP2sivnqupw3TSRMMPqQbwoXz?=
 =?us-ascii?q?mp8rxmQwH0higZKzE58XnXis1ug6JdvBKhvAF0z4rNbI2IKPZyYqbRcNUUSm?=
 =?us-ascii?q?pbWsZaSjJPDIWyYYASC+YNJOZVoo34q1YIsBCwBxSjBPn3xzFVmHH206003e?=
 =?us-ascii?q?cvHw7I0wMvHc4BvnvPodXpN6ofS/y5wLXGwDjBaf5dxDfz6JLPchAkufyCQK?=
 =?us-ascii?q?5wftTJyUkvCQzFiEibp5HgPzyP0uQNt3aU7up9Xu+okG4othpxryOzxsYslo?=
 =?us-ascii?q?bJhoUVxkrC9SVi2ok5P9K4SEllYdO9FpZbqiKUN5NuT88/TGxltzw2x70btZ?=
 =?us-ascii?q?KhYiQHx4orywTCZ/GBboOG+AjsVPyLLjd9nH9lfbW/iAus/kW40e38U9W00E?=
 =?us-ascii?q?5NripYjtnArnAN2ALX6siAUvZ94l2u2SyO1wDO8eFIO1w0lKrHJJ4hxb48jJ?=
 =?us-ascii?q?wTvljYHiDqgkn2ia6WdkE89uip7eTofKnmq4eBO4J7hQzyKKQjltGlDegmPQ?=
 =?us-ascii?q?UCQXKX9fmk2L3m50L5QbFKjvMskqnetZDXPd8bqbOiAwJOzoYi6wqwDzeh0N?=
 =?us-ascii?q?gCm3kHN0hKdAiIj4juJVHCOOr4Auung1SwjDdrwOjLMaH/DZrQNHjDkavuca?=
 =?us-ascii?q?xy6k5dzgozwstS55NSCrEdPv3zXlX9u8DfDh88Kwa02froCM1h1oMCXmKCGr?=
 =?us-ascii?q?OWP7nJsVCW5uMiOPKMa5MVuDnnNvgl6frugmEjmVMEYaamx4EbZ2y/HvRjO0?=
 =?us-ascii?q?+Ze2bjgs8dEWcWuQozVOjqiFyEUT5OaHe+Rrk85j40CY+9E4fDSZ6igKab0C?=
 =?us-ascii?q?e4AJJWfGZGBU6IEXvycIWEQfgMYjqIIsB9ijwESaShS4g52BGqtQ/6zadnL+?=
 =?us-ascii?q?XN9i0Dq53syMV15/fSlREu9T14FsGd02aQQGFpmmMHWSQ73L5woUNj0FePy6?=
 =?us-ascii?q?t4jOJCFdxV+fxJVh02NZnGz+x1E9ryQB7Ofs+VSFa6RdWrGSoxQcw1w98PZU?=
 =?us-ascii?q?Z9Btqjgwvd3yqlHbAVjaaHBJ8q/aLG2Xj+OcJ9x2zB1Kk7gFksWtFPOnG+hq?=
 =?us-ascii?q?5j6wjTAJbEk0ecl6atb6Qcxi/N9HyYwGqIpk5YVRB/UaTfUXAYfEvWooex2k?=
 =?us-ascii?q?SXBY+vD7tjeiBMxdSDIeECPtbkgU9HT7HzOdLRS2O3h2q0Qx2Pw+XIJKHjYG?=
 =?us-ascii?q?gMlB7WCEEZnQQe5z7SPgElCzaJuGneBSFgEV/1Jkjlt+J5rSX/Bks1yRyaKl?=
 =?us-ascii?q?Zux5Kr9RMPw/+RUfUe2vQDoihl4zF1GkutmsnbAMeaphZwOaBbbc457X9Z2m?=
 =?us-ascii?q?/D8Q9wJJqtK+ZlnFFaOx96u0LoygVfFIpNi44poWkswQ40LriXlBtjfjaVxt?=
 =?us-ascii?q?jVPafNK3K6qBKqbLTM20r21t+T96ZJ7+43/QbNpgasQ3E+/m1n3t8d6H6V4p?=
 =?us-ascii?q?HHHUJGSp7qelom/Bh94bfBa28y4J2Chi4kCrW9rjKXg4FhP+Ai0Bv1Oo4CYa?=
 =?us-ascii?q?4=3D?=
X-IPAS-Result: =?us-ascii?q?A2C9BAAFPidd/wHyM5BlHQEBBQEHBQGBZ4FoBSpqUjIoh?=
 =?us-ascii?q?BySXlMGgQkIJYlekRUJAQEBAQEBAQEBIxEBAgEBhEACglMjOBMBAwEBAQQBA?=
 =?us-ascii?q?QEBBAEBbIU8DII6KQGCZwEFIw8BBVEJAhIGAgImAgJJDgYBDAgBAYJfPwGBd?=
 =?us-ascii?q?hSQQptrgTKFR4MqgUeBDCiLXxd4gQeBEScMgjEuPodOglgElBKWSQmCG4Ifh?=
 =?us-ascii?q?DmNKgYbgixthjeOM40zmVkhgVgrCAIYCCEPgycJgkQXg06KbyMDMIEGAQGPD?=
 =?us-ascii?q?wEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 11 Jul 2019 13:51:21 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x6BDpJt7011538;
        Thu, 11 Jul 2019 09:51:19 -0400
Subject: Re: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, James Morris <jmorris@namei.org>
References: <cover.1562542383.git.cedric.xing@intel.com>
 <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
 <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
 <ce4dcce2-88fb-ccec-f173-fc567d9ca006@intel.com>
 <decc7ae6-a89f-1ae5-6289-f3dcaa6390b0@schaufler-ca.com>
 <1f5b5fc1-9a95-9748-f9dc-0486c6ae30d8@intel.com>
 <34552999-160e-4f60-8d7e-37f51c895ef4@schaufler-ca.com>
 <e2a0d952-b4d4-f8f3-ee58-eba63f30dc66@intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <4c3e21dd-8890-e3cb-0db7-c154ac7201e1@tycho.nsa.gov>
Date:   Thu, 11 Jul 2019 09:51:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e2a0d952-b4d4-f8f3-ee58-eba63f30dc66@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/9/19 8:55 PM, Xing, Cedric wrote:
> On 7/9/2019 5:10 PM, Casey Schaufler wrote:
>> On 7/9/2019 3:13 PM, Xing, Cedric wrote:
>>> On 7/8/2019 4:53 PM, Casey Schaufler wrote:
>>>> On 7/8/2019 10:16 AM, Xing, Cedric wrote:
>>>>> On 7/8/2019 9:26 AM, Casey Schaufler wrote:
>>>>>> In this scheme you use an ema LSM to manage your ema data.
>>>>>> A quick sketch looks like:
>>>>>>
>>>>>>       sgx_something_in() calls
>>>>>>           security_enclave_load() calls
>>>>>>               ema_enclave_load()
>>>>>>               selinux_enclave_load()
>>>>>>               otherlsm_enclave_load()
>>>>>>
>>>>>> Why is this better than:
>>>>>>
>>>>>>       sgx_something_in() calls
>>>>>>           ema_enclave_load()
>>>>>>           security_enclave_load() calls
>>>>>>               selinux_enclave_load()
>>>>>>               otherlsm_enclave_load()
>>>>>
>>>>> Are you talking about moving EMA somewhere outside LSM?
>>>>
>>>> Yes. That's what I've been saying all along.
>>>>
>>>>> If so, where?
>>>>
>>>> I tried to make it obvious. Put the call to your EMA code
>>>> on the line before you call security_enclave_load().
>>>
>>> Sorry but I'm still confused.
>>>
>>> EMA code is used by LSMs only. Making it callable from other parts of 
>>> the kernel IMHO is probably not a good idea. And more importantly I 
>>> don't understand the motivation behind it. Would you please elaborate?
>>
>> LSM modules implement additional access control restrictions.
>> The EMA code does not do that, it provides management of data
>> that is used by security modules. It is not one itself. VFS
>> also performs this role, but no one would consider making VFS
>> a security module.
> 
> You are right. EMA is more like a helper library than a real LSM. But 
> the practical problem is, it has a piece of initialization code, to 
> basically request some space in the file blob from the LSM 
> infrastructure. That cannot be done by any LSMs at runtime. So it has to 
> either be done in LSM infrastructure directly, or make itself an LSM to 
> make its initialization function invoked by LSM infrastructure 
> automatically. You have objected to the former, so I switched to the 
> latter. Are you now objecting to the latter as well? Then what are you 
> suggesting, really?
> 
> VFS is a completely different story. It's the file system abstraction so 
> it has a natural place to live in the kernel, and its initialization 
> doesn't depend on the LSM infrastructure. EMA on the other hand, shall 
> belong to LSM because it is both produced and consumed within LSM.
> 
> And, Stephen, do you have an opinion on this?

I don't really understand Casey's position.  I also wouldn't necessarily 
view his opinion on the matter as necessarily authoritative since he is 
not the LSM maintainer as far as I know although he has contributed a 
lot of changes in recent years.

I understood the architecture of the original EMA implementation (i.e. a 
support library to be used by the security modules to help them in 
implementing their own access control policies), although I do have some 
concerns about the complexity and lifecycle issues, and wonder if a 
simpler model as suggested by Dr. Greg isn't feasible.

I'd also feel better if there was clear consensus among all of the 
@intel.com participants that this is the right approach. To date that 
has seemed elusive.

If there were consensus that the EMA approach was the right one and that 
a simpler model is not feasible, and if the only obstacle to adopting 
EMA was Casey's objections, then I'd say just put it directly into 
SELinux and be done with it.  I originally thought that was a mistake 
but if other security modules don't want the support, so be it.

> 
>>>>>>> +/**
>>>>>>> + * ema - Enclave Memory Area structure for LSM modules
>>>>>>
>>>>>> LSM modules is redundant. "LSM" or "LSMs" would be better.
>>>>>
>>>>> Noted
>>>>>
>>>>>>> diff --git a/security/Makefile b/security/Makefile
>>>>>>> index c598b904938f..b66d03a94853 100644
>>>>>>> --- a/security/Makefile
>>>>>>> +++ b/security/Makefile
>>>>>>> @@ -28,6 +28,7 @@ obj-$(CONFIG_SECURITY_YAMA)        += yama/
>>>>>>>     obj-$(CONFIG_SECURITY_LOADPIN)        += loadpin/
>>>>>>>     obj-$(CONFIG_SECURITY_SAFESETID)       += safesetid/
>>>>>>>     obj-$(CONFIG_CGROUP_DEVICE)        += device_cgroup.o
>>>>>>> +obj-$(CONFIG_INTEL_SGX)            += commonema.o
>>>>>>
>>>>>> The config option and the file name ought to match,
>>>>>> or at least be closer.
>>>>>
>>>>> Just trying to match file names as "capability" uses commoncap.c.
>>>>
>>>> Fine, then you should be using CONFIG_SECURITY_EMA.
>>>>
>>>>>
>>>>> Like I said, this feature could potentially be used by TEEs other 
>>>>> than SGX. For now, SGX is the only user so it is tied to 
>>>>> CONFIG_INTEL_SGX. I can rename it to ema.c or enclave.c. Do you 
>>>>> have a preference?
>>>>
>>>> Make
>>>>      CONFIG_SECURITY_EMA
>>>>      depends on CONFIG_INTEL_SGX
>>>>
>>>> When another TEE (maybe MIPS_SSRPQ) comes along you can have
>>>>
>>>>      CONFIG_SECURITY_EMA
>>>>      depends on CONFIG_INTEL_SGX || CONFIG_MIPS_SSRPQ
>>>
>>> Your suggestions are reasonable. Given such config change wouldn't 
>>> affect any code, can we do it later,
>>
>> That doesn't make the current options any less confusing,
>> and it will be easier to make the change now than at some
>> point in the future.
>>
>>> e.g., when additional TEEs come online and make use of these new 
>>> hooks? After all, security_enclave_init() will need amendment anyway 
>>> as one of its current parameters is of type 'struct sgx_sigstruct', 
>>> which will need to be replaced with something more generic. At the 
>>> time being, I'd like to keep things intuitive so as not to confuse 
>>> reviewers.
>>
>> Reviewers (including me) are already confused by the inconsistency.
> 
> OK. Let me make this change.
> 
>>>>>
>>>>>>> diff --git a/security/commonema.c b/security/commonema.c
>>>>>>
>>>>>> Put this in a subdirectory. Please.
>>>>>
>>>>> Then why is commoncap.c located in this directory? I'm just trying 
>>>>> to match the existing convention.
>>>>
>>>> commoncap is not optional. It is a base part of the
>>>> security subsystem. ema is optional.
>>>
>>> Alright. I'd move it into a sub-folder and rename it to ema.c. Would 
>>> you be ok with that?
>>
>> Sounds fine.
> 
> This is another part that confuses me. Per you comment here, I think you 
> are OK with EMA being part of LSM (I mean, living somewhere under 
> security/). But your other comment of calling ema_enclave_load() 
> alongside security_enclave_load() made me think EMA and LSM were 
> separate. What do you want really?

