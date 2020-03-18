Return-Path: <SRS0=nWD/=5D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C59C10DCE
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 20:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26FEF2071C
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 20:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgCRUIO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 16:08:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:15285 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgCRUIO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 16:08:14 -0400
IronPort-SDR: PVG4KAEGAcz4ahobchiutwlSJbDh27bFbzj/023hMXJ/e6lYVMlP3rEa74r3zfMvTtO53HvlhN
 a2s7r74sAgQw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 13:08:14 -0700
IronPort-SDR: twV8agTf5YUhg21rmfj5s1NaDr8GiBEeQeOO3J5uApRFFAddd9u3xDJurkLY5IVv7ovyKLC/8x
 tHaipES1+5PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="268477412"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 18 Mar 2020 13:07:48 -0700
Date:   Wed, 18 Mar 2020 13:07:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix deadlock and race conditions between fork()
 and EPC reclaim
Message-ID: <20200318200748.GA26164@linux.intel.com>
References: <20200317051539.10447-1-sean.j.christopherson@intel.com>
 <20200318153903.GA37333@linux.intel.com>
 <20200318155043.GA37726@linux.intel.com>
 <20200318160316.GE24357@linux.intel.com>
 <20200318194002.GA48177@linux.intel.com>
 <20200318194132.GB48177@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318194132.GB48177@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 18, 2020 at 09:41:32PM +0200, Jarkko Sakkinen wrote:
> On Wed, Mar 18, 2020 at 09:40:06PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Mar 18, 2020 at 09:03:16AM -0700, Sean Christopherson wrote:
> > > How on earth is someone doing to dredge up the above information without a
> > > comment?  Anyone looking at this code without a priori knowledge of the
> > > development history will assume the missing synchronize_srcu() is a bug.
> > 
> > By reading the source code of the driver obviously.
> 
> Secondly, there is no development history. It is in epoch state.

That's exactly my point.  Unless someone knows to look through the
pre-historic threads in the intel_sgx mailing list they'll be clueless as
to why synchronizing the srcu when attaching a new mm to an enclave is a
bad idea.  And give it a few years and we'll probably be asking ourselves
why there's no synchronize_sruc()...

The locking rules between SGX and the core MMU are complex enough as it is,
I don't understand why we'd want to make our lives even more difficult.
