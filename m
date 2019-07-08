Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08950C606C2
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 17:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E10B5216FD
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 17:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbfGHRQ5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 13:16:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:26052 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729583AbfGHRQ5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 13:16:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 10:16:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="316772142"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga004.jf.intel.com with ESMTP; 08 Jul 2019 10:16:56 -0700
Subject: Re: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
To:     Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
References: <cover.1562542383.git.cedric.xing@intel.com>
 <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
 <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <ce4dcce2-88fb-ccec-f173-fc567d9ca006@intel.com>
Date:   Mon, 8 Jul 2019 10:16:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/8/2019 9:26 AM, Casey Schaufler wrote:
> In this scheme you use an ema LSM to manage your ema data.
> A quick sketch looks like:
> 
> 	sgx_something_in() calls
> 		security_enclave_load() calls
> 			ema_enclave_load()
> 			selinux_enclave_load()
> 			otherlsm_enclave_load()
> 
> Why is this better than:
> 
> 	sgx_something_in() calls
> 		ema_enclave_load()
> 		security_enclave_load() calls
> 			selinux_enclave_load()
> 			otherlsm_enclave_load()

Are you talking about moving EMA somewhere outside LSM? If so, where?

> 
> 
> If you did really want ema to behave like an LSM
> you would put the file data that SELinux is managing
> into the ema portion of the blob and provide interfaces
> for the SELinux (or whoever) to use that. Also, it's
> an abomination (as I've stated before) for ema to
> rely on SELinux to provide a file_free() hook for
> ema's data. If you continue down the LSM route, you
> need to provide an ema_file_free() hook. You can't
> count on SELinux to do it for you. If there are multiple
> LSMs (coming soon!) that use the ema data, they'll all
> try to free it, and then Bad Things can happen.

I'm afraid you have misunderstood the code. What is kept open and gets 
closed in selinux_file_free() is the sigstruct file. SELinux uses it to 
determine the page permissions for enclave pages from anonymous sources. 
It is a policy choice made inside SELinux and has nothing to do with EMA.

There's indeed an ema_file_free_security() to free the EMA map for 
enclaves being closed. EMA does *NOT* rely on any other LSMs to free 
data for it. The only exception is when an LSM fails enclave_load(), it 
has to call ema_remove_range() to remove the range being added, which 
was *not* required originally in v2.

>> +/**
>> + * ema - Enclave Memory Area structure for LSM modules
> 
> LSM modules is redundant. "LSM" or "LSMs" would be better.

Noted

>> diff --git a/security/Makefile b/security/Makefile
>> index c598b904938f..b66d03a94853 100644
>> --- a/security/Makefile
>> +++ b/security/Makefile
>> @@ -28,6 +28,7 @@ obj-$(CONFIG_SECURITY_YAMA)		+= yama/
>>   obj-$(CONFIG_SECURITY_LOADPIN)		+= loadpin/
>>   obj-$(CONFIG_SECURITY_SAFESETID)       += safesetid/
>>   obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
>> +obj-$(CONFIG_INTEL_SGX)			+= commonema.o
> 
> The config option and the file name ought to match,
> or at least be closer.

Just trying to match file names as "capability" uses commoncap.c.

Like I said, this feature could potentially be used by TEEs other than 
SGX. For now, SGX is the only user so it is tied to CONFIG_INTEL_SGX. I 
can rename it to ema.c or enclave.c. Do you have a preference?

>> diff --git a/security/commonema.c b/security/commonema.c
> 
> Put this in a subdirectory. Please.

Then why is commoncap.c located in this directory? I'm just trying to 
match the existing convention.

>> +static struct lsm_blob_sizes ema_blob_sizes __lsm_ro_after_init = {
>> +	.lbs_file = sizeof(atomic_long_t),
>> +};
> 
> If this is ema's data ema must manage it. You *must* have
> a file_free().

There is one indeed - ema_file_free_security().

> 
>> +
>> +static atomic_long_t *_map_file(struct file *encl)
>> +{
>> +	return (void *)((char *)(encl->f_security) + ema_blob_sizes.lbs_file);
> 
> I don't trust all the casting going on here, especially since
> you don't end up with the type you should be returning.

Will change.

>> +}
>> +
>> +static struct ema_map *_alloc_map(void)
> 
> Function header comments, please.

Will add.
