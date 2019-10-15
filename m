Return-Path: <SRS0=w1Tp=YI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D58C10F14
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Oct 2019 16:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D26BB2064A
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Oct 2019 16:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfJOQSk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Oct 2019 12:18:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:36902 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbfJOQSk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Oct 2019 12:18:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 09:18:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="198656169"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 15 Oct 2019 09:18:39 -0700
Date:   Tue, 15 Oct 2019 09:18:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 10/16] selftests/x86/sgx: Handle setup failures
 via test assertions
Message-ID: <20191015161838.GD15015@linux.intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
 <20191008044613.12350-11-sean.j.christopherson@intel.com>
 <20191015101635.GA11440@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015101635.GA11440@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 15, 2019 at 01:16:35PM +0300, Jarkko Sakkinen wrote:
> On Mon, Oct 07, 2019 at 09:46:07PM -0700, Sean Christopherson wrote:
> > Use the recently added assertion framework to report errors and exit
> > instead of propagating the error back up the stack.  Using assertions
> > reduces code and provides more detailed error messages, and has no
> > downsides as all errors lead to exit(1) anyways, i.e. an assertion
> > isn't blocking forward progress.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> I'm also dropping all of this. Was too hazy with it because of rush last
> week.
> 
> You shoud use EXCEPT_* macros instead of your home baked ones:
> 
> https://www.kernel.org/doc/html/v4.15/dev-tools/kselftest.html
> 
> I don't know what you are talking about in this commit message.
> "Recently added" tells me absolutely nothing.

It's a fairly common way to refer to changes introduced in prior patches
of the same series.

> All I see that you are adding your own ad hoc crap.

Yo, same team.  A simple "hey, there's already macros for this!" would
suffice.
