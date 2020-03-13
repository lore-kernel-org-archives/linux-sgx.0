Return-Path: <SRS0=tI1m=46=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A93C2BB1D
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 20:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4DA420752
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 20:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZRj4sbyd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgCMUOR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 13 Mar 2020 16:14:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24250 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726528AbgCMUOQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 13 Mar 2020 16:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584130454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ra9NN4yow2WFvpKnbzrLfWOehuuyIIFKeOs27fVV+6g=;
        b=ZRj4sbyd4XhSnArGCS24+xVjTxbsTEet2+Hdu+ejkZ4bkiO9OJGOcetUeqXlk78viZDvA9
        s4sA7U7BzMsYSR7NHMPRxrMB8oUBiT9Z1dnW4XmTdMz9UCZdyfGEVIOKLngfnzATRfh6DH
        ig99dQ/dd3NnRsjWYmZLttuDq2+gqXA=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-anGar7WIM1ae_t2IVi0vRA-1; Fri, 13 Mar 2020 16:14:13 -0400
X-MC-Unique: anGar7WIM1ae_t2IVi0vRA-1
Received: by mail-il1-f198.google.com with SMTP id b72so7712255ilg.16
        for <linux-sgx@vger.kernel.org>; Fri, 13 Mar 2020 13:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ra9NN4yow2WFvpKnbzrLfWOehuuyIIFKeOs27fVV+6g=;
        b=aHmdyM2/Qj/Ax3VPL+uBGkvL/tPJBhmHDeWy8bd51px+kRuHKxnoBxkPjLk+MFpzLV
         bOVhsrsDacWELhik3T7B80Qku1+H0SXaAfHqvb6yIab5sGcAygaJPS0VyNFHKivzMOaR
         te2zpshsT6x2/z2QUyuLbO2KKm/mNubJ6tTHvE9hg3jiyH4foYDbl1A7blVax1pqr7mB
         iYJh47ZHUOul9+ibLa1I7JniExwyQCHVK6gEAqKXNt2bpoEGpwn7JqUbVX2Be5VSrM3c
         bFyYC3+L/XlXLpU7O5YqIRwo4Vp5T9dLah8u8nQuns4v2nYWAoQz3oTC2wmN4sffJj12
         2uAg==
X-Gm-Message-State: ANhLgQ2TYFGx1lZ3GWtjk5SX9Y4A17hhzn4FDa71vxz5+w6zUDQqzTTQ
        pMLqB5dgIn1Ba7ThhNE+RHqd5ZeSP4H58+QUN/2fV9q6ru8M/rioEhpqP7IUqI0hTSDjCYlSL0l
        Dz6L4R5efHtDNYbsSwtNBcfCmGPRA0nkYSjyk
X-Received: by 2002:a92:2542:: with SMTP id l63mr16094121ill.301.1584130452503;
        Fri, 13 Mar 2020 13:14:12 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt5EUEXswbzUU6qurbhPqIsAO6O1Xomu4Em3C3rvP6XALZCXUtBOcvubpedKa7cd5XBerXmTYuHK6wY8vpqZ3M=
X-Received: by 2002:a92:2542:: with SMTP id l63mr16094079ill.301.1584130452112;
 Fri, 13 Mar 2020 13:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <254f1e35-4302-e55f-c00d-0f91d9503498@fortanix.com> <CAOASepOm8-2UCdEnVMopEprMGWjkYUbUTX++dHaqCafi2ju8mA@mail.gmail.com>
 <20200313164622.GC5181@linux.intel.com> <CAOASepN1hxSgxVJAJiAbSmuCTCHd=95Mnvh6BKNSPJs=EpAmbQ@mail.gmail.com>
 <20200313184452.GD5181@linux.intel.com>
