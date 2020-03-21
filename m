Return-Path: <SRS0=/STu=5G=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA54EC4332B
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Mar 2020 00:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A9D20788
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Mar 2020 00:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgCUAze (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:55:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:48767 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUAze (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Mar 2020 20:55:34 -0400
IronPort-SDR: X+wRhxda09nl/NGlHJa3gVOtF+QquEz/GEOd5Na2kFEnYyArX52HPXP7WpARY9wWfI1a8hRQ30
 eqAwjxMSGO2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 17:55:33 -0700
IronPort-SDR: dA+7P55H8JI9VAdMsF2YMpp4Wy64vw0ohyTJwlNK/UWESjOwI9umITfSNBY3zQPvHeYRpVXOs/
 rbfzRXsOZ4gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="238912006"
Received: from ydubov-mobl1.ger.corp.intel.com (HELO localhost) ([10.254.147.149])
  by fmsmga008.fm.intel.com with ESMTP; 20 Mar 2020 17:55:29 -0700
Date:   Sat, 21 Mar 2020 02:55:28 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 0/8] x86/sgx: Make vDSO callable from C
Message-ID: <20200321005528.GA7166@linux.intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
 <20200320005724.GA182892@linux.intel.com>
 <20200320232512.GF3866@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320232512.GF3866@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 20, 2020 at 04:25:12PM -0700, Sean Christopherson wrote:
> On Fri, Mar 20, 2020 at 02:57:24AM +0200, Jarkko Sakkinen wrote:
> > On Wed, Mar 18, 2020 at 06:11:22PM -0700, Sean Christopherson wrote:
> > > Sean Christopherson (8):
> > >   x86/sgx: vdso: Remove an incorrect statement the enter enclave comment
> > >   x86/sgx: vdso: Make the %rsp fixup on return from handler relative
> > >   x86/sgx: vdso: Make __vdso_sgx_enter_enclave() callable from C code
> > >   x86/sgx: vdso: Define a typedef for __vdso_sgx_enter_enclave
> > >   selftests/x86: sgx: Zero out @result before invoking vDSO sub-test
> > >   selftests/x86: sgx: Pass EENTER to vDSO wrapper instead of hardcoding
> > >   selftests/x86: sgx: Stop clobbering non-volatile registers
> > >   selftests/x86: Add selftest to invoke __vsgx_enter_enclave() from C
> > > 
> > >  arch/x86/entry/vdso/vsgx_enter_enclave.S      | 72 ++-----------------
> > >  arch/x86/include/uapi/asm/sgx.h               | 61 ++++++++++++++++
> > >  .../selftests/x86/sgx/encl_bootstrap.S        |  6 +-
> > >  tools/testing/selftests/x86/sgx/main.c        | 17 ++++-
> > >  tools/testing/selftests/x86/sgx/sgx_call.S    |  1 -
> > >  tools/testing/selftests/x86/sgx/sgx_call.h    |  2 +-
> > >  6 files changed, 85 insertions(+), 74 deletions(-)
> > > 
> > > -- 
> > > 2.24.1
> > > 
> > 
> > Might be a grazy idea but better to go through this anyway.
> > 
> > Given the premise that we need the carry the callback anyway in all
> > cases, why won't just have the callback.
> > 
> > Why we absolutely need the code path that fills exception info given
> > that we no matter what need to have a callback route?
> > 
> > Would simplify considerably to have only clear flow.
> 
> Invoking the callback uses a retpoline, which is non-trivial overhead.
> For runtimes that need an assembly wrapper for other reasons, and aren't
> using the untrusted stack, forcing them to implement a handler would be
> painful.

The non-callback route only exists because we did not know that we have
to do the callback route. It does not make sense to add something for
any other reason than absolute necessity.

Things would simplify in the vDSO implementation considerably. Now it is
overwhelmingly complex for no good reason.

/Jarkko
