Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8C9C2BA4C
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Jan 2022 20:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiAZUSF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Jan 2022 15:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiAZUSF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 26 Jan 2022 15:18:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1DCC06161C
        for <linux-sgx@vger.kernel.org>; Wed, 26 Jan 2022 12:18:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3EF5B81FC8
        for <linux-sgx@vger.kernel.org>; Wed, 26 Jan 2022 20:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C878C340E3;
        Wed, 26 Jan 2022 20:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643228282;
        bh=DEQvsHvJT6xcu5Tw6noRUdc+F2u5tB/+Cb4cMQX3DC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C98XAmSyRPvZ7bOuDVAhFYmbKtXG2R2kU+DZuUsGsdS3sM/YI/Lk9qD3lOzajEeZJ
         P4JPZG9+v/TSq4zfb/DTZQLpfcPTfzyRkC5Gs37Mb96nFOsuKbonR9cOptMI7KwgL2
         nXksxDUGQmInE6FTwLOlos3OnNPEVawHBZKGJ4OShoyoZcbeADaEhTeXCaFIou0z4x
         yryOn3DdIr5P+9f7AKJNz03XI/o5KgFOyOf/5eb1j+drhicotkuswVUTVOsVuQpV3T
         Dwm/5660YA2yfUfplTLivIK0nMx8z1nhyHMO/7gMAD7hTXycCZN9TlpYZLn4V4nAen
         mZOQkoKfwAiFA==
Date:   Wed, 26 Jan 2022 22:17:39 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        haitao.huang@linux.intel.com
Subject: Re: [PATCH 1/2] x86/sgx: fixup for available backing pages
 calculation
Message-ID: <YfGsY5IYpIXhqjGm@iki.fi>
References: <20220126191711.4917-1-kristen@linux.intel.com>
 <20220126191711.4917-2-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126191711.4917-2-kristen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 26, 2022 at 11:17:10AM -0800, Kristen Carlson Accardi wrote:
> Remove improper parentheses from calculation for available
> backing bytes. Wtihout this fix, the result will be incorrect
> due to rounding.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 990f341bbd30..c4030fb608c6 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -881,7 +881,7 @@ static bool __init sgx_page_cache_init(void)
>  		return false;
>  	}
>  
> -	available_backing_bytes = total_epc_bytes * (sgx_overcommit_percent / 100);
> +	available_backing_bytes = total_epc_bytes * sgx_overcommit_percent / 100;
>  	atomic_long_set(&sgx_nr_available_backing_pages, available_backing_bytes >> PAGE_SHIFT);
>  
>  	return true;
> -- 
> 2.20.1
> 

You can turn it as:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
