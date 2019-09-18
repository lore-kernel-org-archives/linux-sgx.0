Return-Path: <SRS0=urvj=XN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A602C4CEC4
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Sep 2019 04:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E07322189D
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Sep 2019 04:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfIREVb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Sep 2019 00:21:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:49100 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfIREVb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Sep 2019 00:21:31 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 21:21:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,519,1559545200"; 
   d="scan'208";a="211723326"
Received: from mordehay-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.53])
  by fmsmga004.fm.intel.com with ESMTP; 17 Sep 2019 21:21:26 -0700
Date:   Wed, 18 Sep 2019 07:21:20 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v3 17/17] x86/sgx: Fix pages in the BLOCKED state ending
 up to the free pool
Message-ID: <20190918042120.GG22434@linux.intel.com>
References: <20190916101803.30726-1-jarkko.sakkinen@linux.intel.com>
 <20190916101803.30726-18-jarkko.sakkinen@linux.intel.com>
 <20190917233435.GI10319@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917233435.GI10319@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 17, 2019 at 04:34:35PM -0700, Sean Christopherson wrote:
> On Mon, Sep 16, 2019 at 01:18:03PM +0300, Jarkko Sakkinen wrote:
> > A blocked page can end up legitly to the free pool if pinning fails because
> > we interpret that as an EWB failure and simply put it to the free pool.
> > This corrupts the EPC page allocator.
> > 
> > Fix the bug by pinning the backing storage when picking the victim pages. A
> > clean rollback can still be done when the memory allocation fails as pages
> > can be still returned back to the enclave.
> > 
> > This in effect removes any other failure cases from sgx_encl_ewb() other
> > than EPCM conflict when the host has went through a sleep cycle. In that
> > case putting a page back to the free pool is perfectly fine because it is
> > uninitialized.
> > 
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
> > Cc: Serge Ayoun <serge.ayoun@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/reclaim.c | 95 ++++++++++++++++++-------------
> >  1 file changed, 57 insertions(+), 38 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> > index 7d628a1388e2..d6e580e55456 100644
> > --- a/arch/x86/kernel/cpu/sgx/reclaim.c
> > +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> > @@ -206,32 +206,24 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
> >  
> >  static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
> >  			  struct sgx_va_page *va_page, unsigned int va_offset,
> > -			  unsigned int page_index)
> > +			  struct sgx_backing *backing)
> >  {
> >  	struct sgx_pageinfo pginfo;
> > -	struct sgx_backing b;
> >  	int ret;
> >  
> > -	ret = sgx_encl_get_backing(encl, page_index, &b);
> > -	if (ret)
> > -		return ret;
> > -
> >  	pginfo.addr = 0;
> > -	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
> > -	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) + b.pcmd_offset;
> >  	pginfo.secs = 0;
> > +
> > +	pginfo.contents = (unsigned long)kmap_atomic(backing->contents);
> > +	pginfo.metadata = (unsigned long)kmap_atomic(backing->pcmd) +
> > +			  backing->pcmd_offset;
> > +
> >  	ret = __ewb(&pginfo, sgx_epc_addr(epc_page),
> >  		    sgx_epc_addr(va_page->epc_page) + va_offset);
> > -	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - b.pcmd_offset));
> > -	kunmap_atomic((void *)(unsigned long)pginfo.contents);
> >  
> > -	if (!ret) {
> > -		set_page_dirty(b.pcmd);
> > -		set_page_dirty(b.contents);
> > -	}
> > -
> > -	put_page(b.pcmd);
> > -	put_page(b.contents);
> > +	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
> > +					      backing->pcmd_offset));
> > +	kunmap_atomic((void *)(unsigned long)pginfo.contents);
> >  
> >  	return ret;
> >  }
> > @@ -265,7 +257,7 @@ static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
> >  }
> >  
> >  static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
> > -			 unsigned int page_index)
> > +			 struct sgx_backing *backing)
> >  {
> >  	struct sgx_encl_page *encl_page = epc_page->owner;
> >  	struct sgx_encl *encl = encl_page->encl;
> > @@ -281,8 +273,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
> >  	if (sgx_va_page_full(va_page))
> >  		list_move_tail(&va_page->list, &encl->va_pages);
> >  
> > -	ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
> > -			     page_index);
> > +	ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset, backing);
> >  	if (ret == SGX_NOT_TRACKED) {
> >  		ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
> >  		if (ret) {
> > @@ -292,7 +283,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
> >  		}
> >  
> >  		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
> > -				     page_index);
> > +				     backing);
> >  		if (ret == SGX_NOT_TRACKED) {
> >  			/*
> >  			 * Slow path, send IPIs to kick cpus out of the
> > @@ -304,7 +295,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
> >  			on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
> >  					 sgx_ipi_cb, NULL, 1);
> >  			ret = __sgx_encl_ewb(encl, epc_page, va_page,
> > -					     va_offset, page_index);
> > +					     va_offset, backing);
> >  		}
> >  	}
> >  
> > @@ -314,15 +305,20 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
> >  
> >  		sgx_encl_destroy(encl);
> >  	} else {
> > +		set_page_dirty(backing->pcmd);
> > +		set_page_dirty(backing->contents);
> > +
> >  		encl_page->desc |= va_offset;
> >  		encl_page->va_page = va_page;
> >  	}
> >  }
> >  
> > -static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
> > +static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
> > +				struct sgx_backing *backing)
> >  {
> >  	struct sgx_encl_page *encl_page = epc_page->owner;
> >  	struct sgx_encl *encl = encl_page->encl;
> > +	struct sgx_backing secs_backing;
> >  	int ret;
> >  
> >  	mutex_lock(&encl->lock);
> > @@ -331,7 +327,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
> >  		ret = __eremove(sgx_epc_addr(epc_page));
> >  		WARN(ret, "EREMOVE returned %d\n", ret);
> >  	} else {
> > -		sgx_encl_ewb(epc_page, SGX_ENCL_PAGE_INDEX(encl_page));
> > +		sgx_encl_ewb(epc_page, backing);
> >  	}
> >  
> >  	encl_page->epc_page = NULL;
> > @@ -340,10 +336,17 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
> >  	if (!encl->secs_child_cnt &&
> >  	    (atomic_read(&encl->flags) &
> >  	     (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED))) {
> > -		sgx_encl_ewb(encl->secs.epc_page, PFN_DOWN(encl->size));
> > -		sgx_free_page(encl->secs.epc_page);
> > +		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
> > +					   &secs_backing);
> > +		if (!ret) {
> > +			sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
> > +			sgx_free_page(encl->secs.epc_page);
> > +
> > +			encl->secs.epc_page = NULL;
> >  
> > -		encl->secs.epc_page = NULL;
> > +			put_page(secs_backing.pcmd);
> > +			put_page(secs_backing.contents);
> > +		}
> >  	}
> >  
> >  	mutex_unlock(&encl->lock);
> > @@ -351,17 +354,21 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
> >  
> >  /**
> >   * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
> > - * Takes a fixed chunk of pages from the global list of consumed EPC pages and
> > - * tries to swap them. Only the pages that are either being freed by the
> > - * consumer or actively used are skipped.
> > + *
> > + * Take a fixed number of pages from the head of the active page pool and
> > + * reclaim them to the enclave's private shmem files. Skip the pages, which
> > + * have been accessed since the last scan. Move those pages to the tail of
> > + * active page pool so that the pages get scanned in LRU like fashion.
> >   */
> >  void sgx_reclaim_pages(void)
> >  {
> > -	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];
> > +	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
> > +	struct sgx_backing backing[SGX_NR_TO_SCAN];
> >  	struct sgx_epc_section *section;
> >  	struct sgx_encl_page *encl_page;
> >  	struct sgx_epc_page *epc_page;
> >  	int cnt = 0;
> > +	int ret;
> >  	int i;
> >  
> >  	spin_lock(&sgx_active_page_list_lock);
> > @@ -388,13 +395,21 @@ void sgx_reclaim_pages(void)
> >  		epc_page = chunk[i];
> >  		encl_page = epc_page->owner;
> >  
> > -		if (sgx_can_reclaim(epc_page)) {
> > -			mutex_lock(&encl_page->encl->lock);
> > -			encl_page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> > -			mutex_unlock(&encl_page->encl->lock);
> > -			continue;
> > -		}
> > +		if (!sgx_can_reclaim(epc_page))
> 
> Would it make sense to use a more explicit name for sgx_can_reclaim(),
> e.g. sgx_age_epc_page() or something?  "can reclaim" makes it sound like
> there are scenarios where reclaim is impossible, but really it's just that
> we don't want to reclaim a recently accessed page.
> 
> > +			goto skip;
> >  
> > +		ret = sgx_encl_get_backing(encl_page->encl,
> > +					   SGX_ENCL_PAGE_INDEX(encl_page),
> > +					   &backing[i]);
> > +		if (ret)
> > +			goto skip;
> > +
> > +		mutex_lock(&encl_page->encl->lock);
> > +		encl_page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> > +		mutex_unlock(&encl_page->encl->lock);
> > +		continue;
> > +
> > +skip:
> 
> Eww.  The call to sgx_encl_get_backing() makes it rather ugly no matter
> what, but this seems slightly less ugly:
> 
> 	for (i = 0; i < cnt; i++) {
> 		epc_page = chunk[i];
> 		encl_page = epc_page->owner;
> 
> 		if (!sgx_can_reclaim(chunk[i]) ||
> 		    sgx_encl_get_backing(encl_page->encl,
> 					 SGX_ENCL_PAGE_INDEX(encl_page),
> 					 &backing[i]) {
> 			kref_put(&encl_page->encl->refcount, sgx_encl_release);
> 
> 			spin_lock(&sgx_active_page_list_lock);
> 			list_add_tail(&epc_page->list, &sgx_active_page_list);
> 			spin_unlock(&sgx_active_page_list_lock);
> 
> 			chunk[i] = NULL;
> 			continue;
> 		}
> 
> 		mutex_lock(&encl_page->encl->lock);
> 		encl_page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> 		mutex_unlock(&encl_page->encl->lock);
> 	}
> 
> >  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> >  
> >  		spin_lock(&sgx_active_page_list_lock);
> > @@ -416,7 +431,11 @@ void sgx_reclaim_pages(void)
> >  			continue;
> >  
> >  		encl_page = epc_page->owner;
> > -		sgx_reclaimer_write(epc_page);
> > +		sgx_reclaimer_write(epc_page, &backing[i]);
> > +
> > +		put_page(backing->pcmd);
> > +		put_page(backing->contents);
> 
> These should be backing[i]->
> 
> > +
> >  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> >  		epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> >  
> > -- 
> > 2.20.1
> > 

Good remarks. Have to check why the last one did not give me crashes.

/Jarkko
