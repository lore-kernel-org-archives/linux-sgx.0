Return-Path: <SRS0=T+5Q=YO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602DBCA9EAF
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Oct 2019 11:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38F822084C
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Oct 2019 11:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfJULTK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Oct 2019 07:19:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:33149 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfJULTK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Oct 2019 07:19:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 04:19:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,323,1566889200"; 
   d="scan'208";a="222429391"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.130])
  by fmsmga004.fm.intel.com with ESMTP; 21 Oct 2019 04:19:08 -0700
Date:   Mon, 21 Oct 2019 14:19:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 12/12] x86/sgx: Reinstate per EPC section free
 page counts
Message-ID: <20191021111908.GC7398@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-13-sean.j.christopherson@intel.com>
 <20191018124942.GC4027@linux.intel.com>
 <20191018143057.GA26319@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018143057.GA26319@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 18, 2019 at 07:30:57AM -0700, Sean Christopherson wrote:
> On Fri, Oct 18, 2019 at 03:49:42PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 16, 2019 at 11:37:45AM -0700, Sean Christopherson wrote:
> > > Track the free page count on a per EPC section basis so that the value
> > > is properly protected by the section's spinlock.
> > > 
> > > As was pointed out when the change was proposed[*], using a global
> > > non-atomic counter to track the number of free EPC pages is not safe.
> > > The order of non-atomic reads and writes are not guaranteed, i.e.
> > > concurrent RMW operats can write stale data.  This causes a variety
> > > of bad behavior, e.g. livelocks because the free page count wraps and
> > > causes the swap thread to stop reclaiming.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > What is the reason not change it just to atomic?
> 
> The purpose of separate sections is to avoid bouncing locks and whatnot
> across packages.  Adding a global atomic to the hotpath defeats that
> purpose.

I do get that but it does not actually cause incorrect behaviour,
right? Not being atomic obivously does because READ part of the
READ+STORE can get re-ordered.

> Can't the sysfs read helper aggregate the info?

Sure.

/Jarkko
