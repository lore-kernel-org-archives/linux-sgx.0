Return-Path: <SRS0=9Y++=XV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB046C352A9
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Sep 2019 17:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A11222C6
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Sep 2019 17:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfIZRmh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Sep 2019 13:42:37 -0400
Received: from wind.enjellic.com ([76.10.64.91]:43814 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727824AbfIZRmh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 26 Sep 2019 13:42:37 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x8QHgPKl023931;
        Thu, 26 Sep 2019 12:42:25 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x8QHgO7N023930;
        Thu, 26 Sep 2019 12:42:24 -0500
Date:   Thu, 26 Sep 2019 12:42:24 -0500
From:   "Dr. G.W. Wettstein" <greg@wind.enjellic.com>
Message-Id: <201909261742.x8QHgO7N023930@wind.enjellic.com>
In-Reply-To: Sean Christopherson <sean.j.christopherson@intel.com>
       "Re: SGX release branch." (Sep 19,  1:00pm)
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.6-ESD1.0 03/31/2012)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: SGX release branch.
Cc:     linux-sgx@vger.kernel.org, jarkko.sakkinen@linux.intel.com,
        shay.katz-zamir@intel.com, serge.ayoun@intel.com
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 26 Sep 2019 12:42:25 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sep 19,  1:00pm, Sean Christopherson wrote:
} Subject: Re: SGX release branch.

Good day to everyone.

> On Thu, Sep 19, 2019 at 09:50:30AM -0500, Dr. G.W. Wettstein wrote:
> > It would be perhaps helpful for everyone if we could have a quick
> > summary of what the remote branches in jarkko-sgx are are targeting.
> 
> I recommend ignoring everything except jarkko/master.  master isn't
> necessarily the bleeding edge, but it's the canonical reference with
> respect to changes that have passed internal review, and for the most part
> it is stable (there have been a few hiccups).

> All other branches in Jarkko's repository are either unrelated to
> the initial upstreaming and/or are for Jarkko's own development.

Thank you for the clarifications.

Is it just us or is there something up with the history on these
branches?

We have a local tracking branch that was created on a previous
instance of jarkko-sgx/master that doesn't bear any resemblance to the
current state of jarkko-sgx/master.  The version that we had branched
against had the driver broken into a core and driver component, the
driver was in a sub-directory of the core SGX code and could be built
as a module.

We created a new tracking branch against the current jarkko-sgx/master
and the driver architecture is completely different.  Most notably the
driver cannot be built as a module and there is no driver
sub-directory.

We have also also universally had pull's end up with merge conflicts,
even when there have been no changes to the local branch.

I'm assuming now, given the comments above, that moving forward
jarkko-sgx/master will be a continuous development history?

Have a good remainder of the week.

Dr. Greg

}-- End of excerpt from Sean Christopherson

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC               SGX secured infrastructure and
4206 N. 19th Ave.           autonomously self-defensive platforms.
Fargo, ND  58102
PH: 701-281-1686            EMAIL: greg@idfusion.net
------------------------------------------------------------------------------
"Courage is not the absence of fear, but rather the judgement that
 something else is more important than fear."
                                -- Ambrose Redmoon
