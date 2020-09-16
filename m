Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF00C433E2
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 18:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB3721655
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 18:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgIPSVl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Sep 2020 14:21:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:61430 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726507AbgIPSV1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Sep 2020 14:21:27 -0400
IronPort-SDR: cqHiMs3waixP8NrGB30kNwvLNXV9IPuWvOVr4thh9y/zuH68hfkJwj7hs6TF1P9byfneegbTSE
 vH1rN8gjvm6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="139008854"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="139008854"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:04:28 -0700
IronPort-SDR: Q/fd4pGPyabmqm3WKVszibb4fe3jwPJLd4rGMqL1nJnzdcTRtg2+g9fPONPZhFyJUOrljiyHfA
 l34HiqxNm8Pw==
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="483365305"
Received: from scusackx-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.45.87])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:04:21 -0700
Date:   Wed, 16 Sep 2020 19:04:19 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v37 02/24] x86/cpufeatures: x86/msr: Add Intel SGX Launch
 Control hardware bits
Message-ID: <20200916160419.GB21026@linux.intel.com>
References: <20200911124019.42178-1-jarkko.sakkinen@linux.intel.com>
 <20200911124019.42178-3-jarkko.sakkinen@linux.intel.com>
 <20200914151816.u6camicid4bd5lgo@treble>
 <20200914153812.c6uh3spqmcy2ft3d@treble>
 <20200915095716.GI3612@linux.intel.com>
 <20200915132725.a2qbdio3jsu7rsqs@treble>
 <20200915133929.GI14436@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915133929.GI14436@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 03:39:29PM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 08:27:25AM -0500, Josh Poimboeuf wrote:
> > I see the v37 missing patches now, but they're not threaded with the
> > original thread.
> 
> Probably because he bounced only the ones you didn't get, separately.
> 
> > v38 has some missing patches as well.
> 
> And I got them twice. Can we please stop the spamming?
> 
> And yeah, use another mail service - all those companies switching the
> o365 and mimecast, means time to move kernel development off of company
> mail because company mail simply can't handle it.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

The duplicate versions of v38 are equal. The "backup" server was just
really slow with vger. That's why I retried.

As can be seen here both v38's are also complete:

https://lore.kernel.org/linux-sgx/

I've tried for months to get kernel.org account but I have troubles
getting my PGP trusted. I really would like to move the whole thing
over there. And use that account for email.

Three maintainers have signed my key but when I do gpg --refresh, I
do not get any signatures for my key. The command uses keys.openpgp.org.
I have no idea if that is the correct key server or not. And I have no
idea how PGP servers mirror stuff with each other. And I have not found
anything on this from kernel documentation (e.g. PGP maintainer guide).

/Jarkko
