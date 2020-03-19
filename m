Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8B6C4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 14:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAFC02080C
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 14:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgCSOQD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 10:16:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:40300 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgCSOQD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 10:16:03 -0400
IronPort-SDR: II1gW5P4X12OBltLJo7p35LIIokTwqWcTLGmyhlG8NTL/TkDBgh8Ta/xqWUciNGsLi9Ylp62LZ
 PY2Do5MytMIA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 07:15:53 -0700
IronPort-SDR: wixC7rXZ7pPBC5bIVCLFgCw5L2zg8rL7mEaKW+OlA3gqYsI06YT1b7RactBUAsI1pygBV8xwD1
 XCTu83IihkKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,571,1574150400"; 
   d="scan'208";a="248546737"
Received: from awagner-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.86.227])
  by orsmga006.jf.intel.com with ESMTP; 19 Mar 2020 07:15:50 -0700
Date:   Thu, 19 Mar 2020 16:15:49 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix deadlock and race conditions between fork()
 and EPC reclaim
Message-ID: <20200319141549.GA3703@linux.intel.com>
References: <20200317051539.10447-1-sean.j.christopherson@intel.com>
 <20200318153903.GA37333@linux.intel.com>
 <20200318155043.GA37726@linux.intel.com>
 <20200318160316.GE24357@linux.intel.com>
 <20200318194002.GA48177@linux.intel.com>
 <20200318194132.GB48177@linux.intel.com>
 <20200318200748.GA26164@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318200748.GA26164@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 18, 2020 at 01:07:48PM -0700, Sean Christopherson wrote:
> On Wed, Mar 18, 2020 at 09:41:32PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Mar 18, 2020 at 09:40:06PM +0200, Jarkko Sakkinen wrote:
> > > On Wed, Mar 18, 2020 at 09:03:16AM -0700, Sean Christopherson wrote:
> > > > How on earth is someone doing to dredge up the above information without a
> > > > comment?  Anyone looking at this code without a priori knowledge of the
> > > > development history will assume the missing synchronize_srcu() is a bug.
> > > 
> > > By reading the source code of the driver obviously.
> > 
> > Secondly, there is no development history. It is in epoch state.
> 
> That's exactly my point.  Unless someone knows to look through the
> pre-historic threads in the intel_sgx mailing list they'll be clueless as
> to why synchronizing the srcu when attaching a new mm to an enclave is a
> bad idea.  And give it a few years and we'll probably be asking ourselves
> why there's no synchronize_sruc()...
> 
> The locking rules between SGX and the core MMU are complex enough as it is,
> I don't understand why we'd want to make our lives even more difficult.

A six sentece paragraph is an overkill.

BTW, is smp_wmb() necessary given that the code is strictly x86? x86
does not reorder writes on a core.

/Jarkko
