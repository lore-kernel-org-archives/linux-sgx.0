Return-Path: <SRS0=Dbu1=DY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D19C433E7
	for <linux-sgx@archiver.kernel.org>; Sat, 17 Oct 2020 06:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52AE720720
	for <linux-sgx@archiver.kernel.org>; Sat, 17 Oct 2020 06:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="hPup3C1/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436978AbgJQGCS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 17 Oct 2020 02:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436898AbgJQGBk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 17 Oct 2020 02:01:40 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1F0C0610D3
        for <linux-sgx@vger.kernel.org>; Fri, 16 Oct 2020 18:49:07 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g12so5215968wrp.10
        for <linux-sgx@vger.kernel.org>; Fri, 16 Oct 2020 18:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OibUP6dUlS/WSYPmd+1U89iWf3NG/T7RmpnpwT+iWBI=;
        b=hPup3C1/Zfnx78i7sxEvq+7ebH+YBfTIohRfXyyjDQ+8xTlveXlwzwAW55DRYtdoV+
         usfYKblsP1oXcBcFbn+G14DXWw8rIpp/X4DeP0P/u3Dd7TpnXqipPKk+XhrMvYr/zusA
         5hs+7lqM+x3laoNmtdfYvjCivV6moi4G3GDWmLOaGCQHskjIaYJDzuNxlyXBvZfMZjSi
         RJCpwnzhqBDjk9eXVXoK5KDyDvgFkCFqC2gHCR/KEByr/d+gIaJMMJz7dP9gtj0zGyPt
         ERC3n4mUy8EEKfAYefO9NtZfARFJVNNoGBAHiSb2CjBRGmDBZB3dGmSAid5cJQm3wVcq
         GMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OibUP6dUlS/WSYPmd+1U89iWf3NG/T7RmpnpwT+iWBI=;
        b=ZzFHL0pQN2pIMrka+FBMpCn7HmrcC/gw7T/AePi8wxnb4qDoMrqXCA5VqmMPtsD3ER
         rhR5gnb/mcRSklGfaksT5y/lZQPqy52nci0n3cP7neTxDSoGxhxsEMoOPjRDa75F7ch1
         vFMfK8vKFzH/MV3ZnOsaxM5bzJALKKaQzgQtOa46KAV9d/b/kWXLpb7apB7KJ8HxwYFE
         Jd1KpK5qAmXHwjGdwWOHlXFCrA5pOLlMYQiECNUz/Zmqj69WOJ78L/c6/t8CwFACcFCt
         1R4+waaJ1weL3GbghqcPWwOgHcMGXgmZ3z8gd35nKHWJHbS3L+jFNbXHB2nWxu8qjTAM
         4QbQ==
X-Gm-Message-State: AOAM532rKghkPmFA1xpqSAiS/gduLu+5MhDkb63AIRbKZhwW3lorJGGs
        5aE5P193xVWyyzvlr9kexH6iHyqnyQHlNK2X34puDA==
X-Google-Smtp-Source: ABdhPJyZOu4/CZ4MK+VX4lMevC01cIBgTCC6NV+YeTFZVzXHAr0UDB0D09loHMyvLSrWrAay9BY6bJBSFSMzMA4bYyc=
X-Received: by 2002:adf:df03:: with SMTP id y3mr7266939wrl.70.1602899345942;
 Fri, 16 Oct 2020 18:49:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com> <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Fri, 16 Oct 2020 18:48:53 -0700
