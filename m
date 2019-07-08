Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED50C606BD
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 17:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 254AE216C4
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 17:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730779AbfGHR3U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 13:29:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:40843 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbfGHR3U (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 13:29:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 10:29:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="316774681"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga004.jf.intel.com with ESMTP; 08 Jul 2019 10:29:19 -0700
Subject: Re: [RFC PATCH v4 04/12] x86/sgx: Require userspace to define enclave
 pages' protection bits
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-5-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F65518451@ORSMSX116.amr.corp.intel.com>
 <20190708163431.GF20433@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <a17cc51e-f5c4-d8e3-0154-d475d222ef0b@intel.com>
Date:   Mon, 8 Jul 2019 10:29:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708163431.GF20433@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/8/2019 9:34 AM, Sean Christopherson wrote:
> On Fri, Jun 21, 2019 at 09:42:54AM -0700, Xing, Cedric wrote:
>>> From: Christopherson, Sean J
>>> Sent: Wednesday, June 19, 2019 3:24 PM
>>>
>>> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h index
>>> 6dba9f282232..67a3babbb24d 100644
>>> --- a/arch/x86/include/uapi/asm/sgx.h
>>> +++ b/arch/x86/include/uapi/asm/sgx.h
>>> @@ -35,15 +35,17 @@ struct sgx_enclave_create  {
>>>    * @src:	address for the page data
>>>    * @secinfo:	address for the SECINFO data
>>>    * @mrmask:	bitmask for the measured 256 byte chunks
>>> + * @prot:	maximal PROT_{READ,WRITE,EXEC} protections for the page
>>>    */
>>>   struct sgx_enclave_add_page {
>>>   	__u64	addr;
>>>   	__u64	src;
>>>   	__u64	secinfo;
>>> -	__u64	mrmask;
>>> +	__u16	mrmask;
>>> +	__u8	prot;
>>> +	__u8	pad;
>>>   };
>>
>> Given EPCM permissions cannot change in SGX1, these maximal PROT_* flags can
>> be the same as EPCM permissions, so don't have to be specified by user code
>> until SGX2. Given we don't have a clear picture on how SGX2 will work yet, I
>> think we shall take "prot" off until it is proven necessary.
> 
> I'm ok with deriving the maximal protections from SECINFO, so long as we
> acknowledge that we're preventing userspace from utilizing EMODPE (until
> the kernel supports SGX2).

I think that's alright.

>>> diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c
>>> b/arch/x86/kernel/cpu/sgx/driver/main.c
>>> index 29384cdd0842..dabfe2a7245a 100644
>>> --- a/arch/x86/kernel/cpu/sgx/driver/main.c
>>> +++ b/arch/x86/kernel/cpu/sgx/driver/main.c
>>> @@ -93,15 +93,64 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,  }
>>> #endif
>>>
>>> +/*
>>> + * Returns the AND of VM_{READ,WRITE,EXEC} permissions across all pages
>>> + * covered by the specific VMA.  A non-existent (or yet to be added)
>>> +enclave
>>> + * page is considered to have no RWX permissions, i.e. is inaccessible.
>>> + */
>>> +static unsigned long sgx_allowed_rwx(struct sgx_encl *encl,
>>> +				     struct vm_area_struct *vma)
>>> +{
>>> +	unsigned long allowed_rwx = VM_READ | VM_WRITE | VM_EXEC;
>>> +	unsigned long idx, idx_start, idx_end;
>>> +	struct sgx_encl_page *page;
>>> +
>>> +	idx_start = PFN_DOWN(vma->vm_start);
>>> +	idx_end = PFN_DOWN(vma->vm_end - 1);
>>> +
>>> +	for (idx = idx_start; idx <= idx_end; ++idx) {
>>> +		/*
>>> +		 * No need to take encl->lock, vm_prot_bits is set prior to
>>> +		 * insertion and never changes, and racing with adding pages is
>>> +		 * a userspace bug.
>>> +		 */
>>> +		rcu_read_lock();
>>> +		page = radix_tree_lookup(&encl->page_tree, idx);
>>> +		rcu_read_unlock();
>>
>> This loop iterates through every page in the range, which could be very slow
>> if the range is large.
> 
> At this point I'm shooting for functional correctness and minimal code
> changes.  Optimizations will be in order at some point, just not now.

I was trying to point out in this thread that your approach isn't as 
simple as it looks lik

>>> +
>>> +		/* Do not allow R|W|X to a non-existent page. */
>>> +		if (!page)
>>> +			allowed_rwx = 0;
>>> +		else
>>> +			allowed_rwx &= page->vm_prot_bits;
>>> +		if (!allowed_rwx)
>>> +			break;
>>> +	}
>>> +
>>> +	return allowed_rwx;
>>> +}
>>> +
>>>   static int sgx_mmap(struct file *file, struct vm_area_struct *vma)  {
>>>   	struct sgx_encl *encl = file->private_data;
>>> +	unsigned long allowed_rwx;
>>>   	int ret;
>>>
>>> +	allowed_rwx = sgx_allowed_rwx(encl, vma);
>>> +	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC) & ~allowed_rwx)
>>> +		return -EACCES;
>>> +
>>>   	ret = sgx_encl_mm_add(encl, vma->vm_mm);
>>>   	if (ret)
>>>   		return ret;
>>>
>>> +	if (!(allowed_rwx & VM_READ))
>>> +		vma->vm_flags &= ~VM_MAYREAD;
>>> +	if (!(allowed_rwx & VM_WRITE))
>>> +		vma->vm_flags &= ~VM_MAYWRITE;
>>> +	if (!(allowed_rwx & VM_EXEC))
>>> +		vma->vm_flags &= ~VM_MAYEXEC;
>>> +
>>
>> Say a range comprised of a RW sub-range and a RX sub-range is being mmap()'ed
>> as R here. It'd succeed but mprotect(<RW sub-range>, RW) afterwards will fail
>> because VM_MAYWRITE is cleared here. However, if those two sub-ranges are
>> mapped by separate mmap() calls then the same mprotect() would succeed. The
>> inconsistence here is unexpected and unprecedented.
> 
> Boo, I thought I was being super clever.
> 
>>>   	vma->vm_ops = &sgx_vm_ops;
>>>   	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
>>>   	vma->vm_private_data = encl;
>>
