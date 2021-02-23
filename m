Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB85C433E9
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Feb 2021 19:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B286664EC9
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Feb 2021 19:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbhBWTSM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Feb 2021 14:18:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233690AbhBWTSH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Feb 2021 14:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCFB264E7A;
        Tue, 23 Feb 2021 19:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614107846;
        bh=x6yh8NGQDb+RifuQ95bjVU+mIpOZUX4pyBPC2FNHGR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gq/M/WYDurJ4zpz8sBi6sLR2Amq5Mo869ftjEhnuw350zs9DMMVq++DbhhwZ5Fs96
         tevHhcmO5kWvOMNh4+z3JXveR2ca0H93Vs+ED7xrXVF8xCAnpG2foZqPMFq1ynh6ET
         g3J9adNC+xiMAzF9cmymf/BNdukIL1qkBi5vOKOf+PALGCo03mHGylZwJociPR1m3H
         uUfH5nU25Mw24ijJI3qXmjDX/uuVo+CydZRdfz5dcD3XvP9J6Ug3CaA5mK3zs/vOR1
         eEp1io+NYLljRaAdQqsE/R354L/PcoI8mNT+F0597LfPXKooQ/KxlCa5kK1aYqn8Bh
         ERpu9LPC7/kBQ==
Date:   Tue, 23 Feb 2021 21:17:12 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, haitao.huang@intel.com,
        dan.j.williams@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Add a basic NUMA allocation scheme to
 sgx_alloc_epc_page()
Message-ID: <YDVUuF3rqnRCr+Bb@kernel.org>
References: <20210221020631.171404-1-jarkko@kernel.org>
 <7acc3c1c-373e-cfee-e838-2af170e87d98@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7acc3c1c-373e-cfee-e838-2af170e87d98@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Feb 21, 2021 at 04:54:33PM -0800, Dave Hansen wrote:
> > +/* Nodes with one or more EPC sections. */
> > +static nodemask_t sgx_numa_mask;
> 
> I'd also add that this is for optimization only.
> 
> > +/* Array of lists of EPC sections for each NUMA node. */
> > +struct list_head *sgx_numa_nodes;
> 
> I'd much prefer:
> 
> /*
>  * Array with one list_head for each possible NUMA node.  Each
>  * list contains all the sgx_epc_section's which are on that
>  * node.
>  */
> 
> Otherwise, it's hard to imagine what this structure looks like.

OK.

