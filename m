Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269DFC433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 10:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiEKKeD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 06:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiEKKeC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 06:34:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A7C68335
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 03:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01C716168E
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 10:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13806C340ED;
        Wed, 11 May 2022 10:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652265238;
        bh=paV5ibidZoZX76ztcwPClxoki6PID/GLerVQ7iNl9VI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oQJiV+C/3mAcnHTArEcd0Ssn3Me2LAJT0MV3Z1bMPoxYNsruTUQKxs58wuAj+Xjot
         T/7lKSa1z//MH4xYBzsaPLH8QKJoGMitJyeM451P1s/iF4jDtvB07b+umPtZ4HPjnm
         1MkMRH3dfTDkklNPgEmAuDpALTO75D0kIvjogufZ4HM0hg3QnR+8oH+P2tqxoU4bDc
         hR/v/qf7pauQGtxPTj00tUTpStm0d551dsTntMlm0vsCPdgJz0PkEcvM8YQZbdVa+F
         2zuXqIwcsesbamRjrfGdRsBOebmbLKb0uDxaFnXcdjwip03vBbOz9rjdOaK8a+OL3i
         s5X1oXkHbzo2g==
Date:   Wed, 11 May 2022 13:32:28 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, seanjc@google.com, fan.du@intel.com
Subject: Re: [PATCH 2/4] x86/sgx: add struct sgx_vepc_page to manage EPC
 pages for vepc
Message-ID: <YnuQvN+oQ1ar6ypU@kernel.org>
References: <20220510031737.3181410-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220510031737.3181410-1-zhiquan1.li@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 10, 2022 at 11:17:37AM +0800, Zhiquan Li wrote:
> Current SGX data structures are insufficient to track the EPC pages for
> vepc. For example, if we want to retrieve the virtual address of an EPC
> page allocated to an enclave on host, we can find this info from its
> owner, the ‘desc’ field of struct sgx_encl_page. However, if the EPC
> page is allocated to a KVM guest, this is not available, as their owner
> is a shared vepc.
> 
> So, we introduce struct sgx_vepc_page which can be the owner of EPC
> pages for vepc and saves the useful info of EPC pages for vepc, like
> struct sgx_encl_page.
> 
> Canonical memory failure collects victim tasks by iterating all the
> tasks one by one and use reverse mapping to get victim tasks’ virtual
> address.
> 
> This is not necessary for SGX - as one EPC page can be mapped to ONE
> enclave only. So, this 1:1 mapping enforcement allows us to find task
> virtual address with physical address directly.
> 
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h  |  7 +++++++
>  arch/x86/kernel/cpu/sgx/virt.c | 24 +++++++++++++++++++-----
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 83ff8c3e81cf..cc01d992453a 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -28,6 +28,8 @@
>  
>  /* Pages on free list */
>  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
> +/* Pages is used by VM guest */
> +#define SGX_EPC_PAGE_IS_VEPC		BIT(2)
>  
>  struct sgx_epc_page {
>  	unsigned int section;
> @@ -106,4 +108,9 @@ struct sgx_vepc {
>  	struct mutex lock;
>  };
>  
> +struct sgx_vepc_page {
> +	unsigned long vaddr;
> +	struct sgx_vepc *vepc;
> +};

Same comment as for struct sgx_vepc.

> +
>  #endif /* _X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index c9c8638b5dc4..d7945a47ced8 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -29,6 +29,7 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>  			    struct vm_area_struct *vma, unsigned long addr)
>  {
>  	struct sgx_epc_page *epc_page;
> +	struct sgx_vepc_page *owner;
>  	unsigned long index, pfn;
>  	int ret;
>  
> @@ -41,13 +42,22 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>  	if (epc_page)
>  		return 0;
>  
> -	epc_page = sgx_alloc_epc_page(vepc, false);
> -	if (IS_ERR(epc_page))
> -		return PTR_ERR(epc_page);
> +	owner = kzalloc(sizeof(*owner), GFP_KERNEL);
> +	if (!owner)
> +		return -ENOMEM;
> +	owner->vepc = vepc;
> +	owner->vaddr = addr & PAGE_MASK;
> +
> +	epc_page = sgx_alloc_epc_page(owner, false);
> +	if (IS_ERR(epc_page)) {
> +		ret = PTR_ERR(epc_page);
> +		goto err_free_owner;
> +	}
> +	epc_page->flags = SGX_EPC_PAGE_IS_VEPC;
>  
>  	ret = xa_err(xa_store(&vepc->page_array, index, epc_page, GFP_KERNEL));
>  	if (ret)
> -		goto err_free;
> +		goto err_free_page;
>  
>  	pfn = PFN_DOWN(sgx_get_epc_phys_addr(epc_page));
>  
> @@ -61,8 +71,10 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>  
>  err_delete:
>  	xa_erase(&vepc->page_array, index);
> -err_free:
> +err_free_page:
>  	sgx_free_epc_page(epc_page);
> +err_free_owner:
> +	kfree(owner);
>  	return ret;
>  }
>  
> @@ -122,6 +134,7 @@ static int sgx_vepc_remove_page(struct sgx_epc_page *epc_page)
>  
>  static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
>  {
> +	struct sgx_vepc_page *owner = (struct sgx_vepc_page *)epc_page->owner;
>  	int ret = sgx_vepc_remove_page(epc_page);
>  	if (ret) {
>  		/*
> @@ -141,6 +154,7 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
>  		return ret;
>  	}
>  
> +	kfree(owner);
>  	sgx_free_epc_page(epc_page);
>  	return 0;
>  }
> -- 
> 2.25.1
> 

BR, Jarkko
