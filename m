Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80015C4363C
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 07:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 200BE20870
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 07:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgJGHjk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Oct 2020 03:39:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:49546 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgJGHjk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Oct 2020 03:39:40 -0400
IronPort-SDR: qRGnfQ8argRejdJlwVrMp5FLD0InJ+Kl2oiRbnQCeNP3liyekU/8kRl7L/Bzg2VovmQMJeMkoU
 BNGcgw7BRIvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="144241329"
X-IronPort-AV: E=Sophos;i="5.77,345,1596524400"; 
   d="scan'208";a="144241329"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 00:39:40 -0700
IronPort-SDR: bdfIgso9kHwc3Lh66Bl2jD9gFc5G8/D0Gkmz7qlpoV21MxdhnIZkKtXnPp/y+AekQGK29eegbq
 6qH511bMUhfw==
X-IronPort-AV: E=Sophos;i="5.77,345,1596524400"; 
   d="scan'208";a="461218859"
Received: from juliahar-mobl.ger.corp.intel.com (HELO localhost) ([10.249.32.223])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 00:39:27 -0700
Date:   Wed, 7 Oct 2020 10:39:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20201007073923.GA3632@linux.intel.com>
References: <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
 <20201006025703.GG15803@linux.intel.com>
 <453c2d9b-0fd0-0d63-2bb9-096f255a6ff4@fortanix.com>
 <20201006151532.GA17610@linux.intel.com>
 <20201006172819.GA114208@linux.intel.com>
 <20201006232129.GB28981@linux.intel.com>
 <20201007002236.GA139112@linux.intel.com>
 <20201007011738.GE28981@linux.intel.com>
 <20201007031402.GA143690@linux.intel.com>
 <20201007043418.GG28981@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007043418.GG28981@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 06, 2020 at 09:34:19PM -0700, Sean Christopherson wrote:
> On Wed, Oct 07, 2020 at 06:14:02AM +0300, Jarkko Sakkinen wrote:
> > On Tue, Oct 06, 2020 at 06:17:38PM -0700, Sean Christopherson wrote:
> > > On Wed, Oct 07, 2020 at 03:22:36AM +0300, Jarkko Sakkinen wrote:
> > > > > And then a third flavor comes along, e.g. Jethro's request interrupt case,
> > > > > and exit_reason can also return '2'.  How do you handle that with only the
> > > > > leaf?
> > > > 
> > > > I'm listening. How was that handled before? I saw only '0' and '1'.  Can
> > > > you bring some context on that? I did read the emails that were swapped
> > > > when the run structure was added but I'm not sure what is the exact
> > > > differentiator. Maybe I'm missing something.
> > > 
> > > https://patchwork.kernel.org/patch/11719889/
> > 
> > Thank you.
> > 
> > There's aboslutely nothing that is blocking adding such support for such
> > AEP handling in the current implementation. SGX_SYNCHRONOUS_EXIT is just
> > another name for EEXIT.
> 
> Sure.  And SGX_EXCEPTION_EXIT is just another name for EENTER|ERESUME.

Kind of yes.

> > Even if that was in place, you'd need to separate normal and interrupt.
> > Tristate is useless here. 
> 
> Huh?  You mean like adding SGX_INTERRUPT_EXIT and SGX_EXCEPTION_EXIT?

OK, so I'll throw something.

1. "normal" is either exception from either EENTER or ERESUME,
   or just EEXIT.
2. "interrupt" is something where you want to tailor AEP path.

> > As far as I'm concerned, no bottlenecks have been created.
> 
> There's no bottleneck, just an inflexible and kludgy API for userspace.
> 
> 	if (run->leaf == EEXIT)
> 		return handle_eexit();
> 
> 	if (run->leaf == EENTER || run->leaf == ERESUME)
> 	        return handle_exception(run->leaf);
> 
> 	return -EIO;

I think that's quite intuitive to have just one state variable.

> Let's say we come up with a clever opt-in scheme that allows exception fixup
> to inform the vDSO that the enclave was invalid, even on SGX1.  Now we're in
> a scenario where we want to tell userspace that the enclave is lost, but
> userspace assumes any exit EENTER or ERESUME is an exception.
> 
> 	if (run->leaf == EEXIT)
> 		return handle_eexit();
> 
> 	if (run->leaf == EENTER || run->leaf == ERESUME)
> 		return handle_invalid_enclave_or_maybe_exception();
> 
> 	return -EIO;

What I'd do would be to add a 'flags' field.

It could have a bit for interrupt, let's call it for the sake of an
example as SGX_ENCLAVE_RUN_FLAG_INT.

Then you'd do this if you want to exit from the vDSO instead of doing
ERESUME:

	run->flags |= SGX_ENCLAVE_RUN_FLAG_INT

The vDSO would check this bit on AEP and:

1. If it's cleared, it would ERESUME.
2. If it's set, it would clear it and exit from vDSO.

> We could add a new exit reason, but we'd still need to ensure EENTER|ERESUME
> means "exception" for old userspace.  Or we could add exit_reason now and end
> up with (IMO) a sane and extensible interface.
> 
> 	if (run->exit_reason == SGX_ENCLAVE_INVALID)
> 		return handle_invalid_enclave();
> 
> 	if (run->exit_reason == SGX_SYNCHRONOUS_EXIT)
> 		return handle_eexit();
> 
> 	if (run->exit_reason == SGX_EXCEPTION)
> 		return handle_exception();
> 
> 	return -EIO;
> 
> And maybe we get really clever and figure out a way to (deterministically)
> redirect SIGALRM to the vDSO.  Then we'd want:
> 
> 	if (run->exit_reason == SGX_ENCLAVE_INVALID)
> 		return handle_invalid_enclave();
> 
> 	if (run->exit_reason == SGX_SYNCHRONOUS_EXIT)
> 		return handle_eexit();
> 
> 	if (run->exit_reason == SGX_ALARM)
> 		return handle_reschedule();
> 
> 	if (run->exit_reason == SGX_EXCEPTION)
> 		return handle_exception();
> 
> 	return -EIO;
> 
> Even more hypothetical would be if Andy gets one of his wishes, and EENTER2
> comes along that doesn't allow the enclave to dictate the exit point,
> "returns" an error code on enclave failure, and allows the kernel to
> auto-restart the enclave on IRQs/NMIs.  That (very hypothetical) scenario
> fits nicely into the exit_reason handling.
> 
> I'm not arguing that any of the above is even remotely likely.  I just don't
> understand why we'd want an API that at best requires heuristics in userspace
> to determine why the enclave stopped running, and at worst will saddle us with
> an ugly mess in the future.  All to save 4 bytes that no one cares about (they
> literally cost nothing), and a single MOV in a flow that is hundreds, if not
> thousands, of cycles.

I don't care as much as saving bytes as defining API, which has zero
ambiguous state variables.

And since the field 'leaf' is there, and was before too, no degrees of
freedom are lost. Removing one variable does not make more of a mess.

/Jarkko
