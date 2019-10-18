Return-Path: <SRS0=5L1B=YL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26F9CA9EA0
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 12:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97947222C2
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 12:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393019AbfJRMzZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Oct 2019 08:55:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:45406 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbfJRMzZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Oct 2019 08:55:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 05:55:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="221731964"
Received: from jlenoir-mobl.ger.corp.intel.com (HELO localhost) ([10.252.2.252])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2019 05:55:22 -0700
Date:   Fri, 18 Oct 2019 15:55:21 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 12/12] x86/sgx: Reinstate per EPC section free
 page counts
Message-ID: <20191018125521.GD4027@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-13-sean.j.christopherson@intel.com>
 <20191018124942.GC4027@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018124942.GC4027@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 18, 2019 at 03:49:42PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 16, 2019 at 11:37:45AM -0700, Sean Christopherson wrote:
> > Track the free page count on a per EPC section basis so that the value
> > is properly protected by the section's spinlock.
> > 
> > As was pointed out when the change was proposed[*], using a global
> > non-atomic counter to track the number of free EPC pages is not safe.
> > The order of non-atomic reads and writes are not guaranteed, i.e.
> > concurrent RMW operats can write stale data.  This causes a variety
> > of bad behavior, e.g. livelocks because the free page count wraps and
> > causes the swap thread to stop reclaiming.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> What is the reason not change it just to atomic?
> 
> For debugging the global is useful because it could be exposed
> as a sysfs file.

So the regression is that counter updates is read + store (was not btw
described in the commit message what the regression you are speaking
of, which means that I'm making a guess myself).

This means that changing the variable to atomic should be IMHO
sufficient.

/Jarkko
