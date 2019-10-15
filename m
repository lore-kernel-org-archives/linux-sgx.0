Return-Path: <SRS0=w1Tp=YI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F73AECE588
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Oct 2019 11:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E723218DE
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Oct 2019 11:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbfJOLDu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Oct 2019 07:03:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:55487 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfJOLDu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Oct 2019 07:03:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 04:03:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,299,1566889200"; 
   d="scan'208";a="208161422"
Received: from shacharl-mobl.ger.corp.intel.com (HELO localhost) ([10.252.9.88])
  by fmsmga001.fm.intel.com with ESMTP; 15 Oct 2019 04:03:49 -0700
Date:   Tue, 15 Oct 2019 14:03:48 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 10/16] selftests/x86/sgx: Handle setup failures
 via test assertions
Message-ID: <20191015110339.GA14872@linux.intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
 <20191008044613.12350-11-sean.j.christopherson@intel.com>
 <20191015101635.GA11440@linux.intel.com>
 <20191015102408.GA12061@linux.intel.com>
 <20191015102555.GB12061@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015102555.GB12061@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 15, 2019 at 01:25:55PM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 15, 2019 at 01:24:08PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Oct 15, 2019 at 01:16:35PM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Oct 07, 2019 at 09:46:07PM -0700, Sean Christopherson wrote:
> > > > Use the recently added assertion framework to report errors and exit
> > > > instead of propagating the error back up the stack.  Using assertions
> > > > reduces code and provides more detailed error messages, and has no
> > > > downsides as all errors lead to exit(1) anyways, i.e. an assertion
> > > > isn't blocking forward progress.
> > > > 
> > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > I'm also dropping all of this. Was too hazy with it because of rush last
> > > week.
> > > 
> > > You shoud use EXCEPT_* macros instead of your home baked ones:
> > > 
> > > https://www.kernel.org/doc/html/v4.15/dev-tools/kselftest.html
> > > 
> > > I don't know what you are talking about in this commit message.
> > > "Recently added" tells me absolutely nothing. All I see that you
> > > are adding your own ad hoc crap.
> > 
> > E.g.
> > 
> > 1. WTH the new thing is.
> > 2. Why is it overriding the macros already defined for kselftest
> >    (see the documentation).
> > 3. Before vDSO commits please provide a patch set that does the
> >    migration with clear explanation what is going on.
> 
> See kselftest_harness.h.

For me this all seems like unnecessary stuff done just before patch set
release. It is no in anyway necessary for v23 or even for merging SGX to
mainline. You seriously cannot stuff like this being merged quickly. It
will take a number of days to discuss all this through. My mistake was
to merge it before enough consideration.

Sometimes it is better just to do the *necessary*. Especially when it
is time to release something (e.g. just the minimal changes for vDSO
stuff).

I replaced all of this with v22 selftest and I'm in the process of
adding EENTER call path and splitting that to two commits.

/Jarkko
