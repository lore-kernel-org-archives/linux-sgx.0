Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6713DC4360C
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 10:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A30B20872
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 10:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfJPKTO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 06:19:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:43808 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727167AbfJPKTN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 06:19:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 03:19:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,303,1566889200"; 
   d="scan'208";a="186107236"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.130])
  by orsmga007.jf.intel.com with ESMTP; 16 Oct 2019 03:19:11 -0700
Date:   Wed, 16 Oct 2019 13:19:10 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 10/16] selftests/x86/sgx: Handle setup failures
 via test assertions
Message-ID: <20191016101910.GB8964@linux.intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
 <20191008044613.12350-11-sean.j.christopherson@intel.com>
 <20191015101635.GA11440@linux.intel.com>
 <20191015161838.GD15015@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015161838.GD15015@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 15, 2019 at 09:18:39AM -0700, Sean Christopherson wrote:
> On Tue, Oct 15, 2019 at 01:16:35PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Oct 07, 2019 at 09:46:07PM -0700, Sean Christopherson wrote:
> > > Use the recently added assertion framework to report errors and exit
> > > instead of propagating the error back up the stack.  Using assertions
> > > reduces code and provides more detailed error messages, and has no
> > > downsides as all errors lead to exit(1) anyways, i.e. an assertion
> > > isn't blocking forward progress.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > I'm also dropping all of this. Was too hazy with it because of rush last
> > week.
> > 
> > You shoud use EXCEPT_* macros instead of your home baked ones:
> > 
> > https://www.kernel.org/doc/html/v4.15/dev-tools/kselftest.html
> > 
> > I don't know what you are talking about in this commit message.
> > "Recently added" tells me absolutely nothing.
> 
> It's a fairly common way to refer to changes introduced in prior patches
> of the same series.
> 
> > All I see that you are adding your own ad hoc crap.
> 
> Yo, same team.  A simple "hey, there's already macros for this!" would
> suffice.

Since apologies, was over the top with this.

/Jarkko
