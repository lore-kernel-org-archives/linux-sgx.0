Return-Path: <SRS0=unfi=R7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379DEC43381
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Mar 2019 19:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAAFC2183F
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Mar 2019 19:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553800736;
	bh=SqFGcDMbFqOKM+K0LBh3/YlO8u1NuNuHU5+1gr3EB5E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=qsctUlcoTo9NEBqlyxcCwVxOWR9L/qSP8jii5UleCbMKxsSLq8ZDCgyjMwOxWX46X
	 48OsK9mJONzOYGuiAdq+wq3JjbYgkvE68DZFJWiHUesDuC9k1/7g7/anbXdFBfHeCE
	 DU03ZzxWoz4dbBafSy2tAOYMJew/JfWxX3iFcfN4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfC1TSz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Mar 2019 15:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfC1TSz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 Mar 2019 15:18:55 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 948482183F
        for <linux-sgx@vger.kernel.org>; Thu, 28 Mar 2019 19:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553800733;
        bh=SqFGcDMbFqOKM+K0LBh3/YlO8u1NuNuHU5+1gr3EB5E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cfOHi7dJ6XFxui7a13SSZ6gLreTVvz9W2raFl84K5LJsEoLYpnNWfvXBfm69359i6
         LtCI6ODDWXMOkqa4cx5/E9AAWJNLBqg2S6J4HGMHgZ8TxqbWujzIkksJFlMR+XAWim
         l3WwMXY7ULcc5a1Y8XBRk4luCMBRhXXVgB0P28Qw=
Received: by mail-wr1-f42.google.com with SMTP id w10so24337886wrm.4
        for <linux-sgx@vger.kernel.org>; Thu, 28 Mar 2019 12:18:53 -0700 (PDT)
X-Gm-Message-State: APjAAAUYtWhFBSWgQDx0Pqueh4SExKRE0hUYS5P6h+o8AaHqjr3uQJ76
        BGi++IMaTu0WSEuHQ0EMFajVwqTh+6jbco2jTXGw4g==
X-Google-Smtp-Source: APXvYqzenJ91mYQTYO97jBwe55jA6ZKQeiGgYW/bXgWrvHbaDBiU0oAoc6mChALF10vBwRL00gLq77mVa8pFat2a3w0=
X-Received: by 2002:adf:efc1:: with SMTP id i1mr3401128wrp.199.1553800732210;
 Thu, 28 Mar 2019 12:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
 <20190322215903.GE12666@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
 <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com>
 <20190325180349.GF31069@linux.intel.com> <CALCETrXqb3CHefN-RLudC61jwdbLFS8cXuS4V5OJ6HTuf_arYw@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85FABF@ORSMSX116.amr.corp.intel.com>
 <CALCETrVcR_etAHSVZxvCz7CcPnF4ajpcWiRCtFrOckVWVJByHA@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F4E860C69@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E860C69@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 28 Mar 2019 12:18:40 -0700
X-Gmail-Original-Message-ID: <CALCETrUUv3WSX7uL22DnWg8FOJqVyB=tknxbGDWb9wpx7zY2CQ@mail.gmail.com>
Message-ID: <CALCETrUUv3WSX7uL22DnWg8FOJqVyB=tknxbGDWb9wpx7zY2CQ@mail.gmail.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add __vdso_sgx_enter_enclave()
 to wrap SGX enclave transitions
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 27, 2019 at 9:23 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> Hi Andy,
>
> > From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
> > owner@vger.kernel.org] On Behalf Of Andy Lutomirski
> >
> > I suppose the real question is: are there a significant number of
> > users who will want to run enclaves created using an old SDK on Linux?
> >  And will there actually be support for doing this in the software
> > stack?
>
> To your first question, I cannot share information of Intel customers or =
speak for them. But in general, people would like to stay with an old encla=
ve usually because of: 1) attestation, because MRENCLAVE will change after =
rebuild; and/or 2) the need to support a mix of older and newer Linux kerne=
ls. So I'd say it'll be commonly desired, especially when this vDSO API is =
still "new" (so not available on every platform).
>
> To your second question, Intel will support all "legacy" enclaves built w=
ith older SGX SDKs on newer kernels. And that's why we are so eager to find=
 a migration path. I can't speak for other companies, but guess backward co=
mpatibility is always desirable.
>
> >
> > If the answer to both questions is yes, then it seems like it could be
> > reasonable to support it in the vDSO.  But I still think it should
> > probably be a different vDSO entry point so that the normal case
> > doesn't become more complicated.
>
> I'll support whatever you think is more appropriate.
>
> At the end, I'd like to give out the full version of my proposal, with yo=
ur feedbacks (i.e. stack unwinder and Spectre variant 2) addressed. I'm a b=
it concerned by retpoline, which won't work (or be needed) when CET comes o=
nline. Are you looking to change it again then?

The kernel is buildable with and without retpolines.  Presumably the
addition of CET support will need to address this everywhere,
including in the vDSO.

