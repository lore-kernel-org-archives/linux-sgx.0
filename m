Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B94C742A5
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD58920644
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfGLDoM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 23:44:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:35522 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbfGLDoM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 23:44:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 20:44:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,481,1557212400"; 
   d="scan'208";a="168206290"
Received: from gonegri-mobl.ger.corp.intel.com (HELO localhost) ([10.252.48.192])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2019 20:44:10 -0700
Date:   Fri, 12 Jul 2019 06:44:09 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v21 1/2] x86/sgx: Use SRCU to protect mm_list during
 reclaim
Message-ID: <20190712034409.6qusjbljfexe2ogf@linux.intel.com>
References: <20190711161625.15786-1-sean.j.christopherson@intel.com>
 <20190711161625.15786-2-sean.j.christopherson@intel.com>
 <20190711211307.cymfaxeuq73v63xg@linux.intel.com>
 <20190711212549.GO15067@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711212549.GO15067@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 02:25:49PM -0700, Sean Christopherson wrote:
> On Fri, Jul 12, 2019 at 12:13:07AM +0300, Jarkko Sakkinen wrote:
> > On Thu, Jul 11, 2019 at 09:16:24AM -0700, Sean Christopherson wrote:
> > > Not taking a reference to encl_mm is not just an optimization, it's also
> > > functionally necessary and a major motivation to moving to SRCu. Putting
> > > the reference can invoke sgx_encl_mm_release(), which calls
> > > synchronize_srcu() and will deadlock if done while holding the SRCU read
> > > lock.  Not taking a reference paves the way for additional refcounting
> > > improvements that would be extremely difficult to implement when using
> > > the custom walker due to cyclical dependencies on the refcount.
> > 
> > I'm not sure I get this. The existing code does not have a call to
> > synchronize_srcu().
> 
> Does this read any better?
> 
>   Not taking a reference to encl_mm is not just an optimization, it's also
>   functionally necessary and a major motivation to moving to SRCU.  From a
>   functional perspective, putting the encl_mm reference can invoke
>   sgx_encl_mm_release(), which now calls synchronize_srcu() and thus will
>   deadlock if triggered while holding the SRCU read lock.  In terms of
>   motivation, not taking a reference paves the way for additional refcounting
>   improvements that would be extremely difficult to implement when using
>   the custom walker due to cyclical dependencies on the encl_mm's refcount.

No need to change the commit message. Was just a question. I got the
code change :-) Thanks anyway for elaborating.

>  
> > > -	if (!encl)
> > > -		return;
> > > +	lockdep_assert_held_exclusive(&mm->mmap_sem);
> > 
> > Just a question: what does it check (12:10AM too tired to check,
> > apologies)?
> 
> Asserts that the caller has done down_write(&mmap_sem), i.e. guarantees
> that sgx_encl_mm_add() cannot be called in parallel on the same mm_struct.
