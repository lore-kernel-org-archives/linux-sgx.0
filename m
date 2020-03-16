Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9FDC0044D
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 13:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1E7B206E2
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 13:57:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YPRX+SSq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731465AbgCPN5q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:57:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38091 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731331AbgCPN5o (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 16 Mar 2020 09:57:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584367063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y37xLyubvdE/S1nw2px77Rlc9yCddXzDwGhRdNOHBN8=;
        b=YPRX+SSq7ctHVdfFvljpU0Wp1AHQGU42/hx8zQPmMsjhLnqdpEacq3In6qvc7ovNhP5+Gl
        ba7DH60lpT58YUru9t8r+FvAPJFN8WGAO5MkO4CsKyq5i9JXJaGKRgNmv1Lr4D4ppXBTBn
        JZMhS696Xt3D++slOZIylGPqwKrRg+Q=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-d5bwRLT3PG6eFGkaDkI--w-1; Mon, 16 Mar 2020 09:57:40 -0400
X-MC-Unique: d5bwRLT3PG6eFGkaDkI--w-1
Received: by mail-io1-f70.google.com with SMTP id p4so11688521ioo.4
        for <linux-sgx@vger.kernel.org>; Mon, 16 Mar 2020 06:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y37xLyubvdE/S1nw2px77Rlc9yCddXzDwGhRdNOHBN8=;
        b=DvVk4RsCMjnzHkuDYhpG6kdo1FJ1rrvdNTBlsTDxCdAxA1D0zoQ4oQSnJBwVjxrNv0
         S6rEuuZiaeMQk5zIEUJx1nrU6l1oU4yAZKctBOIwr8WdvV64dw6jMLyV1Viu9TCL2Gku
         o7PGE5YOm/ZMfwAIhw4cYOj2oV309Vj4CmyqJzOA0oOXBs8U0UNQL/7XGbCbipNNMHt7
         OnhCpUw+mqUHdUiBro+J4oRgYOmDsKriJIjTzZHzzCn1gERjaKAAcEQrwM0bdmBpzx2h
         Zr0eZCaeg9UkpXEu/fwm/FmDRUTk9A1seV/vQRTy5aeIgsIDRD+9UN7f0sNnz0mv+FIg
         n3Lw==
X-Gm-Message-State: ANhLgQ2eU9QSzetH/Lr7NCOaHitb6dUCFfi5S3x0WkkGg2ITRb0pSTLe
        vz+ewK9sG8hHXXuxq4+i5Z8Di0W6Tdja0Blt+YEtxuqwJU0yHchhsfRaR/5IAO7sJ4dGHCl+mtT
        SbDF13EYxmphOLhzx+YwkCppfciGQjUfatQQA
X-Received: by 2002:a02:cf04:: with SMTP id q4mr9572694jar.87.1584367059506;
        Mon, 16 Mar 2020 06:57:39 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtNPvPZSYhWxM/8qdJsnQ0HV6J98ZSgGTa1bi4C+JJwXzj6XCPHyu7EOkwfMD3Vu6PwhYirIlDVFEzqlntUoBQ=
X-Received: by 2002:a02:cf04:: with SMTP id q4mr9572653jar.87.1584367059169;
 Mon, 16 Mar 2020 06:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <20200315012523.GC208715@linux.intel.com> <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
 <7f9f2efe-e9af-44da-6719-040600f5b351@fortanix.com>
In-Reply-To: <7f9f2efe-e9af-44da-6719-040600f5b351@fortanix.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Mon, 16 Mar 2020 09:57:28 -0400
Message-ID: <CAOASepNifZdBmg59sJcP1mqSYMW_C=KsdKq-fCmvAU_5iQ9DFw@mail.gmail.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
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

On Mon, Mar 16, 2020 at 9:32 AM Jethro Beekman <jethro@fortanix.com> wrote:
>
> On 2020-03-15 18:53, Nathaniel McCallum wrote:
> > On Sat, Mar 14, 2020 at 9:25 PM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> >>
> >> On Wed, Mar 11, 2020 at 01:30:07PM -0400, Nathaniel McCallum wrote:
> >>> Currently, the selftest has a wrapper around
> >>> __vdso_sgx_enter_enclave() which preserves all x86-64 ABI callee-saved
> >>> registers (CSRs), though it uses none of them. Then it calls this
> >>> function which uses %rbx but preserves none of the CSRs. Then it jumps
> >>> into an enclave which zeroes all these registers before returning.
> >>> Thus:
> >>>
> >>>   1. wrapper saves all CSRs
> >>>   2. wrapper repositions stack arguments
> >>>   3. __vdso_sgx_enter_enclave() modifies, but does not save %rbx
> >>>   4. selftest zeros all CSRs
> >>>   5. wrapper loads all CSRs
> >>>
> >>> I'd like to propose instead that the enclave be responsible for saving
> >>> and restoring CSRs. So instead of the above we have:
> >>>   1. __vdso_sgx_enter_enclave() saves %rbx
> >>>   2. enclave saves CSRs
> >>>   3. enclave loads CSRs
> >>>   4. __vdso_sgx_enter_enclave() loads %rbx
> >>>
> >>> I know that lots of other stuff happens during enclave transitions,
> >>> but at the very least we could reduce the number of instructions
> >>> through this critical path.
> >>
> >> What Jethro said and also that it is a good general principle to cut
> >> down the semantics of any vdso as minimal as possible.
> >>
> >> I.e. even if saving RBX would make somehow sense it *can* be left
> >> out without loss in terms of what can be done with the vDSO.
> >
> > Please read the rest of the thread. Sean and I have hammered out some
> > sensible and effective changes.
>
> I'm not sure they're sensible? By departing from the ENCLU calling convention, both the VDSO
> and the wrapper become more complicated.

For the vDSO, only marginally. I'm counting +4,-2 instructions in my
suggestions. For the wrapper, things become significantly simpler.

> The wrapper because now it needs to implement all
> kinds of logic for different behavior depending on whether the VDSO is or isn't available.

When isn't the vDSO available? Once the patches are merged it will
always be available. Then we also get to live with this interface
forever. I'd rather have a good, usable interface for the long term.

> I agree with Jarkko that everything should be kept small and simple. Calling a couple extra instructions is going to have a negligible effect compared to the actual time EENTER/EEXIT take.

We all agree on small and simple. Nothing I've proposed fails either
of those criteria.

> Can someone remind me why we're not passing TCS in RBX but on the stack?

If you do that, the vDSO will never be callable from C. And, as you've
stated above, calling a couple extra instructions is going to have a
negligible effect.

