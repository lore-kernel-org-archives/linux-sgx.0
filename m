Return-Path: <SRS0=bD14=AL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2FCC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 06:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E6A62067D
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 06:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgF3GA5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 30 Jun 2020 02:00:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:48453 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgF3GA4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 30 Jun 2020 02:00:56 -0400
IronPort-SDR: YaXclxS3+FIINgVPV3FzOhiP54mINmf9CeZu1XBQeKnpWC/KCsXuzoFq9A9UHdE0Uj63YylQFc
 Kvzt3GtgeYgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="146144383"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="146144383"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 23:00:56 -0700
IronPort-SDR: +AEYx3LtlCAR6XYVfnwXGu6Z3lMDB/gEdNA36AbkK9adDliKAqaVV6zEQY5DIWxYzX/XFSCCoq
 HorbUGw/bqkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="321292429"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 29 Jun 2020 23:00:55 -0700
Date:   Mon, 29 Jun 2020 23:00:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 15/21] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20200630060055.GS12312@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-16-jarkko.sakkinen@linux.intel.com>
 <20200629171022.GC32176@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629171022.GC32176@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 29, 2020 at 07:10:22PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:37AM +0300, Jarkko Sakkinen wrote:
> ...
> > intended benefit of massaging GCC's inlining algorithm is unlikely to
> > realized in the vDSO any time soon, if ever.
> 
> That is a very good explanation and I would prefer if it would be in a
> sgx-specific README or so instead of it getting lost in git...
> 
> > +bool fixup_vdso_exception(struct pt_regs *regs, int trapnr,
> > +			  unsigned long error_code, unsigned long fault_addr)
> > +{
> > +	const struct vdso_image *image = current->mm->context.vdso_image;
> > +	const struct vdso_exception_table_entry *extable;
> > +	unsigned int nr_entries, i;
> > +	unsigned long base;
> > +
> > +	/*
> > +	 * Do not attempt to fixup #DB or #BP.  It's impossible to identify
> > +	 * whether or not a #DB/#BP originated from within an SGX enclave and
> > +	 * SGX enclaves are currently the only use case for vDSO fixup.
> > +	 */
> 
> So this is all fine and dandy but nowhere do I see the code doing:
> 
> 	if (am_I_an_sgx_enclave(tsk))
> 		fixup_vdso_exception()
> 
> because that vDSO exception fixup, albeit it looking kinda generic, is
> SGX-only for now. So it should be designed to run only for SGX enclaves
> for now.

That's not really feasible as there is no readily available identifier for
an SGX task.  The only indication that a relevant task is an SGX task is if
it has mmap()'d /dev/sgx/enclave, and hooking that would be heinous.  And
adding flag just to tag the task as SGX seems wasteful.

Even if we could easily condition the vDSO fixup on SGX tasks, I don't think
that'd be a good ABI for the SGX vDSO code.  The intended contract is that
fixup will happen simply by virtue of the code at the related IP taking a
fault (in userspace).  E.g. the vDSO function should get the fixup even if
userspace screws up mmap() and invokes __vdso_sgx_enter_enclave() without
being tagged an SGX task.

> Also, is there any particular reason for fixup_vdso_exception() to be in
> arch/x86/entry/vdso/extable.c instead of in arch/x86/mm/extable.c?
> 
> I mean, it gets called by traps.c so it looks like normal kernel code to
> me or am I missing some vdso magic?

No hard dependency, it's normal kernel code.  My reasoning for dropping it
in .../vdso was largely to co-locate it with vdso/extable.h due to the
dependency on the format of 'struct vdso_exception_table_entry'.  And I
put extable.h in .../vdso because it contains macros that are only for use
in actual vDSO code.
 
> And built only when CONFIG_INTEL_SGX is enabled.

Ya, shouldn't be a problem to stub it out for SGX=n.
