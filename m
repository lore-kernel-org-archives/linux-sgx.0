Return-Path: <SRS0=Mf4r=CX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB8EC433E2
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Sep 2020 18:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B3D4214F1
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Sep 2020 18:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgINSLi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Sep 2020 14:11:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:1239 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgINSH4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Sep 2020 14:07:56 -0400
IronPort-SDR: de1nAWgEPQC69k4s5W+rRNg4zFJIav+L2hkUvbxVOhHe00L153KNpeefouzrxaxg6EizyZ7ssR
 c2Bx7ghZtP/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160067706"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="160067706"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:07:49 -0700
IronPort-SDR: RWSg9rSSnZ/NGFONGcyqMmW6Q/ZPZCPG1PHvLJTdNuLTYGkZoWuBZ+GjU4fX5+Dx6Dg5o9Vfcv
 fwdoznD9VHOA==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482445863"
Received: from mgorski-mobl.ger.corp.intel.com (HELO localhost) ([10.249.43.120])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:07:47 -0700
Date:   Mon, 14 Sep 2020 21:07:42 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86/sgx: Roof the number of pages process in
 SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20200914180742.GD9369@linux.intel.com>
References: <20200908190042.24895-1-jarkko.sakkinen@linux.intel.com>
 <20200909053033.GC9987@sjchrist-ice>
 <20200911114315.GA6760@linux.intel.com>
 <20200911155125.GA4344@sjchrist-ice>
 <op.0qsja9jawjvjmi@mqcpg7oapc828.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0qsja9jawjvjmi@mqcpg7oapc828.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 11, 2020 at 12:38:59PM -0500, Haitao Huang wrote:
> nOn Fri, 11 Sep 2020 10:51:27 -0500, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
> > On Fri, Sep 11, 2020 at 02:43:15PM +0300, Jarkko Sakkinen wrote:
> > > On Tue, Sep 08, 2020 at 10:30:33PM -0700, Sean Christopherson wrote:
> > > > >  	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
> > > > > -		if (signal_pending(current)) {
> > > > > -			ret = -EINTR;
> > > > > +		if (c == SGX_MAX_ADD_PAGES_LENGTH || signal_pending(current)) {
> > > > > +			ret = c;
> > > >
> > > > I don't have an opinion on returning count vs. EINTR, but I don't
> > > see the
> > > > point in arbitrarily capping the number of pages that can be added
> > > in a
> > > > single ioctl().  It doesn't provide any real protection, e.g.
> > > userspace
> > > > can simply restart the ioctl() with updated offsets and continue
> > > spamming
> > > > EADDs.  We are relying on other limits, e.g. memcg, rlimits, etc... to
> > > > reign in malicious/broken userspace.
> > > >
> > > > There is nothing inherently dangerous about spending time in the
> > > kernel so
> > > > long as appropriate checks are made, e.g. for a pending signel and
> > > resched.
> > > > If we're missing checks, adding an arbitrary limit won't fix the
> > > underlying
> > > > problem, at least not in a deterministic way.
> > > >
> > > > If we really want a limit of some form, adding a knob to control
> > > the max
> > > > size of an enclave seems like the way to go.  But even that is of
> > > dubious
> > > > value as I'd rather rely on existing limits for virtual and
> > > physical memory,
> > > > and add a proper EPC cgroup to account and limit EPC memory.
> > > 
> > > It is better to have a contract in the API that the number of processed
> > > pages can be less than given, not unlike in syscalls such as write().
> > 
> > That can be handled by a comment, no?  If we want to "enforce" the
> > behavior,
> > I'd rather bail out of the loop after a random number of pages than have
> > a
> > completely arbitrary limit.  The arbitrary limit will create a contract
> > of
> > its own and may lead to weird guest implementations.
> 
> 
> I agree with Sean on potential issues with the arbitrary hard coded limit.
> Also returning -EINTR is better way to express to user space that operations
> are interrupted by signal and can be retried, which is a known pattern for
> this kind of situations.

In read() -EINTR is returned only when zero amount of data is processed.

Otherwise, it returns just the count.

/Jarkko
