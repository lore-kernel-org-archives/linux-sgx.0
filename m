Return-Path: <SRS0=Nw9Y=X6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31EA8C47404
	for <linux-sgx@archiver.kernel.org>; Sat,  5 Oct 2019 16:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0762422477
	for <linux-sgx@archiver.kernel.org>; Sat,  5 Oct 2019 16:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="DoQZoM5U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfJEQoP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 5 Oct 2019 12:44:15 -0400
Received: from mail.skyhub.de ([5.9.137.197]:34078 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfJEQoP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 5 Oct 2019 12:44:15 -0400
Received: from zn.tnic (p200300EC2F1EF900329C23FFFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ec:2f1e:f900:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 11B1D1EC02C1;
        Sat,  5 Oct 2019 18:44:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570293854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+YX1vtj2G53vkynUCkCYWZd/IUTyT9OXhsEBg1eZng=;
        b=DoQZoM5UATS94gv+/JIxMp7gtDdvOQUga0XbTeLs7V/1bbtlOAd1TdGtWpFLWEcdf8YPNa
        1tRIVANOuAc0VtGgJBrkPjIG9NmSFwa9M0LS/SgOwen4P238AlOYnBiQHyOP2/4yydl+ew
        Z9Bjs54NYD4PmjtX+XDbRZvnPEQ3oh0=
Date:   Sat, 5 Oct 2019 18:44:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 09/24] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20191005164408.GB25699@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-10-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190903142655.21943-10-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 03, 2019 at 05:26:40PM +0300, Jarkko Sakkinen wrote:
> Add functions for grabbing EPC pages into use:
> 
> * sgx_alloc_page(): Iterate the EPC sections and return the first free
>   page, or ERR_PTR(-ENOMEM) when no free pages are available.
> * __sgx_free_page(): Return the page into uninitialized state and move
>   it back to the corresponding EPC section structure. Issues WARN()
>   when EREMOVE fails.
> * sgx_free_page(): Return the page into uninitialized state and move
>   it back to the corresponding EPC section structure. Returns
>   ENCLS[EREMOVE] error code back to the caller.
> 
> [1] Intel SDM: 40.3 INTEL® SGX SYSTEM LEAF FUNCTION REFERENCE
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 90 ++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h  |  4 ++
>  2 files changed, 94 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index e2317f6e4374..6b4727df72ca 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -9,6 +9,7 @@
>  #include <linux/sched/signal.h>
>  #include <linux/slab.h>
>  #include "arch.h"
> +#include "encls.h"
>  #include "sgx.h"
>  
>  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> @@ -16,6 +17,95 @@ EXPORT_SYMBOL_GPL(sgx_epc_sections);
>  
>  int sgx_nr_epc_sections;
>  
> +static struct sgx_epc_page *sgx_section_get_page(

That fits into 80 cols (oh well, 81) and even if not, a trailing opening
arg brace is ugly.

> +	struct sgx_epc_section *section)
> +{
> +	struct sgx_epc_page *page;
> +
> +	if (!section->free_cnt)
> +		return NULL;
> +
> +	page = list_first_entry(&section->page_list,
> +				struct sgx_epc_page, list);

That fits in 80-cols too. Why break it?

> +	list_del_init(&page->list);
> +	section->free_cnt--;
> +	return page;
> +}
> +
> +/**
> + * sgx_alloc_page - Allocate an EPC page
> + *
> + * Try to grab a page from the free EPC page list.
> + *
> + * Return:
> + *   a pointer to a &struct sgx_epc_page instance,
> + *   -errno on error
> + */
> +struct sgx_epc_page *sgx_alloc_page(void)
> +{
> +	struct sgx_epc_section *section;
> +	struct sgx_epc_page *page;
> +	int i;
> +
> +	for (i = 0; i < sgx_nr_epc_sections; i++) {
> +		section = &sgx_epc_sections[i];
> +		spin_lock(&section->lock);
> +		page = sgx_section_get_page(section);
> +		spin_unlock(&section->lock);
> +
> +		if (page)
> +			return page;
> +	}
> +
> +	return ERR_PTR(-ENOMEM);
> +}
> +EXPORT_SYMBOL_GPL(sgx_alloc_page);

That export gets removed later too. But you know already...

> +
> +/**
> + * __sgx_free_page - Free an EPC page
> + * @page:	pointer a previously allocated EPC page
> + *
> + * EREMOVE an EPC page and insert it back to the list of free pages.
> + *
> + * Return:
> + *   0 on success
> + *   SGX error code if EREMOVE fails
> + */
> +int __sgx_free_page(struct sgx_epc_page *page)
> +{
> +	struct sgx_epc_section *section = sgx_epc_section(page);
> +	int ret;

Shouldn't you be grabbing the lock here already?

Or nothing can happen to that page from another thread after you
ENCLS[EREMOVE] it and before it is added to the ->page_list of the
section?

> +
> +	ret = __eremove(sgx_epc_addr(page));
> +	if (ret)
> +		return ret;
> +
> +	spin_lock(&section->lock);
> +	list_add_tail(&page->list, &section->page_list);
> +	section->free_cnt++;
> +	spin_unlock(&section->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__sgx_free_page);
> +
> +/**
> + * sgx_free_page - Free an EPC page and WARN on failure
> + * @page:	pointer to a previously allocated EPC page
> + *
> + * EREMOVE an EPC page and insert it back to the list of free pages, and WARN
> + * if EREMOVE fails.  For use when the call site cannot (or chooses not to)
> + * handle failure, i.e. the page is leaked on failure.
> + */
> +void sgx_free_page(struct sgx_epc_page *page)
> +{
> +	int ret;
> +
> +	ret = __sgx_free_page(page);
> +	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);

That will potentially flood dmesg. Why are we even accommodating such
callers? They either handle the error or they don't get to alloc EPC
pages. There's also __must_check with which you can enforce the error
code checking or we simply don't allow not handling failure. Fullstop.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
