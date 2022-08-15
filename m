Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BA7C25B0E
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Aug 2022 15:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiHOPBz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Aug 2022 11:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiHOPBg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 15 Aug 2022 11:01:36 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D886167F9
        for <linux-sgx@vger.kernel.org>; Mon, 15 Aug 2022 08:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660575694; x=1692111694;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=63868UrDzvGleVquFU4BtsGQjWzgYVlP/+VE0ZlRLWk=;
  b=SIfIMOJQBNpox3s5xkeGzaLHP0RK2PPyUEHB1KR7YfaiaU64KfCLXabg
   +JjxZUoUatHtbILuzAHL8Qn6CmJzvcTrF3HVdAKu7vAzq8vWMV8oSePAz
   RVHHigC8sCKIifvfEx0iR3ad7B1rd+QJaee1KqYy/q8dcZoZ6z7zP62Ky
   vcUaWZ4ambdmBxj902yQzXZdLi3fHVhGwjP86jOSyhIYFxE5LMWaw5ZGR
   SOCYtUqr8s4JEJEWSU6WvKLLwf3HysAobMNyGgjmP7rsqRma9ZK2uGVXZ
   7ErRd8qfJjEDVqM6qIgE3zLo1//+t7rq7TqhQR4dj2B8mZCEmrjU4dfCy
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="317962366"
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="317962366"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 08:01:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="934502251"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.209.188.67])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 15 Aug 2022 08:01:29 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, reinette.chatre@intel.com,
        dave.hansen@linux.intel.com, vijay.dhanraj@intel.com
Subject: Re: [PATCH] x86/sgx: handle VA page allocation failure for EAUG on
 PF.
References: <20220812191224.15561-1-haitao.huang@linux.intel.com>
 <YvlOvZfhm6msW2Ca@kernel.org>
Date:   Mon, 15 Aug 2022 10:01:26 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1qx6oovwwjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <YvlOvZfhm6msW2Ca@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 14 Aug 2022 14:36:29 -0500, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> On Fri, Aug 12, 2022 at 12:12:24PM -0700, Haitao Huang wrote:
>> Return VM_FAULT_NOPAGE to allow the swapping thread to catch up.
>>
>> link:  
>> https://lore.kernel.org/all/20220804201456.33418-1-vijay.dhanraj@intel.com/
>>
>> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
>> ---
>>  arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/encl.c  
>> b/arch/x86/kernel/cpu/sgx/encl.c
>> index 24c1bb8eb196..1f88f80c4477 100644
>> --- a/arch/x86/kernel/cpu/sgx/encl.c
>> +++ b/arch/x86/kernel/cpu/sgx/encl.c
>> @@ -344,8 +344,11 @@ static vm_fault_t sgx_encl_eaug_page(struct  
>> vm_area_struct *vma,
>>  	}
>>
>>  	va_page = sgx_encl_grow(encl, false);
>> -	if (IS_ERR(va_page))
>> -		goto err_out_epc;
>> +	if (IS_ERR(va_page)) {
>> +        if (PTR_ERR(va_page) == -EBUSY)
>> +            vmret =  VM_FAULT_NOPAGE;
>> +        goto err_out_epc;
>> +    }
>>
>>  	if (va_page)
>>  		list_add(&va_page->list, &encl->va_pages);
>> --
>> 2.25.1
>>
>
> Indentation is probably not right, but the fix look legit.

Fixed in updated patch. Can I add your "Reviewed-by" tag?
Thanks
Haitao
