Return-Path: <SRS0=ohEA=EL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32870C4741F
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Nov 2020 15:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C8E222210
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Nov 2020 15:08:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="NDqrJZpf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgKEPIz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 5 Nov 2020 10:08:55 -0500
Received: from mail.skyhub.de ([5.9.137.197]:53862 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731050AbgKEPIy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 5 Nov 2020 10:08:54 -0500
Received: from zn.tnic (p200300ec2f0ee5009a3ef9f4dfadca8f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:e500:9a3e:f9f4:dfad:ca8f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AA5111EC02C1;
        Thu,  5 Nov 2020 16:08:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1604588932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=SNONstbNvXEZ9XiIXgtxs4kO9p+En2BqYsKM95T00+c=;
        b=NDqrJZpfZMhASoS5ddG9pJaiKrova5DbT+9vUdcT4HVdT62a1HKc63cmVZJEK1LetaazJS
        Z7IJtRRWbe99qK9OpRzcJx24TdSK50TU0aBNPyv6s+AWmP1U3U1a1KcmhPDFoEpcajkkIZ
        d/I01iO9UzuXSXu5GPLajxfU9NT/fIk=
Date:   Thu, 5 Nov 2020 16:08:39 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v40 09/24] x86/sgx: Add SGX page allocator functions
Message-ID: <20201105150839.GB25636@zn.tnic>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-10-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201104145430.300542-10-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 04, 2020 at 04:54:15PM +0200, Jarkko Sakkinen wrote:
> The previous patch initialized a simple SGX page allocator.  Add functions
> for runtime allocation and free.
> 
> This allocator and its algorithms are as simple as it gets.  They do a
> linear search across all EPC sections and find the first free page.  They
> are not NUMA aware and only hand out individual pages.  The SGX hardware
> does not support large pages, so something more complicated like a buddy
> allocator is unwarranted.
> 
> The free function (sgx_free_epc_page()) implicitly calls ENCLS[EREMOVE],
> which returns the page to the uninitialized state.  This ensures that the
> page is ready for use at the next allocation.
> 
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 62 ++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++
>  2 files changed, 65 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 956055a0eff6..b9ac438a13a4 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -85,6 +85,68 @@ static bool __init sgx_page_reclaimer_init(void)
>  	return true;
>  }
>  
> +static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
> +{
> +	struct sgx_epc_page *page;
> +
> +	if (list_empty(&section->page_list))
> +		return NULL;
> +
> +	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
> +	list_del_init(&page->list);
> +
> +	return page;
> +}
> +
> +/**
> + * __sgx_alloc_epc_page() - Allocate an EPC page
> + *
> + * Iterate through EPC sections and borrow a free EPC page to the caller. When a
> + * page is no longer needed it must be released with sgx_free_epc_page().
> + *
> + * Return:
> + *   an EPC page,
> + *   -errno on error
> + */
> +struct sgx_epc_page *__sgx_alloc_epc_page(void)
> +{
> +	struct sgx_epc_section *section;
> +	struct sgx_epc_page *page;
> +	int i;
> +
> +	for (i = 0; i < sgx_nr_epc_sections; i++) {
> +		section = &sgx_epc_sections[i];
> +		spin_lock(&section->lock);
> +		page = __sgx_alloc_epc_page_from_section(section);
> +		spin_unlock(&section->lock);

Something for a future cleanup: you can put that logic into
__sgx_alloc_epc_page_from_section() and simplify this one call site.

But not now - you can do that later or if v41 needs to be sent out...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
