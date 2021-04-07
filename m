Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E433C43460
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 15:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38C23610C7
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 15:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353844AbhDGPuK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Apr 2021 11:50:10 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53810 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353957AbhDGPtq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Apr 2021 11:49:46 -0400
Received: from zn.tnic (p200300ec2f08fb00aad493ab6ea3c721.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:fb00:aad4:93ab:6ea3:c721])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 127181EC0301;
        Wed,  7 Apr 2021 17:49:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617810575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=d1Opu7AKJgNAtUx5a3eSNKbEBw8Cs3g1lPL7E4oO9mE=;
        b=INpuBN5dtpg+hBiXg2WZP+vbIXyHD/tZNAyqyR8gnO1tRsm/D9Xk0fk0OC3Pmu2UAUt6Tu
        FPIUd3/PBmgUYC/+8AMBGD/athVrnrY0/RHYHOVZ7GaNDCl29eeD+1ncAskSoNx8cNjfS6
        6MLJ39hZwn+gcGWuNLEwgMcytzow0qQ=
Date:   Wed, 7 Apr 2021 17:49:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/sgx: Do not update sgx_nr_free_pages in
 sgx_setup_epc_section()
Message-ID: <20210407154934.GF25319@zn.tnic>
References: <20210405232653.33680-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210405232653.33680-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 06, 2021 at 02:26:52AM +0300, Jarkko Sakkinen wrote:
> Now that the sanitization process will make pages available by calling
> sgx_free_epc_page(), sgx_setup_epc_section() should not touch to
> sgx_nr_free_pages. This will result sgx_nr_free_pages to contain 2x the
> number of actual free pages. Simply, remove the statement.
> 
> Fixes: 51ab30eb2ad4 ("x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 13a7599ce7d4..7df7048cb1c9 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -657,7 +657,6 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
>  	}
>  
> -	sgx_nr_free_pages += nr_pages;
>  	return true;
>  }
>  

First of all, I don't know how I didn't catch this:

/* The free page list lock protected variables prepend the lock. */
static unsigned long sgx_nr_free_pages;

I need some sort of translator to understand what this comment means. I
can guess what is trying to tell me.

Which leads to my question: what is sgx_nr_free_pages supposed to denote?

Because I understand the callpath

sgx_page_cache_init
...
for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
	...
	sgx_setup_epc_section
	...
		sgx_nr_free_pages += nr_pages;

as adding the number of pages of each new EPC section to the total
number of the free pages. Unless that variable accounts something else.

So what does this variable actually mean?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
