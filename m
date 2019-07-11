Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7D0C74A4B
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 10:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B302320872
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 10:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfGKKXP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 06:23:15 -0400
Received: from wind.enjellic.com ([76.10.64.91]:37774 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727680AbfGKKXP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 06:23:15 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x6BAMmCp005541;
        Thu, 11 Jul 2019 05:22:48 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x6BAMlGN005540;
        Thu, 11 Jul 2019 05:22:47 -0500
Date:   Thu, 11 Jul 2019 05:22:47 -0500
From:   "Dr. Greg" <greg@idfusion.net>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <stephen.smalley@gmail.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Message-ID: <20190711102247.GA5357@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@idfusion.net>
References: <960B34DE67B9E140824F1DCDEC400C0F6551D585@ORSMSX116.amr.corp.intel.com> <f59529e4-6cc8-2405-d7db-2519727f9a80@schaufler-ca.com> <960B34DE67B9E140824F1DCDEC400C0F6551D7F7@ORSMSX116.amr.corp.intel.com> <63c92ab6-dc8d-826b-b8bf-05ad262f06e4@schaufler-ca.com> <960B34DE67B9E140824F1DCDEC400C0F6551DBF7@ORSMSX116.amr.corp.intel.com> <9e45df1b-3aac-e851-4ef2-5b262f5139bd@schaufler-ca.com> <20190703094651.GA29601@wind.enjellic.com> <012fc47d-4e9d-3398-0d9d-d9298a758c8d@schaufler-ca.com> <20190707133023.GA4521@wind.enjellic.com> <256013f7-292d-7014-9abb-61755f07eb25@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <256013f7-292d-7014-9abb-61755f07eb25@schaufler-ca.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 11 Jul 2019 05:22:49 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 08, 2019 at 05:02:00PM -0700, Casey Schaufler wrote:

> > On 7/7/2019 6:30 AM, Dr. Greg wrote:
> > All well taken points from an implementation perspective, but they
> > elide the point I was trying to make.  Which is the fact that without
> > any semblance of a discussion regarding the requirements needed to
> > implement a security architecture around the concept of a TEE, this
> > entire process, despite Cedric's well intentioned efforts, amounts to
> > pounding a square solution into the round hole of a security problem.

> Lead with code. I love a good requirements document, but one of the
> few places where I agree with the agile folks is that working code
> speaks loudly.
>
> > Which, as I noted in my e-mail, is tantamount to security theater.
> 
> Not buying that. Not rejecting it, either. Without code
> to judge it's kind of hard to say.

We tried the code approach.

By most accounts it seemed to go poorly, given that it ended up with
Jonathan Corbet writing an LWN feature article on the state of
dysfunction and chaos surrounding Linux SGX driver development.

So we are standing around and mumbling until we can figure out what
kind of code we need to write to make the new driver relevant to the
CISO's and security architects we need to defend SGX to.

Have a good week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC               Implementing SGX secured and modeled
4206 N. 19th Ave.           intelligent network endpoints.
Fargo, ND  58102
PH: 701-281-1686            EMAIL: greg@idfusion.net
------------------------------------------------------------------------------
"Five year projections, are you kidding me.  We don't know what we are
 supposed to be doing at the 4 o'clock meeting this afternoon."
                                -- Terry Wieland
                                   Resurrection
