Return-Path: <SRS0=BPWR=DX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD246C43457
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Oct 2020 17:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D5B32084C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Oct 2020 17:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436542AbgJPRHu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Oct 2020 13:07:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:20142 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436535AbgJPRHu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Oct 2020 13:07:50 -0400
IronPort-SDR: iD2+VMyOQtNcG+zoF6akva/K8sdnDrNkGnLu21ZZmR7jorMD6/KuLaaNfx2+WYaGIVd2CehUc7
 YnToIqUN0DkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="230837698"
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="230837698"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 10:07:49 -0700
IronPort-SDR: CKcKzCFr/TCW1QuctRed3/fLjyTHmwbnAsp/TbSr0AX+WyfJwSVFoHZtJ07OELERO5OjSl5Hek
 8lNqQf7oS48Q==
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="358154015"
Received: from weetchel-mobl.amr.corp.intel.com (HELO [10.209.40.189]) ([10.209.40.189])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 10:07:48 -0700
Subject: Re: [PATCH v39 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
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
 <20201003045059.665934-13-jarkko.sakkinen@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <5f194bf0-ced1-66e1-b6a2-503741a3e7f1@intel.com>
Date:   Fri, 16 Oct 2020 10:07:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201003045059.665934-13-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> +static u32 sgx_calc_ssa_frame_size(u32 miscselect, u64 xfrm)
> +{
> +	u32 size_max = PAGE_SIZE;
> +	u32 size;
> +	int i;
> +
> +	for (i = 2; i < 64; i++) {

Should this be:

	for (i = XFEATURE_YMM; i < XFEATURE_MAX; i++) {

Basically, does this need to be 64, or should it be limited to the
kernel-known XFEATURES?  Or, should this be looping through all the bits
set in xfeatures_mask_user().

> +		if (!((1 << i) & xfrm))
> +			continue;
> +
> +		size = SGX_SSA_GPRS_SIZE + sgx_xsave_size_tbl[i];
> +
> +		if (miscselect & SGX_MISC_EXINFO)
> +			size += SGX_SSA_MISC_EXINFO_SIZE;
> +
> +		if (size > size_max)
> +			size_max = size;
> +	}
> +
> +	return PFN_UP(size_max);
> +}
> +
> +static int sgx_validate_secs(const struct sgx_secs *secs)
> +{

What's the overall point of this function?  Does it avoid a #GP from an
instruction later?

Does all of the 'secs' content come from userspace?

> +	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
> +		       sgx_encl_size_max_64 : sgx_encl_size_max_32;
> +
> +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> +		return -EINVAL;
> +
> +	if (secs->base & (secs->size - 1))
> +		return -EINVAL;
> +
> +	if (secs->miscselect & sgx_misc_reserved_mask ||
> +	    secs->attributes & sgx_attributes_reserved_mask ||
> +	    secs->xfrm & sgx_xfrm_reserved_mask)
> +		return -EINVAL;
> +
> +	if (secs->size > max_size)
> +		return -EINVAL;
> +
> +	if (!(secs->xfrm & XFEATURE_MASK_FP) ||
> +	    !(secs->xfrm & XFEATURE_MASK_SSE) ||
> +	    (((secs->xfrm >> XFEATURE_BNDREGS) & 1) != ((secs->xfrm >> XFEATURE_BNDCSR) & 1)))
> +		return -EINVAL;
> +
> +	if (!secs->ssa_frame_size)
> +		return -EINVAL;
> +
> +	if (sgx_calc_ssa_frame_size(secs->miscselect, secs->xfrm) > secs->ssa_frame_size)
> +		return -EINVAL;
> +
> +	if (memchr_inv(secs->reserved1, 0, sizeof(secs->reserved1)) ||
> +	    memchr_inv(secs->reserved2, 0, sizeof(secs->reserved2)) ||
> +	    memchr_inv(secs->reserved3, 0, sizeof(secs->reserved3)) ||
> +	    memchr_inv(secs->reserved4, 0, sizeof(secs->reserved4)))
> +		return -EINVAL;
> +
> +	return 0;
> +}

I think it would be nice to at least have one comment per condition to
explain what's going on there.

> +static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> +{
> +	struct sgx_epc_page *secs_epc;
> +	struct sgx_pageinfo pginfo;
> +	struct sgx_secinfo secinfo;
> +	unsigned long encl_size;
> +	struct file *backing;
> +	long ret;
> +
> +	if (sgx_validate_secs(secs)) {
> +		pr_debug("invalid SECS\n");
> +		return -EINVAL;
> +	}
> +
> +	/* The extra page goes to SECS. */
> +	encl_size = secs->size + PAGE_SIZE;
> +
> +	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
> +				   VM_NORESERVE);

What's the >>5 adjustment for?

> +	if (IS_ERR(backing))
> +		return PTR_ERR(backing);
> +
> +	encl->backing = backing;
> +
> +	secs_epc = __sgx_alloc_epc_page();
> +	if (IS_ERR(secs_epc)) {
> +		ret = PTR_ERR(secs_epc);
> +		goto err_out_backing;
> +	}
> +
> +	encl->secs.epc_page = secs_epc;
> +
> +	pginfo.addr = 0;
> +	pginfo.contents = (unsigned long)secs;
> +	pginfo.metadata = (unsigned long)&secinfo;
> +	pginfo.secs = 0;
> +	memset(&secinfo, 0, sizeof(secinfo));
> +
> +	ret = __ecreate((void *)&pginfo, sgx_get_epc_addr(secs_epc));
> +	if (ret) {
> +		pr_debug("ECREATE returned %ld\n", ret);
> +		goto err_out;
> +	}
> +
> +	if (secs->attributes & SGX_ATTR_DEBUG)
> +		atomic_or(SGX_ENCL_DEBUG, &encl->flags);
> +
> +	encl->secs.encl = encl;
> +	encl->base = secs->base;
> +	encl->size = secs->size;
> +	encl->ssaframesize = secs->ssa_frame_size;
> +
> +	/*
> +	 * Set SGX_ENCL_CREATED only after the enclave is fully prepped.  This
> +	 * allows setting and checking enclave creation without having to take
> +	 * encl->lock.
> +	 */
> +	atomic_or(SGX_ENCL_CREATED, &encl->flags);

I'm wondering what the impact of setting this flag is.  That's hard to
figure out because the flag isn't documented.

It's also unusual to have atomic_or() used like this.  The normal
set_bit()/clear_bit() that you can use on an unsigned long are actually
implemented as atomics.

I'm curious both why this needs to be atomics, *and* why the atomic_or()
interface is being used.

> +	return 0;
> +
> +err_out:
> +	sgx_free_epc_page(encl->secs.epc_page);
> +	encl->secs.epc_page = NULL;
> +
> +err_out_backing:
> +	fput(encl->backing);
> +	encl->backing = NULL;
> +
> +	return ret;
> +}
> +
> +/**
> + * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
> + * @encl:	an enclave pointer
> + * @arg:	userspace pointer to a struct sgx_enclave_create instance
> + *
> + * Allocate kernel data structures for a new enclave and execute ECREATE after
> + * checking that the provided data for SECS meets the expectations of ECREATE
> + * for an uninitialized enclave and size of the address space does not surpass the
> + * platform expectations. This validation is done by sgx_validate_secs().
> + *
> + * Return:
> + *   0 on success,
> + *   -errno otherwise
> + */
> +static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
> +{
> +	struct sgx_enclave_create ecreate;
> +	struct page *secs_page;
> +	struct sgx_secs *secs;
> +	int ret;
> +
> +	if (atomic_read(&encl->flags) & SGX_ENCL_CREATED)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
> +		return -EFAULT;
> +
> +	secs_page = alloc_page(GFP_KERNEL);
> +	if (!secs_page)
> +		return -ENOMEM;
> +
> +	secs = kmap(secs_page);

GFP_KERNEL pages are in low memory and don't need to be kmap()'d.

This can just be:

	secs = __get_free_page(GFP_KERNEL);
	if (copy_from_user(secs, (void __user *)ecreate.src,...

and forget about the kmapping.  You also need to change __free_pages()
to free_pages().

The other alternative would be to just kmalloc() it.  kmalloc()
guarantees alignment in a stronger way than it used to.

> +	if (copy_from_user(secs, (void __user *)ecreate.src, sizeof(*secs))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret = sgx_encl_create(encl, secs);
> +
> +out:
> +	kunmap(secs_page);
> +	__free_page(secs_page);
> +	return ret;
> +}
> +
> +long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> +{
> +	struct sgx_encl *encl = filep->private_data;
> +	int ret, encl_flags;
> +
> +	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
> +	if (encl_flags & SGX_ENCL_IOCTL)
> +		return -EBUSY;

Is the SGX_ENCL_IOCTL bit essentially just a lock to single-thread
ioctl()s?  Should we name it as such?

> +	if (encl_flags & SGX_ENCL_DEAD) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	switch (cmd) {
> +	case SGX_IOC_ENCLAVE_CREATE:
> +		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
> +		break;
> +	default:
> +		ret = -ENOIOCTLCMD;
> +		break;
> +	}
> +
> +out:
> +	atomic_andnot(SGX_ENCL_IOCTL, &encl->flags);
> +	return ret;
> +}
> 

