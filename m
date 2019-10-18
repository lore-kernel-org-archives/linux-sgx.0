Return-Path: <SRS0=5L1B=YL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B04CA9EA9
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 14:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54A7B222C3
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 14:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408561AbfJROa7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Oct 2019 10:30:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:2081 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729584AbfJROa7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Oct 2019 10:30:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 07:30:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,312,1566889200"; 
   d="scan'208";a="280242455"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 18 Oct 2019 07:30:57 -0700
Date:   Fri, 18 Oct 2019 07:30:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 12/12] x86/sgx: Reinstate per EPC section free
 page counts
Message-ID: <20191018143057.GA26319@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-13-sean.j.christopherson@intel.com>
 <20191018124942.GC4027@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018124942.GC4027@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 18, 2019 at 03:49:42PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 16, 2019 at 11:37:45AM -0700, Sean Christopherson wrote:
> > Track the free page count on a per EPC section basis so that the value
> > is properly protected by the section's spinlock.
> > 
> > As was pointed out when the change was proposed[*], using a global
> > non-atomic counter to track the number of free EPC pages is not safe.
> > The order of non-atomic reads and writes are not guaranteed, i.e.
> > concurrent RMW operats can write stale data.  This causes a variety
> > of bad behavior, e.g. livelocks because the free page count wraps and
> > causes the swap thread to stop reclaiming.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> What is the reason not change it just to atomic?

The purpose of separate sections is to avoid bouncing locks and whatnot
across packages.  Adding a global atomic to the hotpath defeats that
purpose.

> For debugging the global is useful because it could be exposed
> as a sysfs file.

Can't the sysfs read helper aggregate the info?

> > ---
> >  arch/x86/kernel/cpu/sgx/main.c    | 11 +++++------
> >  arch/x86/kernel/cpu/sgx/reclaim.c |  4 ++--
> >  arch/x86/kernel/cpu/sgx/sgx.h     | 18 +++++++++++++++++-
> >  3 files changed, 24 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 6311aef10ec4..efbb52e4ecad 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -13,18 +13,17 @@
> >  
> >  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> >  int sgx_nr_epc_sections;
> > -unsigned long sgx_nr_free_pages;
> >  
> >  static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section)
> >  {
> >  	struct sgx_epc_page *page;
> >  
> > -	if (list_empty(&section->page_list))
> > +	if (!section->free_cnt)
> >  		return NULL;
> 
>  Why this check needs to be changed?

I was reverting to the previous behavior.

> >  
> >  	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
> >  	list_del_init(&page->list);
> > -	sgx_nr_free_pages--;
> > +	section->free_cnt--;
> >  	return page;
> >  }
> >  
> > @@ -97,7 +96,7 @@ struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
> >  		schedule();
> >  	}
> >  
> > -	if (sgx_nr_free_pages < SGX_NR_LOW_PAGES)
> > +	if (!sgx_at_least_N_free_pages(SGX_NR_LOW_PAGES))
> >  		wake_up(&ksgxswapd_waitq);
> >  
> >  	return entry;
> > @@ -131,7 +130,7 @@ void __sgx_free_page(struct sgx_epc_page *page)
> >  
> >  	spin_lock(&section->lock);
> >  	list_add_tail(&page->list, &section->page_list);
> > -	sgx_nr_free_pages++;
> > +	section->free_cnt++;
> >  	spin_unlock(&section->lock);
> >  
> >  }
> > @@ -218,7 +217,7 @@ static bool __init sgx_alloc_epc_section(u64 addr, u64 size,
> >  		list_add_tail(&page->list, &section->unsanitized_page_list);
> >  	}
> >  
> > -	sgx_nr_free_pages += nr_pages;
> > +	section->free_cnt = nr_pages;
> >  
> >  	return true;
> >  
> > diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> > index 3f183dd0e653..8619141f4bed 100644
> > --- a/arch/x86/kernel/cpu/sgx/reclaim.c
> > +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> > @@ -68,7 +68,7 @@ static void sgx_sanitize_section(struct sgx_epc_section *section)
> >  
> >  static inline bool sgx_should_reclaim(void)
> >  {
> > -	return sgx_nr_free_pages < SGX_NR_HIGH_PAGES &&
> > +	return !sgx_at_least_N_free_pages(SGX_NR_HIGH_PAGES) &&
> >  	       !list_empty(&sgx_active_page_list);
> >  }
> >  
> > @@ -430,7 +430,7 @@ void sgx_reclaim_pages(void)
> >  		section = sgx_epc_section(epc_page);
> >  		spin_lock(&section->lock);
> >  		list_add_tail(&epc_page->list, &section->page_list);
> > -		sgx_nr_free_pages++;
> > +		section->free_cnt++;
> >  		spin_unlock(&section->lock);
> >  	}
> >  }
> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> > index 87e375e8c25e..c7f0277299f6 100644
> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > @@ -30,6 +30,7 @@ struct sgx_epc_page {
> >  struct sgx_epc_section {
> >  	unsigned long pa;
> >  	void *va;
> > +	unsigned long free_cnt;
> >  	struct list_head page_list;
> >  	struct list_head unsanitized_page_list;
> >  	spinlock_t lock;
> > @@ -73,12 +74,27 @@ static inline void *sgx_epc_addr(struct sgx_epc_page *page)
> >  #define SGX_NR_HIGH_PAGES	64
> >  
> >  extern int sgx_nr_epc_sections;
> > -extern unsigned long sgx_nr_free_pages;
> >  extern struct task_struct *ksgxswapd_tsk;
> >  extern struct wait_queue_head(ksgxswapd_waitq);
> >  extern struct list_head sgx_active_page_list;
> >  extern spinlock_t sgx_active_page_list_lock;
> >  
> > +static inline bool sgx_at_least_N_free_pages(unsigned long threshold)
> 
> There is an upper case letter in the function name and name is also
> weird overally.

Ya, not a fan of the name either.

> > +{
> > +	struct sgx_epc_section *section;
> > +	unsigned long free_cnt = 0;
> > +	int i;
> > +
> > +	for (i = 0; i < sgx_nr_epc_sections; i++) {
> > +		section = &sgx_epc_sections[i];
> > +		free_cnt += section->free_cnt;
> > +		if (free_cnt >= threshold)
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> 
> The complexity does not pay here. Better to revert instead back to this
> if required:

I'd prefer to optimize for the happy case, even if it's minor.  But I'm
fine going with the below code.

> unsigned long sgx_calc_free_cnt(void)
> {
> 	struct sgx_epc_section *section;
> 	unsigned long free_cnt = 0;
> 	int i;
> 
> 	for (i = 0; i < sgx_nr_epc_sections; i++) {
> 		section = &sgx_epc_sections[i];
> 		free_cnt += section->free_cnt;
> 	}
> 
> 	return free_cnt;
> }
> 
> /Jarkko
