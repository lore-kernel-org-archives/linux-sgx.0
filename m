Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA36C00140
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Aug 2022 02:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbiHPCwn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Aug 2022 22:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiHPCwa (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 15 Aug 2022 22:52:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C74CC41
        for <linux-sgx@vger.kernel.org>; Mon, 15 Aug 2022 16:21:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F90D610AA
        for <linux-sgx@vger.kernel.org>; Mon, 15 Aug 2022 23:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A2CC433C1;
        Mon, 15 Aug 2022 23:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660605700;
        bh=fE9xCKPCXPSGgTs+z4Iagmlxa0ryw/MYJiTZ/SqrDxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PegxYCwppqiG3q8X9hhCrMj3HorusDcfQrDDX3oxysXwirTYWBK8Awee+iDlnVYjC
         Nu7v9TEfiTufGqrNlbFA7RCI/JIqPnuQgXbsbQTPMMmA3hGSUXZOxU2lU4Zrd2ICmU
         4kw1E1YcDtIU7oxH2BPXz6xrSI/dYDT3/qblAVQjkEkEfcT5Al7L/yM/PX7tgM7zol
         t4omN9bwHNbQ4wCTS/yf3bFk0czjX9OBfMEyhFjT9NQPItgdVsk7iZt145AXuz+TSD
         OO36gK0jLfc4vxGgx5RbPsWhgxPxJ97ws1v2QJ+EpnlfeIx7iVaeCQ/YElk3JTjxF4
         Xdf8ALj1Cc2dg==
Date:   Tue, 16 Aug 2022 02:21:36 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [PATCH] x86/sgx: handle VA page allocation failure for EAUG on
 PF.
Message-ID: <YvrMBEbcXRKLKWFy@kernel.org>
References: <YvlOvZfhm6msW2Ca@kernel.org>
 <20220815045347.36173-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815045347.36173-1-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Aug 14, 2022 at 09:53:47PM -0700, Haitao Huang wrote:
> Return VM_FAULT_NOPAGE to allow the swapping thread to catch up.
> 
> link: https://lore.kernel.org/all/20220804201456.33418-1-vijay.dhanraj@intel.com/
> 
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 24c1bb8eb196..de92c1c8b79d 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -344,8 +344,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  	}
>  
>  	va_page = sgx_encl_grow(encl, false);
> -	if (IS_ERR(va_page))
> +	if (IS_ERR(va_page)) {
> +		if (PTR_ERR(va_page) == -EBUSY)
> +			vmret =  VM_FAULT_NOPAGE;
>  		goto err_out_epc;
> +	}
>  
>  	if (va_page)
>  		list_add(&va_page->list, &encl->va_pages);
> -- 
> 2.25.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
