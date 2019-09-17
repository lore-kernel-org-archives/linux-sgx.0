Return-Path: <SRS0=2oz+=XM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9830FC4CECD
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Sep 2019 19:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7769C214AF
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Sep 2019 19:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbfIQTIf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Sep 2019 15:08:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:43021 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfIQTIf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Sep 2019 15:08:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 12:08:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,517,1559545200"; 
   d="scan'208";a="198790010"
Received: from vcazacux-wtg.ger.corp.intel.com (HELO localhost) ([10.252.38.72])
  by orsmga002.jf.intel.com with ESMTP; 17 Sep 2019 12:08:32 -0700
Date:   Tue, 17 Sep 2019 22:08:31 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH v2 00/17] v23 updates
Message-ID: <20190917190752.GF10244@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
 <20190916075806.GB26608@linux.intel.com>
 <20190916080143.GA27356@linux.intel.com>
 <20190916183742.GK18871@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916183742.GK18871@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 16, 2019 at 11:37:43AM -0700, Sean Christopherson wrote:
> On Mon, Sep 16, 2019 at 11:01:43AM +0300, Jarkko Sakkinen wrote:
> > On Mon, Sep 16, 2019 at 10:58:06AM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Sep 16, 2019 at 07:14:00AM +0300, Jarkko Sakkinen wrote:
> > > > My flush of updates for v23. Contains a bunch of clean ups and bug
> > > > fixes with the main focus on the page reclaimer. The main goal has
> > > > been to disclose all the other possibilities for failure after
> > > > ENCLS[EBLOCK] other than EPCM conflict when the whole EPC is
> > > > invalidated.
> > > 
> > > I have at least one more update to the reclaimer but want to merge these
> > > first.
> > > 
> > > It adds optional struct epc_page **reclaimed_page to
> > > sgx_reclaim_pages(). If NULL, the function will just append everything
> > > to the free pool. Otherwise, it will use it to return one of the
> > > reclaimed pages if there are any.
> > > 
> > > sgx_alloc_page() then does the following when @reclaim=true:
> > > 
> > > 1. If page in free page pool, take one.
> > > 2. If not, try to reclaim one.
> > > 3. If nothing was reclaimed -ENOMEM.
> > > 
> > > Right now sgx_alloc_page() can in theory take however long.
> > > 
> > > I wonder why we do not return -ENOMEM also when @reclaim=false. Where
> > > did this returning -EBUSY came from? Can't recall.
> > 
> > Checked. I guess it is just for ELDU flow but does not make sense
> > otherwise. Tuning sgx_vma_fault() should be enough. I mean with
> > the above change we would start to return -EBUSY sometimes in
> > OOM situations.
> 
> Returning -EBUSY is done to differentiate between the case where reclaim
> is possible, i.e. sgx_active_page_list is *not* empty, but disallowed, and
> the case where reclaim is impossible, i.e. sgx_active_page_list is empty.
> If reclaim is impossible then the fault handler should signal SIGSEGV so
> that processes start dying and/or killing enclaves to free up EPC.
> 
> Barring a kernel bug, I don't think it's possible for sgx_active_page_list
> to be empty when only the driver is supported, but both KVM and EPC cgroup
> support will introduce (relatively common) scenarios where there are no
> pages on the active/reclaimable list.  Technically we probably don't need
> the -EBUSY logic, but my vote is to keep it since it's a nice fallback in
> case there are kernel bugs.

OK, my root question is I guess, why want to differentiate those cases?
Both are as far as I'm concerned situations where there is no memory
available.

And now my changes after these patches add yet another case: active
page list was not empty but nothing could be reclaimed. Is the
granularity really needed for something here?

/Jarkko
