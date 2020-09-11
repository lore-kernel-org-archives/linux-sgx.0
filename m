Return-Path: <SRS0=Q2gl=CU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC8FC43461
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Sep 2020 15:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B45D9208E4
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Sep 2020 15:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgIKPwY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Sep 2020 11:52:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:27797 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgIKPwK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Sep 2020 11:52:10 -0400
IronPort-SDR: I3A1pwl8H3nFndEeBhjWU9hktrvihPj/3S4X9LI2ud8KjbUJdswYn4ZKJsh9mjc2PiZM7UlzPH
 eLmZQHqYkycg==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="159728255"
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="159728255"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 08:51:49 -0700
IronPort-SDR: J2ei1EN6nSivFN1rGXyeRzeSBilgVG3Ze5iuxZkRU9q0xEP2ovyDbKTxgjYK45KFLWRCdmtKWn
 D4ZooW5TvZrQ==
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="505544728"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 08:51:48 -0700
Date:   Fri, 11 Sep 2020 08:51:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86/sgx: Roof the number of pages process in
 SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20200911155125.GA4344@sjchrist-ice>
References: <20200908190042.24895-1-jarkko.sakkinen@linux.intel.com>
 <20200909053033.GC9987@sjchrist-ice>
 <20200911114315.GA6760@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911114315.GA6760@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 11, 2020 at 02:43:15PM +0300, Jarkko Sakkinen wrote:
> On Tue, Sep 08, 2020 at 10:30:33PM -0700, Sean Christopherson wrote:
> > >  	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
> > > -		if (signal_pending(current)) {
> > > -			ret = -EINTR;
> > > +		if (c == SGX_MAX_ADD_PAGES_LENGTH || signal_pending(current)) {
> > > +			ret = c;
> > 
> > I don't have an opinion on returning count vs. EINTR, but I don't see the
> > point in arbitrarily capping the number of pages that can be added in a
> > single ioctl().  It doesn't provide any real protection, e.g. userspace
> > can simply restart the ioctl() with updated offsets and continue spamming
> > EADDs.  We are relying on other limits, e.g. memcg, rlimits, etc... to
> > reign in malicious/broken userspace.
> > 
> > There is nothing inherently dangerous about spending time in the kernel so
> > long as appropriate checks are made, e.g. for a pending signel and resched.
> > If we're missing checks, adding an arbitrary limit won't fix the underlying
> > problem, at least not in a deterministic way.
> > 
> > If we really want a limit of some form, adding a knob to control the max
> > size of an enclave seems like the way to go.  But even that is of dubious
> > value as I'd rather rely on existing limits for virtual and physical memory,
> > and add a proper EPC cgroup to account and limit EPC memory.
> 
> It is better to have a contract in the API that the number of processed
> pages can be less than given, not unlike in syscalls such as write().

That can be handled by a comment, no?  If we want to "enforce" the behavior,
I'd rather bail out of the loop after a random number of pages than have a
completely arbitrary limit.  The arbitrary limit will create a contract of
its own and may lead to weird guest implementations.
