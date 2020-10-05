Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BCCC4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 19:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58976207BC
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 19:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgJETQZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 15:16:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:15824 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgJETQY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 15:16:24 -0400
IronPort-SDR: y9BJbTCekPStIt6Dk6WKWqH9ElvbC6YMZ8+Emo9bVNIeH/PqE9pHglCZ3kMrZ4e94WFjMlkqXl
 nkxUvwBI+nlA==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="143792343"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="143792343"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP; 05 Oct 2020 12:09:42 -0700
IronPort-SDR: NMqX0usbP8x0tMrdflWsZ80YWWl1KHhEPo9RzcmUydXasUi/cxhJZ9VdqlZEeznm/sexa43uNk
 15vZYQJf0eYg==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="526502736"
Received: from unknown (HELO localhost) ([10.249.32.156])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 10:25:31 -0700
Date:   Mon, 5 Oct 2020 20:25:14 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3] x86/sgx: Fix sgx_encl_may_map locking
Message-ID: <20201005172514.GA12358@linux.intel.com>
References: <20201005141119.5395-1-jarkko.sakkinen@linux.intel.com>
 <20201005141254.GL20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005141254.GL20115@casper.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 03:12:54PM +0100, Matthew Wilcox wrote:
> On Mon, Oct 05, 2020 at 05:11:19PM +0300, Jarkko Sakkinen wrote:
> > Fix the issue further discussed in:
> 
> No, this is still utter crap.  Just use the version I sent.

OK, just a quick recap to fully understand it.

Here's your response from the original thread:

https://lore.kernel.org/linux-sgx/20201005013053.GJ20115@casper.infradead.org/

And here's your snippet from v2:

https://lore.kernel.org/linux-sgx/20201005111139.GK20115@casper.infradead.org/

This is what confused me.

Compared to (v3) patch and your version, the differences I spot are:

A. 'count' is checked first.
B. Both this and the snippet from the original thread (i.e.
   page-writeback.c) use the same loop construct.

Right, and snippet from page-writeback.c is not compatible with this
because looking at documentation xas_find() continued with
xas_next_entry() sequence will jump through the existing entries and
skip the holes? On the other hand, xas_next() does not.

Of the A part I'm not sure how the order there semantically matter.

/Jarkko
