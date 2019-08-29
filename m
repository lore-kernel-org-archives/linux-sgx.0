Return-Path: <SRS0=j74F=WZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAD0C3A59F
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 18:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644112189D
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 18:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfH2SBi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 14:01:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:58427 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbfH2SBh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 14:01:37 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 11:01:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,444,1559545200"; 
   d="scan'208";a="356529292"
Received: from friedlmi-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.54.26])
  by orsmga005.jf.intel.com with ESMTP; 29 Aug 2019 11:01:36 -0700
Date:   Thu, 29 Aug 2019 21:01:34 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH v2 1/5] x86/sgx: Convert encl->flags from an unsigned int
 to an atomic
Message-ID: <20190829180134.uzfi46bbdnl6covx@linux.intel.com>
References: <20190827192717.27312-1-sean.j.christopherson@intel.com>
 <20190827192717.27312-2-sean.j.christopherson@intel.com>
 <20190829000600.jkk7aih7j4cwzejp@linux.intel.com>
 <20190829155914.GC26580@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829155914.GC26580@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 29, 2019 at 08:59:14AM -0700, Sean Christopherson wrote:
> On Thu, Aug 29, 2019 at 04:09:29PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Aug 27, 2019 at 12:27:13PM -0700, Sean Christopherson wrote:
> > > @@ -77,7 +78,7 @@ static int sgx_release(struct inode *inode, struct file *file)
> > >  	};
> > >  
> > >  	mutex_lock(&encl->lock);
> > > -	encl->flags |= SGX_ENCL_DEAD;
> > > +	atomic_or(SGX_ENCL_DEAD, &encl->flags);
> > >  	mutex_unlock(&encl->lock);
> > 
> > Had a couple of checkpatch.pl errors (not a biggie, just a remark).
> > 
> > Is there reason to keep lock there?
> 
> Yes, I couldn't convince myself the reclaim flows would work correctly
> if SGX_ENCL_DEAD could be set while the reclaimer held encl->lock.  But
> I'm also not 100% certain holding encl->lock is strictly necessary in
> this case, so I didn't add a comment either.

Right. Lets keep it like it is for the moment.

/Jarkko
