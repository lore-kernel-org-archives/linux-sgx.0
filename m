Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45648C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Feb 2021 12:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 144ED64E05
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Feb 2021 12:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhBLMHP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Feb 2021 07:07:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhBLMHN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 12 Feb 2021 07:07:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 364AF61494;
        Fri, 12 Feb 2021 12:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613131592;
        bh=Y2BRtIDsnLGMMrGNMNMBDXvpJd3MBdqDWLlT2DdDoNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kxI4/NM5zitqb/x+mMxxolEMHfy2S7NWZhaV+AJvS+ieQNatDV8blbaM0+LYNDJ72
         riRR8dRLhSLz4wqBeT76aF3MAvRZZoPhpNgx/t13s5hfXFDMxoEQvQWUWEhd9g32dy
         jb0Z0o+W8K2Ch+qYmAYGPTO+xVsnVc9Ic2ww7PARwm1yWPH66Mybz1qTkXRxH/epKL
         p2+DsFdYQyVfZZOc2T/jTKWvJtIaz1DSkk8wigaBJX8Ozr9kuR4AAcLZ9VizXRE03x
         8TsltlU4W6dRvDkjsp/g4J1UOHlU4/FGCHqmzxXtMKTx6lTy6rU5IeZhy5kBlFXJo6
         YhigKchUC9cjw==
Date:   Fri, 12 Feb 2021 14:06:23 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     luto@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Subject: Re: [PATCH] arch: x86: entry: vdso: Fix the spelling postive to
 positive in the file vsgx.S
Message-ID: <YCZvPzMGmGjgfRN0@kernel.org>
References: <20210210084610.1213418-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210084610.1213418-1-unixbhaskar@gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 10, 2021 at 02:16:10PM +0530, Bhaskar Chowdhury wrote:
> 
> 
> s/postive/positive/

A bit more verbose, please, e.g.:

"Fix spelling error in arch/x86/entry/vdso/vsgx.S: postive -> positive."

> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  arch/x86/entry/vdso/vsgx.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vsgx.S
> index 86a0e94f68df..99dafac992e2 100644
> --- a/arch/x86/entry/vdso/vsgx.S
> +++ b/arch/x86/entry/vdso/vsgx.S
> @@ -137,7 +137,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> 
>  	/*
>  	 * If the return from callback is zero or negative, return immediately,
> -	 * else re-execute ENCLU with the postive return value interpreted as
> +	 * else re-execute ENCLU with the positive return value interpreted as
>  	 * the requested ENCLU function.
>  	 */
>  	cmp	$0, %eax
> --
> 2.30.0
> 
> 



Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
