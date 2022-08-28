Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82A6ECAAD1
	for <linux-sgx@archiver.kernel.org>; Sun, 28 Aug 2022 03:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiH1D2J (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 27 Aug 2022 23:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiH1D2J (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 27 Aug 2022 23:28:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3335C52464
        for <linux-sgx@vger.kernel.org>; Sat, 27 Aug 2022 20:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4A4D60C7B
        for <linux-sgx@vger.kernel.org>; Sun, 28 Aug 2022 03:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D21C433D7;
        Sun, 28 Aug 2022 03:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661657287;
        bh=pFssKcrjVPF0AJpXZqlPEV09mm6FxeahveKuuoV+2Bc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p9uS/KHmvESO3D27RZeiX3jrp4ghh8o7lLp5qO/NKVmIkheEO98J+jQpHSYgFTKO5
         zNDwYdutJUEzBxVUBFhSs1Jr4KTBc60ulBfyANSuygqZAeFsqYq9qmL2LRdCzj8QEy
         +vQtcgogz7Ld2ORjvmW8/c7iX8x6MWkh4UIF38+S53TOcwxhhn/TOHpr/UPAe31zoY
         BgnfK8ZFEiIO+mF+Itj0rHPwcf/OLRtPxDnb1Fb561zGxYLBHvr112NjSiFbDDvwaO
         mX3u/3juE/pIz347odJT1OMFlt3kdWxdWkZKRHFzbrAtH0Wg/3Pv6UxXe4AEYrG/t3
         m469q2tLhG4Ww==
Date:   Sun, 28 Aug 2022 06:27:59 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
Subject: Re: [PATCH RESEND v6 1/3] x86/sgx: Rename the owner field of struct
 sgx_epc_page as encl_owner
Message-ID: <Ywrgp+NUuB83ajkO@kernel.org>
References: <20220826160503.1576966-1-zhiquan1.li@intel.com>
 <20220826160503.1576966-2-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826160503.1576966-2-zhiquan1.li@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Aug 27, 2022 at 12:05:01AM +0800, Zhiquan Li wrote:
> In order to describe the purpose of 'owner' field more exactly,
> rename the 'owner' field of struct sgx_epc_page as 'encl_owner',
> and update all of references.
> 
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>

Is this rename really worth of doing? I'd only consider
such if there was two 'owner' fields but since there is
no name collision, why bother?

Thoughts? Please correct me if I've forgot something
essential previously discussed.

BR, Jarkko


> ---
>  arch/x86/kernel/cpu/sgx/main.c | 20 ++++++++++----------
>  arch/x86/kernel/cpu/sgx/sgx.h  |  2 +-
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 515e2a5f25bb..1315c69a733e 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -102,7 +102,7 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  
>  static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
>  {
> -	struct sgx_encl_page *page = epc_page->owner;
> +	struct sgx_encl_page *page = epc_page->encl_owner;
>  	struct sgx_encl *encl = page->encl;
>  	struct sgx_encl_mm *encl_mm;
>  	bool ret = true;
> @@ -134,7 +134,7 @@ static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
>  
>  static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
>  {
> -	struct sgx_encl_page *page = epc_page->owner;
> +	struct sgx_encl_page *page = epc_page->encl_owner;
>  	unsigned long addr = page->desc & PAGE_MASK;
>  	struct sgx_encl *encl = page->encl;
>  	int ret;
> @@ -191,7 +191,7 @@ void sgx_ipi_cb(void *info)
>  static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
>  			 struct sgx_backing *backing)
>  {
> -	struct sgx_encl_page *encl_page = epc_page->owner;
> +	struct sgx_encl_page *encl_page = epc_page->encl_owner;
>  	struct sgx_encl *encl = encl_page->encl;
>  	struct sgx_va_page *va_page;
>  	unsigned int va_offset;
> @@ -244,7 +244,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
>  static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>  				struct sgx_backing *backing)
>  {
> -	struct sgx_encl_page *encl_page = epc_page->owner;
> +	struct sgx_encl_page *encl_page = epc_page->encl_owner;
>  	struct sgx_encl *encl = encl_page->encl;
>  	struct sgx_backing secs_backing;
>  	int ret;
> @@ -306,7 +306,7 @@ static void sgx_reclaim_pages(void)
>  		epc_page = list_first_entry(&sgx_active_page_list,
>  					    struct sgx_epc_page, list);
>  		list_del_init(&epc_page->list);
> -		encl_page = epc_page->owner;
> +		encl_page = epc_page->encl_owner;
>  
>  		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
>  			chunk[cnt++] = epc_page;
> @@ -320,7 +320,7 @@ static void sgx_reclaim_pages(void)
>  
>  	for (i = 0; i < cnt; i++) {
>  		epc_page = chunk[i];
> -		encl_page = epc_page->owner;
> +		encl_page = epc_page->encl_owner;
>  
>  		if (!sgx_reclaimer_age(epc_page))
>  			goto skip;
> @@ -359,7 +359,7 @@ static void sgx_reclaim_pages(void)
>  		if (!epc_page)
>  			continue;
>  
> -		encl_page = epc_page->owner;
> +		encl_page = epc_page->encl_owner;
>  		sgx_reclaimer_write(epc_page, &backing[i]);
>  
>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> @@ -560,7 +560,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
>  	for ( ; ; ) {
>  		page = __sgx_alloc_epc_page();
>  		if (!IS_ERR(page)) {
> -			page->owner = owner;
> +			page->encl_owner = owner;
>  			break;
>  		}
>  
> @@ -603,7 +603,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
>  
>  	spin_lock(&node->lock);
>  
> -	page->owner = NULL;
> +	page->encl_owner = NULL;
>  	if (page->poison)
>  		list_add(&page->list, &node->sgx_poison_page_list);
>  	else
> @@ -638,7 +638,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  	for (i = 0; i < nr_pages; i++) {
>  		section->pages[i].section = index;
>  		section->pages[i].flags = 0;
> -		section->pages[i].owner = NULL;
> +		section->pages[i].encl_owner = NULL;
>  		section->pages[i].poison = 0;
>  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
>  	}
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 0f2020653fba..4d88abccd12e 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -33,7 +33,7 @@ struct sgx_epc_page {
>  	unsigned int section;
>  	u16 flags;
>  	u16 poison;
> -	struct sgx_encl_page *owner;
> +	struct sgx_encl_page *encl_owner;
>  	struct list_head list;
>  };
>  
> -- 
> 2.25.1
> 
