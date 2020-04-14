Return-Path: <SRS0=Lp6X=56=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F357FC2BA19
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Apr 2020 07:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1E2B20575
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Apr 2020 07:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406499AbgDNHRs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Apr 2020 03:17:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:15752 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406487AbgDNHRq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 Apr 2020 03:17:46 -0400
IronPort-SDR: 6CejHt079ad82kW+Q0yi571fDVT+z7pssjNi+MmHuEy0Yf3+y+uKKSYChiNIgAJfLbGv4kYRH2
 sM5z300pnn2Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 00:17:46 -0700
IronPort-SDR: le24mTvBub27y6fEEk9W3o2po6gcbUtiIWDRAQEOsBG9cW13BTQVkFAqYakBMUdIIseD4sQwZk
 qzBdAYOmVPrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="288135559"
Received: from elenamax-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.42.208])
  by fmsmga002.fm.intel.com with ESMTP; 14 Apr 2020 00:17:45 -0700
Date:   Tue, 14 Apr 2020 10:17:43 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v4] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200414071743.GB8403@linux.intel.com>
References: <20200406205626.33264-1-jarkko.sakkinen@linux.intel.com>
 <20200414043234.GV21204@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414043234.GV21204@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 13, 2020 at 09:32:34PM -0700, Sean Christopherson wrote:
> On Mon, Apr 06, 2020 at 11:56:26PM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
>   	spin_lock(&encl->mm_lock);
> > +
> >  	list_add_rcu(&encl_mm->list, &encl->mm_list);
> > -	spin_unlock(&encl->mm_lock);
> >  
> > -	synchronize_srcu(&encl->srcu);
> > +	/* Even if the CPU does not reorder writes, a compiler might. */
> 
> The preferred (by maintainers) style of comment for smp_wmb()/smp_rmb()
> comments is to explicitly call out the associated reader/writer.  If you
> want to go with a minimal comment, my vote is for something like:
> 
> 	/*
> 	 * Add to list before updating version.  Pairs the with smp_rmb() in
> 	 * sgx_reclaimer_block().
> 	 */
> 
> And if you want to go really spartan, I'd take:
> 
> 	/* Pairs with smp_rmb() in sgx_reclaimer_block(). */
> 
> over a generic comment about the compiler reordering instructions.

Thaks Sean, makes sense, I'll go with your "spartan" suggestion.

/Jarkko
