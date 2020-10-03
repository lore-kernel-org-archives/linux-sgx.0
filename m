Return-Path: <SRS0=MzOG=DK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B60BC41604
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 13:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15247206CD
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 13:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgJCNM7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Oct 2020 09:12:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:43313 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgJCNM7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Oct 2020 09:12:59 -0400
IronPort-SDR: +VnytKEBf5RIKr2eAf12kXv13qAR33SCLlJxTqJL7ja9eed5fPe/0VsCCFuZwS1qb+QbpF4nCR
 ySpeHjwNSBDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9762"; a="227344187"
X-IronPort-AV: E=Sophos;i="5.77,331,1596524400"; 
   d="scan'208";a="227344187"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2020 06:12:56 -0700
IronPort-SDR: 6TbjQzcIt+ezMIcC0X8Qd0w0MeLpKvOs+gVPGQQkLMdEeq/ViijfYAfm576E4FuWyWhlIwbOss
 HAFGXi5rWgJw==
X-IronPort-AV: E=Sophos;i="5.77,331,1596524400"; 
   d="scan'208";a="514265097"
Received: from kboulton-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.33.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2020 06:12:52 -0700
Date:   Sat, 3 Oct 2020 16:12:49 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        dave.hansen@intel.com, sean.j.christopherson@intel.com
Subject: Re: Unable to load large enclave
Message-ID: <20201003131249.GA5025@linux.intel.com>
References: <9393934c-e390-a7df-2e74-08f16d4f48d4@fortanix.com>
 <20200930011650.GA808399@linux.intel.com>
 <81e38a1b-c9a7-209e-76f5-e2c91f49c1e3@fortanix.com>
 <20200930114554.GA7612@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930114554.GA7612@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
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

Jethro,

I'll try to set up your environment and start looking into this, but in
the mean time can you provide a trivial ftrace dump?

Here's what you shoud do:

1. Install trace-cmd. It's tool that works as frontend for ftrace
   among other things. ftrace is one of the many tracing frameworks
   in the Linux kernel.
2. Run trace-cmd start -p function -l 'sgx*'. This will start
   to trace exported sgx prefixed functions.
3. Run your test.
4. Dump trace-cmd show output to a text file and send that to me.
5. trace-cmd stop stops the tracing framework.

Thank you.

/Jarkko

