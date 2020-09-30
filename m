Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B854AC4363D
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 23:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A2B220B1F
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 23:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbgI3Xl7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 19:41:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:11519 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731217AbgI3Xl4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 19:41:56 -0400
IronPort-SDR: P6SI+z/xWWdVo03GCPcKwX3BH0lNW4/RaYgMXuBGyW6Qsi4OOnQabcCzrxELzqaFIhtQZAxohf
 ZAmoNxV3YOBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="224180296"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="224180296"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 16:41:52 -0700
IronPort-SDR: CH64TP6DhihJDVCQ6Sf7j6/B5H8vyNUNVVYXitrKTLiapADgHiEwED0cfCVT4x7VSET3xHtSXe
 L9+PNKf77fyg==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="500139467"
Received: from mmarkova-mobl.ger.corp.intel.com (HELO localhost) ([10.249.36.62])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 16:41:48 -0700
Date:   Thu, 1 Oct 2020 02:41:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86/vdso: Remove retpoline from SGX vDSO call
Message-ID: <20200930234145.GA71808@linux.intel.com>
References: <20200930152806.GA52739@linux.intel.com>
 <20200930154349.GB32672@linux.intel.com>
 <17231664-3735-2d57-fbfa-9af838e224ab@intel.com>
 <f5021328-2fab-a404-108f-e28e26e6996c@fortanix.com>
 <cc222137-e488-c48a-ca66-000e74944eea@citrix.com>
 <20200930192541.GA60658@linux.intel.com>
 <741b45d0-3833-4e5d-5974-81634d1b55eb@intel.com>
 <20200930212214.GD65339@linux.intel.com>
 <20200930213625.GA66129@linux.intel.com>
 <bc09f081-d0e8-20dc-350e-c7dbdf077a52@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc09f081-d0e8-20dc-350e-c7dbdf077a52@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 30, 2020 at 02:46:05PM -0700, Dave Hansen wrote:
> On 9/30/20 2:36 PM, Jarkko Sakkinen wrote:
> > 1. Full reptoline is the safest alternative and we have it done already.
> 
> I wouldn't feel _quite_ comfortable saying this.
> 
> LFENCEs have architecturally defined behavior.  Retpolines have zero
> future guarantees in the architecture.  I'll take an LFENCE that (versus
> a retpoline) is:
> 
> 1. Less code
> 2. Never has to be patched
> 3. Never causes functional problems (like with CET)
> 4. Has architectural semantics
> 
> The only advantage retpolines offer is that they have a well-defined
> mitigations on existing microarchitectures.
> 
> To me, an LFENCE is waaaaaaay "safer".

This is a buy-in argument for me.

We know that CET-SS breaks RETPOLINE, which can be solved by applying
boot time patching. However, there could be however many other features
that could conflict with it in yet non-existing microarchitectures,
which would make the patching process tedious to manage over time.

Essentially, we will end up maintaining the backward and forward
compatibility forever in software. That does not sound too motivating,
agreed.

"Plain" LFENCE does not possess this issue as it is fully contained to
the microarchitecture. Thus, software does not have to do anything to
maintain backward and forward compatibility, which means that the SGX
vDSO continues to functionally work even in the old kernel images to
forseeable future.

To summarize, we will use LFENCE as it has overally the best
characteristics for the vDSO when balancing between security and keeping
things functionally working.

Do I have the correct understanding of your argument? Just sanity
checking before I change any part of the code or documentation.

/Jarkko
