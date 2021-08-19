Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF897C4338F
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 16:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87C26610A5
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 16:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhHSQH7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Aug 2021 12:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhHSQH6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 19 Aug 2021 12:07:58 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6B0C061756
        for <linux-sgx@vger.kernel.org>; Thu, 19 Aug 2021 09:07:22 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id k19so5944109pfc.11
        for <linux-sgx@vger.kernel.org>; Thu, 19 Aug 2021 09:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+Ivs19hxZAuXthjTGXZ/cCu7HehYBGiRHsXTwhvJSRA=;
        b=iV0mm3t92jJpnbRySYEB57+24abag2szQX5J4Ox4Qt11G8cHIAwHS68gaoj3xAeu+H
         LS5gy+5b281d0elBAgmX3ZKZfeX7yEjYy0E0hQ4NxOFTeoJbW6dfTCvV6dwimyhn3Jyo
         A4OoI5FRUSJF2RZVtlotxM0ib1gAOfUb1DrWaBNnr7KbtuVWW92/H2twXUSuMpbYAdiR
         wnLVZVGknhBRYUTYs0NBLGarbEL+Ez0TEkRsC5e7DDunBjQYEXSpqzh6d2gqXLuUlg7a
         7/4f6WUstkjGRi+j6LaPbKdW24flc7WGGK2Z597MmkmA5quCapgDpgXZBGkChOas0fUX
         PBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+Ivs19hxZAuXthjTGXZ/cCu7HehYBGiRHsXTwhvJSRA=;
        b=cDOYYmKm9qm62KtS5Jklq/TUeLGZvR8lRyG3O0DlG5OSZnANupO2JKFvBbEQNgaU5Q
         IWdd4EENGYLD1so41WTo/akMjauuW7sIrvyv96aq2xj6SSMnaDX/zD8YG5kqgtPfzmSd
         2d0x3OJ3+ROjmrNzITrpWPPoe6Uzr2Mkm+XQHlY6eDs0Y+fK0cxcbXL6YbPKrMdSXtQf
         exq0n/1WStgdf/pwO7hmbCPreRy0kqg5r2uVsUkIE2OlbNtrKdECwc2HZ01Q1+I3/RU5
         6DOk+gz7nM5jVxEwTVpR3WkHDqpS82kQYmbTbV/ES2zxRhyrX0YSeudsztRITqsNv/vU
         cGlA==
X-Gm-Message-State: AOAM532KYAIparLxZ15r+Pll2FWTjiP3GKaUCmDcn4hhx+qGfQGbuiRz
        SkaHosdXpdPljv+mPy+DeQJrZQ==
X-Google-Smtp-Source: ABdhPJyqv7vRQnu3Uwxue26rviB/56za4BppxSl/aie732kfuK2eKPQijaPJ/7QFtgM1QtVuV5DN+A==
X-Received: by 2002:a62:1892:0:b029:349:1b8f:af2b with SMTP id 140-20020a6218920000b02903491b8faf2bmr15574595pfy.20.1629389241675;
        Thu, 19 Aug 2021 09:07:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f9sm9288458pjq.36.2021.08.19.09.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 09:07:21 -0700 (PDT)
Date:   Thu, 19 Aug 2021 16:07:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/sgx: Add the missing ifdef for
 sgx_set_attribute()
Message-ID: <YR6Bs2twT4EK/jUK@google.com>
References: <20210819124824.52169-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819124824.52169-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 19, 2021, Jarkko Sakkinen wrote:
> Similarly as sgx_virt_*, decorate sgx_set_attribute() with ifdef, so that
> calling it without appropraite config flags, will cause a compilation
> error, and not a linking error.
> 
> Fixes: b3754e5d3da3 ("x86/sgx: Move provisioning device creation out of SGX driver")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/x86/include/asm/sgx.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 05f3e21f01a7..38c397ef35a8 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -365,6 +365,11 @@ struct sgx_sigstruct {
>   * comment!
>   */
>  
> +#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)

X86_SGX_KVM depends on X86_SGX

And rather than shuffle code, you can wrap all of the prototypes, which has the
added bonus of "documenting" the aformentioned dependency, e.g.

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 05f3e21f01a7..d5f3e617cc38 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -365,6 +365,7 @@ struct sgx_sigstruct {
  * comment!
  */

+#ifdef CONFIG_X86_SGX
 #ifdef CONFIG_X86_SGX_KVM
 int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
                     int *trapnr);
@@ -374,5 +375,6 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,

 int sgx_set_attribute(unsigned long *allowed_attributes,
                      unsigned int attribute_fd);
+#endif /* CONFIG_X86_SGX */

 #endif /* _ASM_X86_SGX_H */
