Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032DBC433E6
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 15:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6B664FBD
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 15:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhCJPpF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 10:45:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:25437 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232523AbhCJPow (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Mar 2021 10:44:52 -0500
IronPort-SDR: C4+dS4A0x5MMGdxhpgX2JVOf4oYkT2O9KhgvJfkls8C4STjP3PUf35FfLcbKbeABHXV54xIq/C
 kjnjkIk4Jz/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="188589510"
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="188589510"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 07:44:42 -0800
IronPort-SDR: fcQi78U6lYR1iT5VHZvV8wlOLMvaHZ/dua28JgCGxXRVno2xt8kUsdZk9gEMzlRJ1z4Qm+q5jf
 tFYd8q2xoHCw==
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="431257138"
Received: from umalluga-mobl.amr.corp.intel.com (HELO [10.209.90.191]) ([10.209.90.191])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 07:44:40 -0800
Subject: Re: [PATCH v3 5/5] x86/sgx: Add a basic NUMA allocation scheme to
 sgx_alloc_epc_page()
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-6-jarkko@kernel.org>
 <7621d89e-9347-d8a5-a8b0-a108990d0e6d@intel.com>
 <YEitzCiXd02/Pxy1@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <c710eea8-a0ea-70b6-6521-0dd685adbb06@intel.com>
Date:   Wed, 10 Mar 2021 07:44:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YEitzCiXd02/Pxy1@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

>>> + * node.
>>> + */
>>> +static struct sgx_numa_node *sgx_numa_nodes;
>>> +
>>> +/*
>>> + * sgx_free_epc_page() uses this to find out the correct struct sgx_numa_node,
>>> + * to put the page in.
>>> + */
>>> +static int sgx_section_to_numa_node_id[SGX_MAX_EPC_SECTIONS];
>>
>> If this is per-section, why not put it in struct sgx_epc_section?
> 
> Because struct sgx_epc_page does not contain a pointer to
> struct sgx_epc_section.

Currently, we have epc_page->section.  That's not changing.  But, with
the free list moving from sgx_epc_section to sgx_numa_node, we need a
way to get from page->node, not just page->section.

We can either add that to:

	struct sgx_epc_section {
		...
+		struct sgx_numa_node *node;
	}

so we can do epc_page->section->node to find the epc_page's free list,
or we could just do:

 struct sgx_epc_page {
- 	unsigned int section;
+ 	unsigned int node;
 	unsigned int flags;
 	struct sgx_encl_page *owner;
 	struct list_head list;
	struct list_head numa_list;
 };

and go from page->node directly.

>>>  	page = list_first_entry(&sgx_free_page_list, struct sgx_epc_page, list);
>>> +	list_del_init(&page->numa_list);
>>>  	list_del_init(&page->list);
>>>  	sgx_nr_free_pages--;
>>
>> I would much rather prefer that this does what the real page allocator
>> does: kep the page on a single list.  That list is maintained
>> per-NUMA-node.  Allocations try local NUMA node structures, then fall
>> back to other structures (hopefully in a locality-aware fashion).
>>
>> I wrote you the loop that I want to see this implement in an earlier
>> review.  This, basically:
>>
>> 	page = NULL;
>> 	nid = numa_node_id();
>> 	while (true) {
>> 		page = __sgx_alloc_epc_page_from_node(nid);	
>> 		if (page)
>> 			break;
>>
>> 		nid = // ... some search here, next_node_in()...
>> 		// check if we wrapped around:
>> 		if (nid == numa_node_id())
>> 			break;
>> 	}
>>
>> There's no global list.  You just walk around nodes trying to find one
>> with space.  If you wrap around, you stop.
>>
>> Please implement this.  If you think it's a bad idea, or can't, let's
>> talk about it in advance.  Right now, it appears that my review comments
>> aren't being incorporated into newer versions.
> 
> How I interpreted your earlier comments is that the fallback is unfair and
> this patch set version does fix that. 
> 
> I can buy the above allocation scheme, but I don't think this patch set
> version is a step backwards. The things done to struct sgx_epc_section
> are exactly what should be done to it.

To me, it's a step backwards.  It regresses in that it falls back to an
entirely non-NUMA aware allocation mechanism.  The global list is
actually likely to be even worse than the per-section searches because
it has a global lock as opposed to the at per-section locks.  It also
has the overhead of managing two lists instead of one.

So, yes, it is *fair* in terms of NUMA node pressure.  But being fair in
a NUMA-aware allocator by simply not doing NUMA at all is a regression.

> Implementation-wise you are asking me to squash 4/5 and 5/5 into a single
> patch, and remove global list. It's a tiny iteration from this patch
> version and I can do it.

Sounds good.


