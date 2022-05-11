Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69944C4332F
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 10:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiEKKpV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 06:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiEKKpU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 06:45:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C80186FD
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 03:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14756B821F5
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 10:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620B3C340ED;
        Wed, 11 May 2022 10:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652265913;
        bh=lrzOBoYBMeUlBNayMSvcsH2vIKOPC8fjqxfaXvp5E7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a3agf0UoL+njX/wSgUeDylQjNWlmfAJWdvrk60jinPy2OuUJ55O+WvLK6bxRQEj8+
         WhWDmg4x/w9/4F5MeRgiUmYoSWx8jkjG8nrh8WMfYPzc0hp9xIwWWeAD5JPqckBZoP
         R0BQ46FwSd/8KCy/zD+8uoWejcKQzRaEiKciHA/iElQz1jBAk5UMIorSddN5xw9m6F
         Ic26wX4hLtXgV3uIMwkQI4EW5ZDR2un9/k8XjT0EWpryJdXBdk77XY8UoB0Ni9asr9
         SUZprQhSLD/rEW0rJZ0oCHplpiDXfM+3oYdkUihsVZMSGaQpjQ7NYsZlBvukmQ4Nq7
         5opbadpHydUvg==
Date:   Wed, 11 May 2022 13:43:44 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        haitao.huang@intel.com
Subject: Re: [PATCH V2 2/5] x86/sgx: Mark PCMD page as dirty when modifying
 contents
Message-ID: <YnuTYN/QZxoN53jc@kernel.org>
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <217608112793e76b335540edde75dfda290de16c.1652131695.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <217608112793e76b335540edde75dfda290de16c.1652131695.git.reinette.chatre@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, May 09, 2022 at 02:48:00PM -0700, Reinette Chatre wrote:
> Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
> after faulting the enclave page") expanded __sgx_encl_eldu()
> to clear an enclave page's PCMD (Paging Crypto MetaData)
> from the PCMD page in the backing store after the enclave
> page is restored to the enclave.
> 
> Since the PCMD page in the backing store is modified the page
> should be marked as dirty to ensure the modified data is retained.
> 
> Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since RFC v1:
> - Do not set dirty bit on enclave page since it is not being
>   written to and always will be discarded.  (Dave)
> 
>  arch/x86/kernel/cpu/sgx/encl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 398695a20605..2521d64e8bcf 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -83,6 +83,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  		ret = -EFAULT;
>  	}
>  
> +	set_page_dirty(b.pcmd);
>  	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
>  
>  	/*
> -- 
> 2.25.1
> 

LGTM.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