> >  /*
> >   * These variables are part of the state of the reclaimer, and must be accessed
> >   * with sgx_reclaimer_lock acquired.
> > @@ -473,6 +479,26 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
> >  	return page;
> >  }
> >  
> > +static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
> > +{
> > +	struct sgx_epc_section *section;
> > +	struct sgx_epc_page *page;
> > +
> > +	if (WARN_ON_ONCE(nid < 0 || nid >= MAX_NUMNODES))
> > +		return NULL;
> > +
> > +	if (!node_isset(nid, sgx_numa_mask))
> > +		return NULL;
> > +
> > +	list_for_each_entry(section, &sgx_numa_nodes[nid], section_list) {
> > +		page = __sgx_alloc_epc_page_from_section(section);
> > +		if (page)
> > +			return page;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> >  /**
> >   * __sgx_alloc_epc_page() - Allocate an EPC page
> >   *
> > @@ -485,13 +511,17 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
> >   */
> >  struct sgx_epc_page *__sgx_alloc_epc_page(void)
> >  {
> > +	int current_nid = numa_node_id();
> >  	struct sgx_epc_section *section;
> >  	struct sgx_epc_page *page;
> >  	int i;
> >  
> > +	page = __sgx_alloc_epc_page_from_node(current_nid);
> > +	if (page)
> > +		return page;
> 
> Comments, please.
> 
> 	/* Try to allocate EPC from the current node, first: */
> 
> then:
> 
> 	/* Search all EPC sections, ignoring locality: */
> 
> >  	for (i = 0; i < sgx_nr_epc_sections; i++) {
> >  		section = &sgx_epc_sections[i];
> > -
> >  		page = __sgx_alloc_epc_page_from_section(section);
> >  		if (page)
> >  			return page;
> 
> This still has the problem that it exerts too much pressure on the
> low-numbered sgx_epc_sections[].  If a node's sections are full, it
> always tries to go after sgx_epc_sections[0].

I have a better idea. See below.

> It can be in another patch, but I think the *minimal* thing we can do
> here for a NUMA allocator is to try to at least balance the allocations.
> 
> Instead of having a for-each-section loop, I'd make it for-each-node ->
> for-each-section.  Something like:
> 
> 	for (i = 0; i < num_possible_nodes(); i++) {
> 		node = (numa_node_id() + i) % num_possible_nodes()
> 		
> 		if (!node_isset(nid, sgx_numa_mask))
> 			continue;
> 
> 		list_for_each_entry(section, &sgx_numa_nodes[nid],
> 				    section_list) {
> 			__sgx_alloc_epc_page_from_section(section)
> 		}
> 	}
> 	
> Then you have a single loop instead of a "try local then a fall back".
> 
> Also, that "node++" thing might be able to use next_online_node().
> 
> > @@ -665,8 +695,12 @@ static bool __init sgx_page_cache_init(void)
> >  {
> >  	u32 eax, ebx, ecx, edx, type;
> >  	u64 pa, size;
> > +	int nid;
> >  	int i;
> >  
> > +	nodes_clear(sgx_numa_mask);
> > +	sgx_numa_nodes = kmalloc_array(MAX_NUMNODES, sizeof(*sgx_numa_nodes), GFP_KERNEL);
> 
> MAX_NUMNODES will always be the largest compile-time constant.  That's
> 4k, IIRC.  num_possible_nodes() might be as small as 1 if NUMA is off.

Right.

> >  	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
> >  		cpuid_count(SGX_CPUID, i + SGX_CPUID_EPC, &eax, &ebx, &ecx, &edx);
> >  
> > @@ -690,6 +724,22 @@ static bool __init sgx_page_cache_init(void)
> >  		}
> >  
> >  		sgx_nr_epc_sections++;
> > +
> > +		nid = numa_map_to_online_node(phys_to_target_node(pa));
> > +
> > +		if (nid == NUMA_NO_NODE) {
> > +			pr_err(FW_BUG "unable to map EPC section %d to online node.\n", nid);
> > +			nid = 0;
> 
> Could we dump out the physical address there?  I think that's even more
> informative than a section number.

Yes.

> > +		} else if (WARN_ON_ONCE(nid < 0 || nid >= MAX_NUMNODES)) {
> > +			nid = 0;
> > +		}
> 
> I'm not sure we really need to check for these.  If we're worried about
> the firmware returning these, I'd expect numa_map_to_online_node() to
> sanity check them for us.

Yes, let's remove it.

> > +		if (!node_isset(nid, sgx_numa_mask)) {
> > +			INIT_LIST_HEAD(&sgx_numa_nodes[nid]);
> > +			node_set(nid, sgx_numa_mask);
> > +		}
> > +
> > +		list_add_tail(&sgx_epc_sections[i].section_list, &sgx_numa_nodes[nid]);
> >  	}
> >  
> >  	if (!sgx_nr_epc_sections) {
> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> > index 5fa42d143feb..4bc31bc4bacf 100644
> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > @@ -45,6 +45,7 @@ struct sgx_epc_section {
> >  	spinlock_t lock;
> >  	struct list_head page_list;
> >  	unsigned long free_cnt;
> > +	struct list_head section_list;
> 
> Maybe name this numa_section_list.

Instead, let's just:

1. Have a global sgx_free_epc_list and remove sgx_epc_section.
   Pages from this are allocated from this in LIFO fashion.
2. Instead add struct list_head node_list and use that for node
   associated pages.
3. Replace 'int section' with 'int node'.

This will remove one layer of abstraction and provide better fallback
scheme.

E.g. allocate:

1. Check node_list of current node.
2. As a fallback check sgx_free_epc_list.
3. list_del() for two lists.

/Jarkko
