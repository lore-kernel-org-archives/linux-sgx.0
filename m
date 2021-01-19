Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C60C433DB
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Jan 2021 20:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDC7823104
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Jan 2021 20:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbhASUab (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389819AbhASUaB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 19 Jan 2021 15:30:01 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8F0C061757
        for <linux-sgx@vger.kernel.org>; Tue, 19 Jan 2021 12:29:21 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m5so646964pjv.5
        for <linux-sgx@vger.kernel.org>; Tue, 19 Jan 2021 12:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tB/SKLCPwSzSquO5fiUc4D+SVjGaQxxEWky+zQ2MRC8=;
        b=L9Pkrnhj9MgnfHYQvR+iRBUV5BbrfSuVlaPnCgA33yuSpga1n0XXRV9FVvyNWT7kXM
         qMf/N6jyy80qn2Sl2jZeSQvKZc/FLw82MD7/yUKQ+b0nJWh7x0aRhdLphSsQ9nANzCzZ
         9uLOBxwO+NpcD5g+5Uxknc+ZQqgUkb8XHhN9lCmpgG5/ayt4dE2xdv/wypIkccUXWZIj
         CzF7ayETv/9uT1+ecZXxkrdSBQvLI1Bm0gyoWaatB4h25+STGr1oGOwUowMBLY53n6iV
         MtLDje3ueobKYUZH35szcFZWVDCbiCP76bdxYo+tegjBpXIbpKXn1BE+jBo4W+yyJLdf
         zsNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tB/SKLCPwSzSquO5fiUc4D+SVjGaQxxEWky+zQ2MRC8=;
        b=j7qWQflyucaLjb5Q+aJM+xWeD9zpHA9n5FsRL2/PlvOh34ZT+ycmPeoYm+Cv+PKiRl
         HlC6Uv9gw6nGkYVNl8XVhYtOcRqZjyu6Z7Ada5QKkwcjYH4vRGPiDJGUY0I4rpsbbuWw
         m9juV5MeI4UiBVl5MGNjIzLkynmByuL4ZYTy2qqcjX4u4Td9oAAWQ/HNWCOJtUX9qQsx
         IwSFJhLnHRmmYnxbmh1tMJe5VHDXIkZ6RgKEKxVWRf3g6962eA6359fOiF18tNEFi0P4
         HGm4jezvOKKG0fTFIK9DLV0kgcRXdN6p01lprX2z1apMI9C+gkNVjm7USxQIWxXxcRK/
         dVYw==
X-Gm-Message-State: AOAM532MhGqNAgliT0yyHo8aYMA/rYJO1FcVbdBS0wOXXHdCeXSqpZNu
        NPDPJCdyEaoT/3Mx+tm3EixFtQ==
X-Google-Smtp-Source: ABdhPJyHst8rpJfU0OKWtbSvpdPC7WXg9YC6Hb3jdcyfJboBdkuXF0s4ve1w/ooaebr3IHZ4VqAHpA==
X-Received: by 2002:a17:90b:ec2:: with SMTP id gz2mr1552296pjb.143.1611088160483;
        Tue, 19 Jan 2021 12:29:20 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id y16sm18379491pgg.20.2021.01.19.12.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 12:29:19 -0800 (PST)
Date:   Tue, 19 Jan 2021 12:29:12 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Subject: Re: [PATCH] x86/sgx: Remove redundant if conditions in
 sgx_encl_create
Message-ID: <YAdBGO00lEmAHR1g@google.com>
References: <20210118133358.99311-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118133358.99311-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 18, 2021, Tianjia Zhang wrote:
> In this scenario, there is no case where va_page is NULL, and
> the error has been checked. The if condition statement here is
> redundant, so remove the condition detection.
> 
> Reported-by: Jia Zhang <zhang.jia@linux.alibaba.com>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 90a5caf76939..f45957c05f69 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -66,9 +66,8 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>  	va_page = sgx_encl_grow(encl);
>  	if (IS_ERR(va_page))
>  		return PTR_ERR(va_page);
> -	else if (va_page)
> -		list_add(&va_page->list, &encl->va_pages);
> -	/* else the tail page of the VA page list had free slots. */
> +
> +	list_add(&va_page->list, &encl->va_pages);

Maybe add a WARN_ONCE to document/enforce the behavior?

	va_page = sgx_encl_grow(encl);
	if (IS_ERR(va_page))
		return PTR_ERR(va_page);

	if (WARN_ONCE(!va_page, "clever comment goes here))
		return -EIO;

	list_add(&va_page->list, &encl->va_pages);

>  
>  	/* The extra page goes to SECS. */
>  	encl_size = secs->size + PAGE_SIZE;
> -- 
> 2.19.1.3.ge56e4f7
> 
