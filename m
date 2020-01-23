Return-Path: <SRS0=PkQm=3M=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1090FC2D0DB
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Jan 2020 14:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4DA9214AF
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Jan 2020 14:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="ldNGYoIQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgAWOed (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 Jan 2020 09:34:33 -0500
Received: from mail.skyhub.de ([5.9.137.197]:42570 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgAWOed (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 Jan 2020 09:34:33 -0500
Received: from zn.tnic (p200300EC2F095B00949AFC6560B2F054.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:5b00:949a:fc65:60b2:f054])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F20671EC0BEA;
        Thu, 23 Jan 2020 15:34:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1579790072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rtpPbYwQaCaisKQMp4l/ishRfEFtOdkzCnkfXG2CZp4=;
        b=ldNGYoIQgt86GVuoy6xDx3t3pnGMrMiqzHpKswP2qGsZ3iN8Rgh2fezrvAVyh5M//FQOQm
        HCNVRuEGaMQk+PLudtWrj9Kcr39A7wvkC62iAnwK3d2lXlLi+EH7Mhf0UV3vG62cOMulT1
        cOmne+7Eq714GrooVZ71hLND/bpZI8Q=
Date:   Thu, 23 Jan 2020 15:34:23 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] x86/sgx: Uncoditionally disallow SGX if MSRs are not
 writable
Message-ID: <20200123143423.GE10328@zn.tnic>
References: <20200123130746.20377-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200123130746.20377-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 23, 2020 at 03:07:46PM +0200, Jarkko Sakkinen wrote:
> As suggested by Borislav, disallow SGX if the PK MSRs are not writable.
> 
> Link: https://patchwork.kernel.org/patch/11267757/#23072371
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> Just a sanity check before merge, please ack that this is what you
> wanted.
>  arch/x86/kernel/cpu/intel.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 06252c82b8f7..0d57e9666de0 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -600,7 +600,7 @@ static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
>  
>  	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
>  		pr_info_once("sgx: The launch control MSRs are not writable\n");
> -		goto err_msrs_rdonly;
> +		goto err_unsupported;
>  	}
>  
>  	return;
> @@ -609,8 +609,6 @@ static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
>  	setup_clear_cpu_cap(X86_FEATURE_SGX);
>  	setup_clear_cpu_cap(X86_FEATURE_SGX1);
>  	setup_clear_cpu_cap(X86_FEATURE_SGX2);
> -
> -err_msrs_rdonly:
>  	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
>  }
>  
> -- 

Yap, looks about right.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
