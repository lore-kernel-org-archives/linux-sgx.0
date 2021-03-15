Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92180C43331
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Mar 2021 16:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48CE464F34
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Mar 2021 16:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhCOQfP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Mar 2021 12:35:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:53919 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232411AbhCOQfK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 15 Mar 2021 12:35:10 -0400
IronPort-SDR: 5w1Ib1IVo8zbNw0LqJUe4lNrTOKglSXsUc/1vQRL1rnmbsSx1QnjJW3C5k8fjHcARy5WszjIYZ
 fyyM+v4i080Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="250483050"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="250483050"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 09:35:06 -0700
IronPort-SDR: 10d+W+3k4MXz4PLz6CaHbtzWWn8yKICDZBMyTBBvXwzctCe72BTjlDhWlb4lySzLXuSrmfsCPK
 Rh8wdSJfdVZA==
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="601484385"
Received: from lguadamu-mobl1.amr.corp.intel.com (HELO [10.213.176.188]) ([10.213.176.188])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 09:35:04 -0700
Subject: Re: [PATCH v4 3/3] x86/sgx: Add a basic NUMA allocation scheme to
 sgx_alloc_epc_page()
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20210313160119.1318533-1-jarkko@kernel.org>
 <20210313160119.1318533-4-jarkko@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <93a2e333-f604-fc44-ee35-3da06b17392a@intel.com>
Date:   Mon, 15 Mar 2021 09:35:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210313160119.1318533-4-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/13/21 8:01 AM, Jarkko Sakkinen wrote:
> Background
> ==========
> 
> EPC section is covered by one or more SRAT entries that are associated with
> one and only one PXM (NUMA node). The motivation behind this patch is to
> provide basic elements of building allocation scheme based on this premise.

A better set of background information here would also remind folks what
an 'EPC section' is.

> Just like normal RAM, enclave memory (EPC) should be covered by entries
> in the ACPI SRAT table.  These entries allow each EPC section to be
> associated with a NUMA node.
> 
> Use this information to implement a simple NUMA-aware allocator for
> enclave memory.

SGX enclave memory is enumerated by the processor in contiguous physical
ranges called "EPC sections".  Currently, there is a free list per
section, but allocations simply target the lowest-numbered sections.
This is functional, but has no NUMA awareness.

Fortunately, EPC sections are covered by entries in the ACPI SRAT table.
 These entries allow each EPC section to be associated with a NUMA node,
just like normal RAM.


> Solution
> ========
> 
> Use phys_to_target_node() to associate each NUMA node with the EPC
> sections contained within its range. In sgx_alloc_epc_page(), first try
> to allocate from the NUMA node, where the CPU is executing. If that
> fails, allocate from other nodes, iterating them from the current node
> in order.

To me, this is just telling us what the code does.  It's not very
useful.  I'd say:

Implement a NUMA-aware enclave page allocator.  Mirror the buddy
allocator and maintain a list of enclave pages for each NUMA node.
Attempt to allocate enclave memory first from local nodes, then fall
back to other nodes.

Note that the fallback is not as sophisticated as the buddy allocator
and is itself not aware of NUMA distances.  When a node's free list is
empty, it searches for the next-highest node with enclave pages (and
will wrap if necessary).  This could be improved in the future.

> Other
> =====
> 
> NUMA_KEEP_MEMINFO dependency is required for phys_to_target_node().

Reading the changelog, it's not obvious that you're talking about a
Kconfig variable here.

I was also thinking, this says:

	# Keep arch NUMA mapping infrastructure post-init.
	config NUMA_KEEP_MEMINFO
	        bool

