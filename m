Return-Path: <SRS0=RM7e=N6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28309C43441
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 15:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E413B206BB
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 15:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UwtB8YMv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E413B206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbeKTBxq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Nov 2018 20:53:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729713AbeKTBxq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Nov 2018 20:53:46 -0500
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58DEA214DA
        for <linux-sgx@vger.kernel.org>; Mon, 19 Nov 2018 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542641390;
        bh=4ArSSgLvYbln2z+xtgBfTKwMGLB3G7ywEbt69m03hR8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UwtB8YMvWHhR1oe8I8LevWmTxy5vfHK/VaHldN6gWx+8yzLStmGw2I9Aj5z0gq65U
         MhHmgOKTL7Uk3IREYdjqMlJQhiP1SryVuwxDfD7lmBWQjMc+6DSkIvRKQNoACkFfNp
         vw5rOSrPXERO7X6cS8hqMWBbbIjVHSc6ql8INzKE=
Received: by mail-wr1-f47.google.com with SMTP id j2so4157792wrw.1
        for <linux-sgx@vger.kernel.org>; Mon, 19 Nov 2018 07:29:50 -0800 (PST)
X-Gm-Message-State: AGRZ1gK+FfVSK27XxsPnaKTZbr9WRrxQXlvXhHMx6RQRIlQAnQGAidkO
        kNu1bVjgi46ArJIzebnGseZzTR/ckeZe2d/kkk1Gjw==
X-Google-Smtp-Source: AJdET5dycq0bVkF+VUNKU9L4Pdz2FtjptGEEF2z93ehVrY9Y+OXprP7hE7juHxk9zZZWu256DHo/uMKdKhcyAajfAQY=
X-Received: by 2002:adf:afdc:: with SMTP id y28-v6mr18038620wrd.176.1542641388634;
 Mon, 19 Nov 2018 07:29:48 -0800 (PST)
MIME-Version: 1.0
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
In-Reply-To: <20181118071548.GA4795@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 19 Nov 2018 07:29:36 -0800
X-Gmail-Original-Message-ID: <CALCETrXSpn7QGzPgO1BjMRQ75r2i0kmACrbUM+8PyT+xi3f3Hw@mail.gmail.com>
Message-ID: <CALCETrXSpn7QGzPgO1BjMRQ75r2i0kmACrbUM+8PyT+xi3f3Hw@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andrew Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rich Felker <dalias@libc.org>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 17, 2018 at 11:16 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Thu, Nov 01, 2018 at 10:53:40AM -0700, Andy Lutomirski wrote:
> > Hi all-
> >
> > The people working on SGX enablement are grappling with a somewhat
> > annoying issue: the x86 EENTER instruction is used from user code and
> > can, as part of its normal-ish operation, raise an exception.  It is
> > also highly likely to be used from a library, and signal handling in
> > libraries is unpleasant at best.
> >
> > There's been some discussion of adding a vDSO entry point to wrap
> > EENTER and do something sensible with the exceptions, but I'm
> > wondering if a more general mechanism would be helpful.
>
> I haven't really followed all of this discussion because I've been busy
> working on the patch set but for me all of these approaches look awfully
> complicated.
>
> I'll throw my own suggestion and apologize if this has been already
> suggested and discarded: return-to-AEP.
>
> My idea is to do just a small extension to SGX AEX handling. At the
> moment hardware will RAX, RBX and RCX with ERESUME parameters. We can
> fill extend this by filling other three spare registers with exception
> information.

I have two issues with this approach:

1. The kernel needs some way to know *when* to apply this fixup.
Decoding the instruction stream and doing it to all exceptions that
hit an ENCLU instruction seems like a poor design.

2. It starts exposing what looks like a more generic exception
handling mechanism to userspace, except that it's nonsensical for
anything other than ENCLU.
