Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5D5C636CC
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Feb 2023 23:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjBGX1D (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Feb 2023 18:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBGX1D (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Feb 2023 18:27:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3632203D
        for <linux-sgx@vger.kernel.org>; Tue,  7 Feb 2023 15:27:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7134760F83
        for <linux-sgx@vger.kernel.org>; Tue,  7 Feb 2023 23:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5203DC433EF;
        Tue,  7 Feb 2023 23:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675812419;
        bh=T/dCjufnBmKiMt0PzDkUxJORpBA73ohOeTJbQ5BICHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QIYIl14zPr/Y6dChrtu6w40dC8XxxCnfI/OkOKFM7AH0Jr/A/uQ2XVezMDHcdI5sd
         3dgsnTgO7W1/3+iplaWy2WOy044eQ8ullAFI7y5IDVP1bQSIVs1VIfwKlDFLSTxmQV
         f6HVOmCWGAqs81nTZHegqS8SeeIeCrDabcNSr3vk8fPNwKrT9QWYompiH9ZjuZAf9m
         Ul/xvZ7NrAUaC+p40QHPbtPleM0sW7nV3UUoet+KL1zUXcuk4ubD0MOkJRAnWkP3PW
         0UrPt1WKNrCfSi3Dc/p7IuY+BvUNIlc01aUS7bMtO3/6feUGT09j8UeIymgZ3/m7c4
         y0sbOa+xOz44w==
Date:   Wed, 8 Feb 2023 01:26:54 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v4 1/4] x86/sgx: Export sgx_encl_eaug_page
Message-ID: <Y+LePreVjYnW9enE@kernel.org>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128045529.15749-2-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jan 27, 2023 at 08:55:26PM -0800, Haitao Huang wrote:
> This function will be called by both the page fault handler
> and the fops->fadvise callback.
> 
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 4 ++--
>  arch/x86/kernel/cpu/sgx/encl.h | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 2a0e90fe2abc..0185c5ab48dd 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -311,8 +311,8 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
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
> index f94ff14c9486..9f19b06c3ae3 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -125,5 +125,7 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
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

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
