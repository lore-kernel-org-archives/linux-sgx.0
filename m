Return-Path: <SRS0=5L1B=YL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77F5CA9EA0
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 10:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1923222CC
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 10:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633218AbfJRKM5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Oct 2019 06:12:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:48340 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392659AbfJRKM5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Oct 2019 06:12:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 03:12:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="397890994"
Received: from glas-mobl.ger.corp.intel.com (HELO localhost) ([10.252.17.198])
  by fmsmga006.fm.intel.com with ESMTP; 18 Oct 2019 03:12:54 -0700
Date:   Fri, 18 Oct 2019 13:12:52 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v2? v2 00/14] selftests/x86/sgx: Improve tests
Message-ID: <20191018101252.GD4835@linux.intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017030340.18301-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 16, 2019 at 08:03:26PM -0700, Sean Christopherson wrote:
> The bulk of this series is comprised of the selftest portion of the vDSO
> cleanup[*].  The big difference from the full vDSO series is to reuse as
> much of the existing selftest code as possible.  There is still a bit of
> homebrew code in defining the low level assertion macro, but much less so
> than in the previous from-scratch version.
> 
> Cc'd Andy, who also happens to be a reviewer for the harness code, on the
> off chance he has bandwidth to weigh in.
> 
> Tagged for_v2? to make it clear that this doesn't need to be rushed into
> v23.

No need for harness right now. Open coded tests are better for initial
upstreaming.

/Jarkko
