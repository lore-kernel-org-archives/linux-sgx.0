Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21375C4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 19:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE60207BC
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 19:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgJETVe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 15:21:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:58919 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgJETVd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 15:21:33 -0400
IronPort-SDR: OU2Cltemb6meryAzUaw6367XonTEC5gdxTWAw25q0tWabCgX4d1Jryyw9AlarM7drbcrRx5pBG
 3o3x6DELP5ug==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="228007461"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="228007461"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 12:12:55 -0700
IronPort-SDR: XazBjcgRw8zTNuOCn2KN1FdYcATpJZqIOGgvXwj1bHQB7XSHrENXIERlalgnu/2QR6Eje/KyzA
 16ERkSNu3xiw==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="526523050"
Received: from unknown (HELO localhost) ([10.249.32.156])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 10:41:37 -0700
Date:   Mon, 5 Oct 2020 20:41:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3] x86/sgx: Fix sgx_encl_may_map locking
Message-ID: <20201005174108.GA13602@linux.intel.com>
References: <20201005141119.5395-1-jarkko.sakkinen@linux.intel.com>
 <20201005155519.GB11938@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005155519.GB11938@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 08:55:19AM -0700, Sean Christopherson wrote:
> On Mon, Oct 05, 2020 at 05:11:19PM +0300, Jarkko Sakkinen wrote:
> > @@ -317,11 +319,30 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> >  	if (current->personality & READ_IMPLIES_EXEC)
> >  		return -EACCES;
> >  
> > -	xas_for_each(&xas, page, idx_end)
> > -		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> > -			return -EACCES;
> > +	/*
> > +	 * No need to hold encl->lock:
> > +	 * 1. None of the page->* get written.
> > +	 * 2. page->vm_max_prot_bits is set in sgx_encl_page_alloc(). This
> > +	 *    is before calling xa_insert(). After that it is never modified.
> > +	 */
> 
> You forgot to cover racing with insertion, e.g. below is the snippet from my
> original patch[*], which did the lookup without protection from encl->lock.`
> 
> +		/*
> +		 * No need to take encl->lock, vm_prot_bits is set prior to
> +		 * insertion and never changes, and racing with adding pages is
> +		 * a userspace bug.
> +		 */
> +		rcu_read_lock();
> +		page = radix_tree_lookup(&encl->page_tree, idx);
> +		rcu_read_unlock();
> 
> 
> [*]https://patchwork.kernel.org/patch/11005431/

I'm not sure why that was merged as it was but it probably was not
because of that snippet. It had encl->lock before, so it was by all
practical means covered then. I would have replaced encl->lock with that
if I ever had received a patch with just that, i.e. that particular
snippet gone to noise. That's why it was not broken before v36.

/Jarkko
