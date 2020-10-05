Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4240C4727D
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 03:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 908032072D
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 03:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgJEDGb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 23:06:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:7648 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgJEDGa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 23:06:30 -0400
IronPort-SDR: k2SRoR5uFlmEoJ86Kk7TgAX/XFvuKuxCu2K6HbE/I+yTsBQmokFl4o0TF+RctFHUQLY6naNm1O
 ej6dEgwbV5Sw==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="150949056"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="150949056"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:06:29 -0700
IronPort-SDR: 5NaMJ8KMuA5SAX+NZz4ygdetZ7eGAwZ6u7txBeQp4rS5Yiye3bU7BjuORBvq4iQfrKatMh8qVf
 78Ud5EQMsiJg==
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="523209843"
Received: from sidorovd-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.48.68])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:06:21 -0700
Date:   Mon, 5 Oct 2020 06:06:19 +0300
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
Message-ID: <20201005030619.GA126283@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003195440.GD20115@casper.infradead.org>
 <20201004215049.GA43926@linux.intel.com>
 <20201004222750.GI20115@casper.infradead.org>
 <20201004234153.GA49415@linux.intel.com>
 <20201005013053.GJ20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005013053.GJ20115@casper.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 02:30:53AM +0100, Matthew Wilcox wrote:
> > In my Geminilake NUC the maximum size of the address space is 64GB for
> > an enclave, and it is not fixed but can grow in microarchitectures
> > beyond that.
> > 
> > That means that in (*artificial*) worst case the locks would be kept for
> > 64*1024*1024*1024/4096 = 16777216 iterations.
> 
> Oh, there's support for that on the XArray API too.
> 
>         xas_lock_irq(&xas);
>         xas_for_each_marked(&xas, page, end, PAGECACHE_TAG_DIRTY) {
>                 xas_set_mark(&xas, PAGECACHE_TAG_TOWRITE);
>                 if (++tagged % XA_CHECK_SCHED)
>                         continue;
> 
>                 xas_pause(&xas);
>                 xas_unlock_irq(&xas);
>                 cond_resched();
>                 xas_lock_irq(&xas);
>         }
>         xas_unlock_irq(&xas);

Assuming we can iterate the array without encl->lock, I think this
would translate to:

/*
 * Not taking encl->lock because:
 * 1. page attributes are not written.
 * 2. the only page attribute read is set before it is put to the array
 *    and stays constant throughout the enclave life-cycle.
 */
xas_lock(&xas);
xas_for_each_marked(&xas, page, idx_end) {
	if (++tagged % XA_CHECK_SCHED)
		continue;

	xas_pause(&xas);
	xas_unlock(&xas);

	/*
	 * Attributes are not protected by the xa_lock, so I'm assuming
	 * that this is the legit place for the check.
	 */
	if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
		return -EACCES;

	cond_resched();
 	xas_lock(&xas);
}
xas_unlock(&xas);

Obviously, we cannot use this pattern by taking the encl->lock inside
the loop (ABBA and encl->lock is a mutex).

Let's enumerate:

A. sgx_encl_add_page(): uses xa_insert() and xa_erase().
B. sgx_encl_load_page(): uses xa_load().
C. sgx_encl_may_map(): is broken (for the moment).

A and B implicitly the lock and if a page exist at all we only access
a pure constant.

Also, since the open file keeps the instance alive, nobody is going
to pull carpet under our feet.

OK, I've just concluded tha we don't need to take encl->lock in this
case. Great.

/Jarkko
