Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93AEC4363D
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 16:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7756C23A1B
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 16:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIVQ3r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:29:47 -0400
Received: from mga07.intel.com ([134.134.136.100]:3474 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbgIVQ3r (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Sep 2020 12:29:47 -0400
IronPort-SDR: QtGKYdt4mk0Zzm4CKdhbk0RJxFuyWcUqZg90pFQqwtFrD3aJsc0TkF3Bhr2HHW/Wj7BSJWWE4N
 deQCV+kMu54A==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="224796412"
X-IronPort-AV: E=Sophos;i="5.77,291,1596524400"; 
   d="scan'208";a="224796412"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 09:29:45 -0700
IronPort-SDR: +aeJPR2XrCKLGqGj8JJVXa4YiaebSvPnxQMdwGKoIAIIm/kaeKLAXe7lM19L1OQTd9WisYrRdl
 vXhvgTMRbPUQ==
X-IronPort-AV: E=Sophos;i="5.77,291,1596524400"; 
   d="scan'208";a="454549490"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 09:29:45 -0700
Date:   Tue, 22 Sep 2020 09:29:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
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
Message-ID: <20200922162944.GA30874@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
 <20200921173514.GI5901@zn.tnic>
 <20200921181021.GA24481@linux.intel.com>
 <20200921182753.GK5901@zn.tnic>
 <20200921191658.GA24823@linux.intel.com>
 <20200922082918.GC22660@zn.tnic>
 <a6f4d3e5-c128-fcd7-a1ca-5515a6c4c09a@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a6f4d3e5-c128-fcd7-a1ca-5515a6c4c09a@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 02:56:19PM +0200, Jethro Beekman wrote:
> On 2020-09-22 10:29, Borislav Petkov wrote:
> > On Mon, Sep 21, 2020 at 12:17:00PM -0700, Sean Christopherson wrote:
> >> That was effectively my original suggestion as well, check for a stale cache
> >> and retry indefinitely.  I capitulated because it did feel like I was being
> >> overly paranoid.  I'm obviously ok going the retry indefinitely route :-).
> >>
> >> https://lkml.kernel.org/r/20180904163546.GA5421@linux.intel.com
> > 
> > Right, so if EINIT is so expensive, why does it matter how many cyccles
> > WRMSR has? I.e., you don't really need to cache - you simply write the 4
> > MSRs and you're done. Simple.

Hmm, true.  The 1200+ cycles to write the hash MSRs (they're 3x slower than
other MSRs) seems scary, but compared to the 60k cycles it really doesn't
matter.

> > As to "indefinitely" - caller can increment a counter which counts
> > how many times it returned SGX_INVALID_EINITTOKEN. I guess when it
> > reaches some too high number which should not be reached during normal
> > usage patterns, you can give up and issue a message to say that counter
> > reached max retries or so but other than that, you should be ok. That
> > thing is running interruptible in a loop anyway...
> 
> I don't see why you'd need to retry indefinitely. Yes the MSRs may not match
> the cached value for “reasons”, but if after you've written them once it
> still doesn't work, clearly either 1) an “unhelpful” VMM is actively messing
> with the MSRs which I'd say is at best a VMM bug or 2) there was an EPC reset
> and your enclave is now invalid anyway, so no need to EINIT.

Ah, also true, I overlooked that an MSR reset would also kill the enclave.

So yeah, this can be simplified to:

	if (SGX_LC) {
		for (i = 0; i < 4; i++)
			wrmsrl(...);
	}
	return __einit(...);
