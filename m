Return-Path: <SRS0=qxyk=5A=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91504C4CECE
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Mar 2020 02:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68E1A2078B
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Mar 2020 02:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I0a1/1jU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCOCPE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 14 Mar 2020 22:15:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42505 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726648AbgCOCPE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 14 Mar 2020 22:15:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584238502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mIwgueKxLcFU4CQiUmuHB19q7eyBM/AqLW69Z1/WEkY=;
        b=I0a1/1jUx4waOB6FWuxXIfXBjYwcpTH+JYLnthl2OIrVfyl80bqR9daifxGHXrphu2zQoU
        ScPNQVvq7dIFGP8afIbCwATAGPnYQ3czCHTDPUc1U1wZ6PKMr1xuZnyThU3EYPf42zh8aQ
        4moyGEklwtxfGF8bd0seI4pkROmiDvw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-TtOvUwe8Pim5Cq01dmD1ew-1; Sat, 14 Mar 2020 10:10:38 -0400
X-MC-Unique: TtOvUwe8Pim5Cq01dmD1ew-1
Received: by mail-il1-f197.google.com with SMTP id h12so9405879ils.12
        for <linux-sgx@vger.kernel.org>; Sat, 14 Mar 2020 07:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mIwgueKxLcFU4CQiUmuHB19q7eyBM/AqLW69Z1/WEkY=;
        b=INJoPx6+fZIwUf9jcAy9fvRffMg6upeh4Eg1r2hPlBc0hbUyOdP8t7F7vN8Z3+Zr62
         MrBTqXWOv4DWD25LL3Mt9u/M4XJewIImWfVzcAe6yhRnaoO4994oxf/i4MVmSZhW4O7p
         fzJOl1AjkbBj7eYDYquz4ubja5bd64CfUBuC90Alxwh26Umw2PNZvTrhY9nj9HwJ88ri
         Ezn9onIAuSH0Pj+aZ7XB2QJFaxCg56du/BUqOxLswlj1mJc82M5sCvLwvnmn6A7T+8GU
         Xa9AwsdGl+DhbMTqhXvH6A8Oy4yzbD6p40/J6AdOKhRfdZ3juWMwNCb4St9hHSTKlR60
         9K6w==
X-Gm-Message-State: ANhLgQ3d5hE0MqmTk1lNlwM1UzlyACEzqCEUV7aYzmQRvPkCMPbOea6v
        u6vhA1PNtFVKzBGznrFLOSlZssXvzWOAC2SDwdziiT0xYwPx4kdJ1m7ywyGFd/UH/syWDWFU825
        9bqVGy35XtgGpZFCKq1RtnrBpYZbtzIo8h1RM
X-Received: by 2002:a92:9f4e:: with SMTP id u75mr18600028ili.116.1584195037381;
        Sat, 14 Mar 2020 07:10:37 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsPW5DuL8dDlJmDEsUMqJ6kxsbEVTOhd86ZLKXksl2QIPUCChW1TMpLMt5XhXw/a6xHL20Gz90VS1KFym3tXBY=
X-Received: by 2002:a92:9f4e:: with SMTP id u75mr18599987ili.116.1584195036995;
 Sat, 14 Mar 2020 07:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <254f1e35-4302-e55f-c00d-0f91d9503498@fortanix.com> <CAOASepOm8-2UCdEnVMopEprMGWjkYUbUTX++dHaqCafi2ju8mA@mail.gmail.com>
 <20200313164622.GC5181@linux.intel.com> <CAOASepN1hxSgxVJAJiAbSmuCTCHd=95Mnvh6BKNSPJs=EpAmbQ@mail.gmail.com>
 <20200313184452.GD5181@linux.intel.com> <CAOASepP_oGOenjCvAvLg+e+=fz4H0X=cyD+v5ywD0peeXEEmYg@mail.gmail.com>
 <20200313220820.GE5181@linux.intel.com>
In-Reply-To: <20200313220820.GE5181@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Sat, 14 Mar 2020 10:10:26 -0400
Message-ID: <CAOASepMicT6CrYyDkoYizh4nAZ+1Zn4rGQh7QjfzSK72Fj6u_g@mail.gmail.com>
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

