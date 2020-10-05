Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CEBC4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 23:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AB46206C3
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 23:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgJEX6V (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 19:58:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:30024 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgJEX6U (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 19:58:20 -0400
IronPort-SDR: tey6P1C744ktrTtMyTB95YcRfnW90Il23Bepjwjbr2Z0yaiirexk5t8GJ+c2VzdyrB4IAK9CUX
 UuKwM3lQGERA==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="143616613"
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="143616613"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP; 05 Oct 2020 16:44:40 -0700
IronPort-SDR: 6XIWHQ8Zb73082phqJxD2hJUoM4EU+4ZNsYBP4N9IKTinYFWgDY8JGXnk8f4AHpjt++cIj4VRA
 Yb+FKbDmXmWg==
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="517478119"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 15:56:53 -0700
Date:   Mon, 5 Oct 2020 15:56:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: Unable to load large enclave
Message-ID: <20201005225652.GD15803@linux.intel.com>
References: <9393934c-e390-a7df-2e74-08f16d4f48d4@fortanix.com>
 <20200930011650.GA808399@linux.intel.com>
 <81e38a1b-c9a7-209e-76f5-e2c91f49c1e3@fortanix.com>
 <20200930114554.GA7612@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930114554.GA7612@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 30, 2020 at 02:45:54PM +0300, Jarkko Sakkinen wrote:
> On Wed, Sep 30, 2020 at 09:12:06AM +0200, Jethro Beekman wrote:
> > On 2020-09-30 03:16, Jarkko Sakkinen wrote:
> > > On Tue, Sep 29, 2020 at 05:52:48PM +0200, Jethro Beekman wrote:
> > >> Since the latest API changes, I'm unable to load a large enclave. The
> > >> test program at
> > >> https://github.com/fortanix/rust-sgx/blob/sgx-load-large-enclave-test/src/main.rs
> > >> always fails with ENOMEM after loading 0xffd6 pages.
> > >>
> > >> I've tested this with v36, if there's reason to believe it has been
> > >> fixed I'd be happy to try it out on a newer patch set.
> > > 
> > > I recommend using v39-rc1 tag that I created for testing because API is
> > > reverted back to be compatible with v36.
> > 
> > Not sure what you're saying. I tested with v36. You're saying v39-rc1
> > will be the same? Or did you fix the issue since v36?
> 
> v37 and v38 has an API change that is reverted in v39:
> 
> https://lore.kernel.org/linux-sgx/20200921195822.GA58176@linux.intel.com/
> 
> I'm not sure of the root cause yet but you asked to try to out a newer
> patch set and v39-rc1 is the best option.
> 
> There was off-by-one error in enclave maximum size calculation fixed in
> v37 (it was actually a bug in SDM inherited to the code) but that should
> not result the situation you just described.

My money is on the XArray changes, that's the most notable change in v36 and
IIRC the only thing that touched EPC/memory management.
