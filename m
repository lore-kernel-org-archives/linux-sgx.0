Return-Path: <SRS0=sUAi=DZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A21C433DF
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Oct 2020 04:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EC7520EDD
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Oct 2020 04:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgJRE1C (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 18 Oct 2020 00:27:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:35110 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgJRE1B (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 18 Oct 2020 00:27:01 -0400
IronPort-SDR: hSx2Lt+Gk3S1rcD93JLsNOGnkk9+7IxZtJ0kHuQmaxbUX+yHPo6Kus09Yxo0zfogG1rGfL/6KF
 j1Er/CZL1Nug==
X-IronPort-AV: E=McAfee;i="6000,8403,9777"; a="153796959"
X-IronPort-AV: E=Sophos;i="5.77,388,1596524400"; 
   d="scan'208";a="153796959"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2020 21:26:54 -0700
IronPort-SDR: 0biV6sS4TnYcmpAcUzXPOtiv9WMqB/LKMRy5CzG/CzjivhUS3VJYAOQf5m20+NXYKBHaPTn/x/
 v3ct13WkJj8w==
X-IronPort-AV: E=Sophos;i="5.77,388,1596524400"; 
   d="scan'208";a="532230802"
Received: from hebenstp-mobl3.ger.corp.intel.com (HELO localhost) ([10.252.54.12])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2020 21:26:39 -0700
Date:   Sun, 18 Oct 2020 07:26:33 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
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
Subject: Re: [PATCH v39 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20201018042633.GI68722@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-13-jarkko.sakkinen@linux.intel.com>
 <5f194bf0-ced1-66e1-b6a2-503741a3e7f1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f194bf0-ced1-66e1-b6a2-503741a3e7f1@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 16, 2020 at 10:07:47AM -0700, Dave Hansen wrote:
> > +static u32 sgx_calc_ssa_frame_size(u32 miscselect, u64 xfrm)
> > +{
> > +	u32 size_max = PAGE_SIZE;
> > +	u32 size;
> > +	int i;
> > +
> > +	for (i = 2; i < 64; i++) {
> 
> Should this be:
> 
> 	for (i = XFEATURE_YMM; i < XFEATURE_MAX; i++) {
> 
> Basically, does this need to be 64, or should it be limited to the
> kernel-known XFEATURES?  Or, should this be looping through all the bits
> set in xfeatures_mask_user().

I think so yes.

> > +		if (!((1 << i) & xfrm))
> > +			continue;
> > +
> > +		size = SGX_SSA_GPRS_SIZE + sgx_xsave_size_tbl[i];
> > +
> > +		if (miscselect & SGX_MISC_EXINFO)
> > +			size += SGX_SSA_MISC_EXINFO_SIZE;
> > +
> > +		if (size > size_max)
> > +			size_max = size;
> > +	}
> > +
> > +	return PFN_UP(size_max);
> > +}
> > +
> > +static int sgx_validate_secs(const struct sgx_secs *secs)
> > +{
> 
> What's the overall point of this function?  Does it avoid a #GP from an
> instruction later?
> 
> Does all of the 'secs' content come from userspace?

Yes it does avoid #GP, and all the data comes from the user space.

> > +	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
> > +		       sgx_encl_size_max_64 : sgx_encl_size_max_32;
> > +
> > +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> > +		return -EINVAL;
> > +
> > +	if (secs->base & (secs->size - 1))
> > +		return -EINVAL;
> > +
> > +	if (secs->miscselect & sgx_misc_reserved_mask ||
> > +	    secs->attributes & sgx_attributes_reserved_mask ||
> > +	    secs->xfrm & sgx_xfrm_reserved_mask)
> > +		return -EINVAL;
> > +
> > +	if (secs->size > max_size)
> > +		return -EINVAL;
> > +
> > +	if (!(secs->xfrm & XFEATURE_MASK_FP) ||
> > +	    !(secs->xfrm & XFEATURE_MASK_SSE) ||
> > +	    (((secs->xfrm >> XFEATURE_BNDREGS) & 1) != ((secs->xfrm >> XFEATURE_BNDCSR) & 1)))
> > +		return -EINVAL;
> > +
> > +	if (!secs->ssa_frame_size)
> > +		return -EINVAL;
> > +
> > +	if (sgx_calc_ssa_frame_size(secs->miscselect, secs->xfrm) > secs->ssa_frame_size)
> > +		return -EINVAL;
> > +
> > +	if (memchr_inv(secs->reserved1, 0, sizeof(secs->reserved1)) ||
> > +	    memchr_inv(secs->reserved2, 0, sizeof(secs->reserved2)) ||
> > +	    memchr_inv(secs->reserved3, 0, sizeof(secs->reserved3)) ||
> > +	    memchr_inv(secs->reserved4, 0, sizeof(secs->reserved4)))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> 
> I think it would be nice to at least have one comment per condition to
> explain what's going on there.

OK, I can do that.

> 
> > +static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> > +{
> > +	struct sgx_epc_page *secs_epc;
> > +	struct sgx_pageinfo pginfo;
> > +	struct sgx_secinfo secinfo;
> > +	unsigned long encl_size;
> > +	struct file *backing;
> > +	long ret;
> > +
> > +	if (sgx_validate_secs(secs)) {
> > +		pr_debug("invalid SECS\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* The extra page goes to SECS. */
> > +	encl_size = secs->size + PAGE_SIZE;
> > +
> > +	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
> > +				   VM_NORESERVE);
> 
> What's the >>5 adjustment for?

The backing storage stores not only the swapped page but also
Paging Crypto MetaData (PCMD) structure. It essentially contains
a CPU encrypted MAC for a page.

The MAC is over page version and data. The version is stored in
a EPC page called Version Array (VA) page.

Both of these are needed by ENCLS[ELDU].

> 
> > +	if (IS_ERR(backing))
> > +		return PTR_ERR(backing);
> > +
> > +	encl->backing = backing;
> > +
> > +	secs_epc = __sgx_alloc_epc_page();
> > +	if (IS_ERR(secs_epc)) {
> > +		ret = PTR_ERR(secs_epc);
> > +		goto err_out_backing;
> > +	}
> > +
> > +	encl->secs.epc_page = secs_epc;
> > +
> > +	pginfo.addr = 0;
> > +	pginfo.contents = (unsigned long)secs;
> > +	pginfo.metadata = (unsigned long)&secinfo;
> > +	pginfo.secs = 0;
> > +	memset(&secinfo, 0, sizeof(secinfo));
> > +
> > +	ret = __ecreate((void *)&pginfo, sgx_get_epc_addr(secs_epc));
> > +	if (ret) {
> > +		pr_debug("ECREATE returned %ld\n", ret);
> > +		goto err_out;
> > +	}
> > +
> > +	if (secs->attributes & SGX_ATTR_DEBUG)
> > +		atomic_or(SGX_ENCL_DEBUG, &encl->flags);
> > +
> > +	encl->secs.encl = encl;
> > +	encl->base = secs->base;
> > +	encl->size = secs->size;
> > +	encl->ssaframesize = secs->ssa_frame_size;
> > +
> > +	/*
> > +	 * Set SGX_ENCL_CREATED only after the enclave is fully prepped.  This
> > +	 * allows setting and checking enclave creation without having to take
> > +	 * encl->lock.
> > +	 */
> > +	atomic_or(SGX_ENCL_CREATED, &encl->flags);
> 
> I'm wondering what the impact of setting this flag is.  That's hard to
> figure out because the flag isn't documented.
> 
> It's also unusual to have atomic_or() used like this.  The normal
> set_bit()/clear_bit() that you can use on an unsigned long are actually
> implemented as atomics.
> 
> I'm curious both why this needs to be atomics, *and* why the atomic_or()
> interface is being used.

Right, and this covers also test_and_change_bit() too (just checked).

So, I suppose we can.

> > +	return 0;
> > +
> > +err_out:
> > +	sgx_free_epc_page(encl->secs.epc_page);
> > +	encl->secs.epc_page = NULL;
> > +
> > +err_out_backing:
> > +	fput(encl->backing);
> > +	encl->backing = NULL;
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
> > + * @encl:	an enclave pointer
> > + * @arg:	userspace pointer to a struct sgx_enclave_create instance
> > + *
> > + * Allocate kernel data structures for a new enclave and execute ECREATE after
> > + * checking that the provided data for SECS meets the expectations of ECREATE
> > + * for an uninitialized enclave and size of the address space does not surpass the
> > + * platform expectations. This validation is done by sgx_validate_secs().
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   -errno otherwise
> > + */
> > +static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
> > +{
> > +	struct sgx_enclave_create ecreate;
> > +	struct page *secs_page;
> > +	struct sgx_secs *secs;
> > +	int ret;
> > +
> > +	if (atomic_read(&encl->flags) & SGX_ENCL_CREATED)
> > +		return -EINVAL;
> > +
> > +	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
> > +		return -EFAULT;
> > +
> > +	secs_page = alloc_page(GFP_KERNEL);
> > +	if (!secs_page)
> > +		return -ENOMEM;
> > +
> > +	secs = kmap(secs_page);
> 
> GFP_KERNEL pages are in low memory and don't need to be kmap()'d.
> 
> This can just be:
> 
> 	secs = __get_free_page(GFP_KERNEL);
> 	if (copy_from_user(secs, (void __user *)ecreate.src,...
> 
> and forget about the kmapping.  You also need to change __free_pages()
> to free_pages().
> 
> The other alternative would be to just kmalloc() it.  kmalloc()
> guarantees alignment in a stronger way than it used to.

Right, I'll change this, makes sense.

> 
> > +	if (copy_from_user(secs, (void __user *)ecreate.src, sizeof(*secs))) {
> > +		ret = -EFAULT;
> > +		goto out;
> > +	}
> > +
> > +	ret = sgx_encl_create(encl, secs);
> > +
> > +out:
> > +	kunmap(secs_page);
> > +	__free_page(secs_page);
> > +	return ret;
> > +}
> > +
> > +long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> > +{
> > +	struct sgx_encl *encl = filep->private_data;
> > +	int ret, encl_flags;
> > +
> > +	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
> > +	if (encl_flags & SGX_ENCL_IOCTL)
> > +		return -EBUSY;
> 
> Is the SGX_ENCL_IOCTL bit essentially just a lock to single-thread
> ioctl()s?  Should we name it as such?

Yes. It makes the concurrency overally easier if we can assume that
only a single ioctl is in progress. There is no good reason to do
them in parallel.

E.g. when you add pages you want to do that serially because the
order changes the MRENCLAVE.

So should I rename it as SGX_ENCL_IOCTL_LOCKED?

> > +	if (encl_flags & SGX_ENCL_DEAD) {
> > +		ret = -EFAULT;
> > +		goto out;
> > +	}
> > +
> > +	switch (cmd) {
> > +	case SGX_IOC_ENCLAVE_CREATE:
> > +		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
> > +		break;
> > +	default:
> > +		ret = -ENOIOCTLCMD;
> > +		break;
> > +	}
> > +
> > +out:
> > +	atomic_andnot(SGX_ENCL_IOCTL, &encl->flags);
> > +	return ret;
> > +}
> > 
> 


/Jarkko
