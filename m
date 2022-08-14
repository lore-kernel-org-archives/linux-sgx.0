Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16336C25B06
	for <linux-sgx@archiver.kernel.org>; Sun, 14 Aug 2022 19:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiHNTgf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 14 Aug 2022 15:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiHNTgf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 14 Aug 2022 15:36:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8053D167F8
        for <linux-sgx@vger.kernel.org>; Sun, 14 Aug 2022 12:36:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 119E660ED5
        for <linux-sgx@vger.kernel.org>; Sun, 14 Aug 2022 19:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFBCC433C1;
        Sun, 14 Aug 2022 19:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660505792;
        bh=SvZU9Qg73QNvOyM1BbJ/iHEX5I7ySBfmB1DyqiW6XBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UX+G2+F0Q4wgyPJfLd8PZ6Qx8nqZSXJxscyoPWlHRjCbwO3h7aUWnmYh74KGaTsFA
         gOeNEilpe2++CI+f8ldY5sgesQ+vvhnnHW3/USHHn8pI7HfVSOvlsjXAcwA4iuId0L
         vtoN3cONXkUWA8kVNNwsRQ7HJom/03tnhcnyTeR8tFSIem/P25e4yQ2iULgKDONLR5
         yPdJB2/6nmvvvHxSaMtap/crVeu0A7DY4w2cnlda09hSKZFzRPv7VefEC8PpToVKzd
         vCzebHYWiyGTTA8vP8gxP+N5mPvfwSSj1FQ2B2s+5Ct7lvWB6ynMpTaeVgwul73l4w
         2+3S535kmCgrQ==
Date:   Sun, 14 Aug 2022 22:36:29 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, reinette.chatre@intel.com,
        dave.hansen@linux.intel.com, vijay.dhanraj@intel.com
Subject: Re: [PATCH] x86/sgx: handle VA page allocation failure for EAUG on
 PF.
Message-ID: <YvlOvZfhm6msW2Ca@kernel.org>
References: <20220812191224.15561-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812191224.15561-1-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 12, 2022 at 12:12:24PM -0700, Haitao Huang wrote:
> Return VM_FAULT_NOPAGE to allow the swapping thread to catch up.
> 
> link: https://lore.kernel.org/all/20220804201456.33418-1-vijay.dhanraj@intel.com/
> 
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 24c1bb8eb196..1f88f80c4477 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -344,8 +344,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  	}
>  
>  	va_page = sgx_encl_grow(encl, false);
> -	if (IS_ERR(va_page))
> -		goto err_out_epc;
> +	if (IS_ERR(va_page)) {
> +        if (PTR_ERR(va_page) == -EBUSY)
> +            vmret =  VM_FAULT_NOPAGE;
> +        goto err_out_epc;
> +    }
>  
>  	if (va_page)
>  		list_add(&va_page->list, &encl->va_pages);
> -- 
> 2.25.1
> 

Indentation is probably not right, but the fix look legit.

You need to use real tab-characters to fix that. Run the
patch with scripts/checkpatch.pl and it will report you
these issues.

Vijay, can you check if this fixes the issue for you?

BR, Jarkko
