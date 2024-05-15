Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F16A15B14D;
	Wed, 15 May 2024 22:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715812194; cv=none; b=Rcifc4xEyZpeUp7WQ/r8PtPeOPoc+FM2jaIBrY9gYLPVXfs/mZiUblvVMqBha06A5nycgEjWugLn88RgTxZljxal9v5Y8gL9kN6wiz4TPfftdIKvc2rp1J4DNxmXWiOg7zADobs6avaiKfZ9vzyOFGZSp/1+lUOODTFfY9Nw5e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715812194; c=relaxed/simple;
	bh=27nbdem5s/AwTYYPl6s7NGoH7kWLD+sGJfMyucZ8ZPk=;
	h=Content-Type:To:Cc:Subject:References:Date:MIME-Version:From:
	 Message-ID:In-Reply-To; b=svs4FxO5AmJZZp9HZUqgHfiplNnn9AnKkLH9qKGXYJATrYBEJ2Df52kDrEUmxIH6ax+B7DHDvul/mqlglV9+ZyKa3YUxEmw4uxp9bM5TeUth1EN/aZCTrMY16UczxKUXJE1D7bDnOy9Ep9PLiYZg0YQrm+J1NThrs0q1EeXN1xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VhS6CU/j; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VhS6CU/j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715812193; x=1747348193;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=27nbdem5s/AwTYYPl6s7NGoH7kWLD+sGJfMyucZ8ZPk=;
  b=VhS6CU/j0z/nrOlPm/il6MlJCNfyZKqcuOMFnKV6KvWXYQKylBdsmB3g
   5S5toQvmt8Oo2Q0d88raTaAloSm1rKDJ88hdVG/dEfxSk6rMmVwnJkaxi
   rzddLwHJFUai0KsMM1BnasF+zQAQmH+MAN8tEtLqUMFf7VcAz8jZqiH5X
   flCcKcBMbI+NZA1kwFIvOqLEhsl9J+/x8mS+hKVYIUdpIRTNKQpswgal+
   K2ruxPvj64IFDRTM9T0LrJQHmszuaOnvcilo1dC9sCzE8GafyxcULq3ir
   du30jEQOAQrtgBWgr0N6q8zy9JUM8PXTIcOrvKzl7Tm4cwHQHtU01nhP5
   A==;
X-CSE-ConnectionGUID: zJVugIJmTk+RWK0IXNhLjg==
X-CSE-MsgGUID: 44Tg4jqqS1yFoHG1wNe6ig==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15717249"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15717249"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:29:52 -0700
X-CSE-ConnectionGUID: 4y3j4iNfSqumB1FLBRfLQQ==
X-CSE-MsgGUID: ewgLClsLRLSHoebrAS+Hyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31040329"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.17.168])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 15 May 2024 15:29:51 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
 jarkko@kernel.org, dave.hansen@linux.intel.com, "Bojun Zhu"
 <zhubojun.zbj@antgroup.com>
Cc: reinette.chatre@intel.com, =?utf-8?B?5YiY5Y+MKOi9qeWxuSk=?=
 <ls123674@antgroup.com>
Subject: Re: [RFC PATCH v3 1/1] x86/sgx: Explicitly give up the CPU in EDMM's
 ioctl() to avoid softlockup
References: <20240515065521.67908-1-zhubojun.zbj@antgroup.com>
 <20240515065521.67908-2-zhubojun.zbj@antgroup.com>
 <op.2nt1vls9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
Date: Wed, 15 May 2024 17:29:49 -0500
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.2nt3fzsnwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.2nt1vls9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
User-Agent: Opera Mail/1.0 (Win32)

On Wed, 15 May 2024 16:55:59 -0500, Haitao Huang  
<haitao.huang@linux.intel.com> wrote:

> On Wed, 15 May 2024 01:55:21 -0500, Bojun Zhu  
> <zhubojun.zbj@antgroup.com> wrote:
>
>> EDMM's ioctl()s support batch operations, which may be
>> time-consuming. Try to explicitly give up the CPU as the prefix
>> operation at the every begin of "for loop" in
>> sgx_enclave_{ modify_types | restrict_permissions | remove_pages}
>> to give other tasks a chance to run, and avoid softlockup warning.
>>
>> Additionally perform pending signals check as the prefix operation,
>> and introduce sgx_check_signal_and_resched(),
>> which wraps all the checks.
>>
>> The following has been observed on Linux v6.9-rc5 with kernel
>> preemptions disabled(by configuring "PREEMPT_NONE=y"), when kernel
>> is requested to restrict page permissions of a large number of EPC  
>> pages.
>>
>>     ------------[ cut here ]------------
>>     watchdog: BUG: soft lockup - CPU#45 stuck for 22s!
>>     ...
>>     RIP: 0010:sgx_enclave_restrict_permissions+0xba/0x1f0
>>     ...
>>     Call Trace:
>>      sgx_ioctl
>>      __x64_sys_ioctl
>>      x64_sys_call
>>      do_syscall_64
>>      entry_SYSCALL_64_after_hwframe
>>     ------------[ end trace ]------------
>>
>> Signed-off-by: Bojun Zhu <zhubojun.zbj@antgroup.com>
>> ---
>>  arch/x86/kernel/cpu/sgx/ioctl.c | 40 +++++++++++++++++++++++----------
>>  1 file changed, 28 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c  
>> b/arch/x86/kernel/cpu/sgx/ioctl.c
>> index b65ab214bdf5..6199f483143e 100644
>> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
>> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
>> @@ -365,6 +365,20 @@ static int sgx_validate_offset_length(struct  
>> sgx_encl *encl,
>>  	return 0;
>>  }
>> +/*
>> + * Check signals and invoke scheduler. Return true for a pending  
>> signal.
>> + */
>> +static bool sgx_check_signal_and_resched(void)
>> +{
>> +	if (signal_pending(current))
>> +		return true;
>> +
>> +	if (need_resched())
>> +		cond_resched();
>> +
>> +	return false;
>> +}
>> +
>>  /**
>>   * sgx_ioc_enclave_add_pages() - The handler for  
>> %SGX_IOC_ENCLAVE_ADD_PAGES
>>   * @encl:       an enclave pointer
>> @@ -409,7 +423,7 @@ static long sgx_ioc_enclave_add_pages(struct  
>> sgx_encl *encl, void __user *arg)
>>  	struct sgx_enclave_add_pages add_arg;
>>  	struct sgx_secinfo secinfo;
>>  	unsigned long c;
>> -	int ret;
>> +	int ret = -ERESTARTSYS;
>> 	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
>>  	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
>> @@ -432,15 +446,8 @@ static long sgx_ioc_enclave_add_pages(struct  
>> sgx_encl *encl, void __user *arg)
>>  		return -EINVAL;
>> 	for (c = 0 ; c < add_arg.length; c += PAGE_SIZE) {
>> -		if (signal_pending(current)) {
>> -			if (!c)
>> -				ret = -ERESTARTSYS;
>> -
>> +		if (sgx_check_signal_and_resched())
>>  			break;
>> -		}
>
> ERESTARTSYS is only appropriate if we have not EADDed any pages yet.
> If we got interrupted in the middle, we should return 0. User space  
> would check the 'count' returned and decide to recall this ioctl() with  
> 'offset'  reset to the next page, and adjust length.

NVM, I misread it. ret will be changed to zero in subsequent iteration.

Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>

Thanks
Haitao
