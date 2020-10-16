Return-Path: <SRS0=BPWR=DX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559DFC433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Oct 2020 21:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC943214DB
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Oct 2020 21:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411303AbgJPV0Z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Oct 2020 17:26:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:13379 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410258AbgJPVZ6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Oct 2020 17:25:58 -0400
IronPort-SDR: vvsXFBZlTMnKbdKajABF8xLLkwXYNnyFcgGwep3Uum0Z9wNd3vt4JNBp/EJUaTRvAB8H+ROJ5U
 SR2b09ff7eFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="228337977"
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="228337977"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:25:54 -0700
IronPort-SDR: ambpymW09VkkT/Rx53PgxtbJ8LvJlyQxBx64wlwFOQKqGKGnFHynYWUwjPmjkR38PUKYf7pTyq
 GTbfGtwilMcA==
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="358225361"
Received: from weetchel-mobl.amr.corp.intel.com (HELO [10.209.40.189]) ([10.209.40.189])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:25:53 -0700
Subject: Re: [PATCH v39 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
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
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <1739984e-0010-2031-1561-809a0b6380bb@intel.com>
Date:   Fri, 16 Oct 2020 14:25:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201003045059.665934-14-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> +/**
> + * struct sgx_enclave_add_pages - parameter structure for the
> + *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> + * @src:	start address for the page data
> + * @offset:	starting page offset

Is this the offset *within* the page?  Might be nice to say that.

> + * @length:	length of the data (multiple of the page size)
> + * @secinfo:	address for the SECINFO data
> + * @flags:	page control flags
> + * @count:	number of bytes added (multiple of the page size)
> + */
> +struct sgx_enclave_add_pages {
> +	__u64 src;
> +	__u64 offset;
> +	__u64 length;
> +	__u64 secinfo;
> +	__u64 flags;
> +	__u64 count;
> +};
> +
>  #endif /* _UAPI_ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 9bb4694e57c1..e13e04737683 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -194,6 +194,302 @@ static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
>  	return ret;
>  }
>  
> +static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
> +						 unsigned long offset,
> +						 u64 secinfo_flags)
> +{
> +	struct sgx_encl_page *encl_page;
> +	unsigned long prot;
> +
> +	encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
> +	if (!encl_page)
> +		return ERR_PTR(-ENOMEM);
> +
> +	encl_page->desc = encl->base + offset;
> +	encl_page->encl = encl;

Somewhere, we need an explanation of why we have 'sgx_epc_page' and
'sgx_encl_page'.  I think they're 1:1 at least after
sgx_encl_page_alloc(), so I'm wondering why we need two.

> +	prot = _calc_vm_trans(secinfo_flags, SGX_SECINFO_R, PROT_READ)  |
> +	       _calc_vm_trans(secinfo_flags, SGX_SECINFO_W, PROT_WRITE) |
> +	       _calc_vm_trans(secinfo_flags, SGX_SECINFO_X, PROT_EXEC);
> +
> +	/*
> +	 * TCS pages must always RW set for CPU access while the SECINFO
> +	 * permissions are *always* zero - the CPU ignores the user provided
> +	 * values and silently overwrites them with zero permissions.
> +	 */
> +	if ((secinfo_flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
> +		prot |= PROT_READ | PROT_WRITE;
> +
> +	/* Calculate maximum of the VM flags for the page. */
> +	encl_page->vm_max_prot_bits = calc_vm_prot_bits(prot, 0);
> +
> +	return encl_page;
> +}
> +
> +static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
> +{
> +	u64 perm = secinfo->flags & SGX_SECINFO_PERMISSION_MASK;
> +	u64 pt = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;

I'd align the ='s up there ^^

> +
> +	if (pt != SGX_SECINFO_REG && pt != SGX_SECINFO_TCS)
> +		return -EINVAL;
> +
> +	if ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R))
> +		return -EINVAL;
> +
> +	/*
> +	 * CPU will silently overwrite the permissions as zero, which means
> +	 * that we need to validate it ourselves.
> +	 */
> +	if (pt == SGX_SECINFO_TCS && perm)
> +		return -EINVAL;
> +
> +	if (secinfo->flags & SGX_SECINFO_RESERVED_MASK)
> +		return -EINVAL;
> +
> +	if (memchr_inv(secinfo->reserved, 0, sizeof(secinfo->reserved)))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int __sgx_encl_add_page(struct sgx_encl *encl,
> +			       struct sgx_encl_page *encl_page,
> +			       struct sgx_epc_page *epc_page,
> +			       struct sgx_secinfo *secinfo, unsigned long src)
> +{
> +	struct sgx_pageinfo pginfo;
> +	struct vm_area_struct *vma;
> +	struct page *src_page;
> +	int ret;
> +
> +	/* Deny noexec. */
> +	vma = find_vma(current->mm, src);
> +	if (!vma)
> +		return -EFAULT;
> +
> +	if (!(vma->vm_flags & VM_MAYEXEC))
> +		return -EACCES;
> +
> +	ret = get_user_pages(src, 1, 0, &src_page, NULL);
> +	if (ret < 1)
> +		return -EFAULT;
> +
> +	pginfo.secs = (unsigned long)sgx_get_epc_addr(encl->secs.epc_page);
> +	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
> +	pginfo.metadata = (unsigned long)secinfo;
> +	pginfo.contents = (unsigned long)kmap_atomic(src_page);
> +
> +	ret = __eadd(&pginfo, sgx_get_epc_addr(epc_page));

Could you convince me that EADD is not going to fault and make the
kmap_atomic() mad?

> +	kunmap_atomic((void *)pginfo.contents);

All the casting is kinda nasty, but I gues you do it to ensure you can
use __u64 in the hardware structs.

> +	put_page(src_page);
> +
> +	return ret ? -EIO : 0;
> +}
> +
> +/*
> + * If the caller requires measurement of the page as a proof for the content,
> + * use EEXTEND to add a measurement for 256 bytes of the page. Repeat this
> + * operation until the entire page is measured."
> + */
> +static int __sgx_encl_extend(struct sgx_encl *encl,
> +			     struct sgx_epc_page *epc_page)
> +{
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < 16; i++) {

No magic numbers please.

#define SGX_EEXTEND_NR_BYTES 16 ??

> +		ret = __eextend(sgx_get_epc_addr(encl->secs.epc_page),
> +				sgx_get_epc_addr(epc_page) + (i * 0x100));

What's the 0x100 for?

> +		if (ret) {
> +			if (encls_failed(ret))
> +				ENCLS_WARN(ret, "EEXTEND");
> +			return -EIO;

How frequent should we expect these to be?  Can users cause them?  You
should *proably* call it ENCLS_WARN_ONCE() if it's implemented that way.

> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> +			     unsigned long offset, struct sgx_secinfo *secinfo,
> +			     unsigned long flags)
> +{
> +	struct sgx_encl_page *encl_page;
> +	struct sgx_epc_page *epc_page;
> +	int ret;
> +
> +	encl_page = sgx_encl_page_alloc(encl, offset, secinfo->flags);
> +	if (IS_ERR(encl_page))
> +		return PTR_ERR(encl_page);
> +
> +	epc_page = __sgx_alloc_epc_page();
> +	if (IS_ERR(epc_page)) {
> +		kfree(encl_page);
> +		return PTR_ERR(epc_page);
> +	}

Looking at these, I'm forgetting why we need to both allocate an
encl_page and an epc_page.  Commends might remind me.  So would better
names.

> +	mmap_read_lock(current->mm);
> +	mutex_lock(&encl->lock);
> +
> +	/*
> +	 * Insert prior to EADD in case of OOM.

I wouldn't say OOM.  Maybe:

	xa_insert() and EADD can both fail.  But xa_insert() is easier
	to unwind so do it first.

>                                              EADD modifies MRENCLAVE, i.e.

What is MRENCLAVE?

> +	 * can't be gracefully unwound, while failure on EADD/EXTEND is limited
> +	 * to userspace errors (or kernel/hardware bugs).
> +	 */
> +	ret = xa_insert(&encl->page_array, PFN_DOWN(encl_page->desc),
> +			encl_page, GFP_KERNEL);
> +	if (ret)
> +		goto err_out_unlock;
> +
> +	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
> +				  src);
> +	if (ret)
> +		goto err_out;
> +
> +	/*
> +	 * Complete the "add" before doing the "extend" so that the "add"
> +	 * isn't in a half-baked state in the extremely unlikely scenario
> +	 * the enclave will be destroyed in response to EEXTEND failure.
> +	 */
> +	encl_page->encl = encl;
> +	encl_page->epc_page = epc_page;
> +	encl->secs_child_cnt++;
> +
> +	if (flags & SGX_PAGE_MEASURE) {
> +		ret = __sgx_encl_extend(encl, epc_page);
> +		if (ret)
> +			goto err_out;
> +	}

Why would we never *not* measure an added page?

> +	mutex_unlock(&encl->lock);
> +	mmap_read_unlock(current->mm);
> +	return ret;
> +
> +err_out:
> +	xa_erase(&encl->page_array, PFN_DOWN(encl_page->desc));
> +
> +err_out_unlock:
> +	mutex_unlock(&encl->lock);
> +	mmap_read_unlock(current->mm);
> +
> +	sgx_free_epc_page(epc_page);
> +	kfree(encl_page);
> +
> +	return ret;
> +}
> +
> +/**
> + * sgx_ioc_enclave_add_pages() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGES
> + * @encl:       an enclave pointer
> + * @arg:	a user pointer to a struct sgx_enclave_add_pages instance
> + *
> + * Add one or more pages to an uninitialized enclave, and optionally extend the
> + * measurement with the contents of the page. The SECINFO and measurement mask
> + * are applied to all pages.
> + *
> + * A SECINFO for a TCS is required to always contain zero permissions because
> + * CPU silently zeros them. Allowing anything else would cause a mismatch in
> + * the measurement.
> + *
> + * mmap()'s protection bits are capped by the page permissions. For each page
> + * address, the maximum protection bits are computed with the following
> + * heuristics:
> + *
> + * 1. A regular page: PROT_R, PROT_W and PROT_X match the SECINFO permissions.
> + * 2. A TCS page: PROT_R | PROT_W.
> + *
> + * mmap() is not allowed to surpass the minimum of the maximum protection bits
> + * within the given address range.
> + *
> + * The function deinitializes kernel data structures for enclave and returns
> + * -EIO in any of the following conditions:
> + *
> + * - Enclave Page Cache (EPC), the physical memory holding enclaves, has
> + *   been invalidated. This will cause EADD and EEXTEND to fail.
> + * - If the source address is corrupted somehow when executing EADD.
> + *
> + * Return:
> + *   length of the data processed on success,
> + *   -EACCES if an executable source page is located in a noexec partition,
> + *   -ENOMEM if the system is out of EPC pages,
> + *   -EINTR if the call was interrupted before any data was processed,
> + *   -EIO if the enclave was lost
> + *   -errno otherwise
> + */
> +static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
> +{
> +	struct sgx_enclave_add_pages addp;
> +	struct sgx_secinfo secinfo;
> +	unsigned long c;
> +	int ret;
> +
> +	if ((atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) ||
> +	    !(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
> +		return -EINVAL;

There should to be a nice state machine documented somewhere.  Is ther?

> +	if (copy_from_user(&addp, arg, sizeof(addp)))
> +		return -EFAULT;
> +
> +	if (!IS_ALIGNED(addp.offset, PAGE_SIZE) ||
> +	    !IS_ALIGNED(addp.src, PAGE_SIZE))
> +		return -EINVAL;
> +
> +	if (!(access_ok(addp.src, PAGE_SIZE)))
> +		return -EFAULT;

This worries me.  You're doing an access_ok() check on addp.src because
you evidently don't trust it.  But, below, it looks to be accessed
directly with an offset, bound by addp.length, which I think can be
>PAGE_SIZE.

I'd feel a lot better if addp.src's value was being passed around as a
__user pointer.

> +	if (addp.length & (PAGE_SIZE - 1))
> +		return -EINVAL;
> +
> +	if (addp.offset + addp.length - PAGE_SIZE >= encl->size)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
> +			   sizeof(secinfo)))
> +		return -EFAULT;
> +
> +	if (sgx_validate_secinfo(&secinfo))
> +		return -EINVAL;
> +
> +	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
> +		if (signal_pending(current)) {
> +			if (!c)
> +				ret = -ERESTARTSYS;
> +
> +			break;
> +		}
> +
> +		if (c == SGX_MAX_ADD_PAGES_LENGTH)
> +			break;
> +
> +		if (need_resched())
> +			cond_resched();
> +
> +		ret = sgx_encl_add_page(encl, addp.src + c, addp.offset + c,
> +					&secinfo, addp.flags);

Yeah...  Don't we need to do another access_ok() check here, if we
needed one above since we are moving away from addrp.src?

> +		if (ret)
> +			break;
> +	}
> +
> +	addp.count = c;
> +
> +	if (copy_to_user(arg, &addp, sizeof(addp)))
> +		return -EFAULT;
> +
> +	/*
> +	 * If the enlave was lost, deinitialize the internal data structures
> +	 * for the enclave.
> +	 */
> +	if (ret == -EIO) {
> +		mutex_lock(&encl->lock);
> +		sgx_encl_destroy(encl);
> +		mutex_unlock(&encl->lock);
> +	}
> +
> +	return ret;
> +}
> +
>  long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  {
>  	struct sgx_encl *encl = filep->private_data;
> @@ -212,6 +508,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  	case SGX_IOC_ENCLAVE_CREATE:
>  		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
>  		break;
> +	case SGX_IOC_ENCLAVE_ADD_PAGES:
> +		ret = sgx_ioc_enclave_add_pages(encl, (void __user *)arg);
> +		break;
>  	default:
>  		ret = -ENOIOCTLCMD;
>  		break;
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index fce756c3434b..8d126070db1e 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -34,6 +34,7 @@ struct sgx_epc_section {
>  
>  #define SGX_EPC_SECTION_MASK		GENMASK(7, 0)
>  #define SGX_MAX_EPC_SECTIONS		(SGX_EPC_SECTION_MASK + 1)
> +#define SGX_MAX_ADD_PAGES_LENGTH	0x100000
>  
>  extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
>  
> 

