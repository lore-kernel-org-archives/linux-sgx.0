Return-Path: <SRS0=zErr=CH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BCDC433E6
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Aug 2020 00:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 100A320714
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Aug 2020 00:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgH2AVM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Aug 2020 20:21:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:49793 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbgH2AVL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 28 Aug 2020 20:21:11 -0400
IronPort-SDR: MpFWC40r6sZtFFFqyJdV72SmPVU+ptm13awjhWSLLOmVhCq7Ph1+jy+c2vfpbM2QgUdVF+R5qs
 VkNFamtJ2TxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9727"; a="156027449"
X-IronPort-AV: E=Sophos;i="5.76,365,1592895600"; 
   d="scan'208";a="156027449"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 17:21:10 -0700
IronPort-SDR: XsL7UiaTnATWvQFIcY/3MD+Sm5W8U41OWW6gftH2LedzEuZTp8ocscyURk3zZPyDqWy9YX22Dj
 aRlVHA3S71sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,365,1592895600"; 
   d="scan'208";a="340052040"
Received: from faerberc-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.36.74])
  by orsmga007.jf.intel.com with ESMTP; 28 Aug 2020 17:21:03 -0700
Date:   Sat, 29 Aug 2020 03:21:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20200829002102.GB39420@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
 <20200826145239.GC22390@zn.tnic>
 <20200827132436.GA4674@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827132436.GA4674@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 27, 2020 at 04:24:50PM +0300, Jarkko Sakkinen wrote:
> > > + * @arg:	userspace pointer to a struct sgx_enclave_create instance
> > > + *
> > > + * Allocate kernel data structures for a new enclave and execute ECREATE after
> > > + * verifying the correctness of the provided SECS.
> > > + *
> > > + * Note, enforcement of restricted and disallowed attributes is deferred until
> > > + * sgx_ioc_enclave_init(), only the architectural correctness of the SECS is
> > > + * checked by sgx_ioc_enclave_create().
> > 
> > From that same review:
> > 
> > "Well, I don't see that checking. Where is it?"
> > 
> > Ok, I'm going to stop here. Please go over v33's review and either
> > address *all* feedback or incorporate it into your patches if you agree
> > with it but do not silently ignore it. One of the things I very strongly
> > detest is ignored review comments.

OK, so sgx_validate_secs() is the validation of what the CPU requires
from the contents of the SECS. That is mean by "architectural
correctness".

I spotted the glitch that makes this confusing.

The change that the comment is related is

https://lore.kernel.org/linux-sgx/20200716135303.276442-16-jarkko.sakkinen@linux.intel.com/

This check in sgx_encl_init() should be relocated to this commit:

	/* Check that the required attributes have been authorized. */
	if (encl->secs_attributes & ~encl->allowed_attributes)
		return -EACCES;

It is the "enforcement of restricted and disallowed attributes" part.

Does this make sense to you?

> > -- 
> > Regards/Gruss,
> >     Boris.

/Jarkko
