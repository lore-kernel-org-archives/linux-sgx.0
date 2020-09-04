Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD90C43461
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 14:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7149020709
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 14:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgIDOLC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 10:11:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:60527 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730661AbgIDOKu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 10:10:50 -0400
IronPort-SDR: QP47nZQ98igF3wPVjRDn+QVsmzk2GhIj3oIQCclNr9Sk1Mj1NkSs5xLlQm8TG4z1emvEr6Q7Hz
 j8PQDj6q4Avg==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="145477143"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="145477143"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 07:10:49 -0700
IronPort-SDR: sJkwTTr5OR6CxcIMGmpKP6jKHfVIid557vgPLVU0iGVEat7PLLNdYxU/sca5qN5hxCK2nHwJPS
 TLalFL/PnQBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="478501286"
Received: from pipper-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.56.104])
  by orsmga005.jf.intel.com with ESMTP; 04 Sep 2020 07:10:48 -0700
Date:   Fri, 4 Sep 2020 17:10:47 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v37 6/6] selftests/sgx: Add a smoke test to ensure
 the user handler is invoked
Message-ID: <20200904141047.GO39023@linux.intel.com>
References: <20200904104437.29555-1-sean.j.christopherson@intel.com>
 <20200904104437.29555-7-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904104437.29555-7-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 04, 2020 at 03:44:37AM -0700, Sean Christopherson wrote:
> Add a very simple exit handler and use it as a third variant of the SGX
> selftest to verify that the vDSO invokes then user's handler when one is
> supplied.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
 
Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I have no concerns of the vDSO code with these changes have been merged.
The way things are structured ('flags' + the fact we have a context
structure 'run' for everything) keeps door open for eBPF (if ever
wanted).

/Jarkko
