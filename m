Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCDCC433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 16:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9863233EA
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 16:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389342AbhATQWs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403872AbhATQVN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 20 Jan 2021 11:21:13 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A796C061575
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 08:20:33 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id n10so15492449pgl.10
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 08:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MBqThV9Olupan+r++p/11MWGguLV0PkDywP+wSQi6Ys=;
        b=uHr2OtDySDWynGYYVHmG0ZLx5k0Xy3+cFC6x79NNNa1TrWBKQOCABpQ2bdlD2NfWMi
         +/GIjyJLmUCsaXB/23nUzfp1zu2SliNMi8A6LgxHad+C/2ZVK5kZFAW+jOYUu/xSZk1z
         EeUJsxPMVvRK6t87oEbGkUYD9HUWh+/eZHJk0qPLpKgo5PyjgsRk7/fUTcvhL2CkJFXs
         KqzPtAqvrzSyUY9ug0lU74cZsa3LZPrDUIO4XYFHc92PGnpclqfTtS9yQcUmZyxRCM/d
         IMe3GOyNJNRshNj9B5TpSjLH3tG7KBOic6wfjWmCytNxziT4f9tJX+9TY7otjNedyENs
         zVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MBqThV9Olupan+r++p/11MWGguLV0PkDywP+wSQi6Ys=;
        b=WwTfotpXNnpaZv3JlXPEHtk6u8d9XpUpUBpR+Nbf6gH/B7Fh68sUV1j9YuhoY8lmnw
         LUM2XP6/gW3MZfi2TXaVTaee5dQLsDdeP1wXnvJtShz5PESeF6I4aRdJ9/oO3Z3NTghf
         SONM7EtKE9O0bQ9/KqSD92wjABC0nO+IyKt2I31LVbhl/ryNp0vpOAULpQzIF/T+s3ot
         n+SfMpOjRRMi+ZUsJF6jVq8JSh+R4UPQ8s8E9eajZqWef/BObADqbRoy8qPfdGrq+L75
         zwpNwcwzABxBH4Nr6wCwygLVdp6LCDL6uO7ly4lV38RefZz3AD6sc/XvD2slIzN97hbE
         LrQg==
X-Gm-Message-State: AOAM532FY8fx2ViBL3W5Zr9diV6q+pzek6Om7ykgSe4q3pQWEQeL1KmR
        HbMB6dTe/aOWdpFqM4crvDiEvw==
X-Google-Smtp-Source: ABdhPJwXLSuAW3fgaBQRD1DO4EwQ6ZcDffSH9Tq2hezveyi9uLHs9gN6QuMVUx0nykOdqHLOYMS/7A==
X-Received: by 2002:a63:e40e:: with SMTP id a14mr10073281pgi.345.1611159632434;
        Wed, 20 Jan 2021 08:20:32 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id h6sm3049073pfr.47.2021.01.20.08.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 08:20:31 -0800 (PST)
Date:   Wed, 20 Jan 2021 08:20:25 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Subject: Re: [PATCH v2] x86/sgx: Allows ioctl PROVISION to execute before
 CREATE
Message-ID: <YAhYSdpIr60EUnRI@google.com>
References: <20210120035309.19545-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120035309.19545-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 20, 2021, Tianjia Zhang wrote:
> In function sgx_encl_create(), the logic of directly assigning
> value to attributes_mask determines that the call to
> SGX_IOC_ENCLAVE_PROVISION must be after the command of
> SGX_IOC_ENCLAVE_CREATE. If move this assignment statement to
> function sgx_open(), the PROVISION command can be executed
> earlier and more flexibly.

Use imperative mood to describe what you're doing, e.g. the "if" leaves the
reader wonder whether it's a suggestion or what the patch is actually doing.

E.g. something like

  Move the initialization of an enclave's allowed attributes_mask to
  sgx_open() to allow the ENCLAVE_PROVISION ioctl() to be invoked before
  ENCLAVE_CREATE.

> Reported-by: Jia Zhang <zhang.jia@linux.alibaba.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver.c | 3 +++
>  arch/x86/kernel/cpu/sgx/ioctl.c  | 1 -
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index f2eac41bb4ff..8766580194ae 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -36,6 +36,9 @@ static int sgx_open(struct inode *inode, struct file *file)
>  		return ret;
>  	}
>  
> +	encl->attributes_mask = SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
> +				SGX_ATTR_KSS;

Probably don't need a newline before SGX_ATTR_KSS.  In fact, I wouldn't be
surprised if Boris explicitly requested letting the original code go past 80
chars to improve readability.  Either way, with a cleaned up changelog:

Reviewed-by: Sean Christopherson <seanjc@google.com> 

> +
>  	file->private_data = encl;
>  
>  	return 0;
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 90a5caf76939..1c6ecf9fbeff 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -109,7 +109,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>  	encl->base = secs->base;
>  	encl->size = secs->size;
>  	encl->attributes = secs->attributes;
> -	encl->attributes_mask = SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | SGX_ATTR_KSS;
>  
>  	/* Set only after completion, as encl->lock has not been taken. */
>  	set_bit(SGX_ENCL_CREATED, &encl->flags);
> -- 
> 2.19.1.3.ge56e4f7
> 
