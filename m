Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDA5C05027
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Feb 2023 22:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjBQWH4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Feb 2023 17:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBQWHz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 Feb 2023 17:07:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA87F761
        for <linux-sgx@vger.kernel.org>; Fri, 17 Feb 2023 14:07:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA21361CBD
        for <linux-sgx@vger.kernel.org>; Fri, 17 Feb 2023 22:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F33C433D2;
        Fri, 17 Feb 2023 22:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676671673;
        bh=5Is0xUPKE8fmYoXakRS6ZerJxl3YztVA++aq3yu/MCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i8KeC1Q4RUuo0fsR092Bb7VVagiRGCjuaqK8gElBKBZ59si0+WyS7Dd42X53KH8hw
         Ko5Rny/YsRvf/DktPrIzfU8Yq57vlk27EyaQ6uc6YK7+j+cuk5Yl0ISDTX6hKOJNy2
         X8nFDxtVvnLsL0DrSvmXZ1wfJTOeUqwEc6lkmMEIE1GhNITEqaMqP8zdCJL28ZwAiM
         Qml6rVyQzZFUHega7wmrdbcJI2uhOAIWTQjawmC2Wz7M6sa0eaM0SbYPaoZRnXSBff
         EUvlI5/H3fcolOBFaZ9bspUhZiSAJXKgrteItg9MsMm5YHVdhgQBPyrwa4tuN8t2Tr
         HvMfixtWj5O+w==
Date:   Sat, 18 Feb 2023 00:07:48 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Message-ID: <Y+/6tHAcZv17NZUB@kernel.org>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
 <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
 <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 14, 2023 at 08:54:53PM +0000, Huang, Kai wrote:
> On Tue, 2023-02-14 at 13:18 -0600, Haitao Huang wrote:
> > Hi Kai
> > 
> > On Tue, 14 Feb 2023 03:47:24 -0600, Huang, Kai <kai.huang@intel.com> wrote:
> > 
> > > On Fri, 2023-01-27 at 20:55 -0800, Haitao Huang wrote:
> > > > @@ -97,10 +99,81 @@ static int sgx_mmap(struct file *file, struct  
> > > > vm_area_struct *vma)
> > > >  	vma->vm_ops = &sgx_vm_ops;
> > > >  	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
> > > >  	vma->vm_private_data = encl;
> > > > +	vma->vm_pgoff = PFN_DOWN(vma->vm_start - encl->base);
> > > >   	return 0;
> > > >  }
> > > 
> > > Perhaps I am missing something, but above change looks weird.  
> > > Conceptually, it doesn't/shouldn't belong to this series, which  
> > > essentially
> > > preallocates and does EAUG EPC pages for a (or part of) given enclave.   
> > > The EAUG
> > > logic should already be working for the normal fault path, which means  
> > > the code
> > > change above either: 1) has been done at other place; 2) isn't needed.
> > > 
> > > I have kinda forgotten the userspace sequence to create an enclave.  If  
> > > I recall
> > > correctly, you do below to create an enclave:
> > > 
> > > 	1) encl_fd = open("/dev/sgx_enclave");
> > > 	2) encl_addr = mmap(encl_fd, encl_size, 0 /* pgoff */);
> > > 	3) IOCTL(ECREATE, encl_addr, encl_size);
> > > 
> > > Would the above code change break the "mmap()" in above step 2?
> > > 	
> > 
> > No, vm_pgoff was not used previously for enclave VMAs. I had to add this  
> > because the offset passed to sgx_fadvise is relative to file base and  
> > calculated in mm/madvise.c like this:
> > 
> >          offset = (loff_t)(start - vma->vm_start)
> >                          + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
> 
> But shouldn't 'offset is relative to the file base' be conceptually correct from
> the fadvice()'s point of view?
> 
> I think you should do:
> 
> 	encl_offset = offset + encl->base;
> 
> inside sgx_fadvice()?

I agree.

BR, Jarkko
