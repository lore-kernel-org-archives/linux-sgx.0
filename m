Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4C6C4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 19:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A302100A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 19:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgJETLU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 15:11:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:57607 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbgJETLU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 15:11:20 -0400
IronPort-SDR: KYLKGJTYNfeZ+E2cYaJNPTvjARBBeYjTmSrcXGiJoFs5o3CPMDKOrTKFmL+UNpbPGBCgejfJiV
 +CWeMz1q9vkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="143251755"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="143251755"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP; 05 Oct 2020 12:06:09 -0700
IronPort-SDR: CTOgZZh+qWw9I0/XzAolvSThBYJcgYCdQLFWKKpDLCvyOE6bYBw+mVz5NnGTw8OniDxyVhCLeH
 EGbYID3O14iw==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="459863932"
Received: from unknown (HELO localhost) ([10.249.32.156])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 10:36:24 -0700
Date:   Mon, 5 Oct 2020 20:36:21 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3] x86/sgx: Fix sgx_encl_may_map locking
Message-ID: <20201005173621.GA13055@linux.intel.com>
References: <20201005141119.5395-1-jarkko.sakkinen@linux.intel.com>
 <9f1b6d7e-1990-925b-c124-adfef7f2ddfc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f1b6d7e-1990-925b-c124-adfef7f2ddfc@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 07:28:38AM -0700, Dave Hansen wrote:
> On 10/5/20 7:11 AM, Jarkko Sakkinen wrote:
> > +	unsigned long count = 0;
> ...
> > +	xas_lock(&xas);
> > +	xas_for_each(&xas, page, idx_end) {
> > +		if (++count % XA_CHECK_SCHED)
> > +			continue;
> 
> Let's slow down and think through the loop, please.
> 
> First time through the loop, count=0, XA_CHECK_SCHED=4096, it will do a
> ++count, and now count=1.  (count % XA_CHECK_SCHED) == 1.  It will
> continue.  It skips the page->vm_max_prot_bits checks.
> 
> Next time through the loop, count=1, XA_CHECK_SCHED=4096, it will do a
> ++count, and now count=2.  (count % XA_CHECK_SCHED) == 2.  It will
> continue.  It skips the page->vm_max_prot_bits checks.
> 
> ...
> 
> It will do this until it hits count=4095 where it will actually fall
> into the rest of the loop, doing the page->vm_max_prot_bits checks.

Uh oh, how stupid of me.

> So, in the end the loop only does what it's supposed to be doing 1/4096
> times.  Not great.  Don't we have tests that will notice breakage like this?

It would not be hard to have two counts and WARN_ON in the end to
compare for mismatch.

> The XA_CHECK_SCHED needs to be stuck near the *end* of the loop, just
> before the lock dropping and resched stuff.

Referring to Matthew's suggestion:

https://lore.kernel.org/linux-sgx/20201005111139.GK20115@casper.infradead.org/

I think that the order is just right.

It takes the page, does the processing, and in the tail does check
before rescheduling.

The only thing I'd do for clarity would be to change the tail in
that like this:


		/* Move to the next iteration. */
		count++;

		/* Surpassed the modulus, reschedule. */
		if (!(count % XA_CHECK_SCHED)) {
			xas_pause(&xas);
			xas_unlock(&xas);
			cond_resched();
			xas_lock(&xas);
		}
	}

	xas_unlock(&xas);

I think this is just a bit more readable way to express the same
thing. Matthew, can you agree with this small twist?

/Jarkko
