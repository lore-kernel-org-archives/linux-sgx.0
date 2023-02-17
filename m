Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC53AC636D6
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Feb 2023 21:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBQVuM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Feb 2023 16:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjBQVuL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 Feb 2023 16:50:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A076532503
        for <linux-sgx@vger.kernel.org>; Fri, 17 Feb 2023 13:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 485CDB82E1F
        for <linux-sgx@vger.kernel.org>; Fri, 17 Feb 2023 21:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B689C433EF;
        Fri, 17 Feb 2023 21:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676670607;
        bh=wuJi+ivNkASDofAY/So1F1u28d+u1nUz1PFvTnWB2t8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I1BEPeLlDum4lI1ItiYMblzArbTNQZJrykrHML+HEaRp88LcMNX13LN10gmRvELQH
         OSjh7xvVSSF1R9YlmMON19/4xPIMMc4sl+8gTl4APUv5bo5IRQX/tpiQUnzx6Qsp9i
         ZM46+rR0SRH+yB0+8uETYP4+q+HsgZBJEqu5l1Q4M+lRGrp0L48beuH/wuF27d0FNB
         DEZHyy93CR289LMInyzuPyhsC2dufs+EqntpR16+4aVFZSUvysGR9TDV18kuCQCpzq
         FYrI9Ij/ykfnqQsv9W608RLIfYCBzROUGRuGSLIzvrOfXLM2yc6HYENQnWuZyiKzpY
         nmnc33d7wossA==
Date:   Fri, 17 Feb 2023 23:50:02 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Message-ID: <Y+/2ik/r7on7dkGf@kernel.org>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
 <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 14, 2023 at 09:47:24AM +0000, Huang, Kai wrote:
> On Fri, 2023-01-27 at 20:55 -0800, Haitao Huang wrote:
> > @@ -97,10 +99,81 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
> >  	vma->vm_ops = &sgx_vm_ops;
> >  	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
> >  	vma->vm_private_data = encl;
> > +	vma->vm_pgoff = PFN_DOWN(vma->vm_start - encl->base);
> >  
> >  	return 0;
> >  }
> 
> Perhaps I am missing something, but above change looks weird.  
> 
> Conceptually, it doesn't/shouldn't belong to this series, which essentially
> preallocates and does EAUG EPC pages for a (or part of) given enclave.  The EAUG
> logic should already be working for the normal fault path, which means the code
> change above either: 1) has been done at other place; 2) isn't needed.
> 
> I have kinda forgotten the userspace sequence to create an enclave.  If I recall
> correctly, you do below to create an enclave:
> 
> 	1) encl_fd = open("/dev/sgx_enclave");
> 	2) encl_addr = mmap(encl_fd, encl_size, 0 /* pgoff */);
> 	3) IOCTL(ECREATE, encl_addr, encl_size);
> 
> Would the above code change break the "mmap()" in above step 2?

Good catch! Actually shouldn't be validate it to be always zero? We
are essentially MAP_ANONYMOUS mapping semantics with a device file.

BR, Jarkko
