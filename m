Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531DEC433E6
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 14:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1834264EF9
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 14:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhCJOvI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 09:51:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230341AbhCJOu5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Mar 2021 09:50:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 299C764EFD;
        Wed, 10 Mar 2021 14:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615387856;
        bh=1W0zXMyR7sXLPJ1vtPcoz7OuZT3ZKhmd9XfK3FbOSAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=og1Dk20ZdthFg1cvoZN1TUA40KQ+ByDaEV3AmoUxPYLBKPKrRb2KGGwbCqs+zArti
         uxAO65gRnRY3oguoeoaIr+tC9i03YhgQNPA8/u/Hly5GJZPqEnqnYL355LjWYRR/8f
         KBZUwAaguHwALUsLov1cnQO3zjGcRxrWIxKofEHlLooi9u6bFP+E1dCs339hIA9DNh
         EkdvcsFFLFvaewK5qlBOmNaENkAmJhRZs7MUJ8KE1hmFTd5iFX8nw6GXd62xNNCIFX
         KprxgKUZXv8wpwWh/gTm8TVitF1Ml5lLGRVaBp5wbrBSuu+yFK8vfB2pmKKmAfJdxk
         Jra6Q5XZa00Og==
Date:   Wed, 10 Mar 2021 16:50:32 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] x86/sgx: Replace section->init_laundry_list with
 a temp list
Message-ID: <YEjcuFRHqgF/nMg3@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-4-jarkko@kernel.org>
 <5f0c773f-4da1-7418-be42-e11427c2f137@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f0c773f-4da1-7418-be42-e11427c2f137@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 03, 2021 at 10:02:27AM -0800, Dave Hansen wrote:
