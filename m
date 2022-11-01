Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FC1C433FE
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Nov 2022 18:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiKASYv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 1 Nov 2022 14:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiKASYt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 1 Nov 2022 14:24:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFE3192BF
        for <linux-sgx@vger.kernel.org>; Tue,  1 Nov 2022 11:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667327088; x=1698863088;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=00xS+JOL5J5k25mcjniwO/wvtd5OWaov5z4107Cqs4g=;
  b=lKB14SBAn08C1ZmTbqyiEOvjA2mG7wrT3eJSAHbXvCfzMx2I/zQDeB1V
   +ZotvMeVrt7QKF4nfciTnyTk7PjADHUUAeYHhdCUxj1CajjDeGBhctobv
   A8jIn4aPYBmMAAXLDSSRQHDs3Xfn6CoEAj8KM1seSA5YmqDBESUlm8/5S
   agFYjcoCseOU2IWJf+rXRecX7BQNDayNy7k62+Ic7eragzjZkB8p7P4cI
   d88HH7xTAeiZJCeV0cYF4CFbbcHSTdwyRTDn81MQMRunj0RsSn7Tc95K4
   JXA44P6JtnWOwGBZSlbq+utdSEAI+dhUCKrCfcZpBHQFP66fZMlwlIopl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="309208055"
X-IronPort-AV: E=Sophos;i="5.95,231,1661842800"; 
   d="scan'208";a="309208055"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 11:24:28 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="723251560"
X-IronPort-AV: E=Sophos;i="5.95,231,1661842800"; 
   d="scan'208";a="723251560"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.122.136.245])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 01 Nov 2022 11:24:28 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v2 2/4] x86/sgx: Implement support for MADV_WILLNEED
References: <20221027194532.180053-1-haitao.huang@linux.intel.com>
 <20221027194532.180053-2-haitao.huang@linux.intel.com>
 <20221027194532.180053-3-haitao.huang@linux.intel.com>
 <Y2B0jBsG6HE4KVk7@kernel.org>
Date:   Tue, 01 Nov 2022 13:24:24 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1uyv2yc5wjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <Y2B0jBsG6HE4KVk7@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On Mon, 31 Oct 2022 20:21:16 -0500, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> On Thu, Oct 27, 2022 at 12:45:30PM -0700, Haitao Huang wrote:
>> Support madvise(..., MADV_WILLNEED) by adding EPC pages with EAUG in
>> the newly added fops->fadvise() callback implementation, sgx_fadvise().
>>
>> Change the return type and values of the sgx_encl_eaug_page function
>> so that more specific error codes are returned for different treatment
>> by the page fault handler and the fadvise callback.
>> On any error, sgx_fadvise() will discontinue further operations
>> and return as normal. The page fault handler allows a PF retried
>> by returning VM_FAULT_NOPAGE in handling -EBUSY returned from
>> sgx_encl_eaug_page.
>>
>> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
>> ---
>>  arch/x86/kernel/cpu/sgx/driver.c | 81 ++++++++++++++++++++++++++++++++
>>  arch/x86/kernel/cpu/sgx/encl.c   | 46 +++++++++++-------
>>  arch/x86/kernel/cpu/sgx/encl.h   |  4 +-
>>  3 files changed, 113 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/driver.c  
>> b/arch/x86/kernel/cpu/sgx/driver.c
>> index aa9b8b868867..54b24897605b 100644
>> --- a/arch/x86/kernel/cpu/sgx/driver.c
>> +++ b/arch/x86/kernel/cpu/sgx/driver.c
>> @@ -2,6 +2,7 @@
>>  /*  Copyright(c) 2016-20 Intel Corporation. */
>>
>>  #include <linux/acpi.h>
>> +#include <linux/fadvise.h>
>>  #include <linux/miscdevice.h>
>>  #include <linux/mman.h>
>>  #include <linux/security.h>
>> @@ -9,6 +10,7 @@
>>  #include <asm/traps.h>
>>  #include "driver.h"
>>  #include "encl.h"
>> +#include "encls.h"
>>
>>  u64 sgx_attributes_reserved_mask;
>>  u64 sgx_xfrm_reserved_mask = ~0x3;
>> @@ -97,10 +99,88 @@ static int sgx_mmap(struct file *file, struct  
>> vm_area_struct *vma)
>>  	vma->vm_ops = &sgx_vm_ops;
>>  	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
>>  	vma->vm_private_data = encl;
>> +	/* Anchor vm_pgoff to the enclave base.
>> +	 * So offset passed back to sgx_fadvise hook
>> +	 * is relative to the enclave base
>> +	 */
>
> This comment only convolutes code because it does not tell anything
> that is non-intuitive to understand from the code.
>
>> +	vma->vm_pgoff = (vma->vm_start - encl->base) >> PAGE_SHIFT;
>
> vma->vm_pgoff = PFN_DOWN(vma->vm_start - encl->base);
>
>>
>>  	return 0;
>>  }
>>
>> +/*
>> + * Add new pages to the enclave sequentially with ENCLS[EAUG] for the  
>> WILLNEED advice.
>> + * Only do this to existing VMAs in the same enclave and reject the  
>> request.
>
> Keep this.
>
>> + * Returns:	0 if EAUG done with best effort, -EINVAL if any sub-range  
>> given
>> + * is not in the enclave, or enclave is not initialized..
>> + */
>
> Please remove this.
>
> It is useless and also incorrect, given that the function can also return
> other return values.
>
>> +static int sgx_fadvise(struct file *file, loff_t offset, loff_t len,  
>> int advice)
>> +{
>> +	struct sgx_encl *encl = file->private_data;
>> +	unsigned long start, end, pos;
>> +	int ret = -EINVAL;
>> +	struct vm_area_struct *vma = NULL;
>
> Reverse christmas tree order.
>
>> +
>> +	/* Only support WILLNEED */
>> +	if (advice != POSIX_FADV_WILLNEED)
>> +		return -EINVAL;
>> +	if (!encl)
>> +		return -EINVAL;
...
>> +
>> +	/* EAUG works only for initialized enclaves. */
>
> Please, remove this comment.
>
>> +	if (!test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
>> +		return -EINVAL;
...
>> +		/* Don't allow any gaps */
>> +		goto unlock;
>> +	}
>
> Empty line.
>
>> +	/* Here: vm_start <= pos < end <= vm_end */
>
...
>> +		if (ret)
>> +			break;
>> +		pos = pos + PAGE_SIZE;
>> +		cond_resched();
>> +	}
>> +	ret = 0;
>
> Empty line.
>

Thanks for the review. Will fix all above in next version.
BR
Haitao
