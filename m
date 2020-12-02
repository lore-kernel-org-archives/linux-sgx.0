Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FFBC83013
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 10:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ECA2206E3
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 10:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388334AbgLBKIW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387847AbgLBKIW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 2 Dec 2020 05:08:22 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1209CC0613D6;
        Wed,  2 Dec 2020 02:07:42 -0800 (PST)
Received: from zn.tnic (p200300ec2f161b005f182bceb5dadd19.dip0.t-ipconnect.de [IPv6:2003:ec:2f16:1b00:5f18:2bce:b5da:dd19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6473A1EC03CF;
        Wed,  2 Dec 2020 11:07:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1606903660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YqhsvDALzL4/TeJ0/3F849dB/uyrKUaeeus7UR7foE8=;
        b=rlObo3Wqdrf/U/lwZ5AVn2SHSK4wd3k+h2dmPb20AFx3AMWlH8g3PW4Wm+wqBAyUywE42j
        UtgwhTZ9IuCpdmcGLGuLI4n4aN6cq7QIC42QGUey0uOhzi2+oEAiq2EgieiZBF1t1OT4Ol
        bM5H+XmNGBJ03hifx7/NXxk0A1pXIRA=
Date:   Wed, 2 Dec 2020 11:07:35 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 1/2] asm: sgx.h: fix a typo on a kernel-doc markup
Message-ID: <20201202100735.GA2951@zn.tnic>
References: <cover.1606897462.git.mchehab+huawei@kernel.org>
 <ca11a4540d981cbd5f026b6cbc8931aa55654e00.1606897462.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ca11a4540d981cbd5f026b6cbc8931aa55654e00.1606897462.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 02, 2020 at 09:27:14AM +0100, Mauro Carvalho Chehab wrote:
> As warned by kernel-doc:
> 	arch/x86/include/uapi/asm/sgx.h:19: warning: expecting prototype for enum sgx_epage_flags. Prototype was for enum sgx_page_flags instead
> 
> There is a typo at the kernel-doc markup:
> 
> 	sgx_epage_flags -> sgx_page_flags
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  arch/x86/include/uapi/asm/sgx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 791e45334a4a..9034f3007c4e 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -9,7 +9,7 @@
>  #include <linux/ioctl.h>
>  
>  /**
> - * enum sgx_epage_flags - page control flags
> + * enum sgx_page_flags - page control flags
>   * %SGX_PAGE_MEASURE:	Measure the page contents with a sequence of
>   *			ENCLS[EEXTEND] operations.
>   */
> -- 

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
