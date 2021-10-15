Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA7BC433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 15 Oct 2021 23:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49E861151
	for <linux-sgx@archiver.kernel.org>; Fri, 15 Oct 2021 23:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243458AbhJOXKB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 15 Oct 2021 19:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243453AbhJOXKA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 15 Oct 2021 19:10:00 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C863BC061570
        for <linux-sgx@vger.kernel.org>; Fri, 15 Oct 2021 16:07:53 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id i76so7436442pfe.13
        for <linux-sgx@vger.kernel.org>; Fri, 15 Oct 2021 16:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z8yUxq3fwATXAZvZ+lWfldcPLRgo3vd2F+DRsUdb+9k=;
        b=ix1CjFYFwAMKBDbre51KYojeJClAoFUDAmAZKy2BsC10T6sCVLpQf4ukVbh7B5AN9q
         4ZT55TPN9AF48veuBQhveJQ7XLca0OmozymLRD//nZ9oMxVn37TTeSZVoG/1TlyhHAIg
         yFkOdHRc05+olH3sZp+S+lWLouBdj41M3bFcvxrxFTmf65yp+fsnGsAq7XXoudrz6CQN
         NIeOYcSDKzJ7voUJ+NSc9/cQdDNWc49AHboi2G6kL0VWKKe5w8IZvXzmJp80ywXjn1HC
         Jc4OChl6ssgf/UONOvvMhRlYYfQoUmSQTfEj3jH4LT8kYvaqtAy2iq0y6ecNorK7FErx
         teSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z8yUxq3fwATXAZvZ+lWfldcPLRgo3vd2F+DRsUdb+9k=;
        b=m6KkxgRncfWhHHia/qq5W51CePdsK9Pd3/FtFLUJPr7yYRQ6tXF7XB4P40K1NJfA1r
         A3T4zV5AxqtWnV0ANNRPBhK/QlpT1zDPdYOLekQdx/zruXoQNn00rWiJwx8l/yTUJOlM
         cT75u0w7eem1LwE87ZEB6BWaJwoJw4G7mP5VZPY0uJQCnOWVCRj3NCKZAH0YIx/0bye/
         WjJuionPjRlA4BIpjIsqk0dNTGo3ibdHxP5uFQ+R12Lu/AoYYw15WOpWxdXickYFGTxw
         KVQro+QbwiUuTwvGJENHsEUDaE5F37t30Yl1yo1rgIhXkFKfxQEcpz8hldE+ksJdZkod
         BSiw==
X-Gm-Message-State: AOAM533kAWmLNdnx5M0boM87mdZRn6vN+/uMllDNCm78QOXbMgagrGmY
        UAgTC0+pLCh29jRx9k1qqOhHOg==
X-Google-Smtp-Source: ABdhPJy4h2FNfbZgu1Koh9jPi8vcK+UEVktIVGNRQks2Obn4rAQmVHFwRnOt+GjpUTS3c3BaPXtImg==
X-Received: by 2002:a63:fc65:: with SMTP id r37mr11313850pgk.28.1634339273037;
        Fri, 15 Oct 2021 16:07:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y1sm5854838pfo.104.2021.10.15.16.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 16:07:52 -0700 (PDT)
Date:   Fri, 15 Oct 2021 23:07:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tony Luck <tony.luck@intel.com>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        naoya.horiguchi@nec.com, Andrew Morton <akpm@linux-foundation.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v9 3/7] x86/sgx: Initial poison handling for dirty and
 free pages
Message-ID: <YWoJxJCHxMN4ABVS@google.com>
References: <20211001164724.220532-1-tony.luck@intel.com>
 <20211011185924.374213-1-tony.luck@intel.com>
 <20211011185924.374213-4-tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011185924.374213-4-tony.luck@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 11, 2021, Tony Luck wrote:
> A memory controller patrol scrubber can report poison in a page
> that isn't currently being used.
> 
> Add "poison" field in the sgx_epc_page that can be set for an
> sgx_epc_page. Check for it:
> 1) When sanitizing dirty pages
> 2) When freeing epc pages
> 
> Poison is a new field separated from flags to avoid having to make
> all updates to flags atomic, or integrate poison state changes into
> some other locking scheme to protect flags.

Explain why atomic would be needed.  I lived in this code for a few years and
still had to look at the source to remember that the reclaimer can set flags
without taking node->lock.

> In both cases place the poisoned page on a list of poisoned epc pages
> to make sure it will not be reallocated.
> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Tested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 14 +++++++++++++-
>  arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++-
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 09fa42690ff2..653bace26100 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -43,6 +43,7 @@ static nodemask_t sgx_numa_mask;
>  static struct sgx_numa_node *sgx_numa_nodes;
>  
>  static LIST_HEAD(sgx_dirty_page_list);
> +static LIST_HEAD(sgx_poison_page_list);
>  
>  /*
>   * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
> @@ -62,6 +63,12 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  
>  		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
>  
> +		if (page->poison) {

Does this need READ_ONCE (and WRITE_ONCE in the writer) to prevent reloading
page->poison since the sanitizer doesn't hold node->lock, i.e. page->poison can
be set any time?  Honest question, I'm terrible with memory ordering rules...

> +			list_del(&page->list);
> +			list_add(&page->list, &sgx_poison_page_list);

list_move()

> +			continue;
> +		}
> +
>  		ret = __eremove(sgx_get_epc_virt_addr(page));
>  		if (!ret) {
>  			/*
> @@ -626,7 +633,11 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
>  
>  	spin_lock(&node->lock);
>  
> -	list_add_tail(&page->list, &node->free_page_list);
> +	page->owner = NULL;
> +	if (page->poison)
> +		list_add(&page->list, &sgx_poison_page_list);

sgx_poison_page_list is a global list, whereas node->lock is, well, per node.
On a system with multiple EPCs, this could corrupt sgx_poison_page_list if
multiple poisoned pages from different nodes are freed simultaneously.

> +	else
> +		list_add_tail(&page->list, &node->free_page_list);
>  	sgx_nr_free_pages++;
>  	page->flags = 0;
>  
> @@ -658,6 +669,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  		section->pages[i].section = index;
>  		section->pages[i].flags = SGX_EPC_PAGE_IN_USE;
>  		section->pages[i].owner = NULL;
> +		section->pages[i].poison = 0;
>  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
>  	}
>  
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index f9202d3d6278..a990a4c9a00f 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -31,7 +31,8 @@
>  
>  struct sgx_epc_page {
>  	unsigned int section;
> -	unsigned int flags;
> +	u16 flags;
> +	u16 poison;
>  	struct sgx_encl_page *owner;
>  	struct list_head list;
>  };
> 
> -- 
> 2.31.1
> 
