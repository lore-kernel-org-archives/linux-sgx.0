Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2B4C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 19 May 2022 22:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiESWBa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 May 2022 18:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbiESWB2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 19 May 2022 18:01:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A7B8720D
        for <linux-sgx@vger.kernel.org>; Thu, 19 May 2022 15:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3B4960F4B
        for <linux-sgx@vger.kernel.org>; Thu, 19 May 2022 22:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AD8C385B8;
        Thu, 19 May 2022 22:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652997685;
        bh=0hl4SEUSAL083cd5qr0VLLzvJKqxDS0j8VUrUhkrqUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WyTRsM47ksHp2yfzd9Dz0TucB3PXUXvFNTRZwNtAf5BV8tLMxTgehpqUAZfrQfs68
         ZL7+g5ln2ZWTaoJ6rb7tuIti5er98oKlTS9JaLzkVeW6phZwUBUa/CXN2r8Q1BGsn5
         DXFpQVlfxsuoh3D0glTIZb9lW8XQQYTF5NmnyR/suEmKtCklB82JDp+ySevQ/AOlKC
         VYvs6TyiP+l+rEfCa4rM1KarVWLHTOzt4/sCzJJwHTR/20OL0NSiu6P9xDyJIvq+70
         aDWPfIrC06IHN10DDyD6ntUPj+4OCZvSSKAGGS/+890NMr2QH+IFhPLKpIwWkRUUB/
         jdwhV7vu0+9LA==
Date:   Fri, 20 May 2022 00:59:46 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com
Subject: Re: [PATCH v2 2/4] x86/sgx: add struct sgx_vepc_page to manage EPC
 pages for vepc
Message-ID: <Yoa90l89OTQX0NYk@iki.fi>
References: <20220519031137.245767-1-zhiquan1.li@intel.com>
 <Yoa76TmwHPeS7vRG@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yoa76TmwHPeS7vRG@iki.fi>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 20, 2022 at 12:51:40AM +0300, Jarkko Sakkinen wrote:
