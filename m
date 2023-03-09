Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A68C64EC4
	for <linux-sgx@archiver.kernel.org>; Thu,  9 Mar 2023 00:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCIAue (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Mar 2023 19:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjCIAuK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Mar 2023 19:50:10 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E88A85A7E
        for <linux-sgx@vger.kernel.org>; Wed,  8 Mar 2023 16:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678323008; x=1709859008;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=KX3uJPxB4oZ6zaH7VPjqcxh9/sPpR7pj4JVkrjewYQM=;
  b=FdSogLOJXzpjMHzluLjV0+7Xl/c5b75GoXo2lsmYedlDfpomJlkfk1Xs
   9rX5KEcFjw4TUdEBXMkgyt1Ea+yr5qywtBhTpanpYSrgkCT+mWOCQp6df
   fzAegZ/k8PZi9+WWGx4WMmEjlCn4h3ALoq5mAdcct2OFZTEzsYjA5c3Jn
   ePDrq5eJkCs9olcao7YEmdM8defr0HoesM9i8mLe8QRZTQ1O4CSbbDz3U
   acF3dmi3XB+q+TelKW0RSenkJz+4h3zNqg16GOg1GVH0W/re+LhgeJBlc
   eZ54sVuxVsvC+wKJCQJiXVbEYYLz2fkwcYKKq0mV6Fer0gILMoryKLkLL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="422590184"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="422590184"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 16:50:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="746118831"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="746118831"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.209.168.61])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 08 Mar 2023 16:50:07 -0800
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
Date:   Wed, 08 Mar 2023 18:50:06 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Kai

Thanks for your detailed review.

On Tue, 07 Mar 2023 17:32:15 -0600, Huang, Kai <kai.huang@intel.com> wrote:

