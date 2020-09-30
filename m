Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C504FC4727E
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 11:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9423F20709
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 11:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgI3Lp7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 07:45:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:26244 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729578AbgI3Lp7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 07:45:59 -0400
IronPort-SDR: MBuZ7zYdAhtb5vbYsthr9kE5dJ7o0EDO33gu70Lf4N25qnteOaMz7SdGBTCsdmB9sJWP9Cj7Kq
 Oucxp5C7SNVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="142444647"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="142444647"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 04:45:58 -0700
IronPort-SDR: DYXefbo+KeC2XdHrrqfaZNRtKgv+JoZtsCrgJUuGhqTuD6AQBJRXnZsujF38PqWB79zuNK71tv
 c46e6f4RwR9A==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="497155843"
Received: from lbentzio-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.88])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 04:45:56 -0700
Date:   Wed, 30 Sep 2020 14:45:54 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: Unable to load large enclave
Message-ID: <20200930114554.GA7612@linux.intel.com>
References: <9393934c-e390-a7df-2e74-08f16d4f48d4@fortanix.com>
 <20200930011650.GA808399@linux.intel.com>
 <81e38a1b-c9a7-209e-76f5-e2c91f49c1e3@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81e38a1b-c9a7-209e-76f5-e2c91f49c1e3@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 30, 2020 at 09:12:06AM +0200, Jethro Beekman wrote:
> On 2020-09-30 03:16, Jarkko Sakkinen wrote:
> > On Tue, Sep 29, 2020 at 05:52:48PM +0200, Jethro Beekman wrote:
> >> Since the latest API changes, I'm unable to load a large enclave. The
> >> test program at
> >> https://github.com/fortanix/rust-sgx/blob/sgx-load-large-enclave-test/src/main.rs
> >> always fails with ENOMEM after loading 0xffd6 pages.
> >>
> >> I've tested this with v36, if there's reason to believe it has been
> >> fixed I'd be happy to try it out on a newer patch set.
> > 
> > I recommend using v39-rc1 tag that I created for testing because API is
> > reverted back to be compatible with v36.
> 
> Not sure what you're saying. I tested with v36. You're saying v39-rc1
> will be the same? Or did you fix the issue since v36?

v37 and v38 has an API change that is reverted in v39:

https://lore.kernel.org/linux-sgx/20200921195822.GA58176@linux.intel.com/

I'm not sure of the root cause yet but you asked to try to out a newer
patch set and v39-rc1 is the best option.

There was off-by-one error in enclave maximum size calculation fixed in
v37 (it was actually a bug in SDM inherited to the code) but that should
not result the situation you just described.

/Jarkko
