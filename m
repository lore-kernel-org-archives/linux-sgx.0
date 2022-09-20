Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041DDC54EE9
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Sep 2022 04:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiITEvq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 20 Sep 2022 00:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiITEvp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 20 Sep 2022 00:51:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50603719F
        for <linux-sgx@vger.kernel.org>; Mon, 19 Sep 2022 21:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3791B80B48
        for <linux-sgx@vger.kernel.org>; Tue, 20 Sep 2022 04:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84C9C433C1;
        Tue, 20 Sep 2022 04:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663649501;
        bh=SoECJ1jPae9bQbGGWE0oxX00MrBbsJ5OsfWBvuTX40A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PxhgSOrSpXm273goJPJ47ztQ51c+3LEqI9Fjgtu8nRZrZQcuMS/hthN67++8+pe0Z
         uIQ+UBgd61A0iMC8G+ufdm5bMoREay+IxTmAWFiD7hW7NEZtBMAu1+VuLA5zmyMzyx
         gBG7f+qKFadEImhmJeZVCwS8QtXhfjmJ7NmZt7QmoYSFNE0PgwX272SYgQGEf/KS+2
         Jl6tDeUvUP6Es01CWZ5pQFjkZGbWV+cmwnDFHPg/Z9xbwIqbTI1XQ75Du5X4rEHSWL
         e1wfASHhAXn3YvzaY7sUAqR32TlYjHeVtXYgjs1Yzf/VCzAJHgS9svdNN3UxYyRjYs
         rA6F3qQfH+pEA==
Date:   Tue, 20 Sep 2022 07:51:36 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
Subject: Re: [PATCH v8 2/3] x86/sgx: Introduce union with vepc_vaddr field
 for virtualization case
Message-ID: <YylG2JgrtX8rOHri@kernel.org>
References: <20220913145330.2998212-1-zhiquan1.li@intel.com>
 <20220913145330.2998212-3-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913145330.2998212-3-zhiquan1.li@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 13, 2022 at 10:53:29PM +0800, Zhiquan Li wrote:
> When a page triggers a machine check, it only reports the PFN.  But in
> order to inject #MC into hypervisor, the virtual address is required.
> The 'encl_owner' field is useless in virtualization case, then
> repurpose it as 'vepc_vaddr' - the virtual address of the virtual EPC
> page for such case so that arch_memory_failure() can easily retrieve it.
> 
> Introduce a union to prevent adding a new dedicated structure to
> track the virtual address of virtual EPC page.  And it can also prevent
> playing the casting games while using it.
> 
> Add a new EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the
> meaning of the field.
> 
> Co-developed-by: Cathy Zhang <cathy.zhang@intel.com>
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> Acked-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

Remove acked-by

> 
> ---
> Changes since V7:
> - Add Acked-by from Jarkko.
> 
> No changes since V6.
> 
> Changes since V5:
> - To prevent casting the 'encl_owner' field, introduce a union with
>   another field - 'vepc_vaddr', sugguested by Dave Hansen.
> - Add Reviewed-by from Jarkko.
>   Link: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m379d00fc7f1d43726a42b3884637532061a8c0d1
> 
> Changes since V4:
> - Add Co-developed-by and Signed-off-by from Cathy Zhang, as she had
>   fully discussed the flag name with Jarkko.
>   Link: https://lore.kernel.org/all/df92395ade424401ac3c6322de568720@intel.com/
> - Add Acked-by from Kai Huang
>   Link: https://lore.kernel.org/linux-sgx/0676cd4e-d94b-e904-81ae-ca1c05d37070@intel.com/T/#mccfb11df30698dbd060f2b6f06383cda7f154ef3
> 
> Changes since V3:
> - Take the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
>   Cathy Zhang's third patch of SGX rebootless recovery patch set but
>   discard irrelevant portion, since it might need some time to
>   re-forge and these are two different features.
>   Link: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170
> 
> Changes since V2:
> - Remove struct sgx_vepc_page and relevant code.
> - Rework the patch suggested by Jarkko.
> - Remove new EPC page flag SGX_EPC_PAGE_IS_VEPC definition as it is
>   duplicated to SGX_EPC_PAGE_KVM_GUEST.
>   Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u
> 
> Changes since V1:
> - Add documentation suggested by Jarkko.
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 4 ++++
>  arch/x86/kernel/cpu/sgx/sgx.h  | 8 +++++++-
>  arch/x86/kernel/cpu/sgx/virt.c | 4 +++-
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 1315c69a733e..b319bedcaf1e 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -549,6 +549,10 @@ int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
>   * Finally, wake up ksgxd when the number of pages goes below the watermark
>   * before returning back to the caller.
>   *
> + * When an EPC page is assigned to KVM guest, repurpose the 'encl_owner' field
> + * as the virtual address of virtual EPC page, since it is useless in such
> + * scenario, so 'owner' is assigned to 'vepc_vaddr'.
> + *
>   * Return:
>   *   an EPC page,
>   *   -errno on error
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 4d88abccd12e..d16a8baa28d4 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -28,12 +28,18 @@
>  
>  /* Pages on free list */
>  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
> +/* Pages allocated for KVM guest */
> +#define SGX_EPC_PAGE_KVM_GUEST		BIT(2)
>  
>  struct sgx_epc_page {
>  	unsigned int section;
>  	u16 flags;
>  	u16 poison;
> -	struct sgx_encl_page *encl_owner;
> +	union {
> +		struct sgx_encl_page *encl_owner;
> +		/* Use when SGX_EPC_PAGE_KVM_GUEST set in ->flags: */
> +		void __user *vepc_vaddr;
> +	};
>  	struct list_head list;
>  };
>  
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 6a77a14eee38..776ae5c1c032 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -46,10 +46,12 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>  	if (epc_page)
>  		return 0;
>  
> -	epc_page = sgx_alloc_epc_page(vepc, false);
> +	epc_page = sgx_alloc_epc_page((void *)addr, false);
>  	if (IS_ERR(epc_page))
>  		return PTR_ERR(epc_page);
>  
> +	epc_page->flags |= SGX_EPC_PAGE_KVM_GUEST;
> +
>  	ret = xa_err(xa_store(&vepc->page_array, index, epc_page, GFP_KERNEL));
>  	if (ret)
>  		goto err_free;
> -- 
> 2.25.1
> 

BR, Jarkko
