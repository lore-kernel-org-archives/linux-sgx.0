Return-Path: <SRS0=OrTC=YP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8C1CA9EA0
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 03:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14F7E2173B
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 03:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbfJVDUI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Oct 2019 23:20:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:57153 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730156AbfJVDUI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Oct 2019 23:20:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 20:20:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="201545189"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 21 Oct 2019 20:20:07 -0700
Date:   Mon, 21 Oct 2019 20:20:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v2? v2 08/14] selftests/harness: Move operator macros
 to their own header file
Message-ID: <20191022032007.GB32147@linux.intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
 <20191017030340.18301-9-sean.j.christopherson@intel.com>
 <20191017165356.GD6667@linux.intel.com>
 <20191017181309.GE20903@linux.intel.com>
 <20191021110823.GB7398@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021110823.GB7398@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 21, 2019 at 02:08:23PM +0300, Jarkko Sakkinen wrote:
> On Thu, Oct 17, 2019 at 11:13:09AM -0700, Sean Christopherson wrote:
> > On Thu, Oct 17, 2019 at 07:53:56PM +0300, Jarkko Sakkinen wrote:
> > > On Wed, Oct 16, 2019 at 08:03:34PM -0700, Sean Christopherson wrote:
> > > > Move the operator macros, ASSERT_* and EXTEND_*, to a standalone header
> > > > so that they can be reused by other selftests without pulling in the
> > > > full harness framework, which is cumbersome to use for testing features
> > > > that require a substantial amount of setup, need callbacks, etc...
> > > > 
> > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > Is it possible to just use a "dull" selftest and not go into this before
> > > the code is upstreamed? If yes, lets go with that.
> > 
> > It's certainly possible, but the code is verbose and ugly (IMO), which
> > means it will be harder for other to review.
> 
> Ok, I'll try to explain in more verbose terms how I see this.
> 
> Not all selftests use the harness and I'm not yet confident that SGX has
> to. Unfortunately, ugly is for me something that I cannot put metrics
> on. Also, often "ugly" is actually better than layering because it is
> more transparent.
> 
> The test is comprised of simple POSIX calls that everyone knows whereas
> using kselftest harness requires learning new framework. Less macros
> makes code also easier to debug and pair compare to dissembly when
> required. I've done the latter at least a few times.
> 
> It will also add a requirement for code reviewers who are simply looking
> for a code example how SGX works also to learn the harness. In the scope
> of the patch set the selftest serves as a such example.

Eh, if SGX were actually using any of the harness stuff, sure, but I'd
hope most reviewers intuitively understand what ASSERT_EQ does.
