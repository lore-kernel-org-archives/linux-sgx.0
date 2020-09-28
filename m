Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FBFC4727E
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 18:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7772074A
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 18:08:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBQ3kK/k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgI1SI0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 14:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgI1SI0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 28 Sep 2020 14:08:26 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755F5C061755;
        Mon, 28 Sep 2020 11:08:24 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l16so2196324ilt.13;
        Mon, 28 Sep 2020 11:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nKSJN20m2Jf2AlPqu6+2tq7IkJVBweKUH7voj06VmFQ=;
        b=fBQ3kK/kcuUeLyJVp5s6hpg0jy09Qi3cJgR0D/Od7F13/6zHb3XXtDHGK4TOfeq5RA
         ZFqleP+5zGuN+pAxLRPFXyaUT78RUoHPPdzAA9iNO869Hu0rk9/+ttAUnJPlb0SW5suK
         YqXYeEFkXaoub5XtkmoY2KZ46rdd3jicNkZ1dj9WL4clHi0DZr+wcc//o6A55Nv0BhHB
         rFBxx2Et4o8RQpP0LU2q+zP4KqDM7djQwmTy2CBYIe5AfvSz+J+EBEmaWVZN0k/umLp2
         eU0Ptxc1DdD5+itZHJc6FKZp2ZK0fg02HCJo8eOiGFmqhFy3BG/XUJZRbaZ2aYf6lxs6
         zAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nKSJN20m2Jf2AlPqu6+2tq7IkJVBweKUH7voj06VmFQ=;
        b=VqOKdwKx83cbEJ4S31sEmxKhZFqZZF2oV0+xTifzuuxxF3I3YHS5+PKRehFX+Ex80q
         8kdCTmu2ycL+IjxQYhhHQ2D9/hRsH5mdEFdUry17WkoMMNx1zrrapcuN3uu3zeenDG7H
         hv925HOKt/PxmjL3gdCcFBYi/A4ieRZU0eJTpc6RqpCv0YtB0m1Vx4OjLXdlWjjtfetS
         Cg0KgGR3JK18T1T/CjfP39rd3/k5CC/9Z5tq7b4yaZRX7aQaBa6XIqs/cEKAGZvAx5KT
         gFJovydH11NEZYCI5NgMizAYAUlADXlz6dMgddgo9iXJZQtwJ7By9nD3nBuRaq6qmCKb
         5d3A==
X-Gm-Message-State: AOAM533jKSyPBlny8Ca1QVqujk7bAveB1pYFYyycOCGuRexDwiVlfMsa
        jz4tDyOllMBX/gbxWeL3eQr40n5aZ+LaKnf0QRUMjDmO6FQgnw==
X-Google-Smtp-Source: ABdhPJzFtIs70e4FpySNixEQnyWuQQnZVCMq4UpNNmWk6XYXaor66zymQTwrz4vRm8Dd0CYYISF3Zg+K45ZAVeLt+KE=
X-Received: by 2002:a92:1589:: with SMTP id 9mr2302583ilv.292.1601316503759;
 Mon, 28 Sep 2020 11:08:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com> <20200928005842.GC6704@linux.intel.com>
 <85bc15d5-93cd-e332-ae9a-1e1e66e1181d@citrix.com>
In-Reply-To: <85bc15d5-93cd-e332-ae9a-1e1e66e1181d@citrix.com>
From:   "H.J. Lu" <hjl.tools@gmail.com>
Date:   Mon, 28 Sep 2020 11:07:47 -0700
Message-ID: <CAMe9rOpzXW0cSD=9E7drGEHH=pcm_NqvPiaR0pBJzYLeAt0_3g@mail.gmail.com>
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        Borislav Petkov <bp@alien8.de>, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>, josh@joshtriplett.org,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        Christian Ludloff <ludloff@google.com>,
        Andy Lutomirski <luto@kernel.org>, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Yu-cheng Yu <yu-cheng.yu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 9:44 AM Andrew Cooper <andrew.cooper3@citrix.com> wrote:
>
> On 28/09/2020 01:58, Jarkko Sakkinen wrote:
> > On Fri, Sep 25, 2020 at 07:23:59PM +0100, Andrew Cooper wrote:
> >> On 15/09/2020 12:28, Jarkko Sakkinen wrote:
> >>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >>> new file mode 100644
> >>> index 000000000000..adbd59d41517
> >>> --- /dev/null
> >>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >>> @@ -0,0 +1,157 @@
> >>> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >>> <snip>
> >>> +.Lretpoline:
> >>> +   call    2f
> >>> +1: pause
> >>> +   lfence
> >>> +   jmp     1b
> >>> +2: mov     %rax, (%rsp)
> >>> +   ret
> >> I hate to throw further spanners in the work, but this is not compatible
> >> with CET, and the user shadow stack work in progress.
> > CET goes beyond my expertise. Can you describe, at least rudimentary,
> > how this code is not compatible?
>
> CET Shadow Stacks detect attacks which modify the return address on the
> stack.
>
> Retpoline *is* a ROP gadget.  It really does modify the return address
> on the stack, even if its purpose is defensive (vs Spectre v2) rather
> than malicious.
>
> >> Whichever of these two large series lands first is going to inflict
> >> fixing this problem on the other.
> >>
> >> As the vdso text is global (to a first approximation), it must not be a
> >> retpoline if any other process is liable to want to use CET-SS.
> > Why is that?
>
> Because when CET-SS is enabled, the ret will suffer a #CP exception
> (return address on the stack not matching the one recorded in the shadow
> stack), which I presume/hope is wired into SIGSEGV.
>

Here is the CET compatible retpoline:

endbr64
/* Check if shadow stack is in use.  NB: R11 is the only usable
   scratch register for function calls.  */
xorl %r11d, %r11d
rdsspq %r11
testq %r11, %r11
jnz 3f
call 2f
1:
pause
lfence
jmp 1b
2:
mov %rax, (%rsp)
ret
3:
/* Shadow stack is in use.  Make the indirect call.  */
call *%rax
ret


-- 
H.J.
