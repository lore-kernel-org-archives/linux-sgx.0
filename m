Return-Path: <SRS0=Mf4r=CX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502AEC43461
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Sep 2020 18:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26014214F1
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Sep 2020 18:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgINSKY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Sep 2020 14:10:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:34812 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgINSJU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Sep 2020 14:09:20 -0400
IronPort-SDR: N0powd4F4Dq+pIqELQT79Hp9AvnOPvhpNT8yf3r81gLIUWFYZnBbaCff677AmEVgNKwNdrFREL
 oIVXCKYnrQgQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="177198794"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="177198794"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:09:20 -0700
IronPort-SDR: epUqlyo5qLwG25OWtiXCIHUKcqkyESLMy7ry9R8fpa0XBESN4GUa5SUlPUcZYBD++9/hBREHer
 8awy7kVmtA2g==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="450981645"
Received: from mgorski-mobl.ger.corp.intel.com (HELO localhost) ([10.249.43.120])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:09:18 -0700
Date:   Mon, 14 Sep 2020 21:09:13 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86/sgx: Roof the number of pages process in
 SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20200914180913.GE9369@linux.intel.com>
References: <20200908190042.24895-1-jarkko.sakkinen@linux.intel.com>
 <20200909053033.GC9987@sjchrist-ice>
 <20200911114315.GA6760@linux.intel.com>
 <20200911155125.GA4344@sjchrist-ice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911155125.GA4344@sjchrist-ice>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 11, 2020 at 08:51:27AM -0700, Sean Christopherson wrote:
> On Fri, Sep 11, 2020 at 02:43:15PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Sep 08, 2020 at 10:30:33PM -0700, Sean Christopherson wrote:
> > > >  	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
> > > > -		if (signal_pending(current)) {
> > > > -			ret = -EINTR;
> > > > +		if (c == SGX_MAX_ADD_PAGES_LENGTH || signal_pending(current)) {
> > > > +			ret = c;
> > > 
> > > I don't have an opinion on returning count vs. EINTR, but I don't see the
> > > point in arbitrarily capping the number of pages that can be added in a
> > > single ioctl().  It doesn't provide any real protection, e.g. userspace
> > > can simply restart the ioctl() with updated offsets and continue spamming
> > > EADDs.  We are relying on other limits, e.g. memcg, rlimits, etc... to
> > > reign in malicious/broken userspace.
> > > 
> > > There is nothing inherently dangerous about spending time in the kernel so
> > > long as appropriate checks are made, e.g. for a pending signel and resched.
> > > If we're missing checks, adding an arbitrary limit won't fix the underlying
> > > problem, at least not in a deterministic way.
> > > 
> > > If we really want a limit of some form, adding a knob to control the max
> > > size of an enclave seems like the way to go.  But even that is of dubious
> > > value as I'd rather rely on existing limits for virtual and physical memory,
> > > and add a proper EPC cgroup to account and limit EPC memory.
> > 
> > It is better to have a contract in the API that the number of processed
> > pages can be less than given, not unlike in syscalls such as write().
> 
> That can be handled by a comment, no?  If we want to "enforce" the behavior,
> I'd rather bail out of the loop after a random number of pages than have a
> completely arbitrary limit.  The arbitrary limit will create a contract of
> its own and may lead to weird guest implementations.

I don't understand.

It is already a random number given that also signal can cause this.

/Jarkko
