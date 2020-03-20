Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F60C4332D
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 13:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 722202076E
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 13:56:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e8LrfHnI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgCTN4O (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 09:56:14 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32943 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgCTN4N (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 20 Mar 2020 09:56:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584712571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=43gKcVxvjNaDcKczGn8X6anzS+EGMd6+Dlrm4O2YHnY=;
        b=e8LrfHnISXFbuAGCAwl6FffgcWO4CbJikFSYqRX2i64fUlzCjAysa1pqp9D5hMnwbi38p8
        c2s3ep4OtVEjHL6QK0WvY5Y1bbaz40EfMGTXIgYRYuFNJ75Ihp0hZvv7ouaSkOHbfUEJeA
        E11USm0kZSZ6D9kN1CEgZlZeQ2KJ4DQ=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-fPq-8WpjN36XLYXVs59buQ-1; Fri, 20 Mar 2020 09:56:09 -0400
X-MC-Unique: fPq-8WpjN36XLYXVs59buQ-1
Received: by mail-io1-f70.google.com with SMTP id v13so2296008iox.6
        for <linux-sgx@vger.kernel.org>; Fri, 20 Mar 2020 06:56:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=43gKcVxvjNaDcKczGn8X6anzS+EGMd6+Dlrm4O2YHnY=;
        b=Wt0xfe8qiCQqvndrJlIbPFesQMFlepKSR0H3dzVpwOIYVn0/tnDL9XoSYHPmj/N8PB
         S/Km75prAjPr5Gq3xGRSYBiS8uNkYflXRtRX235bvH5WCMWkdcH+etEXQfB/8B0f/gmI
         aNjwzanfkP2i5pEq/CfvfmdkEAAlVLtWgbjhy86Cn2/VKdQLjrojo9UpdPqIomxniZnc
         r5ofWk6z3i2feMRwBPt0uS5LX/Kn+R30hymnEsE6ZHgzy8mX8euJ8noGVDsHXSB3igf6
         hNsbHLImDGRPrD1LuDo/yh1m/la0LBg1g0f21cebbyf8nJESH7seCGzERxIniKqi1jF7
         5C5Q==
X-Gm-Message-State: ANhLgQ3pSrTWTEPpiBD28jqaCqTnlm/X8qgpyXJ4h9PSLT4b3q1VPqVA
        UqRAjiCSl8lgXPo6hejaotNT7+FQGWDN5Q7/ZUXaqZC70mBE6G00aeFkM3V6sqs8w6j8g+jWKkn
        OA2/MW0izK+LAZDOL2MhQkSo2U5lgSjxDxOWv
X-Received: by 2002:a02:3443:: with SMTP id z3mr8360785jaz.7.1584712569043;
        Fri, 20 Mar 2020 06:56:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsibHcrRh4M47oNO1E9alNXjSgLrZl33kUgYM6S+GUvPilYzh4YLNigmSSdW0k5cgBDbpuHEafzZz9hnZ5c6WU=
X-Received: by 2002:a02:3443:: with SMTP id z3mr8360757jaz.7.1584712568702;
 Fri, 20 Mar 2020 06:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <254f1e35-4302-e55f-c00d-0f91d9503498@fortanix.com> <CAOASepOm8-2UCdEnVMopEprMGWjkYUbUTX++dHaqCafi2ju8mA@mail.gmail.com>
 <20200313164622.GC5181@linux.intel.com> <CAOASepN1hxSgxVJAJiAbSmuCTCHd=95Mnvh6BKNSPJs=EpAmbQ@mail.gmail.com>
 <20200313184452.GD5181@linux.intel.com> <CAOASepP_oGOenjCvAvLg+e+=fz4H0X=cyD+v5ywD0peeXEEmYg@mail.gmail.com>
 <20200313220820.GE5181@linux.intel.com> <CAOASepMicT6CrYyDkoYizh4nAZ+1Zn4rGQh7QjfzSK72Fj6u_g@mail.gmail.com>
 <20200318234057.GE26164@linux.intel.com>
In-Reply-To: <20200318234057.GE26164@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Fri, 20 Mar 2020 09:55:57 -0400
Message-ID: <CAOASepOSUciw73C+dQYtKuU4x4BkJ_f=TRFVMgj10qDce3k94g@mail.gmail.com>
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
        "Xing, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
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

On Wed, Mar 18, 2020 at 7:41 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sat, Mar 14, 2020 at 10:10:26AM -0400, Nathaniel McCallum wrote:
> > On Fri, Mar 13, 2020 at 6:08 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > > > > > 4. sub/add to %rsp rather than save/restore
> > > > >
> > > > > Can you elaborate on why you want to sub/add to %rsp instead of having the
> > > > > enclave unwind the stack?  Preserving %rsp across EEXIT/ERESUME seems more
> > > > > in line with function call semantics, which I assume is desirable?  E.g.
> > > > >
> > > > >   push param3
> > > > >   push param2
> > > > >   push param1
> > > > >
> > > > >   enclu[EEXIT]
> > > > >
> > > > >   add $0x18, %rsp
> > > >
> > > > Before enclave EEXIT, the enclave restores %rsp to the value it had
> > > > before EENTER was called. Then it pushes additional output arguments
> > > > onto the stack. The enclave calls EENCLU[EEXIT].
> > > >
> > > > We are now in __vdso...() on the way back to the caller. However, %rsp
> > > > has a different value than we entered the function with. This breaks
> > > > x86_64 ABI, obviously. The handler needs to fix this up: how does it
> > > > do so?
>
> Circling back to this request, because I just realized that the above is
> handled by saving %rsp into %rbp and requiring the enclave and handler
> to preserve %rbp at all times.
>
> So the below discussion on making the %rsp adjustment relative is moot,
> at least with respect to getting out of __vdso() if the enclave has mucked
> with the untrusted stack.

You're right. __vdso() will always restore the caller's stack via the
leave instruction at .Lout. So no change is necessary.

> > > > In the current code, __vdso..() saves the value of %rsp, calls the
> > > > handler and then restores %rsp. The handler can fix up the stack by
> > > > setting the correct value to %rbx and returning without restoring it.
> > >
> > > Ah, you're referring to the patch where the handler decides to return all
> > > the way back to the caller of __vdso...().
> > >
> > > > But this requires internal knowledge of the __vdso...() function,
> > > > which could theoretically change in the future.
> > > >
> > > > If instead the __vdso...() only did add/sub, then the handler could do:
> > > > 1. pop return address
> > > > 2. pop handler stack params
> > > > 3. pop enclave additional output stack params
> > > > 4. push handler stack params
> > > > 5. push return address
>
> Per above, this is unnecessary when returning to the caller of __vdso().
> It would be necessary if the enclave wasn't smart enough to do it's own
> stack cleanup, but that seems like a very bizarre contract between the
> enclave and its runtime.
>
> The caveat is if %rbx is saved/restored by __vdso().  If we want a
> traditional frame pointer, then %rbx would be restored from the stack
> before %rsp itself is restored (from %rbp), in which case the exit handler
> would need to adjust %rsp using a sequence similar to what you listed
> above.
>
> If __vdso() uses a non-standard frame pointer, e.g.
>
>   push %rbp
>   push %rbx
>   mov  %rsp, %rbp
>
> then %rbx would come off the stack after %rsp is restored from %rbp, i.e.
> would be guaranteed to be restored to the pre-EENTER value (unless the
> enclave or handler mucks with %rbp).
>
> Anyways, we can discuss how to implement the frame pointer in the context
> of the patches, just wanted to point this out here for completeness.
>
> > > > While this is more work, it is standard calling convention work that
> > > > doesn't require internal knowledge of __vdso..(). Alternatively, if we
> > > > don't like the extra work, we can document the %rbx hack explicitly
> > > > into the handler documentation and make it part of the interface. But
> > > > we need some explicit way for the handler to pop enclave output stack
> > > > params that doesn't depend on internal knowledge of the __vdso...()
> > > > invariants.
> > >
> > > IIUC, this is what you're suggesting?  Having to align the stack makes this
> > > a bit annoying, but it's not bad by any means.
> > >
> > > diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > index 94a8e5f99961..05d54f79b557 100644
> > > --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > @@ -139,8 +139,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > >         /* Pass the untrusted RSP (at exit) to the callback via %rcx. */
> > >         mov     %rsp, %rcx
> > >
> > > -       /* Save the untrusted RSP in %rbx (non-volatile register). */
> > > +       /* Save the untrusted RSP offset in %rbx (non-volatile register). */
> > >         mov     %rsp, %rbx
> > > +       and     $0xf, %rbx
> > >
> > >         /*
> > >          * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
> > > @@ -161,8 +162,8 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > >         mov     0x20(%rbp), %rax
> > >         call    .Lretpoline
> > >
> > > -       /* Restore %rsp to its post-exit value. */
> > > -       mov     %rbx, %rsp
> > > +       /* Undo the post-exit %rsp adjustment. */
> > > +       lea     0x20(%rsp,%rbx), %rsp
> > >
> > >
> > > That's reasonable, let's the handler play more games with minimal overhead.
> >
> > Yes, exactly!
> >
> > > > > > That would make this a very usable and fast interface without
> > > > > > sacrificing any of its current power.
> > > > >
> > > >
> > >
> >
>

