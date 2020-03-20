Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E18DC4332D
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 00:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CB8320752
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 00:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgCTA53 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 20:57:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:26410 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCTA53 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 20:57:29 -0400
IronPort-SDR: AQsiO1cmbUe9J7w8aOvqK/ND9zNJHhpYjwJppqLeziZ7Ryh0IIyQTj1gLx9CRzmSTziwazqE4S
 023RurB/0ilA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 17:57:28 -0700
IronPort-SDR: IKvb0KnxlYRupOMVqgx5vFRosQdlJvDr4hN9lz/4JXTbY+/tcGGxNgtPvkL4OVDkG46dT74e6+
 ZhWZswT0U1kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,573,1580803200"; 
   d="scan'208";a="444790311"
Received: from anakash-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.183.74])
  by fmsmga005.fm.intel.com with ESMTP; 19 Mar 2020 17:57:25 -0700
Date:   Fri, 20 Mar 2020 02:57:24 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 0/8] x86/sgx: Make vDSO callable from C
Message-ID: <20200320005724.GA182892@linux.intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319011130.8556-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 18, 2020 at 06:11:22PM -0700, Sean Christopherson wrote:
> Nathaniel pointed out that __vdso_sgx_enter_enclave() is tantalizingly
> close to being callable from C (with caveats and a cooperative enclave).
> The missing pieces are preserving %rbx and taking @leaf as a standard
> paramter (hey look, %rcx is available!).
> 
> As requested, update the selftest to invoke the vDSO from C, and fix
> bugs along the way.  Don't suppose you've changed your mind about waiting
> until after upstreaming to add a proper framework?
> 
> I also did a lot more testing on my internal code base to verify the
> %rsp tweaks play nice with the exit handler, and to prove that an exit
> handler can even cleanly handle exceptions in the enclave.
> 
> Here's the relevant code from my internal test suite, might want to have
> eye bleach ready ;-).  I tested the exception handling by overwriting
> @ms in enter_enclave() with a bogus value, e.g. 0xdeadull << 0x48.  The
> nested call to the vDSO (in the exit handler) with EMCD_EXCEPTION has the
> enclave dump its register.  The host (this runs as cgo in a Golang process)
> dumps the exception info.
> 
> I also verified the relative %rsp fixup by corrupting %rsp in the enclave,
> verifying it exploded as expected (I added extra consumption in the vDSO to
> force this) and then adding code to undo the damage in the exit handler and
> verifying things got back to normal.
> 
> Last thread of thought, IMO taking a context param (as suggested by
> Nathaniel) is unnecessary.  As shown below, the runtime effectively has a
> context param in the form of "struct sgx_enclave_exception *e", the handler
> just needs to be willing to cast (or use container_of()).  There are a
> multitude of other ways to pass info as well.
> 
> vdso_sgx_enter_enclave_t __enter_enclave;
> 
> vDSO::vDSO()
> {
>     if (__enter_enclave)
>         abort();
> 
>     uintptr_t vdso = (uintptr_t)getauxval(AT_SYSINFO_EHDR);
>     vdso_init_from_sysinfo_ehdr(vdso);
> 
>     __enter_enclave = (vdso_sgx_enter_enclave_t)vdso_sym("LINUX_2.6", "__vdso_sgx_enter_enclave");
>     if (!__enter_enclave)
>         abort();
> }
> 
> struct sgx_vdso_ctxt {
>     sgx_exception_t e;
>     long            ret;
>     Enclave *       enclave;
>     jmp_buf         buf;
> };
> 
> static int exit_handler(long rdi, long rsi, long rdx, long ursp, long r8, long r9,
>                         void *tcs, int ret, struct sgx_enclave_exception *e)
> {
>     struct sgx_vdso_ctxt *ctxt = (struct sgx_vdso_ctxt *)e;
>     int r;
> 
>     if (!ret) {
>         if (ctxt)
>             ctxt->ret = rdi;
>         return 0;
>     }
> 
>     if (!ctxt)
>         exit(EFAULT);
> 
>     r = __enter_enclave(ECMD_EXCEPTION, (unsigned long)&ctxt->e.regs, 0, EENTER,
>                         0, 0, tcs, NULL, exit_handler);
>     if (r)
>         exit(-r);
> 
>     ctxt->enclave->set_exception(ctxt->e);
> 
>     longjmp(ctxt->buf, ret);
> }
> 
> sgx_status_t vDSO::enter_enclave(Enclave &enclave, const long fn, void *ms, tcs_t *tcs)
> {
>     struct sgx_vdso_ctxt ctxt;
>     ctxt.enclave = &enclave;
> 
>     int ret = setjmp(ctxt.buf);
>     if (ret) {
>         if (ret != -EFAULT)
>             return SGX_ERROR_INVALID_PARAMETER;
> 
>         SE_URTS_ERROR("\nEnclave exception, base = %lx, size = %lx",
>                       enclave.get_base(), enclave.get_size());
> 
>         return SGX_ERROR_UNHANDLED_EXCEPTION;
>     }
> 
>     ret = __enter_enclave(fn, (unsigned long)ms, 0, EENTER, 0, 0, tcs,
>                           &ctxt.e.fault, exit_handler);
>     if (ret == -EINVAL)
>         return SGX_ERROR_INVALID_PARAMETER;
> 
>     return (sgx_status_t)ctxt.ret;
> }
> 
> Sean Christopherson (8):
>   x86/sgx: vdso: Remove an incorrect statement the enter enclave comment
>   x86/sgx: vdso: Make the %rsp fixup on return from handler relative
>   x86/sgx: vdso: Make __vdso_sgx_enter_enclave() callable from C code
>   x86/sgx: vdso: Define a typedef for __vdso_sgx_enter_enclave
>   selftests/x86: sgx: Zero out @result before invoking vDSO sub-test
>   selftests/x86: sgx: Pass EENTER to vDSO wrapper instead of hardcoding
>   selftests/x86: sgx: Stop clobbering non-volatile registers
>   selftests/x86: Add selftest to invoke __vsgx_enter_enclave() from C
> 
>  arch/x86/entry/vdso/vsgx_enter_enclave.S      | 72 ++-----------------
>  arch/x86/include/uapi/asm/sgx.h               | 61 ++++++++++++++++
>  .../selftests/x86/sgx/encl_bootstrap.S        |  6 +-
>  tools/testing/selftests/x86/sgx/main.c        | 17 ++++-
>  tools/testing/selftests/x86/sgx/sgx_call.S    |  1 -
>  tools/testing/selftests/x86/sgx/sgx_call.h    |  2 +-
>  6 files changed, 85 insertions(+), 74 deletions(-)
> 
> -- 
> 2.24.1
> 

Might be a grazy idea but better to go through this anyway.

Given the premise that we need the carry the callback anyway in all
cases, why won't just have the callback.

Why we absolutely need the code path that fills exception info given
that we no matter what need to have a callback route?

Would simplify considerably to have only clear flow.

/Jarkko
