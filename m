Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3B4C2D0E2
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 11:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B2B6221EB
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 11:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgIVLu0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 07:50:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:21220 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgIVLuW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Sep 2020 07:50:22 -0400
IronPort-SDR: +vnWP6gHv46+XF9acqS/a1+eG0n03FgEFcRIlezk97IAX9OzBE4MxJ36oF/r3SnivvmD812vV0
 zCWvBlR/UCxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="161511978"
X-IronPort-AV: E=Sophos;i="5.77,290,1596524400"; 
   d="scan'208";a="161511978"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 04:50:20 -0700
IronPort-SDR: lIwk2gZMiibyudb/P/DyKaKvhifqKwT0UqtUFS0BoCQhCdO3upAFOcrz6ug+BVR7XiRRMyLp9j
 B40oc8E1aZyQ==
X-IronPort-AV: E=Sophos;i="5.77,290,1596524400"; 
   d="scan'208";a="485924412"
Received: from krodolf-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.49.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 04:50:12 -0700
Date:   Tue, 22 Sep 2020 14:50:10 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 14/24] x86/sgx: Add SGX_IOC_ENCLAVE_INIT
Message-ID: <20200922115010.GA102220@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
 <20200921173514.GI5901@zn.tnic>
 <20200921181021.GA24481@linux.intel.com>
 <20200921182753.GK5901@zn.tnic>
 <20200921191658.GA24823@linux.intel.com>
 <20200922082918.GC22660@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922082918.GC22660@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 10:29:18AM +0200, Borislav Petkov wrote:
> On Mon, Sep 21, 2020 at 12:17:00PM -0700, Sean Christopherson wrote:
> > That was effectively my original suggestion as well, check for a stale cache
> > and retry indefinitely.  I capitulated because it did feel like I was being
> > overly paranoid.  I'm obviously ok going the retry indefinitely route :-).
> > 
> > https://lkml.kernel.org/r/20180904163546.GA5421@linux.intel.com
> 
> Right, so if EINIT is so expensive, why does it matter how many cyccles
> WRMSR has? I.e., you don't really need to cache - you simply write the 4
> MSRs and you're done. Simple.
> 
> As to "indefinitely" - caller can increment a counter which counts
> how many times it returned SGX_INVALID_EINITTOKEN. I guess when it
> reaches some too high number which should not be reached during normal
> usage patterns, you can give up and issue a message to say that counter
> reached max retries or so but other than that, you should be ok. That
> thing is running interruptible in a loop anyway...

The way I see it after reading the thread is:

1. Start with simpler always-update-MSRs in this patch set.
2. If this ever causes a bottleneck, then we will fix it.

> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
