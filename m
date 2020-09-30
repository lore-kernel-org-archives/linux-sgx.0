Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9C2C47423
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 01:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A39A820C09
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 01:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbgI3BQ4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 29 Sep 2020 21:16:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:5988 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729540AbgI3BQ4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 29 Sep 2020 21:16:56 -0400
IronPort-SDR: Y0cNd5rkzhnASdeI0O9C4ZeFbGN8I+LaxNch2o7ZknV2yNJ9mc/FL0ub2VSfhAQyuURwLLo6Uh
 onKs9vASJzdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="226485007"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="226485007"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 18:16:54 -0700
IronPort-SDR: wEmqOVbaRlPNKWD2UMh23DolzntZSztGrX+rZGZnfMITKonlLbWaNI4vKlFoyTPX0rKx+fewuM
 rrRSPc1IYQ1A==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="457475255"
Received: from jwilliam-mobl.ger.corp.intel.com (HELO localhost) ([10.252.47.189])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 18:16:53 -0700
Date:   Wed, 30 Sep 2020 04:16:50 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: Unable to load large enclave
Message-ID: <20200930011650.GA808399@linux.intel.com>
References: <9393934c-e390-a7df-2e74-08f16d4f48d4@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9393934c-e390-a7df-2e74-08f16d4f48d4@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 29, 2020 at 05:52:48PM +0200, Jethro Beekman wrote:
> Since the latest API changes, I'm unable to load a large enclave. The
> test program at
> https://github.com/fortanix/rust-sgx/blob/sgx-load-large-enclave-test/src/main.rs
> always fails with ENOMEM after loading 0xffd6 pages.
> 
> I've tested this with v36, if there's reason to believe it has been
> fixed I'd be happy to try it out on a newer patch set.

I recommend using v39-rc1 tag that I created for testing because API is
reverted back to be compatible with v36.

The repository has now also a new location:

git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git

> 
> -- 
> Jethro Beekman | Fortanix
> 

/Jarkko
