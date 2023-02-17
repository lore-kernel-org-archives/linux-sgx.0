Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E044C636D6
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Feb 2023 23:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjBQXDJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Feb 2023 18:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjBQXDJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 Feb 2023 18:03:09 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664C62DE61
        for <linux-sgx@vger.kernel.org>; Fri, 17 Feb 2023 15:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676674988; x=1708210988;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=hoPGyOHfEs422PXtzl2bVn9S/wtAfmat0UMwtYbYa9w=;
  b=EWgj3Xk6PrvJNTnpFe2IOrO3dpu/uqMq8txPvT8N2xzj2ZallGx9J4RM
   q+Ufakh8xR1dHZgvUH88t5L2Ml/MlDczN7T/Jr5x1QwU8fVVY/BAebGBi
   9wBrNj9/oN85hxBw/Q63NiFw3z4F/CgfDpPItdZ5efMVwKZ18rvsbVAs3
   ydAWJdPvZO76VXM4egzHpYPEWini/NhvufoKsF9ktDS4PqafBvI2+jS9h
   1Fi6k7orRZ0uIQeN+hI8H559R3hHfqB0wNTByTSL5JF0AVd7nptjBrMLc
   InGpSkJrGYR+XRKKGzbYzHDCYGsH5SIm+XFO7oe6288sS7zqTi9vcKl2o
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="394591983"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="394591983"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 15:03:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="734467478"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="734467478"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.209.190.112])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 17 Feb 2023 15:03:06 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "jarkko@kernel.org" <jarkko@kernel.org>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
References: <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
 <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
 <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
 <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
 <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
 <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/AAbC/j04aUkd8R@kernel.org>
Date:   Fri, 17 Feb 2023 17:03:05 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <Y/AAbC/j04aUkd8R@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko

On Fri, 17 Feb 2023 16:32:12 -0600, jarkko@kernel.org <jarkko@kernel.org>  
wrote:

> On Wed, Feb 15, 2023 at 09:42:30AM -0600, Haitao Huang wrote:
>> On Wed, 15 Feb 2023 02:51:23 -0600, Huang, Kai <kai.huang@intel.com>  
>> wrote:
>>
>> > > > > >
>> > > >
>> > > > Since sgx_mmap() can happen before enclave is created,  
>> calculating the
>> > > > vm_pgoff
>> > > > from enclave_base is conceptually wrong.  Even if you really want
>> > > to do
>> > > > it, it
>> > > > should be:
>> > > >
>> > > > 	if (enclave_has_initialized())
>> > > > 		vma->vm_pgoff = ...;
>> > >
>> > > I got your point now. I can add a condition to test the  
>> SGX_ENCL_CREATED
>> > > bit. However, we still have a hole if we must handle the sequence
>> > > mmap(..., enclave_fd) being called before ECREATE ioctl. We can't  
>> leave
>> > > vm_pgoff not set for those cases.
>> > >
>> > > Since no one does that so far, can we explicitly return an error  
>> from
>> > > sgx_mmap when that happens?
>> > > Other suggestions?
>> >
>> > As I replied to patch 4/4, I believe userspace should pass the correct
>> > pgoff in
>> > mmap().  It's wrong to always pass 0 or any random value.
>> >
>> > If userspace follow the mmap() rule, you won't need to manually set
>> > vm_pgoff
>> > here (which is hacky IMHO).  Everything works fine.
>> >
>>
>> SGX driver was following MAP_ANONYMOUS semantics. If we change that,  
>> it'd
>> break current usage/ABI.
>>
>> I still think returning error for cases mmap(..., enclave_fd) if  
>> enclave is
>> not created would be less intrusive change.
>
> Is this something you care in SGX SDK?
>
> It is not categorically forbidden so that's why I'm asking.

SDK does not care as we would never do this and don't think anyone is  
doing that either. Suggesting returning error to cover all cases so user  
space would not accidentally cause incorrect vm_pgoff set.
Thanks
Haitao
