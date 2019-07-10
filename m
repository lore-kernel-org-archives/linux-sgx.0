Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924BBC73C65
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 01:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B3C72081C
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 01:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfGJB2g (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Jul 2019 21:28:36 -0400
Received: from wind.enjellic.com ([76.10.64.91]:37620 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfGJB2g (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Jul 2019 21:28:36 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x6A1SDne018849;
        Tue, 9 Jul 2019 20:28:13 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x6A1SBCa018848;
        Tue, 9 Jul 2019 20:28:11 -0500
Date:   Tue, 9 Jul 2019 20:28:11 -0500
From:   "Dr. Greg" <greg@idfusion.net>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
Message-ID: <20190710012811.GA18755@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@idfusion.net>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com> <20190705160549.tzsck5ho5kvtdhit@linux.intel.com> <20190708172930.GA20791@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708172930.GA20791@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 09 Jul 2019 20:28:13 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 08, 2019 at 10:29:30AM -0700, Sean Christopherson wrote:

Good evening to everyone.

> That being said, we can do so without functional changes to the SGX
> uapi, e.g. add reserved fields so that the initial uapi can be
> extended *if* we decide to go with the "userspace provides maximal
> protections" path, and use the EPCM permissions as the maximal
> protections for the initial upstreaming.
>
> That'd give us a minimal implemenation for initial upstreaming and
> would eliminate Cedric's blocking complaint.  The "whole mess" of
> whitelisting, blacklisting and SGX2 support would be deferred until
> post-upstreaming.

Are we convinced the 'mess' will be any easier to clean up after the
driver is upstreamed?

The primary problem is that we haven't addressed the issue of what
this technology is designed to do and its implications with respect to
the kernel.  As a result we are attempting to implement controls which
we are comfortable with and understand rather then those that are
relevant.

Have a good evening.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC               Implementing SGX secured and modeled
4206 N. 19th Ave.           intelligent network endpoints.
Fargo, ND  58102
PH: 701-281-1686            EMAIL: greg@idfusion.net
------------------------------------------------------------------------------
"Courage is not the absence of fear, but rather the judgement that
 something else is more important than fear."
                                -- Ambrose Redmoon
