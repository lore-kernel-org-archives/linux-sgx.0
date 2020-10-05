Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB230C4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 11:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 742C9206CB
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 11:11:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FR7dfmGQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgJELLn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 07:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgJELLn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 5 Oct 2020 07:11:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F79C0613CE
        for <linux-sgx@vger.kernel.org>; Mon,  5 Oct 2020 04:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=F1ZThjlgYLYCDTOB9pq09VqvMHTtdRkQ3vfaoG5T4TA=; b=FR7dfmGQVtvd/RkjSW32Yt0e4u
        4RRHZVyxvvEzjZzLDfQD8fEQ+qHie3npko8h+hOCA8c8k/FmeAp6wFu82UIoDkGzn5EsBYyZjg5GO
        IrIlrqXQv0KzM7kcdLChRhDjGDrxI6AyFu7kwXgxvS49ek/IVK+o3mFaqjWKUeI9s+tqaofOa9v+U
        cdBd5vMgCO7ohU8W+JCkx8Q7JKbsb+Ob0YQB5ZWF0Bz6vVml5nxQxgzntPkFXj68HUr8DgAESS1JY
        vZYORFxGS6Z0RgMl17dvJNeKyyewVGngroLuHbB6mna889ixBDiByF31R3e0qdZWM94NoheVut4ql
        Y3NSKOvQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPOP5-0002Kt-WD; Mon, 05 Oct 2020 11:11:40 +0000
Date:   Mon, 5 Oct 2020 12:11:39 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] Fix the issue further discussed in:
Message-ID: <20201005111139.GK20115@casper.infradead.org>
References: <20201005031759.143544-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005031759.143544-1-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 06:17:59AM +0300, Jarkko Sakkinen wrote:
> @@ -317,10 +318,31 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
>  	if (current->personality & READ_IMPLIES_EXEC)
>  		return -EACCES;
>  
> -	xas_for_each(&xas, page, idx_end)
> +	/*
> +	 * No need to hold encl->lock:
> +	 * 1. None of the page->* get written.
> +	 * 2. page->vm_max_prot_bits is set in sgx_encl_page_alloc(). This
> +	 *    is before calling xa_insert(). After that it is never modified.
> +	 */
> +	xas_lock(&xas);
> +	xas_for_each(&xas, page, idx_end) {
> +		if (++count % XA_CHECK_SCHED)
> +			continue;

This really doesn't do what you think it does.

	int ret = 0;
	int count = 0;

	xas_lock(&xas);
	while (xas.index < idx_end) {
		struct sgx_page *page = xas_next(&xas);

		if (!page || (~page->vm_max_prot_bits & vm_prot_bits)) {
			ret = -EACCESS;
			break;
		}

		if (++count % XA_CHECK_SCHED)
			continue;
		xas_pause(&xas);
		xas_unlock(&xas);
		cond_resched();
		xas_lock(&xas);
	}
	xas_unlock(&xas);

	return ret;
