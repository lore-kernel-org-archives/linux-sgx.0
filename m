Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E64C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 14:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99CBC64F4D
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 14:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhCSOv0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Mar 2021 10:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230200AbhCSOvB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Mar 2021 10:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1755164F18;
        Fri, 19 Mar 2021 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616165460;
        bh=wU8iIMBhPxRayggULsJAF1NnzD6BCHvHEMtWCEAXmuU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FMvvJ8TsmoceDzLuu/qx/bVk2KRCFEIHGjYOCGAurogMX1klyZxKbn4/LBj0jCe0T
         khKFITbnSZZkNIZKEvfXAIhfaOHJw4vIqPIt9BN8UYrVtBeVIUUCPx6gIH12UBJGK0
         OqGkwvJ9adBbHmL3moHUn0B7mtUaB5KdBx1RfobhMZYZR23vFeQq88MGb6q0RGMMKg
         pefT7v3TxOe9yDmxTk7CNhujb/ojVHNz7Xyies2Qq+8I4bQXBue9E4ibWk/LULhUfw
         H+ctxGzCtFl6uQ3Bcr2EFVDm4xaaqFe+fALrcX1+tOnIfQf25QCPg6PF5zjSYRWYFY
         PGxI8qWNusylw==
Date:   Fri, 19 Mar 2021 16:50:33 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Avoid returning NULL in __sgx_alloc_epc_page()
Message-ID: <YFS6Of4nnDJR+ZFk@kernel.org>
References: <20210319040602.178558-1-kai.huang@intel.com>
 <20210319084523.GA6251@zn.tnic>
 <20210319220141.8bf20c54fdb06c6f93cde448@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319220141.8bf20c54fdb06c6f93cde448@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 19, 2021 at 10:01:41PM +1300, Kai Huang wrote:
> On Fri, 19 Mar 2021 09:45:23 +0100 Borislav Petkov wrote:
> > On Fri, Mar 19, 2021 at 05:06:02PM +1300, Kai Huang wrote:
> > > Below kernel bug happened when running simple SGX application when EPC
> > > is under pressure.  The root cause is with commit 5b8719504e3a
> > > ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()"),
> > > __sgx_alloc_epc_page() returns NULL when there's no free EPC page can be
> > > allocated, while old behavior was it always returned ERR_PTR(-ENOMEM) in
> > > such case.
> > > 
> > > Fix by directly returning the page if __sgx_alloc_epc_page_from_node()
> > > allocates a valid page in fallback to non-local allocation, and always
> > > returning ERR_PTR(-ENOMEM) if no EPC page can be allocated.
> > > 
> > > [  253.474764] BUG: kernel NULL pointer dereference, address: 0000000000000008
> > > [  253.500101] #PF: supervisor write access in kernel mode
> > > [  253.525462] #PF: error_code(0x0002) - not-present page
> > > ...
> > > [  254.102041] Call Trace:
> > > [  254.126699]  sgx_ioc_enclave_add_pages+0x241/0x770
> > > [  254.151305]  sgx_ioctl+0x194/0x4b0
> > > [  254.174976]  ? handle_mm_fault+0xd0/0x260
> > > [  254.198470]  ? do_user_addr_fault+0x1ef/0x570
> > > [  254.221827]  __x64_sys_ioctl+0x91/0xc0
> > > [  254.244546]  do_syscall_64+0x38/0x90
> > > [  254.266728]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > [  254.289232] RIP: 0033:0x7fdc4cf4031b
> > > ...
> > > [  254.711480] CR2: 0000000000000008
> > > [  254.735494] ---[ end trace 970dce6d4cdf7f64 ]---
> > > [  254.759915] RIP: 0010:sgx_alloc_epc_page+0x46/0x152
> > > ...
> > > 
> > > Fixes: 5b8719504e3a("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/sgx/main.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > I was on the verge whether to merge that into the original patch since
> > it is the top patch on the branch or create a new one but opted for
> > former because this way it won't break bisection and people won't have
> > to pay attention whether there's a fix patch to the NUMA patch too, in
> > case they wanna backport and whatnot.
> 
> Sure.
> 
> [...]
> 
> > +
> > +	/* Fall back to the non-local NUMA nodes: */
> > +	while (true) {
> > +		nid = next_node_in(nid, sgx_numa_mask);
> > +		if (nid == nid_of_current)
> > +			break;
> >  
> > -		page = __sgx_alloc_epc_page_from_section(section);
> > +		page = __sgx_alloc_epc_page_from_node(nid);
> >  		if (page)
> >  			return page;
> >  	}
> 
> It seems "return ERR_PTR(-ENOMEM)" is missing at the bottom of this function?

I understood Boris' comment that the fixes would not be squashed.

/Jarkko