> ...
> > -static void sgx_sanitize_section(struct sgx_epc_section *section)
> > +static void sgx_sanitize_section(struct list_head *laundry)
> >  {
> 
> Does this need a better function name now that it's not literally
> dealing with sections at *all*?
> 
> 	sgx_sanitize_pages()
> 
> perhaps.

Makes sense to me.

> >  	struct sgx_epc_page *page;
> >  	LIST_HEAD(dirty);
> >  	int ret;
> >  
> >  	/* init_laundry_list is thread-local, no need for a lock: */
> > -	while (!list_empty(&section->init_laundry_list)) {
> > +	while (!list_empty(laundry)) {
> >  		if (kthread_should_stop())
> >  			return;
> >  
> > -		/* needed for access to ->page_list: */
> > -		spin_lock(&section->lock);
> > -
> > -		page = list_first_entry(&section->init_laundry_list,
> > -					struct sgx_epc_page, list);
> > +		page = list_first_entry(laundry, struct sgx_epc_page, list);
> >  
> >  		ret = __eremove(sgx_get_epc_virt_addr(page));
> > -		if (!ret)
> > -			list_move(&page->list, &section->page_list);
> > -		else
> > +		if (!ret) {
> > +			/* The page is clean - move to the free list. */
> > +			list_del(&page->list);
> > +			sgx_free_epc_page(page);
> > +		} else {
> > +			/* The page is not yet clean - move to the dirty list. */
> >  			list_move_tail(&page->list, &dirty);
> > -
> > -		spin_unlock(&section->lock);
> > +		}
> >  
> >  		cond_resched();
> >  	}
> >  
> > -	list_splice(&dirty, &section->init_laundry_list);
> > +	list_splice(&dirty, laundry);
> >  }
> >  
> >  static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
> > @@ -400,6 +398,7 @@ static bool sgx_should_reclaim(unsigned long watermark)
> >  
> >  static int ksgxd(void *p)
> >  {
> > +	struct list_head *laundry = p;
> >  	int i;
> >  
> >  	set_freezable();
> > @@ -408,16 +407,13 @@ static int ksgxd(void *p)
> >  	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
> >  	 * required for SECS pages, whose child pages blocked EREMOVE.
> >  	 */
> > -	for (i = 0; i < sgx_nr_epc_sections; i++)
> > -		sgx_sanitize_section(&sgx_epc_sections[i]);
> > +	sgx_sanitize_section(laundry);
> > +	sgx_sanitize_section(laundry);
> 
> Did you intend to call this twice?

Yes, see the inline comment above.

> > -	for (i = 0; i < sgx_nr_epc_sections; i++) {
> > -		sgx_sanitize_section(&sgx_epc_sections[i]);
> > +	if (!list_empty(laundry))
> > +		WARN(1, "EPC section %d has unsanitized pages.\n", i);
> >  
> > -		/* Should never happen. */
> > -		if (!list_empty(&sgx_epc_sections[i].init_laundry_list))
> > -			WARN(1, "EPC section %d has unsanitized pages.\n", i);
> > -	}
> > +	kfree(laundry);
> 
> This is a bit unfortunate.  'laundry' is allocated up in another thread
> and the lifetime isn't obvious.  It's just 32 bytes, but this is just
> asking to be leaked.
> >  	while (!kthread_should_stop()) {
> >  		if (try_to_freeze())
> > @@ -436,11 +432,11 @@ static int ksgxd(void *p)
> >  	return 0;
> >  }
> >  
> > -static bool __init sgx_page_reclaimer_init(void)
> > +static bool __init sgx_page_reclaimer_init(struct list_head *laundry)
> >  {
> >  	struct task_struct *tsk;
> >  
> > -	tsk = kthread_run(ksgxd, NULL, "ksgxd");
> > +	tsk = kthread_run(ksgxd, laundry, "ksgxd");
> >  	if (IS_ERR(tsk))
> >  		return false;
> >  
> > @@ -614,7 +610,8 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
> >  
> >  static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
> >  					 unsigned long index,
> > -					 struct sgx_epc_section *section)
> > +					 struct sgx_epc_section *section,
> > +					 struct list_head *laundry)
> >  {
> 
> I think this at least need a comment somewhere about what this function
> is doing with 'laundry'.

Ok.

> >  	unsigned long nr_pages = size >> PAGE_SHIFT;
> >  	unsigned long i;
> > @@ -632,13 +629,12 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
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
> > +		list_add_tail(&section->pages[i].list, laundry);
> >  	}
> >  
> >  	section->free_cnt = nr_pages;
> > @@ -656,7 +652,7 @@ static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
> >  	       ((high & GENMASK_ULL(19, 0)) << 32);
> >  }
> >  
> > -static bool __init sgx_page_cache_init(void)
> > +static bool __init sgx_page_cache_init(struct list_head *laundry)
> >  {
> >  	u32 eax, ebx, ecx, edx, type;
> >  	u64 pa, size;
> > @@ -679,7 +675,7 @@ static bool __init sgx_page_cache_init(void)
> >  
> >  		pr_info("EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
> >  
> > -		if (!sgx_setup_epc_section(pa, size, i, &sgx_epc_sections[i])) {
> > +		if (!sgx_setup_epc_section(pa, size, i, &sgx_epc_sections[i], laundry)) {
> >  			pr_err("No free memory for an EPC section\n");
> >  			break;
> >  		}
> 
> This is a great place for a comment about what is coming back on 'laundry'.
> 
> > @@ -697,18 +693,25 @@ static bool __init sgx_page_cache_init(void)
> >  
> >  static int __init sgx_init(void)
> >  {
> > +	struct list_head *laundry;
> >  	int ret;
> >  	int i;
> >  
> >  	if (!cpu_feature_enabled(X86_FEATURE_SGX))
> >  		return -ENODEV;
> >  
> > -	if (!sgx_page_cache_init()) {
> > +	laundry = kzalloc(sizeof(*laundry), GFP_KERNEL);
> > +	if (!laundry)
> > +		return -ENOMEM;
> > +
> > +	INIT_LIST_HEAD(laundry);
> > +
> > +	if (!sgx_page_cache_init(laundry)) {
> >  		ret = -ENOMEM;
> >  		goto err_page_cache;
> >  	}
> >  
> > -	if (!sgx_page_reclaimer_init()) {
> > +	if (!sgx_page_reclaimer_init(laundry)) {
> >  		ret = -ENOMEM;
> >  		goto err_page_cache;
> >  	}
> 
> I really don't like this being dynamically allocated, especially since
> it's freed in another task in a non-obvious place.
> 
> Wouldn't this all just be a lot simpler if we had a global list_head?
> That will eat a whopping 16 bytes of space.

Yeah, why not. It's just then one global instead of per-struct field, which
is quite ugly.

/Jarkko
