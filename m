Return-Path: <SRS0=/STu=5G=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10555C4332B
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Mar 2020 20:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1FFF2077D
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Mar 2020 20:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgCUUL1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 21 Mar 2020 16:11:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:58223 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbgCUUL1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 21 Mar 2020 16:11:27 -0400
IronPort-SDR: zH4aEHZ+g7v0+QJL3Gf9fg8O3V32Zv9KzQ6QThih0z6ZrqV9Lma3F1XhchMvkoyIYVd7RRVg7Z
 RToKvesT4xWQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 13:11:27 -0700
IronPort-SDR: VGDssGqPjR4Aw6jAWUkOV2rxwlhcWjzSmJSulpDZ5u6eYleoleKExCp9ojLn6NsUTa7txZDpEX
 M4XCQfLSzuDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="446994199"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 21 Mar 2020 13:11:26 -0700
Date:   Sat, 21 Mar 2020 13:11:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 0/8] x86/sgx: Make vDSO callable from C
Message-ID: <20200321201126.GF13851@linux.intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
 <20200320005724.GA182892@linux.intel.com>
 <20200320232512.GF3866@linux.intel.com>
 <20200321005528.GA7166@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321005528.GA7166@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Mar 21, 2020 at 02:55:28AM +0200, Jarkko Sakkinen wrote:
> On Fri, Mar 20, 2020 at 04:25:12PM -0700, Sean Christopherson wrote:
> > On Fri, Mar 20, 2020 at 02:57:24AM +0200, Jarkko Sakkinen wrote:
> > > On Wed, Mar 18, 2020 at 06:11:22PM -0700, Sean Christopherson wrote:
> > > > Sean Christopherson (8):
> > > >   x86/sgx: vdso: Remove an incorrect statement the enter enclave comment
> > > >   x86/sgx: vdso: Make the %rsp fixup on return from handler relative
> > > >   x86/sgx: vdso: Make __vdso_sgx_enter_enclave() callable from C code
> > > >   x86/sgx: vdso: Define a typedef for __vdso_sgx_enter_enclave
> > > >   selftests/x86: sgx: Zero out @result before invoking vDSO sub-test
> > > >   selftests/x86: sgx: Pass EENTER to vDSO wrapper instead of hardcoding
> > > >   selftests/x86: sgx: Stop clobbering non-volatile registers
> > > >   selftests/x86: Add selftest to invoke __vsgx_enter_enclave() from C
> > > > 
> > > >  arch/x86/entry/vdso/vsgx_enter_enclave.S      | 72 ++-----------------
> > > >  arch/x86/include/uapi/asm/sgx.h               | 61 ++++++++++++++++
> > > >  .../selftests/x86/sgx/encl_bootstrap.S        |  6 +-
> > > >  tools/testing/selftests/x86/sgx/main.c        | 17 ++++-
> > > >  tools/testing/selftests/x86/sgx/sgx_call.S    |  1 -
> > > >  tools/testing/selftests/x86/sgx/sgx_call.h    |  2 +-
> > > >  6 files changed, 85 insertions(+), 74 deletions(-)
> > > > 
> > > > -- 
> > > > 2.24.1
> > > > 
> > > 
> > > Might be a grazy idea but better to go through this anyway.
> > > 
> > > Given the premise that we need the carry the callback anyway in all
> > > cases, why won't just have the callback.
> > > 
> > > Why we absolutely need the code path that fills exception info given
> > > that we no matter what need to have a callback route?
> > > 
> > > Would simplify considerably to have only clear flow.
> > 
> > Invoking the callback uses a retpoline, which is non-trivial overhead.
> > For runtimes that need an assembly wrapper for other reasons, and aren't
> > using the untrusted stack, forcing them to implement a handler would be
> > painful.
> 
> The non-callback route only exists because we did not know that we have
> to do the callback route. It does not make sense to add something for
> any other reason than absolute necessity.

The non-callback route exists because it's simpler for the runtime to use
if it already has an asm wrapper and doesn't do stack shenanigans, e.g. the
runtime doesn't need to play games to get context information when handling
an exit.

And using a callback in conjunction with calling the vDSO from C is by no
means necessary, e.g. if the runtime is happy to die on exceptions, or if
it's doing clever clobbering, function annotation, longjump(), etc... to
avoid consuming corrupted state on an exception.

> Things would simplify in the vDSO implementation considerably. Now it is
> overwhelmingly complex for no good reason.

No it wouldn't, it literally saves zero instructions (unless the vDSO
wanted to crash the caller on a NULL pointer exception). It'd do nothing
more than move this code:

	/* Invoke userspace's exit handler if one was provided. */
.Lhandle_exit:
	cmp	$0, 0x20(%rbp)
	jne	.Linvoke_userspace_handler

up to the beginning of the code as

	/* Return -EINVAL if there's no userspace exit handler. */
	cmp	$0, 0x20(%rbp)
	je	.Linvalid_input

and the exit handler invocation would get inlined.  Unless I'm missing some
clever massaging of code, that's it.

At best the above could be dropped, but that's a whopping two instructions
and a single uop.
