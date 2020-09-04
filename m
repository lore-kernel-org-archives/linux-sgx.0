Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DD7C43461
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 14:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AECA2206B7
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 14:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbgIDOHA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 10:07:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:22220 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbgIDOG4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 10:06:56 -0400
IronPort-SDR: +5w0AWvNX6nPjhBEzOUuLUyU9Cf3rEh2Lu4JOgHeck8/zQrKP1VrOE+fFBsgtQV11zdP1Ggc+a
 17gv1UDMfwXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="158720311"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="158720311"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 07:06:33 -0700
IronPort-SDR: DaenfkeHQ93Q/dj3CRcdz5+9Z0gwZ1SzWScylNmY+mIr7gVtGHZYBe1ADLPtBAaJkYPvk8NS0W
 stELv/WJTscg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="283091021"
Received: from pipper-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.56.104])
  by fmsmga007.fm.intel.com with ESMTP; 04 Sep 2020 07:06:30 -0700
Date:   Fri, 4 Sep 2020 17:06:29 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v37 3/6] x86/vdso: x86/sgx: Introduce dedicated SGX
 exit reasons for vDSO
Message-ID: <20200904140629.GL39023@linux.intel.com>
References: <20200904104437.29555-1-sean.j.christopherson@intel.com>
 <20200904104437.29555-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904104437.29555-4-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 04, 2020 at 03:44:34AM -0700, Sean Christopherson wrote:
> Use dedicated exit reasons, e.g. SYNCHRONOUS and EXCEPTION, instead of
> '0' and '-EFAULT' respectively.  Using -EFAULT is less than desirable as
> it usually means "bad address", which may or may not be true for a fault
> in the enclave or on ENCLU.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I agree with the change but I think this a the main reason for merging
this change: since we have the IO structure it is not coherent to not have
all IO data there that can be put there. Better to have everything in
one place when possible.

Ack-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
