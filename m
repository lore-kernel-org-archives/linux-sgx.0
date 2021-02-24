Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE16C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Feb 2021 17:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA9B264F13
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Feb 2021 17:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhBXRas (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Feb 2021 12:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhBXRar (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Feb 2021 12:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3328C64EDB;
        Wed, 24 Feb 2021 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614187806;
        bh=3f1JPeP2WveFctyK2JC6+FfYW964gGhcHeqIX6mttLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fr/oMZagr9ei7bNSVzuJIQA2T063jTGFnm0FT0R2pYSU1ucY+7x/aY2+T1Lm4ymUU
         24m3P88slWXXRlz6lNu5sCaQoqHuAbCjbv2mlcyvS9ag4PXr4NXzC/YMpC7Jezh98R
         9Kse4+ECzv8iOKKy0fVt95UeHpQQ9N6cAY46HoAJvXEK2GxywJ0PANDw4hlSX6/Ev2
         RWdMLBso8IWgKR956rqYlEghh02nh3gao8JyH5nxGRfL6E4Z5PEirbS/vDGsbvtdGV
         srUuLUvsyvhc4eG2y8WnuoJ3WhY27XL72h3AqXjedKWmMdhNRx5eMpHt7rPc9I2Xqy
         ULUgVAn40+jvQ==
Date:   Wed, 24 Feb 2021 19:29:49 +0200
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
Message-ID: <YDaNDcJvnAen0wZn@kernel.org>
References: <20210221020631.171404-1-jarkko@kernel.org>
 <7acc3c1c-373e-cfee-e838-2af170e87d98@intel.com>
 <3b3391bc-8c40-cf08-d09d-90ff1517ff8c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b3391bc-8c40-cf08-d09d-90ff1517ff8c@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 23, 2021 at 11:14:10AM -0800, Dave Hansen wrote:
> On 2/21/21 4:54 PM, Dave Hansen wrote:
> > Instead of having a for-each-section loop, I'd make it for-each-node ->
> > for-each-section.  Something like:
> > 
> > 	for (i = 0; i < num_possible_nodes(); i++) {
> > 		node = (numa_node_id() + i) % num_possible_nodes()
> > 		
> > 		if (!node_isset(nid, sgx_numa_mask))
> > 			continue;
> > 
> > 		list_for_each_entry(section, &sgx_numa_nodes[nid],
> > 				    section_list) {
> > 			__sgx_alloc_epc_page_from_section(section)
> > 		}
> > 	}
> 
> OK, here's an almost completely fleshed-out loop:
> 
> 	page = NULL;
> 	node = numa_node_id();
> 	start_node = node;
> 	while (1) {
> 		list_for_each_entry(section, &sgx_numa_nodes[nid],
>  				    section_list) {
>  			page = __sgx_alloc_epc(section);
> 			if (page)
> 				break;
>  		}
> 		if (page)
> 			break;
> 		
> 		/*
> 		 * EPC allocation failed on 'node'.  Fall
> 		 * back with round-robin to other nodes with
> 		 * EPC:
> 		 */
> 		node = next_node_in(node, sgx_numa_mask);
> 
> 		/* Give up if allocation wraps back to the start: */
> 		if (node == start_node)
> 			break;
> 	}
> 
> This will:
> 1. Always start close to the CPU that started the allocation
> 2. Always spread the allocations out among nodes evenly, never
>    concentrating allocations on node 0, for instance.  (This could also
>    be node_random() and get a similar effect, but this probably has
>    slightly better default NUMA behavior).
> 3. Efficiently look among all nodes because of 'sgx_numa_mask'
> 4. Have no special case for the first allocation.  All allocations will
>    be satisfied from this unified loop.
> 5. Compile down to no loop on CONFIG_NUMA=y systems.
> 6. Be guaranteed to make forward progress even if preempted and
>    numa_node_id() changes in the loop.
> 
> BTW, I think the name of __sgx_alloc_epc_page_from_section() can be
> shortened down.  It's passed a section and returns a page, so both of
> those could be removed from the name.

I would start with what I have with minimal changes, and then continue
with a patch that completely wipes the section list.

Then fallback can just take a page from a flat FIFO of EPC pages.

/Jarkko
