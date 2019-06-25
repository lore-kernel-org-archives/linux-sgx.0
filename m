Return-Path: <SRS0=BFWe=UY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6B8C48BD4
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 16:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5723208E3
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 16:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfFYQ3t (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jun 2019 12:29:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:56418 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbfFYQ3t (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 25 Jun 2019 12:29:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 09:29:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,416,1557212400"; 
   d="scan'208";a="360011113"
Received: from pkoeberl-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.33.126])
  by fmsmga005.fm.intel.com with ESMTP; 25 Jun 2019 09:29:46 -0700
Date:   Tue, 25 Jun 2019 19:29:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v3 00/12] security: x86/sgx: SGX vs. LSM, round 3
Message-ID: <20190625162945.GB7046@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617222438.2080-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 17, 2019 at 03:24:26PM -0700, Sean Christopherson wrote:

Since you are gone up until end of next week, I'm going to do some
proactive work and for those patches that I only had some feedback
concerning how the code is written etc. I'll just fix those myself and
squash. You can check when you're back and send me follow ups if you
disagree on something I made.

I'll also try to extract *only* the SRCU part from [1] and squash that
to my tree. The main reason is that I want to do my RFC for enclave
life-cycle handling on the same codebase so that we can compare and
make the best possible decision on that.

[1] https://patchwork.kernel.org/patch/11005495/

/Jarkko
