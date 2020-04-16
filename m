Return-Path: <SRS0=joXX=6A=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03341C2BB55
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Apr 2020 04:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E336120771
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Apr 2020 04:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404203AbgDPE2N (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Apr 2020 00:28:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:27851 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403897AbgDPE2L (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Apr 2020 00:28:11 -0400
IronPort-SDR: /NwURuqxRi7VznYH6wBi+WpeNE2/KrKyO+js7OUGjxLQjNG8ziqHWjEh0wdQ+U3/irdGOhIFj6
 xZ0/uH0yD+FQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 21:28:10 -0700
IronPort-SDR: XK8V0G9Vumd9719ghYfzvAYE7JXdjKG/fxKSb9df4iZbyLjmo/LQ/eKf8KbPi0NU8PK4KgWjn6
 2hcEpMdc2OJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="245875037"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 15 Apr 2020 21:28:10 -0700
Date:   Wed, 15 Apr 2020 21:28:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v4] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200416042810.GC10076@linux.intel.com>
References: <20200406205626.33264-1-jarkko.sakkinen@linux.intel.com>
 <20200414043234.GV21204@linux.intel.com>
 <20200414071743.GB8403@linux.intel.com>
 <20200414184528.GA11185@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414184528.GA11185@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 14, 2020 at 09:45:28PM +0300, Jarkko Sakkinen wrote:
> On Tue, Apr 14, 2020 at 10:17:49AM +0300, Jarkko Sakkinen wrote:
> > On Mon, Apr 13, 2020 at 09:32:34PM -0700, Sean Christopherson wrote:
> > > On Mon, Apr 06, 2020 at 11:56:26PM +0300, Jarkko Sakkinen wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > >   	spin_lock(&encl->mm_lock);
> > > > +
> > > >  	list_add_rcu(&encl_mm->list, &encl->mm_list);
> > > > -	spin_unlock(&encl->mm_lock);
> > > >  
> > > > -	synchronize_srcu(&encl->srcu);
> > > > +	/* Even if the CPU does not reorder writes, a compiler might. */
> > > 
> > > The preferred (by maintainers) style of comment for smp_wmb()/smp_rmb()
> > > comments is to explicitly call out the associated reader/writer.  If you
> > > want to go with a minimal comment, my vote is for something like:
> > > 
> > > 	/*
> > > 	 * Add to list before updating version.  Pairs the with smp_rmb() in
> > > 	 * sgx_reclaimer_block().
> > > 	 */
> > > 
> > > And if you want to go really spartan, I'd take:
> > > 
> > > 	/* Pairs with smp_rmb() in sgx_reclaimer_block(). */
> > > 
> > > over a generic comment about the compiler reordering instructions.
> > 
> > Thaks Sean, makes sense, I'll go with your "spartan" suggestion.
> 
> Updated, ready to squash?

Any objection to using the spartan comment for the smb_rmb() in
sgx_reclaimer_block() as well?
