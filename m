Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B156C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 11:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B448264FD7
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 11:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCJLbH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 06:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhCJLao (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Mar 2021 06:30:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B5E64FD7;
        Wed, 10 Mar 2021 11:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615375844;
        bh=suwFvFAR28YJE9v3I95o0mqKODn5ocVAXWz13k7wMeE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UhBmGLz5HOZgC4Q04Vw3fSd38wxZXDQnz2okpvGhb4ZvG4kllK97W8Me1NFmP49gG
         T1uzuiaLXSF75FMv3KM6oLUdaSuHP3FCDd3wWyRw5kDYhkKXbaLIVqcOm4JixgqEsD
         5/WsRE1/sAc/Kv9Tf35QZyKPEYUBxX9ePuxT3i3127ld8yK0k6qJs40aQ43NNbYqfz
         O7nJmDM8FS3Xs1K9RwHqFsXqXXxkFgkLILILRnw3ZlYnQ8gIvnXPK9W0RY3O8HTH7/
         28Yf0Bec9MSX7oKLWbIBD54BGyZlJ5QalMl/V9CojbTsrva6zo9c6z8g/vaVr8jUgW
         WWLAkOYqquWyA==
Date:   Wed, 10 Mar 2021 13:30:20 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] x86/sgx: Add a basic NUMA allocation scheme to
 sgx_alloc_epc_page()
Message-ID: <YEitzCiXd02/Pxy1@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-6-jarkko@kernel.org>
 <7621d89e-9347-d8a5-a8b0-a108990d0e6d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7621d89e-9347-d8a5-a8b0-a108990d0e6d@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Weird. I did check my kernel org last time on Thrusday night but did not
get this. I was actually wondering the lack of feedback.

Then I had suddenly huge pile of email waiting for me on Monday with
bunch emails from around the time you sent this one.

On Wed, Mar 03, 2021 at 04:20:03PM -0800, Dave Hansen wrote:
> What changed from the last patch?
> 
> On 3/3/21 7:03 AM, Jarkko Sakkinen wrote:
> > Background
> > ==========
> > 
> > EPC section is covered by one or more SRAT entries that are associated with
> > one and only one PXM (NUMA node). The motivation behind this patch is to
> > provide basic elements of building allocation scheme based on this premise.
> 
> Just like normal RAM, enclave memory (EPC) should be covered by entries
> in the ACPI SRAT table.  These entries allow each EPC section to be
> associated with a NUMA node.
> 
> Use this information to implement a simple NUMA-aware allocator for
> enclave memory.
> 
> > Use phys_to_target_node() to associate each NUMA node with the EPC
> > sections contained within its range. In sgx_alloc_epc_page(), first try
> > to allocate from the NUMA node, where the CPU is executing. If that
> > fails, fallback to the legacy allocation.
> 
> By "legacy", you mean the one from the last patch? :)
> 
> > Link: https://lore.kernel.org/lkml/158188326978.894464.217282995221175417.stgit@dwillia2-desk3.amr.corp.intel.com/
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  arch/x86/Kconfig               |  1 +
> >  arch/x86/kernel/cpu/sgx/main.c | 84 ++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/sgx/sgx.h  |  9 ++++
> >  3 files changed, 94 insertions(+)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index a5f6a3013138..7eb1e96cfe8a 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1940,6 +1940,7 @@ config X86_SGX
> >  	depends on CRYPTO_SHA256=y
> >  	select SRCU
> >  	select MMU_NOTIFIER
> > +	select NUMA_KEEP_MEMINFO if NUMA
> 
> This dependency is worth mentioning somewhere.  Why do we suddenly need
> NUMA_KEEP_MEMINFO?
> 
> > +/* Nodes with one or more EPC sections. */
> > +static nodemask_t sgx_numa_mask;
> > +
> > +/*
> > + * Array with one list_head for each possible NUMA node.  Each
> > + * list contains all the sgx_epc_section's which are on that
> 
> 					   ^ no "'", please
> 
> > + * node.
> > + */
> > +static struct sgx_numa_node *sgx_numa_nodes;
> > +
> > +/*
> > + * sgx_free_epc_page() uses this to find out the correct struct sgx_numa_node,
> > + * to put the page in.
> > + */
> > +static int sgx_section_to_numa_node_id[SGX_MAX_EPC_SECTIONS];
> 
> If this is per-section, why not put it in struct sgx_epc_section?

