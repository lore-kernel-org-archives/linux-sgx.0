Return-Path: <SRS0=ohEA=EL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F88C388F9
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Nov 2020 01:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41B18221FA
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Nov 2020 01:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604538659;
	bh=lMfw07YaIe+dh+7s9oBPV38psJTZ7p1esC3tPIo+his=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=kKomb8bLxkTKMk6I/GJp3X52tXnYwnwb3TmoO+QF02OiKQ64FZCLFrMMWkGXt+T1R
	 IvWhAKOyIqeQpzVUQSIxSf4QYrzORWlfhe+7ITOgv1kaBELk2ILqOJaoXscO3aDYc3
	 DCk65CWvL/0gAs5aG14KSuSIscYQj5eNRQJON6J8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgKEBKz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 4 Nov 2020 20:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727698AbgKEBKz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 4 Nov 2020 20:10:55 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489FE20867;
        Thu,  5 Nov 2020 01:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604538654;
        bh=lMfw07YaIe+dh+7s9oBPV38psJTZ7p1esC3tPIo+his=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SSTA37CZVbn50FW+3/ykeNCf3SmnWE56MkAT56GFu+v0j5I/Z70UC9BbsWpAKnrRp
         vi+NNtXzjLVqCVzn4Gepo92C6mR3QuH1/Y8VsXZP3hLhfsBsXHt7hlJSzltlyBYaz5
         EM+sq8esZVtIfQWwrjciOKzJtqwCOT8yAwBUiuDY=
Date:   Thu, 5 Nov 2020 03:10:43 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v40 11/24] x86/sgx: Add SGX misc driver interface
Message-ID: <20201105011043.GA700495@kernel.org>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-12-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104145430.300542-12-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Noticed couple of minor glitches.

On Wed, Nov 04, 2020 at 04:54:17PM +0200, Jarkko Sakkinen wrote:
> +int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> +		     unsigned long end, unsigned long vm_flags)
> +{
> +	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
> +	struct sgx_encl_page *page;
> +	unsigned long count = 0;
> +	int ret = 0;
> +
> +	XA_STATE(xas, &encl->page_array, PFN_DOWN(start));
> +
> +	/*
> +	 * Disallow READ_IMPLIES_EXEC tasks as their VMA permissions might
> +	 * conflict with the enclave page permissions.
> +	 */
> +	if (current->personality & READ_IMPLIES_EXEC)
> +		return -EACCES;
> +
> +	mutex_lock(&encl->lock);
> +	xas_lock(&xas);
> +	xas_for_each(&xas, page, PFN_DOWN(end - 1)) {
> +		if (!page)
> +			break;

A redundant check, can be removed.

> +
> +		if (~page->vm_max_prot_bits & vm_prot_bits) {
> +			ret = -EACCES;
> +			break;
> +		}
> +
> +		/* Reschedule on every XA_CHECK_SCHED iteration. */
> +		if (!(++count % XA_CHECK_SCHED)) {
> +			xas_pause(&xas);
> +			xas_unlock(&xas);
> +			mutex_unlock(&encl->lock);
> +
> +			cond_resched();
> +
> +			mutex_lock(&encl->lock);
> +			xas_lock(&xas);
> +		}
> +	}
> +	xas_unlock(&xas);
> +	mutex_unlock(&encl->lock);
> +
> +	return ret;
> +}
> +
> +static int sgx_vma_mprotect(struct vm_area_struct *vma,
> +			    struct vm_area_struct **pprev, unsigned long start,
> +			    unsigned long end, unsigned long newflags)
> +{
> +	int ret;
> +
> +	ret = sgx_encl_may_map(vma->vm_private_data, start, end, newflags);
> +	if (ret)
> +		return ret;
> +
> +	return mprotect_fixup(vma, pprev, start, end, newflags);
> +}
> +
> +const struct vm_operations_struct sgx_vm_ops = {
> +	.fault = sgx_vma_fault,
> +	.mprotect = sgx_vma_mprotect,
> +};
> +
> +/**
> + * sgx_encl_find - find an enclave
> + * @mm:		mm struct of the current process
> + * @addr:	address in the ELRANGE
> + * @vma:	the resulting VMA
> + *
> + * Find an enclave identified by the given address. Give back a VMA that is
> + * part of the enclave and located in that address. The VMA is given back if it
> + * is a proper enclave VMA even if an &sgx_encl instance does not exist yet
> + * (enclave creation has not been performed).
> + *
> + * Return:
> + *   0 on success,
> + *   -EINVAL if an enclave was not found,
> + *   -ENOENT if the enclave has not been created yet
> + */
> +int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
> +		  struct vm_area_struct **vma)
> +{
> +	struct vm_area_struct *result;
> +	struct sgx_encl *encl;
> +
> +	result = find_vma(mm, addr);
> +	if (!result || result->vm_ops != &sgx_vm_ops || addr < result->vm_start)
> +		return -EINVAL;
> +
> +	encl = result->vm_private_data;
> +	*vma = result;
> +
> +	return encl ? 0 : -ENOENT;
> +}

Since v20 there has been 1:1 assocition between enclaves and files.
In other words, this can never return -ENOENT.

With this reduction the function turns into:

int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
		  struct vm_area_struct **vma)
{
	struct vm_area_struct *result;

	result = find_vma(mm, addr);
	if (!result || result->vm_ops != &sgx_vm_ops || addr < result->vm_start)
		return -EINVAL;

	*vma = result;

	return 0;
}

There are only two call sites:

1. sgx_encl_test_and_clear_young()
2. sgx_reclaimer_block()

I.e. would not be a big trouble to tune the signature a bit:

struct vm_area_struct *sgx_encl_find_vma(struct mm_struct *mm, unsigned long addr)
{
	struct vm_area_struct *result;

	result = find_vma(mm, addr);
	if (!result || result->vm_ops != &sgx_vm_ops || addr < result->vm_start)
		return NULL;

	return result;
}

There is a function called sgx_encl_find_mm(), which is *unrelated* to
this function and has only one call sites. Its flow is very linear. In
order to avoid confusion, I'd open code that into sgx_encl_mm_add().

/Jarkko
