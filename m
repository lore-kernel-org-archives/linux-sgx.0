Return-Path: <SRS0=TB01=ID=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DATE_IN_PAST_24_48,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03229C4321A
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Mar 2021 17:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5160650AF
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Mar 2021 17:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhCERi2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Mar 2021 12:38:28 -0500
Received: from mga04.intel.com ([192.55.52.120]:23772 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhCERiM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Mar 2021 12:38:12 -0500
IronPort-SDR: bRZNx2719w98lh23hyszg9pwOV7E6UWbqrkwGpOTPfSy1MY3dSlkKkrxRP+zkC4tawDGn5+pTr
 AnYNk0UDhYXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9914"; a="185287117"
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="185287117"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 09:38:10 -0800
IronPort-SDR: uHxWCYpeWtedGHMWbpgcvY08sSKZcnhNXy65DNsFavjIAyzgZUR9vaQ79O8DNkBtax3j/XlP4b
 Qxv6LD0vk4UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="446288785"
Received: from viggo.jf.intel.com (HELO ray) ([10.54.77.144])
  by orsmga001.jf.intel.com with ESMTP; 05 Mar 2021 09:38:09 -0800
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by ray (Postfix) with ESMTP id 6AB4EE0959;
        Wed,  3 Mar 2021 16:20:03 -0800 (PST)
Subject: Re: [PATCH v3 5/5] x86/sgx: Add a basic NUMA allocation scheme to
 sgx_alloc_epc_page()
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-6-jarkko@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <7621d89e-9347-d8a5-a8b0-a108990d0e6d@intel.com>
Date:   Wed, 3 Mar 2021 16:20:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210303150323.433207-6-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

What changed from the last patch?

On 3/3/21 7:03 AM, Jarkko Sakkinen wrote:
> Background
> ==========
> 
> EPC section is covered by one or more SRAT entries that are associated with
> one and only one PXM (NUMA node). The motivation behind this patch is to
> provide basic elements of building allocation scheme based on this premise.

Just like normal RAM, enclave memory (EPC) should be covered by entries
in the ACPI SRAT table.  These entries allow each EPC section to be
associated with a NUMA node.

Use this information to implement a simple NUMA-aware allocator for
enclave memory.

> Use phys_to_target_node() to associate each NUMA node with the EPC
> sections contained within its range. In sgx_alloc_epc_page(), first try
> to allocate from the NUMA node, where the CPU is executing. If that
> fails, fallback to the legacy allocation.

By "legacy", you mean the one from the last patch? :)

> Link: https://lore.kernel.org/lkml/158188326978.894464.217282995221175417.stgit@dwillia2-desk3.amr.corp.intel.com/
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/x86/Kconfig               |  1 +
>  arch/x86/kernel/cpu/sgx/main.c | 84 ++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h  |  9 ++++
>  3 files changed, 94 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index a5f6a3013138..7eb1e96cfe8a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1940,6 +1940,7 @@ config X86_SGX
>  	depends on CRYPTO_SHA256=y
>  	select SRCU
>  	select MMU_NOTIFIER
> +	select NUMA_KEEP_MEMINFO if NUMA

This dependency is worth mentioning somewhere.  Why do we suddenly need
NUMA_KEEP_MEMINFO?

> +/* Nodes with one or more EPC sections. */
> +static nodemask_t sgx_numa_mask;
> +
> +/*
> + * Array with one list_head for each possible NUMA node.  Each
> + * list contains all the sgx_epc_section's which are on that

					   ^ no "'", please

> + * node.
> + */
> +static struct sgx_numa_node *sgx_numa_nodes;
> +
> +/*
> + * sgx_free_epc_page() uses this to find out the correct struct sgx_numa_node,
> + * to put the page in.
> + */
> +static int sgx_section_to_numa_node_id[SGX_MAX_EPC_SECTIONS];

If this is per-section, why not put it in struct sgx_epc_section?

