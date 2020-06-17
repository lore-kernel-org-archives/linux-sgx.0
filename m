Return-Path: <SRS0=OlnE=76=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF63C433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Jun 2020 00:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 221AD207C4
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Jun 2020 00:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgFQAG6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 16 Jun 2020 20:06:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:4548 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgFQAG5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 16 Jun 2020 20:06:57 -0400
IronPort-SDR: U9wWw2LOWBlZj0mcDVKcy5ibGydKyOXYqRyexVqz0P+mJ2xHNJA67lptVeRU3OxQTcCdTmQ1Vn
 FEm1yZBAuDUg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 17:06:55 -0700
IronPort-SDR: H6QpQy7n5myIs++qIDkFsI1D6malujRVIssFYyjopJQ6ePl01TEZOqIkBjKbNy+hJ3Pkff25wn
 WxsBx2EmKWIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,520,1583222400"; 
   d="scan'208";a="351907808"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 16 Jun 2020 17:06:55 -0700
Date:   Tue, 16 Jun 2020 17:06:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v32 00/21] Intel SGX foundations
Message-ID: <20200617000655.GB19300@linux.intel.com>
References: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
 <20200610205903.GF18790@linux.intel.com>
 <20200616200958.GC10412@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616200958.GC10412@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 16, 2020 at 11:09:58PM +0300, Jarkko Sakkinen wrote:
> On Wed, Jun 10, 2020 at 01:59:03PM -0700, Sean Christopherson wrote:
> > On Mon, Jun 01, 2020 at 10:51:57AM +0300, Jarkko Sakkinen wrote:
> > > v29:
> > > * The selftest has been moved to selftests/sgx. Because SGX is an execution
> > >   environment of its own, it really isn't a great fit with more "standard"
> > >   x86 tests.
> > > 
> > >   The RSA key is now generated on fly and the whole signing process has
> > >   been made as part of the enclave loader instead of signing the enclave
> > >   during the compilation time.
> > > 
> > >   Finally, the enclave loader loads now the test enclave directly from its
> > >   ELF file, which means that ELF file does not need to be coverted as raw
> > >   binary during the build process.
> > 
> > Something in the above rework broke the selftest.  I'm getting intermittent
> > EINIT failures with SGX_INVALID_SIGNATURE.  I'm guessing it's related to
> > the dynamic RSA key generation, e.g. only ~15% of runs fail.  Verified that
> > v29 selftest fails and v28 passes.  My internal tests also pass, i.e. it's
> > all but guaranteed to be a selftest issue, not a kernel issue.
> > 
> > Jarkko, I don't have bandwidth to dig into this right now, hopefully this
> > reproduces in your environment.  Let me know if that's not the case.
> 
> I haven't experienced but I'll try to stress test it.
> 
> Just to know how complex test should reproduce your issue, can you
> reproduce the issue by running the selftest sequentially in a loop or
> do I need to do something more complex than that?

I didn't even get that complex, just running the selftest manually will
eventually fail for me, e.g. the first failure I saw was a one-off run of
the selftest.