> On Tue, 2023-02-21 at 19:37 -0600, Haitao Huang wrote:
>> On Tue, 21 Feb 2023 16:10:02 -0600, jarkko@kernel.org  
>> <jarkko@kernel.org>
>> wrote:
>>
>> > On Fri, Feb 17, 2023 at 05:03:05PM -0600, Haitao Huang wrote:
>> > > Hi Jarkko
>> > >
>> > > On Fri, 17 Feb 2023 16:32:12 -0600, jarkko@kernel.org
>> > > <jarkko@kernel.org>
>> > > wrote:
>> > >
>> > > > On Wed, Feb 15, 2023 at 09:42:30AM -0600, Haitao Huang wrote:
>> > > > > On Wed, 15 Feb 2023 02:51:23 -0600, Huang, Kai  
>> <kai.huang@intel.com>
>> > > > > wrote:
>> > > > >
>> > > > > > > > > >
>> > > > > > > >
>> > > > > > > > Since sgx_mmap() can happen before enclave is created,
>> > > > > calculating the
>> > > > > > > > vm_pgoff
>> > > > > > > > from enclave_base is conceptually wrong.  Even if you  
>> really
>> > > want
>> > > > > > > to do
>> > > > > > > > it, it
>> > > > > > > > should be:
>> > > > > > > >
>> > > > > > > > 	if (enclave_has_initialized())
>> > > > > > > > 		vma->vm_pgoff = ...;
>> > > > > > >
>> > > > > > > I got your point now. I can add a condition to test the
>> > > > > SGX_ENCL_CREATED
>> > > > > > > bit. However, we still have a hole if we must handle the
>> > > sequence
>> > > > > > > mmap(..., enclave_fd) being called before ECREATE ioctl. We
>> > > > > can't leave
>> > > > > > > vm_pgoff not set for those cases.
>> > > > > > >
>> > > > > > > Since no one does that so far, can we explicitly return an  
>> error
>> > > > > from
>> > > > > > > sgx_mmap when that happens?
>> > > > > > > Other suggestions?
>> > > > > >
>> > > > > > As I replied to patch 4/4, I believe userspace should pass the
>> > > correct
>> > > > > > pgoff in
>> > > > > > mmap().  It's wrong to always pass 0 or any random value.
>> > > > > >
>> > > > > > If userspace follow the mmap() rule, you won't need to  
>> manually
>> > > set
>> > > > > > vm_pgoff
>> > > > > > here (which is hacky IMHO).  Everything works fine.
>> > > > > >
>> > > > >
>> > > > > SGX driver was following MAP_ANONYMOUS semantics. If we change  
>> that,
>> > > > > it'd
>> > > > > break current usage/ABI.
>> > > > >
>> > > > > I still think returning error for cases mmap(..., enclave_fd) if
>> > > > > enclave is
>> > > > > not created would be less intrusive change.
>> > > >
>> > > > Is this something you care in SGX SDK?
>> > > >
>> > > > It is not categorically forbidden so that's why I'm asking.
>> > >
>> > > SDK does not care as we would never do this and don't think anyone  
>> is
>> > > doing
>> > > that either. Suggesting returning error to cover all cases so user  
>> space
>> > > would not accidentally cause incorrect vm_pgoff set.
>> >
>> > vm_pgoff != 0 should result -EINVAL.
>> >
>>
>> Do you mean 'offset' passed in from mmap syscall and converted to pgoff  
>> in
>> kernel? I can see it only passed to driver in get_unmapped_area. I can  
>> add
>> this enforcement there so it is consistent to the MAP_ANONYMOUS spec if
>> that's what you suggest.
>>
>>   vma->vm_pgoff is the offset in pages of the vma->vm_start relative to
>> 'file'.
>>   It can not be zero for all VMAs of the enclave.
>>
>> Kernel sets vma->vm_pgoff == vma->vm_start>>PAGE_SHIFT for private anon
>> VMAs, and ignore it (zero) for shared anon mapping.
>>
>> For us, we propose to set it to PFN_DOWN(vma->vm_start - encl->base)  
>> upon
>> mmap.
>
> Sorry for late reply.  Basically I was sick and having limited working  
> time in
> the passed two weeks.
>
> For what I understand now, SGX driver wants to use MAP_ANONYMOUS  
> semantic for
> mmap()s against /dev/sgx_enclave (for whatever reason that I don't  
> understand).
> And because of that, we even want to explicitly enforce userspace to  
> always pass
> 0 as pgoff in mmap()s (hasn't been done yet).
>
> And then here, we want to rewrite vma->pgoff so that the VMA can act  
> _like_ a
> normal file-based mmap() semantics (despite it is indeed a file-based  
> VMA),
> because the VFS fadvice() implementation assumes file-based VMAs are  
> always
> following file-based mmap() semantics.
>
> Hmm..
>
> Doesn't this sound weird?
>

Sometime weird means good or creative as expressed in a popular slogan in  
the city where I live. Just joking:-)

> I must have been missing something, but why cannot SGX driver just  
> always follow
> file-based mmap() semantics at the beginning?
>
> For instance, what's wrong with:
>
> 	1) encl_fd = open("/dev/sgx_enclave")
> 	2) encl_base = mmap(..., encl_size, MAP_SHARED, encl_fd, 0 /* pgoff */)
> 	3) ioctl(ECREATE, encl_base, encl_size)
>
> (In ioctl(ECREATE), we might want to verify the VMA we found has the same
> encl_base as starting address, and 0 pgoff).
>
> And in following mmap()s in which we want to map a small range of  
> enclave:
>
> 	encl_addr = mmap(encl_addr, MAP_SHARED|MAP_FIXED, encl_fd,
> 			(encl_addr - encl_base) >> PAGE_SHIFT);
>
> ?
>
> Anything wrong above?
>

I believe this can be done except for that you are breaking existing code  
by requiring pg_off for all mmaps now.

Doing mmap before ECREATE also effectively bypasses sgx_encl_may_map. And  
we have a very long thread of discussion about this[1] and that's why  
sgx_encl_may_map come into play to limit VMA permissions to those given in  
SecInfo by EADD ioctl. However, current code does not explicitly block it  
and I think it'd be better do it.  More comment below on this point.

