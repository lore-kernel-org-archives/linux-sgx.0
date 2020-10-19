Return-Path: <SRS0=Kf/c=D2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3542EC433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 20:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8A5522404
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 20:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgJSUsl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Oct 2020 16:48:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:58167 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbgJSUsl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Oct 2020 16:48:41 -0400
IronPort-SDR: 4pp7nLst+AIfiGK+aY2gcQoZ4jaaxF+LBAfQXHe/s+WfLNHl7L/yKzZOfqgbHvO3pCi9+tvIPK
 XfKrUMzpQjVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="231294639"
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="231294639"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 13:48:36 -0700
IronPort-SDR: tbysIISBGZjr825l7A/pGvjkGJnCmMiCVIdN/xnDWT5cypuCCWYOLW3WwKDyPN5DrvCC3pXXZx
 jkUTTTXnyGQw==
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="522125233"
Received: from haixinlu-mobl1.amr.corp.intel.com (HELO [10.212.84.56]) ([10.212.84.56])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 13:48:33 -0700
Subject: Re: [PATCH v39 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-14-jarkko.sakkinen@linux.intel.com>
 <1739984e-0010-2031-1561-809a0b6380bb@intel.com>
 <20201018050311.GK68722@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <516a1b7a-38cc-adde-833b-b661cbee97f2@intel.com>
Date:   Mon, 19 Oct 2020 13:48:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201018050311.GK68722@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/17/20 10:03 PM, Jarkko Sakkinen wrote:
> On Fri, Oct 16, 2020 at 02:25:50PM -0700, Dave Hansen wrote:
>>> +/**
>>> + * struct sgx_enclave_add_pages - parameter structure for the
>>> + *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
>>> + * @src:	start address for the page data
>>> + * @offset:	starting page offset
>>
>> Is this the offset *within* the page?  Might be nice to say that.
> 
> It's the offset in the enclave address range where page is to be added.

Yikes, comment improvement needed, badly.

>>> +static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
>>> +						 unsigned long offset,
>>> +						 u64 secinfo_flags)
>>> +{
>>> +	struct sgx_encl_page *encl_page;
>>> +	unsigned long prot;
>>> +
>>> +	encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
>>> +	if (!encl_page)
>>> +		return ERR_PTR(-ENOMEM);
>>> +
>>> +	encl_page->desc = encl->base + offset;
>>> +	encl_page->encl = encl;
>>
>> Somewhere, we need an explanation of why we have 'sgx_epc_page' and
>> 'sgx_encl_page'.  I think they're 1:1 at least after
>> sgx_encl_page_alloc(), so I'm wondering why we need two.
> 
> You need sgx_encl_page to hold data that exists whether or not there is
> an associated EPC page.

Except they're currently tightly bound:

>         encl_page = sgx_encl_page_alloc(encl, offset, secinfo->flags);
>         if (IS_ERR(encl_page))
>                 return PTR_ERR(encl_page);
>  
> -       epc_page = __sgx_alloc_epc_page();
> +       epc_page = sgx_alloc_epc_page(encl_page, true);
>         if (IS_ERR(epc_page)) {
>                 kfree(encl_page);
>                 return PTR_ERR(epc_page);
>         }

So, is this because 'sgx_encl_page' continues to exist even if
'sgx_epc_page' is reclaimed?

> Essentially sgx_encl_page contains the data needed for a virtual page,
> and sgx_epc_page what is needed to represent physical page.

So, grumble grumble, that's horribly inefficient for sparse mappings.
There's a reason VMAs cover ranges instead of being allocated
per-virtual-page.

> None of the data contained in sgx_encl_page make sense for sgx_epc_page.
> They don't contain intersecting or redundant data.

Yeah, except they point to each other, so if one isn't necessary, we can
get rid of that pointer.

>>> +static int __sgx_encl_add_page(struct sgx_encl *encl,
>>> +			       struct sgx_encl_page *encl_page,
>>> +			       struct sgx_epc_page *epc_page,
>>> +			       struct sgx_secinfo *secinfo, unsigned long src)
>>> +{
>>> +	struct sgx_pageinfo pginfo;
>>> +	struct vm_area_struct *vma;
>>> +	struct page *src_page;
>>> +	int ret;
>>> +
>>> +	/* Deny noexec. */
>>> +	vma = find_vma(current->mm, src);
>>> +	if (!vma)
>>> +		return -EFAULT;
>>> +
>>> +	if (!(vma->vm_flags & VM_MAYEXEC))
>>> +		return -EACCES;
>>> +
>>> +	ret = get_user_pages(src, 1, 0, &src_page, NULL);
>>> +	if (ret < 1)
>>> +		return -EFAULT;
>>> +
>>> +	pginfo.secs = (unsigned long)sgx_get_epc_addr(encl->secs.epc_page);
>>> +	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
>>> +	pginfo.metadata = (unsigned long)secinfo;
>>> +	pginfo.contents = (unsigned long)kmap_atomic(src_page);
>>> +
>>> +	ret = __eadd(&pginfo, sgx_get_epc_addr(epc_page));
>>
>> Could you convince me that EADD is not going to fault and make the
>> kmap_atomic() mad?
> 
> It can legitly fail in the case when power cycle happens.
> 
> That's why the inline assembly catches faults and return an error code.
> Thhis code has been field tested a lot. I have fairly good trust on
> it.

OK, so it can fault, but not *sleep*.

Can you comment it to that effect, please?

>>> +		if (ret) {
>>> +			if (encls_failed(ret))
>>> +				ENCLS_WARN(ret, "EEXTEND");
>>> +			return -EIO;
>>
>> How frequent should we expect these to be?  Can users cause them?  You
>> should *proably* call it ENCLS_WARN_ONCE() if it's implemented that way.
> 
> If power cycle happens.

So, we get one warning per power cycle?  Practically, do you mean a
suspend/resume cycle, or is this more like hibernation-to-disk-resume?

In any case, if this is normal system operation (which closing my laptop
lid qualifies as), it should produce zero warnings.


>>> +static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
>>> +			     unsigned long offset, struct sgx_secinfo *secinfo,
>>> +			     unsigned long flags)
>>> +{
>>> +	struct sgx_encl_page *encl_page;
>>> +	struct sgx_epc_page *epc_page;
>>> +	int ret;
>>> +
>>> +	encl_page = sgx_encl_page_alloc(encl, offset, secinfo->flags);
>>> +	if (IS_ERR(encl_page))
>>> +		return PTR_ERR(encl_page);
>>> +
>>> +	epc_page = __sgx_alloc_epc_page();
>>> +	if (IS_ERR(epc_page)) {
>>> +		kfree(encl_page);
>>> +		return PTR_ERR(epc_page);
>>> +	}
>>
>> Looking at these, I'm forgetting why we need to both allocate an
>> encl_page and an epc_page.  Commends might remind me.  So would better
>> names.
> 
> Should the struct names be renamed?
> 
> Like sgx_phys_epc_page and sgx_virt_epc_page?

"epc" is additional acronym nonsense and redundant with "sgx" and "page"
anyway.

I'd probably call then 'sgx_phys_page' and 'sgx_virt_slot' or something.

>>> +	mmap_read_lock(current->mm);
>>> +	mutex_lock(&encl->lock);
>>> +
>>> +	/*
>>> +	 * Insert prior to EADD in case of OOM.
>>
>> I wouldn't say OOM.  Maybe:
>>
>> 	xa_insert() and EADD can both fail.  But xa_insert() is easier
>> 	to unwind so do it first.
>>
>>>                                              EADD modifies MRENCLAVE, i.e.
>>
>> What is MRENCLAVE?
> 
> The measurement stored in SECS. I'm wondering  with xarray, is it
> possible to preallocate entry without inserting anything?

Let's use plain english here.  I don't care what the implementation
does, I just care about what it means to the kernel.

> Then we could get rid of this unwind and also would not need to
> take encl->lock in sgx_encl_may_map().

There was for radix trees, iirc.

>>> +	 * can't be gracefully unwound, while failure on EADD/EXTEND is limited
>>> +	 * to userspace errors (or kernel/hardware bugs).
>>> +	 */
>>> +	ret = xa_insert(&encl->page_array, PFN_DOWN(encl_page->desc),
>>> +			encl_page, GFP_KERNEL);
>>> +	if (ret)
>>> +		goto err_out_unlock;
>>> +
>>> +	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
>>> +				  src);
>>> +	if (ret)
>>> +		goto err_out;
>>> +
>>> +	/*
>>> +	 * Complete the "add" before doing the "extend" so that the "add"
>>> +	 * isn't in a half-baked state in the extremely unlikely scenario
>>> +	 * the enclave will be destroyed in response to EEXTEND failure.
>>> +	 */
>>> +	encl_page->encl = encl;
>>> +	encl_page->epc_page = epc_page;
>>> +	encl->secs_child_cnt++;
>>> +
>>> +	if (flags & SGX_PAGE_MEASURE) {
>>> +		ret = __sgx_encl_extend(encl, epc_page);
>>> +		if (ret)
>>> +			goto err_out;
>>> +	}
>>
>> Why would we never *not* measure an added page?
> 
> You might add Thread Control Structure pages without measuring them or
> data area. There are reasons for the user space not to have everything
> measured.

This is also good comment fodder.

>>> +static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
>>> +{
>>> +	struct sgx_enclave_add_pages addp;
>>> +	struct sgx_secinfo secinfo;
>>> +	unsigned long c;
>>> +	int ret;
>>> +
>>> +	if ((atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) ||
>>> +	    !(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
>>> +		return -EINVAL;
>>
>> There should to be a nice state machine documented somewhere.  Is ther?
> 
> So should I document to encl.h where they are declared to start with?

I think it's better placed in the Documentation/.

>>> +	if (copy_from_user(&addp, arg, sizeof(addp)))
>>> +		return -EFAULT;
>>> +
>>> +	if (!IS_ALIGNED(addp.offset, PAGE_SIZE) ||
>>> +	    !IS_ALIGNED(addp.src, PAGE_SIZE))
>>> +		return -EINVAL;
>>> +
>>> +	if (!(access_ok(addp.src, PAGE_SIZE)))
>>> +		return -EFAULT;
>>
>> This worries me.  You're doing an access_ok() check on addp.src because
>> you evidently don't trust it.  But, below, it looks to be accessed
>> directly with an offset, bound by addp.length, which I think can be
>>> PAGE_SIZE.
>>
>> I'd feel a lot better if addp.src's value was being passed around as a
>> __user pointer.
> 
> I'm not sure if that call is even needed. Each page is pinned with
> get_user_pages(). AFAIK, it should be enough. This must be legacy cruft.

get_user_pages() and access_ok() do *very* different things.  Even if
the pages are pinned, you might still be tricked into referencing off
the end of the page, or up into the kernel address space.

>>> +	if (addp.length & (PAGE_SIZE - 1))
>>> +		return -EINVAL;
>>> +
>>> +	if (addp.offset + addp.length - PAGE_SIZE >= encl->size)
>>> +		return -EINVAL;
>>> +
>>> +	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
>>> +			   sizeof(secinfo)))
>>> +		return -EFAULT;
>>> +
>>> +	if (sgx_validate_secinfo(&secinfo))
>>> +		return -EINVAL;
>>> +
>>> +	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
>>> +		if (signal_pending(current)) {
>>> +			if (!c)
>>> +				ret = -ERESTARTSYS;
>>> +
>>> +			break;
>>> +		}
>>> +
>>> +		if (c == SGX_MAX_ADD_PAGES_LENGTH)
>>> +			break;
>>> +
>>> +		if (need_resched())
>>> +			cond_resched();
>>> +
>>> +		ret = sgx_encl_add_page(encl, addp.src + c, addp.offset + c,
>>> +					&secinfo, addp.flags);
>>
>> Yeah...  Don't we need to do another access_ok() check here, if we
>> needed one above since we are moving away from addrp.src?
> 
> I don't think so because the page is pinned with get_user_pages().

No, get_user_pages() is orthogonal.

Looking at this again, you _might_ be OK since you validated addp.length
against encl->size.  But, it's all very convoluted and doesn't look very
organized or obviously right.

So, this begs the question: What, exactly are the guarantees you are
expecting out of get_user_pages() here?

I also think it's an absolute requirement that if you're passing around
userspace pointers that you tag them as __user, not pass around as
unsigned longs.
