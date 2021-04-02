Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F536C433ED
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 09:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 488AB6101E
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 09:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhDBJsR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:48:17 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58162 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhDBJsR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Apr 2021 05:48:17 -0400
Received: from zn.tnic (p200300ec2f0a2000e9f6c6f26a4b9205.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:2000:e9f6:c6f2:6a4b:9205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2500C1EC0288;
        Fri,  2 Apr 2021 11:48:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617356895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=29TNI45C4NuBpa0bXgLlOHCPu6BWYV1mLhtyhBM9p6A=;
        b=PHf7dRCwGU84w0iZ+8UuNhap63do/D8O/PMPayQKe782m3m3ABsapJLegqVHNyM0q4DC3Z
        umvNT1Bihx+wXJb1Pj4QFFyCgC07AKm99m2Yc/B8FpjG//a8JrMqwQCGSMium7TNcaE+Ne
        UJqF/0B4IuiAs6MKxZkIhITcSkZ0bY0=
Date:   Fri, 2 Apr 2021 11:48:16 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <20210402094816.GC28499@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 19, 2021 at 08:23:02PM +1300, Kai Huang wrote:
> Modify sgx_init() to always try to initialize the virtual EPC driver,
> even if the SGX driver is disabled.  The SGX driver might be disabled
> if SGX Launch Control is in locked mode, or not supported in the
> hardware at all.  This allows (non-Linux) guests that support non-LC
> configurations to use SGX.
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 6a734f484aa7..b73114150ff8 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -743,7 +743,15 @@ static int __init sgx_init(void)
>  		goto err_page_cache;
>  	}
>  
> -	ret = sgx_drv_init();
> +	/*
> +	 * Always try to initialize the native *and* KVM drivers.
> +	 * The KVM driver is less picky than the native one and
> +	 * can function if the native one is not supported on the
> +	 * current system or fails to initialize.
> +	 *
> +	 * Error out only if both fail to initialize.
> +	 */
> +	ret = !!sgx_drv_init() & !!sgx_vepc_init();

This is a silly way of writing:

        if (sgx_drv_init() && sgx_vepc_init())
                goto err_kthread;

methinks.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
