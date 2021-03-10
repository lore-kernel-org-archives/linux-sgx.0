Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B345CC433E6
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 21:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76A6D64FD6
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 21:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhCJVtQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 16:49:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232206AbhCJVtO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Mar 2021 16:49:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C825064FAB;
        Wed, 10 Mar 2021 21:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615412954;
        bh=+oOFNv56O7sMY7qolB4gLqf1KbVTKbHQJ69T+KpnJ2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZLvuUQ+VxNtzXtc89ljBECwuc81VfHAHA8rI1rEkpff+j5Lh2nAl3YUvNMMJF+h1j
         c34KzybBRtUBywyrFAU1zoimW8MV+mS1Y5SXSS7l5y5he3UokpYm6LpI2NhrKTaD9B
         bIP1j5KU5103Rf5gxy62v9VxHH+IVSW4lyI4VbaHx/3tt+w2LufwFwLNomu0tXESO5
         wpbLMZQqVZhZ0CDgEMOxXe/zNKXKvHJcLyylS4cypnPtnGlN2wEoKRGli5Vpo5kmFL
         rj15DNdq1YnHBEwpPbAlcik68D+RnYURpExd9pKrY4ERqdV52KXNFTiIvfZjnNgiZr
         TcidJ4eOx2wvA==
Date:   Wed, 10 Mar 2021 23:48:50 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] x86/sgx: Add a basic NUMA allocation scheme to
 sgx_alloc_epc_page()
Message-ID: <YEk+wpHbSrHBZeKn@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-6-jarkko@kernel.org>
 <7621d89e-9347-d8a5-a8b0-a108990d0e6d@intel.com>
 <YEitzCiXd02/Pxy1@kernel.org>
 <c710eea8-a0ea-70b6-6521-0dd685adbb06@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c710eea8-a0ea-70b6-6521-0dd685adbb06@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 10, 2021 at 07:44:39AM -0800, Dave Hansen wrote:
> >>> + * node.
> >>> + */
> >>> +static struct sgx_numa_node *sgx_numa_nodes;
> >>> +
> >>> +/*
> >>> + * sgx_free_epc_page() uses this to find out the correct struct sgx_numa_node,
> >>> + * to put the page in.
> >>> + */
> >>> +static int sgx_section_to_numa_node_id[SGX_MAX_EPC_SECTIONS];
> >>
> >> If this is per-section, why not put it in struct sgx_epc_section?
> > 
> > Because struct sgx_epc_page does not contain a pointer to
> > struct sgx_epc_section.
> 
> Currently, we have epc_page->section.  That's not changing.  But, with
> the free list moving from sgx_epc_section to sgx_numa_node, we need a
> way to get from page->node, not just page->section.
> 
> We can either add that to:
> 
> 	struct sgx_epc_section {
> 		...
> +		struct sgx_numa_node *node;
> 	}
> 
> so we can do epc_page->section->node to find the epc_page's free list,
> or we could just do:
> 
>  struct sgx_epc_page {
> - 	unsigned int section;
> + 	unsigned int node;
>  	unsigned int flags;
>  	struct sgx_encl_page *owner;
>  	struct list_head list;
> 	struct list_head numa_list;
>  };
> 
> and go from page->node directly.

OK, I buy this, thanks.

> >>>  	page = list_first_entry(&sgx_free_page_list, struct sgx_epc_page, list);
> >>> +	list_del_init(&page->numa_list);
> >>>  	list_del_init(&page->list);
> >>>  	sgx_nr_free_pages--;
> >>
> >> I would much rather prefer that this does what the real page allocator
> >> does: kep the page on a single list.  That list is maintained
> >> per-NUMA-node.  Allocations try local NUMA node structures, then fall
> >> back to other structures (hopefully in a locality-aware fashion).
> >>
> >> I wrote you the loop that I want to see this implement in an earlier
> >> review.  This, basically:
> >>
> >> 	page = NULL;
> >> 	nid = numa_node_id();
> >> 	while (true) {
> >> 		page = __sgx_alloc_epc_page_from_node(nid);	
> >> 		if (page)
> >> 			break;
> >>
> >> 		nid = // ... some search here, next_node_in()...
> >> 		// check if we wrapped around:
> >> 		if (nid == numa_node_id())
> >> 			break;
> >> 	}
> >>
> >> There's no global list.  You just walk around nodes trying to find one
> >> with space.  If you wrap around, you stop.
> >>
> >> Please implement this.  If you think it's a bad idea, or can't, let's
> >> talk about it in advance.  Right now, it appears that my review comments
> >> aren't being incorporated into newer versions.
> > 
> > How I interpreted your earlier comments is that the fallback is unfair and
> > this patch set version does fix that. 
> > 
> > I can buy the above allocation scheme, but I don't think this patch set
> > version is a step backwards. The things done to struct sgx_epc_section
> > are exactly what should be done to it.
> 
> To me, it's a step backwards.  It regresses in that it falls back to an
> entirely non-NUMA aware allocation mechanism.  The global list is
> actually likely to be even worse than the per-section searches because
> it has a global lock as opposed to the at per-section locks.  It also
> has the overhead of managing two lists instead of one.
> 
> So, yes, it is *fair* in terms of NUMA node pressure.  But being fair in
> a NUMA-aware allocator by simply not doing NUMA at all is a regression.

The code is structured now in a way that is trivial to remove the global
list and move on to just node lists. I.e. nasty section lists have been
wiped away. Refactoring global list out is a trivial step.  

That way this is a step forwards, even if having a global list would
be step backwards:-)

> > Implementation-wise you are asking me to squash 4/5 and 5/5 into a single
> > patch, and remove global list. It's a tiny iteration from this patch
> > version and I can do it.
> 
> Sounds good.

I'll dissolve your feedback and come with the new version, which I'll
put out tomorrow.

PS. If you don't here of me after you have given feedback to the next
version, please ping privately. It looks like things are getting through
again fast but better be sure than sorry...

/Jarkko
