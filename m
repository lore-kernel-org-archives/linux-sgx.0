Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F98C433DF
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 171C5206B2
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FnYwn8Ms"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgHFR4U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:56:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26658 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727006AbgHFQR0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 12:17:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596730591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=onEWWUD1yYFf96Ib5iYdabPbRCsNrpZZ92IFVcR6Rs0=;
        b=FnYwn8MsRFQrRZdp7IXdXnSMrLYzKKc7oSXLnM1L1BmEMs4qT6WailwHuKDe9a/Ouqp27k
        Rsd/ERNS/2sv4w7vsOXg43+vvJyfBTFeEMP1itX/fPKRza/aWOlKeZY5xpw3Actm8X5Po+
        qhLbSiBte35AVw0aEX6jOxEM9tkb8aM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-O1c-7MmNMcSECVMWybl4YQ-1; Thu, 06 Aug 2020 10:55:55 -0400
X-MC-Unique: O1c-7MmNMcSECVMWybl4YQ-1
Received: by mail-il1-f199.google.com with SMTP id v13so23342431ila.20
        for <linux-sgx@vger.kernel.org>; Thu, 06 Aug 2020 07:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=onEWWUD1yYFf96Ib5iYdabPbRCsNrpZZ92IFVcR6Rs0=;
        b=hVLO8+WC9qY9kBv63EVhYy+2qKCOLKUfngq+QLSpkQx+1TwBPrlRCObvwx4PVjD0AU
         Cy6u3gGBzGFHtXGerQyyo8bnH31yH5oeBf/mGMwyFsgW03nOgYwZFV3bBxn1PNWcb8+2
         oRNqEwH+9ZRWcK4zE0T7m6DC+0zLDIJwUXKspbgumN0FEh4p6zBO09LS/ONPB2718PFD
         36o0MkBccsJpbqHOL9C8SNQk5StEatjI8q/EJzx5HJ4G9OmYXo2lOxm5dGIJQtubz84B
         IsfFXCWxh2OzfTWeTTv7YIkMToRyKK9yj8tSUcA6yOQsc3A9ka0lgcUO9ZcBfODGHXk5
         BrbA==
X-Gm-Message-State: AOAM531oXfAEtxpJ0eirzBHghMtjUtdD4Ed0OT5UMRcWe4aRKv6Jw5dT
        xUXPpfMN4WcTcE3OMmIq7L5qpzAnfG3f1Rp3oJi6FRO+DKSR8h6hk9obN2ik/cyTG9VBH+zSN/B
        BHksmmEvMXq80b060qmv5fBnrqvzksvN9DbUz
X-Received: by 2002:a92:4b08:: with SMTP id m8mr10910217ilg.11.1596725754481;
        Thu, 06 Aug 2020 07:55:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuJAGOPwP7OrTmjnN3rRa8ddHgXxsPgsj1Q2/acIxvDPuw3FHxbSArh+QHe2ZDGjFvubofSLbbD2G+jWL7cf4=
X-Received: by 2002:a92:4b08:: with SMTP id m8mr10910153ilg.11.1596725753996;
 Thu, 06 Aug 2020 07:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com> <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Thu, 6 Aug 2020 10:55:43 -0400
Message-ID: <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>, kai.huang@intel.com,
        "Svahn, Kai" <kai.svahn@intel.com>, kmoy@google.com,
        ludloff@google.com, luto@kernel.org,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nmccallu@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In a past revision of this patch, I had requested a void *misc
parameter that could be passed through vdso_sgx_enter_enclave_t into
sgx_enclave_exit_handler_t. This request encountered some push back
and I dropped the issue. However, I'd like to revisit it or something
similar.

One way to create a generic interface to SGX is to pass a structure
that captures the relevant CPU state from the handler so that it can
be evaluated in C code before reentry. Precedent for this approach can
be found in struct kvm_run[0]. Currently, however, there is no way to
pass a pointer to such a structure directly into the handler.

This can be done implicitly by wrapping the struct
sgx_enclave_exception in another structure and then using techniques
like container_of() to find another field. However, this is made more
difficult by the fact that the sgx_enclave_exit_handler_t is not
really using the x86_64 sysv calling convention. Therefore, the
sgx_enclave_exit_handler_t MUST be written in assembly. This also
implies that we can't use techniques like container_of() and must
calculate all the offsets manually, which is tedious, error prone and
fragile.

