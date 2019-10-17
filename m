Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143B2ECE58D
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 18:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB3C821835
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 18:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438468AbfJQSNK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Oct 2019 14:13:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:56153 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395229AbfJQSNK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 17 Oct 2019 14:13:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 11:13:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="200466061"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 17 Oct 2019 11:13:09 -0700
Date:   Thu, 17 Oct 2019 11:13:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v2? v2 08/14] selftests/harness: Move operator macros
 to their own header file
Message-ID: <20191017181309.GE20903@linux.intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
 <20191017030340.18301-9-sean.j.christopherson@intel.com>
 <20191017165356.GD6667@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017165356.GD6667@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 17, 2019 at 07:53:56PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 16, 2019 at 08:03:34PM -0700, Sean Christopherson wrote:
> > Move the operator macros, ASSERT_* and EXTEND_*, to a standalone header
> > so that they can be reused by other selftests without pulling in the
> > full harness framework, which is cumbersome to use for testing features
> > that require a substantial amount of setup, need callbacks, etc...
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Is it possible to just use a "dull" selftest and not go into this before
> the code is upstreamed? If yes, lets go with that.

It's certainly possible, but the code is verbose and ugly (IMO), which
means it will be harder for other to review.

> Do not mind using frameworky stuff later on. Just trying to avoid new
> intersects with other subsystems, that's all.

Understood, but IMO this particular change is safe-ish:

  - We're already intersecting with selftests
  - The odds of a conflict are very low
  - Andy is already involved in SGX


There are also other options:

  1. Use kselftest_harness.h as-is via #undef __EXPECT.  I actually would
     have gone with this option except the header also defines a function
     and we end up with a compiler error due to an unused function :-(

  2. Upstream the change separately from SGX, similar to the
     FEATURE_CONTROL handling.  E.g. I think the KVM selftests could
     use the operators, so there would even be concrete usage.
