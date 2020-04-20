Return-Path: <SRS0=jXpw=6E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45AAC54FD0
	for <linux-sgx@archiver.kernel.org>; Mon, 20 Apr 2020 21:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BD9520724
	for <linux-sgx@archiver.kernel.org>; Mon, 20 Apr 2020 21:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgDTVvO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 20 Apr 2020 17:51:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:34445 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgDTVvO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 20 Apr 2020 17:51:14 -0400
IronPort-SDR: GMWRQEr10358YB0maIeOW7MF78bQt8OTsb+NgJYnG5wVAQ4g5eBSPl5bBKot5VGCs5TEQBaS9Y
 PYv9hhje9c3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 14:51:13 -0700
IronPort-SDR: QAZtPKfaSanodUDnfivk75eNwpcTjDK4TgWI2J4h8O3v4+1O1sTPdC0AO4WB7WVvJ3lJHKSwHr
 EdDfUfzPJOhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="300406320"
Received: from rpirker-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.46.184])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 14:51:11 -0700
Date:   Tue, 21 Apr 2020 00:51:10 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, luto@kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Remove PROT_NONE branch from sgx_encl_may_map().
Message-ID: <20200420215110.GB14637@linux.intel.com>
References: <20200330185452.1382455-1-jarkko.sakkinen@linux.intel.com>
 <20200330211320.GA1389628@linux.intel.com>
 <20200418043749.GH15609@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418043749.GH15609@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 17, 2020 at 09:37:49PM -0700, Sean Christopherson wrote:
> On Tue, Mar 31, 2020 at 12:13:36AM +0300, Jarkko Sakkinen wrote:
> > On Mon, Mar 30, 2020 at 09:54:52PM +0300, Jarkko Sakkinen wrote:
> > > sgx_encl_may_map() always succeeding when PROT_NONE is given is not that
> > > useful behaviour as one can just well as do an anonymous mapping as
> > > demonstrated by the change in this patch to the test program. As a
> > > consequence, remove the special case.
> > > 
> > > Pratically any possible way to make sure that you don't overwrite anything
> > > useful in the memory, should be fine. MAP_FIXED does not care what's
> > > underneath (if you want't it to care you ought to use
> > > MAP_FIXED_NO_REPLACE).
> > > 
> > > After this change, the selftest run called sgx_mmap() only three times
> > > (TCS, text, data) instead of four.
> > > 
> > >         test_sgx-1811  [002] ....   586.907585: sgx_mmap <-mmap_region
> > >         test_sgx-1811  [002] ....   586.911752: sgx_mmap <-mmap_region
> > >         test_sgx-1811  [002] ....   586.911756: sgx_mmap <-mmap_region
> > > 
> > > This also gives more angles to segregate enclave building and mapping as
> > > the mmap()'s need to be applied only when the enclave is fully built:
> > > 
> > > Cc: luto@kernel.org
> > > Cc: Haitao Huang <haitao.huang@linux.intel.com>
> > > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > 
> > Sean, would be cool if you can try this out soonish because I'm
> > building on top of this.
> 
> Two and a half weeks is soonish, right?
> 
> Anyways, finally tested this, no issues.  Just to be different than the
> selftest, I used MAP_PRIVATE instead of MAP_SHARED along with MAP_ANONYMOUS
> in my test code.

Ah, MAP_SHARED was not intentional. Not gonna change it tho because both
should equally work (or basically anything to guarante the availability
of the address space).

/Jarkko
