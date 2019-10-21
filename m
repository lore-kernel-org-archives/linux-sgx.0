Return-Path: <SRS0=T+5Q=YO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474F8C47E49
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Oct 2019 11:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DEF720B7C
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Oct 2019 11:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbfJULI1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Oct 2019 07:08:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:63304 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfJULI0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Oct 2019 07:08:26 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 04:08:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,323,1566889200"; 
   d="scan'208";a="203306813"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.130])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Oct 2019 04:08:24 -0700
Date:   Mon, 21 Oct 2019 14:08:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v2? v2 08/14] selftests/harness: Move operator macros
 to their own header file
Message-ID: <20191021110823.GB7398@linux.intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
 <20191017030340.18301-9-sean.j.christopherson@intel.com>
 <20191017165356.GD6667@linux.intel.com>
 <20191017181309.GE20903@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017181309.GE20903@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 17, 2019 at 11:13:09AM -0700, Sean Christopherson wrote:
> On Thu, Oct 17, 2019 at 07:53:56PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 16, 2019 at 08:03:34PM -0700, Sean Christopherson wrote:
> > > Move the operator macros, ASSERT_* and EXTEND_*, to a standalone header
> > > so that they can be reused by other selftests without pulling in the
> > > full harness framework, which is cumbersome to use for testing features
> > > that require a substantial amount of setup, need callbacks, etc...
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Is it possible to just use a "dull" selftest and not go into this before
> > the code is upstreamed? If yes, lets go with that.
> 
> It's certainly possible, but the code is verbose and ugly (IMO), which
> means it will be harder for other to review.

Ok, I'll try to explain in more verbose terms how I see this.

Not all selftests use the harness and I'm not yet confident that SGX has
to. Unfortunately, ugly is for me something that I cannot put metrics
on. Also, often "ugly" is actually better than layering because it is
more transparent.

The test is comprised of simple POSIX calls that everyone knows whereas
using kselftest harness requires learning new framework. Less macros
makes code also easier to debug and pair compare to dissembly when
required. I've done the latter at least a few times.

It will also add a requirement for code reviewers who are simply looking
for a code example how SGX works also to learn the harness. In the scope
of the patch set the selftest serves as a such example.

/Jarkko
