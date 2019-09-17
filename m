Return-Path: <SRS0=2oz+=XM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7A7C4CECD
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Sep 2019 23:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E152216C8
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Sep 2019 23:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbfIQXHm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Sep 2019 19:07:42 -0400
Received: from mga06.intel.com ([134.134.136.31]:10893 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728077AbfIQXHm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Sep 2019 19:07:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 16:07:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,518,1559545200"; 
   d="scan'208";a="216740757"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 17 Sep 2019 16:07:41 -0700
Date:   Tue, 17 Sep 2019 16:07:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v3 12/17] x86/sgx: Open code sgx_reclaimer_get() and
 sgx_reclaimer_put()
Message-ID: <20190917230740.GE10319@linux.intel.com>
References: <20190916101803.30726-1-jarkko.sakkinen@linux.intel.com>
 <20190916101803.30726-13-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916101803.30726-13-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 16, 2019 at 01:17:58PM +0300, Jarkko Sakkinen wrote:
> Open code sgx_reclaimer_get() and sgx_reclaimer_put(). They are legacy
> from the callback interface. Wrapping a function call inside a function
> does not make sense.

I actually like the functions, IMO they make the loops more readable.
They should be static, and probably static inline, but I doubt either
annotation affects the compiler output.

> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Cc: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/reclaim.c | 47 ++++++++++++-------------------
>  1 file changed, 18 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> index c2a85db68307..5a4d44dd02d7 100644
> --- a/arch/x86/kernel/cpu/sgx/reclaim.c
> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -121,22 +121,6 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
>  	spin_unlock(&sgx_active_page_list_lock);
>  }
>  
> -bool sgx_reclaimer_get(struct sgx_epc_page *epc_page)
> -{
> -	struct sgx_encl_page *encl_page = epc_page->owner;
> -	struct sgx_encl *encl = encl_page->encl;
> -
> -	return kref_get_unless_zero(&encl->refcount) != 0;
> -}
> -
> -void sgx_reclaimer_put(struct sgx_epc_page *epc_page)
> -{
> -	struct sgx_encl_page *encl_page = epc_page->owner;
> -	struct sgx_encl *encl = encl_page->encl;
> -
> -	kref_put(&encl->refcount, sgx_encl_release);
> -}
> -
>  static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
>  {
>  	struct sgx_encl_page *page = epc_page->owner;
> @@ -392,6 +376,7 @@ void sgx_reclaim_pages(void)
>  {
>  	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];
>  	struct sgx_epc_section *section;
> +	struct sgx_encl_page *encl_page;
>  	struct sgx_epc_page *epc_page;
>  	int cnt = 0;
>  	int i;
> @@ -404,8 +389,9 @@ void sgx_reclaim_pages(void)
>  		epc_page = list_first_entry(&sgx_active_page_list,
>  					    struct sgx_epc_page, list);
>  		list_del_init(&epc_page->list);
> +		encl_page = epc_page->owner;
>  
> -		if (sgx_reclaimer_get(epc_page))
> +		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
>  			chunk[cnt++] = epc_page;
>  		else
>  			/* The owner is freeing the page. No need to add the
> @@ -417,10 +403,12 @@ void sgx_reclaim_pages(void)
>  
>  	for (i = 0; i < cnt; i++) {
>  		epc_page = chunk[i];
> +		encl_page = epc_page->owner;
> +
>  		if (sgx_reclaimer_evict(epc_page))
>  			continue;
>  
> -		sgx_reclaimer_put(epc_page);
> +		kref_put(&encl_page->encl->refcount, sgx_encl_release);
>  
>  		spin_lock(&sgx_active_page_list_lock);
>  		list_add_tail(&epc_page->list, &sgx_active_page_list);
> @@ -437,19 +425,20 @@ void sgx_reclaim_pages(void)
>  
>  	for (i = 0; i < cnt; i++) {
>  		epc_page = chunk[i];
> -		if (epc_page) {
> -			sgx_reclaimer_write(epc_page);
> -			sgx_reclaimer_put(epc_page);
> -			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> +		if (!epc_page)
> +			continue;
>  
> -			section = sgx_epc_section(epc_page);
>  
> -			spin_lock(&section->lock);
> -			list_add_tail(&epc_page->list,
> -				      &section->page_list);
> -			section->free_cnt++;
> -			spin_unlock(&section->lock);
> -		}
> +		encl_page = epc_page->owner;
> +		sgx_reclaimer_write(epc_page);
> +		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> +		epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> +
> +		section = sgx_epc_section(epc_page);
> +		spin_lock(&section->lock);
> +		list_add_tail(&epc_page->list, &section->page_list);
> +		section->free_cnt++;
> +		spin_unlock(&section->lock);
>  	}
>  }
>  
> -- 
> 2.20.1
> 
