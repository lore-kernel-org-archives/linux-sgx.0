Return-Path: <SRS0=pKip=DL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D463C4363C
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Oct 2020 22:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22599206DD
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Oct 2020 22:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgJDWDL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 18:03:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:14889 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgJDWDL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 18:03:11 -0400
IronPort-SDR: LEJGndDXX/lEU9pKKg6ddc5ARSGn9F0BOWh6xaYQiU/EIEiPT49fQ2t0G3jMbW6jNyObYr6lxs
 httzdUELN24w==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="227444558"
X-IronPort-AV: E=Sophos;i="5.77,336,1596524400"; 
   d="scan'208";a="227444558"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 15:03:10 -0700
IronPort-SDR: D8WaEYIYc3W8ZM2k34p1YdK1bF/oWqAJliXPiHexrXnNuPFTPIHAGqmyfqm2ztQtLxq5Y4VJ0M
 ZUL7HbGi78ow==
X-IronPort-AV: E=Sophos;i="5.77,336,1596524400"; 
   d="scan'208";a="459240377"
Received: from avahldie-mobl.amr.corp.intel.com (HELO localhost) ([10.249.32.74])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 15:03:02 -0700
Date:   Mon, 5 Oct 2020 01:02:59 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201004220259.GB43926@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003195440.GD20115@casper.infradead.org>
 <20201004215049.GA43926@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004215049.GA43926@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 12:51:00AM +0300, Jarkko Sakkinen wrote:
> On Sat, Oct 03, 2020 at 08:54:40PM +0100, Matthew Wilcox wrote:
> > On Sat, Oct 03, 2020 at 07:50:46AM +0300, Jarkko Sakkinen wrote:
> > > +	XA_STATE(xas, &encl->page_array, idx_start);
> > > +
> > > +	/*
> > > +	 * Disallow READ_IMPLIES_EXEC tasks as their VMA permissions might
> > > +	 * conflict with the enclave page permissions.
> > > +	 */
> > > +	if (current->personality & READ_IMPLIES_EXEC)
> > > +		return -EACCES;
> > > +
> > > +	xas_for_each(&xas, page, idx_end)
> > > +		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> > > +			return -EACCES;
> > 
> > You're iterating the array without holding any lock that the XArray knows
> > about.  If you're OK with another thread adding/removing pages behind your
> > back, or there's a higher level lock (the mmap_sem?) protecting the XArray
> > from being modified while you walk it, then hold the rcu_read_lock()
> > while walking the array.  Otherwise you can prevent modification by
> > calling xas_lock(&xas) and xas_unlock()..
> 
> I backtracked this. The locks have been there from v21-v35. This is a
> refactoring mistake in radix_tree to xarray migration happened in v36.
> It's by no means intentional.
> 
> What is shoukd take is encl->lock.
> 
> The loop was pre-v36 like:
> 
> 	idx_start = PFN_DOWN(start);
> 	idx_end = PFN_DOWN(end - 1);
> 
> 	for (idx = idx_start; idx <= idx_end; ++idx) {
> 		mutex_lock(&encl->lock);
> 		page = radix_tree_lookup(&encl->page_tree, idx);
> 		mutex_unlock(&encl->lock);
> 
> 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> 			return -EACCES;
> 	}
> 
> Looking at xarray.h and filemap.c, I'm thinking something along the
> lines of:
> 
> 	for (idx = idx_start; idx <= idx_end; ++idx) {
> 		mutex_lock(&encl->lock);
> 		page = xas_find(&xas, idx + 1);
                                      ~~~~~~~
				      idx

> 		mutex_unlock(&encl->lock);
> 
> 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> 			return -EACCES;
> 	}
> 
> Does this look about right?

/Jarkko
