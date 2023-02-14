Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB5CC05027
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Feb 2023 19:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBNTS7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Feb 2023 14:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjBNTS6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Feb 2023 14:18:58 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B84729173
        for <linux-sgx@vger.kernel.org>; Tue, 14 Feb 2023 11:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676402336; x=1707938336;
  h=to:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=RANMYisWQ92Int9Xzl/DZr3fz2lRl8MgI1p1NSCytUA=;
  b=RST0B1prJIYiHaU/Hok2EAOTscZQ3UzfiXDUwbUrtLTFNGhUP0e01+dD
   0t6qSB4TLgfUr9fc8lCRm6E4TTF7C70MefGXZVOo2LXwEjwq7LIdgw53E
   8PXbrKU7TbXC+lt51N6+peIyqJ7+6KSGyt3U2vDYi1kkF4SHGDMOjT/kC
   SqsPlCjL+humS1CQiakq+WKeKZiFmJcttXfJSXVOdC2Czmp1ilSJkxiKZ
   kIzE/CgOSF4enYwfz92kPEJDRaLz2mXsHeHWeRQZ3gpYk9Hiv4Gj3tgMT
   hEZj7eAeFxStxA//vZJtOChXRHJc5qIIW8O2LQIZtf7KHlg/d1Ava9f4S
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="332555418"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="332555418"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 11:18:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699645198"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="699645198"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.212.92.110])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 14 Feb 2023 11:18:54 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
 <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
Date:   Tue, 14 Feb 2023 13:18:53 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Kai

On Tue, 14 Feb 2023 03:47:24 -0600, Huang, Kai <kai.huang@intel.com> wrote:

> On Fri, 2023-01-27 at 20:55 -0800, Haitao Huang wrote:
>> @@ -97,10 +99,81 @@ static int sgx_mmap(struct file *file, struct  
>> vm_area_struct *vma)
>>  	vma->vm_ops = &sgx_vm_ops;
>>  	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
>>  	vma->vm_private_data = encl;
>> +	vma->vm_pgoff = PFN_DOWN(vma->vm_start - encl->base);
>>   	return 0;
>>  }
>
> Perhaps I am missing something, but above change looks weird.  
> Conceptually, it doesn't/shouldn't belong to this series, which  
> essentially
> preallocates and does EAUG EPC pages for a (or part of) given enclave.   
> The EAUG
> logic should already be working for the normal fault path, which means  
> the code
> change above either: 1) has been done at other place; 2) isn't needed.
>
> I have kinda forgotten the userspace sequence to create an enclave.  If  
> I recall
> correctly, you do below to create an enclave:
>
> 	1) encl_fd = open("/dev/sgx_enclave");
> 	2) encl_addr = mmap(encl_fd, encl_size, 0 /* pgoff */);
> 	3) IOCTL(ECREATE, encl_addr, encl_size);
>
> Would the above code change break the "mmap()" in above step 2?
> 	

No, vm_pgoff was not used previously for enclave VMAs. I had to add this  
because the offset passed to sgx_fadvise is relative to file base and  
calculated in mm/madvise.c like this:

         offset = (loff_t)(start - vma->vm_start)
                         + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);

I had a comment in first version but removed it based on Jarkko's  
suggestion here: https://lore.kernel.org/all/Y2B0jBsG6HE4KVk7@kernel.org/

The original comments probably seemed redundant to the definitions of the  
vm_pgoff field and the fadvise interface. But let me know if we need add a  
more helpful version of comments or any suggestion on the comments.

Thanks
Haitao
