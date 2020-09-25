Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D090C4727E
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 20:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2734206FC
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 20:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601065994;
	bh=R2B4CZI1Vo2yizkiYehqOWUsCi8h2JC6TtVkB3rBz2k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=HuHFWj3FWtHmyGMU0yJYXOVAI/CkM9ssxylBYm6ZIG22d71pXGjK6OqTjL74A3CE7
	 BrVD1HYTMvbcQtv+J6sAFM9mqCwosyp5KilEtmmUZiD6YX1vhCreoNR2ogPPdIAXEj
	 fcKHRcG/uWRzpLEkGaTvgnpizrqquNZkJuMkoS/0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgIYUdM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 16:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbgIYUUT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 16:20:19 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE3062389F
        for <linux-sgx@vger.kernel.org>; Fri, 25 Sep 2020 20:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601065218;
        bh=R2B4CZI1Vo2yizkiYehqOWUsCi8h2JC6TtVkB3rBz2k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ksq+8LOi4CcXWdy2uABVrhDqJB47i8p7w6gIVC2hJY8+Tvq07pjb8hL1QfszIr2Bt
         QaMxXLHwk/vVM7siBmt30hJ+uDMJ1fvvHxYq3PGYLaB5zuU/0f2WgBRIclMYJoIKE7
         4uAow+bikLfWNTWiNXDDe6TMeawAUrkUejfGHvFo=
Received: by mail-wr1-f50.google.com with SMTP id w5so5093577wrp.8
        for <linux-sgx@vger.kernel.org>; Fri, 25 Sep 2020 13:20:17 -0700 (PDT)
X-Gm-Message-State: AOAM532DfrrA9PEwZBZuXhmqhKInIqaPDgaIr5EEIFKECU1GjEGDmtxX
        KHwHBv46LF0JXxDuw38nCVj3Ykr7OAKo3UPlWUyOtA==
X-Google-Smtp-Source: ABdhPJyWF7AUaI8SR+nes9l7fegEZC3y76AaL+Z2ZdDfUG2lv86csMTl0exC3ZZwMbkcjdgeZ9k5snm2bz91Cb4iwp8=
X-Received: by 2002:adf:a3c3:: with SMTP id m3mr6186242wrb.70.1601065216298;
 Fri, 25 Sep 2020 13:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrUhQjQQa-BqNHPgdDfD9GDJZXJWSQ_M0tDF_ri5RfyTsw@mail.gmail.com>
 <20200925190915.GD31528@linux.intel.com>
In-Reply-To: <20200925190915.GD31528@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 25 Sep 2020 13:20:03 -0700
X-Gmail-Original-Message-ID: <CALCETrWDgb_mVPDmKy_7oFg03cOxO-GAUS8kOFrfGiPp9RjboA@mail.gmail.com>
Message-ID: <CALCETrWDgb_mVPDmKy_7oFg03cOxO-GAUS8kOFrfGiPp9RjboA@mail.gmail.com>
Subject: Re: Can we credibly make vdso_sgx_enter_enclave() pleasant to use?
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 12:09 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> +Nathaniel, Cedric and linux-sgx
>
> On Fri, Sep 25, 2020 at 09:55:00AM -0700, Andy Lutomirski wrote:
> > vdso_sgx_enter_enclave() sucks. I don't think anyone seriously likes
> > it, but maybe it's the best we can do.
>
> The code itself sucks, or the API sucks?

I'm referring to the API.

>
> For the code, given the constraints of SGX and the number of runtimes we're
> enabling, I don't think it's bad at all.  It's not hard to maintain, there are
> no horrendous hacks, and it doesn't play games with the caller's state, i.e.
> there's no additional magic required.  In other words, I really like that we
> have in hand _works_, and works for a variety of runtimes and their ABIs.

Well, it _works_, but I see at least two implementation issues.
There's the CET problem that Andrew Cooper spotted (solvable without
too much work).  Also, the code really ought to have .cfi annotations
because it's user code and userspace expects libunwind, gdb, etc to
work.