>  /*
> @@ -434,6 +451,36 @@ static bool __init sgx_page_reclaimer_init(struct list_head *laundry)
>  	return true;
>  }
>  
> +static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
> +{
> +	struct sgx_epc_page *page = NULL;
> +	struct sgx_numa_node *sgx_node;
> +
> +	if (WARN_ON_ONCE(nid < 0 || nid >= num_possible_nodes()))
> +		return NULL;

This has exactly one call-site which plumbs numa_node_id() in here
pretty directly.  Is this check worthwhile?

> +	if (!node_isset(nid, sgx_numa_mask))
> +		return NULL;
> +
> +	sgx_node = &sgx_numa_nodes[nid];
> +
> +	spin_lock(&sgx_free_page_list_lock);

The glocal lock protecting a per-node structure is a bit unsightly.

> +	if (list_empty(&sgx_node->free_page_list)) {
> +		spin_unlock(&sgx_free_page_list_lock);
> +		return NULL;
> +	}
> +
> +	page = list_first_entry(&sgx_node->free_page_list, struct sgx_epc_page, numa_list);
> +	list_del_init(&page->numa_list);
> +	list_del_init(&page->list);
> +	sgx_nr_free_pages--;
> +
> +	spin_unlock(&sgx_free_page_list_lock);
> +
> +	return page;
> +}
> +
>  /**
>   * __sgx_alloc_epc_page() - Allocate an EPC page
>   *
> @@ -446,8 +493,14 @@ static bool __init sgx_page_reclaimer_init(struct list_head *laundry)
>   */
>  struct sgx_epc_page *__sgx_alloc_epc_page(void)
>  {
> +	int current_nid = numa_node_id();
>  	struct sgx_epc_page *page;
>  
> +	/* Try to allocate EPC from the current node, first: */
> +	page = __sgx_alloc_epc_page_from_node(current_nid);
> +	if (page)
> +		return page;
> +
>  	spin_lock(&sgx_free_page_list_lock);
>  
>  	if (list_empty(&sgx_free_page_list)) {
> @@ -456,6 +509,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
>  	}
>  
>  	page = list_first_entry(&sgx_free_page_list, struct sgx_epc_page, list);
> +	list_del_init(&page->numa_list);
>  	list_del_init(&page->list);
>  	sgx_nr_free_pages--;

I would much rather prefer that this does what the real page allocator
does: kep the page on a single list.  That list is maintained
per-NUMA-node.  Allocations try local NUMA node structures, then fall
back to other structures (hopefully in a locality-aware fashion).

I wrote you the loop that I want to see this implement in an earlier
review.  This, basically:

	page = NULL;
	nid = numa_node_id();
	while (true) {
		page = __sgx_alloc_epc_page_from_node(nid);	
		if (page)
			break;

		nid = // ... some search here, next_node_in()...
		// check if we wrapped around:
		if (nid == numa_node_id())
			break;
	}

There's no global list.  You just walk around nodes trying to find one
with space.  If you wrap around, you stop.

Please implement this.  If you think it's a bad idea, or can't, let's
talk about it in advance.  Right now, it appears that my review comments
aren't being incorporated into newer versions.

>  void sgx_free_epc_page(struct sgx_epc_page *page)
>  {
> +	int nid = sgx_section_to_numa_node_id[page->section];
> +	struct sgx_numa_node *sgx_node = &sgx_numa_nodes[nid];
>  	int ret;
>  
>  	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> @@ -575,7 +631,15 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
>  		return;
>  
>  	spin_lock(&sgx_free_page_list_lock);
> +
> +	/*   Enable NUMA local allocation in sgx_alloc_epc_page(). */
> +	if (!node_isset(nid, sgx_numa_mask)) {
> +		INIT_LIST_HEAD(&sgx_node->free_page_list);
> +		node_set(nid, sgx_numa_mask);
> +	}
> +
>  	list_add_tail(&page->list, &sgx_free_page_list);
> +	list_add_tail(&page->numa_list, &sgx_node->free_page_list);
>  	sgx_nr_free_pages++;
>  	spin_unlock(&sgx_free_page_list_lock);
>  }
> @@ -626,8 +690,28 @@ static bool __init sgx_page_cache_init(struct list_head *laundry)
>  {
>  	u32 eax, ebx, ecx, edx, type;
>  	u64 pa, size;
> +	int nid;
>  	int i;
>  
> +	nodes_clear(sgx_numa_mask);

Is this really required for a variable allocated in .bss?

> +	sgx_numa_nodes = kmalloc_array(num_possible_nodes(), sizeof(*sgx_numa_nodes), GFP_KERNEL);

This is what I was looking for here, thanks!

> +	/*
> +	 * Create NUMA node lookup table for sgx_free_epc_page() as the very
> +	 * first step, as it is used to populate the free list's during the
> +	 * initialization.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
> +		nid = numa_map_to_online_node(phys_to_target_node(pa));
> +		if (nid == NUMA_NO_NODE) {
> +			/* The physical address is already printed above. */
> +			pr_warn(FW_BUG "Unable to map EPC section to online node. Fallback to the NUMA node 0.\n");
> +			nid = 0;
> +		}
> +
> +		sgx_section_to_numa_node_id[i] = nid;
> +	}
> +
>  	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
>  		cpuid_count(SGX_CPUID, i + SGX_CPUID_EPC, &eax, &ebx, &ecx, &edx);
>  
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 41ca045a574a..3a3c07fc0c8e 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -27,6 +27,7 @@ struct sgx_epc_page {
>  	unsigned int flags;
>  	struct sgx_encl_page *owner;
>  	struct list_head list;
> +	struct list_head numa_list;
>  };

I'll say it again, explicitly: Each sgx_epc_page should be on one and
only one free list: a per-NUMA-node list.

>  /*
> @@ -43,6 +44,14 @@ struct sgx_epc_section {
>  
>  extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
>  
> +/*
> + * Contains the tracking data for NUMA nodes having EPC pages. Most importantly,
> + * the free page list local to the node is stored here.
> + */
> +struct sgx_numa_node {
> +	struct list_head free_page_list;
> +};

I think it's unconscionable to leave this protected by a global lock.
Please at least give us a per-node spinlock proteting this list.


