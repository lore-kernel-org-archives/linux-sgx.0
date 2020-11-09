Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F59C2D0A3
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Nov 2020 20:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8725520789
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Nov 2020 20:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgKIUAK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 Nov 2020 15:00:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:55326 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgKIUAK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 9 Nov 2020 15:00:10 -0500
IronPort-SDR: RQDZgjkAv8QGrAbXyy5hzGYTECJGMj/LeVxcxynjeaR51QvTn9GtRNN+UaR+QcX3wmhL5JNjn2
 5zFwEQmzJbTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="170014910"
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="170014910"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 12:00:09 -0800
IronPort-SDR: j6Yq4JPREaWEvwGl8XZBZoz6hf+DAXQLm/YHazmZyuiiIL/lyiTbBUv9bSsF/3xoV0D7ujnhCQ
 9bxiwWMEc2Zg==
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="540999806"
Received: from mostoegl-mobl1.ger.corp.intel.com (HELO linux.intel.com) ([10.252.49.251])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 12:00:01 -0800
Date:   Mon, 9 Nov 2020 21:59:57 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v40 21/24] x86/sgx: Add a page reclaimer
Message-ID: <20201109195957.GA5544@linux.intel.com>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201108035630.11540-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201108035630.11540-1-hdanton@sina.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Nov 08, 2020 at 11:56:30AM +0800, Hillf Danton wrote:
> On Wed,  4 Nov 2020 16:54:27 Jarkko Sakkinen wrote:
> [...]
> > +/**
> > + * sgx_alloc_epc_page() - Allocate an EPC page
> > + * @owner:	the owner of the EPC page
> > + * @reclaim:	reclaim pages if necessary
> > + *
> > + * Iterate through EPC sections and borrow a free EPC page to the caller. When a
> > + * page is no longer needed it must be released with sgx_free_epc_page(). If
> > + * @reclaim is set to true, directly reclaim pages when we are out of pages. No
> > + * mm's can be locked when @reclaim is set to true.
> > + *
> > + * Finally, wake up ksgxswapd when the number of pages goes below the watermark
> > + * before returning back to the caller.
> > + *
> > + * Return:
> > + *   an EPC page,
> > + *   -errno on error
> > + */
> > +struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
> > +{
> > +	struct sgx_epc_page *entry;
> 
> Nit: s/entry/epc_page/
> > +
> > +	for ( ; ; ) {
> > +		entry = __sgx_alloc_epc_page();
> > +		if (!IS_ERR(entry)) {
> > +			entry->owner = owner;
> > +			break;
> > +		}
> > +
> > +		if (list_empty(&sgx_active_page_list))
> > +			return ERR_PTR(-ENOMEM);
> > +
> > +		if (!reclaim) {
> > +			entry = ERR_PTR(-EBUSY);
> > +			break;
> > +		}
> > +
> > +		if (signal_pending(current)) {
> > +			entry = ERR_PTR(-ERESTARTSYS);
> > +			break;
> > +		}
> > +
> > +		sgx_reclaim_pages();
> i
> This is the direct reclaim mode with ksgxswapd that works in
> the background ignored in the entire for loop. But we can go
> with it in parallel, see below, if it tries as hard as it can
> to maitain the watermark in which allocators may have no
> interest.

I think this policy should be left at is and once the code in mainline
further refined. Consider it as a baseline/initial version for
reclaiming code.

> > +		schedule();
> 
> To cut allocator's latency use cond_resched();

Thanks, I'll change this.

> > +	}
> > +
> > +	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
> > +		wake_up(&ksgxswapd_waitq);
> 
> Nit: s/ksgxswapd/sgxd/ as it seems to have nothing to do with swap,
> given sgx itself is clear and good enough.

Yeah, it also handling kexec() situation, i.e. has multitude of
functions.

> > +
> > +	return entry;
> > +}
> 
> struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
> {
> 	struct sgx_epc_page *epc_page;
> 
> 	for (;;) {
> 		epc_page = __sgx_alloc_epc_page();
> 
> 		if (!IS_ERR(epc_page)) {
> 			epc_page->owner = owner;
> 			return epc_page;
> 		}
> 
> 		if (signal_pending(current))
> 			return ERR_PTR(-ERESTARTSYS);
> 
> 		if (list_empty(&sgx_active_page_list) || !reclaim)
> 			return ERR_PTR(-ENOMEM);
> 
> 		wake_up(&ksgxswapd_waitq);
> 		cond_resched();
> 	}
> 	return ERR_PTR(-ENOMEM);
> }

/Jarkko
