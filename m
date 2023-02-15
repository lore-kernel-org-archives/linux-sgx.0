Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61ADAC636CC
	for <linux-sgx@archiver.kernel.org>; Wed, 15 Feb 2023 03:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBOD7L (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Feb 2023 22:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBOD7L (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Feb 2023 22:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA032B2B2
        for <linux-sgx@vger.kernel.org>; Tue, 14 Feb 2023 19:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676433550; x=1707969550;
  h=to:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=LtghehPHYRIgvWgUqFgoyaDCMfVI77npwQ0jvXgatp0=;
  b=mWFlCTKULGzeBinhC9QX+iQEDWdKoP17bNAJnwnEU4YL7P0lEYX2Udo0
   g/g28F0s9pjUev9rXM5+0LAXcc51HCdma6yuK8w37JcW80QCY/gHo2hVq
   P0ILBYAQQJF71tLfTOwvNV/ZM7QmBOnTJXaPVFX+k+EzM3r/azNiUJZ32
   fKB4ZRXO+EFlSoF3/BoWsTkAWDnbZrPEQQjyKzACrrgwSaPrTHpbI2cEj
   A4i95iM/yPvTI9WItn2TNOJ8v49mfDVS43OanmPxHPYZWqasGfi1s1zK2
   v4nVQiEqexck/UkESJFJ82USO1sbIbuzxgMgqUyl+c1fwfTSyQ+CpwOgP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="332648975"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="332648975"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 19:59:09 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="619280983"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="619280983"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.212.233.201])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 14 Feb 2023 19:59:08 -0800
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
 <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
 <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
Date:   Tue, 14 Feb 2023 21:59:07 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 14 Feb 2023 16:36:40 -0600, Huang, Kai <kai.huang@intel.com> wrote:

> On Tue, 2023-02-14 at 15:42 -0600, Haitao Huang wrote:
>> On Tue, 14 Feb 2023 14:54:53 -0600, Huang, Kai <kai.huang@intel.com>  
>> wrote:
>>
>> > On Tue, 2023-02-14 at 13:18 -0600, Haitao Huang wrote:
>> > > Hi Kai
>> > >
>> > > On Tue, 14 Feb 2023 03:47:24 -0600, Huang, Kai <kai.huang@intel.com>
>> > > wrote:
>> > >
>> > > > On Fri, 2023-01-27 at 20:55 -0800, Haitao Huang wrote:
>> > > > > @@ -97,10 +99,81 @@ static int sgx_mmap(struct file *file,  
>> struct
>> > > > > vm_area_struct *vma)
>> > > > >  	vma->vm_ops = &sgx_vm_ops;
>> > > > >  	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP |  
>> VM_IO;
>> > > > >  	vma->vm_private_data = encl;
>> > > > > +	vma->vm_pgoff = PFN_DOWN(vma->vm_start - encl->base);
>> > > > >   	return 0;
>> > > > >  }
>> > > >
>> > > > Perhaps I am missing something, but above change looks weird.
>> > > > Conceptually, it doesn't/shouldn't belong to this series, which
>> > > > essentially
>> > > > preallocates and does EAUG EPC pages for a (or part of) given  
>> enclave.
>> > > > The EAUG
>> > > > logic should already be working for the normal fault path, which  
>> means
>> > > > the code
>> > > > change above either: 1) has been done at other place; 2) isn't  
>> needed.
>> > > >
>> > > > I have kinda forgotten the userspace sequence to create an  
>> enclave.
>> > > If
>> > > > I recall
>> > > > correctly, you do below to create an enclave:
>> > > >
>> > > > 	1) encl_fd = open("/dev/sgx_enclave");
>> > > > 	2) encl_addr = mmap(encl_fd, encl_size, 0 /* pgoff */);
>> > > > 	3) IOCTL(ECREATE, encl_addr, encl_size);
>> > > >
>> > > > Would the above code change break the "mmap()" in above step 2?
>> > > > 	
>> > >
>> > > No, vm_pgoff was not used previously for enclave VMAs. I had to add  
>> this
>> > > because the offset passed to sgx_fadvise is relative to file base  
>> and
>> > > calculated in mm/madvise.c like this:
>> > >
>> > >          offset = (loff_t)(start - vma->vm_start)
>> > >                          + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
>> >
>> > But shouldn't 'offset is relative to the file base' be conceptually
>> > correct from
>> > the fadvice()'s point of view?
>> >
>> > I think you should do:
>> >
>> > 	encl_offset = offset + encl->base;
>> >
>> > inside sgx_fadvice()?
>> >
>> > >
>> If we don't set vma->vm_pgoff (default to zero), then offset will be
>> calculated as (start - vma->vm_start). Then the above calculation is  
>> wrong
>> if we have multiple VMAs for the same enclave, which is usually the  
>> case.
>
> do_mmap() -> mmap_region() itself sets vma->vm_pgoff:
>
> 	vma = vm_area_alloc();
> 	...
> 	vma->vm_pgoff = pgoff;
>
> 	if (file)
> 		call_mmap(file, vma);	<- sgx_mmap()
>
> I think you will always call mmap() against enclave's fd with 'pgoff'  
> being set
> to the offset relative to the file?
>

