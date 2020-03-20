Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45ABC4332D
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 13:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85BD420722
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 13:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCTNpR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 09:45:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:61270 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbgCTNpR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Mar 2020 09:45:17 -0400
IronPort-SDR: bgQpyOXVdEJyF69H1mQin1X9kaOybrPeUkjkYdAy6CJs39rTNFjcsQG0pteTLkk0hSwlIsVccV
 wwLS2HfKPmpQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 06:45:16 -0700
IronPort-SDR: RhJlYix3UPyPGxdRB7FBw8PMk1VH25/GFmOZyUfid0c6J+aFmX6X5T4C0uG6qJ1JCee7+2K0zb
 uXO7Cn1YEM6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,284,1580803200"; 
   d="scan'208";a="418716781"
Received: from hbuttle-mobl2.ger.corp.intel.com (HELO localhost) ([10.214.209.205])
  by orsmga005.jf.intel.com with ESMTP; 20 Mar 2020 06:45:14 -0700
Date:   Fri, 20 Mar 2020 15:45:12 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] selftests/x86/sgx: Merge test_sgx and sgxsign
Message-ID: <20200320134512.GA867045@linux.intel.com>
References: <20200320060738.2183396-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320060738.2183396-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 20, 2020 at 08:07:38AM +0200, Jarkko Sakkinen wrote:
> Sign enclaves on fly in test_sgx instead of using a precompiled
> sigstruct. This simplifies both the build process and the test
> program.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Squashed.

(and properly tested this time)

/Jarkko
