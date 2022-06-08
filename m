Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A21C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jun 2022 06:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiFHGAy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbiFHFy5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Jun 2022 01:54:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE661FDEAC
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 20:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654660478; x=1686196478;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZdiXHZUJo38IOKboQjnmaGENfeeHeX1A4dYpCywnqZQ=;
  b=Os0C+zZPVcEAPWgWjmldl1LR1F9dIkzqVoVX5AajkqvppxAgDhjLeD+p
   dVRQ/xdZobsdK9/UERTLMsD7aOW5jQc+bsPBljgQYnTKGBDTY9wW6Np3i
   sJzSihY8r5TP4GMUt5zqNf7BblKjP6eILE/PLfyuYO0appRIy+TZ70AUI
   9R0ks3wZmYD9ZQYzzSaoSjpAD2iM/nIaVyL+v/2q463veyFczOxHsYakk
   fLtpvv+FnUhdTfah7dMeDEV5S76kH6SGAK8WSLTYHBKbqATIiwmcGb8/t
   ROCAvWvR1D0ZQ9kQf7ceh9xYsi8WBZj8jBJgVbKyT5GevrwUYwKLRGdqc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="274317999"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="274317999"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 20:54:38 -0700
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="584604217"
Received: from pkakkine-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.149])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 20:54:36 -0700
Message-ID: <7ff6d1d2f727f9453ff89dc68da45ffc77520fdd.camel@intel.com>
Subject: Re: [PATCH v4 1/3] x86/sgx: Repurpose the owner field as the
 virtual address of virtual EPC page
From:   Kai Huang <kai.huang@intel.com>
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com
Date:   Wed, 08 Jun 2022 15:54:34 +1200
In-Reply-To: <20220608032654.1764936-2-zhiquan1.li@intel.com>
References: <20220608032654.1764936-1-zhiquan1.li@intel.com>
         <20220608032654.1764936-2-zhiquan1.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2022-06-08 at 11:26 +0800, Zhiquan Li wrote:
> When a page triggers a machine check, it only reports the
> physical address of EPC page. But in order to inject #MC into
> hypervisor, the virtual address is required. Then repurpose the
> "owner" field as the virtual address of the virtual EPC page so that
> arch_memory_failure() can easily retrieve it.
> 
> Add a new EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the
> meaning of the field.
> 
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> ---
> Changes since V3:
> - Move the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
>   Cathy's third patch of SGX rebootless recovery patch set but discard
>   irrelevant portion, since it might need more time to re-forge and
>   these are two different features.
>   Link: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170
> 
> Changes since V2:
> - Rework the patch suggested by Jarkko.
> - Remove struct sgx_vepc_page and relevant code.
> - Remove new EPC page flag SGX_EPC_PAGE_IS_VEPC definition as it is
>   duplicated to SGX_EPC_PAGE_KVM_GUEST.
>   Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u
> 
> Changes since V1:
> - Add documentation suggested by Jarkko.
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h  | 2 ++
>  arch/x86/kernel/cpu/sgx/virt.c | 4 +++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 0f17def9fe6f..b43582da1bcf 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -28,6 +28,8 @@
>  
>  /* Pages on free list */
>  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
> +/* Pages allocated for KVM guest */
> +#define SGX_EPC_PAGE_KVM_GUEST		BIT(2)
>  
>  struct sgx_epc_page {
>  	unsigned int section;
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


Acked-by: Kai Huang <kai.huang@intel.com>

-- 
Thanks,
-Kai


