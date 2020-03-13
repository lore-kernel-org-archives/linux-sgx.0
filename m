Return-Path: <SRS0=tI1m=46=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9F8C4CECE
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 18:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F4812074A
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 18:32:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eNCwoaHy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgCMScp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 13 Mar 2020 14:32:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34195 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726339AbgCMScp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 13 Mar 2020 14:32:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584124364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3m4Rn0qHyWmTm14emhIRtvuFR2s0moOwY/yLhDcqE5E=;
        b=eNCwoaHyduOPsHar7cOTwMizuT0yKH8lDmy4K7eqnsY9x2G5n3gSDOZ2+1Wbo2R95HMM+1
        ITvDlF//eu85CXlDm8nS3UyvhMIpgRmSw05RzpoAqamm1x0QvNBExkxTw+q+dIBEmQnSv6
        lYptIZgEUxYsJvqnW1YzxPR2SlAgrFc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-cQy0RpfJOQGMFpKq1o4www-1; Fri, 13 Mar 2020 14:32:43 -0400
X-MC-Unique: cQy0RpfJOQGMFpKq1o4www-1
Received: by mail-io1-f72.google.com with SMTP id q10so7106595ioh.9
        for <linux-sgx@vger.kernel.org>; Fri, 13 Mar 2020 11:32:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3m4Rn0qHyWmTm14emhIRtvuFR2s0moOwY/yLhDcqE5E=;
        b=pPh/par+7GBTwn74yBObNj6r7LlkSd1CKTNMTeKnE6gBw96sGFh7wS+edlGFkdTd9t
         TTAPeuPzpygBuQ/7+sIo11VGlW5Bl/sPAZ5kJVeJYlXcpyJe1trik+KwtCtzDbMtYmYH
         ClzEXB5dAjj2pcc9gi7kK6dO62KRe4gWjYUzeRYJoqDl3ZnKjWkXMKvTSmK3obkRUvVN
         qGVQFlPA3T2T8UZkmvVnrt+CzYaN6k6gs9fe203OHkiBsYu8lk60/2EcT/LQKrnUJIVG
         jXp522OgZGzwpnU02TaVIm8U2tShMiOjvHmCUqr6ZFB55BEJcTiQRthNmJFh7vhyu9c/
         YuTA==
X-Gm-Message-State: ANhLgQ2HhTp7rdO1lYyUcLDny6Ghd98qRRCDg/DATeoMH8nC3HF98AVn
        p4SFvtLYsCmT6eHtWlLrp7txu78ZWKx1yXRCia5dPlo5R4Bdh+37WM/ePG2bYV3Xh/UoE540xDE
        bpgMT+FjSKEM7lD8nBrteECKP2itNuo3tNjya
X-Received: by 2002:a92:9f4e:: with SMTP id u75mr14766191ili.116.1584124360278;
        Fri, 13 Mar 2020 11:32:40 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vthyy+v4v/Q4P5In4zddVuAOvxBXuwSwvMbS3t3Zx+C9rEXBfmwE6XdtCY2jQpgH5/KwJjQ1vpCgv1QI0zp2n8=
X-Received: by 2002:a92:9f4e:: with SMTP id u75mr14766155ili.116.1584124359900;
 Fri, 13 Mar 2020 11:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <254f1e35-4302-e55f-c00d-0f91d9503498@fortanix.com> <CAOASepOm8-2UCdEnVMopEprMGWjkYUbUTX++dHaqCafi2ju8mA@mail.gmail.com>
 <20200313164622.GC5181@linux.intel.com>
In-Reply-To: <20200313164622.GC5181@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Fri, 13 Mar 2020 14:32:29 -0400
Message-ID: <CAOASepN1hxSgxVJAJiAbSmuCTCHd=95Mnvh6BKNSPJs=EpAmbQ@mail.gmail.com>
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

