Return-Path: <SRS0=OrTC=YP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CF9CA9EA0
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 22:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36F6E2086D
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 22:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbfJVWl7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Oct 2019 18:41:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:40607 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731850AbfJVWl7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Oct 2019 18:41:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 15:41:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,218,1569308400"; 
   d="scan'208";a="196598121"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 22 Oct 2019 15:41:58 -0700
Date:   Tue, 22 Oct 2019 15:41:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v2? v2 00/14] selftests/x86/sgx: Improve tests
Message-ID: <20191022224158.GB27239@linux.intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
 <20191018101252.GD4835@linux.intel.com>
 <20191018102059.GA6314@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018102059.GA6314@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 18, 2019 at 01:20:59PM +0300, Jarkko Sakkinen wrote:
> On Fri, Oct 18, 2019 at 01:12:52PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 16, 2019 at 08:03:26PM -0700, Sean Christopherson wrote:
> > > The bulk of this series is comprised of the selftest portion of the vDSO
> > > cleanup[*].  The big difference from the full vDSO series is to reuse as
> > > much of the existing selftest code as possible.  There is still a bit of
> > > homebrew code in defining the low level assertion macro, but much less so
> > > than in the previous from-scratch version.
> > > 
> > > Cc'd Andy, who also happens to be a reviewer for the harness code, on the
> > > off chance he has bandwidth to weigh in.
> > > 
> > > Tagged for_v2? to make it clear that this doesn't need to be rushed into
> > > v23.
> > 
> > No need for harness right now. Open coded tests are better for initial
> > upstreaming.
> 
> Macros make code more productive to write but harder to read and
> debug. With only maybe three tests the cost of using them does
> not pay.

Harder to read is debatable, personally I find this

static void test_sgx_basic(struct sgx_secs *secs)
{
	uint64_t result = 0;

	sgx_call_eenter((void *)&MAGIC, &result, (void *)secs->base);
	EXPECT_EQ(result, MAGIC);
}

to be more intuitive than

static void test_sgx_basic(struct sgx_secs *secs)
{
	uint64_t result = 0;

	printf("Input: 0x%lx\n", MAGIC);

	sgx_call_eenter((void *)&MAGIC, &result, (void *)secs->base);
	if (result != MAGIC) {
		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
		exit(1);
	}

	printf("Output: 0x%lx\n", result);
}

but to each his own.

The debug argument I just don't buy.  How is this

  $ ./test_sgx
  TAP version 13
  1..4
  not ok 1 Expected 'result (0) == MAGIC (1234605616436508552)' at main.c:325
  ok 2 test_sgx_vdso: Passed
  ok 3 test_sgx_vdso_exit_handler: Passed
  ok 4 test_sgx_vdso_exception_handler: Passed
  # Pass 3 Fail 1 Xfail 0 Xpass 0 Skip 0 Error 0

 
harder to debug than this?

  $ ./test_sgx
  Input: 0x1122334455667788
  0x0 != 0x1122334455667788

Except for the error status in the shell there's not even an explicit
indicator that something went wrong, let alone any information about
what test was being run, what exact check failed, etc...
