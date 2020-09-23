Return-Path: <SRS0=YjYT=DA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B734C4363D
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 14:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F27BA206FB
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 14:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIWOrQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Sep 2020 10:47:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:59208 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgIWOrQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Sep 2020 10:47:16 -0400
IronPort-SDR: j6W3uEjE9Y+3k9zHsmzK4wHpMq25AsGUDSUcozhNIqmWB+BrOiRodR14Wv1aI/Vo+IvUykgixA
 r/twI1UvUjjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148555259"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148555259"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 07:47:16 -0700
IronPort-SDR: +Xbj246mPwIR7pSKj2Xz72hEM1umcXBC9/gNFta2Bio+n7wIj4HD2vUlCu2+KMNRXyxnLYDd3w
 25GHJHBj+QqQ==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486464881"
Received: from linortne-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.49.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 07:47:09 -0700
Date:   Wed, 23 Sep 2020 17:47:07 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
Message-ID: <20200923144707.GF5160@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
 <20200921173514.GI5901@zn.tnic>
 <20200921181021.GA24481@linux.intel.com>
 <20200921182753.GK5901@zn.tnic>
 <20200921191658.GA24823@linux.intel.com>
 <20200922082918.GC22660@zn.tnic>
 <a6f4d3e5-c128-fcd7-a1ca-5515a6c4c09a@fortanix.com>
 <20200922142909.GI22660@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200922142909.GI22660@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 04:29:09PM +0200, Borislav Petkov wrote:
> On Tue, Sep 22, 2020 at 02:56:19PM +0200, Jethro Beekman wrote:
> > I don't see why you'd need to retry indefinitely. Yes the MSRs may not
> > match the cached value for “reasons”, but if after you've written
> > them once it still doesn't work, clearly either 1) an “unhelpful”
> > VMM is actively messing with the MSRs which I'd say is at best a VMM
> > bug or 2) there was an EPC reset and your enclave is now invalid
> > anyway, so no need to EINIT.
> 
> /me likes that even more.

OK, so I did not follow this particular discussion in high detail, so
as a sanity check I'll preview my changes.

I'd refine sgx_update_lepubkeyhash_msrs() to:

static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash)
{
	u64 *cache;
	int i;

	preempt_disable();

	cache = per_cpu(sgx_lepubkeyhash_cache, smp_processor_id());
	for (i = 0; i < 4; i++) {
		if (lepubkeyhash[i] != cache[i]) {
			wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
			cache[i] = lepubkeyhash[i];
		}
	}

	preempt_enable();
}

I'd drop sgx_einit() completely.

Finally, in sgx_encl_init() I would call sgx_update_lepubkeyhash_msrs()
directly:

/* ... */
			sgx_update_lepubkeyhash_msrs(mrsigner);

			ret = __einit(sigstruct, token, sgx_get_epc_addr(secs));
/* ... */

These staments would replace the call to sgx_einit().

Do I have the correct understanding?

/Jarkko
