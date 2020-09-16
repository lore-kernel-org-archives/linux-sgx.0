Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5522C43461
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 16:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71F3C2220B
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 16:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgIPQfU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Sep 2020 12:35:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:13463 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgIPQbt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Sep 2020 12:31:49 -0400
IronPort-SDR: N3Qw40H49KXR3pMg3I14fjlOv1t6zZD6NU4Iv/4afW650gly3OVkMidO5121B+1wg/JnGQ9b5Y
 H6UPGQLLI57A==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="244342272"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="244342272"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:09:13 -0700
IronPort-SDR: PXl0x/ESxSTx+56q8kc/UsPwLO450SS8TaplzdK7JshJum/HNnyS8RErTqv4cZ95SYFthXFLB4
 UYKWyigkB3nw==
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="508055839"
Received: from scusackx-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.45.87])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:09:07 -0700
Date:   Wed, 16 Sep 2020 19:09:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
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
Message-ID: <20200916160905.GC21026@linux.intel.com>
References: <20200911124019.42178-1-jarkko.sakkinen@linux.intel.com>
 <20200911124019.42178-3-jarkko.sakkinen@linux.intel.com>
 <20200914151816.u6camicid4bd5lgo@treble>
 <20200914153812.c6uh3spqmcy2ft3d@treble>
 <20200915095716.GI3612@linux.intel.com>
 <20200915132725.a2qbdio3jsu7rsqs@treble>
 <20200915133929.GI14436@zn.tnic>
 <20200915140250.kf2kgfbgzxfvmoiy@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915140250.kf2kgfbgzxfvmoiy@treble>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 09:02:50AM -0500, Josh Poimboeuf wrote:
> On Tue, Sep 15, 2020 at 03:39:29PM +0200, Borislav Petkov wrote:
> > On Tue, Sep 15, 2020 at 08:27:25AM -0500, Josh Poimboeuf wrote:
> > > I see the v37 missing patches now, but they're not threaded with the
> > > original thread.
> > 
> > Probably because he bounced only the ones you didn't get, separately.
> > 
> > > v38 has some missing patches as well.
> > 
> > And I got them twice. Can we please stop the spamming?
> > 
> > And yeah, use another mail service - all those companies switching the
> > o365 and mimecast, means time to move kernel development off of company
> > mail because company mail simply can't handle it.
> 
> If you getting them (twice?) and vger's not, it sounds like vger is
> dropping them for some reason.

It was my fault.

First time when I sent with mail.kapsi.fi I did not see anything for
like 20 minutes or so. I thought that things went wrong. So, I applied
git send-email another time for v38. Over hours both came to LKML as
can be seen from here:

https://lore.kernel.org/linux-sgx/

I'll try to sort out kernel.org account thing asap. Already sent my
key for the 2nd time to keys@linux.kernel.org albeit my PGP skills are
not good enough to check whether the signatures for my key are
somewhere.

/Jarkko
