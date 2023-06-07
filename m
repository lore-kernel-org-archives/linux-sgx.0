Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80151C77B7A
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Jun 2023 17:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjFGRBE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjFGRBD (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 7 Jun 2023 13:01:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7FFBA
        for <linux-sgx@vger.kernel.org>; Wed,  7 Jun 2023 10:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686157262; x=1717693262;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=M18uvCFQBTCKjqRQKgDkedyYXzz+hbjXt7lcmiWBWtg=;
  b=Klh+xnpQqDI8Yzl3QaZAGIEZDIWH8l9knblLSgg/7mENvQyxwTTF46QK
   s6sCN4UZeXaskKjb1atUge710k7guqRBirar42m1Lko1/Dn0427dAXh2z
   S6VQ8YFGc2OL8fa+ZnbWqlgow9gvqgPqUDDPFC+g/ejItFeFEsatPwtra
   aGF1KZ1vRVGPOw9D/HN67nh5f0+siYKx9TqjqBrfM8onfIGkzfQFVdnX4
   koYBgmDWsKRn2xgry8MXMhqW3XB/phfhex8iTCsTkxAaxnM0DRIysOChz
   41SRPQc6GYgUlhwIg/VbLSk3/wrSbwECSdCEQrWrxdlBrH743VotXYaYv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="336676597"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="336676597"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 09:59:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="799472344"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="799472344"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.88.61])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 07 Jun 2023 09:59:36 -0700
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
 <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
Date:   Wed, 07 Jun 2023 11:59:32 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.156hhiivwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 05 Jun 2023 23:11:59 -0500, Huang, Kai <kai.huang@intel.com> wrote:

> On Fri, 2023-05-26 at 19:32 -0500, Haitao Huang wrote:
>> Hi Kai, Jarkko and Dave
>>
>> On Thu, 09 Mar 2023 05:31:29 -0600, Huang, Kai <kai.huang@intel.com>  
>> wrote:
>> >
>> > So I am still a little bit confused about where does "SGX driver uses
>> > MAP_ANONYMOUS semantics for fd-based mmap()" come from.
>> >
>> > Anyway, we certainly don't want to break userspace.  However, IIUC,  
>> even
>> > from
>> > now on we change the driver to depend on userspace to pass the correct
>> > pgoff in
>> > mmap(), this won't break userspace, because old userspace which  
>> doesn't
>> > use
>> > fadvice() and pgoff actually doesn't matter.  For new userspace which
>> > uses
>> > fadvice(), it needs to pass the correct pgoff.
>> >
>> > I am not saying we should do this, but it doesn't seem we can break
>> > userspace?
>> >
>>
>> Sorry for delayed update but I thought about this more and likely to
>> propose a new EAUG ioctl for this and for enabling SGX-CET shadow stack
>> pages. But regardless, I'd like to wrap up this discussion to just  
>> clarify
>> this anonymous semantics design in documentation so people won't get
>> confused in future.
>>
>> I think we all agree to keep this semantics so no user space would need
>> specify 'offset' for mmap with enclave fd. And here is my proposed
>> documentation changes.
>>
>> --- a/Documentation/x86/sgx.rst
>> +++ b/Documentation/x86/sgx.rst
>> @@ -100,6 +100,23 @@ pages and establish enclave page permissions.
>>                  sgx_ioc_enclave_init
>>                  sgx_ioc_enclave_provision
>>
>> +Enclave memory mapping
>> +----------------------
>> +
>> +A file descriptor created from opening **/dev/sgx_enclave** represents  
>> an
>> +enclave object. The mmap() syscall with enclave file descriptors does  
>> not
>> +support non-zero value for the 'offset' parameter.
>
> I think we all need to understand better why SGX driver requires  
> anonymous
> semantics mmap() against /dev/sgx_enclave, and as a result of that,  
> requires
> mmap() to pass  0 as pgoff (which looks wasn't even discussed when  
> upstreaming
> the driver).
>
> I'll do some investigation and try to summerize and report back.  Thanks.
>
> [...]
>
>> This is
>> +unlike regular file mapping in that no content offset can be defined  
>> that
>> is
>> +independent from the virtual address it is loaded to.
>> +
>>
>
> Don't quite understand this.  The virtual address of a regular file  
> mapping can
> be linked to file's offest from VMA's pgoff.
>

For file mapping, the offset is the 'content offset' relative to the  
beginning of the file content. The file 'content' is independent from the  
memory it is mapped to.

mmap(..., encl_fd, ...) just creates VMAs as windows/views into the  
enclave memory whose range is already defined by [encl->base,  
encl->base+encl->size) when ECREATE is done. The 'content' of enclave and  
the memory to which the 'content' is mapped are the same. Hence, no  
independent  'content offset' can be defined from user point of view.

 From implementation point of view:

In regular file mapping, vma->vm_pgoff has nothing to do with  
vma->vm_start (or 'addr' passed by mmap). It is used to load bytes at  
pg_offset in the 'content' referenced by vma->vm_file, which is backed up  
by a real file or object that contains the bytes.

In enclave mapping, vma->vm_file is the '/dev/sgx_enclave' device node,  
and it does not refer to any content. It does not make sense to have  
'offset' into '/dev/sgx_enclave'. vma->pg_offset is meaningless for  
enclave mapping.

Thanks
Haitao
