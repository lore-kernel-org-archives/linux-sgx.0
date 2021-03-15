Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B8DC433DB
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Mar 2021 19:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B16F264F18
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Mar 2021 19:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhCOTOe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Mar 2021 15:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232713AbhCOTO2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 15 Mar 2021 15:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 394BD64F42;
        Mon, 15 Mar 2021 19:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615835667;
        bh=w+O8tE8/lNNiCyFoSErd8fAKbqEYMyYn1crZ5A7Oqsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O/fxbkHz61MPlamyRYwhQGnnWowANB7No+beb8cRy19YCitsX/WZXpMjAd+Xw95da
         gwENIdS0x3iG3V3DQlpRlIIHSZgXOK2Yq+OODwh9303V2LjXSneU1h+S5auliqY19D
         LmuvncmySj4GuO7g7Sav3wJg+AQPGxrDvla1OFvGm/QFvSKAkBu5wJOSFRAmbpXNOu
         O9nRRU/x1XqAx1yqqov0y+WmX48YkvyTxidRJata95UYzzg6yVNR0hlhWZ2mpx+V5k
         9jCH+uVIay8e72QsooCvB6XkuUiBQKodGY1CYVcCIh7NQqiOiLctzZLrtuKrJpuaZU
         0cvyWboe4/G+A==
Date:   Mon, 15 Mar 2021 21:14:02 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] x86/sgx: Replace section local dirty page lists
 with a global list
Message-ID: <YE+x+lhDYnKZ1933@kernel.org>
References: <20210313160119.1318533-1-jarkko@kernel.org>
 <20210313160119.1318533-3-jarkko@kernel.org>
 <b2a02fa6-8076-9fe4-59b7-91a91f44aaf7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2a02fa6-8076-9fe4-59b7-91a91f44aaf7@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 15, 2021 at 09:03:21AM -0700, Dave Hansen wrote:
> On 3/13/21 8:01 AM, Jarkko Sakkinen wrote:
> > Reset initialized EPC pages in sgx_dirty_page_list to uninitialized state,
> > and free them using sgx_free_epc_page(). Do two passes, as for SECS pages
> > the first round can fail, if all child pages have not yet been removed.
> > The driver puts all pages on startup first to sgx_dirty_page_list, as the
> > initialization could be triggered by kexec(), meaning that pages have been
> > reserved for active enclaves before the operation.
> > 
> > The section local lists are redundant, as sgx_free_epc_page() figures
> > out the correction by using epc_page->section.
> 
> During normal runtime, the "ksgxd" daemon behaves like a  version of
> kswapd just for SGX.  But, its first job is to initialize enclave
> memory.  This is done in a a separate thread because this initialization
> can be quite slow.
> 
> Currently, the SGX boot code places each enclave page on a
> sgx_section-local list (init_laundry_list).  Once it starts up, the
> ksgxd code walks over that list and populates the actual SGX page allocator.
> 
> However, the per-section structures are going away to make way for the
> SGX NUMA allocator.  There's also little need to have a per-section
> structure; the enclave pages are all treated identically, and they can
> be placed on the correct allocator list from metadata stoered in the
> enclave page itself.
> 
Is this a suggestion how to rephrase the commit message? :-)

> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 65004fb8a91f..cb4561444b96 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -27,39 +27,10 @@ static LIST_HEAD(sgx_active_page_list);
> >  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
> >  
> >  /*
> > - * Reset dirty EPC pages to uninitialized state. Laundry can be left with SECS
> > - * pages whose child pages blocked EREMOVE.
> > + * When the driver initialized, EPC pages go first here, as they could be
> > + * initialized to an active enclave, on kexec entry.
> >   */
> > -static void sgx_sanitize_section(struct sgx_epc_section *section)
> > -{
> > -	struct sgx_epc_page *page;
> > -	LIST_HEAD(dirty);
> > -	int ret;
> > -
> > -	/* init_laundry_list is thread-local, no need for a lock: */
> > -	while (!list_empty(&section->init_laundry_list)) {
> > -		if (kthread_should_stop())
> > -			return;
> > -
> > -		/* needed for access to ->page_list: */
> > -		spin_lock(&section->lock);
> > -
> > -		page = list_first_entry(&section->init_laundry_list,
> > -					struct sgx_epc_page, list);
> > -
> > -		ret = __eremove(sgx_get_epc_virt_addr(page));
> > -		if (!ret)
> > -			list_move(&page->list, &section->page_list);
> > -		else
> > -			list_move_tail(&page->list, &dirty);
> > -
> > -		spin_unlock(&section->lock);
> > -
> > -		cond_resched();
> > -	}
> > -
> > -	list_splice(&dirty, &section->init_laundry_list);
> > -}
> > +static LIST_HEAD(sgx_dirty_page_list);
> >  
> >  static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
> >  {
> > @@ -400,25 +371,48 @@ static bool sgx_should_reclaim(unsigned long watermark)
> >  
> >  static int ksgxd(void *p)
> >  {
> > -	int i;
> > +	struct sgx_epc_page *page;
> > +	LIST_HEAD(dirty);
> > +	int i, ret;
> >  
> >  	set_freezable();
> >  
> >  	/*
> > -	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
> > -	 * required for SECS pages, whose child pages blocked EREMOVE.
> > +	 * Reset initialized EPC pages in sgx_dirty_page_list to uninitialized state,
> > +	 * and free them using sgx_free_epc_page(). 
> 
> I'm not a fan of comments that tell us verbatim what the code does.

So, what are you suggesting? Remove the whole comment or parts of it? I'm
presuming that you suggest removing the "top-level" part.

> 
> >							Do two passes, as for SECS pages the
> > +	 * first round can fail, if all child pages have not yet been removed.  The
> > +	 * driver puts all pages on startup first to sgx_dirty_page_list, as the
> > +	 * initialization could be triggered by kexec(), meaning that pages have been
> > +	 * reserved for active enclaves before the operation.
> >  	 */
> 
> 
> 
> > -	for (i = 0; i < sgx_nr_epc_sections; i++)
> > -		sgx_sanitize_section(&sgx_epc_sections[i]);
> >  
> > -	for (i = 0; i < sgx_nr_epc_sections; i++) {
> > -		sgx_sanitize_section(&sgx_epc_sections[i]);
> 
> FWIW, I don't like the removal of the helper here.  I really like kernel
> threads' top-level function to be very understandable and clean.  This
> makes it quite a bit harder to figure out what is going on.
> 
> For instance, we could just have a sgx_sanitize_pages() which has a
> local dirty list and just calls:
> 
> void sgx_santitize_pages(void)
> {
> 	LIST_HEAD(dirty);
> 
> 	/*
> 	 * Comment about two passes
> 	 */
> 	__sgx_sanitize_pages(&dirty)
> 	__sgx_sanitize_pages(&dirty)

OK.

> }
> 
> > +	/* sgx_dirty_page_list is thread-local to ksgxd, no need for a lock: */
> > +	for (i = 0; i < 2 && !list_empty(&sgx_dirty_page_list); i++) {
> > +		while (!list_empty(&sgx_dirty_page_list)) {
> > +			if (kthread_should_stop())
> > +				return 0;
> > +
> > +			page = list_first_entry(&sgx_dirty_page_list, struct sgx_epc_page, list);
> > +
> > +			ret = __eremove(sgx_get_epc_virt_addr(page));
> > +			if (!ret) {
> > +				/* The page is clean - move to the free list. */
> 
> I'd even say:
> 				/*
> 				 * page is now sanitized.  Make it
> 				 * available via the SGX page allocator:
> 				 */
> 
> See what that does?  It actually links the "cleaning" to the freeing.

I agree, thanks.

> > +				list_del(&page->list);
> > +				sgx_free_epc_page(page);
> > +			} else {
> > +				/* The page is not yet clean - move to the dirty list. */
> > +				list_move_tail(&page->list, &dirty);
> > +			}
> > +
> > +			cond_resched();
> > +		}
> >  
> > -		/* Should never happen. */
> > -		if (!list_empty(&sgx_epc_sections[i].init_laundry_list))
> > -			WARN(1, "EPC section %d has unsanitized pages.\n", i);
> > +		list_splice(&dirty, &sgx_dirty_page_list);
> >  	}
> >  
> > +	if (!list_empty(&sgx_dirty_page_list))
> > +		WARN(1, "EPC section %d has unsanitized pages.\n", i);
> > +
> >  	while (!kthread_should_stop()) {
> >  		if (try_to_freeze())
> >  			continue;
> > @@ -632,13 +626,12 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
> >  	section->phys_addr = phys_addr;
> >  	spin_lock_init(&section->lock);
> >  	INIT_LIST_HEAD(&section->page_list);
> > -	INIT_LIST_HEAD(&section->init_laundry_list);
> >  
> >  	for (i = 0; i < nr_pages; i++) {
> >  		section->pages[i].section = index;
> >  		section->pages[i].flags = 0;
> >  		section->pages[i].owner = NULL;
> > -		list_add_tail(&section->pages[i].list, &section->init_laundry_list);
> > +		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
> >  	}
> ...
> 

/Jarkko
