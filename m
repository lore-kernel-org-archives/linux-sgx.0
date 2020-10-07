Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116DBC4363C
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 04:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C889F208C7
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 04:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgJGEeV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Oct 2020 00:34:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:43840 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgJGEeV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Oct 2020 00:34:21 -0400
IronPort-SDR: ayZmLje5qVjr545e5CZ13prx++7aQig2nfpjMFgb/KbeoK/VNS/j52AnNTidMI99S48XjNeqCs
 TOttiqUAiVDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="144729908"
X-IronPort-AV: E=Sophos;i="5.77,345,1596524400"; 
   d="scan'208";a="144729908"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 21:34:21 -0700
IronPort-SDR: gcG3t4tfDqTzJe7zhMWVGhRu+DJwbxdocUDxR3WOxlWfuQE4zHbYYAh8TrgvO6Bi4LH7NV/HdU
 1EaHfOEjdP3g==
X-IronPort-AV: E=Sophos;i="5.77,345,1596524400"; 
   d="scan'208";a="311578880"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 21:34:20 -0700
Date:   Tue, 6 Oct 2020 21:34:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20201007043418.GG28981@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
 <20201006025703.GG15803@linux.intel.com>
 <453c2d9b-0fd0-0d63-2bb9-096f255a6ff4@fortanix.com>
 <20201006151532.GA17610@linux.intel.com>
 <20201006172819.GA114208@linux.intel.com>
 <20201006232129.GB28981@linux.intel.com>
 <20201007002236.GA139112@linux.intel.com>
 <20201007011738.GE28981@linux.intel.com>
 <20201007031402.GA143690@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007031402.GA143690@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 07, 2020 at 06:14:02AM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 06, 2020 at 06:17:38PM -0700, Sean Christopherson wrote:
> > On Wed, Oct 07, 2020 at 03:22:36AM +0300, Jarkko Sakkinen wrote:
> > > > And then a third flavor comes along, e.g. Jethro's request interrupt case,
> > > > and exit_reason can also return '2'.  How do you handle that with only the
> > > > leaf?
> > > 
> > > I'm listening. How was that handled before? I saw only '0' and '1'.  Can
> > > you bring some context on that? I did read the emails that were swapped
> > > when the run structure was added but I'm not sure what is the exact
> > > differentiator. Maybe I'm missing something.
> > 
> > https://patchwork.kernel.org/patch/11719889/
> 
> Thank you.
> 
> There's aboslutely nothing that is blocking adding such support for such
> AEP handling in the current implementation. SGX_SYNCHRONOUS_EXIT is just
> another name for EEXIT.

Sure.  And SGX_EXCEPTION_EXIT is just another name for EENTER|ERESUME.

> Even if that was in place, you'd need to separate normal and interrupt.
> Tristate is useless here. 

Huh?  You mean like adding SGX_INTERRUPT_EXIT and SGX_EXCEPTION_EXIT?

> As far as I'm concerned, no bottlenecks have been created.

There's no bottleneck, just an inflexible and kludgy API for userspace.

	if (run->leaf == EEXIT)
		return handle_eexit();

	if (run->leaf == EENTER || run->leaf == ERESUME)
	        return handle_exception(run->leaf);

	return -EIO;

Let's say we come up with a clever opt-in scheme that allows exception fixup
to inform the vDSO that the enclave was invalid, even on SGX1.  Now we're in
a scenario where we want to tell userspace that the enclave is lost, but
userspace assumes any exit EENTER or ERESUME is an exception.

	if (run->leaf == EEXIT)
		return handle_eexit();

	if (run->leaf == EENTER || run->leaf == ERESUME)
		return handle_invalid_enclave_or_maybe_exception();

	return -EIO;

We could add a new exit reason, but we'd still need to ensure EENTER|ERESUME
means "exception" for old userspace.  Or we could add exit_reason now and end
up with (IMO) a sane and extensible interface.

	if (run->exit_reason == SGX_ENCLAVE_INVALID)
		return handle_invalid_enclave();

	if (run->exit_reason == SGX_SYNCHRONOUS_EXIT)
		return handle_eexit();

	if (run->exit_reason == SGX_EXCEPTION)
		return handle_exception();

	return -EIO;

And maybe we get really clever and figure out a way to (deterministically)
redirect SIGALRM to the vDSO.  Then we'd want:

	if (run->exit_reason == SGX_ENCLAVE_INVALID)
		return handle_invalid_enclave();

	if (run->exit_reason == SGX_SYNCHRONOUS_EXIT)
		return handle_eexit();

	if (run->exit_reason == SGX_ALARM)
		return handle_reschedule();

	if (run->exit_reason == SGX_EXCEPTION)
		return handle_exception();

	return -EIO;

Even more hypothetical would be if Andy gets one of his wishes, and EENTER2
comes along that doesn't allow the enclave to dictate the exit point,
"returns" an error code on enclave failure, and allows the kernel to
auto-restart the enclave on IRQs/NMIs.  That (very hypothetical) scenario
fits nicely into the exit_reason handling.

I'm not arguing that any of the above is even remotely likely.  I just don't
understand why we'd want an API that at best requires heuristics in userspace
to determine why the enclave stopped running, and at worst will saddle us with
an ugly mess in the future.  All to save 4 bytes that no one cares about (they
literally cost nothing), and a single MOV in a flow that is hundreds, if not
thousands, of cycles.
