Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91FBECE58E
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 16:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B63C720872
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 16:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436732AbfJQQyP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Oct 2019 12:54:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:12260 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436683AbfJQQyP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 17 Oct 2019 12:54:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 09:54:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="195216621"
Received: from eshoguli-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.19.56])
  by fmsmga008.fm.intel.com with ESMTP; 17 Oct 2019 09:53:57 -0700
Date:   Thu, 17 Oct 2019 19:53:56 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v2? v2 08/14] selftests/harness: Move operator macros
 to their own header file
Message-ID: <20191017165356.GD6667@linux.intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
 <20191017030340.18301-9-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017030340.18301-9-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 16, 2019 at 08:03:34PM -0700, Sean Christopherson wrote:
> Move the operator macros, ASSERT_* and EXTEND_*, to a standalone header
> so that they can be reused by other selftests without pulling in the
> full harness framework, which is cumbersome to use for testing features
> that require a substantial amount of setup, need callbacks, etc...
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Is it possible to just use a "dull" selftest and not go into this before
the code is upstreamed? If yes, lets go with that. Do not mind using
frameworky stuff later on. Just trying to avoid new intersects with
other subsystems, that's all.

/Jarkko
