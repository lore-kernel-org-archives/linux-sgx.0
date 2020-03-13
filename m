Return-Path: <SRS0=tI1m=46=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EAC7C10DCE
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 22:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F1562074A
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 22:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgCMWIW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 13 Mar 2020 18:08:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:55138 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgCMWIV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 13 Mar 2020 18:08:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Mar 2020 15:08:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,550,1574150400"; 
   d="scan'208";a="390046224"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 13 Mar 2020 15:08:20 -0700
Date:   Fri, 13 Mar 2020 15:08:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        cedric.xing@intel.com, Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200313220820.GE5181@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <254f1e35-4302-e55f-c00d-0f91d9503498@fortanix.com>
 <CAOASepOm8-2UCdEnVMopEprMGWjkYUbUTX++dHaqCafi2ju8mA@mail.gmail.com>
 <20200313164622.GC5181@linux.intel.com>
 <CAOASepN1hxSgxVJAJiAbSmuCTCHd=95Mnvh6BKNSPJs=EpAmbQ@mail.gmail.com>
 <20200313184452.GD5181@linux.intel.com>
 <CAOASepP_oGOenjCvAvLg+e+=fz4H0X=cyD+v5ywD0peeXEEmYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepP_oGOenjCvAvLg+e+=fz4H0X=cyD+v5ywD0peeXEEmYg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 13, 2020 at 04:14:01PM -0400, Nathaniel McCallum wrote:
> On Fri, Mar 13, 2020 at 2:45 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
 > > This doesn't compromise the ability to treat __vsdo...() like ENCLU if
> > > you need the full power. But it does make it significantly easier to
> > > consume when you don't have special needs. So as I see it, __vdso...()
> > > should:
> > >
> > > 1. preserve %rbx
> > > 2. take leaf in %rcx
> > > 3. gain a void* stack param which is passed to the handler
> >
> > Unless I'm misunderstanding the request, this already exists.  %rsp at the
> > time of EEXIT is passed to the handler.
> 
> Sorry, different stack parameter. I mean this:
> 
> typedef int (*sgx_enclave_exit_handler_t)(
>     long rdi,
>     long rsi,
>     long rdx,
>     long ursp,
>     long r8,
>     long r9,
>     int ret,
>     void *tcs,
>     struct sgx_enclave_exception *e,
>     void *misc
> );
> 
> int __vdso_sgx_enter_enclave(
>     long rdi,
>     long rsi,
>     long rdx,
>     int leaf,
>     long r8,
>     long r9,
>     void *tcs,
>     struct sgx_enclave_exception *e,
>     void *misc,
>     sgx_enclave_exit_handler_t handler
> );
> 
> This is so that the caller of __vdso...() can pass context into the
> handler.

Hrm, I'm not a fan of adding a param that is only consumed by the handler,
especially when there are multiple alternatives, e.g. fudge the param in
assembly before calling __vdso(), have the enclave supply the context in a
volatile register, etc...

> Note that I've also reordered the stack parameters so that the stack
> order can be reused.

Ah, ret<->tcs, took me a minute...

Does preserving tsc->e->misc ordering matter all that much?  __vdso() needs
to manually copy them either way.  I ask because putting @misc at the end
would allow implementations that don't use @handler to omit the param (if
I've done my math correctly, which is always a big if).  That would make
adding the handler-only param a little more palatable.

> > > 4. sub/add to %rsp rather than save/restore
> >
> > Can you elaborate on why you want to sub/add to %rsp instead of having the
> > enclave unwind the stack?  Preserving %rsp across EEXIT/ERESUME seems more
> > in line with function call semantics, which I assume is desirable?  E.g.
> >
> >   push param3
> >   push param2
> >   push param1
> >
> >   enclu[EEXIT]
> >
> >   add $0x18, %rsp
> 
> Before enclave EEXIT, the enclave restores %rsp to the value it had
> before EENTER was called. Then it pushes additional output arguments
> onto the stack. The enclave calls EENCLU[EEXIT].
> 
> We are now in __vdso...() on the way back to the caller. However, %rsp
> has a different value than we entered the function with. This breaks
> x86_64 ABI, obviously. The handler needs to fix this up: how does it
> do so?
> 
> In the current code, __vdso..() saves the value of %rsp, calls the
> handler and then restores %rsp. The handler can fix up the stack by
> setting the correct value to %rbx and returning without restoring it.

Ah, you're referring to the patch where the handler decides to return all
the way back to the caller of __vdso...().

> But this requires internal knowledge of the __vdso...() function,
> which could theoretically change in the future.
> 
> If instead the __vdso...() only did add/sub, then the handler could do:
> 1. pop return address
> 2. pop handler stack params
> 3. pop enclave additional output stack params
> 4. push handler stack params
> 5. push return address
> 
> While this is more work, it is standard calling convention work that
> doesn't require internal knowledge of __vdso..(). Alternatively, if we
> don't like the extra work, we can document the %rbx hack explicitly
> into the handler documentation and make it part of the interface. But
> we need some explicit way for the handler to pop enclave output stack
> params that doesn't depend on internal knowledge of the __vdso...()
> invariants.

IIUC, this is what you're suggesting?  Having to align the stack makes this
a bit annoying, but it's not bad by any means.

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 94a8e5f99961..05d54f79b557 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -139,8 +139,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
        /* Pass the untrusted RSP (at exit) to the callback via %rcx. */
        mov     %rsp, %rcx

-       /* Save the untrusted RSP in %rbx (non-volatile register). */
+       /* Save the untrusted RSP offset in %rbx (non-volatile register). */
        mov     %rsp, %rbx
+       and     $0xf, %rbx

        /*
         * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
@@ -161,8 +162,8 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
        mov     0x20(%rbp), %rax
        call    .Lretpoline

-       /* Restore %rsp to its post-exit value. */
-       mov     %rbx, %rsp
+       /* Undo the post-exit %rsp adjustment. */
+       lea     0x20(%rsp,%rbx), %rsp


That's reasonable, let's the handler play more games with minimal overhead.

> > > That would make this a very usable and fast interface without
> > > sacrificing any of its current power.
> >
> 
