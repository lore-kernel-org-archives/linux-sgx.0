Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23820FA3728
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 20:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 026E221835
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 20:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733089AbfJPUVk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 16:21:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:28178 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732738AbfJPUVk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 16:21:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 13:21:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="199063122"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 16 Oct 2019 13:21:39 -0700
Date:   Wed, 16 Oct 2019 13:21:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 10/16] selftests/x86/sgx: Handle setup failures
 via test assertions
Message-ID: <20191016202139.GA8711@linux.intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
 <20191008044613.12350-11-sean.j.christopherson@intel.com>
 <20191015101635.GA11440@linux.intel.com>
 <20191015102408.GA12061@linux.intel.com>
 <20191015102555.GB12061@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191015102555.GB12061@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
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

I spent a bit of time looking at kselftest_harness.h.  It's simply not
designed to handle testing things like SGX and KVM where the nature of the
thing being tested requires a substantial amount of setup, or where a
non-trivial amount of work is done in a callback, e.g. the guest in KVM
and the vDSO callback in SGX.

And IMO "designed" is a strong word.  The macros are just someone else's
ad hoc code that got hoisted into the top-level selftests directory.

  commit 0b40808a10842131742b1646a465b877a277168a
  Author: Mickaël Salaün <mic@digikod.net>
  Date:   Fri May 26 20:43:56 2017 +0200

    selftests: Make test_harness.h more generally available

    The seccomp/test_harness.h file contains useful helpers to build tests.
    Moving it to the selftest directory should benefit to other test
    components.

    Keep seccomp maintainers for this file.

It's gained two non-seccomp users in the 2+ years since being hoisted, so
it's not exactly a kernel-wide standard.

  seccomp/seccomp_bpf.c:TEST_HARNESS_MAIN
  uevent/uevent_filtering.c:TEST_HARNESS_MAIN
  net/tls.c:TEST_HARNESS_MAIN

The SGX selftest can be massaged/butchered to work with kselftest_harness,
but the error messages are still unhelpful and the resulting code is a
mess.

What I do think makes sense is to use the ksft_test_* helpers that are
provided by kselftest.h.  I'd still like to add ASSERT_* macros to cut
down on the amount of boilerplate code, but the result should be much less
ad hoc than this version.
