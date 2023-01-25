Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C30C54EED
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Jan 2023 19:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbjAYTk6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Jan 2023 14:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbjAYTk5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 25 Jan 2023 14:40:57 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E64D4DE3C
        for <linux-sgx@vger.kernel.org>; Wed, 25 Jan 2023 11:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674675656; x=1706211656;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=NFdJbtRwzz3uSYLPrNXcdPG7evIBqpoofX9ayY04FGY=;
  b=bkZZ4ypzyq9R9BTX1EjC/6iy/FWP4KFK5YXbjyZFvOZ/Nsm0FzeBWSbJ
   y/Twra6xAZqicopxgtyuHNIuAP2ASZRaGnkoDnuMdy60tOKtkXax+7lNh
   7GmeYKDFpvEr9F2TN6idKS+q6kt21/Tlmu9/G9PhHnz+3qX+6wawA243T
   lgcNQFzF6W0X610Zq/vLV4fC1NdQ+Nd5zrTzeElQqyDO9YG/H22PnTCjB
   BOLYrgqy/36CwfiOwf/6fWSuVMPNvfPolAp9ou+tf/ZmMeq601b+dNdwu
   4zcOmiKhaw84ifTvf9w1ft6M+sUkQH1VMumTrTlSKKhsZ+OaTHccpuBFF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="327909403"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="327909403"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 11:40:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="731165728"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="731165728"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.122.136.103])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 25 Jan 2023 11:40:47 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v3 2/4] x86/sgx: Implement support for MADV_WILLNEED
References: <20221107220212.257422-1-haitao.huang@linux.intel.com>
 <20221107220212.257422-2-haitao.huang@linux.intel.com>
 <20221107220212.257422-3-haitao.huang@linux.intel.com>
 <Y3QMtZJd25lexKi8@kernel.org>
Date:   Wed, 25 Jan 2023 13:40:39 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.1zcd91mxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <Y3QMtZJd25lexKi8@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 15 Nov 2022 16:03:45 -0600, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:


>> +	if (!encl)
>> +		return -EINVAL;
>
> Why !encl check is needed?
It was intended as sanity check. But I think encl should not be null at  
this point so will remove in next version.

>
>> +	if (!cpu_feature_enabled(X86_FEATURE_SGX2))
>> +		return -EINVAL;
>
> This should be done first before doing anything else in the function.

Will do

>
>> +
>> +	if (offset + len < offset)
>> +		return -EINVAL;
>> +	if (encl->base + offset < encl->base)
>> +		return -EINVAL;
>> +	start  = offset + encl->base;
>> +	end = start + len;
>
> These could be just as well assigned in the declarations, which would
> definitely be also less convoluted.
>
Will do

...
>> diff --git a/arch/x86/kernel/cpu/sgx/encl.c  
>> b/arch/x86/kernel/cpu/sgx/encl.c
>> index 1abc5e7f2660..c57e60d5a0aa 100644
>> --- a/arch/x86/kernel/cpu/sgx/encl.c
>> +++ b/arch/x86/kernel/cpu/sgx/encl.c
>> @@ -305,11 +305,11 @@ struct sgx_encl_page *sgx_encl_load_page(struct  
>> sgx_encl *encl,
>>   * on a SGX2 system then the EPC can be added dynamically via the SGX2
>>   * ENCLS[EAUG] instruction.
>>   *
>> - * Returns: Appropriate vm_fault_t: VM_FAULT_NOPAGE when PTE was  
>> installed
>> - * successfully, VM_FAULT_SIGBUS or VM_FAULT_OOM as error otherwise.
>> + * Returns: 0 when PTE was installed successfully, -EBUSY for waiting  
>> on
>> + * reclaimer to free EPC, -ENOMEM for out of RAM, -EFAULT as error  
>> otherwise.
>>   */
>> -vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>> -			      struct sgx_encl *encl, unsigned long addr)
>> +int sgx_encl_eaug_page(struct vm_area_struct *vma,
>> +		       struct sgx_encl *encl, unsigned long addr)
>>  {
>>  	vm_fault_t vmret = VM_FAULT_SIGBUS;
>>  	struct sgx_pageinfo pginfo = {0};
>> @@ -318,10 +318,10 @@ vm_fault_t sgx_encl_eaug_page(struct  
>> vm_area_struct *vma,
>>  	struct sgx_va_page *va_page;
>>  	unsigned long phys_addr;
>>  	u64 secinfo_flags;
>> -	int ret;
>> +	int ret = -EFAULT;
>
> Why?
Original code uses ret only to temporarily store return values from the  
called functions.
Now I also use it as return of this function and assign -EFAULT as default
in all cases that ret is not assigned explicitly below, e.g., -EBUSY cases.
Basically -EFAULT cases are the same as VM_FAULT_SIGBUS cases in original  
code.
I'll clarify in comments above for the return values.

Thanks
Haitao
