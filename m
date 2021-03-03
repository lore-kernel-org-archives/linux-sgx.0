Return-Path: <SRS0=TB01=ID=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DATE_IN_PAST_24_48,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1735C43331
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Mar 2021 17:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DDF1650B1
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Mar 2021 17:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCERi1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Mar 2021 12:38:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:60556 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhCERiL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Mar 2021 12:38:11 -0500
IronPort-SDR: wxJbIinaCZWXw/rufTYD1Erd5Wv/kkJVm0mLfzQFX3ny6M4du2vt9FY4A6TRPJNHT2G18rwdfr
 lfuTNXg+zUVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9914"; a="187747005"
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="187747005"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 09:38:10 -0800
IronPort-SDR: i/1+a3A7ccysz/lIx9zz1SkMSoP5qxWNfjt55EfMrh3UCPngZ16toJm8JHdM4fMa3K/hUHIwYM
 of7Y3Fwtu94g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="375069277"
Received: from viggo.jf.intel.com (HELO ray) ([10.54.77.144])
  by fmsmga007.fm.intel.com with ESMTP; 05 Mar 2021 09:38:09 -0800
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by ray (Postfix) with ESMTP id 21282E2301;
        Wed,  3 Mar 2021 10:02:27 -0800 (PST)
Subject: Re: [PATCH v3 3/5] x86/sgx: Replace section->init_laundry_list with a
 temp list
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-4-jarkko@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <5f0c773f-4da1-7418-be42-e11427c2f137@intel.com>
Date:   Wed, 3 Mar 2021 10:02:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210303150323.433207-4-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