Because struct sgx_epc_page does not contain a pointer to
struct sgx_epc_section.

> 
> >  /*
> > @@ -434,6 +451,36 @@ static bool __init sgx_page_reclaimer_init(struct list_head *laundry)
> >  	return true;
> >  }
> >  
> > +static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
> > +{
> > +	struct sgx_epc_page *page = NULL;
> > +	struct sgx_numa_node *sgx_node;
> > +
> > +	if (WARN_ON_ONCE(nid < 0 || nid >= num_possible_nodes()))
> > +		return NULL;
> 
> This has exactly one call-site which plumbs numa_node_id() in here
> pretty directly.  Is this check worthwhile?

Probably not.


> > +	if (!node_isset(nid, sgx_numa_mask))
> > +		return NULL;
> > +
> > +	sgx_node = &sgx_numa_nodes[nid];
> > +
> > +	spin_lock(&sgx_free_page_list_lock);
> 
> The glocal lock protecting a per-node structure is a bit unsightly.

The patch set could introduce additional patch for changing the
locking scheme. It's logically a separate change.

> > +	if (list_empty(&sgx_node->free_page_list)) {
> > +		spin_unlock(&sgx_free_page_list_lock);
> > +		return NULL;
> > +	}
> > +
> > +	page = list_first_entry(&sgx_node->free_page_list, struct sgx_epc_page, numa_list);
> > +	list_del_init(&page->numa_list);
> > +	list_del_init(&page->list);
> > +	sgx_nr_free_pages--;
> > +
> > +	spin_unlock(&sgx_free_page_list_lock);
> > +
> > +	return page;
> > +}
> > +
> >  /**
> >   * __sgx_alloc_epc_page() - Allocate an EPC page
> >   *
> > @@ -446,8 +493,14 @@ static bool __init sgx_page_reclaimer_init(struct list_head *laundry)
> >   */
> >  struct sgx_epc_page *__sgx_alloc_epc_page(void)
> >  {
> > +	int current_nid = numa_node_id();
> >  	struct sgx_epc_page *page;
> >  
> > +	/* Try to allocate EPC from the current node, first: */
> > +	page = __sgx_alloc_epc_page_from_node(current_nid);
> > +	if (page)
> > +		return page;
> > +
> >  	spin_lock(&sgx_free_page_list_lock);
> >  
> >  	if (list_empty(&sgx_free_page_list)) {
> > @@ -456,6 +509,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
> >  	}
> >  
> >  	page = list_first_entry(&sgx_free_page_list, struct sgx_epc_page, list);
> > +	list_del_init(&page->numa_list);
> >  	list_del_init(&page->list);
> >  	sgx_nr_free_pages--;
> 
> I would much rather prefer that this does what the real page allocator
> does: kep the page on a single list.  That list is maintained
> per-NUMA-node.  Allocations try local NUMA node structures, then fall
> back to other structures (hopefully in a locality-aware fashion).
> 
> I wrote you the loop that I want to see this implement in an earlier
> review.  This, basically:
> 
> 	page = NULL;
> 	nid = numa_node_id();
> 	while (true) {
> 		page = __sgx_alloc_epc_page_from_node(nid);	
> 		if (page)
> 			break;
> 
> 		nid = // ... some search here, next_node_in()...
> 		// check if we wrapped around:
> 		if (nid == numa_node_id())
> 			break;
> 	}
> 
> There's no global list.  You just walk around nodes trying to find one
> with space.  If you wrap around, you stop.
> 
> Please implement this.  If you think it's a bad idea, or can't, let's
> talk about it in advance.  Right now, it appears that my review comments
> aren't being incorporated into newer versions.

How I interpreted your earlier comments is that the fallback is unfair and
this patch set version does fix that. 

I can buy the above allocation scheme, but I don't think this patch set
version is a step backwards. The things done to struct sgx_epc_section
are exactly what should be done to it.

Implementation-wise you are asking me to squash 4/5 and 5/5 into a single
patch, and remove global list. It's a tiny iteration from this patch
version and I can do it.

> >  void sgx_free_epc_page(struct sgx_epc_page *page)
> >  {
> > +	int nid = sgx_section_to_numa_node_id[page->section];
> > +	struct sgx_numa_node *sgx_node = &sgx_numa_nodes[nid];
> >  	int ret;
> >  
> >  	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> > @@ -575,7 +631,15 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
> >  		return;
> >  
> >  	spin_lock(&sgx_free_page_list_lock);
> > +
> > +	/*   Enable NUMA local allocation in sgx_alloc_epc_page(). */
> > +	if (!node_isset(nid, sgx_numa_mask)) {
> > +		INIT_LIST_HEAD(&sgx_node->free_page_list);
> > +		node_set(nid, sgx_numa_mask);
> > +	}
> > +
> >  	list_add_tail(&page->list, &sgx_free_page_list);
> > +	list_add_tail(&page->numa_list, &sgx_node->free_page_list);
> >  	sgx_nr_free_pages++;
> >  	spin_unlock(&sgx_free_page_list_lock);
> >  }
> > @@ -626,8 +690,28 @@ static bool __init sgx_page_cache_init(struct list_head *laundry)
> >  {
> >  	u32 eax, ebx, ecx, edx, type;
> >  	u64 pa, size;
> > +	int nid;
> >  	int i;
> >  
> > +	nodes_clear(sgx_numa_mask);
> 
> Is this really required for a variable allocated in .bss?

Probably not, I'll check what nodes_clear() does.

> > +	sgx_numa_nodes = kmalloc_array(num_possible_nodes(), sizeof(*sgx_numa_nodes), GFP_KERNEL);
> 
> This is what I was looking for here, thanks!
> 
> > +	/*
> > +	 * Create NUMA node lookup table for sgx_free_epc_page() as the very
> > +	 * first step, as it is used to populate the free list's during the
> > +	 * initialization.
> > +	 */
> > +	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
> > +		nid = numa_map_to_online_node(phys_to_target_node(pa));
> > +		if (nid == NUMA_NO_NODE) {
> > +			/* The physical address is already printed above. */
> > +			pr_warn(FW_BUG "Unable to map EPC section to online node. Fallback to the NUMA node 0.\n");
> > +			nid = 0;
> > +		}
> > +
> > +		sgx_section_to_numa_node_id[i] = nid;
> > +	}
> > +
> >  	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
> >  		cpuid_count(SGX_CPUID, i + SGX_CPUID_EPC, &eax, &ebx, &ecx, &edx);
> >  
> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> > index 41ca045a574a..3a3c07fc0c8e 100644
> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > @@ -27,6 +27,7 @@ struct sgx_epc_page {
> >  	unsigned int flags;
> >  	struct sgx_encl_page *owner;
> >  	struct list_head list;
> > +	struct list_head numa_list;
> >  };
> 
> I'll say it again, explicitly: Each sgx_epc_page should be on one and
> only one free list: a per-NUMA-node list.
> 
> >  /*
> > @@ -43,6 +44,14 @@ struct sgx_epc_section {
> >  
> >  extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> >  
> > +/*
> > + * Contains the tracking data for NUMA nodes having EPC pages. Most importantly,
> > + * the free page list local to the node is stored here.
> > + */
> > +struct sgx_numa_node {
> > +	struct list_head free_page_list;
> > +};
> 
> I think it's unconscionable to leave this protected by a global lock.
> Please at least give us a per-node spinlock proteting this list.

I can do it but I'll add a separate commit for it. It's better to make
locking scheme changes that way (IMHO). Helps with bisection later on...

/Jarkko