>
> Here's the summary of the changes:
>  - Added CFI directives for proper unwinding.
>  - Defined sgx_ex_callback - the callback function on enclave exit/except=
ion.
>  - Aligned stack properly before calling sgx_ex_callback (per x86_64 ABI)=
.
>  - Used retpoline in place of indirect call.
>  - The block starting at label "4:" captures all the code necessary to su=
pport sgx_ex_call. It has grown longer due to retpoline.
>
> /**
>  * __vdso_sgx_enter_enclave() - Enter an SGX enclave
>  *
>  * %eax:        ENCLU leaf, must be either EENTER or ERESUME
>  * 0x08(%rsp):  TCS
>  * 0x10(%rsp):  Optional pointer to 'struct sgx_enclave_exception'
>  * 0x18(%rsp):  Optional function pointer to 'sgx_ex_callback', whose
>  *              definition will be given below. Note that this function, =
if
>  *              present, shall follow x86_64 ABI.
>  * return:      0 (zero) on success, or a negative error code on failure.
>  *
>  * Note that __vdso_sgx_enter_enclave() is not compatible with x86_64 ABI=
.
>  * All registers except RBP must be treated as volatile from the caller's
>  * perspective, including but not limited to GPRs, EFLAGS.DF, MXCSR, FCW,=
 etc...
>  * Enclave may decrement RSP, but must not increment it - i.e. existing c=
ontent
>  * of the stack shall be preserved.
>  *
>  * sgx_ex_callback - A callback function to be invoked by
>  * __vdso_sgx_enter_enclave() upon exception or after the enclave exits.
>  *
>  * typedef int (*sgx_ex_callback)(long rdi, long rsi, long rdx,
>  *      struct sgx_enclave_exception *ex_info, long r8, long r9,
>  *      long rsp, void *tcs);
>  *
>  * Note that sgx_ex_callback shall be x86_64 ABI compliant.
>  *
>  * Note that other GPRs (except %rax, %rbx and %rcx) are also passed thro=
ugh to
>  * sgx_ex_callback, even though accessing them requires assembly code.
>  */
> __vdso_sgx_enter_enclave:
>         /* prolog */
>         .cfi_startproc
>         push    %rbp
>         .cfi_adjust_cfa_offset  8
>         .cfi_rel_offset         %rbp, 0
>         mov     %rsp, %rbp
>         .cfi_def_cfa_register   %rbp
>
> 1:      /* EENTER <=3D leaf <=3D ERESUME */
>         cmp     $0x2, %eax
>         jb      5f
>         cmp     $0x3, %eax
>         ja      5f
>
>         /* Load TCS and AEP */
>         mov     0x10(%rbp), %rbx
>         lea     2f(%rip), %rcx
>
> 2:      enclu
>
>         /* EEXIT path */
>         mov     0x18(%rbp), %rcx
>         jrcxz   3f
>         mov     %eax, EX_LEAF(%rcx)
>         /* normalize return value */
> 3:      xor     %eax, %eax
>
> 4:      /* call sgx_ex_callback if supplied */
>         cmpq    $0, 0x20(%rbp)
>         jz      6f
>         /* align stack per x86_64 ABI */
>         mov     %rsp, %rbx
>         and     $-0x10, %rsp
>         /* parameters */
>         push    0x10(%rbp)
>         push    %rbx
>         /* call *0x20(%rbp) using retpoline */
>         mov     0x20(%rbp), %rax
>         call    41f
>         /* stack cleanup */
>         mov     %rbx, %rsp
>         jmp     1b
> 41:     call    43f
> 42:     pause
>         lfence
>         jmp     42b
> 43:     mov     %rax, (%rsp)
>         ret
>
> 5:      /* bad leaf */
>         cmp     $0, %eax
>         jle     6f
>         mov     $(-EINVAL), %eax
>
> 6:      /* epilog */
>         leave
>         .cfi_def_cfa            %rsp, 8
>         ret
>         .cfi_endproc
>
> .pushsection    .fixup, "ax"
> 7:      mov     0x18(%rbp), %rcx
>         jrcxz   8f
>         /* fill in ex_info */
>         mov     %eax, EX_LEAF(%rcx)
>         mov     %di, EX_TRAPNR(%rcx)
>         mov     %si, EX_ERROR_CODE(%rcx)
>         mov     %rdx, EX_ADDRESS(%rcx)
> 8:      mov     $(-EFAULT), %eax
>         jmp     4b
> .popsection
>
> _ASM_VDSO_EXTABLE_HANDLE(2b, 7b)
>
>

It's certainly making progress.  I like the fact that the callback is
now unconditional (if non-NULL) rather than being used just in case of
certain exit types.  But, if we go down this route, let's name and
document it appropriately -- just call the function "callback" and
document it as a function that is called just before
__vdso_sgx_enter_enclave returns, to be used if support for legacy
enclaves that push data onto the untrusted stack is needed.  We should
further document that it's safe to longjmp out of it.

Also, the tests in tools/testing/selftests/x86/unwind_vdso.c should be
augmented to test this code.

Finally, why does the vDSO code bother checking whether the leaf is valid?
