Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA014C4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 11:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 783C920774
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 11:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJELtF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 07:49:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:21213 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgJELtF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 07:49:05 -0400
IronPort-SDR: 9WKKKvnNuSY4hMnpprZoSB/LD4Jra0agc58M7AfiSj9ZrfcnNHnLj1nQA5JDPUPrUhXCV2SGPn
 kPpuL8K2FPhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="143378437"
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="143378437"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 04:49:04 -0700
IronPort-SDR: yfaR+EmfCx23VQ10lc5eQeF6w2OEudD+wZcAciT2ExuDROZTxJyqbLxT3qXVMX+UWiUwSLMcQ7
 X3RCMUnxR+og==
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="525256010"
Received: from bclindho-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.32.27])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 04:48:58 -0700
Date:   Mon, 5 Oct 2020 14:48:55 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] Fix the issue further discussed in:
Message-ID: <20201005114855.GD181338@linux.intel.com>
References: <20201005031759.143544-1-jarkko.sakkinen@linux.intel.com>
 <20201005111139.GK20115@casper.infradead.org>
 <20201005114802.GC181338@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005114802.GC181338@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 02:48:07PM +0300, Jarkko Sakkinen wrote:
> On Mon, Oct 05, 2020 at 12:11:39PM +0100, Matthew Wilcox wrote:
> > On Mon, Oct 05, 2020 at 06:17:59AM +0300, Jarkko Sakkinen wrote:
> > > @@ -317,10 +318,31 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> > >  	if (current->personality & READ_IMPLIES_EXEC)
> > >  		return -EACCES;
> > >  
> > > -	xas_for_each(&xas, page, idx_end)
> > > +	/*
> > > +	 * No need to hold encl->lock:
> > > +	 * 1. None of the page->* get written.
> > > +	 * 2. page->vm_max_prot_bits is set in sgx_encl_page_alloc(). This
> > > +	 *    is before calling xa_insert(). After that it is never modified.
> > > +	 */
> > > +	xas_lock(&xas);
> > > +	xas_for_each(&xas, page, idx_end) {
> > > +		if (++count % XA_CHECK_SCHED)
> > > +			continue;
> > 
> > This really doesn't do what you think it does.
> > 
> > 	int ret = 0;
> > 	int count = 0;
> > 
> > 	xas_lock(&xas);
> > 	while (xas.index < idx_end) {
> > 		struct sgx_page *page = xas_next(&xas);
> > 
> > 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits)) {
> > 			ret = -EACCESS;
> > 			break;
> > 		}
> > 
> > 		if (++count % XA_CHECK_SCHED)
> > 			continue;
> > 		xas_pause(&xas);
> > 		xas_unlock(&xas);
> > 		cond_resched();
> > 		xas_lock(&xas);
> > 	}
> > 	xas_unlock(&xas);
> > 
> > 	return ret;
> 
> No mine certainly does not, it locks up the system if the loop succeeds
> (i.e. does not return -EACCESS) :-) Unfortunately had by mistake the v1
> patch (xa_load()) in the kernel that I used to test.

... and not having xas_unlock() in the end was not intentional.

/Jarkko
