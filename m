Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0944EC4363C
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 18:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A70F921D91
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 18:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIUSKe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 14:10:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:10434 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgIUSKe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 14:10:34 -0400
IronPort-SDR: coZfDMUQZWYD0aFZbk6fcu+YjUsR3SYwSOzhXjJ/rY/PbEWUiGlfHCQYdcWf75wDdCPBEehmwY
 WhXwvnwKQvPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="148207084"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="148207084"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 11:10:23 -0700
IronPort-SDR: mpDMERO1472sfD/4J47NZq8BnQx2HCiGrr4acojo+GMCebeKiuwmaWlEv35AfvufSHZ3jXk2yd
 ADRtpBp0zvsA==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="485597119"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 11:10:22 -0700
Date:   Mon, 21 Sep 2020 11:10:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
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
Message-ID: <20200921181021.GA24481@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
 <20200921173514.GI5901@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921173514.GI5901@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 07:35:14PM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 02:28:32PM +0300, Jarkko Sakkinen wrote:
> > +static int sgx_einit(struct sgx_sigstruct *sigstruct, void *token,
> > +		     struct sgx_epc_page *secs, u64 *lepubkeyhash)
> > +{
> > +	int ret;
> > +
> > +	preempt_disable();
> > +	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
> 
> So this will update the cached copies *and* the MSRs itself if what's
> cached is stale...
> 
> > +	ret = __einit(sigstruct, token, sgx_get_epc_addr(secs));
> > +	if (ret == SGX_INVALID_EINITTOKEN) {
> 
> ... so why would it return this error here?
> 
> Definition of this error says:
> 
>  * %SGX_INVALID_EINITTOKEN:     EINITTOKEN is invalid and enclave signer's
>  *                              public key does not match IA32_SGXLEPUBKEYHASH.
> 
> when you just updated them?!
> 
> > +		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
> 
> So why force a second time?

The LE pubkey hash MSRs are special snowflakes.  They get reset to Intel's
default key on any loss of EPC, e.g. if the system does a suspend/resume
cycle.  The approach we took (obviously) is to assume the kernel's cache can
be stale at any given time.  The alternative would be to try and track loss
of EPC conditions and emulate the reset, but that's a bit dicey on bare
metal as any missed case would hose SGX, and in a VM it's theoretically
impossible to handle as a particularly unhelpful VMM could emulate loss of
EPC at will.

Yes, this need a big fat comment.

> > +		ret = __einit(sigstruct, token, sgx_get_epc_addr(secs));
> > +	}
> > +	preempt_enable();
> > +	return ret;
> > +}
