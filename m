Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C835C10F11
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 01:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7EC320859
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 01:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555982761;
	bh=CYgn7AWamaNLaiwJVLFUSoNVigaXyTmosyLbWChYTTQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=sCRocwklolfCULmU8QD+2VBo85yrfGPx3r8PmBfHahstsiLjx9OjSfMvUV8GbPVPW
	 ytjfa/+RMUkhLEoQtjx6xYtNzDvnFkq8lfFqjcpwuKvUfslcOBwjLkoivs6uccG6EB
	 JjI5UrQZKEBTahT72rVbVOcaRE6nELpku+CvmoVA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfDWB0A (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 21:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbfDWB0A (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 21:26:00 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFC20218CD
        for <linux-sgx@vger.kernel.org>; Tue, 23 Apr 2019 01:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555982759;
        bh=CYgn7AWamaNLaiwJVLFUSoNVigaXyTmosyLbWChYTTQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DPDQDvleb52ysCMyRwdO/DxHf+hP5wNUa2DXR0XRiwITN6j+Wwxf2mOMvtGOz220r
         8GUw1iuNlcTVy29fztt7PROjWq7QGnq9dnUtLlOqLxKXZVz6HvDTMOcIXNxZqYwX/2
         XcmdVszb0+qPbClpjYf6OBNOwKpL3/h9IyfkKaA4=
Received: by mail-wr1-f41.google.com with SMTP id t17so17834039wrw.13
        for <linux-sgx@vger.kernel.org>; Mon, 22 Apr 2019 18:25:58 -0700 (PDT)
X-Gm-Message-State: APjAAAWq8FgYL7CRCi4IUpKUdzOZa8XcyZnBjpe7Mf3Eb9nDspWqWQbl
        /8yhigZvvEJyQBD1n8i5+QdF/4mZAsvYFu8TcMeOdA==
X-Google-Smtp-Source: APXvYqzeNGooj26DotItbThNDCt/3nbxtNRf1oL/AeRDTR63dZnoAunwMmUTDLTHAzsAfzzUomD87+/jWSbk7PrjXpo=
X-Received: by 2002:a5d:4587:: with SMTP id p7mr7906968wrq.77.1555982757130;
 Mon, 22 Apr 2019 18:25:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <cover.1555965327.git.cedric.xing@intel.com> <ba2a51568f3adaf74994d33ea3cbee570e20c6f6.1555965327.git.cedric.xing@intel.com>
In-Reply-To: <ba2a51568f3adaf74994d33ea3cbee570e20c6f6.1555965327.git.cedric.xing@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 22 Apr 2019 18:25:45 -0700
X-Gmail-Original-Message-ID: <CALCETrULHDiKk6xxMX-iDgb=ZEghkxLfX6d3x5KLQb8YAO1mKA@mail.gmail.com>
Message-ID: <CALCETrULHDiKk6xxMX-iDgb=ZEghkxLfX6d3x5KLQb8YAO1mKA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave() to
 allow parameter passing on untrusted stack
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave <dave.hansen@intel.com>,
        Sean J <sean.j.christopherson@intel.com>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge <serge.ayoun@intel.com>,
        Shay <shay.katz-zamir@intel.com>,
        Haitao <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kai <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Lutomirski <luto@kernel.org>, Kai <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 5:37 PM Cedric Xing <cedric.xing@intel.com> wrote:
>
> The previous __vdso_sgx_enter_enclave() requires enclaves to preserve %rsp,
> which prohibits enclaves from allocating and passing parameters for
> untrusted function calls (aka. o-calls).
>
> This patch addresses the problem above by introducing a new ABI that preserves
> %rbp instead of %rsp. Then __vdso_sgx_enter_enclave() can anchor its frame
> using %rbp so that enclaves are allowed to allocate space on the untrusted
> stack by decrementing %rsp. Please note that the stack space allocated in such
> way will be part of __vdso_sgx_enter_enclave()'s frame so will be freed after
> __vdso_sgx_enter_enclave() returns. Therefore, __vdso_sgx_enter_enclave() has
> been changed to take a callback function as an optional parameter, which if
> supplied, will be invoked upon enclave exits (both AEX (Asynchronous Enclave
> eXit) and normal exits), with the value of %rsp left
> off by the enclave as a parameter to the callback.
>
> Here's the summary of API/ABI changes in this patch. More details could be
> found in arch/x86/entry/vdso/vsgx_enter_enclave.S.
> * 'struct sgx_enclave_exception' is renamed to 'struct sgx_enclave_exinfo'
>   because it is filled upon both AEX (i.e. exceptions) and normal enclave
>   exits.
> * __vdso_sgx_enter_enclave() anchors its frame using %rbp (instead of %rsp in
>   the previous implementation).
> * __vdso_sgx_enter_enclave() takes one more parameter - a callback function to
>   be invoked upon enclave exits. This callback is optional, and if not
>   supplied, will cause __vdso_sgx_enter_enclave() to return upon enclave exits
>   (same behavior as previous implementation).
> * The callback function is given as a parameter the value of %rsp at enclave
>   exit to address data "pushed" by the enclave. A positive value returned by
>   the callback will be treated as an ENCLU leaf for re-entering the enclave,
>   while a zero or negative value will be passed through as the return
>   value of __vdso_sgx_enter_enclave() to its caller. It's also safe to
>   leave callback by longjmp() or by throwing a C++ exception.
>
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 156 ++++++++++++++---------
>  arch/x86/include/uapi/asm/sgx.h          |  14 +-
>  2 files changed, 100 insertions(+), 70 deletions(-)
>
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index fe0bf6671d6d..210f4366374a 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -14,88 +14,118 @@
>  .code64
>  .section .text, "ax"
>
> -#ifdef SGX_KERNEL_DOC
>  /**
>   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
>   *
>   * @leaf:      **IN \%eax** - ENCLU leaf, must be EENTER or ERESUME
> - * @tcs:       **IN \%rbx** - TCS, must be non-NULL
> - * @ex_info:   **IN \%rcx** - Optional 'struct sgx_enclave_exception' pointer
> + * @tcs:       **IN 0x08(\%rsp)** - TCS, must be non-NULL
> + * @ex_info:   **IN 0x10(\%rsp)** - Optional 'struct sgx_enclave_exinfo'
> + *                                  pointer
> + * @callback:  **IN 0x18(\%rsp)** - Optional callback function to be called on
> + *                                  enclave exit or exception
>   *
>   * Return:
>   *  **OUT \%eax** -
> - *  %0 on a clean entry/exit to/from the enclave, %-EINVAL if ENCLU leaf is
> - *  not allowed or if TCS is NULL, %-EFAULT if ENCLU or the enclave faults
> + *  %0 on a clean entry/exit to/from the enclave, %-EINVAL if ENCLU leaf is not
> + *  allowed, %-EFAULT if ENCLU or the enclave faults, or a non-positive value
> + *  returned from ``callback`` (if one is supplied).
>   *
>   * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
> - * x86-64 ABI, i.e. cannot be called from standard C code.   As noted above,
> - * input parameters must be passed via ``%eax``, ``%rbx`` and ``%rcx``, with
> - * the return value passed via ``%eax``.  All registers except ``%rsp`` must
> - * be treated as volatile from the caller's perspective, including but not
> - * limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc...  Conversely, the enclave
> - * being run **must** preserve the untrusted ``%rsp`` and stack.
> + * x86-64 ABI, i.e. cannot be called from standard C code. As noted above,
> + * input parameters must be passed via ``%eax``, ``8(%rsp)``, ``0x10(%rsp)`` and
> + * ``0x18(%rsp)``, with the return value passed via ``%eax``. All other registers
> + * will be passed through to the enclave as is. All registers except ``%rbp``
> + * must be treated as volatile from the caller's perspective, including but not
> + * limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc... Conversely, the enclave being
> + * run **must** preserve the untrusted ``%rbp``.
> + *
> + * ``callback`` has the following signature:
> + * int callback(long rdi, long rsi, long rdx,
> + *             struct sgx_enclave_exinfo *ex_info, long r8, long r9,
> + *             void *tcs, long ursp);
> + * ``callback`` **shall** follow x86_64 ABI. All GPRs **except** ``%rax``, ``%rbx``
> + * and ``rcx`` are passed through to ``callback``. ``%rdi``, ``%rsi``, ``%rdx``,
> + * ``%r8``, ``%r9``, along with the value of ``%rsp`` when the enclave exited/excepted,
> + * can be accessed directly as input parameters, while other GPRs can be
> + * accessed in assembly if needed.
> + * A positive value returned from ``callback`` will be treated as an ENCLU leaf
> + * (e.g. EENTER/ERESUME) to reenter the enclave, while 0 or a negative return

"to reenter the enclave without popping the extra data pushed by the
enclave off the stack" or similar.  We really don't want a situation
where someone puts all there "keep on going" logic in the callback and
the stack usage grows without bound.

> + * value will be passed back to the caller of __vdso_sgx_enter_enclave().
> + * It is also **safe** to ``longjmp()`` out of ``callback``.

I'm not sure that "safe" needs emphasis.

>   */
> -__vdso_sgx_enter_enclave(u32 leaf, void *tcs,
> -                        struct sgx_enclave_exception *ex_info)
> -{
> -       if (leaf != SGX_EENTER && leaf != SGX_ERESUME)
> -               return -EINVAL;
> -
> -       if (!tcs)
> -               return -EINVAL;
> -
> -       try {
> -               ENCLU[leaf];
> -       } catch (exception) {
> -               if (e)
> -                       *e = exception;
> -               return -EFAULT;
> -       }
> -
> -       return 0;
> -}
> -#endif
>  ENTRY(__vdso_sgx_enter_enclave)
> -       /* EENTER <= leaf <= ERESUME */
> +       /* Prolog */
> +       .cfi_startproc
> +       push    %rbp
> +       .cfi_adjust_cfa_offset  8
> +       .cfi_rel_offset         %rbp, 0
> +       mov     %rsp, %rbp
> +       .cfi_def_cfa_register   %rbp
> +
> +1:     /* EENTER <= leaf <= ERESUME */
>         cmp     $0x2, %eax
> -       jb      bad_input
> -
> +       jb      6f
>         cmp     $0x3, %eax
> -       ja      bad_input
> +       ja      6f
>
> -       /* TCS must be non-NULL */
> -       test    %rbx, %rbx
> -       je      bad_input
> +       /* Load TCS and AEP */
> +       mov     0x10(%rbp), %rbx
> +       lea     2f(%rip), %rcx
>
> -       /* Save @exception_info */
> -       push    %rcx
> -
> -       /* Load AEP for ENCLU */
> -       lea     1f(%rip),  %rcx
> -1:     enclu
> -
> -       add     $0x8, %rsp
> -       xor     %eax, %eax
> -       ret
> -
> -bad_input:
> -       mov     $(-EINVAL), %rax
> -       ret
> -
> -.pushsection .fixup, "ax"
> -       /* Re-load @exception_info and fill it (if it's non-NULL) */
> -2:     pop     %rcx
> -       test    %rcx, %rcx
> -       je      3f
> +       /* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> +2:     enclu
>
> +       /* EEXIT path */
> +       xor     %ebx, %ebx
> +3:     mov     0x18(%rbp), %rcx
> +       jrcxz   4f
>         mov     %eax, EX_LEAF(%rcx)
> -       mov     %di,  EX_TRAPNR(%rcx)
> -       mov     %si,  EX_ERROR_CODE(%rcx)
> +       jnc     4f
> +       mov     %di, EX_TRAPNR(%rcx)
> +       mov     %si, EX_ERROR_CODE(%rcx)
>         mov     %rdx, EX_ADDRESS(%rcx)
> -3:     mov     $(-EFAULT), %rax
> +
> +4:     /* Call *callback if supplied */
> +       mov     0x20(%rbp), %rax
> +       test    %rax, %rax

Maybe have a comment like "At this point, the effective return value
is in RBX.  If there is no callback, then return it."

> +       cmovz   %rbx, %rax
> +       jz      7f
> +       /* Align stack and clear RFLAGS.DF per x86_64 ABI */
> +       mov     %rsp, %rbx

Whoa, this is too subtle here.  Can you update the comment to clarify
that the uRSP value set by the enclave needs to be saved so that the
enclave can be resumed if needed?

> +       and     $-0x10, %rsp
> +       cld
> +       /* Parameters for *callback */
> +       push    %rbx
> +       push    0x10(%rbp)
> +       /* Call via retpoline */
> +       call    40f
> +       /* Cleanup stack */
> +       mov     %rbx, %rsp

To me, "Cleanup stack" makes me think that you're restoring the
original RSP, but you're actually just undoing in the stack alignment.
How about "Undo stack alignment"?

But I'm not seeing the code that causes a return value RAX <= 0 to just return.

> +       jmp     1b
> +40:    /* retpoline */
> +       call    42f
> +41:    pause
> +       lfence
> +       jmp     41b
> +42:    mov     %rax, (%rsp)
> +       ret
> +
> +5:     /* Exception path */
> +       mov     $-EFAULT, %ebx
> +       stc
> +       jmp     3b
> +
> +6:     /* Unsupported ENCLU leaf */
> +       cmp     $0, %eax
> +       jle     7f
> +       mov     $-EINVAL, %eax
> +
> +7:     /* Epilog */
> +       leave
> +       .cfi_def_cfa            %rsp, 8
>         ret
> -.popsection
> +       .cfi_endproc
>
> -_ASM_VDSO_EXTABLE_HANDLE(1b, 2b)
> +_ASM_VDSO_EXTABLE_HANDLE(2b, 5b)

--Andy
