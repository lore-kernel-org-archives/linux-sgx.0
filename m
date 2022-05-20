Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EAAC433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 20 May 2022 19:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbiETTMy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 May 2022 15:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347963AbiETTMu (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 20 May 2022 15:12:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86929D065
        for <linux-sgx@vger.kernel.org>; Fri, 20 May 2022 12:12:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76EB361ACF
        for <linux-sgx@vger.kernel.org>; Fri, 20 May 2022 19:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CED6C385AA;
        Fri, 20 May 2022 19:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653073968;
        bh=WTiJtl3GLvf5VFp+xFEb3G/9BJNAYoF1v/YzN5P/UIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=goR6XwuEv0Eq1pJQ24nBvW1NpnOV2w+ps+esYcPeYsxwEVH9gH9XJVYK3TY/IdABK
         tO/XayFURdjgM0ihQxXcy6R3C7TgnA2BWFDAJThn0ox4rmVkCz5sL/TiKPDmzXu7Ic
         0o9YMQ5eV43n94O7Mei1Qu9iHdVzcXf7llYNEgWupm0imAFAWixO/9KmhN+vUTypfg
         QwWnYL/06z1qMltpyxl0Ah2WHjrvLLvnb8rYj7KMT6Gx6Gq4+uxsVRdwxiWFBj/Qdb
         VWSvosSDHejlG/ZcL1JKqVz173/m6YBWCVseInnjV138RIkZAoLqCAw+ZrLYmyiKG0
         oEVCOUB9gI1eA==
Date:   Fri, 20 May 2022 22:11:10 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Cathy Zhang <cathy.zhang@intel.com>,
        Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com, chao.p.peng@linux.intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH v5 3/9] x86/sgx: Keep record for SGX VA and Guest page
 type
Message-ID: <Yofnzg76OyCiHZwk@iki.fi>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
 <20220520103904.1216-4-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520103904.1216-4-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 20, 2022 at 06:38:58PM +0800, Cathy Zhang wrote:
> Regular enclave EPC pages have sgx_encl_page as their owner, but
> SGX VA page and KVM guest EPC page are maintained by different
> owner structures.
> 
> SGX CPUSVN update requires to know the EPC page owner's status
> and then decide how to handle the page.
> 
> Keep a record of page type for SGX VA and KVM guest page while
> the other EPC pages already have their type tracked, so that
> CPUSVN update can get EPC page's owner by type and handle it then.
> 
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> 
> ---
> Changes since v3:
>  - Rename SGX_EPC_PAGE_GUEST as SGX_EPC_PAGE_KVM_GUEST. (Suggested by
>    Jarkko, Sakkinen)
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h  | 4 ++++
>  arch/x86/kernel/cpu/sgx/encl.c | 2 ++
>  arch/x86/kernel/cpu/sgx/virt.c | 2 ++
>  3 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index f8ed9deac18b..4ad0e5396eef 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -28,6 +28,10 @@
>  
>  /* Pages on free list */
>  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
> +/* VA page */
> +#define SGX_EPC_PAGE_VA			BIT(2)
> +/* Pages allocated for KVM guest */
> +#define SGX_EPC_PAGE_KVM_GUEST		BIT(3)
>  
>  struct sgx_epc_page {
>  	unsigned int section;
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 08f39fa03a39..383abd538ac9 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -912,6 +912,8 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_va_page *va_page)
>  		return ERR_PTR(-EFAULT);
>  	}
>  
> +	epc_page->flags |= SGX_EPC_PAGE_VA;
> +
>  	return epc_page;
>  }
>  
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index e953816d7c8b..104487b72fb8 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -50,6 +50,8 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>  	if (IS_ERR(epc_page))
>  		return PTR_ERR(epc_page);
>  
> +	epc_page->flags |= SGX_EPC_PAGE_KVM_GUEST;

This would need to be synced up with SGX_EPC_IS_VEPC:

https://lore.kernel.org/linux-sgx/694234d7-6a0d-e85f-f2f9-e52b4a61e1ec@intel.com/T/#t

Otherwise, we have a chaos.

Can you sync up with Zhiquan Li and find some common approach. IMHO,
it might even sense to merge these patch sets into one. Then it would
be easier to review them as a whole.

BR, Jarkko
