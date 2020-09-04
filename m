Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15199C2D0A7
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 14:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E90D8206B8
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 14:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgIDOIJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 10:08:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:10808 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbgIDOHo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 10:07:44 -0400
IronPort-SDR: 77XuXXzkvf9B6HTIycXpa5fgJ3X/TFBHyhG6UDMXJj5TO9KWEzDx/k6EsmSLR2PE5ann8szbQX
 3L6c32AtysUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="242563546"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="242563546"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 07:07:25 -0700
IronPort-SDR: AwY5rOWzRdxdr22mvPBgmPa3sIddaoUGU4zkf+xwIkhiygTqlvhL/k4CuWCiw9DhCFDeYod8ws
 /e+t4KwsmsTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="315849128"
Received: from pipper-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.56.104])
  by orsmga002.jf.intel.com with ESMTP; 04 Sep 2020 07:07:23 -0700
Date:   Fri, 4 Sep 2020 17:07:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v37 4/6] selftests/sgx: Update the SGX selftest to
 match the reworked vDSO API
Message-ID: <20200904140723.GM39023@linux.intel.com>
References: <20200904104437.29555-1-sean.j.christopherson@intel.com>
 <20200904104437.29555-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904104437.29555-5-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 04, 2020 at 03:44:35AM -0700, Sean Christopherson wrote:
> Update the call to __vdso_sgx_enter_enclave() to use the sgx_enclave_run
> struct instead of cramming parameters into the function call itself.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
