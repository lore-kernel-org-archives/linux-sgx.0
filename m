Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEA7C2D0E4
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Nov 2020 18:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E8312465E
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Nov 2020 18:15:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqKVL5Z3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgKQSOs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Nov 2020 13:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgKQSOr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Nov 2020 13:14:47 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCDF42462E;
        Tue, 17 Nov 2020 18:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605636886;
        bh=Zo7ZhZu4hr8dzjmIJAUlUJ3adtcEXpkIdPJcQMt35fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MqKVL5Z3z6XJugchnRsrPdGtTqFSAwKErinRMrpKjlsllktUog87TeKw/xbg9Ghgo
         fTYz7EN8IV6XNHNq22DIIBuEVjnQVYo+dWZ35LcmQEyPHO+RJ15g5FgBIEOLvKYvW4
         iqr3beMOKSzENA7F0tgAWvxN2thwEGjXQfV3QB9k=
Date:   Tue, 17 Nov 2020 20:14:41 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org
Subject: Re: [PATCH v41 09/24] x86/sgx: Add SGX page allocator functions
Message-ID: <20201117181426.GF8524@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
 <20201114093256.7800-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114093256.7800-1-hdanton@sina.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 14, 2020 at 05:32:56PM +0800, Hillf Danton wrote:
> On Fri, 13 Nov 2020 00:01:20 +0200 Jarkko Sakkinen wrote:
> > 
> > The previous patch initialized a simple SGX page allocator.  Add functions
> > for runtime allocation and free.
> > 
> > This allocator and its algorithms are as simple as it gets.  They do a
> > linear search across all EPC sections and find the first free page.  They
> > are not NUMA aware and only hand out individual pages.  The SGX hardware
> > does not support large pages, so something more complicated like a buddy
> > allocator is unwarranted.
> > 
> > The free function (sgx_free_epc_page()) implicitly calls ENCLS[EREMOVE],
> > which returns the page to the uninitialized state.  This ensures that the
> > page is ready for use at the next allocation.
> > 
> > Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
> > # Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > # Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 65 ++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++
> >  2 files changed, 68 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 187a237eec38..2e53afc288a4 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -85,6 +85,71 @@ static bool __init sgx_page_reclaimer_init(void)
> >  	return true;
> >  }
> >  
> > +static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
> > +{
> > +	struct sgx_epc_page *page;
> > +
> > +	spin_lock(&section->lock);
> > +
> > +	if (list_empty(&section->page_list)) {
> > +		spin_unlock(&section->lock);
> > +		return NULL;
> > +	}
> > +
> > +	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
> > +	list_del_init(&page->list);
> > +
> > +	spin_unlock(&section->lock);
> > +	return page;
> > +}
> > +
> > +/**
> > + * __sgx_alloc_epc_page() - Allocate an EPC page
> > + *
> > + * Iterate through EPC sections and borrow a free EPC page to the caller. When a
> > + * page is no longer needed it must be released with sgx_free_epc_page().
> > + *
> > + * Return:
> > + *   an EPC page,
> > + *   -errno on error
> > + */
> > +struct sgx_epc_page *__sgx_alloc_epc_page(void)
> > +{
> > +	struct sgx_epc_section *section;
> > +	struct sgx_epc_page *page;
> > +	int i;
> > +
> > +	for (i = 0; i < sgx_nr_epc_sections; i++) {
> > +		section = &sgx_epc_sections[i];
> > +
> > +		page = __sgx_alloc_epc_page_from_section(section);
> > +		if (page)
> > +			return page;
> > +	}
> > +
> > +	return ERR_PTR(-ENOMEM);
> > +}
> > +
> > +/**
> > + * sgx_free_epc_page() - Free an EPC page
> > + * @page:	an EPC page
> > + *
> > + * Call EREMOVE for an EPC page and insert it back to the list of free pages.
> > + */
> > +void sgx_free_epc_page(struct sgx_epc_page *page)
> > +{
> > +	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
> > +	int ret;
> > +
> > +	ret = __eremove(sgx_get_epc_virt_addr(page));
> > +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> > +		return;
> > +
> > +	spin_lock(&section->lock);
> > +	list_add_tail(&page->list, &section->page_list);
> 
> Add head in favor of allocators coming before LLC becomes cold.

Nice suggestion, thank you.

/Jarkko
