Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5F6C6FD1C
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Mar 2023 14:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjCNOyf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Mar 2023 10:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjCNOye (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Mar 2023 10:54:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A6A4FF33
        for <linux-sgx@vger.kernel.org>; Tue, 14 Mar 2023 07:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678805672; x=1710341672;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=M9X71Mv/s6swB6Fi/G8O9ABVVKNJl8mBIuWaORT1ans=;
  b=ROplb7ZGwAYc+0gbOU6QFtiYu6qZ7wwAgQvJLpszZDUkwB+TyJZ+k8pi
   ROliTb+xPUzt1BUWlhkGQknNh3ZUmUc9ec1vnOBt4CZf3j2XN2+yNs4Kk
   xkPccdBBvUxekFxu1O/WGc/xSv9r+O3voPHKV3XIqvOhl64ZcqzHrdfAA
   AIemFF54UTGIvpJ7W3U5BEMvJ2NIgNudhwxJ6NgrLJoNzQfU6U1j5IJp/
   S22tTT1zRC+h+lAv4Vmrgq+iBJX8E4MC0SbF4TCSrxBraDgygEY9VhIdK
   coNglh0USihCGN7CubiBzKzpxvhLY5McXTyQbSb4dNZY6J4yHWR6mcbsY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317094069"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317094069"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 07:54:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008447071"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="1008447071"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.212.75.222])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 14 Mar 2023 07:54:31 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
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
 <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
 <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
Date:   Tue, 14 Mar 2023 09:54:30 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.11sw04rxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 09 Mar 2023 05:31:29 -0600, Huang, Kai <kai.huang@intel.com> wrote:
>>
>> Then in v29, PROT_NONE mapping was disallowed for encl_fd before pages
>> EADDed so user space has to mmap anonymously to reserve the range.The
>> intent was still not to allow mmap before pages EADDed (the !page check
>> was still there up to v38)
>
> Do you know the reason of disallowing PROT_NONE mapping against encl_fd?
>

I think it was to allow user space to do anonymous mapping to reserve  
address space for enclave.
Before this point, you have to use PROT_NONE to reserve with encl_fd.  
There might be an issue with how #PF and EPC swapping was handled or the  
elegance of those flows that motivated the move but I can't remember. ABI  
was not fixed at that time so it was OK to change.

> I dig v28 roughly but didn't find any clue.
>
> Basically no comments related to this were made to:
>
> 	[PATCH v28 11/22] x86/sgx: Linux Enclave Driver
>
>>
>> Later version (around v39?) we switched to enforce the permissions in PF
>> handler and mmap with any permissions before EADD is allowed, but may
>> cause failure later on PF. I'm not sure it was intentional but pretty  
>> sure
>> no meaningful usage for doing mmap before ECREATE due to PF handler
>> enforcement.
>
> IIUC this change around v39 re-allows mmap() against encl_fd before  
> ECREATE?
>

I don't think so. There is no meaningful usage for that as I said.

> IIUC the only enforcement is VMA's permission must be more restricted  
> than
> enclave page's permission.
>
> So, theoretically, we can mmap() encl_fd with  
> PROT_READ|PROT_WRITE|PROT_EXEC,
> and then mprotect() the address range based on the actual enclave pages  
> (in
> EADD) before actually doing EADD those pages?
>
>>
>> I think that's the history behind it. Others more knowledgeable can
>> correct me as needed.
>
> Thanks for the information.
>
>>
>> Again, even if we redesign the whole thing to be less "weird", then
>> requiring pgoff for each mmap would break existing user space code. And  
>> I
>> think explicitly block mmap before ECREATE make the API more consistent
>> with the PF handler enforcement and original intent of sgx_encl_may_map.
>
> I think permission check in sgx_encl_may_map() isn't restricted related  
> to the
> vma->pgoff issue here.  They are basically two different topics, IIUC.
>

They are related because the intention was not allowing user space to do  
arbitrary mmaping before EADD.
So in the context of the gap you identified for this patch series, i.e,  
mmap before ECREATE, it is relevant. My view is that we never intended and  
there is no use case for allowing that to happen. So it naturally follows  
that we fix that gap by not allowing those scenarios explicitly.

> So I am still a little bit confused about where does "SGX driver uses
> MAP_ANONYMOUS semantics for fd-based mmap()" come from.
>
> Anyway, we certainly don't want to break userspace.  However, IIUC, even  
> from
> now on we change the driver to depend on userspace to pass the correct  
> pgoff in
> mmap(), this won't break userspace, because old userspace which doesn't  
> use
> fadvice() and pgoff actually doesn't matter.  For new userspace which  
> uses
> fadvice(), it needs to pass the correct pgoff.
>
> I am not saying we should do this, but it doesn't seem we can break  
> userspace?
>

I'll leave it for others to chime in on this.
With my user space developer hat on, I would not like this because in one  
place (mmap before madvise call) I have to pass pgoff and not in another  
place (mmap after EADD). If you see really big issues on the current  
MAP_ANONYMOUS + enclave_fd semantics, then we should fix the design. But  
it should be in separate patches.

Thanks
Haitao