Message-ID: <CALCETrUJG4LLk4SkBdufUYAx=ec=NyY2wv=Js=72=am6nFQfiw@mail.gmail.com>
Subject: Re: [PATCH v39 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        mikko.ylinen@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 2, 2020 at 9:51 PM Jarkko Sakkinen
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
> The calling convention supports providing the parameters in standard RDI
> RSI, RDX, RCX, R8 and R9 registers, i.e. it is possible to declare the vDSO
> as a C prototype, but other than that there is no specific support for
> SystemV ABI. Storing XSAVE etc. is all responsibility of the enclave and
> the associated run-time.
>
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Cedric Xing <cedric.xing@intel.com>
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

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

This *looks* right, but I'm not really an expert.

> +
> +       mov     %ecx, %eax
> +.Lenter_enclave:
> +       /* EENTER <= leaf <= ERESUME */
> +       cmp     $EENTER, %eax
> +       jb      .Linvalid_input
> +       cmp     $ERESUME, %eax
> +       ja      .Linvalid_input
> +
> +       mov     SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rcx
> +
> +       /* Validate that the reserved area contains only zeros. */
> +       push    %rax
> +       push    %rbx

This could use a .cfi_register_something_or_other for rbx

> +       mov     $SGX_ENCLAVE_RUN_RESERVED_START, %rbx
> +1:
> +       mov     (%rcx, %rbx), %rax
> +       cmpq    $0, %rax
> +       jne     .Linvalid_input
> +
> +       add     $8, %rbx
> +       cmpq    $SGX_ENCLAVE_RUN_RESERVED_END, %rbx
> +       jne     1b
> +       pop     %rbx

This should undo it.

> +       pop     %rax
> +
> +       /* Load TCS and AEP */
> +       mov     SGX_ENCLAVE_RUN_TCS(%rcx), %rbx
> +       lea     .Lasync_exit_pointer(%rip), %rcx
> +
> +       /* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> +.Lasync_exit_pointer:
> +.Lenclu_eenter_eresume:
> +       enclu
> +
> +       /* EEXIT jumps here unless the enclave is doing something fancy. */
> +       mov     SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rbx
> +
> +       /* Set exit_reason. */
> +       movl    $EEXIT, SGX_ENCLAVE_RUN_LEAF(%rbx)
> +
> +       /* Invoke userspace's exit handler if one was provided. */
> +.Lhandle_exit:
> +       cmpq    $0, SGX_ENCLAVE_RUN_USER_HANDLER(%rbx)
> +       jne     .Linvoke_userspace_handler
> +
> +       /* Success, in the sense that ENCLU was attempted. */
> +       xor     %eax, %eax
> +
> +.Lout:
> +       pop     %rbx

and this should undo the .cfi_register.

> +       leave
> +       .cfi_def_cfa            %rsp, 8
> +       ret
> +
> +       /* The out-of-line code runs with the pre-leave stack frame. */
> +       .cfi_def_cfa            %rbp, 16
> +
> +.Linvalid_input:

Here rbx and rax are pushed, and I guess pop rbx and leave fixes that
up, so okay.

> +       mov     $(-EINVAL), %eax
> +       jmp     .Lout
> +
> +.Lhandle_exception:
> +       mov     SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rbx
> +
> +       /* Set the exception info. */
> +       mov     %eax, (SGX_ENCLAVE_RUN_LEAF)(%rbx)
> +       mov     %di,  (SGX_ENCLAVE_RUN_EXCEPTION_VECTOR)(%rbx)
> +       mov     %si,  (SGX_ENCLAVE_RUN_EXCEPTION_ERROR_CODE)(%rbx)
> +       mov     %rdx, (SGX_ENCLAVE_RUN_EXCEPTION_ADDR)(%rbx)
> +       jmp     .Lhandle_exit
> +
> +.Linvoke_userspace_handler:
> +       /* Pass the untrusted RSP (at exit) to the callback via %rcx. */
> +       mov     %rsp, %rcx
> +
> +       /* Save struct sgx_enclave_exception %rbx is about to be clobbered. */
> +       mov     %rbx, %rax
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
> +       /* Push struct sgx_enclave_exception as a param to the callback. */
> +       push    %rax
> +
> +       /* Clear RFLAGS.DF per x86_64 ABI */
> +       cld
> +
> +       /*
> +        * Load the callback pointer to %rax and lfence for LVI (load value
> +        * injection) protection before making the call.
> +        */
> +       mov     SGX_ENCLAVE_RUN_USER_HANDLER(%rax), %rax
> +       lfence
> +       call    *%rax
> +
> +       /* Undo the post-exit %rsp adjustment. */
> +       lea     0x10(%rsp, %rbx), %rsp
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
> +       .cfi_endproc
> +
> +_ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
