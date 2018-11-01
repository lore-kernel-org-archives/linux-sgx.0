Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8029C0044C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 18:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC83920831
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 18:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hky0196a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC83920831
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbeKBDiH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Nov 2018 23:38:07 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:33317 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbeKBDiH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 1 Nov 2018 23:38:07 -0400
Received: by mail-oi1-f173.google.com with SMTP id c25-v6so17472902oiy.0
        for <linux-sgx@vger.kernel.org>; Thu, 01 Nov 2018 11:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VydAecWCb2O6SNfJkI4cq4re5+yo1Xcs1mpLrFucJa8=;
        b=hky0196a7cwB2rM7dJ30lrKv6D/YrNg34ugSwkgvw+RPxl9GcztNQ9LAdVy7e58s5D
         geN9s6d96KFlsVvpImymSAP60bf1h7XHcJjX0TYklEmI6N6ZEk+Iwb7GJDBYPk5yt1wX
         SzxJPtWpH4ko2GEMAwILpy+SBbGIFjQg+03AwXulXiu1pwfP9B6fE9xWG7KXFl1tb0Yc
         YYU+C8g1S6Vb1Gin7TPKxgQKapyeq7X2NeFg2xqXn6IClC+6UU3t8yHxUzIn9RAdTANy
         Ly300kWRlYLPl14ju3fLBJJergir/Q7O+k+jBM/1rNMJsO7/pvY9XmugFVZpGxqdhMzW
         uvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VydAecWCb2O6SNfJkI4cq4re5+yo1Xcs1mpLrFucJa8=;
        b=kYLji0LUTSFjDF0oW/r9wygzG8M9DKe+Ft24nOzu8t28vQzoTHh7xS7ZF80tjTaaMU
         U9Jc9Iu49q9HpQBnNANUVxvYw7PxczFpajX5p2UNjtZoI0bDX8zsh+A8cdd7KsJIax3w
         IbyYC+QvOFGH3YhPwEQr4vlZIREKa2x6n/TCus3GovQxT9LLP7ectEibioBqfXKKsto7
         b+DoXbaUFxc2hjgZm1FBXpMAXcil5WG/PYC4vSXOrhEuXRjWy9VghN58Ak5Bi6ZFG5HK
         /ZKSocrHBfcEPIdxR0UZNmICdKSj/I2S8WD2jRjBd853FWbFxSGAUpMiqB1YgsTxwuNP
         9pdg==
X-Gm-Message-State: AGRZ1gLHN9S94Z8MVpKaeAgfolDgALaA1bTT55ZLWzFDuq58dXS4+Qiz
        UP135MA1zBexmo9OnHFbhtV9E0nCASAP1Ze04uWVyQ==
X-Google-Smtp-Source: AJdET5fxbCEKKYRxCYfCMya3XFKcH8+zAYsJxDu6iRAyPhJ6EMyTbpiOsleLP8QdXNP3IoCptXZ5VjYWpWssRlzgsKE=
X-Received: by 2002:aca:b05:: with SMTP id 5-v6mr5168286oil.157.1541097239392;
 Thu, 01 Nov 2018 11:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
In-Reply-To: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 1 Nov 2018 19:33:33 +0100
Message-ID:
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        sean.j.christopherson@intel.com, jethro@fortanix.com,
        jarkko.sakkinen@linux.intel.com,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, dalias@libc.org,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        andriy.shevchenko@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        carlos@redhat.com, adhemerval.zanella@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181101183333.69JmF-OiX8SXsjVfHKH5iy7y1kIURIrEdMHpP7g8CiA@z>

On Thu, Nov 1, 2018 at 6:53 PM Andy Lutomirski <luto@kernel.org> wrote:
> The people working on SGX enablement are grappling with a somewhat
> annoying issue: the x86 EENTER instruction is used from user code and
> can, as part of its normal-ish operation, raise an exception.  It is
> also highly likely to be used from a library, and signal handling in
> libraries is unpleasant at best.
>
> There's been some discussion of adding a vDSO entry point to wrap
> EENTER and do something sensible with the exceptions,

This sounds reasonable to me.

> but I'm
> wondering if a more general mechanism would be helpful.
>
> The basic idea would be to allow libc, or maybe even any library, to
> register a handler that gets a chance to act on an exception caused by
> a user instruction before a signal is delivered.  As a straw-man
> example for how this could work, there could be a new syscall:
>
> long register_exception_handler(void (*handler)(int, siginfo_t *, void *));
>
> If a handler is registered, then, if a synchronous exception happens
> (page fault, etc), the kernel would set up an exception frame as usual
> but, rather than checking for signal handlers, it would just call the
> registered handler.

> That handler is expected to either handle the
> exception entirely on its own or to call one of two new syscalls to
> ask for normal signal delivery

If you do it this way, these exception handlers would have to chain,
with an API convention that you're obligated to always ask for
resumption of signal delivery if you don't recognize the address,
right? Kind of like a notifier chain. (Except that, unless this is
implemented in the vDSO, each notifier invocation would cross the
kernel-user boundary twice.)

> or to ask to retry the faulting instruction.

Why would that have to be a syscall? For signal handlers registered
with SA_NODEFER, you can basically leave the signal handler with a
longjmp, right?

> Alternatively, we could do something a lot more like the kernel's
> internal fixups where there's a table in user memory that maps
> potentially faulting instructions to landing pads that handle
> exceptions.

I like this direction more, although I'm not sure whether the table
the kernel sees should be at instruction-level granularity. Perhaps
you could associate an exception handler with a VMA? Any instruction
that faults in the VMA triggers the fault handler?

> Do you think this would be useful?  Here are some use cases that I
> think are valid:
>
> (a) Enter an SGX enclave and handle errors.  There would be two
> instructions that would need special handling: EENTER and ERESUME.
>
> (b) Do some math and catch division by zero.  I think it would be a
> bad idea to have user code call a function and say that it wants to
> handle *any* division by zero, but having certain specified division
> instructions have special handling seems entirely reasonable.
>
> (c) Ditto for floating point errors.
>
> (d) Try an instruction and see if it gets #UD.
>
> (e) Run a bunch of code and handle page faults to a given address
> range by faulting something in.  This is not like the others, in that
> a handler wants to handle a range of target addresses, not
> instructions.  And userfaultfd is plausibly a better solution anyway.
>
> (f) Run NaCl-like sandboxed code where the code can cause page faults
> to certain mapped-but-intentionally-not-present ranges and those need
> to be handled.
>
> On Windows, you can use SEH to do crazy things like running
> known-buggy code and eating the page faults.  I don't think we want to
> go there.
>
> All of this makes me think that the right solution is to have a way to
> register fault handlers for instructions to cover (a) - (d) and to
> treat (e) and (f) as something else entirely if there's enough demand.