> In fact, if the first mmap() in step 2) before IOCTL(ecreate) used
> MAP_ANONYMOUS, IIUC that VMA will stay as anonymous VMA but will never be
> converted to SGX file-based one, because by looking at the code, I see  
> neither
> ioctl(ECREATE) nor ioctl(EINIT) converts that VMA to file-based one.
>
> That being said, all page faults caused by userspace access to that VMA  
> will
> still go to anonymous VMA's fault path, but not SGX driver's.
>

It is required to mmap anonymously with PROT_NONE initially and
user space must invoke mmap with enclave fd after EADDing each  
segments/areas. PF handler will check VMA prot bits against  
vm_max_prot_bits in sgx_encl_load_page_in_vma, and report failure on any  
mismatch.
If user space does not mmap(...,encl_fd) after EADD, pages will have  
PROT_NONE and fail on any access.

> This is fine for SGX1 as all enclave pages are fully populated.  For  
> SGX2,
> _unless_ you explicitly mmap("/dev/sgx_enclave") those dynamical ranges,  
> the
> fault will never be handled by SGX driver.
>

Indeed, it is required user space invoke mmap to config the regions for  
EAUG.

> Architecturally, for SGX2, if you mmap() the entire enclave range (as in  
> step
> 2), you don't need explicitly mmap() all dynamic ranges.  The userspace  
> should
> just be able to access those dynamic ranges (i.e. EACCEPT) and the  
> kernel driver
> should gracefully handle the fault.
>
> Shouldn't this be a problem?
>
> (Btw, there might be other corner cases that could cause VMA  
> splitting/merging,
> etc, but I haven't thought about those)
>
>> The concern Kai raised about encl->base not available in the window
>> between mmap and ECREATE can be addressed by disallowing mmap before
>> ECREATE is done. It does not make much sense anyway to mmap(enclave_fd)
>> without a valid enclave range associated with enclave_fd.
>>
>
> We can, but I don't understand why the first mmap() before ECREATE  
> must/should
> be done via MMAP_ANONYMOUS.  In fact, I think it might be wrong for SGX2.
>

There is a long history behind it. The use of anonymous mapping can be  
traced back to v29.
See this thread[2].

Before v29, user space can do mmap(PROT_NONE, ..., enclave_fd) before  
ECREATE to reserve a range for the enclave. But it must be PROT_NONE for  
the reservation, otherwise sgx_encl_may_map will block it by the "!page"  
check below [3]:

int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
		     unsigned long end, unsigned long vm_prot_bits)
{
	unsigned long idx, idx_start, idx_end;
	struct sgx_encl_page *page;

	/* PROT_NONE always succeeds. */
	if (!vm_prot_bits)
		return 0;

	idx_start = PFN_DOWN(start);
	idx_end = PFN_DOWN(end - 1);
	for (idx = idx_start; idx <= idx_end; ++idx) {
		mutex_lock(&encl->lock);
		page = radix_tree_lookup(&encl->page_tree, idx);
		mutex_unlock(&encl->lock);

		if (!page || (~page->vm_prot_bits & vm_prot_bits))
			return -EACCES;
...

Then in v29, PROT_NONE mapping was disallowed for encl_fd before pages  
EADDed so user space has to mmap anonymously to reserve the range.The  
intent was still not to allow mmap before pages EADDed (the !page check  
was still there up to v38)

Later version (around v39?) we switched to enforce the permissions in PF  
handler and mmap with any permissions before EADD is allowed, but may  
cause failure later on PF. I'm not sure it was intentional but pretty sure  
no meaningful usage for doing mmap before ECREATE due to PF handler  
enforcement.

I think that's the history behind it. Others more knowledgeable can  
correct me as needed.

Again, even if we redesign the whole thing to be less "weird", then  
requiring pgoff for each mmap would break existing user space code. And I  
think explicitly block mmap before ECREATE make the API more consistent  
with the PF handler enforcement and original intent of sgx_encl_may_map.

Thanks again for detailed review and those thoughtful questions.

Haitao

[1]https://lore.kernel.org/linux-sgx/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com/
[2]https://lore.kernel.org/linux-sgx/CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com/
[3]https://lore.kernel.org/linux-sgx/20190713170804.2340-17-jarkko.sakkinen@linux.intel.com/
