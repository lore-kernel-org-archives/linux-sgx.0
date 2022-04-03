Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E48C433F5
	for <linux-sgx@archiver.kernel.org>; Sun,  3 Apr 2022 10:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiDCKJH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 3 Apr 2022 06:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiDCKJH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 3 Apr 2022 06:09:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047CE3057D
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 03:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A00B261000
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 10:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85246C340ED;
        Sun,  3 Apr 2022 10:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648980431;
        bh=1gYMY9Pr9TWCwx5r26ALqloBNRYtFwcCM/H0yF+XEBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XwExd0XQvNV7esPvqt7i7zU8x3i2Q+u5IgsPE1iRimti8wKv38K8UvfGbYvP3fSNd
         GMfE6YJRtCh8T6DkPEZHudhOmUxN2FCi//ZhhPviPOX3ENOFX0oM0RVlU5oSJk/VWD
         TlhA61yO0/u/xBHowbpfpdYLEQAPT7Ach8Vp7zdLmGDqNTX925THMiJ24PLcZDqRKm
         Z0VeRLsMVx2ViC5Vcd+UQDFk32KrX+/44g9PvAAuwV4JpQn+jOjbw5lN57QlCY9Qgc
         YXudOQxVBCYK+qe8QKvbOUhe0LylKwi3AvNqyF7/8FT5Nh+JXhK0CLtizRK4lQ8/Rg
         7S1zfjR/uq0CA==
Date:   Sun, 3 Apr 2022 13:08:20 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com
Subject: Re: [RFC PATCH v3 03/10] x86/sgx: Save enclave pointer for VA page
Message-ID: <YklyFJpzsC+7zC5L@kernel.org>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-4-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401142409.26215-4-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 01, 2022 at 10:24:02PM +0800, Cathy Zhang wrote:
> Tearing down all enclaves is required by SGX SVN update, which
> involves running the ENCLS[EREMOVE] instruction on every EPC
> page. This (tearing down all enclaves) should be coordinated
> with any enclaves that may be in the process of existing and thus
> already be running ENCLS[EREMOVE] as part of enclave release.
> 
> In support of this coordination, it is required to know which enclave
> owns each in-use EPC page. It is already possible to locate the
> owning enclave of SECS and regular pages but not for VA pages.
> 
> Save the enclave pointer for each VA page to support locating its
> owning enclave.
> 
> Note: to track 2T EPC memory, this scheme of tracking will use
> additional 8M memory.
> 
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.h  | 1 +
>  arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index 0c8571fc30cf..59fbd4ed5c64 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -76,6 +76,7 @@ struct sgx_va_page {
>  	struct sgx_epc_page *epc_page;
>  	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
>  	struct list_head list;
> +	struct sgx_encl *encl;
>  };
>  
>  struct sgx_backing {
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index f0ce96bd462a..da82abbb81b4 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -30,6 +30,7 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
>  		if (!va_page)
>  			return ERR_PTR(-ENOMEM);
>  
> +		va_page->encl = encl;
>  		va_page->epc_page = sgx_alloc_va_page(va_page);
>  		if (IS_ERR(va_page->epc_page)) {
>  			err = ERR_CAST(va_page->epc_page);
> -- 
> 2.17.1
> 

Squash this with the previous patch. Then the code will provide
answer to one of the questions that I mentioned in 2/10 review.

BR, Jarkko