right. (pgoff above is most likely zero in enclave cases but that's not  
important)

>>
>> > > I had a comment in first version but removed it based on Jarkko's
>> > > suggestion here:
>> > > https://lore.kernel.org/all/Y2B0jBsG6HE4KVk7@kernel.org/
>> > >
>> > > The original comments probably seemed redundant to the definitions  
>> of
>> > > the
>> > > vm_pgoff field and the fadvise interface. But let me know if we need
>> > > add a
>> > > more helpful version of comments or any suggestion on the comments.
>> >
>> > I still think this code change is wrong.
>> >
>> > For instance, IIUC, it at least breaks the case where enclave hasn't  
>> been
>> > created/initialized, where encl->base == 0 (although normal code path
>> > doesn't
>> > use vm_pgoff, conceptually it's still wrong IIUC).
>> >
>> > Maybe I am missing something?
>>
>> The fadvise interface is only usable for an initialized enclave,
>> sgx_fadvise will return error otherwise.
>
> True.  But that code change is unconditionally called for all mmap(),  
> even when
> enclave hasn't been created.
>
Theoretically yes. However, the user space sequences I am aware are  
following:

1. enclave_fd = fopen("/dev/sgx_enclave")
2. mmap(..., 2*enclave_size, MAP_ANONYMOUS, ...) to reserve a larger  
range, then trim the reserved address range to get enclave_base aligned  
with enclave_size
3. ioctl(ECREATE, enclave_base, enclave_size, enclave_fd)

Only after ECREATE, we do mmap(..., enclave_fd) calls.

>> Conceptually I view enclave base
>> as "file base", it's just that we don't ever need handle the zero case
>> caused by uninitialized enclave (kind of like a file never mapped). If  
>> an
>> initialized enclave happens to have zero base, it would also work.
>
> A little bit confused about what does "enclave base" here.
>
> To me, A file is an enclave, meaning the "file offset" equals to "enclave
> offset".  "enclave base" is the base linear address of the enclave, it  
> doesn't
> matter whether it is 0 or not.  You get an "enclave address" from  
> "enclave base"
> plus "enclave offset" (or "file offset"):
>
> 	enclave_addr = enclave_base + enclave_offset/file_offset;
>
Yes this is in sgx_fadvise:
	start = offset + encl->base

The issue is that the file_offset is calculated in madvise.c before  
calling sgx_fadvise like this:
         offset = (loff_t)(start - vma->vm_start)
                         + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
         ...
         vfs_fadvise(file, offset, end - start, POSIX_FADV_WILLNEED);

So vma->vm_pgoff is expected being set correctly relative to file.

> And such calculation is only valid after enclave has been created  
> (enclave_base
> is valid -- can be 0 or whatever).
>
> Since sgx_mmap() can happen before enclave is created, calculating the  
> vm_pgoff
> from enclave_base is conceptually wrong.  Even if you really want to do  
> it, it
> should be:
>
> 	if (enclave_has_initialized())
> 		vma->vm_pgoff = ...;

I got your point now. I can add a condition to test the SGX_ENCL_CREATED  
bit. However, we still have a hole if we must handle the sequence  
mmap(..., enclave_fd) being called before ECREATE ioctl. We can't leave  
vm_pgoff not set for those cases.

Since no one does that so far, can we explicitly return an error from  
sgx_mmap when that happens?
Other suggestions?

>But again I am not convinced why you cannot get the enclave_addr inside
> sgx_fadvice().
>

I hope the above comments addressed this. Basically we need set vm_pgoff  
relative to file for sgx_fadvise callback to receive meaningful `offset`  
relative to file.

Thanks
Haitao
