Return-Path: <SRS0=u9ux=7I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEE3C433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 26 May 2020 12:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B7C320787
	for <linux-sgx@archiver.kernel.org>; Tue, 26 May 2020 12:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="qlSo2Zbx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgEZMwU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 May 2020 08:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgEZMwU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 26 May 2020 08:52:20 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D1FC03E96D;
        Tue, 26 May 2020 05:52:20 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0f910029cc1ac058818593.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:9100:29cc:1ac0:5881:8593])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CD3C51EC0118;
        Tue, 26 May 2020 14:52:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590497538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZGH6cJ+EMFRFX4aplnDSD+DpMuQLo38Ps+fJV82VzCI=;
        b=qlSo2ZbxzQoEd46ObhBqeRWPa6sLsZbdFDMdO6sqoBqhzSgPMMxW0dZvXVV9mMQ/2l//1O
        sHyXBTNiS43qkWgA9OkgGUuAzdGy61Wu2libvEx7SeFNdr3MH860Ee7RdoT/YGbR1ryt4V
        VUppJQiINcI6WieHJiReA+PRI0FpEB0=
Date:   Tue, 26 May 2020 14:52:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com, Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 08/20] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20200526125207.GE28228@zn.tnic>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 15, 2020 at 03:43:58AM +0300, Jarkko Sakkinen wrote:
> Add functions for allocating page from Enclave Page Cache (EPC). A page is

				pages

> allocated by going through the EPC sections and returning the first free
> page.
> 
> When a page is freed, it might have a valid state, which means that the
> callee has assigned it to an enclave, which are protected memory ares used

								  areas

although explaining what enclaves are has already happened so probably
not needed here too.

> to run code protected from outside access. The page is returned back to the
> invalid state with ENCLS[EREMOVE] [1].
> 
> [1] Intel SDM: 40.3 INTEL® SGX SYSTEM LEAF FUNCTION REFERENCE
> 
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 60 ++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 38424c1e8341..60d82e7537c8 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -13,6 +13,66 @@
>  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
>  int sgx_nr_epc_sections;
>  
> +static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section)
> +{
> +	struct sgx_epc_page *page;
> +
> +	if (list_empty(&section->page_list))
> +		return NULL;
> +
> +	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
> +	list_del_init(&page->list);
> +	return page;
> +}
> +
> +/**
> + * sgx_try_alloc_page() - Allocate an EPC page

Uuh, this is confusing. Looking forward into the patchset, you guys have

sgx_alloc_page()
sgx_alloc_va_page()

and this here

sgx_try_alloc_page()

So this one here should be called sgx_alloc_epc_page() if we're going to
differentiate *what* it is allocating.

But then looking at sgx_alloc_page():

+ * sgx_alloc_page() - Allocate an EPC page
...

+ struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)

this one returns a struct sgx_epc_page * too.

The former "allocates" from the EPC cache so I'm thinking former should
not have "alloc" in its name at all. It should be called something like

sgx_get_epc_page()

or so.

Now, looking at sgx_alloc_page(), it does call this one -
sgx_try_alloc_page() to get a page from the page list but it
does not allocate anything. The actual allocation happens in
sgx_alloc_epc_section() which actually does the k*alloc().

Which sounds to me like those functions should not use "alloc" and
"free" in their names but "get" and "put" to denote that they're simply
getting pages from lists and returning them back to those lists.

IMNSVHO.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
