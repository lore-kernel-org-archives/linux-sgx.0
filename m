Return-Path: <SRS0=0h1F=EM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9D8C388F2
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 16:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6353C20720
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 16:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604681479;
	bh=IEal4DM6g9pzay8voUAwBH9HgqP88t6Jh9pbcjBimdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sW1CYn4uLeUpQOizM1POycvsC1upHZ7qXXNQ7N9jPnHpQ1rA5bF5FqS3vnKSiXgAm
	 MT8WCrdgXaLmshxSm1dJ5odm8UidGqYXmqTCkFGLI6BSFt+vgSZhlMxn0woUf/4dlI
	 3TzNNEJH1G1QRneQQc6s54bkpu6KpGV1Nx8FHGnU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgKFQvT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Nov 2020 11:51:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbgKFQvS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Nov 2020 11:51:18 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F7402151B;
        Fri,  6 Nov 2020 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604681477;
        bh=IEal4DM6g9pzay8voUAwBH9HgqP88t6Jh9pbcjBimdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DwqQohcJEgkBnM4uO/7BgnvX7ReasVA1yAl5vhjUy3mNbwNHBF8antXZ217mpTy5u
         wVc4b1yMgJhu92+vURdJa+GNLEfQ2FuU9leamNT//DOpLvKHBIIaRpxw4GN4LcIQ3u
         C9O+8rJcGVBsxuJ5uk+vJR91YWsWwA455jOVTwNo=
Date:   Fri, 6 Nov 2020 18:51:07 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com,
        Michal Hocko <mhocko@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v40 10/24] mm: Add 'mprotect' hook to struct
 vm_operations_struct
Message-ID: <20201106165107.GA52595@kernel.org>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com>
 <20201106100409.GD3371@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106100409.GD3371@techsingularity.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 06, 2020 at 10:04:09AM +0000, Mel Gorman wrote:
> On Wed, Nov 04, 2020 at 04:54:16PM +0200, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Background
> > ==========
> > 
> > 1. SGX enclave pages are populated with data by copying from normal memory
> >    via ioctl() (SGX_IOC_ENCLAVE_ADD_PAGES), which will be added later in
> >    this series.
> > 2. It is desirable to be able to restrict those normal memory data sources.
> >    For instance, to ensure that the source data is executable before
> >    copying data to an executable enclave page.
> > 3. Enclave page permissions are dynamic (just like normal permissions) and
> >    can be adjusted at runtime with mprotect().
> > 
> > This creates a problem because the original data source may have long since
> > vanished at the time when enclave page permissions are established (mmap()
> > or mprotect()).
> > 
> > The solution (elsewhere in this series) is to force enclaves creators to
> > declare their paging permission *intent* up front to the ioctl().  This
> > intent can me immediately compared to the source data???s mapping and
> > rejected if necessary.
> > 
> > The ???intent??? is also stashed off for later comparison with enclave
> > PTEs. This ensures that any future mmap()/mprotect() operations
> > performed by the enclave creator or done on behalf of the enclave
> > can be compared with the earlier declared permissions.
> > 
> > Problem
> > =======
> > 
> > There is an existing mmap() hook which allows SGX to perform this
> > permission comparison at mmap() time.  However, there is no corresponding
> > ->mprotect() hook.
> > 
> > Solution
> > ========
> > 
> > Add a vm_ops->mprotect() hook so that mprotect() operations which are
> > inconsistent with any page's stashed intent can be rejected by the driver.
> > 
> 
> I have not read the series so this is superficial only. That said...
> 
> > Cc: linux-mm@kvack.org
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Acked-by: Jethro Beekman <jethro@fortanix.com>
> > Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  include/linux/mm.h | 3 +++
> >  mm/mprotect.c      | 5 ++++-
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index ef360fe70aaf..eb38eabc5039 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -559,6 +559,9 @@ struct vm_operations_struct {
> >  	void (*close)(struct vm_area_struct * area);
> >  	int (*split)(struct vm_area_struct * area, unsigned long addr);
> >  	int (*mremap)(struct vm_area_struct * area);
> > +	int (*mprotect)(struct vm_area_struct *vma,
> > +			struct vm_area_struct **pprev, unsigned long start,
> > +			unsigned long end, unsigned long newflags);
> 
> The first user of this uses the following information
> 
> 	ret = sgx_encl_may_map(vma->vm_private_data, start, end, newflags);
> 
> It only needs start, end and newflags. The pprev is passed in so the
> hook can call mprotect_fixup() which is redundant as the caller knows it
> should do that. I don't think an arbitrary driver should be responsible
> for poking too much into the mm internals to do the fixup because we do
> not know what other users of this hook might require in the future.
> 
> Hence, I would suggest that the hook receive the minimum possible
> information to do the permissions check for the first in-tree user. If
> it returns without failure then mm/mprotect.c would always do the fixup.
> 
> >  	vm_fault_t (*fault)(struct vm_fault *vmf);
> >  	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
> >  			enum page_entry_size pe_size);
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 56c02beb6041..1fd4fa71ce16 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -616,7 +616,10 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> >  		tmp = vma->vm_end;
> >  		if (tmp > end)
> >  			tmp = end;
> > -		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
> > +		if (vma->vm_ops && vma->vm_ops->mprotect)
> > +			error = vma->vm_ops->mprotect(vma, &prev, nstart, tmp, newflags);
> > +		else
> > +			error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
> 
> That would then become
> 
> if (vma->vm_ops && vma->vm_ops->mprotect)
> 	error = vma->vm_ops->mprotect(vma, &prev, nstart, tmp, newflags);
> if (!error)
> 	error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
> 
> and mprotect_fixup would be removed from the driver.
> 
> While vm_operations_struct has borderline zero documentation, a hook for
> one in-kernel user should have a comment explaining what the semantics
> of the hook is -- what is it responsible for (permission check), what
> can it change (nothing), etc. Maybe something like
> 
> 	/*
> 	 * Called by mprotect in the event driver-specific permission
> 	 * checks need to be made before the mprotect is finalised.
> 	 * No modifications should be done to the VMA, returns 0
> 	 * if the mprotect is permitted.
> 	 */
> 	int (*mprotect)(struct vm_area_struct *vma,
> 		unsigned long start, unsigned long end,
> 		unsigned long newflags);
> 
> If a future driver *does* need to poke deeper into the VM for mprotect
> then at least they'll have to explain why that's a good idea.

Both comments make sense to me. I'll refine this patch on Monday and
also "x86/sgx: Add SGX misc driver interface", which uses this callback.

Thanks a lot for valuable feedback!

> -- 
> Mel Gorman
> SUSE Labs

/Jarkko
