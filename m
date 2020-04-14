Return-Path: <SRS0=Lp6X=56=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7B8C2BA19
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Apr 2020 18:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F19242074D
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Apr 2020 18:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504305AbgDNSpd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Apr 2020 14:45:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:55988 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504293AbgDNSpc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 Apr 2020 14:45:32 -0400
IronPort-SDR: qcC/Nn37hZzp7ZbzLZFOLgu5joI5z9L52OcIDu7ULX+v7xppm/f9TwmA4AzF/YLy2Jk1bL5uOG
 79ZLXh0DaoEg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 11:45:30 -0700
IronPort-SDR: YOqHXRb4HkgwBV4qoyTwu2fDYDI+thzWMd1/DllgwIGBO/6XaCNttTYt5PaL7gEdTE/rewVg9D
 kDtu0o6Z6+zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,383,1580803200"; 
   d="scan'208";a="271016624"
Received: from jclobus-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.42.176])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2020 11:45:29 -0700
Date:   Tue, 14 Apr 2020 21:45:28 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v4] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200414184528.GA11185@linux.intel.com>
References: <20200406205626.33264-1-jarkko.sakkinen@linux.intel.com>
 <20200414043234.GV21204@linux.intel.com>
 <20200414071743.GB8403@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414071743.GB8403@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 14, 2020 at 10:17:49AM +0300, Jarkko Sakkinen wrote:
> On Mon, Apr 13, 2020 at 09:32:34PM -0700, Sean Christopherson wrote:
> > On Mon, Apr 06, 2020 at 11:56:26PM +0300, Jarkko Sakkinen wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >   	spin_lock(&encl->mm_lock);
> > > +
> > >  	list_add_rcu(&encl_mm->list, &encl->mm_list);
> > > -	spin_unlock(&encl->mm_lock);
> > >  
> > > -	synchronize_srcu(&encl->srcu);
> > > +	/* Even if the CPU does not reorder writes, a compiler might. */
> > 
> > The preferred (by maintainers) style of comment for smp_wmb()/smp_rmb()
> > comments is to explicitly call out the associated reader/writer.  If you
> > want to go with a minimal comment, my vote is for something like:
> > 
> > 	/*
> > 	 * Add to list before updating version.  Pairs the with smp_rmb() in
> > 	 * sgx_reclaimer_block().
> > 	 */
> > 
> > And if you want to go really spartan, I'd take:
> > 
> > 	/* Pairs with smp_rmb() in sgx_reclaimer_block(). */
> > 
> > over a generic comment about the compiler reordering instructions.
> 
> Thaks Sean, makes sense, I'll go with your "spartan" suggestion.

Updated, ready to squash?

/Jarkko
