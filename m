Return-Path: <SRS0=z1MW=4H=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99996C34022
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Feb 2020 03:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 701DC24658
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Feb 2020 03:26:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="r4+Kljkj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgBSD0d (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Feb 2020 22:26:33 -0500
Received: from linux.microsoft.com ([13.77.154.182]:57678 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgBSD0d (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 18 Feb 2020 22:26:33 -0500
Received: from [10.131.86.135] (unknown [131.107.147.135])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0583320B9C02;
        Tue, 18 Feb 2020 19:26:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0583320B9C02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1582082792;
        bh=uuBpz3jOBtISlExYRZ5CqsTuMHXduhDBZyDX+rs/0uQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=r4+Kljkj3skkGozxptnCeqBISH4etkGbNOxIcfgS+/o/90eMCoq3t1A2A5COFzzXG
         mJbybAOHJibpTMVy387FTD752QW333+M3SVUE4+lbrNYFKb9xs/ILOj6KymE70x/6F
         xkbgPuYBmjF4z7NCm+gkRGWFl6nQRL3QKQHqzwsM=
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
From:   Jordan Hand <jorhand@linux.microsoft.com>
Message-ID: <15074c16-4832-456d-dd12-af8548e46d6d@linux.microsoft.com>
Date:   Tue, 18 Feb 2020 19:26:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

I ran our validation tests for the Open Enclave SDK against this patch
set and came across a potential issue.

On 2/9/20 1:25 PM, Jarkko Sakkinen wrote:
> +/**
> + * sgx_encl_may_map() - Check if a requested VMA mapping is allowed
> + * @encl:		an enclave
> + * @start:		lower bound of the address range, inclusive
> + * @end:		upper bound of the address range, exclusive
> + * @vm_prot_bits:	requested protections of the address range
> + *
> + * Iterate through the enclave pages contained within [@start, @end) to verify
> + * the permissions requested by @vm_prot_bits do not exceed that of any enclave
> + * page to be mapped.  Page addresses that do not have an associated enclave
> + * page are interpreted to zero permissions.
> + *
> + * Return:
> + *   0 on success,
> + *   -EACCES if VMA permissions exceed enclave page permissions
> + */
> +int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> +		     unsigned long end, unsigned long vm_prot_bits)
> +{
> +	unsigned long idx, idx_start, idx_end;
> +	struct sgx_encl_page *page;
> +
> +	/* PROT_NONE always succeeds. */
> +	if (!vm_prot_bits)
> +		return 0;
> +
> +	idx_start = PFN_DOWN(start);
> +	idx_end = PFN_DOWN(end - 1);
> +
> +	for (idx = idx_start; idx <= idx_end; ++idx) {
> +		mutex_lock(&encl->lock);
> +		page = radix_tree_lookup(&encl->page_tree, idx);
> +		mutex_unlock(&encl->lock);
> +
> +		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> +			return -EACCES;
> +	}
> +
> +	return 0;
> +}
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
> +
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

During mprotect (in mm/mprotect.c line 525) the following checks if
READ_IMPLIES_EXECUTE and a PROT_READ is being requested. If so and
VM_MAYEXEC is set, it also adds PROT_EXEC to the request.

	if (rier && (vma->vm_flags & VM_MAYEXEC))
		prot |= PROT_EXEC;

But if we look at sgx_encl_page_alloc(), we see vm_max_prot_bits is set
without taking VM_MAYEXEC into account:

	encl_page->vm_max_prot_bits = calc_vm_prot_bits(prot, 0);

sgx_encl_may_map() checks that the requested protection can be added with:

	if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
		return -EACCESS

This means that for any process where READ_IMPLIES_EXECUTE is set and
page where (vma->vm_flags & VM_MAYEXEC) == true, mmap/mprotect calls to
that request PROT_READ on a page that was not added with PROT_EXEC will
fail.

- Jordan
