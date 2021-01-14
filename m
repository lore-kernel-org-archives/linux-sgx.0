Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1E4C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 17:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1545823B4B
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 17:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbhANRzg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 Jan 2021 12:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbhANRzg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 Jan 2021 12:55:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6540D23A57;
        Thu, 14 Jan 2021 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610646895;
        bh=G3GC1hucK9xYKXNXmO3eHSnGDiDgRjhzWWI+4CvgXG4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WvnfJZ7yMZG8M8lcxWCL4NEKnAuoauadu1x9YR8exc+Q2xB6A4luQ7lpXtAsWc4Ei
         Yw2ecoxY0KNzH/DBWso30nk8buxtrfg+CzqkMwbi5jsvzhiAusXLp46uV/QoZzMcjm
         H+J30ocesOSwp6R5dRspR6p/BC611rtvlmbIJJJQJWaVGcxewtNFCO8uPxmx66aaXg
         z7Y2gRIS7FJaQRGLbxCf3ahNsOpbUmtH5u3RMDUDBNIpTPCli8IM9I4iu8V2N26NIf
         8g0hvqneE3kmBVPqH96BbrdHbRq8o6YiVEOzdWVdAQBhFlOXu5RYikPP5KYVpheZtc
         vPZqCj59EZkKA==
Date:   Thu, 14 Jan 2021 19:54:50 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH RFC] x86/sgx: Add trivial NUMA allocation
Message-ID: <YACFasdDi0siM2ML@kernel.org>
References: <20201216135031.21518-1-jarkko@kernel.org>
 <34b1acd1-e769-0dc2-a225-8ce3d2b6a085@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34b1acd1-e769-0dc2-a225-8ce3d2b6a085@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 12, 2021 at 04:24:01PM -0800, Dave Hansen wrote:
> On 12/16/20 5:50 AM, Jarkko Sakkinen wrote:
> > Create a pointer array for each NUMA node with the references to the
> > contained EPC sections. Use this in __sgx_alloc_epc_page() to knock the
> > current NUMA node before the others.
> 
> It makes it harder to comment when I'm not on cc.
> 
> Hint, hint... ;)
> 
> We need a bit more information here as well.  What's the relationship
> between NUMA nodes and sections?  How does the BIOS tell us which NUMA
> nodes a section is in?  Is it the same or different from normal RAM and
> PMEM?

How does it go with pmem?

> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index c519fc5f6948..0da510763c47 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -13,6 +13,13 @@
> >  #include "encl.h"
> >  #include "encls.h"
> >  
> > +struct sgx_numa_node {
> > +	struct sgx_epc_section *sections[SGX_MAX_EPC_SECTIONS];
> > +	int nr_sections;
> > +};
> 
> So, we have a 'NUMA node' structure already: pg_data_t.  Why don't we
> just hang the epc sections off there?
> 
> > +static struct sgx_numa_node sgx_numa_nodes[MAX_NUMNODES];
> 
> Hmm...  Time to see if I can still do math.
> 
> #define SGX_MAX_EPC_SECTIONS            8
> 
> (sizeof(struct sgx_epc_section *) + sizeof(int)) * 8 * MAX_NUMNODES
> 
> CONFIG_NODES_SHIFT=10 (on Fedora)
> #define MAX_NUMNODES (1 << NODES_SHIFT)
> 
> 12*8*1024 = ~100k.  Yikes.  For *EVERY* system that enables SGX,
> regardless if they are NUMA or not.'
> 
> Trivial is great, this may be too trivial.
> 
> Adding a list_head to pg_data_t and sgx_epc_section would add
> SGX_MAX_EPC_SECTIONS*sizeof(list_head)=192 bytes plus 16 bytes per
> *present* NUMA node.

I'm hearing you.

> >  /**
> >   * __sgx_alloc_epc_page() - Allocate an EPC page
> >   *
> > @@ -485,14 +511,19 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
> >   */
> >  struct sgx_epc_page *__sgx_alloc_epc_page(void)
> >  {
> > -	struct sgx_epc_section *section;
> >  	struct sgx_epc_page *page;
> > +	int nid = numa_node_id();
> >  	int i;
> >  
> > -	for (i = 0; i < sgx_nr_epc_sections; i++) {
> > -		section = &sgx_epc_sections[i];
> > +	page = __sgx_alloc_epc_page_from_node(nid);
> > +	if (page)
> > +		return page;
> >  
> > -		page = __sgx_alloc_epc_page_from_section(section);
> > +	for (i = 0; i < sgx_nr_numa_nodes; i++) {
> > +		if (i == nid)
> > +			continue;
> 
> Yikes.  That's a horribly inefficient loop.  Consider if nodes 0 and
> 1023 were the only ones with EPC.  What would this loop do?  I think
> it's a much better idea to keep a nodemask_t of nodes that have EPC.
> Then, just do bitmap searches.

OK, so we need to maintain nodemask_t containing nodes with EPC.

Probably also split the patch to a patch that builds nodemask_t,
and the one that uses it. They are separately reviewable clearly.
The allocation part can considered sorted out now.
> 
> > +		page = __sgx_alloc_epc_page_from_node(i);
> >  		if (page)
> >  			return page;
> >  	}
> > @@ -661,11 +692,28 @@ static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
> >  	       ((high & GENMASK_ULL(19, 0)) << 32);
> >  }
> >  
> > +static int __init sgx_pfn_to_nid(unsigned long pfn)
> > +{
> > +	pg_data_t *pgdat;
> > +	int nid;
> > +
> > +	for (nid = 0; nid < nr_node_ids; nid++) {
> > +		pgdat = NODE_DATA(nid);
> > +
> > +		if (pfn >= pgdat->node_start_pfn &&
> > +		    pfn < (pgdat->node_start_pfn + pgdat->node_spanned_pages))
> > +			return nid;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> I'm not positive this works.  I *thought* these ->node_start_pfn and
> ->node_spanned_pages are really only guaranteed to cover memory which is
> managed by the kernel and has 'struct page' for it.
> 
> EPC doesn't have a 'struct page', so won't necessarily be covered by the
> pgdat-> and zone-> ranges.  I *think* you may have to go all the way
> back to the ACPI SRAT for this.
> 
> It would also be *possible* to have an SRAT constructed like this:
> 
> 0->1GB System RAM - Node 0
> 1->2GB Reserved   - Node 1
> 2->3GB System RAM - Node 0
> 
> Where the 1->2GB is EPC.  The Node 0 pg_data_t would be:
> 
> 	pgdat->node_start_pfn = 0
> 	pgdat->node_spanned_pages = 3GB

If I've understood the current Linux memory architecture correctly.

- Memory is made available through mm/memory_hotplug.c, which is populated
  by drivers/acpi/acpi_memhotplug.c.
- drivers/acpi/numa/srat.c provides the conversion API from proximity node to
  logical node but I'm not *yet* sure how the interaction goes with memory
  hot plugging

I'm not sure of I'm following the idea of alternative SRAT construciton.
So are you saying that srat.c would somehow group pxm's with EPC to
specific node numbers?

/Jarkko
