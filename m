Return-Path: <SRS0=0h1F=EM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FA9C2D0A3
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 10:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F86221FA
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 10:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgKFKMj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Nov 2020 05:12:39 -0500
Received: from outbound-smtp10.blacknight.com ([46.22.139.15]:38885 "EHLO
        outbound-smtp10.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726913AbgKFKMi (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 6 Nov 2020 05:12:38 -0500
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2020 05:12:37 EST
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp10.blacknight.com (Postfix) with ESMTPS id A27861C4AF0
        for <linux-sgx@vger.kernel.org>; Fri,  6 Nov 2020 10:04:11 +0000 (GMT)
Received: (qmail 14879 invoked from network); 6 Nov 2020 10:04:11 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 6 Nov 2020 10:04:11 -0000
Date:   Fri, 6 Nov 2020 10:04:09 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
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
Message-ID: <20201106100409.GD3371@techsingularity.net>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 04, 2020 at 04:54:16PM +0200, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Background
> ==========
> 
> 1. SGX enclave pages are populated with data by copying from normal memory
>    via ioctl() (SGX_IOC_ENCLAVE_ADD_PAGES), which will be added later in
>    this series.
> 2. It is desirable to be able to restrict those normal memory data sources.
>    For instance, to ensure that the source data is executable before
>    copying data to an executable enclave page.
> 3. Enclave page permissions are dynamic (just like normal permissions) and
>    can be adjusted at runtime with mprotect().
> 
> This creates a problem because the original data source may have long since
> vanished at the time when enclave page permissions are established (mmap()
> or mprotect()).
> 
> The solution (elsewhere in this series) is to force enclaves creators to
> declare their paging permission *intent* up front to the ioctl().  This
> intent can me immediately compared to the source data???s mapping and
> rejected if necessary.
> 
> The ???intent??? is also stashed off for later comparison with enclave
> PTEs. This ensures that any future mmap()/mprotect() operations
> performed by the enclave creator or done on behalf of the enclave
> can be compared with the earlier declared permissions.
> 
> Problem
> =======
> 
> There is an existing mmap() hook which allows SGX to perform this
> permission comparison at mmap() time.  However, there is no corresponding
> ->mprotect() hook.
> 
> Solution
> ========
> 
> Add a vm_ops->mprotect() hook so that mprotect() operations which are
> inconsistent with any page's stashed intent can be rejected by the driver.
> 

I have not read the series so this is superficial only. That said...

> Cc: linux-mm@kvack.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  include/linux/mm.h | 3 +++
>  mm/mprotect.c      | 5 ++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ef360fe70aaf..eb38eabc5039 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -559,6 +559,9 @@ struct vm_operations_struct {
>  	void (*close)(struct vm_area_struct * area);
>  	int (*split)(struct vm_area_struct * area, unsigned long addr);
>  	int (*mremap)(struct vm_area_struct * area);
> +	int (*mprotect)(struct vm_area_struct *vma,
> +			struct vm_area_struct **pprev, unsigned long start,
> +			unsigned long end, unsigned long newflags);

The first user of this uses the following information

	ret = sgx_encl_may_map(vma->vm_private_data, start, end, newflags);

It only needs start, end and newflags. The pprev is passed in so the
hook can call mprotect_fixup() which is redundant as the caller knows it
should do that. I don't think an arbitrary driver should be responsible
for poking too much into the mm internals to do the fixup because we do
not know what other users of this hook might require in the future.

Hence, I would suggest that the hook receive the minimum possible
information to do the permissions check for the first in-tree user. If
it returns without failure then mm/mprotect.c would always do the fixup.

>  	vm_fault_t (*fault)(struct vm_fault *vmf);
>  	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
>  			enum page_entry_size pe_size);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 56c02beb6041..1fd4fa71ce16 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -616,7 +616,10 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>  		tmp = vma->vm_end;
>  		if (tmp > end)
>  			tmp = end;
> -		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
> +		if (vma->vm_ops && vma->vm_ops->mprotect)
> +			error = vma->vm_ops->mprotect(vma, &prev, nstart, tmp, newflags);
> +		else
> +			error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);

That would then become

if (vma->vm_ops && vma->vm_ops->mprotect)
	error = vma->vm_ops->mprotect(vma, &prev, nstart, tmp, newflags);
if (!error)
	error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);

and mprotect_fixup would be removed from the driver.

While vm_operations_struct has borderline zero documentation, a hook for
one in-kernel user should have a comment explaining what the semantics
of the hook is -- what is it responsible for (permission check), what
can it change (nothing), etc. Maybe something like

	/*
	 * Called by mprotect in the event driver-specific permission
	 * checks need to be made before the mprotect is finalised.
	 * No modifications should be done to the VMA, returns 0
	 * if the mprotect is permitted.
	 */
	int (*mprotect)(struct vm_area_struct *vma,
		unsigned long start, unsigned long end,
		unsigned long newflags);

If a future driver *does* need to poke deeper into the VM for mprotect
then at least they'll have to explain why that's a good idea.

-- 
Mel Gorman
SUSE Labs
