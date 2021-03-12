Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DBDC433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6335264F73
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbhCLVpI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Mar 2021 16:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbhCLVpH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 12 Mar 2021 16:45:07 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF23C061761
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:45:06 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id b23so2746263pfo.8
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x7D4wx4txlNBgp7gkpJLfngOVwKdjZaDmVpicz7DAY4=;
        b=pTf4mbw4jbXZjOuoMn+tuTw2O1Xj6MyUg3SqxwF+JQIgEmgVKFNOCGgWa1Dd4VCcb8
         6BMMguTPhhRaFTFymZJX0yquozaGXf1z1uJYCse9BWNAanT+JBAxgK5n5wZS6Nua0woM
         ylv9h5+iTKYi7PKfmQ6An+a7xYiI4XRFPACp5H5QQpFdLlbBuGbH6+ZFmc9ZNXRvabxj
         XryOlDtxv0bQGACGkWfy33nZlkRY5zWpUEbjzDBP6/CrpuDlAC1kuNd+fh1GErieAZGm
         mFZgG5FqNSLpqK9p5GgpSTiaTXYflbwB8YDPVYaClUXFs9tMHrGZ7AlKNb8EBei85cSx
         5uow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x7D4wx4txlNBgp7gkpJLfngOVwKdjZaDmVpicz7DAY4=;
        b=J0mX881D4e0c+DE7+iDDl3DG71c9gH61vnMH3/8sYSzvvkC+3w+DZDFfH5KWE9K3CY
         Zsiymqf3a/NnxuentLcvEYEP5u6c7YbwBX3LrYOxrmVzw/yqm4pf9Gi3HvAPNOOG8x1J
         l/jdawktYJ/xZkRwu2WjmhOB7bVa42RJypWdcF83+QoBYQDf8quv6OcYMcobEXW6P62w
         WNfV8J258vrBIdvCotQH1YoVwNa8Fm86qtVbacP7s47OX3TpSoxyIfoJ3yoDAb0xzMcb
         vPQsGyaM00x1r1k1MF8LtKIZgdHJZov5kB+Icpxbk+hAPvuZX8kJye0OuXo1HZylJPuD
         +Wdg==
X-Gm-Message-State: AOAM532cszmF4M9LFKhXiz1o13LgKNmF/dG/WNhpy/t4xmtnyT4V4yBf
        5257dxot4tbXWK9Ayyh5Oo2N+g==
X-Google-Smtp-Source: ABdhPJxnN/QGTf+wnEPW4XpmbpqhI2bE/23csUm9gWJ18Ute1hlfIiSxwTfb/12TMRKVrMDgCRq0cg==
X-Received: by 2002:aa7:92d9:0:b029:1bb:b6de:c872 with SMTP id k25-20020aa792d90000b02901bbb6dec872mr177679pfa.68.1615585506293;
        Fri, 12 Mar 2021 13:45:06 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id x7sm3003749pjr.7.2021.03.12.13.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:45:05 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:44:58 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YEvg2vNfiDYoc9u3@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
 <d2ebcffeb9193d26a1305e08fe1aa1347feb1c62.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2ebcffeb9193d26a1305e08fe1aa1347feb1c62.1615250634.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 09, 2021, Kai Huang wrote:
> Modify sgx_init() to always try to initialize the virtual EPC driver,
> even if the SGX driver is disabled.  The SGX driver might be disabled
> if SGX Launch Control is in locked mode, or not supported in the
> hardware at all.  This allows (non-Linux) guests that support non-LC
> configurations to use SGX.
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 44fe91a5bfb3..8c922e68274d 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -712,7 +712,15 @@ static int __init sgx_init(void)
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

I love this code.

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  	if (ret)
>  		goto err_kthread;
>  
> -- 
> 2.29.2
> 
