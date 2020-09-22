Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDB9C2D0E2
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 10:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D21FE2073A
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 10:45:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="E3uvcZBI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgIVKpq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 06:45:46 -0400
Received: from mail.skyhub.de ([5.9.137.197]:56408 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgIVKpq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Sep 2020 06:45:46 -0400
Received: from zn.tnic (p200300ec2f0bfb00b5db4aa9bc6d967b.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:fb00:b5db:4aa9:bc6d:967b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 13FE41EC0114;
        Tue, 22 Sep 2020 12:45:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600771544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KV+AIznwncL3m4lCijPPkTe9M8NJxOjO/EQJQDekkzE=;
        b=E3uvcZBIX6xBAvVy9ljLvAVUwswlqj57o9mJK528BSkjPOEW6tf+TrwfVpMFrF+/P2CnV0
        H6K2W7hIwVrk9gjxW9Je7Ydj/CWa1UabCXdsDbofeH4NdZIAyl74m5Rh4ke89D5PUfFhz4
        wFiqD32dr0Ktwx9duXavENPjkaxmAlQ=
Date:   Tue, 22 Sep 2020 12:45:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 16/24] x86/sgx: Add a page reclaimer
Message-ID: <20200922104538.GE22660@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-17-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200915112842.897265-17-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 02:28:34PM +0300, Jarkko Sakkinen wrote:
> There is a limited amount of EPC available. Therefore, some of it must be
> copied to the regular memory, and only subset kept in the SGX reserved
> memory. While kernel cannot directly access enclave memory, SGX provides a
> set of ENCLS leaf functions to perform reclaiming.
> 
> This commits implements a page reclaimer by using these leaf functions. It

s/This commits implements/Implement/

> picks the victim pages in LRU fashion from all the enclaves running in the
> system. The thread ksgxswapd reclaims pages on the event when the number of
> free EPC pages goes below SGX_NR_LOW_PAGES up until it reaches
> SGX_NR_HIGH_PAGES.

...

Had to grep the SDM for that "eldu" magic. It could use a comment:

/*
 * ELDU: Load an EPC page as unblocked. For more info, see "OS
 * Management of EPC Pages" in the SDM.
 */

or so, to denote what's going on here.

> +static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
> +					  struct sgx_epc_page *secs_page)
> +{
> +	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
> +	struct sgx_encl *encl = encl_page->encl;
> +	struct sgx_epc_page *epc_page;
> +	int ret;
> +
> +	epc_page = sgx_alloc_epc_page(encl_page, false);
> +	if (IS_ERR(epc_page))
> +		return epc_page;
> +
> +	ret = __sgx_encl_eldu(encl_page, epc_page, secs_page);
> +	if (ret) {
> +		sgx_free_epc_page(epc_page);
> +		return ERR_PTR(ret);
> +	}
> +
> +	sgx_free_va_slot(encl_page->va_page, va_offset);
> +	list_move(&encl_page->va_page->list, &encl->va_pages);
> +	encl_page->desc &= ~SGX_ENCL_PAGE_VA_OFFSET_MASK;
> +	encl_page->epc_page = epc_page;
> +
> +	return epc_page;
> +}

...

> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index 0448d22d3010..11dcf4e7fb3e 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -19,6 +19,10 @@
>  
>  /**
>   * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
> + * %SGX_ENCL_PAGE_RECLAIMED:		The page is in the process of being
> + *					reclaimed.

SGX_ENCL_PAGE_RECLAIMED means, tho, that the page has been reclaimed
already.

I guess that reads better:

+		if (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)
+			return ERR_PTR(-EBUSY);


> + * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version Array
> + *					(VA) page for a swapped page.
>   * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
>   *
>   * The page address for SECS is zero and is used by the subsystem to recognize

...

> @@ -86,24 +123,34 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>  {
>  	unsigned long encl_size = secs->size + PAGE_SIZE;
>  	struct sgx_epc_page *secs_epc;
> +	struct sgx_va_page *va_page;
>  	struct sgx_pageinfo pginfo;
>  	struct sgx_secinfo secinfo;
>  	struct file *backing;
>  	long ret;
>  
> +	va_page = sgx_encl_grow(encl);
> +	if (IS_ERR(va_page))
> +		return PTR_ERR(va_page);
> +	else if (va_page)

Not "else" simply?

AFAICT, sgx_encl_grow() would either return an ERR_PTR or the actual
page...

Also, should the growing happen *after* the SECS validation?

> +		list_add(&va_page->list, &encl->va_pages);
> +
>  	if (sgx_validate_secs(secs)) {
>  		pr_debug("invalid SECS\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto err_out_shrink;
>  	}
>  
>  	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
>  				   VM_NORESERVE);
> -	if (IS_ERR(backing))
> -		return PTR_ERR(backing);
> +	if (IS_ERR(backing)) {
> +		ret = PTR_ERR(backing);
> +		goto err_out_shrink;
> +	}
>  
>  	encl->backing = backing;
>  
> -	secs_epc = __sgx_alloc_epc_page();
> +	secs_epc = sgx_alloc_epc_page(&encl->secs, true);
>  	if (IS_ERR(secs_epc)) {
>  		ret = PTR_ERR(secs_epc);
>  		goto err_out_backing;
> @@ -151,6 +198,9 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>  	fput(encl->backing);
>  	encl->backing = NULL;
>  
> +err_out_shrink:
> +	sgx_encl_shrink(encl, va_page);
> +
>  	return ret;
>  }

...


Let's add some comment blurb about "Write back/invalidate an EPC page"
to at least start to explain what that "ewb" is.

> +static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
> +			 struct sgx_backing *backing)
> +{
> +	struct sgx_encl_page *encl_page = epc_page->owner;
> +	struct sgx_encl *encl = encl_page->encl;
> +	struct sgx_va_page *va_page;
> +	unsigned int va_offset;
> +	void *va_slot;
> +	int ret;
> +
> +	encl_page->desc &= ~SGX_ENCL_PAGE_RECLAIMED;
> +
> +	va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
> +				   list);
> +	va_offset = sgx_alloc_va_slot(va_page);
> +	va_slot = sgx_get_epc_addr(va_page->epc_page) + va_offset;
> +	if (sgx_va_page_full(va_page))
> +		list_move_tail(&va_page->list, &encl->va_pages);
> +
> +	ret = __sgx_encl_ewb(epc_page, va_slot, backing);
> +	if (ret == SGX_NOT_TRACKED) {
> +		ret = __etrack(sgx_get_epc_addr(encl->secs.epc_page));
> +		if (ret) {
> +			if (encls_failed(ret))
> +				ENCLS_WARN(ret, "ETRACK");
> +		}
> +
> +		ret = __sgx_encl_ewb(epc_page, va_slot, backing);
> +		if (ret == SGX_NOT_TRACKED) {
> +			/*
> +			 * Slow path, send IPIs to kick cpus out of the
> +			 * enclave.  Note, it's imperative that the cpu
> +			 * mask is generated *after* ETRACK, else we'll
> +			 * miss cpus that entered the enclave between
> +			 * generating the mask and incrementing epoch.
> +			 */
> +			on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
> +					 sgx_ipi_cb, NULL, 1);
> +			ret = __sgx_encl_ewb(epc_page, va_slot, backing);
> +		}
> +	}
> +
> +	if (ret) {
> +		if (encls_failed(ret))
> +			ENCLS_WARN(ret, "EWB");
> +
> +		sgx_free_va_slot(va_page, va_offset);
> +	} else {
> +		encl_page->desc |= va_offset;
> +		encl_page->va_page = va_page;
> +	}

...

> +static void sgx_reclaim_pages(void)
> +{
> +	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
> +	struct sgx_backing backing[SGX_NR_TO_SCAN];
> +	struct sgx_epc_section *section;
> +	struct sgx_encl_page *encl_page;
> +	struct sgx_epc_page *epc_page;
> +	int cnt = 0;
> +	int ret;
> +	int i;
> +
> +	spin_lock(&sgx_active_page_list_lock);
> +	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
> +		if (list_empty(&sgx_active_page_list))

Isn't it enough to do this once, i.e., not in the loop? You're holding
sgx_active_page_list_lock...

> +			break;
> +
> +		epc_page = list_first_entry(&sgx_active_page_list,
> +					    struct sgx_epc_page, list);
> +		list_del_init(&epc_page->list);
> +		encl_page = epc_page->owner;
> +
> +		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
> +			chunk[cnt++] = epc_page;
> +		else
> +			/* The owner is freeing the page. No need to add the
> +			 * page back to the list of reclaimable pages.
> +			 */
> +			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> +	}
> +	spin_unlock(&sgx_active_page_list_lock);
> +
> +	for (i = 0; i < cnt; i++) {
> +		epc_page = chunk[i];
> +		encl_page = epc_page->owner;
> +
> +		if (!sgx_reclaimer_age(epc_page))
> +			goto skip;
> +
> +		ret = sgx_encl_get_backing(encl_page->encl,
> +					   SGX_ENCL_PAGE_INDEX(encl_page),
> +					   &backing[i]);
> +		if (ret)
> +			goto skip;
> +
> +		mutex_lock(&encl_page->encl->lock);
> +		encl_page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> +		mutex_unlock(&encl_page->encl->lock);
> +		continue;
> +
> +skip:
> +		spin_lock(&sgx_active_page_list_lock);
> +		list_add_tail(&epc_page->list, &sgx_active_page_list);
> +		spin_unlock(&sgx_active_page_list_lock);
> +
> +		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> +
> +		chunk[i] = NULL;
> +	}
> +
> +	for (i = 0; i < cnt; i++) {
> +		epc_page = chunk[i];
> +		if (epc_page)
> +			sgx_reclaimer_block(epc_page);
> +	}
> +
> +	for (i = 0; i < cnt; i++) {
> +		epc_page = chunk[i];
> +		if (!epc_page)
> +			continue;
> +
> +		encl_page = epc_page->owner;
> +		sgx_reclaimer_write(epc_page, &backing[i]);
> +		sgx_encl_put_backing(&backing[i], true);
> +
> +		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> +		epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> +
> +		section = sgx_get_epc_section(epc_page);
> +		spin_lock(&section->lock);
> +		list_add_tail(&epc_page->list, &section->page_list);
> +		section->free_cnt++;
> +		spin_unlock(&section->lock);
> +	}
> +}
> +
>  
>  static void sgx_sanitize_section(struct sgx_epc_section *section)

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
