Return-Path: <SRS0=bCPb=AH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E133AC433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 15:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B448B2080C
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 15:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="kwqJPEeQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgFZPeJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 26 Jun 2020 11:34:09 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45830 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgFZPeI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 26 Jun 2020 11:34:08 -0400
Received: from zn.tnic (p200300ec2f0d1400bc333d3023e61f63.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1400:bc33:3d30:23e6:1f63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4013A1EC0328;
        Fri, 26 Jun 2020 17:34:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593185646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lptL648Q3VO1TOdmWl0P3XL1W5sSUcOH5yZa95Laca8=;
        b=kwqJPEeQDNUT4pbXVCb9g7B2zJpeRooaEb3OZk8w8RzcHsQ4TggDqUoLTHAZMwJoiKZqw1
        YivkwySYuRDxGU0kqv0G/RIPHuSvSnFkFvsvrcHFcZvBrhvIhWpKt5SzUvWRBX/m7gCgmN
        rNCA6akWo3iP775uhvZDs4SLuKsMrrY=
Date:   Fri, 26 Jun 2020 17:34:00 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200626153400.GE27151@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:

...

This could use some commenting along the lines of:

"— If the enclave developer requires measurement of the page as a
proof for the content, use EEXTEND to add a measurement for 256 bytes of
the page. Repeat this operation until the entire page is measured."

At least this text from the SDM maps to the 256 bytes below. Otherwise
it is magic.

> +static int __sgx_encl_extend(struct sgx_encl *encl,
> +			     struct sgx_epc_page *epc_page)
> +{
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < 16; i++) {
> +		ret = __eextend(sgx_get_epc_addr(encl->secs.epc_page),
> +				sgx_get_epc_addr(epc_page) + (i * 0x100));
> +		if (ret) {
> +			if (encls_failed(ret))
> +				ENCLS_WARN(ret, "EEXTEND");
> +			return -EIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> +			     unsigned long offset, unsigned long length,
> +			     struct sgx_secinfo *secinfo, unsigned long flags)
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
> +
> +	if (atomic_read(&encl->flags) &
> +	    (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
> +		ret = -EFAULT;
> +		goto err_out_free;
> +	}

You can do this first thing when you enter the function so that
you don't have to allocate needlessly in the error case, when
SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD is set.

> +
> +	mmap_read_lock(current->mm);
> +	mutex_lock(&encl->lock);
> +
> +	/*
> +	 * Insert prior to EADD in case of OOM.  EADD modifies MRENCLAVE, i.e.
> +	 * can't be gracefully unwound, while failure on EADD/EXTEND is limited
> +	 * to userspace errors (or kernel/hardware bugs).
> +	 */
> +	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
> +				encl_page);
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
> +	 * isn't in a half-baked state in the extremely unlikely scenario the
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
> +
> +	mutex_unlock(&encl->lock);
> +	mmap_read_unlock(current->mm);
> +	return ret;
> +
> +err_out:
> +	radix_tree_delete(&encl_page->encl->page_tree,
> +			  PFN_DOWN(encl_page->desc));
> +
> +err_out_unlock:
> +	mutex_unlock(&encl->lock);
> +	mmap_read_unlock(current->mm);
> +
> +err_out_free:
> +	sgx_free_epc_page(epc_page);
> +	kfree(encl_page);
> +
> +	/*
> +	 * Destroy enclave on ENCLS failure as this means that EPC has been
> +	 * invalidated.
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
> +/**
> + * sgx_ioc_enclave_add_pages() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGES
> + * @encl:       pointer to an enclave instance (via ioctl() file pointer)
> + * @arg:	a user pointer to a struct sgx_enclave_add_pages instance
> + *
> + * Add one or more pages to an uninitialized enclave, and optionally extend the

"uninitialized"?

Where is the test for SGX_ENCL_INITIALIZED and erroring out otherwise?

I.e., what happens if you add pages to an initialized enclave?

> + * measurement with the contents of the page. The address range of pages must
> + * be contiguous.

Must? Who is enforcing this? I'm trying to find where...

> The SECINFO and measurement mask are applied to all pages.
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
> + * If ENCLS opcode fails, that effectively means that EPC has been invalidated.
> + * When this happens the enclave is destroyed and -EIO is returned to the
> + * caller.
> + *
> + * Return:
> + *   0 on success,
> + *   -EACCES if an executable source page is located in a noexec partition,
> + *   -EIO if either ENCLS[EADD] or ENCLS[EEXTEND] fails
> + *   -errno otherwise
> + */
> +static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
> +{
> +	struct sgx_enclave_add_pages addp;
> +	struct sgx_secinfo secinfo;
> +	unsigned long c;
> +	int ret;
> +
> +	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&addp, arg, sizeof(addp)))
> +		return -EFAULT;
> +
> +	if (!IS_ALIGNED(addp.offset, PAGE_SIZE) ||
> +	    !IS_ALIGNED(addp.src, PAGE_SIZE))
> +		return -EINVAL;
> +
> +	if (!(access_ok(addp.src, PAGE_SIZE)))
> +		return -EFAULT;
> +
> +	if (addp.length & (PAGE_SIZE - 1))
> +		return -EINVAL;

How many pages are allowed? Unlimited? I'm hoping some limits are
checked somewhere...

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
> +			ret = -EINTR;
> +			break;
> +		}
> +
> +		if (need_resched())
> +			cond_resched();
> +
> +		ret = sgx_encl_add_page(encl, addp.src + c, addp.offset + c,
> +					addp.length - c, &secinfo, addp.flags);
> +		if (ret)
> +			break;
> +	}
> +
> +	addp.count = c;
> +
> +	if (copy_to_user(arg, &addp, sizeof(addp)))
> +		return -EFAULT;
> +
> +	return ret;
> +}
> +
-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
