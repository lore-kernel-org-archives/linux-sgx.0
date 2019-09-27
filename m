Return-Path: <SRS0=CuW6=XW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97B9C4360C
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 14:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5DA9217D9
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 14:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfI0O5n (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Sep 2019 10:57:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:45385 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727319AbfI0O5n (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 27 Sep 2019 10:57:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 07:57:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="204177594"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 27 Sep 2019 07:57:41 -0700
Date:   Fri, 27 Sep 2019 07:57:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     greg@enjellic.com
Cc:     linux-sgx@vger.kernel.org, jarkko.sakkinen@linux.intel.com,
        shay.katz-zamir@intel.com, serge.ayoun@intel.com
Subject: Re: SGX release branch.
Message-ID: <20190927145741.GA25513@linux.intel.com>
References: <sean.j.christopherson@intel.com>
 <201909261742.x8QHgO7N023930@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201909261742.x8QHgO7N023930@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 26, 2019 at 12:42:24PM -0500, Dr. G.W. Wettstein wrote:
> On Sep 19,  1:00pm, Sean Christopherson wrote:
> } Subject: Re: SGX release branch.

Shouldn't this be an opening brace?  :-)

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

Not just you, the branches, including master, are deliberately rebased
and rewritten.

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

master will become stable when SGX is merged into the mainline kernel.
Until then, the reality is that we need rebase on the latest upstream,
squash commits, and rewrite history to prep the series for submission.

I agree that a complete history would be convenient, but keeping such a
branch perferctly aligned with master would incur a non-trivial amount of
overhead, and anything but 100% accuracy would do more harm than good.

> Have a good remainder of the week.
> 
> Dr. Greg
> 
> }-- End of excerpt from Sean Christopherson
> 
> As always,
> Dr. Greg Wettstein, Ph.D, Worker
> IDfusion, LLC               SGX secured infrastructure and
> 4206 N. 19th Ave.           autonomously self-defensive platforms.
> Fargo, ND  58102
> PH: 701-281-1686            EMAIL: greg@idfusion.net
> ------------------------------------------------------------------------------
> "Courage is not the absence of fear, but rather the judgement that
>  something else is more important than fear."
>                                 -- Ambrose Redmoon