On Fri, Mar 13, 2020 at 6:08 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Mar 13, 2020 at 04:14:01PM -0400, Nathaniel McCallum wrote:
> > On Fri, Mar 13, 2020 at 2:45 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
>  > > This doesn't compromise the ability to treat __vsdo...() like ENCLU if
> > > > you need the full power. But it does make it significantly easier to
> > > > consume when you don't have special needs. So as I see it, __vdso...()
> > > > should:
> > > >
> > > > 1. preserve %rbx
> > > > 2. take leaf in %rcx
> > > > 3. gain a void* stack param which is passed to the handler
> > >
> > > Unless I'm misunderstanding the request, this already exists.  %rsp at the
> > > time of EEXIT is passed to the handler.
> >
> > Sorry, different stack parameter. I mean this:
> >
> > typedef int (*sgx_enclave_exit_handler_t)(
> >     long rdi,
> >     long rsi,
> >     long rdx,
> >     long ursp,
> >     long r8,
> >     long r9,
> >     int ret,
> >     void *tcs,
> >     struct sgx_enclave_exception *e,
> >     void *misc
> > );
> >
> > int __vdso_sgx_enter_enclave(
> >     long rdi,
> >     long rsi,
> >     long rdx,
> >     int leaf,
> >     long r8,
> >     long r9,
> >     void *tcs,
> >     struct sgx_enclave_exception *e,
> >     void *misc,
> >     sgx_enclave_exit_handler_t handler
> > );
> >
> > This is so that the caller of __vdso...() can pass context into the
> > handler.
>
> Hrm, I'm not a fan of adding a param that is only consumed by the handler,
> especially when there are multiple alternatives, e.g. fudge the param in
> assembly before calling __vdso(), have the enclave supply the context in a
> volatile register, etc...

Yes, but all of those require assembly. The whole point of this is
ergonomics without assembly. Once you can call __vdso() without
assembly, having to resort to assembly to make it useful will feel
painful. I imagine it would be pretty common to pass something like a
jmp_buf reference or a reference to a struct for collecting output
stack arguments through misc.

> > Note that I've also reordered the stack parameters so that the stack
> > order can be reused.
>
> Ah, ret<->tcs, took me a minute...
>
> Does preserving tsc->e->misc ordering matter all that much?

Not really. I was just trying to aid the reader of the assembly. If
there are more important concerns, fine.

>  __vdso() needs
> to manually copy them either way.  I ask because putting @misc at the end
> would allow implementations that don't use @handler to omit the param (if
> I've done my math correctly, which is always a big if).  That would make
> adding the handler-only param a little more palatable.

Fine by me.

> > > > 4. sub/add to %rsp rather than save/restore
> > >
> > > Can you elaborate on why you want to sub/add to %rsp instead of having the
> > > enclave unwind the stack?  Preserving %rsp across EEXIT/ERESUME seems more
> > > in line with function call semantics, which I assume is desirable?  E.g.
> > >
> > >   push param3
> > >   push param2
> > >   push param1
> > >
> > >   enclu[EEXIT]
> > >
> > >   add $0x18, %rsp
> >
> > Before enclave EEXIT, the enclave restores %rsp to the value it had
> > before EENTER was called. Then it pushes additional output arguments
> > onto the stack. The enclave calls EENCLU[EEXIT].
> >
> > We are now in __vdso...() on the way back to the caller. However, %rsp
> > has a different value than we entered the function with. This breaks
> > x86_64 ABI, obviously. The handler needs to fix this up: how does it
> > do so?
> >
> > In the current code, __vdso..() saves the value of %rsp, calls the
> > handler and then restores %rsp. The handler can fix up the stack by
> > setting the correct value to %rbx and returning without restoring it.
>
> Ah, you're referring to the patch where the handler decides to return all
> the way back to the caller of __vdso...().
>
> > But this requires internal knowledge of the __vdso...() function,
> > which could theoretically change in the future.
> >
> > If instead the __vdso...() only did add/sub, then the handler could do:
> > 1. pop return address
> > 2. pop handler stack params
> > 3. pop enclave additional output stack params
> > 4. push handler stack params
> > 5. push return address
> >
> > While this is more work, it is standard calling convention work that
> > doesn't require internal knowledge of __vdso..(). Alternatively, if we
> > don't like the extra work, we can document the %rbx hack explicitly
> > into the handler documentation and make it part of the interface. But
> > we need some explicit way for the handler to pop enclave output stack
> > params that doesn't depend on internal knowledge of the __vdso...()
> > invariants.
>
> IIUC, this is what you're suggesting?  Having to align the stack makes this
> a bit annoying, but it's not bad by any means.
>
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index 94a8e5f99961..05d54f79b557 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -139,8 +139,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>         /* Pass the untrusted RSP (at exit) to the callback via %rcx. */
>         mov     %rsp, %rcx
>
> -       /* Save the untrusted RSP in %rbx (non-volatile register). */
> +       /* Save the untrusted RSP offset in %rbx (non-volatile register). */
>         mov     %rsp, %rbx
> +       and     $0xf, %rbx
>
>         /*
>          * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
> @@ -161,8 +162,8 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>         mov     0x20(%rbp), %rax
>         call    .Lretpoline
>
> -       /* Restore %rsp to its post-exit value. */
> -       mov     %rbx, %rsp
> +       /* Undo the post-exit %rsp adjustment. */
> +       lea     0x20(%rsp,%rbx), %rsp
>
>
> That's reasonable, let's the handler play more games with minimal overhead.

Yes, exactly!

> > > > That would make this a very usable and fast interface without
> > > > sacrificing any of its current power.
> > >
> >
>

