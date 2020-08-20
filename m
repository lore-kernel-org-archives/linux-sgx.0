Return-Path: <SRS0=LqHz=B6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD59C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 17:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 147BE208B3
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 17:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597945497;
	bh=rqDhTzeraPGPIIawJkvwKcw1vUA8gGTZC3i6nxjmHTY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=EGO8weGRpqIfjIv+g4jS0tNKI8bV44yEjXo1M9q7eLmMVquxzPzvuAnCrHKldl3bb
	 QYqPU6o77Et5h2zuaTYDsBNDlPltRehUJ/WY0XjKgaacRW0sxm7ot920unr/W4LlVP
	 nEUv+4yOfK73IGzIb8SqEbGnD2pFHY+BQ5N9h6Ho=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgHTRoz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Aug 2020 13:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbgHTRov (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Aug 2020 13:44:51 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 501CE21734
        for <linux-sgx@vger.kernel.org>; Thu, 20 Aug 2020 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597945490;
        bh=rqDhTzeraPGPIIawJkvwKcw1vUA8gGTZC3i6nxjmHTY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qWHKUrfSXVnoW2ZIJBaMhEuctN5Nvk4ThCuzkGOLYdbmYXGNasImTF3NLuBOszgSn
         /GYUWNXQD7oxhuvwJ8DxyuQpTxKkHPwHnj/zgxL+CkTgGV3+Ljd4jlOOSZ/TIs3+il
         V1P8ZhzqNnwEpfCfb+eIomPSu9XxbsDCPcM5lb40=
Received: by mail-wm1-f54.google.com with SMTP id c80so2418847wme.0
        for <linux-sgx@vger.kernel.org>; Thu, 20 Aug 2020 10:44:50 -0700 (PDT)
X-Gm-Message-State: AOAM531uqKgExyoiUs84MEWoUZmpK1RpZTjE37A/OvMG3xd3aojrDjKf
        nj/QVrcEemRGTeag8btnq1HZOc09AkLl6dWXQY9srw==
X-Google-Smtp-Source: ABdhPJy5WQbZjTgiwCwC+ugFOuMlDq/eY0DVxXftaullynitzIBc3zMyEEMLHEFCDnrpZ+yhaQWoJtNfM2ca0dLjQqE=
X-Received: by 2002:a1c:de86:: with SMTP id v128mr4402971wmg.36.1597945488785;
 Thu, 20 Aug 2020 10:44:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-5-sean.j.christopherson@intel.com> <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
 <6109f3e1-0579-67c6-0a02-f9b931ba1fac@fortanix.com> <CALCETrW94nC5jtQcn7tCMm4itrGSbpxSadtyQUJ=UcR4bFPJ4Q@mail.gmail.com>
 <8603e74e-6484-6e28-164f-2b0f908d5986@fortanix.com>
In-Reply-To: <8603e74e-6484-6e28-164f-2b0f908d5986@fortanix.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 20 Aug 2020 10:44:36 -0700
X-Gmail-Original-Message-ID: <CALCETrVTxdssjtp1+E8RH5wek2FauJTmJhGqp8taBzXVSm6VFQ@mail.gmail.com>
Message-ID: <CALCETrVTxdssjtp1+E8RH5wek2FauJTmJhGqp8taBzXVSm6VFQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the
 vDSO loop on interrupts
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 20, 2020 at 4:20 AM Jethro Beekman <jethro@fortanix.com> wrote:
>
> On 2020-08-19 17:02, Andy Lutomirski wrote:
> > On Wed, Aug 19, 2020 at 7:21 AM Jethro Beekman <jethro@fortanix.com> wr=
ote:
> >>
> >> On 2020-08-18 19:15, Andy Lutomirski wrote:
> >>> On Mon, Aug 17, 2020 at 9:24 PM Sean Christopherson
> >>> <sean.j.christopherson@intel.com> wrote:
> >>>>
> >>>> Allow userspace to exit the vDSO on interrupts that are acknowledged
> >>>> while the enclave is active.  This allows the user's runtime to swit=
ch
> >>>> contexts at opportune times without additional overhead, e.g. when u=
sing
> >>>> an M:N threading model (where M user threads run N TCSs, with N > M)=
.
> >>>
> >>> This is IMO rather odd.  We don't support this type of notification o=
n
> >>> interrupts for normal user code.  The fact user code can detect
> >>> interrupts during enclave execution is IMO an oddity of SGX, and I
> >>> have asked Intel to consider replacing the AEX mechanism with
> >>> something more transparent to user mode.  If this ever happens, this
> >>> mechanism is toast.
> >>
> >> Let's design the current interface for the current architecture. We ca=
n deal with a new architecture if and when Intel provides it.
> >
> > No.  If Intel fixes the architecture, the proposed interface will
> > *stop working*.
> >
> >>
> >>> Even without architecture changes, building a *reliable* M:N threadin=
g
> >>> mechanism on top of this will be difficult or impossible, as there is
> >>> no particular guarantee that a thread will get timing interrupts at> =
all or that these interrupts will get lucky and hit enclave code, thus
> >>> triggering an AEX.  We certainly don't, and probably never will,
> >>> support any corresponding feature for non-enclave code.
> >>
> >> There's no guarantee, but this vDSO exit mechanism is a prerequisite. =
Both for context switching and aborting an enclave, userspace *must* have a=
 way to trigger exit from enclave mode *and* recover the user stack in a sa=
ne manner. Userspace *should* also be able to do this in a way that's compa=
tible with library use, so calling timer_create or pthread_kill to deliver =
a signal would be ok, but installing a signal handler should be avoided (th=
e whole reason behind this vDSO call).
> >
> > If you want to abort an enclave, abort it the same way you abort any
> > other user code -- send a signal or something.  If something is wrong> =
with signal handling in the proposed vDSO interface, then by all
> > means, let's fix it.  If we need better library signal support, let's
> > add such a thing.  If you really want to abort an enclave *cleanly*
> > without any chance of garbage left around, stick it in a subprocess.
> > We are not playing the game where someone sets a flag, crosses their
> > fingers, and waits for an interrupt.
>
> Sending a signal is not sufficient. The current __vdso_sgx_enter_enclave =
call is not interruptible.
>

Why not?  If we are failing to deliver signals if
__vdso_sgx_enter_enclave() is running, we have a bug and we should fix
it.  We should actually deliver the signal and then either resume the
enclave or return -EINTR or equivalent.  Are we getting this wrong?
Looking at your code, I think we're doing it right but maybe we could
do better.

I suppose we also need a test case for this if we do anything fancy here.

> > Now maybe I'm wrong and there's an actual legitimate use case for this
> > trick, in which case I'd like to be enlightened.  But M:N threading
> > and enclave aborting don't sound like legitimate use cases.
> >
>
> Why is it ok for this code to return to userspace after 1 second:
>
>
>
> void ignore_signal_but_dont_restart(int s) {}
>
> // set SIGALRM handler if none set (FIXME: racy)
> struct sigaction sa_old;
> struct sigaction sa =3D {
>     .sa_handler =3D ignore_signal_but_dont_restart,
>     .sa_flags =3D 0,
> };
> sigaction(SIGALRM, &sa, &sa_old);
> if (!(sa_old.sa_handler =3D=3D SIG_IGN || sa_old.sa_handler =3D=3D SIG_DF=
L)
>     || (sa_old.sa_flags & SA_SIGINFO)) {
>     sa_old.sa_flags &=3D ~SA_RESTART;
>     sigaction(SIGALRM, &sa_old, NULL);
> }
>
> alarm(1);
>
> char buf;
> read(0, &buf, 1);
>

Seems fine.  That's POSIX.  User code is receiving a signal and is
being affected by the signal.  A signal is a user-visible thing.

>
>
> But, according to your train of thought, this code must hang indefinitely=
 (assuming the enclave is not calling EEXIT)?
>
>
>
> void ignore_signal_but_dont_restart(int s) {}
>
> // set SIGALRM handler if none set (FIXME: racy)
> struct sigaction sa_old;
> struct sigaction sa =3D {
>     .sa_handler =3D ignore_signal_but_dont_restart,
>     .sa_flags =3D 0,
> };
> sigaction(SIGALRM, &sa, &sa_old);
> if (!(sa_old.sa_handler =3D=3D SIG_IGN || sa_old.sa_handler =3D=3D SIG_DF=
L)
>     || (sa_old.sa_flags & SA_SIGINFO)) {
>     sa_old.sa_flags &=3D ~SA_RESTART;
>     sigaction(SIGALRM, &sa_old, NULL);
> }
>
> alarm(1);
>
> __vdso_sgx_enter_enclave(0, 0, 0, 2, 0, 0, tcs, NULL, NULL);
>

This is a genuine semantic question: is __vdso_sgx_enter_enclave()
like read on a pipe (returns -EINTR on a signal) or is it more like a
restartable syscall or a normal library function that just keeps
running if your signal handler does nothing?  You could siglongjmp()
out, but that's a bit gross.

I wouldn't object to an option to __vdso_sgx_enter_enclave() to make
it return -EINTR if signaled by a non-SA_RESTART signal.  Implementing
it might be distinctly nontrivial, though.

But this isn't what this patch does, and I suspect we've been talking
past each other.  This patch makes __vdso_sgx_enter_enclave() return
if there's an *interrupt*.  If you push a keyboard button, move your
mouse, get a network interrupt on that core, etc, it will return.
This is nonsense.

--Andy
