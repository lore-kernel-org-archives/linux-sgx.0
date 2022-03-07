Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A96C433F5
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Mar 2022 16:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238386AbiCGQDk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Mar 2022 11:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239484AbiCGQDj (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Mar 2022 11:03:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B3031DF4;
        Mon,  7 Mar 2022 08:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87A6BB81606;
        Mon,  7 Mar 2022 16:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DCCC340E9;
        Mon,  7 Mar 2022 16:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646668961;
        bh=dcOU/gA08rZKDZ4+ccCpMowJuxHHgzOtP4kOG059zHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GOVFZvLuN64f5sEeKly/51EJIRfdUIxlAQIenk4DPdMYWALdqgQTx0jjMKlAU0u74
         OGqTpztCZN9RUx/5Vlb9VgQSZTby2PdqYmFsj5VbospRed4vipQt/G3I4A8qXXqzXE
         of1yVZdmQ/BFuTvuCXA2K/6w8g59Z4cDBQUfI56VkVz+8OTtEu3K2JFQXJcpatGCVj
         v8b6n7HQPZl3IDgio1yBs5yVTds2W/J4peeg5GToJB1orbRfzRTyPuNCDz1Rvy5oFe
         V9/gTKooW1Yxft+L3IyldTXDN4AVlEQXr4VjVpEBwdlv+/IrG7BkSwGqyqwoRgEzSl
         AfZWxxLMSkjwg==
Date:   Mon, 7 Mar 2022 18:02:00 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Nathaniel McCallum <nathaniel@profian.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Enable PROT_EXEC for EAUG'd pages
Message-ID: <YiYseF3aKI70x3d8@iki.fi>
References: <20220307153504.198112-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307153504.198112-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 07, 2022 at 05:35:04PM +0200, Jarkko Sakkinen wrote:
> vm_max_permissions was created to control the pre-initialization content
> that contributes to MRSIGNATURE. It was never meant to be as a limit to
> dynamically added pages.
> 
> E.g. static content could be used as a hook for LSM's to decide whether
> certain signature is qualified for EINIT. Dynamic content has nothing to
> do with that. The current mechanisms only add to the complexity on how
> to control PTE and EPCM permissions, and do not add anything else than
> obfuscity to security side of things.
> 
> Thus add PROT_EXEC to the permissions assigned by the #PF handler.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 79e39bd99c09..0256918b2c2f 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -160,12 +160,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  	encl_page->encl = encl;
>  
>  	/*
> -	 * Adding a regular page that is architecturally allowed to only
> -	 * be created with RW permissions.
> -	 * TBD: Interface with user space policy to support max permissions
> -	 * of RWX.
> +	 * Dynamic pages do not contribute to MRSIGNATURE, i.e. they are
> +	 * controlled only by PTE and EPCM permissions. Thus, the no limit
> +	 * is set here.
>  	 */
> -	prot = PROT_READ | PROT_WRITE;
> +	prot = PROT_READ | PROT_WRITE | PROT_EXEC;
>  	encl_page->vm_run_prot_bits = calc_vm_prot_bits(prot, 0);
>  	encl_page->vm_max_prot_bits = encl_page->vm_run_prot_bits;
>  
> -- 
> 2.35.1
> 

This is really a show stopper. I think here's a logical mistake on for what
purpose vm_max_prot_bits are used for. They are meant for the static and
also signed content of the enclave.

These changes in the patch set that are related to vm_max_prot_bits only
messes up what already exists, and make incredibly hard to implement
anything decent on top of SGX2 features.

BR, Jarkko
