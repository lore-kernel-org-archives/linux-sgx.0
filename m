Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4666DC4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 14:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1046B205F4
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 14:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WCeoFFDb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgJEOM5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 10:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgJEOM5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 5 Oct 2020 10:12:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C14C0613CE
        for <linux-sgx@vger.kernel.org>; Mon,  5 Oct 2020 07:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5TuOPBNUbBRAJMMBLTJFw8fxPCEcRsnpEHgAKrQ+zrU=; b=WCeoFFDbWsaAOe8YZ0TJ8uP91A
        Od4sJtYXCyZDrm4tQe9JsF2ATuA+SQjk0HXn3oozQJ3MpM2clrw+vqqUf+DAI8YA/CJo9GxDppsFe
        Zvp6rWeduvyBWAyAXK1u6ubiXCgghSi3j5qgekEecgMzsNj4mgv6L7PIiTd0J8kpyqYY0tQHBwN34
        /oFaQ9zxFGcxfhlzN7Z7k+Qxz1ZTpqV2yRv9G0kUq+/VbieEcy3yCfxyKWQ9euP8aIVDEBBFp+V+Z
        KIoXUtkOZPNXKRoVWL3+3yhkjK/6zmiSeprqBo4g9voOpDp/mt82XG0zu7v2asPc3q+ALqX4RSpZx
        2ZQYKrIA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPREU-00050m-KV; Mon, 05 Oct 2020 14:12:54 +0000
Date:   Mon, 5 Oct 2020 15:12:54 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3] x86/sgx: Fix sgx_encl_may_map locking
Message-ID: <20201005141254.GL20115@casper.infradead.org>
References: <20201005141119.5395-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005141119.5395-1-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 05:11:19PM +0300, Jarkko Sakkinen wrote:
> Fix the issue further discussed in:

No, this is still utter crap.  Just use the version I sent.

> 1. https://lore.kernel.org/linux-sgx/op.0rwbv916wjvjmi@mqcpg7oapc828.gar.corp.intel.com/
> 2. https://lore.kernel.org/linux-sgx/20201003195440.GD20115@casper.infradead.org/
> 
> Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Jethro Beekman <jethro@fortanix.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> v3:
> * Added the missing unlock pointed out by Matthew.
> * Tested with the correct patch (last time had v1 applied)
> * I don't know what happened to v2 changelog, checked from patchwork
>   and it wasn't there. Hope this is not scraped.
>  arch/x86/kernel/cpu/sgx/encl.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 4c6407cd857a..e91e521b03a8 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -307,6 +307,8 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
>  	unsigned long idx_start = PFN_DOWN(start);
>  	unsigned long idx_end = PFN_DOWN(end - 1);
>  	struct sgx_encl_page *page;
> +	unsigned long count = 0;
> +	int ret = 0;
>  
>  	XA_STATE(xas, &encl->page_array, idx_start);
>  
> @@ -317,11 +319,30 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
>  	if (current->personality & READ_IMPLIES_EXEC)
>  		return -EACCES;
>  
> -	xas_for_each(&xas, page, idx_end)
> -		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> -			return -EACCES;
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
>  
> -	return 0;
> +		if (!page || (~page->vm_max_prot_bits & vm_prot_bits)) {
> +			ret = -EACCES;
> +			break;
> +		}
> +
> +		xas_pause(&xas);
> +		xas_unlock(&xas);
> +		cond_resched();
> +		xas_lock(&xas);
> +	}
> +	xas_unlock(&xas);
> +
> +	return ret;
>  }
>  
>  static int sgx_vma_mprotect(struct vm_area_struct *vma,
> -- 
> 2.25.1
> 