But we only need it during SGX init.  Could you explain a bit why it's
needed here specifically?  Superficially it seems like we only need this
info *during* init.

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 513895af8ee7..3e6152a8dd2b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1930,6 +1930,7 @@ config X86_SGX
>  	depends on CRYPTO_SHA256=y
>  	select SRCU
>  	select MMU_NOTIFIER
> +	select NUMA_KEEP_MEMINFO if NUMA
>  	help
>  	  Intel(R) Software Guard eXtensions (SGX) is a set of CPU instructions
>  	  that can be used by applications to set aside private regions of code
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index cb4561444b96..3b524a1361d6 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -18,14 +18,23 @@ static int sgx_nr_epc_sections;
>  static struct task_struct *ksgxd_tsk;
>  static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
>  
> -/*
> - * These variables are part of the state of the reclaimer, and must be accessed
> - * with sgx_reclaimer_lock acquired.
> - */
> +/* The reclaimer lock protected variables prepend the lock. */
>  static LIST_HEAD(sgx_active_page_list);
> -
>  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
>  
> +/* The free page list lock protected variables prepend the lock. */
> +static unsigned long sgx_nr_free_pages;
> +
> +/* Nodes with one or more EPC sections. */
> +static nodemask_t sgx_numa_mask;
> +
> +/*
> + * Array with one list_head for each possible NUMA node.  Each
> + * list contains all the sgx_epc_section's which are on that
> + * node.
> + */
> +static struct sgx_numa_node *sgx_numa_nodes;
> +
>  /*
>   * When the driver initialized, EPC pages go first here, as they could be
>   * initialized to an active enclave, on kexec entry.
> @@ -352,21 +361,9 @@ static void sgx_reclaim_pages(void)
>  	}
>  }
>  
> -static unsigned long sgx_nr_free_pages(void)
> -{
> -	unsigned long cnt = 0;
> -	int i;
> -
> -	for (i = 0; i < sgx_nr_epc_sections; i++)
> -		cnt += sgx_epc_sections[i].free_cnt;
> -
> -	return cnt;
> -}
> -
>  static bool sgx_should_reclaim(unsigned long watermark)
>  {
> -	return sgx_nr_free_pages() < watermark &&
> -	       !list_empty(&sgx_active_page_list);
> +	return sgx_nr_free_pages < watermark && !list_empty(&sgx_active_page_list);
>  }
>  
>  static int ksgxd(void *p)
> @@ -443,50 +440,63 @@ static bool __init sgx_page_reclaimer_init(void)
>  	return true;
>  }
>  
> -static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
> +static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
>  {
> -	struct sgx_epc_page *page;
> +	struct sgx_numa_node *node = &sgx_numa_nodes[nid];
> +	struct sgx_epc_page *page = NULL;
> +
> +	if (!node_isset(nid, sgx_numa_mask))
> +		return NULL;

I don't think this mask check is super necessary.  It won't ever trigger
for the "fallback" path.  For the node-local allocation, I guess it
saves a cacheline (node->free_page_list).

> -	spin_lock(&section->lock);
> +	spin_lock(&node->lock);
>  
> -	if (list_empty(&section->page_list)) {
> -		spin_unlock(&section->lock);
> +	if (list_empty(&node->free_page_list)) {
> +		spin_unlock(&node->lock);
>  		return NULL;
>  	}
>  
> -	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
> +	page = list_first_entry(&node->free_page_list, struct sgx_epc_page, list);
>  	list_del_init(&page->list);
> -	section->free_cnt--;
> +	sgx_nr_free_pages--;
> +
> +	spin_unlock(&node->lock);
>  
> -	spin_unlock(&section->lock);
>  	return page;
>  }
>  
>  /**
>   * __sgx_alloc_epc_page() - Allocate an EPC page
>   *
> - * Iterate through EPC sections and borrow a free EPC page to the caller. When a
> - * page is no longer needed it must be released with sgx_free_epc_page().
> + * Iterate through NUMA nodes and borrow a free EPC page to the caller. When a

"borrow" is a weird word to use here.

> + * page is no longer needed it must be released with sgx_free_epc_page(). Start
> + * from the NUMA node, where the caller is executing.

I don't think we need to tell folks how allocators work: that "free" and
"alloc" are opposites.

>   * Return:
> - *   an EPC page,
> - *   -errno on error
> + * - an EPC page:	Free EPC pages were available.
> + * - ERR_PTR(-ENOMEM):	Run out of EPC pages.
>   */

I think returning NULL from a allocator is probably OK.  Folks
understand that NULL means ENOMEM.

