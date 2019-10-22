Return-Path: <SRS0=OrTC=YP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8574CA9EA0
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 19:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7433D20B7C
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 19:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbfJVTfn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Oct 2019 15:35:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:8836 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfJVTfn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Oct 2019 15:35:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 12:35:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,217,1569308400"; 
   d="scan'208";a="188007869"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 22 Oct 2019 12:35:30 -0700
Date:   Tue, 22 Oct 2019 12:35:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 12/12] x86/sgx: Reinstate per EPC section free
 page counts
Message-ID: <20191022193530.GL2343@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-13-sean.j.christopherson@intel.com>
 <20191018124942.GC4027@linux.intel.com>
 <20191018143057.GA26319@linux.intel.com>
 <20191021111908.GC7398@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021111908.GC7398@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 21, 2019 at 02:19:08PM +0300, Jarkko Sakkinen wrote:
> On Fri, Oct 18, 2019 at 07:30:57AM -0700, Sean Christopherson wrote:
> > On Fri, Oct 18, 2019 at 03:49:42PM +0300, Jarkko Sakkinen wrote:
> > > On Wed, Oct 16, 2019 at 11:37:45AM -0700, Sean Christopherson wrote:
> > > > Track the free page count on a per EPC section basis so that the value
> > > > is properly protected by the section's spinlock.
> > > > 
> > > > As was pointed out when the change was proposed[*], using a global
> > > > non-atomic counter to track the number of free EPC pages is not safe.
> > > > The order of non-atomic reads and writes are not guaranteed, i.e.
> > > > concurrent RMW operats can write stale data.  This causes a variety
> > > > of bad behavior, e.g. livelocks because the free page count wraps and
> > > > causes the swap thread to stop reclaiming.
> > > > 
> > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > What is the reason not change it just to atomic?
> > 
> > The purpose of separate sections is to avoid bouncing locks and whatnot
> > across packages.  Adding a global atomic to the hotpath defeats that
> > purpose.
> 
> I do get that but it does not actually cause incorrect behaviour,
> right? Not being atomic obivously does because READ part of the
> READ+STORE can get re-ordered.

Haven't tested yet, but it should be functionally correct.  I just don't
understand the motivation for the change to a global free count.  I get
that we don't have any NUMA awareness whatsoever, but if that's the
argument, why bother with the complexity of per-section tracking in the
first place?
