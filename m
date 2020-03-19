Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C13C4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 02:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B612076E
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 02:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgCSCwd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 22:52:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:47727 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCSCwd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 22:52:33 -0400
IronPort-SDR: zxnC4Xe16NU9ovL0XI7hqMBKnhta6tiayvQ4PswHJNvrZDbEgZAegrrkZwrMbooe/ZjXrhrYtS
 CYsBlMx8fejQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 19:52:32 -0700
IronPort-SDR: C5pO5Tf6l6tZgHEVTZjaWSOrFb6QIDvi4LgRW3sWMlnSLe1/KQ/3FVaUiVmEIX8CWPKYibT/6a
 LyP/IwTRAX6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="391658591"
Received: from oshikbit-mobl.ger.corp.intel.com (HELO localhost) ([10.214.196.145])
  by orsmga004.jf.intel.com with ESMTP; 18 Mar 2020 19:52:29 -0700
Date:   Thu, 19 Mar 2020 04:52:28 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] selftests/x86: Generate an RSA key on fly
Message-ID: <20200319025228.GA7792@linux.intel.com>
References: <20200319023306.6875-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319023306.6875-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 19, 2020 at 04:33:06AM +0200, Jarkko Sakkinen wrote:
> Modify the signing tool to generate an RSA key on fly because that is
> require for the selftest.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

The bigger idea is to combine sgxsign and the test program. The enclave
can be measured and sigstruct can be calculated in the exact same loop.

After this change has been merged it is somewhat trivial change to do.

This results way way more robust test program (e.g. easy to generate
dynamically enclaves of different sizes).

/Jarkko
