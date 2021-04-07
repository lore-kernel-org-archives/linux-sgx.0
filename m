Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC35C433ED
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 15:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B697761382
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 15:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347463AbhDGP4n (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Apr 2021 11:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbhDGP4n (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 7 Apr 2021 11:56:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC91C061756;
        Wed,  7 Apr 2021 08:56:33 -0700 (PDT)
Received: from zn.tnic (p200300ec2f08fb00aad493ab6ea3c721.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:fb00:aad4:93ab:6ea3:c721])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6920B1EC0246;
        Wed,  7 Apr 2021 17:56:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617810992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=2zy9HaPp5QLTjnLtg7mOMCS8VHEuMJmllA5VVq4pXfA=;
        b=SGUPhPZooTM09vE1dvF+pLLS/ShXMuXgmoIl0QilN7iqvo9i1/02XNw9Qgip2vA0vhWno0
        CYY+AarzAw07VwmfQIPxeTpFGeMlM/JP9NATAEj2QEVx/owxEPuTHHSFFqA+nsd94tHE85
        CLZQ4eaPelqxZwjTQf7IKOaxnmVr1lU=
Date:   Wed, 7 Apr 2021 17:56:36 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the
 debugfs
Message-ID: <20210407155636.GG25319@zn.tnic>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210405232653.33680-2-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210405232653.33680-2-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 06, 2021 at 02:26:53AM +0300, Jarkko Sakkinen wrote:
> Add two debugs attributes:
> 
> * /sys/kernel/debug/x86/sgx_nr_all_pages
> * /sys/kernel/debug/x86/sgx_nr_free_pages

Definitely under /sys/kernel/debug/x86/sgx/...
				      ^^^^^^

> These provide useful statistics for testing purposes.

Testing what exactly?

Also, if those are EPC pages, why isn't "epc" in the name?

> E.g. on a NUC7CJYH2, when no enclaves are running, and EPC set to 32 MB:
> 
> $ sudo cat /sys/kernel/debug/x86/sgx_nr_all_pages
> 5632
> 
> $ sudo cat /sys/kernel/debug/x86/sgx_nr_free_pages
> 5632

I have no clue what that is useful for. You want to account how many of
the EPC pages on all nodes are in use? What for?

Are those globally useful for people? If so, they need to go to sysfs
along with documentation what they do.

If not, you can keep this patch in your tree for your own testing.

> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> 
> v2:
> * Use debugfs_create_ulong():
>   https://lore.kernel.org/linux-sgx/57c18e08-3e36-b5b3-aaba-9a21b75a1613@intel.com/
> 
>  arch/x86/kernel/cpu/sgx/main.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 7df7048cb1c9..07bad864c531 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*  Copyright(c) 2016-20 Intel Corporation. */
>  
> +#include <linux/debugfs.h>
>  #include <linux/freezer.h>
>  #include <linux/highmem.h>
>  #include <linux/kthread.h>
> @@ -25,7 +26,10 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
>  static LIST_HEAD(sgx_active_page_list);
>  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
>  
> -/* The free page list lock protected variables prepend the lock. */
> +/* The number of EPC pages in total in all nodes. */
> +static unsigned long sgx_nr_all_pages;
> +
> +/* The number of free EPC pages in all nodes. */
>  static unsigned long sgx_nr_free_pages;

Ok, you're fixing the comment here. Good.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
