Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B517DC433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Feb 2021 16:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B3E864E77
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Feb 2021 16:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhBJQQK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Feb 2021 11:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhBJQQJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 10 Feb 2021 11:16:09 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F59C06174A;
        Wed, 10 Feb 2021 08:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=CYJcVmBGnQFQ/SiKsdw+9m6uk0EkGnIzHiS6mQ/l9EA=; b=IIReaBY3my2Iiy3g/T1IDkRjGn
        I/mGj7K2xxWQ4IrS96nsAacFfLoUHzv+hl97OwdoNt5AFmzLqnuoA/Yem+YYHLJDqxzYtGUt2xfQ4
        POWLBJrukyfs5JiHcB/chu/F2QEqNOLUCPLhkOvinmdn2P4ewS/GzuOrN8DnsPk1AeAF6+0cu+uUB
        O8LJhO92OHrh1qjXZjUC6Vh3/hIJlMl46fDrIQzq6TumEM7Be0z4u4xzp7VVlusJHM9MWOlhNuyFE
        92mpXhtORZCkGRp9nh41k8ir21ZNFmI3ZcB4N/ly6i9FDYpz5rPbQRUBK5AbbjQwSdCAttK4hdjE8
        JgGynQ7A==;
Received: from [2601:1c0:6280:3f0::cf3b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l9s9F-00063d-Kw; Wed, 10 Feb 2021 16:15:26 +0000
Subject: Re: [PATCH] arch: x86: entry: vdso: Fix the spelling postive to
 positive in the file vsgx.S
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, jarkko@kernel.org,
        luto@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210210084610.1213418-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <9a5bc424-d438-7d30-4bc6-8367554b4bd4@infradead.org>
Date:   Wed, 10 Feb 2021 08:15:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210210084610.1213418-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/10/21 12:46 AM, Bhaskar Chowdhury wrote:
> 
> 
> s/postive/positive/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

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


-- 
~Randy