This is further complicated by the fact that I'm using Rust (as are a
number of other consumers), which has no native offsetof support (yes,
there is a crate for it, but it requires a number of complex
strategies to defeat the compiler which aren't great) and therefore no
container_of() support.

We could design a standard struct for this (similar to struct
kvm_run). But in order to keep performance in check we'd have to
define a limited ABI surface (to avoid things like xsave) which
wouldn't have the full flexibility of the current approach. This would
allow for a kernel provided vDSO function with a normal calling
convention, however (which does have some non-trivial value). I think
this is a trade-off we should consider (perhaps making it optional?).

But at the least, allowing a pass-through void *misc would reduce the
complexity of the assembly calculations.

[0]: https://github.com/torvalds/linux/blob/master/include/uapi/linux/kvm.h#L263

On Thu, Jul 16, 2020 at 9:58 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> An SGX runtime must be aware of the exceptions, which happen inside an
> enclave. Introduce a vDSO call that wraps EENTER/ERESUME cycle and returns
> the CPU exception back to the caller exactly when it happens.
>
> Kernel fixups the exception information to RDI, RSI and RDX. The SGX call
> vDSO handler fills this information to the user provided buffer or
> alternatively trigger user provided callback at the time of the exception.
>
> The calling convention is custom and does not follow System V x86-64 ABI.
>
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Cedric Xing <cedric.xing@intel.com>
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/entry/vdso/Makefile             |   2 +
>  arch/x86/entry/vdso/vdso.lds.S           |   1 +
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 131 +++++++++++++++++++++++
>  arch/x86/include/asm/enclu.h             |   8 ++
>  arch/x86/include/uapi/asm/sgx.h          |  98 +++++++++++++++++
>  5 files changed, 240 insertions(+)
>  create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
>  create mode 100644 arch/x86/include/asm/enclu.h
>
> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
> index ebe82b7aecda..f71ad5ebd0c4 100644
> --- a/arch/x86/entry/vdso/Makefile
> +++ b/arch/x86/entry/vdso/Makefile
> @@ -29,6 +29,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)       := y
>  vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
>  vobjs32-y := vdso32/note.o vdso32/system_call.o vdso32/sigreturn.o
>  vobjs32-y += vdso32/vclock_gettime.o
> +vobjs-$(VDSO64-y)              += vsgx_enter_enclave.o
>
>  # files to link into kernel
>  obj-y                          += vma.o extable.o
> @@ -100,6 +101,7 @@ $(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS
>  CFLAGS_REMOVE_vclock_gettime.o = -pg
>  CFLAGS_REMOVE_vdso32/vclock_gettime.o = -pg
>  CFLAGS_REMOVE_vgetcpu.o = -pg
> +CFLAGS_REMOVE_vsgx_enter_enclave.o = -pg
>
>  #
>  # X32 processes use x32 vDSO to access 64bit kernel data.
> diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso.lds.S
> index 36b644e16272..4bf48462fca7 100644
> --- a/arch/x86/entry/vdso/vdso.lds.S
> +++ b/arch/x86/entry/vdso/vdso.lds.S
> @@ -27,6 +27,7 @@ VERSION {
>                 __vdso_time;
>                 clock_getres;
>                 __vdso_clock_getres;
> +               __vdso_sgx_enter_enclave;
>         local: *;
>         };
>  }
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> new file mode 100644
> index 000000000000..be7e467e1efb
> --- /dev/null
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -0,0 +1,131 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include <linux/linkage.h>
> +#include <asm/export.h>
> +#include <asm/errno.h>
> +#include <asm/enclu.h>
> +
> +#include "extable.h"
> +
> +#define EX_LEAF                0*8
> +#define EX_TRAPNR      0*8+4
> +#define EX_ERROR_CODE  0*8+6
> +#define EX_ADDRESS     1*8
> +
> +.code64
> +.section .text, "ax"
> +
> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> +       /* Prolog */
> +       .cfi_startproc
> +       push    %rbp
> +       .cfi_adjust_cfa_offset  8
> +       .cfi_rel_offset         %rbp, 0
> +       mov     %rsp, %rbp
> +       .cfi_def_cfa_register   %rbp
> +       push    %rbx
> +       .cfi_rel_offset         %rbx, -8
> +
> +       mov     %ecx, %eax
> +.Lenter_enclave:
> +       /* EENTER <= leaf <= ERESUME */
> +       cmp     $EENTER, %eax
> +       jb      .Linvalid_leaf
> +       cmp     $ERESUME, %eax
> +       ja      .Linvalid_leaf
> +
> +       /* Load TCS and AEP */
> +       mov     0x10(%rbp), %rbx
> +       lea     .Lasync_exit_pointer(%rip), %rcx
> +
> +       /* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> +.Lasync_exit_pointer:
> +.Lenclu_eenter_eresume:
> +       enclu
> +
> +       /* EEXIT jumps here unless the enclave is doing something fancy. */
> +       xor     %eax, %eax
> +
> +       /* Invoke userspace's exit handler if one was provided. */
> +.Lhandle_exit:
> +       cmp     $0, 0x20(%rbp)
> +       jne     .Linvoke_userspace_handler
> +
> +.Lout:
> +       pop     %rbx
> +       leave
> +       .cfi_def_cfa            %rsp, 8
> +       ret
> +
> +       /* The out-of-line code runs with the pre-leave stack frame. */
> +       .cfi_def_cfa            %rbp, 16
> +
> +.Linvalid_leaf:
> +       mov     $(-EINVAL), %eax
> +       jmp     .Lout
> +
> +.Lhandle_exception:
> +       mov     0x18(%rbp), %rcx
> +       test    %rcx, %rcx
> +       je      .Lskip_exception_info
> +
> +       /* Fill optional exception info. */
> +       mov     %eax, EX_LEAF(%rcx)
> +       mov     %di,  EX_TRAPNR(%rcx)
> +       mov     %si,  EX_ERROR_CODE(%rcx)
> +       mov     %rdx, EX_ADDRESS(%rcx)
> +.Lskip_exception_info:
> +       mov     $(-EFAULT), %eax
> +       jmp     .Lhandle_exit
> +
> +.Linvoke_userspace_handler:
> +       /* Pass the untrusted RSP (at exit) to the callback via %rcx. */
> +       mov     %rsp, %rcx
> +
> +       /* Save the untrusted RSP offset in %rbx (non-volatile register). */
> +       mov     %rsp, %rbx
> +       and     $0xf, %rbx
> +
> +       /*
> +        * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
> +        * _after_ pushing the parameters on the stack, hence the bonus push.
> +        */
> +       and     $-0x10, %rsp
> +       push    %rax
> +
> +       /* Push @e, the "return" value and @tcs as params to the callback. */
> +       push    0x18(%rbp)
> +       push    %rax
> +       push    0x10(%rbp)
> +
> +       /* Clear RFLAGS.DF per x86_64 ABI */
> +       cld
> +
> +       /* Load the callback pointer to %rax and invoke it via retpoline. */
> +       mov     0x20(%rbp), %rax
> +       call    .Lretpoline
> +
> +       /* Undo the post-exit %rsp adjustment. */
> +       lea     0x20(%rsp, %rbx), %rsp
> +
> +       /*
> +        * If the return from callback is zero or negative, return immediately,
> +        * else re-execute ENCLU with the postive return value interpreted as
> +        * the requested ENCLU leaf.
> +        */
> +       cmp     $0, %eax
> +       jle     .Lout
> +       jmp     .Lenter_enclave
> +
> +.Lretpoline:
> +       call    2f
> +1:     pause
> +       lfence
> +       jmp     1b
> +2:     mov     %rax, (%rsp)
> +       ret
> +       .cfi_endproc
> +
> +_ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
> +
> +SYM_FUNC_END(__vdso_sgx_enter_enclave)
> diff --git a/arch/x86/include/asm/enclu.h b/arch/x86/include/asm/enclu.h
> new file mode 100644
> index 000000000000..06157b3e9ede
> --- /dev/null
> +++ b/arch/x86/include/asm/enclu.h
> @@ -0,0 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_ENCLU_H
> +#define _ASM_X86_ENCLU_H
> +
> +#define EENTER 0x02
> +#define ERESUME        0x03
> +
> +#endif /* _ASM_X86_ENCLU_H */
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 57d0d30c79b3..3760e5d5dc0c 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -74,4 +74,102 @@ struct sgx_enclave_set_attribute {
>         __u64 attribute_fd;
>  };
>
> +/**
> + * struct sgx_enclave_exception - structure to report exceptions encountered in
> + *                               __vdso_sgx_enter_enclave()
> + *
> + * @leaf:      ENCLU leaf from \%eax at time of exception
> + * @trapnr:    exception trap number, a.k.a. fault vector
> + * @error_code:        exception error code
> + * @address:   exception address, e.g. CR2 on a #PF
> + * @reserved:  reserved for future use
> + */
> +struct sgx_enclave_exception {
> +       __u32 leaf;
> +       __u16 trapnr;
> +       __u16 error_code;
> +       __u64 address;
> +       __u64 reserved[2];
> +};
> +
> +/**
> + * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
> + *                                     __vdso_sgx_enter_enclave()
> + *
> + * @rdi:       RDI at the time of enclave exit
> + * @rsi:       RSI at the time of enclave exit
> + * @rdx:       RDX at the time of enclave exit
> + * @ursp:      RSP at the time of enclave exit (untrusted stack)
> + * @r8:                R8 at the time of enclave exit
> + * @r9:                R9 at the time of enclave exit
> + * @tcs:       Thread Control Structure used to enter enclave
> + * @ret:       0 on success (EEXIT), -EFAULT on an exception
> + * @e:         Pointer to struct sgx_enclave_exception (as provided by caller)
> + */
> +typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
> +                                         long ursp, long r8, long r9,
> +                                         void *tcs, int ret,
> +                                         struct sgx_enclave_exception *e);
> +
> +/**
> + * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> + * @rdi:       Pass-through value for RDI
> + * @rsi:       Pass-through value for RSI
> + * @rdx:       Pass-through value for RDX
> + * @leaf:      ENCLU leaf, must be EENTER or ERESUME
> + * @r8:                Pass-through value for R8
> + * @r9:                Pass-through value for R9
> + * @tcs:       TCS, must be non-NULL
> + * @e:         Optional struct sgx_enclave_exception instance
> + * @handler:   Optional enclave exit handler
> + *
> + * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance with the
> + * x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.  Except for
> + * non-volatile general purpose registers, preserving/setting state in
> + * accordance with the x86-64 ABI is the responsibility of the enclave and its
> + * runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
> + * without careful consideration by both the enclave and its runtime.
> + *
> + * All general purpose registers except RAX, RBX and RCX are passed as-is to
> + * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME and are
> + * loaded with @leaf, asynchronous exit pointer, and @tcs respectively.
> + *
> + * RBP and the stack are used to anchor __vdso_sgx_enter_enclave() to the
> + * pre-enclave state, e.g. to retrieve @e and @handler after an enclave exit.
> + * All other registers are available for use by the enclave and its runtime,
> + * e.g. an enclave can push additional data onto the stack (and modify RSP) to
> + * pass information to the optional exit handler (see below).
> + *
> + * Most exceptions reported on ENCLU, including those that occur within the
> + * enclave, are fixed up and reported synchronously instead of being delivered
> + * via a standard signal. Debug Exceptions (#DB) and Breakpoints (#BP) are
> + * never fixed up and are always delivered via standard signals. On synchrously
> + * reported exceptions, -EFAULT is returned and details about the exception are
> + * recorded in @e, the optional sgx_enclave_exception struct.
> +
> + * If an exit handler is provided, the handler will be invoked on synchronous
> + * exits from the enclave and for all synchronously reported exceptions. In
> + * latter case, @e is filled prior to invoking the handler.
> + *
> + * The exit handler's return value is interpreted as follows:
> + *  >0:                continue, restart __vdso_sgx_enter_enclave() with @ret as @leaf
> + *   0:                success, return @ret to the caller
> + *  <0:                error, return @ret to the caller
> + *
> + * The exit handler may transfer control, e.g. via longjmp() or C++ exception,
> + * without returning to __vdso_sgx_enter_enclave().
> + *
> + * Return:
> + *  0 on success,
> + *  -EINVAL if ENCLU leaf is not allowed,
> + *  -EFAULT if an exception occurs on ENCLU or within the enclave
> + *  -errno for all other negative values returned by the userspace exit handler
> + */
> +typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
> +                                       unsigned long rdx, unsigned int leaf,
> +                                       unsigned long r8,  unsigned long r9,
> +                                       void *tcs,
> +                                       struct sgx_enclave_exception *e,
> +                                       sgx_enclave_exit_handler_t handler);
> +
>  #endif /* _UAPI_ASM_X86_SGX_H */
> --
> 2.25.1
>

