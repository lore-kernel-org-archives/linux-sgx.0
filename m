Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6079FC4363D
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 21:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2878A2075F
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 21:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbgI3VW0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:22:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:28537 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730338AbgI3VWZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 17:22:25 -0400
IronPort-SDR: byye6vxbfoHPv2yQ68ZR8DO56busUywU6uYKnmPToFa5VhHI1eokWvsz+MyoBLNBJbmpsbJOfu
 FjrxlxwFT2rw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="247276284"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="247276284"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 14:22:20 -0700
IronPort-SDR: dpoDE9ggtGypIzpFpNsvOYmemY97Tw9vfJzbxWWU+Ry1dzgcTvVYArWO5USugn/Aj68ZUrLn1U
 +BF81rZWgcCg==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="499551226"
Received: from petrescv-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.36.73])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 14:22:16 -0700
Date:   Thu, 1 Oct 2020 00:22:14 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86/vdso: Remove retpoline from SGX vDSO call
Message-ID: <20200930212214.GD65339@linux.intel.com>
References: <92578646-83a4-606c-b251-4d80cb62399c@intel.com>
 <20200930142017.GA49393@linux.intel.com>
 <112ad81e-16ab-d6e0-09e7-3658874434f7@intel.com>
 <20200930152806.GA52739@linux.intel.com>
 <20200930154349.GB32672@linux.intel.com>
 <17231664-3735-2d57-fbfa-9af838e224ab@intel.com>
 <f5021328-2fab-a404-108f-e28e26e6996c@fortanix.com>
 <cc222137-e488-c48a-ca66-000e74944eea@citrix.com>
 <20200930192541.GA60658@linux.intel.com>
 <741b45d0-3833-4e5d-5974-81634d1b55eb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <741b45d0-3833-4e5d-5974-81634d1b55eb@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 30, 2020 at 01:45:52PM -0700, Xing, Cedric wrote:
> On 9/30/2020 12:25 PM, Jarkko Sakkinen wrote:
> > On Wed, Sep 30, 2020 at 07:09:33PM +0100, Andrew Cooper wrote:
> > > Honestly, my advice would be to leave it unprotected for now.  Anyone
> > > who managed to figure out the rest of the practical userspace issues
> > > will probably have a much better idea of what can/should be done in this
> > > case.
> > > 
> > > If that doesn't sit well with people, then the next best would probably
> > > be LFENCE; CALL *reg/mem; LFENCE to cover as many of the corner cases as
> > > possible without being incompatible with CET.  Its not as if this
> > > callback is the slow aspect of entering/exiting SGX mode.
> > > 
> > > ~Andrew
> > 
> > I tend to agree. We cannot drive changes based on unknown unknowns.
> > 
> > And I don't see why we could not add boot time patching of retpoline
> > even after the code is in the mainline kernel, if something ever
> > pushes to that direction.
> > 
> > /Jarkko
> > 
> I agree. It'll be compatible with CET. The overhead of LFENCE is negligible
> comparing to entering/exiting SGX mode.

Andrew's advice was to do "just call" as for now.

If we add also lfence, what is the real-world threat scenario that we
are protecting against that exposes a real visible risk that could harm
the users of these patches?

Please remember that:

1. We can assume that the usage model and implementation is for the
   callback is sane. It is something that is contained to the run-time
   and there is just one instance of the callback.
2. We can always harden this more later on.

I do not want to add any extra bytes to the vDSO without any practical
purpose and I also need to document this choice.

/Jarkko
