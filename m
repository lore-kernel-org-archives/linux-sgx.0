Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA20C4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 11:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AB3D20757
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 11:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgJELsH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 07:48:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:1200 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgJELsH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 07:48:07 -0400
IronPort-SDR: QSiCNP69hRrtRNQ5kNL5USatSsot+w3ytTvSrZWXDejkEBsFCVMfmJyZkTBTJYn+SMoaCHrS/X
 9T3qT+ctUupA==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="163493946"
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="163493946"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 04:48:06 -0700
IronPort-SDR: N+VVj21Qq6Y/Wo2+uSVAyDAxgwsfHh/hyBz8ztqF2mT7OfkJbidgeJu90kg2n9evW3FEl5h/Fe
 tD9cu1jdxEkw==
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="459465731"
Received: from bclindho-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.32.27])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 04:48:04 -0700
Date:   Mon, 5 Oct 2020 14:48:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] Fix the issue further discussed in:
Message-ID: <20201005114802.GC181338@linux.intel.com>
References: <20201005031759.143544-1-jarkko.sakkinen@linux.intel.com>
 <20201005111139.GK20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005111139.GK20115@casper.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 12:11:39PM +0100, Matthew Wilcox wrote:
> On Mon, Oct 05, 2020 at 06:17:59AM +0300, Jarkko Sakkinen wrote:
> > @@ -317,10 +318,31 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> >  	if (current->personality & READ_IMPLIES_EXEC)
> >  		return -EACCES;
> >  
> > -	xas_for_each(&xas, page, idx_end)
> > +	/*
> > +	 * No need to hold encl->lock:
> > +	 * 1. None of the page->* get written.
> > +	 * 2. page->vm_max_prot_bits is set in sgx_encl_page_alloc(). This
> > +	 *    is before calling xa_insert(). After that it is never modified.
> > +	 */
> > +	xas_lock(&xas);
> > +	xas_for_each(&xas, page, idx_end) {
> > +		if (++count % XA_CHECK_SCHED)
> > +			continue;
> 
> This really doesn't do what you think it does.
> 
> 	int ret = 0;
> 	int count = 0;
> 
> 	xas_lock(&xas);
> 	while (xas.index < idx_end) {
> 		struct sgx_page *page = xas_next(&xas);
> 
> 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits)) {
> 			ret = -EACCESS;
> 			break;
> 		}
> 
> 		if (++count % XA_CHECK_SCHED)
> 			continue;
> 		xas_pause(&xas);
> 		xas_unlock(&xas);
> 		cond_resched();
> 		xas_lock(&xas);
> 	}
> 	xas_unlock(&xas);
> 
> 	return ret;

No mine certainly does not, it locks up the system if the loop succeeds
(i.e. does not return -EACCESS) :-) Unfortunately had by mistake the v1
patch (xa_load()) in the kernel that I used to test.

/Jarkko
