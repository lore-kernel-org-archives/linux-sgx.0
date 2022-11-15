Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C91C433FE
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Nov 2022 21:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiKOVyU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Nov 2022 16:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiKOVyI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Nov 2022 16:54:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AC225C71
        for <linux-sgx@vger.kernel.org>; Tue, 15 Nov 2022 13:54:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97024618F5
        for <linux-sgx@vger.kernel.org>; Tue, 15 Nov 2022 21:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C847C433C1;
        Tue, 15 Nov 2022 21:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668549247;
        bh=aMnkWTHQFjqnzFCh47+E4XXguvKhJIP5/Okl+tVKSbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o9cgoq4zcBpV5c+38zUh/CqtIK3b9LeGsPDtSCett9SqELqQsSSYZqmWolZto4oKt
         gKdMINFsxpuZiEKKfl6fcaar+qXCo1+o+ZwuZd9RcCbnR3Ow6R3EJsJdnixneTjVRQ
         x/F4owdVXBFjcS40XmutDrRMG+UJCfgZ21jHYXR5fLnQrc7J2em2RZsVgM1H2es8dm
         nvSarDGY+z6eADf+J9NDas7VlCA+XS+oxwXU6SFTOOi/JG8BnrmpNRMq0hnOGaGh/1
         Sbnx0e6mYuVqnT5xb/njO9tobOg0Wm2x4Jz0MrdzA8r2Kd+FVWNSxJc5mYEv039Huj
         f0qAu27HkwF+w==
Date:   Tue, 15 Nov 2022 23:54:03 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v3 1/4] x86/sgx: Export sgx_encl_eaug_page
Message-ID: <Y3QKXQjydl7WwAzZ@kernel.org>
References: <20221107220212.257422-1-haitao.huang@linux.intel.com>
 <20221107220212.257422-2-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107220212.257422-2-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 07, 2022 at 02:02:09PM -0800, Haitao Huang wrote:
> This function will be called by both the page fault handler
> and the fops->fadvise callback.
> 
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 4 ++--
>  arch/x86/kernel/cpu/sgx/encl.h | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
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
> index a65a952116fd..557d4abb13fc 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -127,5 +127,7 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
>  					 unsigned long addr);
>  struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
>  void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
> +vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
> +			      struct sgx_encl *encl, unsigned long addr);
>  
>  #endif /* _X86_ENCL_H */
> -- 
> 2.25.1
> 

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
