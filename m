Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A7B4A990;
	Wed, 15 May 2024 21:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715810166; cv=none; b=mGoQ7boibYNfwlOIHbyGyPgSjBCaw6pTYtwohiUWtjpypFxlFl6N0iWHx5ooH/82IrzmW/4jg8ddbgKKyGgH0RrTsNkKd6iK/UP8Bg192O5pOuyyO2lDdXRaVIAIawVpmbqtDrJAtBOExSQi72xL1oemS+/tgaq8dV2LQNzNFZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715810166; c=relaxed/simple;
	bh=ag6RRN0W3k+lgmyxxVUJzaWjBVXqSE/9F+7Inf+hFGI=;
	h=Content-Type:To:Cc:Subject:References:Date:MIME-Version:From:
	 Message-ID:In-Reply-To; b=fHK9ldUAoCn9qc+Gq+b5bZDJYwBVFZaKEzgwq4rG/Tw0LfORoOHzIRzpVQZTOTMfgnpTZ/RgYXlnxIJZQnERvsm8NE2Fuov2/dT1xYWASy9zfhDRg9NXqJLBLoVCwgz21GN3pHhbz5mWQpQY78rHFJ3joGiEQufLvYP9FeAy/XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FfOgI1He; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FfOgI1He"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715810162; x=1747346162;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=ag6RRN0W3k+lgmyxxVUJzaWjBVXqSE/9F+7Inf+hFGI=;
  b=FfOgI1Hed1HdEKajt346iKOUxOeJA3FpVvL+e3o571QN0Cd8TKc2ppvv
   cqfS3e7+9BR9PEDCzlWEvoTEid1ulGUXrUHdY+olBNPJFIb3wUsHu55ZV
   pLu2FQlY2N2wrUt/bz/0BOEsGui7nE6cUiqZ210DiwDzcSbUQzx5fEKtK
   txphrGIqwj/iEACoNwvJQKCNKGRsgwq8hUgwu7asuDQXl7QomJgbBVCmQ
   +TbtAX8pdoxvpY1IKe9eipPmiygGaXOB0y7fXTo9aoSCUqq7623GLJPLT
   yjp6Gmvw2ewfIkezf+c3UpI+jjkBWL+bj2giTVWSdyXPvnw6DLCD+/dMl
   A==;
X-CSE-ConnectionGUID: v1aHGJoYQIS9uSfmgHgWvQ==
X-CSE-MsgGUID: iuMQsuyYQPm8Kv4V9hPfPA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22469749"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="22469749"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 14:56:02 -0700
X-CSE-ConnectionGUID: ZgrBB6ecRuu9FMeoxHmE0Q==
X-CSE-MsgGUID: GfKK2Q27QHu9riQoPEBVNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="68653337"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.17.168])
  by smtpauth.intel.com with ESMTP/TLS/AES256-SHA; 15 May 2024 14:56:01 -0700
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
Date: Wed, 15 May 2024 16:55:59 -0500
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.2nt1vls9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <20240515065521.67908-2-zhubojun.zbj@antgroup.com>
User-Agent: Opera Mail/1.0 (Win32)

On Wed, 15 May 2024 01:55:21 -0500, Bojun Zhu <zhubojun.zbj@antgroup.com>  
wrote:

> EDMM's ioctl()s support batch operations, which may be
> time-consuming. Try to explicitly give up the CPU as the prefix
> operation at the every begin of "for loop" in
> sgx_enclave_{ modify_types | restrict_permissions | remove_pages}
> to give other tasks a chance to run, and avoid softlockup warning.
>
> Additionally perform pending signals check as the prefix operation,
> and introduce sgx_check_signal_and_resched(),
> which wraps all the checks.
>
> The following has been observed on Linux v6.9-rc5 with kernel
> preemptions disabled(by configuring "PREEMPT_NONE=y"), when kernel
> is requested to restrict page permissions of a large number of EPC pages.
>
>     ------------[ cut here ]------------
>     watchdog: BUG: soft lockup - CPU#45 stuck for 22s!
>     ...
>     RIP: 0010:sgx_enclave_restrict_permissions+0xba/0x1f0
>     ...
>     Call Trace:
>      sgx_ioctl
>      __x64_sys_ioctl
>      x64_sys_call
>      do_syscall_64
>      entry_SYSCALL_64_after_hwframe
>     ------------[ end trace ]------------
>
> Signed-off-by: Bojun Zhu <zhubojun.zbj@antgroup.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 40 +++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c  
> b/arch/x86/kernel/cpu/sgx/ioctl.c
> index b65ab214bdf5..6199f483143e 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -365,6 +365,20 @@ static int sgx_validate_offset_length(struct  
> sgx_encl *encl,
>  	return 0;
>  }
> +/*
> + * Check signals and invoke scheduler. Return true for a pending signal.
> + */
> +static bool sgx_check_signal_and_resched(void)
> +{
> +	if (signal_pending(current))
> +		return true;
> +
> +	if (need_resched())
> +		cond_resched();
> +
> +	return false;
> +}
> +
>  /**
>   * sgx_ioc_enclave_add_pages() - The handler for  
> %SGX_IOC_ENCLAVE_ADD_PAGES
>   * @encl:       an enclave pointer
> @@ -409,7 +423,7 @@ static long sgx_ioc_enclave_add_pages(struct  
> sgx_encl *encl, void __user *arg)
>  	struct sgx_enclave_add_pages add_arg;
>  	struct sgx_secinfo secinfo;
>  	unsigned long c;
> -	int ret;
> +	int ret = -ERESTARTSYS;
> 	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
>  	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
> @@ -432,15 +446,8 @@ static long sgx_ioc_enclave_add_pages(struct  
> sgx_encl *encl, void __user *arg)
>  		return -EINVAL;
> 	for (c = 0 ; c < add_arg.length; c += PAGE_SIZE) {
> -		if (signal_pending(current)) {
> -			if (!c)
> -				ret = -ERESTARTSYS;
> -
> +		if (sgx_check_signal_and_resched())
>  			break;
> -		}

ERESTARTSYS is only appropriate if we have not EADDed any pages yet.
If we got interrupted in the middle, we should return 0. User space would  
check the 'count' returned and decide to recall this ioctl() with  
'offset'  reset to the next page, and adjust length.

Ditto for other changes below.

Thanks
Haitao
