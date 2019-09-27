Return-Path: <SRS0=CuW6=XW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E831C4360C
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 15:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40ABA217D9
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 15:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfI0PoT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Sep 2019 11:44:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:52313 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727518AbfI0PoS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 27 Sep 2019 11:44:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 08:44:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,556,1559545200"; 
   d="scan'208";a="214872319"
Received: from mdauner2-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.39.118])
  by fmsmga004.fm.intel.com with ESMTP; 27 Sep 2019 08:44:16 -0700
Date:   Fri, 27 Sep 2019 18:44:15 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     greg@enjellic.com
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, shay.katz-zamir@intel.com,
        serge.ayoun@intel.com
Subject: Re: SGX release branch.
Message-ID: <20190927154415.GH10545@linux.intel.com>
References: <sean.j.christopherson@intel.com>
 <201909261742.x8QHgO7N023930@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201909261742.x8QHgO7N023930@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 26, 2019 at 12:42:24PM -0500, Dr. G.W. Wettstein wrote:
> On Sep 19,  1:00pm, Sean Christopherson wrote:
> } Subject: Re: SGX release branch.
> 
> Good day to everyone.
> 
> > On Thu, Sep 19, 2019 at 09:50:30AM -0500, Dr. G.W. Wettstein wrote:
> > > It would be perhaps helpful for everyone if we could have a quick
> > > summary of what the remote branches in jarkko-sgx are are targeting.
> > 
> > I recommend ignoring everything except jarkko/master.  master isn't
> > necessarily the bleeding edge, but it's the canonical reference with
> > respect to changes that have passed internal review, and for the most part
> > it is stable (there have been a few hiccups).
> 
> > All other branches in Jarkko's repository are either unrelated to
> > the initial upstreaming and/or are for Jarkko's own development.
> 
> Thank you for the clarifications.
> 
> Is it just us or is there something up with the history on these
> branches?
> 
> We have a local tracking branch that was created on a previous
> instance of jarkko-sgx/master that doesn't bear any resemblance to the
> current state of jarkko-sgx/master.  The version that we had branched
> against had the driver broken into a core and driver component, the
> driver was in a sub-directory of the core SGX code and could be built
> as a module.
> 
> We created a new tracking branch against the current jarkko-sgx/master
> and the driver architecture is completely different.  Most notably the
> driver cannot be built as a module and there is no driver
> sub-directory.
> 
> We have also also universally had pull's end up with merge conflicts,
> even when there have been no changes to the local branch.
> 
> I'm assuming now, given the comments above, that moving forward
> jarkko-sgx/master will be a continuous development history?

It cannot be because it is a snapshot of the next version of the
patch set. Anything can change all the time.

/Jarkko
