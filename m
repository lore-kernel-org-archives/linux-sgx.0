Return-Path: <SRS0=I8pg=B5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6DBC433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 15:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C582076E
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597849386;
	bh=DTsxGWRguc9gXJQEhpyyfMrSqpLRVbFAvw1E9BKHzlg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=MZE5LPu4u6sp6VXxwyH7noae0NWnCAsqxmOvEWMF5yrPhHU5cI8+a6lFcfcr/wrS+
	 T6AB1wU2fvMgerDt20fMpxYZ2IOAuvMs4AzXFRuRZGMAFijwMjhzJTO2K8JyHsD+xy
	 RqZqgxQ6tIX20+MTpjREf4XBk3XQhby1vcE6ZRn0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgHSPDE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgHSPDC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Aug 2020 11:03:02 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32AD520882
        for <linux-sgx@vger.kernel.org>; Wed, 19 Aug 2020 15:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597849381;
        bh=DTsxGWRguc9gXJQEhpyyfMrSqpLRVbFAvw1E9BKHzlg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dG3VqY2RUKWhVjzz+AyL7mUCoNfThbKRDsUQ5Hm83QrgzupiQjiyGbTJvq1EZpVwp
         kXLQEZ6TgaoI45pSaakV4eRSrhFNfwol/tfinVXCiDAIEecNUUExPT4FU2PeR9cQtc
         7Tk6xMHp5slRWt7weTi+qtkbKn8TQ+fpOuEIoYpc=
Received: by mail-wm1-f41.google.com with SMTP id g8so2406176wmk.3
        for <linux-sgx@vger.kernel.org>; Wed, 19 Aug 2020 08:03:01 -0700 (PDT)
X-Gm-Message-State: AOAM531oFOwSJhtPy+xHJWAJ+AZy9UxWv6D0LH8g3I0lycqb/9/ukrgv
        0XDsqsk4D9vjKreg6VtnXNdB0jl8u3uh+TU92mxtvw==
X-Google-Smtp-Source: ABdhPJyuQPnYfajBJucVLJM5okmkc6h9Av502mcyNcjiwb5yZ3SfXtT99qJchfX6uegfzZHm8LnwEASCgc2DMOEiyEc=
X-Received: by 2002:a1c:de86:: with SMTP id v128mr5152027wmg.36.1597849379714;
 Wed, 19 Aug 2020 08:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-5-sean.j.christopherson@intel.com> <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
 <6109f3e1-0579-67c6-0a02-f9b931ba1fac@fortanix.com>
In-Reply-To: <6109f3e1-0579-67c6-0a02-f9b931ba1fac@fortanix.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 19 Aug 2020 08:02:48 -0700
X-Gmail-Original-Message-ID: <CALCETrW94nC5jtQcn7tCMm4itrGSbpxSadtyQUJ=UcR4bFPJ4Q@mail.gmail.com>
Message-ID: <CALCETrW94nC5jtQcn7tCMm4itrGSbpxSadtyQUJ=UcR4bFPJ4Q@mail.gmail.com>
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

On Wed, Aug 19, 2020 at 7:21 AM Jethro Beekman <jethro@fortanix.com> wrote:
>
> On 2020-08-18 19:15, Andy Lutomirski wrote:
> > On Mon, Aug 17, 2020 at 9:24 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >>
> >> Allow userspace to exit the vDSO on interrupts that are acknowledged
> >> while the enclave is active.  This allows the user's runtime to switch
> >> contexts at opportune times without additional overhead, e.g. when usi=
ng
> >> an M:N threading model (where M user threads run N TCSs, with N > M).
> >
> > This is IMO rather odd.  We don't support this type of notification on
> > interrupts for normal user code.  The fact user code can detect
> > interrupts during enclave execution is IMO an oddity of SGX, and I
> > have asked Intel to consider replacing the AEX mechanism with
> > something more transparent to user mode.  If this ever happens, this
> > mechanism is toast.
>
> Let's design the current interface for the current architecture. We can d=
eal with a new architecture if and when Intel provides it.

No.  If Intel fixes the architecture, the proposed interface will
*stop working*.

>
> > Even without architecture changes, building a *reliable* M:N threading
> > mechanism on top of this will be difficult or impossible, as there is
> > no particular guarantee that a thread will get timing interrupts at> al=
l or that these interrupts will get lucky and hit enclave code, thus
> > triggering an AEX.  We certainly don't, and probably never will,
> > support any corresponding feature for non-enclave code.
>
> There's no guarantee, but this vDSO exit mechanism is a prerequisite. Bot=
h for context switching and aborting an enclave, userspace *must* have a wa=
y to trigger exit from enclave mode *and* recover the user stack in a sane =
manner. Userspace *should* also be able to do this in a way that's compatib=
le with library use, so calling timer_create or pthread_kill to deliver a s=
ignal would be ok, but installing a signal handler should be avoided (the w=
hole reason behind this vDSO call).

If you want to abort an enclave, abort it the same way you abort any
other user code -- send a signal or something.  If something is wrong
with signal handling in the proposed vDSO interface, then by all
means, let's fix it.  If we need better library signal support, let's
add such a thing.  If you really want to abort an enclave *cleanly*
without any chance of garbage left around, stick it in a subprocess.
We are not playing the game where someone sets a flag, crosses their
fingers, and waits for an interrupt.

>
> > So this seems like an odd, and possibly unsupportable, feature to add.
>
> I can implement all this without the vDSO call today, so why not support =
it? That just means not everyone is going to use the vDSO call, again resul=
ting in potential problems when multiple libraries want to use enclaves.

No offense, but if you want to write garbage software with entirely
user code, I can't stop you, but the kernel is not going to give this
anything resembling a stamp of approval.  When you inevitably discover
that it has broken for one reason or another and your software stack
stops making forward progress, I don't want anyone playing the "ABI
stability" card and asking the upstream kernel to work around the
breakage.

Now maybe I'm wrong and there's an actual legitimate use case for this
trick, in which case I'd like to be enlightened.  But M:N threading
and enclave aborting don't sound like legitimate use cases.
