Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF3DC433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 19 May 2022 21:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbiESVby (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 May 2022 17:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiESVby (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 19 May 2022 17:31:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E425A59F
        for <linux-sgx@vger.kernel.org>; Thu, 19 May 2022 14:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5445ACE27E8
        for <linux-sgx@vger.kernel.org>; Thu, 19 May 2022 21:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59973C34113;
        Thu, 19 May 2022 21:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652995909;
        bh=62RwmJTeYjpseJSg6K41aU1ey3s9PpzkuO9VVGZSRAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ar7K3em6IAx4mTYz+kSjk7w+C5RGnVqB33GdybotWwbW2BbOyWl1jsBgM9KebqIk3
         nSYW2fBtj8d8zOc1fHlnz87awXizkXGl3E0UEGGq3IVhrVX4AUmS488O2kGnYsQeDg
         HTOtqt0VaRdGG63ErDjyQPulE4Z226Bf5kxZ87RMXMmGDBzYMKJselNETBesnP1fCw
         GUFXgBkGG4Sj/yHG3WZosC9suga4nyhNHlR66PLTfVG7lo5RVJ8Uc/mZe5WHKfbUcl
         PLUzjjUfz0W9igUpPohL1BKegvQ9k7k/2PUgy6ruCBsr3Y93J3fvQscyyoFmauINhC
         rEywNsCL3+RSg==
Date:   Fri, 20 May 2022 00:30:10 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com
Subject: Re: [PATCH v2 1/4] x86/sgx: Move struct sgx_vepc definition to sgx.h
Message-ID: <Yoa24o8df+371sQ0@iki.fi>
References: <20220519031117.245698-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519031117.245698-1-zhiquan1.li@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 19, 2022 at 11:11:17AM +0800, Zhiquan Li wrote:
> Move struct sgx_vepc definition to sgx.h so that it can be used outside
> of virt.c.
> 
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> ---
> Changes since V1:
> - Add documentation suggested by Jarkko.
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h  | 13 +++++++++++++
>  arch/x86/kernel/cpu/sgx/virt.c |  5 -----
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 0f17def9fe6f..ad3b455ed0da 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -101,4 +101,17 @@ static inline int __init sgx_vepc_init(void)
>  
>  void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
>  
> +/**
> + * struct sgx_vepc - SGX virtual EPC structure
> + * @page_array:		the xarray of virtual EPC pages allocated to guest
> + * @lock:			the mutex lock to protect a virtual EPC instance
> + *
> + * When hypervisor opens /dev/sgx_vepc a virtual EPC instance. The
> + * virtual EPC pages allocated to guest will be added to its page_array.

I would just write "page array".

> + */
> +struct sgx_vepc {
> +	struct xarray page_array;
> +	struct mutex lock;
> +};
> +
>  #endif /* _X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 6a77a14eee38..c9c8638b5dc4 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -18,11 +18,6 @@
>  #include "encls.h"
>  #include "sgx.h"
>  
> -struct sgx_vepc {
> -	struct xarray page_array;
> -	struct mutex lock;
> -};
> -
>  /*
>   * Temporary SECS pages that cannot be EREMOVE'd due to having child in other
>   * virtual EPC instances, and the lock to protect it.
> -- 
> 2.25.1
> 

BR, Jarkko
