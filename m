Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE41C61DA3
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Feb 2023 01:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjBVBhX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 21 Feb 2023 20:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBVBhX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 21 Feb 2023 20:37:23 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4211305E6
        for <linux-sgx@vger.kernel.org>; Tue, 21 Feb 2023 17:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677029841; x=1708565841;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=aWqSsZKKZm8Z7VO5W4CdqlUOsBHelZvBxLdJdtME0rQ=;
  b=Nfv2xSe74O6jP4373dIHxB8LDRdJZRAel2Gp9f7fDaPZd/aAJ11WRgdF
   GCKLhD8kGM5g71nZpJAppBA8lrRCsZhI7MPiJbF91twIYwBw+NWBDpSx+
   7xz4cWE5pRJ6cvTzzlxa/E8o7UhijJUkm3HH81hYxEbYiur5yKl8hLru7
   4GOTofXAPGRLZ3i0wXeK+cHlS3HlRWT59XKGc9BZVSFj6mPYLruvlKnFM
   SNnx7TorNQ8lt+L1RHbQuPCpDdr6Afubrqe74Xusaiuy22MGot1BPX3ZF
   a/rn0d53fmhwoPFluTo7nRrs6rIYBlIlZFXRiYKNszlWN0lHktUM8RgEk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="335002830"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="335002830"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 17:37:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="735684174"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="735684174"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.212.22.123])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 21 Feb 2023 17:37:20 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "jarkko@kernel.org" <jarkko@kernel.org>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
References: <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
 <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
 <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
 <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
 <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/AAbC/j04aUkd8R@kernel.org>
 <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/VBOkmi7VbVuzAh@kernel.org>
Date:   Tue, 21 Feb 2023 19:37:18 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <Y/VBOkmi7VbVuzAh@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 21 Feb 2023 16:10:02 -0600, jarkko@kernel.org <jarkko@kernel.org>  
wrote:

> On Fri, Feb 17, 2023 at 05:03:05PM -0600, Haitao Huang wrote:
>> Hi Jarkko
>>
>> On Fri, 17 Feb 2023 16:32:12 -0600, jarkko@kernel.org  
>> <jarkko@kernel.org>
>> wrote:
>>
>> > On Wed, Feb 15, 2023 at 09:42:30AM -0600, Haitao Huang wrote:
>> > > On Wed, 15 Feb 2023 02:51:23 -0600, Huang, Kai <kai.huang@intel.com>
>> > > wrote:
>> > >
>> > > > > > > >
>> > > > > >
>> > > > > > Since sgx_mmap() can happen before enclave is created,
>> > > calculating the
>> > > > > > vm_pgoff
>> > > > > > from enclave_base is conceptually wrong.  Even if you really  
>> want
>> > > > > to do
>> > > > > > it, it
>> > > > > > should be:
>> > > > > >
>> > > > > > 	if (enclave_has_initialized())
>> > > > > > 		vma->vm_pgoff = ...;
>> > > > >
>> > > > > I got your point now. I can add a condition to test the
>> > > SGX_ENCL_CREATED
>> > > > > bit. However, we still have a hole if we must handle the  
>> sequence
>> > > > > mmap(..., enclave_fd) being called before ECREATE ioctl. We
>> > > can't leave
>> > > > > vm_pgoff not set for those cases.
>> > > > >
>> > > > > Since no one does that so far, can we explicitly return an error
>> > > from
>> > > > > sgx_mmap when that happens?
>> > > > > Other suggestions?
>> > > >
>> > > > As I replied to patch 4/4, I believe userspace should pass the  
>> correct
>> > > > pgoff in
>> > > > mmap().  It's wrong to always pass 0 or any random value.
>> > > >
>> > > > If userspace follow the mmap() rule, you won't need to manually  
>> set
>> > > > vm_pgoff
>> > > > here (which is hacky IMHO).  Everything works fine.
>> > > >
>> > >
>> > > SGX driver was following MAP_ANONYMOUS semantics. If we change that,
>> > > it'd
>> > > break current usage/ABI.
>> > >
>> > > I still think returning error for cases mmap(..., enclave_fd) if
>> > > enclave is
>> > > not created would be less intrusive change.
>> >
>> > Is this something you care in SGX SDK?
>> >
>> > It is not categorically forbidden so that's why I'm asking.
>>
>> SDK does not care as we would never do this and don't think anyone is  
>> doing
>> that either. Suggesting returning error to cover all cases so user space
>> would not accidentally cause incorrect vm_pgoff set.
>
> vm_pgoff != 0 should result -EINVAL.
>

Do you mean 'offset' passed in from mmap syscall and converted to pgoff in  
kernel? I can see it only passed to driver in get_unmapped_area. I can add  
this enforcement there so it is consistent to the MAP_ANONYMOUS spec if  
that's what you suggest.

  vma->vm_pgoff is the offset in pages of the vma->vm_start relative to  
'file'.
  It can not be zero for all VMAs of the enclave.

Kernel sets vma->vm_pgoff == vma->vm_start>>PAGE_SHIFT for private anon  
VMAs, and ignore it (zero) for shared anon mapping.

For us, we propose to set it to PFN_DOWN(vma->vm_start - encl->base) upon  
mmap.
The concern Kai raised about encl->base not available in the window  
between mmap and ECREATE can be addressed by disallowing mmap before  
ECREATE is done. It does not make much sense anyway to mmap(enclave_fd)  
without a valid enclave range associated with enclave_fd.

Does that sound reasonable or I still miss some point here?

Thanks
Haitao
