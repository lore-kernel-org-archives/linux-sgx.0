Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B966BC433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 17:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 809A9223DB
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 17:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbhATRsx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 12:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732994AbhATRso (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 20 Jan 2021 12:48:44 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20CDC061757
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 09:48:01 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id i5so15696192pgo.1
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 09:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i4lYsnGE+v+tE5l45H+oTDC1o93O3IhagWLh4ZAp+8k=;
        b=V3o/tdTNiMjFvWcboAIMY1AHu9r0V4CGofgz7tX8a9WGa4qbOEaI4Q8K1HUetKujRG
         KU1fHJcAhGO+ZN1MjiRBqqbSykkX24xz6nVUXtIH1JlSPgfvMjq4vlk+GFogTJSIorGs
         bGqK6MIYM2tCbG/9s8mwTDTAeBgz6GbBdnUpd+GX2Dx7+9LYWMKz+4Fxs2jGHlu5bt0L
         WM0xRxzo7cjDx+3UcPseYjhY7yOknrxIkxK+4XugY/TATP7G8r/MSzyE4pzlVco9xIpN
         OFm6isesgtVpZzOnEG8+l6pru5bQhQRp/2CudGh7GAD1tWEGf8qEMkRu1DWD+bz0+WA0
         ay0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i4lYsnGE+v+tE5l45H+oTDC1o93O3IhagWLh4ZAp+8k=;
        b=slhpUHY9B9rjEB9WPcEH3eKOoHurTvHbHz7T6fnoS53ByxlYVLkzdS+blrMDGkw1i5
         hLwvsdE7QCNGwTVDDpr69fpH0bT7raKI94DsyDBs9tBifyZOjxGAP022MAfOhEQiBr9D
         vlZDrXfvaTDjULAmGB+HLSueW7TbXuEAHGei9zs7TYKNYafrvykM0ILAoW2DUfTqKPYk
         owh/2wc9416GQVWYhVQZrAKeqK9iBsMLOxv/+HuV6kdjOrh39k3dNKsyFVbTtWIMzbJh
         51wG8bJijP09vUOPkeiX5xaF2NaPdkON9QnzK5W8viYKfhhjmtxoqOwx+D+uKMFKe8fQ
         Dyrw==
X-Gm-Message-State: AOAM5317phLHaacQ8pR+e/3/hHRhFZwjnNWr4+iZnER4JaJWoBV3d+Uu
        aidxvG9ZU1wqZvU/MU+iKKsP2A==
X-Google-Smtp-Source: ABdhPJzYvFB+UWVM60ozUVDH7qdLtkysL9uR8eekFzRdpp9pddf5Tv9QrPUVhwMb06WYmrF5AB0oEA==
X-Received: by 2002:a65:50c8:: with SMTP id s8mr10489522pgp.68.1611164881166;
        Wed, 20 Jan 2021 09:48:01 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id s23sm2919642pgj.29.2021.01.20.09.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 09:48:00 -0800 (PST)
Date:   Wed, 20 Jan 2021 09:47:53 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Subject: Re: [PATCH v2] x86/sgx: Remove redundant if conditions in
 sgx_encl_create
Message-ID: <YAhsyXahEYjV7DZ8@google.com>
References: <20210120035328.19868-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120035328.19868-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 20, 2021, Tianjia Zhang wrote:
> In this scenario, there is no case where va_page is NULL, and
> the error has been checked. The if condition statement here is
> redundant, so remove the condition detection.
> 
> Reported-by: Jia Zhang <zhang.jia@linux.alibaba.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 1c6ecf9fbeff..efad2fb61c76 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -66,9 +66,12 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>  	va_page = sgx_encl_grow(encl);
>  	if (IS_ERR(va_page))
>  		return PTR_ERR(va_page);
> -	else if (va_page)
> -		list_add(&va_page->list, &encl->va_pages);
> -	/* else the tail page of the VA page list had free slots. */
> +
> +	if (WARN_ONCE(!va_page,
> +		      "the tail page of the VA page list had free slots\n"))

IMO it's worth trimming down the message to keep this on a single line.  The
newline isn't necessary, and this code expects a completely empty list, e.g. it
can be reworded to something like:

	if (WARN_ONCE(!va_page, "non-empty VA page list before ECREATE"))

> +		return -EIO;
> +
> +	list_add(&va_page->list, &encl->va_pages);
>  
>  	/* The extra page goes to SECS. */
>  	encl_size = secs->size + PAGE_SIZE;
> -- 
> 2.19.1.3.ge56e4f7
> 
