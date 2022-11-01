Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A316BFA3741
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Nov 2022 01:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiKABNB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 31 Oct 2022 21:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiKABNA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 31 Oct 2022 21:13:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28CDEE0C
        for <linux-sgx@vger.kernel.org>; Mon, 31 Oct 2022 18:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57B6C6151B
        for <linux-sgx@vger.kernel.org>; Tue,  1 Nov 2022 01:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32991C433C1;
        Tue,  1 Nov 2022 01:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667265178;
        bh=SQ4n/TdRztZcVldRw9oRHFZG46wD7Bpy9LT+MOKt+cQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B2hFukjBrUJ6UkpOgfQtXRvKbTLPPNYcBtNIgw2clBl2qoEJMij0WpU63YlHzNGzh
         OVYfvaEPcbOQzhBSKUYkrpOxg6TWbphHhAUlJC4tA6m1HKfEykVyF6+X0wRZGfhVXs
         YrI95vOOmj+zA1GbBnrJzdV6lcqVBhVHCpYEcLL7yrZWd531qiQZwaFM62lnBExUOW
         c+LcAaK2HVMR/lACR6utxwa9OznXdzbrZ1dbian6aZHoYaMDDH3joUm+pcueA89t1k
         JsMjZr6sA4OkQs0hYqjhmZx0pSz/9NFbNqQBGeOgtMd3f7b1a0+jEp6PRm5D9wrauC
         qAldRfwgLBIaw==
Date:   Tue, 1 Nov 2022 03:12:54 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v2 1/4] x86/sgx: Export sgx_encl_eaug_page
Message-ID: <Y2BylnnANuD3CrI+@kernel.org>
References: <20221027194532.180053-1-haitao.huang@linux.intel.com>
 <20221027194532.180053-2-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027194532.180053-2-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 27, 2022 at 12:45:29PM -0700, Haitao Huang wrote:
> This function will be called by both the page fault handler
> and the fops->fadvise callback.
> 
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 4 ++--
>  arch/x86/kernel/cpu/sgx/encl.h | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 8bdeae2fc309..1abc5e7f2660 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -308,8 +308,8 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
>   * Returns: Appropriate vm_fault_t: VM_FAULT_NOPAGE when PTE was installed
>   * successfully, VM_FAULT_SIGBUS or VM_FAULT_OOM as error otherwise.
>   */
> -static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
> -				     struct sgx_encl *encl, unsigned long addr)
> +vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
> +			      struct sgx_encl *encl, unsigned long addr)
>  {
>  	vm_fault_t vmret = VM_FAULT_SIGBUS;
>  	struct sgx_pageinfo pginfo = {0};
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index a65a952116fd..500437981161 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -127,5 +127,6 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
>  					 unsigned long addr);
>  struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
>  void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
> -

Spurious change.

> +vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
> +			      struct sgx_encl *encl, unsigned long addr)
>  #endif /* _X86_ENCL_H */
> -- 
> 2.25.1
> 

BR, Jarkko
