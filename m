Return-Path: <SRS0=joXX=6A=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9E7C2BB55
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Apr 2020 17:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA8A92076D
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Apr 2020 17:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgDPRZD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Apr 2020 13:25:03 -0400
Received: from mga04.intel.com ([192.55.52.120]:53427 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgDPRZC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Apr 2020 13:25:02 -0400
IronPort-SDR: pXUqxHFZW+vcAgOZAcNNFas51muqJ8SgOyP++m116ZZ7VBhFcLMst1ruou/lpSwBxwspC5NDL2
 Pco7GFJ8XRbw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 10:25:01 -0700
IronPort-SDR: g7HKYPqkc22bg4wOWmGmOPwWFmo0hmbllMuwJEdmrI2HhL2/sdLGCU4vLSK5EHmMyN+hrOpQYU
 rMo8qrj0dj0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="242725363"
Received: from otazetdi-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.42.128])
  by orsmga007.jf.intel.com with ESMTP; 16 Apr 2020 10:25:00 -0700
Date:   Thu, 16 Apr 2020 20:24:59 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v4] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200416172459.GF199110@linux.intel.com>
References: <20200406205626.33264-1-jarkko.sakkinen@linux.intel.com>
 <20200414043234.GV21204@linux.intel.com>
 <20200414071743.GB8403@linux.intel.com>
 <20200414184528.GA11185@linux.intel.com>
 <20200416042810.GC10076@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416042810.GC10076@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 15, 2020 at 09:28:10PM -0700, Sean Christopherson wrote:
> On Tue, Apr 14, 2020 at 09:45:28PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Apr 14, 2020 at 10:17:49AM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Apr 13, 2020 at 09:32:34PM -0700, Sean Christopherson wrote:
> > > > On Mon, Apr 06, 2020 at 11:56:26PM +0300, Jarkko Sakkinen wrote:
> > > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > >   	spin_lock(&encl->mm_lock);
> > > > > +
> > > > >  	list_add_rcu(&encl_mm->list, &encl->mm_list);
> > > > > -	spin_unlock(&encl->mm_lock);
> > > > >  
> > > > > -	synchronize_srcu(&encl->srcu);
> > > > > +	/* Even if the CPU does not reorder writes, a compiler might. */
> > > > 
> > > > The preferred (by maintainers) style of comment for smp_wmb()/smp_rmb()
> > > > comments is to explicitly call out the associated reader/writer.  If you
> > > > want to go with a minimal comment, my vote is for something like:
> > > > 
> > > > 	/*
> > > > 	 * Add to list before updating version.  Pairs the with smp_rmb() in
> > > > 	 * sgx_reclaimer_block().
> > > > 	 */
> > > > 
> > > > And if you want to go really spartan, I'd take:
> > > > 
> > > > 	/* Pairs with smp_rmb() in sgx_reclaimer_block(). */
> > > > 
> > > > over a generic comment about the compiler reordering instructions.
> > > 
> > > Thaks Sean, makes sense, I'll go with your "spartan" suggestion.
> > 
> > Updated, ready to squash?
> 
> Any objection to using the spartan comment for the smb_rmb() in
> sgx_reclaimer_block() as well?

For sure. I think here the role of the comment is to help with
the navigation.

/Jarkko
the navigation.
