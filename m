Return-Path: <SRS0=yHMC=WF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5183C31E40
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 16:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E15F2086A
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 16:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407417AbfHIQMb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 12:12:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:45361 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406171AbfHIQMb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 12:12:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 09:12:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,364,1559545200"; 
   d="scan'208";a="259081167"
Received: from ishiri-mobl1.ger.corp.intel.com ([10.252.50.117])
  by orsmga001.jf.intel.com with ESMTP; 09 Aug 2019 09:12:28 -0700
Message-ID: <d052e95d308eca3eefd24ff36713c1866d868de7.camel@linux.intel.com>
Subject: Re: [PATCH for_v22 10/11] x86/sgx: Call sgx_encl_grow() with the
 enclave's lock held
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Date:   Fri, 09 Aug 2019 19:12:25 +0300
In-Reply-To: <20190808155548.GD23156@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
         <20190808001254.11926-11-sean.j.christopherson@intel.com>
         <20190808155217.r5seneo3px3kzjmd@linux.intel.com>
         <20190808155548.GD23156@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-08 at 08:55 -0700, Sean Christopherson wrote:
> On Thu, Aug 08, 2019 at 06:52:29PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Aug 07, 2019 at 05:12:53PM -0700, Sean Christopherson wrote:
> > > Move the taking of the enclave's lock outside of sgx_encl_grow() in
> > > preparation for adding sgx_encl_shrink(), which will decrement the
> > > number of enclave pages and free any allocated VA page.  When freeing
> > > a VA page, the enclave's lock needs to be held for the entire time
> > > between adding the VA page to the enclave's list and freeing the VA
> > > page so as to prevent it from being used by reclaim, e.g. to avoid a
> > > use-after-free scenario.
> > > 
> > > Because sgx_encl_grow() can temporarily drop encl->lock, calling it
> > > with encl->lock held adds a subtle dependency on the ordering of
> > > checks against encl->flags, e.g. checking for SGX_ENCL_CREATED prior
> > > to calling sgx_encl_grow() could lead to a TOCTOU on ECREATE.  Avoid
> > > this by passing in the disallowed flags to sgx_encl_grow() so that the
> > > the dependency is clear.
> > > 
> > > Retaking encl->lock in the failure paths is a bit ugly, but the
> > > alternative is to have sgx_encl_grow() drop encl->lock in all failure
> > > paths, which is arguably worse since the caller has to know which
> > > paths do/don't drop the lock.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Would be cleaner to check the flags just before the call. Otherwise,
> > no problems with this.
> 
> That's not sufficient in the case that sgx_encl_grow() drops encl->lock
> to allocate an EPC page, as the flags need to be rechecked after the
> lock is reacquired.  I'm not a huge fan of the code either, but it was
> the least ugly solution I could come up with and kinda fit since
> sgx_encl_grow() was already checking SGX_ENCL_DEAD.

Right, I was too hazy. We'll go what you proposed.

/Jarkko

