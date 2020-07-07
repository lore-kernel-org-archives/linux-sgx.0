Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCD6C433DF
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F271B20734
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UfU43NEe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgGGDgX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Jul 2020 23:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgGGDgX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 6 Jul 2020 23:36:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD4FC061755;
        Mon,  6 Jul 2020 20:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Hp0xGFRg77TXwsB3gqqzb9MGA43cz2VdahzAAJzi0C8=; b=UfU43NEeuLUEoytxjSntGO6Gzk
        sbsi6DFnUdK6kq9AJR9S6DyW32HokIEIiN5sBJoZWDyC9V2Ai7hBtERKDxE8NKOm7AZB/EYHjEfwy
        h5Kyzez1BnSeBHbU9x/NaAcg+O9lQxh6g0NlmF0T/1bIR9mKnpRu1anZkc6VYFlzXdlSbYSxXYEi9
        vIs14/VkgGfHev3oXyqUrMEzEQk5bQkDmYKRedOkVWhyAaotklO41woLgoC5ea+ZLzWesOa6sLY3E
        tYHCICPTdXK+mxfEd2nht15OvfmGseeOLgBQnfXCfBl9b12Hp7roXNarZXRi9OMvi6Vm8WhNrkKZA
        c7P2G+UA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jseP3-0003v8-VO; Tue, 07 Jul 2020 03:36:18 +0000
Date:   Tue, 7 Jul 2020 04:36:17 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v34 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20200707033617.GF25523@casper.infradead.org>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-12-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707030204.126021-12-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 07, 2020 at 06:01:51AM +0300, Jarkko Sakkinen wrote:
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the SGX hosted software entity is disallowed to

s/disallowed to/prevented from/

> access the memory inside the enclave enforced by the CPU. We call these

s/enforced//

> entities enclaves.
> 
> Add a driver that provides an ioctl API to construct and run enclaves.
> Enclaves are constructed from pages residing in reserved physical memory
> areas. The contents of these pages can only be accessed when they are
> mapped as part of an enclave, by a hardware thread running inside the
> enclave.
> 
> The starting state of an enclave consists of a fixed measured set of
> pages that are copied to the EPC during the construction process by
> using ENCLS leaf functions and Software Enclave Control Structure (SECS)
> that defines the enclave properties.
> 
> Enclaves are constructed by using ENCLS leaf functions ECREATE, EADD and
> EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
> the EPC and EINIT checks a given signed measurement and moves the enclave
> into a state ready for execution.

What's a leaf function?  Is it like a CPU instruction?

> The mmap() permissions are capped by the contained enclave page
> permissions. The mapped areas must also be opaque, i.e. each page address
> must contain a page. This logic is implemented in sgx_encl_may_map().

do you mean "populated" instead of "opaque"?

> +	atomic_set(&encl->flags, 0);
> +	kref_init(&encl->refcount);
> +	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);

Why are you using a radix tree instead of an xarray?

> +int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> +		     unsigned long end, unsigned long vm_prot_bits)
> +{
> +	unsigned long idx, idx_start, idx_end;
> +	struct sgx_encl_page *page;
> +
> +	/*
> +	 * Disallow RIE tasks as their VMA permissions might conflict with the
> +	 * enclave page permissions.
> +	 */
> +	if (!!(current->personality & READ_IMPLIES_EXEC))
> +		return -EACCES;
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

You should really use an iterator here instead of repeated lookups.
xas_for_each() will probably be what you want.