> On Thu, May 19, 2022 at 11:11:37AM +0800, Zhiquan Li wrote:
> > Current SGX data structures are insufficient to track the EPC pages for
> > vepc. For example, if we want to retrieve the virtual address of an EPC
> > page allocated to an enclave on host, we can find this info from its
> > owner, the 'desc' field of struct sgx_encl_page. However, if the EPC
> > page is allocated to a KVM guest, this is not available, as their owner
> > is a shared vepc.
> 
> Interesting, but this does not explain what is the motivation to make
> this information available for consumption.
>  
> > So, we introduce struct sgx_vepc_page which can be the owner of EPC
> > pages for vepc and saves the useful info of EPC pages for vepc, like
> > struct sgx_encl_page.
> 
> Instead of "we introduce", write "introduce". The actions taken should
> be always in imperative form.
> 
> > Canonical memory failure collects victim tasks by iterating all the
> > tasks one by one and use reverse mapping to get victim tasks' virtual
> > address.
> > 
> > This is not necessary for SGX - as one EPC page can be mapped to ONE
> > enclave only. So, this 1:1 mapping enforcement allows us to find task
> > virtual address with physical address directly. Even though an enclave
> > has been shared by multiple processes, the virtual address is the same.
> > 
> 
> Isn't the point put in simple terms that in order to inject #MC, the
> virtual address is required. Then, arch_memory_failure() can easily
> retrieve it.
> 
> This is the motivation to do this, and it's completely missing from
> above, not a single word about it. I would delete most of it and focus
> on motivation and application.
> 
> > Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> > ---
> > Changes since V1:
> > - Add documentation suggested by Jarkko.
> > - Revise the commit message.
> > ---
> >  arch/x86/kernel/cpu/sgx/sgx.h  | 15 +++++++++++++++
> >  arch/x86/kernel/cpu/sgx/virt.c | 24 +++++++++++++++++++-----
> >  2 files changed, 34 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> > index ad3b455ed0da..9a4292168389 100644
> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > @@ -28,6 +28,8 @@
> >  
> >  /* Pages on free list */
> >  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
> > +/* Pages is used by VM guest */
> > +#define SGX_EPC_PAGE_IS_VEPC		BIT(2)
> >  
> >  struct sgx_epc_page {
> >  	unsigned int section;
> > @@ -114,4 +116,17 @@ struct sgx_vepc {
> >  	struct mutex lock;
> >  };
> >  
> > +/**
> > + * struct sgx_vepc_page - SGX virtual EPC page structure
> > + * @vaddr:		the virtual address when the EPC page was mapped
> > + * @vepc:		the owner of the virtual EPC page
> > + *
> > + * When a virtual EPC page is allocated to guest, we use this structure
> > + * to track the associated information on host, like struct sgx_encl_page.
> > + */
> > +struct sgx_vepc_page {
> > +	unsigned long vaddr;
> > +	struct sgx_vepc *vepc;
> > +};
> > +
> >  #endif /* _X86_SGX_H */
> > diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> > index c9c8638b5dc4..d7945a47ced8 100644
> > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > @@ -29,6 +29,7 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
> >  			    struct vm_area_struct *vma, unsigned long addr)
> >  {
> >  	struct sgx_epc_page *epc_page;
> > +	struct sgx_vepc_page *owner;
> >  	unsigned long index, pfn;
> >  	int ret;
> >  
> > @@ -41,13 +42,22 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
> >  	if (epc_page)
> >  		return 0;
> >  
> > -	epc_page = sgx_alloc_epc_page(vepc, false);
> > -	if (IS_ERR(epc_page))
> > -		return PTR_ERR(epc_page);
> > +	owner = kzalloc(sizeof(*owner), GFP_KERNEL);
> > +	if (!owner)
> > +		return -ENOMEM;
> > +	owner->vepc = vepc;
> > +	owner->vaddr = addr & PAGE_MASK;
> 
> By addr would have lower 12 bits set, isn't it a page address?
> 
> > +
> > +	epc_page = sgx_alloc_epc_page(owner, false);
> > +	if (IS_ERR(epc_page)) {
> > +		ret = PTR_ERR(epc_page);
> > +		goto err_free_owner;
> > +	}
> > +	epc_page->flags = SGX_EPC_PAGE_IS_VEPC;
> >  
> >  	ret = xa_err(xa_store(&vepc->page_array, index, epc_page, GFP_KERNEL));
> >  	if (ret)
> > -		goto err_free;
> > +		goto err_free_page;
> >  
> >  	pfn = PFN_DOWN(sgx_get_epc_phys_addr(epc_page));
> >  
> > @@ -61,8 +71,10 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
> >  
> >  err_delete:
> >  	xa_erase(&vepc->page_array, index);
> > -err_free:
> > +err_free_page:
> >  	sgx_free_epc_page(epc_page);
> > +err_free_owner:
> > +	kfree(owner);
> >  	return ret;
> >  }
> >  
> > @@ -122,6 +134,7 @@ static int sgx_vepc_remove_page(struct sgx_epc_page *epc_page)
> >  
> >  static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
> >  {
> > +	struct sgx_vepc_page *owner = (struct sgx_vepc_page *)epc_page->owner;
> >  	int ret = sgx_vepc_remove_page(epc_page);
> >  	if (ret) {
> >  		/*
> > @@ -141,6 +154,7 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
> >  		return ret;
> >  	}
> >  
> > +	kfree(owner);
> >  	sgx_free_epc_page(epc_page);
> >  	return 0;
> >  }
> > -- 
> > 2.25.1
> > 
> 
> I think this patch set is going taking wrong approach. Instead it would
> be better just to re-use struct sgx_encl_page.
> 
> Things will get out of hands, if we have a struct of each flavor of the
> same entity.
> 
> Additionally, it will take virtualization code a step closer to be
> feasible for the page reclaimer consumption.

I have a better idea. Why don't you simply store 'vaddr' to 'owner',
i.e.

        epc_page = sgx_alloc_epc_page((void *)addr, false);

The new struct is useless, or harmful, because it consumes memory.
SGX_EPC_PAGE_IS_VEPC is there to interpret the meaning of the field
correctly.

BR, Jarkko