In-Reply-To: <20200313184452.GD5181@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Fri, 13 Mar 2020 16:14:01 -0400
Message-ID: <CAOASepP_oGOenjCvAvLg+e+=fz4H0X=cyD+v5ywD0peeXEEmYg@mail.gmail.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 13, 2020 at 2:45 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Mar 13, 2020 at 02:32:29PM -0400, Nathaniel McCallum wrote:
> > On Fri, Mar 13, 2020 at 12:46 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Fri, Mar 13, 2020 at 11:48:54AM -0400, Nathaniel McCallum wrote:
> > > > Therefore, I'd like to propose that __vdso_sgx_enter_enclave():
> > > >   * Preserve %rbx.
> > >
> > > At first glance, that looks sane.  Being able to call __vdso... from C
> > > would certainly be nice.
> >
> > Agreed. I think ergonomically we want __vdso...() to be called from C
> > and the handler to be implemented in asm (optionally); without
> > breaking the ability to call __vdso..() from asm in special cases.
> >
> > I think all ergonomic issues get solved by the following:
> >    * Pass a void * into the handler from C through __vdso...().
> >    * Allow the handler to pop parameters off of the output stack without hacks.
> >
> > This allows the handler to pop extra arguments off the stack and write
> > them into the memory at the void *. Then the handler can be very small
> > and pass logic back to the caller of __vdso...().
> >
> > Here's what this all means for the enclave. For maximum usability, the
> > enclave should preserve all callee-saved registers (except %rbx, which
> > is preserved by __vdso..()). For each ABI rule that the enclave
> > breaks, you need logic in a handler to fix it. So if you push return
> > params on the stack, the handler needs to undo that.
>
> Or the untrusted runtime needs to wrap the __vdso() to save state that is
> clobbered by the enclave.  Just want to make it crystal clear that using a
> handler is only required for stack shenanigans.

Yup.

> > This doesn't compromise the ability to treat __vsdo...() like ENCLU if
> > you need the full power. But it does make it significantly easier to
> > consume when you don't have special needs. So as I see it, __vdso...()
> > should:
> >
> > 1. preserve %rbx
> > 2. take leaf in %rcx
> > 3. gain a void* stack param which is passed to the handler
>
> Unless I'm misunderstanding the request, this already exists.  %rsp at the
> time of EEXIT is passed to the handler.

Sorry, different stack parameter. I mean this:

typedef int (*sgx_enclave_exit_handler_t)(
    long rdi,
    long rsi,
    long rdx,
    long ursp,
    long r8,
    long r9,
    int ret,
    void *tcs,
    struct sgx_enclave_exception *e,
    void *misc
);

int __vdso_sgx_enter_enclave(
    long rdi,
    long rsi,
    long rdx,
    int leaf,
    long r8,
    long r9,
    void *tcs,
    struct sgx_enclave_exception *e,
    void *misc,
    sgx_enclave_exit_handler_t handler
);

This is so that the caller of __vdso...() can pass context into the
handler. Note that I've also reordered the stack parameters so that
the stack order can be reused.

> > 4. sub/add to %rsp rather than save/restore
>
> Can you elaborate on why you want to sub/add to %rsp instead of having the
> enclave unwind the stack?  Preserving %rsp across EEXIT/ERESUME seems more
> in line with function call semantics, which I assume is desirable?  E.g.
>
>   push param3
>   push param2
>   push param1
>
>   enclu[EEXIT]
>
>   add $0x18, %rsp

Before enclave EEXIT, the enclave restores %rsp to the value it had
before EENTER was called. Then it pushes additional output arguments
onto the stack. The enclave calls EENCLU[EEXIT].

We are now in __vdso...() on the way back to the caller. However, %rsp
has a different value than we entered the function with. This breaks
x86_64 ABI, obviously. The handler needs to fix this up: how does it
do so?

In the current code, __vdso..() saves the value of %rsp, calls the
handler and then restores %rsp. The handler can fix up the stack by
setting the correct value to %rbx and returning without restoring it.
But this requires internal knowledge of the __vdso...() function,
which could theoretically change in the future.

If instead the __vdso...() only did add/sub, then the handler could do:
1. pop return address
2. pop handler stack params
3. pop enclave additional output stack params
4. push handler stack params
5. push return address

While this is more work, it is standard calling convention work that
doesn't require internal knowledge of __vdso..(). Alternatively, if we
don't like the extra work, we can document the %rbx hack explicitly
into the handler documentation and make it part of the interface. But
we need some explicit way for the handler to pop enclave output stack
params that doesn't depend on internal knowledge of the __vdso...()
invariants.

> > That would make this a very usable and fast interface without
> > sacrificing any of its current power.
>

