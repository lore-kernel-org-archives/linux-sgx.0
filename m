Return-Path: <SRS0=iPl9=4W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB8AC3F2D2
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 19:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B6C2072A
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 19:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgCETEH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 5 Mar 2020 14:04:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:53080 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgCETEG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 5 Mar 2020 14:04:06 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 11:03:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,519,1574150400"; 
   d="scan'208";a="413622077"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 11:03:54 -0800
Date:   Thu, 5 Mar 2020 11:03:54 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-mm@kvack.org, Ismo Puustinen <ismo.puustinen@intel.com>,
        Mark Shanahan <mark.shanahan@intel.com>,
        Mikko Ylinen <mikko.ylinen@intel.com>,
        Derek Bombien <derek.bombien@intel.com>
Subject: Re: [PATCH v28 16/22] x86/sgx: Add a page reclaimer
Message-ID: <20200305190354.GK11500@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-17-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303233609.713348-17-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

+cc some more Intel people

On Wed, Mar 04, 2020 at 01:36:03AM +0200, Jarkko Sakkinen wrote:
> +static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
> +					      pgoff_t index)
> +{
> +	struct inode *inode = encl->backing->f_path.dentry->d_inode;
> +	struct address_space *mapping = inode->i_mapping;
> +	gfp_t gfpmask = mapping_gfp_mask(mapping);

Question for folks that care about cgroup accounting: should the shmem page
allocation be accounted, even though it'll charge the "wrong" task?  E.g.

	gfp_t gfpmask = mapping_gfp_mask(mapping) | __GFP_ACCOUNT;


Background details...

To reclaim an EPC page, the encrypted data must be written to addressable
memory when the page is evicted from the EPC.  I.e. RAM or persistent
memory acts as swap space for the EPC.  In the SGX code this is referred to
as the "backing store" or just "backing".

As implemented, the backing for EPC reclaim is not pre-allocated.  I don't
think anyone would want to change this behavior as it would eat regular
memory even if EPC isn't oversubscribed.

But, as implemented it's not accounted.  The reason we haven't explicitly
forced accounting is because allocations for the backing would be charged
to the task doing the evicting, as opposed to the task that originally
allocated the EPC page.  This means that task 'A' can do a DOS of sorts on
task 'B' by allocating a large amount of EPC with the goal of causing 'B'
to trigger (normal memory) OOM and get killed.

AFAICT, that's still preferable to not accounting at all, e.g. at least 'B'
would need to be allocating a decent amount of EPC as well to trigger OOM,
as opposed to today where the allocations are completely unaccounted and so
cause a more global OOM.

We've also discussed taking a file descriptor to hold the backing, but
unless I'm misreading the pagecache code, that doesn't solve the incorrect
accounting problem because the current task, i.e. evicting task, would be
charged.  In other words, whether the backing is kernel or user controlled
is purely an ABI question.

In theory, SGX could do some form of manual memcg accounting in
sgx_encl_get_backing_page(), but that gets ridiculously ugly, if it's even
possible, e.g. determining whether or not the page was already allocated
would be a nightmare.


Long term, I think this can be solved, or at least mitigated, by adding
a "backing" limit to the EPC cgroup (which obviously doesn't exist in yet)
to allow limiting the amount of memory that can be indirectly consumed by
creating a large enclave.  E.g. account each page during ENCLAVE_ADD_PAGES,
with some logic to transfer the charges when a mm_struct is disassociated
from an enclave (which will probably be needed for the base EPC cgroup
anyways).

> +
> +	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
> +}
> +
> +/**
> + * sgx_encl_get_backing() - Pin the backing storage
> + * @encl:	an enclave
> + * @page_index:	enclave page index
> + * @backing:	data for accessing backing storage for the page
> + *
> + * Pin the backing storage pages for storing the encrypted contents and Paging
> + * Crypto MetaData (PCMD) of an enclave page.
> + *
> + * Return:
> + *   0 on success,
> + *   -errno otherwise.
> + */
> +int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
> +			 struct sgx_backing *backing)
> +{
> +	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> +	struct page *contents;
> +	struct page *pcmd;
> +
> +	contents = sgx_encl_get_backing_page(encl, page_index);
> +	if (IS_ERR(contents))
> +		return PTR_ERR(contents);
> +
> +	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
> +	if (IS_ERR(pcmd)) {
> +		put_page(contents);
> +		return PTR_ERR(pcmd);
> +	}
> +
> +	backing->page_index = page_index;
> +	backing->contents = contents;
> +	backing->pcmd = pcmd;
> +	backing->pcmd_offset =
> +		(page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
> +		sizeof(struct sgx_pcmd);
> +
> +	return 0;
> +}
> +
> +/**
> + * sgx_encl_put_backing() - Unpin the backing storage
> + * @backing:	data for accessing backing storage for the page
> + * @do_write:	mark pages dirty
> + */
> +void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write)
> +{
> +	if (do_write) {
> +		set_page_dirty(backing->pcmd);
> +		set_page_dirty(backing->contents);
> +	}
> +
> +	put_page(backing->pcmd);
> +	put_page(backing->contents);
> +}