On Fri, Mar 13, 2020 at 12:46 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Mar 13, 2020 at 11:48:54AM -0400, Nathaniel McCallum wrote:
> > Thinking about this more carefully, I still think that at least part
> > of my critique still stands.
> >
> > __vdso_sgx_enter_enclave() doesn't use the x86-64 ABI. This means that
> > there will always be an assembly wrapper for
> > __vdso_sgx_enter_enclave(). But because __vdso_sgx_enter_enclave()
> > doesn't save %rbx, the wrapper is forced to in order to be called from
> > C.
> >
> > A common pattern for the wrapper will be to do something like this:
> >
> > # void enter_enclave(rdi, rsi, rdx, unused, r8, r9, @tcs, @e,
> > @handler, @leaf, @vdso)
> > enter_enclave:
> >     push %rbx
> >     push $0 /* align */
> >     push 0x48(%rsp)
> >     push 0x48(%rsp)
> >     push 0x48(%rsp)
> >
> >     mov 0x70(%rsp), %eax
> >     call *0x68(%rsp)
> >
> >     add $0x20, %rsp
> >     pop %rbx
> >     ret
> >
> > Because __vdso_sgx_enter_enclave() doesn't preserve %rbx, the wrapper
> > is forced to reposition stack parameters in a performance-critical
> > path. On the other hand, if __vdso_sgx_enter_enclave() preserved %rbx,
> > you could implement the above as:
> >
> > # void enter_enclave(rdi, rsi, rdx, unused, r8, r9, @tcs, @e,
> > @handler, @leaf, @vdso)
> > enter_enclave:
> >     mov 0x20(%rsp), %eax
> >     jmp *0x28(%rsp)
> >
> > This also implies that if __vdso_sgx_enter_enclave() took @leaf as a
> > stack parameter and preserved %rbx, it would be x86-64 ABI compliant
> > enough to call from C if the enclave preserves all callee-saved
> > registers besides %rbx (Enarx does).
> >
> > What are the downsides of this approach? It also doesn't harm the more
> > extended case when you need to use an assembly wrapper to setup
> > additional registers. This can still be done. It does imply an extra
> > push and mov instruction. But because there are currently an odd
> > number of stack function parameters, the push also removes an
> > alignment instruction where the stack is aligned before the call to
> > __vdso_sgx_enter_enclave() (likely). Further, the push and mov are
> > going to be performed by *someone* in order to call
> > __vdso_sgx_enter_enclave() from C.
> >
> > Therefore, I'd like to propose that __vdso_sgx_enter_enclave():
> >   * Preserve %rbx.
>
> At first glance, that looks sane.  Being able to call __vdso... from C
> would certainly be nice.

Agreed. I think ergonomically we want __vdso...() to be called from C
and the handler to be implemented in asm (optionally); without
breaking the ability to call __vdso..() from asm in special cases.

I think all ergonomic issues get solved by the following:
   * Pass a void * into the handler from C through __vdso...().
   * Allow the handler to pop parameters off of the output stack without hacks.

This allows the handler to pop extra arguments off the stack and write
them into the memory at the void *. Then the handler can be very small
and pass logic back to the caller of __vdso...().

Here's what this all means for the enclave. For maximum usability, the
enclave should preserve all callee-saved registers (except %rbx, which
is preserved by __vdso..()). For each ABI rule that the enclave
breaks, you need logic in a handler to fix it. So if you push return
params on the stack, the handler needs to undo that.

This doesn't compromise the ability to treat __vsdo...() like ENCLU if
you need the full power. But it does make it significantly easier to
consume when you don't have special needs. So as I see it, __vdso...()
should:

1. preserve %rbx
2. take leaf in %rcx
3. gain a void* stack param which is passed to the handler
4. sub/add to %rsp rather than save/restore

That would make this a very usable and fast interface without
sacrificing any of its current power.

> >   * Take the leaf as an additional stack parameter instead of passing
> > it in %rax.
>
> Does the leaf even need to be a stack param?  Wouldn't it be possible to
> use %rcx as @leaf instead of @unusued?  E.g.

Even better!

> int __vdso_sgx_enter_enclave(unsigned long rdi, unsigned long rsi,
>                              unsigned long rdx, unsigned int leaf,
>                              unsigned long r8,  unsigned long r9,
>                              void *tcs, struct sgx_enclave_exception *e,
>                              sgx_enclave_exit_handler_t handler)
> {
>         push    %rbp
>         mov     %rsp, %rbp
>         push    %rbx
>
>         mov     %ecx, %eax
> .Lenter_enclave
>         cmp     $0x2, %eax
>         jb      .Linvalid_leaf
>         cmp     $0x3, %eax
>         ja      .Linvalid_leaf
>
>         mov     0x0x10(%rbp), %rbx
>         lea     .Lasync_exit_pointer(%rip), %rcx
>
> .Lasync_exit_pointer:
> .Lenclu_eenter_eresume:
>         enclu
>
>         xor     %eax, %eax
>
> .Lhandle_exit:
>         cmp     $0, 0x20(%rbp)
>         jne     .Linvoke_userspace_handler
>
> .Lout
>         pop     %rbx
>         leave
>         ret
> }
>
>
> > Then C can call it without additional overhead. And people who need to
> > "extend" the C ABI can still do so.
> >
>