>  struct sgx_epc_page *__sgx_alloc_epc_page(void)
>  {
> -	struct sgx_epc_section *section;
>  	struct sgx_epc_page *page;
> -	int i;
> +	int nid = numa_node_id();
>  
> -	for (i = 0; i < sgx_nr_epc_sections; i++) {
> -		section = &sgx_epc_sections[i];
> +	/* Try to allocate EPC from the current node, first: */
> +	page = __sgx_alloc_epc_page_from_node(nid);
> +	if (page)
> +		return page;
>  
> -		page = __sgx_alloc_epc_page_from_section(section);
> +	/* Then, go through the other nodes: */
> +	while (true) {
> +		nid = next_node_in(nid, sgx_numa_mask);
> +		if (nid == numa_node_id())
> +			break;

One nit: This can _theoretically_ livelock.  Preemption is enabled here
and numa_node_id() can change.  It's theoretically possible that
numa_node_id()!=nid forever.

The way to prevent this is to read numa_node_id() once and then compare
'nid' against that single read.

> +		page = __sgx_alloc_epc_page_from_node(nid);
>  		if (page)
> -			return page;
> +			break;
>  	}
>  
> -	return ERR_PTR(-ENOMEM);
> +	return page;
>  }

I guess you probably wrote it this way because you prefer it.  But, this
can be written with a single call to __sgx_alloc_epc_page_from_node().

>  /**
> @@ -592,6 +602,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
>  void sgx_free_epc_page(struct sgx_epc_page *page)
>  {
>  	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
> +	struct sgx_numa_node *node = section->node;
>  	int ret;
>  
>  	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> @@ -600,10 +611,12 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
>  	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
>  		return;
>  
> -	spin_lock(&section->lock);
> -	list_add_tail(&page->list, &section->page_list);
> -	section->free_cnt++;
> -	spin_unlock(&section->lock);
> +	spin_lock(&node->lock);
> +
> +	list_add_tail(&page->list, &node->free_page_list);
> +	sgx_nr_free_pages++;
> +
> +	spin_unlock(&node->lock);
>  }
>  
>  static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
> @@ -624,8 +637,6 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  	}
>  
>  	section->phys_addr = phys_addr;
> -	spin_lock_init(&section->lock);
> -	INIT_LIST_HEAD(&section->page_list);
>  
>  	for (i = 0; i < nr_pages; i++) {
>  		section->pages[i].section = index;
> @@ -634,7 +645,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
>  	}
>  
> -	section->free_cnt = nr_pages;
> +	sgx_nr_free_pages += nr_pages;
>  	return true;
>  }
>  
> @@ -653,8 +664,11 @@ static bool __init sgx_page_cache_init(void)
>  {
>  	u32 eax, ebx, ecx, edx, type;
>  	u64 pa, size;
> +	int nid;
>  	int i;
>  
> +	sgx_numa_nodes = kmalloc_array(num_possible_nodes(), sizeof(*sgx_numa_nodes), GFP_KERNEL);

Needs a NULL check.

>  	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
>  		cpuid_count(SGX_CPUID, i + SGX_CPUID_EPC, &eax, &ebx, &ecx, &edx);
>  
> @@ -677,6 +691,21 @@ static bool __init sgx_page_cache_init(void)
>  			break;
>  		}
>  
> +		nid = numa_map_to_online_node(phys_to_target_node(pa));
> +		if (nid == NUMA_NO_NODE) {
> +			/* The physical address is already printed above. */
> +			pr_warn(FW_BUG "Unable to map EPC section to online node. Fallback to the NUMA node 0.\n");
> +			nid = 0;
> +		}
> +
> +		if (!node_isset(nid, sgx_numa_mask)) {
> +			spin_lock_init(&sgx_numa_nodes[nid].lock);
> +			INIT_LIST_HEAD(&sgx_numa_nodes[nid].free_page_list);
> +			node_set(nid, sgx_numa_mask);
> +		}
> +
> +		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
> +
>  		sgx_nr_epc_sections++;
>  	}

The rest looks OK.
