Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD98C4727C
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 23:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03B82206D9
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 23:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VGsezYmo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgI1XXm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI1XXm (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 28 Sep 2020 19:23:42 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4EAC0613DA;
        Mon, 28 Sep 2020 15:07:12 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g7so2754270iov.13;
        Mon, 28 Sep 2020 15:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YMvcxqdogjlVh457rV2UNx34JbjoAtCNJHUjcDLmp2o=;
        b=VGsezYmoblzEdqCchJ65YZpzkvFe0Jv1je9CfBpdejzupJU3crK1K/vGHB+lkgkQ0/
         tu2p9N6Si0qmFpNqAvuWL9vlvHcKOCXJbereIjUzRakmDoea/a5NQj1QWXcYvke9zOcQ
         nOP99BGEAKqj3LRIPCn59CCITRXmhkiqrJs1g4iCVPWR4n9gc3rNzVgh7KAi5vrPJY+O
         kSUD7+9RsNtHIBc33aYpBRuGTEKuzQPi6N7uFlv1k+nnoQEM/15Vy1RCzWQkEV+ki0Fz
         VS5nOWD/RjEVPqtT7LIxROgZFfC8Yr3v7WTdcLyxtAx0UAo3DstBmf4mL5CfT491GB1z
         caCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YMvcxqdogjlVh457rV2UNx34JbjoAtCNJHUjcDLmp2o=;
        b=jrlHqy6kCcZpE4KyJTyUsroeH7HRrfVZhxXdqpGd/CRdjFfa0BDW0BM9BCQoQHdKIw
         uMq2aaBz7q7Wxa+TesAO9mlQjTFt7LU9Q6XmO6NzVPyGq4c+/XMRVFbI1TBG6dDOIJMf
         bTco7xfkGeaGJn/D20/EQyZs5k1NOjA4FrD0z6TI0ffKA4JUzj1JI2dKdVQ+9mZTPKNJ
         eAd/2fekJUBp/ToOv8W0ZONltDNPSRmy0ezk4+Yk14rrJFk0QhtshxrsQcaK61VMiHac
         +HjMkZd/lHpShM3B1Z68Y/kSwi3awslwTHXSUva0XssVQf3t7yZ/etJrzozdsGBAmoGu
         tcwA==
X-Gm-Message-State: AOAM531j4wwI+HhqZ0iYjeyJ1I8jprLZeflXCCoeni5ZFefUbq8lERPG
        fnGk77qVqTVu+bGSVu1HNO+IaoxIgFcU2zsixlY=
X-Google-Smtp-Source: ABdhPJxTqZhfaCfG0PnKWDjdVdb7i/EfSJqUSk5y3W09ngOrh4E9sg+PC2VRgsA8n0DdVJTw9qhezXJaHL7TVWIy1dc=
X-Received: by 2002:a02:6607:: with SMTP id k7mr603123jac.91.1601330831661;
 Mon, 28 Sep 2020 15:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com> <20200928005842.GC6704@linux.intel.com>
 <85bc15d5-93cd-e332-ae9a-1e1e66e1181d@citrix.com> <CAMe9rOpzXW0cSD=9E7drGEHH=pcm_NqvPiaR0pBJzYLeAt0_3g@mail.gmail.com>
 <CALCETrU4Rhc0fwzzKLSUgan2YmSovxVFYOZEmFnBHC4DbZ5RfQ@mail.gmail.com> <20200928215635.GF2705@linux.intel.com>
In-Reply-To: <20200928215635.GF2705@linux.intel.com>
From:   "H.J. Lu" <hjl.tools@gmail.com>
Date:   Mon, 28 Sep 2020 15:06:35 -0700
Message-ID: <CAMe9rOoyxtf_kUCdb-TN+NmZsQNmFY8NLMObSdCB5bBVq1x+cQ@mail.gmail.com>
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Yu-cheng Yu <yu-cheng.yu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 2:56 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Mon, Sep 28, 2020 at 11:12:08AM -0700, Andy Lutomirski wrote:
> > On Mon, Sep 28, 2020 at 11:08 AM H.J. Lu <hjl.tools@gmail.com> wrote:
> > >
> > > On Mon, Sep 28, 2020 at 9:44 AM Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> > > >
> > > > On 28/09/2020 01:58, Jarkko Sakkinen wrote:
> > > > > On Fri, Sep 25, 2020 at 07:23:59PM +0100, Andrew Cooper wrote:
> > > > >> On 15/09/2020 12:28, Jarkko Sakkinen wrote:
> > > > >>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > > >>> new file mode 100644
> > > > >>> index 000000000000..adbd59d41517
> > > > >>> --- /dev/null
> > > > >>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > > >>> @@ -0,0 +1,157 @@
> > > > >>> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > > > >>> <snip>
> > > > >>> +.Lretpoline:
> > > > >>> +   call    2f
> > > > >>> +1: pause
> > > > >>> +   lfence
> > > > >>> +   jmp     1b
> > > > >>> +2: mov     %rax, (%rsp)
> > > > >>> +   ret
> > > > >> I hate to throw further spanners in the work, but this is not compatible
> > > > >> with CET, and the user shadow stack work in progress.
> > > > > CET goes beyond my expertise. Can you describe, at least rudimentary,
> > > > > how this code is not compatible?
> > > >
> > > > CET Shadow Stacks detect attacks which modify the return address on the
> > > > stack.
> > > >
> > > > Retpoline *is* a ROP gadget.  It really does modify the return address
> > > > on the stack, even if its purpose is defensive (vs Spectre v2) rather
> > > > than malicious.
> > > >
> > > > >> Whichever of these two large series lands first is going to inflict
> > > > >> fixing this problem on the other.
> > > > >>
> > > > >> As the vdso text is global (to a first approximation), it must not be a
> > > > >> retpoline if any other process is liable to want to use CET-SS.
> > > > > Why is that?
> > > >
> > > > Because when CET-SS is enabled, the ret will suffer a #CP exception
> > > > (return address on the stack not matching the one recorded in the shadow
> > > > stack), which I presume/hope is wired into SIGSEGV.
> > > >
> > >
> > > Here is the CET compatible retpoline:
> > >
> > > endbr64
> > > /* Check if shadow stack is in use.  NB: R11 is the only usable
> > >    scratch register for function calls.  */
> > > xorl %r11d, %r11d
> > > rdsspq %r11
> > > testq %r11, %r11
> > > jnz 3f
> > > call 2f
> > > 1:
> > > pause
> > > lfence
> > > jmp 1b
> > > 2:
> > > mov %rax, (%rsp)
> > > ret
> > > 3:
> > > /* Shadow stack is in use.  Make the indirect call.  */
> > > call *%rax
> > > ret
> >
> > What do we expect user programs to do on CET systems?  It would be
> > nice if we could instead ALTERNATIVE this out if X86_FEATURE_SHSTK.
> >
> > --Andy
>
> I'm open to do either solution. My thinking was to initially do things
> vsgx.S local (i.e. consider ALTERNATIVE post upstreaming) and use the
> above solution but I'm also fine doing ALTERNATIVE. Dave kindly briefed
> on details how that thing works and it should be perfectly usable for
> our use case.
>

Since SHSTK and IBT are enabled per process, not the whole machine,
are you going to patch vDSO on a per-process basis?

-- 
H.J.
