Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F054C636CC
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Feb 2023 17:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjBPRUp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Feb 2023 12:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBPRUp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 16 Feb 2023 12:20:45 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54064C3F6
        for <linux-sgx@vger.kernel.org>; Thu, 16 Feb 2023 09:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676568039; x=1708104039;
  h=to:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=qs28cMWUajFe81i91VT3R3Q/eTPAP4Thg9+sZoDXhT8=;
  b=J26tJ/6VlJPCzlmx9SXZJ1HXPW13o0gt8X05C4F1QebQRKp51Lgp0N8w
   Df9APOaWreDZAkOf/+XgOOBT2EkwnTaAktZj+u/EN9F4QyxN4SMAEKkl8
   AAexaFTFNS6iFkto2I0kq4+VvMFn75YanP3PKQx0uaFkMl0AtuOhGmfXW
   Hr1X8uHq+0tiuNZH+ENwoy3zcioQEr7/AUBCcyWnoLxxvIlpAz0uU8vtX
   ZZQSg6kvPQAZRPYSKTECGpy6PvjbAd/0S0h1IPwdo0j5ELdibNTZJP4Lq
   kc51wZBBT4C2yWnJkIZsLjPz21cvKy+m/yelboUbjY8/c4olt4etzeWg/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="312139363"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="312139363"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 09:12:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="779433771"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="779433771"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.209.147.51])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 16 Feb 2023 09:12:47 -0800
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
 <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
 <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <68d19c7bb8e28e85d503da53124fc57b916dcaf9.camel@intel.com>
Date:   Thu, 16 Feb 2023 11:12:46 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.10gx3kk9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <68d19c7bb8e28e85d503da53124fc57b916dcaf9.camel@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Kai

On Thu, 16 Feb 2023 01:53:47 -0600, Huang, Kai <kai.huang@intel.com> wrote:

> On Wed, 2023-02-15 at 09:42 -0600, Haitao Huang wrote:
>> On Wed, 15 Feb 2023 02:51:23 -0600, Huang, Kai <kai.huang@intel.com>  
>> wrote:
>>
>> > > > > >
>> > > >
>> > > > Since sgx_mmap() can happen before enclave is created,  
>> calculating the
>> > > > vm_pgoff
>> > > > from enclave_base is conceptually wrong.  Even if you really want  
>> to
>> > > do
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
>
> Is there any doc/reference mentioning this?
>
No, just from how we use it :-). Jarkko/Sean/Dave may have  
history/insights on this?
But file offset in mmap spec implies there is a "real" file independent of  
the memory it is mapped into, and you can mmap arbitrary offset of that  
file to any memory address. That does not fit well with SGX enclave  
memory: there is no separate physical file other than enclave residing in  
memory and its base is fixed.
Again, my main concern is impact to existing usage.

>>
>> I still think returning error for cases mmap(..., enclave_fd) if enclave
>> is not created would be less intrusive change.
>
> But you need the first mmap() to work before IOCTL(ecreate) to get  
> enclave's
> base address, correct?
>

No, mmap(..., MAP_ANONYMOUS, fd=-1) must be used to reserve address range  
for enclave before calling IOCTL(ecreate). In fact, I realize mmap(...,  
fd=enclave_fd) before ioctl(ecreate) should fail in sgx_encl_may_map  
according to its definition but IIUC it would skip the loop xas_for_each  
when no entries yet available in encl->page_array. This might be a hole to  
enforcement of vma_prot_bits not exceeding the vm_max_prot_bits which is  
recorded first during EADD.
So if my understanding is correct, we just need fix sgx_encl_may_map to  
return -EACCES when mmap is called before ecreate is done.

Thanks
Haitao
