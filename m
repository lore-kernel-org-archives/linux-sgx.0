Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22298C3A59D
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Oct 2022 21:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJWVWN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Oct 2022 17:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJWVWM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 23 Oct 2022 17:22:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272AFF585
        for <linux-sgx@vger.kernel.org>; Sun, 23 Oct 2022 14:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 949D3CE0EAF
        for <linux-sgx@vger.kernel.org>; Sun, 23 Oct 2022 21:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725B1C433D6;
        Sun, 23 Oct 2022 21:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666560127;
        bh=rYM4O2ZzNR7Ito6PjVL4Y/Afp8fT7+1lki/Lsyk8GGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PjpsW8w5JqvHZUydrsxBjGbUAVPmERS17yskX7/ZU5Kg0QIZYtB9/auqb8hT9tGFY
         8pzcVNHkRgNduc/3VElEJ/a2ct5CZXSAywksU8YyWVae7blwN8LPYtMA1zJLe91tXM
         URYnu33F53CVQiW4i7E5WU+cRQEqMZMMnlwvusk55REu05RmEVigRC/6LvgH0AvZ0U
         ysGdirNFygTGMJhY22+REvthucCGGR3sqGM0eY9NsxL+G5Sxfnll9nbt9DHJdQV/tf
         SIWFSXyDpwk8t5rPmLMQi8x6/cjCFzrzsP7yPSKjogcDCOGj61P8ca56StNIUv4+yu
         KtLIL1Gk4XUqQ==
Date:   Mon, 24 Oct 2022 00:22:00 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH 1/4] x86/sgx: Export sgx_encl_eaug_page
Message-ID: <Y1WweP7AKcE1/cdo@kernel.org>
References: <20221019191413.48752-1-haitao.huang@linux.intel.com>
 <20221019191413.48752-2-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019191413.48752-2-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 19, 2022 at 12:14:10PM -0700, Haitao Huang wrote:
> Change return type so it can be reused later for fops->fadvise

Does not mention the change in return values or reasoning for that.

> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 46 ++++++++++++++++++++++------------
>  arch/x86/kernel/cpu/sgx/encl.h |  3 ++-
>  2 files changed, 32 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 8bdeae2fc309..c57e60d5a0aa 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -305,11 +305,11 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
>   * on a SGX2 system then the EPC can be added dynamically via the SGX2
>   * ENCLS[EAUG] instruction.
>   *
> - * Returns: Appropriate vm_fault_t: VM_FAULT_NOPAGE when PTE was installed
> - * successfully, VM_FAULT_SIGBUS or VM_FAULT_OOM as error otherwise.
> + * Returns: 0 when PTE was installed successfully, -EBUSY for waiting on
> + * reclaimer to free EPC, -ENOMEM for out of RAM, -EFAULT as error otherwise.
>   */
> -static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 -				     struct sgx_encl *encl, unsigned long addr)
> +int sgx_encl_eaug_page(struct vm_area_struct *vma,
> +		       struct sgx_encl *encl, unsigned long addr)

I'd prefer export changes to be separated to their own commits.

>  {
>  	vm_fault_t vmret = VM_FAULT_SIGBUS;
>  	struct sgx_pageinfo pginfo = {0};
> @@ -318,10 +318,10 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  	struct sgx_va_page *va_page;
>  	unsigned long phys_addr;
>  	u64 secinfo_flags;
> -	int ret;
> +	int ret = -EFAULT;
>  
>  	if (!test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
> -		return VM_FAULT_SIGBUS;
> +		return -EFAULT;
>  
>  	/*
>  	 * Ignore internal permission checking for dynamically added pages.
> @@ -332,21 +332,21 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  	secinfo_flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X;
>  	encl_page = sgx_encl_page_alloc(encl, addr - encl->base, secinfo_flags);
>  	if (IS_ERR(encl_page))
> -		return VM_FAULT_OOM;
> +		return -ENOMEM;
>  
>  	mutex_lock(&encl->lock);
>  
>  	epc_page = sgx_alloc_epc_page(encl_page, false);
>  	if (IS_ERR(epc_page)) {
>  		if (PTR_ERR(epc_page) == -EBUSY)
> -			vmret =  VM_FAULT_NOPAGE;
> +			ret =  -EBUSY;
>  		goto err_out_unlock;
>  	}
>  
>  	va_page = sgx_encl_grow(encl, false);
>  	if (IS_ERR(va_page)) {
>  		if (PTR_ERR(va_page) == -EBUSY)
> -			vmret = VM_FAULT_NOPAGE;
> +			ret = -EBUSY;
>  		goto err_out_epc;
>  	}
>  
> @@ -359,16 +359,20 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  	 * If ret == -EBUSY then page was created in another flow while
>  	 * running without encl->lock
>  	 */
> -	if (ret)
> +	if (ret) {
> +		ret = -EFAULT;
>  		goto err_out_shrink;
> +	}
>  
>  	pginfo.secs = (unsigned long)sgx_get_epc_virt_addr(encl->secs.epc_page);
>  	pginfo.addr = encl_page->desc & PAGE_MASK;
>  	pginfo.metadata = 0;
>  
>  	ret = __eaug(&pginfo, sgx_get_epc_virt_addr(epc_page));
> -	if (ret)
> +	if (ret) {
> +		ret = -EFAULT;
>  		goto err_out;
> +	}
>  
>  	encl_page->encl = encl;
>  	encl_page->epc_page = epc_page;
> @@ -385,10 +389,10 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  	vmret = vmf_insert_pfn(vma, addr, PFN_DOWN(phys_addr));
>  	if (vmret != VM_FAULT_NOPAGE) {
>  		mutex_unlock(&encl->lock);
> -		return VM_FAULT_SIGBUS;
> +		return -EFAULT;
>  	}
>  	mutex_unlock(&encl->lock);
> -	return VM_FAULT_NOPAGE;
> +	return 0;
>  
>  err_out:
>  	xa_erase(&encl->page_array, PFN_DOWN(encl_page->desc));
> @@ -401,7 +405,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  	mutex_unlock(&encl->lock);
>  	kfree(encl_page);
>  
> -	return vmret;
> +	return ret;
>  }
>  
>  static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
> @@ -431,8 +435,18 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
>  	 * enclave that will be checked for right away.
>  	 */
>  	if (cpu_feature_enabled(X86_FEATURE_SGX2) &&
> -	    (!xa_load(&encl->page_array, PFN_DOWN(addr))))
> -		return sgx_encl_eaug_page(vma, encl, addr);
> +	    (!xa_load(&encl->page_array, PFN_DOWN(addr)))) {
> +		switch (sgx_encl_eaug_page(vma, encl, addr)) {
> +		case 0:
> +		case -EBUSY:
> +			return VM_FAULT_NOPAGE;
> +		case -ENOMEM:
> +			return VM_FAULT_OOM;
> +		case -EFAULT:
> +		default:
> +			return VM_FAULT_SIGBUS;
> +		}
> +	}

I.e. why it is better to change working code like this, and not
instead add such conversion to the fadvise handler.

No need to response here. This should be explained in the commit
message.

>  
>  	mutex_lock(&encl->lock);
>  
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index a65a952116fd..36059d35e1bc 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -127,5 +127,6 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
>  					 unsigned long addr);
>  struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
>  void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
> -
> +int sgx_encl_eaug_page(struct vm_area_struct *vma,
> +		       struct sgx_encl *encl, unsigned long addr);
>  #endif /* _X86_ENCL_H */
> -- 
> 2.25.1
> 

BR, Jarkko
