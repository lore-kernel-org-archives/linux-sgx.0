Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C7AC433E6
	for <linux-sgx@archiver.kernel.org>; Wed, 13 Jan 2021 00:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4630C23131
	for <linux-sgx@archiver.kernel.org>; Wed, 13 Jan 2021 00:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392434AbhAMAnP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 12 Jan 2021 19:43:15 -0500
Received: from mga18.intel.com ([134.134.136.126]:36086 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392353AbhAMAYx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 12 Jan 2021 19:24:53 -0500
IronPort-SDR: lAeD72ipNxoVqYUtHD1Q+VbMxpRrca1xOmNKglD82bvvtosekv5frMgQ1rt1Om0dF7qA7IlXtl
 16ZbVv3oxQsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="165806061"
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="165806061"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 16:24:03 -0800
IronPort-SDR: xf1pArokD/uydnkppULHtB7Ar6UzMmYIyzoe/Hrja/BP5yiTC2yAP/aSjPOz8QcZ+Tlnq1lzt/
 B7SjQ7cNWfnQ==
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="363701232"
Received: from hjhill1-mobl1.amr.corp.intel.com (HELO [10.209.161.74]) ([10.209.161.74])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 16:24:02 -0800
Subject: Re: [PATCH RFC] x86/sgx: Add trivial NUMA allocation
To:     Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <trivial@kernel.org>
References: <20201216135031.21518-1-jarkko@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <34b1acd1-e769-0dc2-a225-8ce3d2b6a085@intel.com>
Date:   Tue, 12 Jan 2021 16:24:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201216135031.21518-1-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 12/16/20 5:50 AM, Jarkko Sakkinen wrote:
> Create a pointer array for each NUMA node with the references to the
> contained EPC sections. Use this in __sgx_alloc_epc_page() to knock the
> current NUMA node before the others.

It makes it harder to comment when I'm not on cc.

Hint, hint... ;)

We need a bit more information here as well.  What's the relationship
between NUMA nodes and sections?  How does the BIOS tell us which NUMA
nodes a section is in?  Is it the same or different from normal RAM and
PMEM?

> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index c519fc5f6948..0da510763c47 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -13,6 +13,13 @@
>  #include "encl.h"
>  #include "encls.h"
>  
> +struct sgx_numa_node {
> +	struct sgx_epc_section *sections[SGX_MAX_EPC_SECTIONS];
> +	int nr_sections;
> +};

So, we have a 'NUMA node' structure already: pg_data_t.  Why don't we
just hang the epc sections off there?

> +static struct sgx_numa_node sgx_numa_nodes[MAX_NUMNODES];

Hmm...  Time to see if I can still do math.

#define SGX_MAX_EPC_SECTIONS            8

(sizeof(struct sgx_epc_section *) + sizeof(int)) * 8 * MAX_NUMNODES

CONFIG_NODES_SHIFT=10 (on Fedora)
#define MAX_NUMNODES (1 << NODES_SHIFT)

12*8*1024 = ~100k.  Yikes.  For *EVERY* system that enables SGX,
regardless if they are NUMA or not.'

Trivial is great, this may be too trivial.

Adding a list_head to pg_data_t and sgx_epc_section would add
SGX_MAX_EPC_SECTIONS*sizeof(list_head)=192 bytes plus 16 bytes per
*present* NUMA node.

>  /**
>   * __sgx_alloc_epc_page() - Allocate an EPC page
>   *
> @@ -485,14 +511,19 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
>   */
>  struct sgx_epc_page *__sgx_alloc_epc_page(void)
>  {
> -	struct sgx_epc_section *section;
>  	struct sgx_epc_page *page;
> +	int nid = numa_node_id();
>  	int i;
>  
> -	for (i = 0; i < sgx_nr_epc_sections; i++) {
> -		section = &sgx_epc_sections[i];
> +	page = __sgx_alloc_epc_page_from_node(nid);
> +	if (page)
> +		return page;
>  
> -		page = __sgx_alloc_epc_page_from_section(section);
> +	for (i = 0; i < sgx_nr_numa_nodes; i++) {
> +		if (i == nid)
> +			continue;

Yikes.  That's a horribly inefficient loop.  Consider if nodes 0 and
1023 were the only ones with EPC.  What would this loop do?  I think
it's a much better idea to keep a nodemask_t of nodes that have EPC.
Then, just do bitmap searches.

> +		page = __sgx_alloc_epc_page_from_node(i);
>  		if (page)
>  			return page;
>  	}
> @@ -661,11 +692,28 @@ static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
>  	       ((high & GENMASK_ULL(19, 0)) << 32);
>  }
>  
> +static int __init sgx_pfn_to_nid(unsigned long pfn)
> +{
> +	pg_data_t *pgdat;
> +	int nid;
> +
> +	for (nid = 0; nid < nr_node_ids; nid++) {
> +		pgdat = NODE_DATA(nid);
> +
> +		if (pfn >= pgdat->node_start_pfn &&
> +		    pfn < (pgdat->node_start_pfn + pgdat->node_spanned_pages))
> +			return nid;
> +	}
> +
> +	return 0;
> +}

I'm not positive this works.  I *thought* these ->node_start_pfn and
->node_spanned_pages are really only guaranteed to cover memory which is
managed by the kernel and has 'struct page' for it.

EPC doesn't have a 'struct page', so won't necessarily be covered by the
pgdat-> and zone-> ranges.  I *think* you may have to go all the way
back to the ACPI SRAT for this.

It would also be *possible* to have an SRAT constructed like this:

0->1GB System RAM - Node 0
1->2GB Reserved   - Node 1
2->3GB System RAM - Node 0

Where the 1->2GB is EPC.  The Node 0 pg_data_t would be:

	pgdat->node_start_pfn = 0
	pgdat->node_spanned_pages = 3GB