...
> -static void sgx_sanitize_section(struct sgx_epc_section *section)
> +static void sgx_sanitize_section(struct list_head *laundry)
>  {

Does this need a better function name now that it's not literally
dealing with sections at *all*?

	sgx_sanitize_pages()

perhaps.

>  	struct sgx_epc_page *page;
>  	LIST_HEAD(dirty);
>  	int ret;
>  
>  	/* init_laundry_list is thread-local, no need for a lock: */
> -	while (!list_empty(&section->init_laundry_list)) {
> +	while (!list_empty(laundry)) {
>  		if (kthread_should_stop())
>  			return;
>  
> -		/* needed for access to ->page_list: */
> -		spin_lock(&section->lock);
> -
> -		page = list_first_entry(&section->init_laundry_list,
> -					struct sgx_epc_page, list);
> +		page = list_first_entry(laundry, struct sgx_epc_page, list);
>  
>  		ret = __eremove(sgx_get_epc_virt_addr(page));
> -		if (!ret)
> -			list_move(&page->list, &section->page_list);
> -		else
> +		if (!ret) {
> +			/* The page is clean - move to the free list. */
> +			list_del(&page->list);
> +			sgx_free_epc_page(page);
> +		} else {
> +			/* The page is not yet clean - move to the dirty list. */
>  			list_move_tail(&page->list, &dirty);
> -
> -		spin_unlock(&section->lock);
> +		}
>  
>  		cond_resched();
>  	}
>  
> -	list_splice(&dirty, &section->init_laundry_list);
> +	list_splice(&dirty, laundry);
>  }
>  
>  static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
> @@ -400,6 +398,7 @@ static bool sgx_should_reclaim(unsigned long watermark)
>  
>  static int ksgxd(void *p)
>  {
> +	struct list_head *laundry = p;
>  	int i;
>  
>  	set_freezable();
> @@ -408,16 +407,13 @@ static int ksgxd(void *p)
>  	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
>  	 * required for SECS pages, whose child pages blocked EREMOVE.
>  	 */
> -	for (i = 0; i < sgx_nr_epc_sections; i++)
> -		sgx_sanitize_section(&sgx_epc_sections[i]);
> +	sgx_sanitize_section(laundry);
> +	sgx_sanitize_section(laundry);

Did you intend to call this twice?

> -	for (i = 0; i < sgx_nr_epc_sections; i++) {
> -		sgx_sanitize_section(&sgx_epc_sections[i]);
> +	if (!list_empty(laundry))
> +		WARN(1, "EPC section %d has unsanitized pages.\n", i);
>  
> -		/* Should never happen. */
> -		if (!list_empty(&sgx_epc_sections[i].init_laundry_list))
> -			WARN(1, "EPC section %d has unsanitized pages.\n", i);
> -	}
> +	kfree(laundry);

This is a bit unfortunate.  'laundry' is allocated up in another thread
and the lifetime isn't obvious.  It's just 32 bytes, but this is just
asking to be leaked.

>  	while (!kthread_should_stop()) {
>  		if (try_to_freeze())
> @@ -436,11 +432,11 @@ static int ksgxd(void *p)
>  	return 0;
>  }
>  
> -static bool __init sgx_page_reclaimer_init(void)
> +static bool __init sgx_page_reclaimer_init(struct list_head *laundry)
>  {
>  	struct task_struct *tsk;
>  
> -	tsk = kthread_run(ksgxd, NULL, "ksgxd");
> +	tsk = kthread_run(ksgxd, laundry, "ksgxd");
>  	if (IS_ERR(tsk))
>  		return false;
>  
> @@ -614,7 +610,8 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
>  
>  static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  					 unsigned long index,
> -					 struct sgx_epc_section *section)
> +					 struct sgx_epc_section *section,
> +					 struct list_head *laundry)
>  {

I think this at least need a comment somewhere about what this function
is doing with 'laundry'.

>  	unsigned long nr_pages = size >> PAGE_SHIFT;
>  	unsigned long i;
> @@ -632,13 +629,12 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  	section->phys_addr = phys_addr;
>  	spin_lock_init(&section->lock);
>  	INIT_LIST_HEAD(&section->page_list);
> -	INIT_LIST_HEAD(&section->init_laundry_list);
>  
>  	for (i = 0; i < nr_pages; i++) {
>  		section->pages[i].section = index;
>  		section->pages[i].flags = 0;
>  		section->pages[i].owner = NULL;
> -		list_add_tail(&section->pages[i].list, &section->init_laundry_list);
> +		list_add_tail(&section->pages[i].list, laundry);
>  	}
>  
>  	section->free_cnt = nr_pages;
> @@ -656,7 +652,7 @@ static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
>  	       ((high & GENMASK_ULL(19, 0)) << 32);
>  }
>  
> -static bool __init sgx_page_cache_init(void)
> +static bool __init sgx_page_cache_init(struct list_head *laundry)
>  {
>  	u32 eax, ebx, ecx, edx, type;
>  	u64 pa, size;
> @@ -679,7 +675,7 @@ static bool __init sgx_page_cache_init(void)
>  
>  		pr_info("EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
>  
> -		if (!sgx_setup_epc_section(pa, size, i, &sgx_epc_sections[i])) {
> +		if (!sgx_setup_epc_section(pa, size, i, &sgx_epc_sections[i], laundry)) {
>  			pr_err("No free memory for an EPC section\n");
>  			break;
>  		}

This is a great place for a comment about what is coming back on 'laundry'.

> @@ -697,18 +693,25 @@ static bool __init sgx_page_cache_init(void)
>  
>  static int __init sgx_init(void)
>  {
> +	struct list_head *laundry;
>  	int ret;
>  	int i;
>  
>  	if (!cpu_feature_enabled(X86_FEATURE_SGX))
>  		return -ENODEV;
>  
> -	if (!sgx_page_cache_init()) {
> +	laundry = kzalloc(sizeof(*laundry), GFP_KERNEL);
> +	if (!laundry)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(laundry);
> +
> +	if (!sgx_page_cache_init(laundry)) {
>  		ret = -ENOMEM;
>  		goto err_page_cache;
>  	}
>  
> -	if (!sgx_page_reclaimer_init()) {
> +	if (!sgx_page_reclaimer_init(laundry)) {
>  		ret = -ENOMEM;
>  		goto err_page_cache;
>  	}

I really don't like this being dynamically allocated, especially since
it's freed in another task in a non-obvious place.

Wouldn't this all just be a lot simpler if we had a global list_head?
That will eat a whopping 16 bytes of space.
