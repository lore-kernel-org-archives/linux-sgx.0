Return-Path: <SRS0=CuW6=XW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AB1C4360C
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 15:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7C4A21841
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 15:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfI0PkC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Sep 2019 11:40:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:25788 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbfI0PkC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 27 Sep 2019 11:40:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 08:40:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="196754200"
Received: from mdauner2-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.39.118])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Sep 2019 08:39:58 -0700
Date:   Fri, 27 Sep 2019 18:39:57 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v3 17/17] x86/sgx: Fix pages in the BLOCKED state ending
 up to the free pool
Message-ID: <20190927153957.GE10545@linux.intel.com>
References: <20190916101803.30726-1-jarkko.sakkinen@linux.intel.com>
 <20190916101803.30726-18-jarkko.sakkinen@linux.intel.com>
 <20190917233435.GI10319@linux.intel.com>
 <20190918042120.GG22434@linux.intel.com>
 <20190925002749.GA29629@linux.intel.com>
 <20190925183303.GI31852@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925183303.GI31852@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 25, 2019 at 11:33:03AM -0700, Sean Christopherson wrote:
> On Wed, Sep 25, 2019 at 03:27:49AM +0300, Jarkko Sakkinen wrote:
> > On Wed, Sep 18, 2019 at 07:21:20AM +0300, Jarkko Sakkinen wrote:
> > > > > +			goto skip;
> > > > >  
> > > > > +		ret = sgx_encl_get_backing(encl_page->encl,
> > > > > +					   SGX_ENCL_PAGE_INDEX(encl_page),
> > > > > +					   &backing[i]);
> > > > > +		if (ret)
> > > > > +			goto skip;
> > > > > +
> > > > > +		mutex_lock(&encl_page->encl->lock);
> > > > > +		encl_page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> > > > > +		mutex_unlock(&encl_page->encl->lock);
> > > > > +		continue;
> > > > > +
> > > > > +skip:
> > > > 
> > > > Eww.  The call to sgx_encl_get_backing() makes it rather ugly no matter
> > > > what, but this seems slightly less ugly:
> > > > 
> > > > 	for (i = 0; i < cnt; i++) {
> > > > 		epc_page = chunk[i];
> > > > 		encl_page = epc_page->owner;
> > > > 
> > > > 		if (!sgx_can_reclaim(chunk[i]) ||
> > > > 		    sgx_encl_get_backing(encl_page->encl,
> > > > 					 SGX_ENCL_PAGE_INDEX(encl_page),
> > > > 					 &backing[i]) {
> > > > 			kref_put(&encl_page->encl->refcount, sgx_encl_release);
> > > > 
> > > > 			spin_lock(&sgx_active_page_list_lock);
> > > > 			list_add_tail(&epc_page->list, &sgx_active_page_list);
> > > > 			spin_unlock(&sgx_active_page_list_lock);
> > > > 
> > > > 			chunk[i] = NULL;
> > > > 			continue;
> > > > 		}
> > > > 
> > > > 		mutex_lock(&encl_page->encl->lock);
> > > > 		encl_page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> > > > 		mutex_unlock(&encl_page->encl->lock);
> > > > 	}
> > > > 
> > 
> > Well that is one big nested mess where as the version I did is legit use
> > of gotos: two conditions that can cause to skip the action. And also
> > fairly normal use of gotos with same ideas as with out/err etc. labels
> > except now it is used inside a loop..
> 
> Yeah, it's the "inside a loop" part that's ugly.  I agree the nested code
> is also heinous.
> 
> What if we add a helper to split out the verbose check?  Maybe as below,
> or move the entire guts to a separate helper?
> 
> static int sgx_prepare_to_reclaim(struct sgx_encl_page *encl_page,
> 				  struct sgx_backing *backing)
> {
> 	if (!sgx_can_reclaim(encl_page))
> 		return -EBUSY;
> 
> 	return sgx_encl_get_backing(encl_page->encl,
> 				    SGX_ENCL_PAGE_INDEX(encl_page), backing);
> }

If you want to make it cleaner, it would be better keep
sgx_reclaimer_age() call outside the function in order to keep the call
hierarchy kind of "flat". Aging is kind of core part of the flow works
and I don't want it to be buried too deep.

E.g. inside the sgx_reclaim_pages():

if (sgx_reclaimer_age(epc_page))
	sgx_reclaimer_prepare(epc_page, &backing[i]);

sgx_reclaimer_prepare() would do then all the preparation work (also
set SGX_ENCL_PAGE_RECLAIMED).

/Jarkko


