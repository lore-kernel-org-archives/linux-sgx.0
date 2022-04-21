Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B74C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Apr 2022 16:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390475AbiDUQI0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Apr 2022 12:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390469AbiDUQIV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Apr 2022 12:08:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF7B1208C
        for <linux-sgx@vger.kernel.org>; Thu, 21 Apr 2022 09:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC02161C28
        for <linux-sgx@vger.kernel.org>; Thu, 21 Apr 2022 16:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC51C385A8;
        Thu, 21 Apr 2022 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650557129;
        bh=D7er7Gkjv/f4i1Yu0ZUVinpq3kpPcMDuLA+oEQdw4ds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RYi9fmMOeIx9QgGwYVfvMBfc2k4PeLKOPpWVpgFcBhAYCVtIES8+yiKfu4+uQ7rjx
         UB5OBzHiW7mb7o6gfwFvRk6l2mudmmV0zLAzGr9UMWfs4B2RH4QHqLOQ7dIpm8R7BT
         YdyxHrF1T6al93a+spFowtOS/BIEl0JASQX5xxQCkjgzorhmVNCMAqHDblF4iTdGna
         033EMDzj538eCeAFeaohpnraeoNDsIYLfLiXmRWBzcEB3xOrWXHPaG/kASVW7wF+8N
         KIm2JNsjFLauWPQ4/fxVn7Vq3+2qTqt02U+qrQCxUTZRpqwYQDgdjcO1YQupb7CmgC
         JZm+UzOYiXW7A==
Date:   Thu, 21 Apr 2022 19:04:14 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com, chao.p.peng@intel.com, yang.zhong@intel.com
Subject: Re: [PATCH v4 2/9] x86/sgx: Save enclave pointer for VA page
Message-ID: <YmGAfiiog/NRHIvq@kernel.org>
References: <20220421110326.856-1-cathy.zhang@intel.com>
 <20220421110326.856-3-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421110326.856-3-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 21, 2022 at 07:03:19PM +0800, Cathy Zhang wrote:
> Tearing down all enclaves is required by SGX SVN update, which
> involves running the ENCLS[EREMOVE] instruction on every EPC
> page. This (tearing down all enclaves) should be coordinated
> with any enclaves that may be in the process of existing and thus
> already be running ENCLS[EREMOVE] as part of enclave release.
> 
> In support of this coordination, it is required to know which enclave
> owns each in-use EPC page. It is already possible to locate the
> owning enclave of SECS and regular pages but not for VA pages.
> 
> Make the following changes for VA pages' location:
> 1) Make epc->owner type-agnostic by changing its type to 'void *'. So,
>    besides "struct sgx_encl_page", it can have other types, like
>    "struct sgx_va_page".
> 2) Save the enclave pointer for each VA page to support locating its
>    owning enclave.
> 
> Note: to track 2T EPC memory, this scheme of tracking will use
> additional 8M memory.
> 
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> 
> ---
> Changes since v3:
>  - Squash patch "x86/sgx: Provide VA page non-NULL owner" and
>    "x86/sgx: Save enclave pointer for VA page". Update commit log.
>    (Suggested by Jarkko Sakkinen)
> ---
>  arch/x86/kernel/cpu/sgx/encl.h  | 4 ++--
>  arch/x86/kernel/cpu/sgx/sgx.h   | 2 +-
>  arch/x86/kernel/cpu/sgx/encl.c  | 5 +++--
>  arch/x86/kernel/cpu/sgx/ioctl.c | 3 ++-
>  4 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index 7cdc351bc273..59fbd4ed5c64 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -76,6 +76,7 @@ struct sgx_va_page {
>  	struct sgx_epc_page *epc_page;
>  	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
>  	struct list_head list;
> +	struct sgx_encl *encl;
>  };
>  
>  struct sgx_backing {
> @@ -112,8 +113,7 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
>  void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write);
>  int sgx_encl_test_and_clear_young(struct mm_struct *mm,
>  				  struct sgx_encl_page *page);
> -

This line removal is not related to the patch.

> -struct sgx_epc_page *sgx_alloc_va_page(void);
> +struct sgx_epc_page *sgx_alloc_va_page(struct sgx_va_page *va_page);
>  unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
>  void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
>  bool sgx_va_page_full(struct sgx_va_page *va_page);
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index d7a1490d90bb..f8ed9deac18b 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -33,7 +33,7 @@ struct sgx_epc_page {
>  	unsigned int section;
>  	u16 flags;
>  	u16 poison;
> -	struct sgx_encl_page *owner;
> +	void *owner;
>  	struct list_head list;
>  };
>  
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 68c8d65a8dee..c0725111cc25 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -753,6 +753,7 @@ int sgx_encl_test_and_clear_young(struct mm_struct *mm,
>  
>  /**
>   * sgx_alloc_va_page() - Allocate a Version Array (VA) page
> + * @va_page:	struct sgx_va_page connected to this VA page
>   *
>   * Allocate a free EPC page and convert it to a Version Array (VA) page.
>   *
> @@ -760,12 +761,12 @@ int sgx_encl_test_and_clear_young(struct mm_struct *mm,
>   *   a VA page,
>   *   -errno otherwise
>   */
> -struct sgx_epc_page *sgx_alloc_va_page(void)
> +struct sgx_epc_page *sgx_alloc_va_page(struct sgx_va_page *va_page)
>  {
>  	struct sgx_epc_page *epc_page;
>  	int ret;
>  
> -	epc_page = sgx_alloc_epc_page(NULL, true);
> +	epc_page = sgx_alloc_epc_page(va_page, true);
>  	if (IS_ERR(epc_page))
>  		return ERR_CAST(epc_page);
>  
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index a4df72f715d7..b77343eb2d49 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -30,7 +30,8 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
>  		if (!va_page)
>  			return ERR_PTR(-ENOMEM);
>  
> -		va_page->epc_page = sgx_alloc_va_page();
> +		va_page->encl = encl;
> +		va_page->epc_page = sgx_alloc_va_page(va_page);
>  		if (IS_ERR(va_page->epc_page)) {
>  			err = ERR_CAST(va_page->epc_page);
>  			kfree(va_page);
> -- 
> 2.17.1
> 

BR, Jarkko