>
> The API isn't glorious, but it's not awful either.
>
> > I'm wondering if it's worth trying to do better.  Here's what I'd like
> > if I could wave a magic wand:
> >
> > struct sgx_enclave_run {
> >        __u64 tcs;
> >        __u32 flags;
> >        __u32 exit_reason;
> >
> >     /*
> >      * These values are exposed to the enclave on entry, and the values
> >      * left behind by the enclave are returned here.
> >      * Some enclaves might write to memory pointed to by rsp.
> >      */
> >        __u64 rsp, rbp, r8, r9, r10, r11, r12, r13, r14, r15;
> >        /* Maybe other regs too? */
> >
> >        union {
> >                struct sgx_enclave_exception exception;
> >
> >                /* Pad the entire struct to 256 bytes. */
> >                __u8 pad[256 - 32];
> >        };
> > };
> >
> > long vdso_sgx_enter_enclave(unsigned int leaf, struct sgx_enclave_run *r);
> >
> > No callback, no asm wrapper needed, no nastiness from the perspective
> > of the caller.
> >
> > So here are my questions.  First, do people agree with me that this
> > would be better?
>
> No?
>
> From a user perspective, I don't find the callback particularly onerous.
> Avoiding the callback would yield prettier code for the caller, but IMO it
> doesn't fundamentally make the code easier to maintain.  Implementing the
> callback is a one-time cost for a relatively small number of people, and it's
> not even all that difficult to write, especially compared to all the other crud
> that needs to be done to enable SGX.

[lots of discussion about r8 .. r15]

r8 through r15 are kind of red herrings.  I think that supporting them
as C-callable input/output args in the vDSO would be polite but isn't
really important. The actual important part I'm thinking of is RSP,
RBP, and the callback.

>
> So it really comes down to context switching versus using a callback.  Not that
> this is exactly a hot path, but for me having to implement a callback versus
> bloating the vDSO with state save and restore is a mostly a wash.
>
> > Second, could this be implemented in a way that doesn't utterly suck?  The
> > best I've come up with so far is abusing WRFSBASE to shove a little data
> > structure containing the real user RSP or RBP along with the old FSBASE into
> > FSBASE, do EENTER, and then undo the FSBASE dance.  We'd also need some
> > additional exception fixup magic to prevent a signal or ptrace() from
> > observing the intermediate states and getting extremely confused.
>
> But where would the vDSO get memory for that little data structure?  It can't
> be percpu because the current task can get preempted.  It can't be per instance
> of the vDSO because a single mm/process can have multiple tasks entering an
> enclave.  Per task might work, but how would the vDSO get that info?  E.g.
> via a syscall, which seems like complete overkill?

The stack.  The vDSO could, logically, do:

struct sgx_entry_state {
  unsigned long real_rbp;
  unsigned long real_rsp;
  unsigned long orig_fsbase;
};

...

  struct sgx_entry_state state;
  state.rbp = rbp;  [ hey, this is pseudocode.  the real code would be in asm.]
  state.rsp = rsp;
  state.fsbase = __rdfsbase();
  rbp = arg->rbp;

  /* set up all other regs */
  wrfsbase %rsp
  movq enclave_rsp(%rsp), %rsp
  enclu
  rdfsbase %rsp

Expressing this abomination using DWARF is surely entirely impossible,
so instead we would want to make sure that user code simply cannot
observe the state between the wrfsbase and the rdfsbase.  This would
require three exception hooks, which is more than we have now but is
not actually unmanageable.  And it would be possible to write a test
case to make sure we got it right.  A downside is that single-stepping
this mess would probably not work in any sensible way.

This could also be handled more slowly by introducing an actual
syscall so the kernel could help out.  This would also be pretty ugly.

On the other hand, if we had some confidence that the existing corpus
of enclaves plays games with RSP but not RBP, we could handle this
much more straightforwardly and even likely perserve DWARF support,
although we'd still have strange artifacts if we got a signal in the
wrong place.

(If we have CET, we could do truly unspeakable things involving saving
our state on the shadow stack.  Don't think too hard about this.)

>
> So, no?
>
> If we truly want to provide a "better" vDSO, my vote would be to disallow using
> the runtime's stack from within the enclave.  But I'm guessing that would cause
> more than a few aneurysms for the folks that are cc'd :-)

Indeed.

My real problem with the callback is that it forces the untrusted
runtime to use a C-like stack model and to keep the vDSO entry on the
stack while handling the OCALL or whatever you want to call it.  This
is fine for those of us who exclusively program in C, aren't doing
anything fancy, and want to think of enclaves as just more C code.
But enclaves aren't just more C code -- they're more-or-less-immutable
blobs, and they can't easily evolve with the untrusted code that
invokes them.  And the world is slowly but surely moving toward
languages that aren't quite as C-like as C.  In a language with
stackless coroutines or async/await or continuations or goroutines,
this could all get quite awkward.  Sure, a really nice Rust or Go SGX
untrusted runtime could just declare that it won't support enclaves
that touch the stack, but that's a bit of an unfortunate restriction
given that removing stack access from an existing enclave will
inevitably change MRENCLAVE.

If I thought there was a straightforward way to support all existing
enclaves without callbacks in the vDSO, I would be all for it.  I'm
wondering if doing so even unstraightforwardly would still be
worthwhile.

If everyone wants to tell me that what we have now (plus .cfi
annotations and perhaps a CET fix) is good enough, then so be it.  But
I figured I'd ask.

--Andy
