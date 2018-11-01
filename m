Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD83C0044C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 17:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A817E2064C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 17:53:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pe+oRCX9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A817E2064C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbeKBC5x (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Nov 2018 22:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:32816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbeKBC5x (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Nov 2018 22:57:53 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4455C2084D
        for <linux-sgx@vger.kernel.org>; Thu,  1 Nov 2018 17:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541094833;
        bh=lxfRkIbnNn5vEkPpgT7ExdEPOv3fuXsZCA4uvAwxVlU=;
        h=From:Date:Subject:To:From;
        b=Pe+oRCX9f30bzoz0mr0Pr1nDUrIKq9CbrzWQLrSDkljBCc5BAaNTkbqvoWMVufnYk
         aErJTnMyiHDwgKdxPCx+SDFbLfVyZzd8CjmhlkdBfM++O7VcUpa4xL8TEmOzEqcps+
         rMb9r5+P8Znzc+ekus0w+1fi9U3l5m0CLV5bujBM=
Received: by mail-wr1-f45.google.com with SMTP id d10-v6so20932938wrs.5
        for <linux-sgx@vger.kernel.org>; Thu, 01 Nov 2018 10:53:53 -0700 (PDT)
X-Gm-Message-State: AGRZ1gJtOB3IrHXI9nhPDtC9Cf2AtBFF+R6m8YRD9C1vuLD6g0vTJJxm
        4yRxR9T7ZdmD1GhZ0lWe6a6uL8aWagtViNkn89hA4Q==
X-Google-Smtp-Source: AJdET5fNAj8WjIWXQkwlGqI7e+GsUgpY92//3LOVIjLeUFVQApbdPQ0OiOC21mmbHFeS6dHLfb2F58SVqURAUImiS5g=
X-Received: by 2002:adf:97d3:: with SMTP id t19-v6mr7793210wrb.283.1541094831751;
 Thu, 01 Nov 2018 10:53:51 -0700 (PDT)
MIME-Version: 1.0
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 1 Nov 2018 10:53:40 -0700
X-Gmail-Original-Message-ID: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Message-ID:
 <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Subject: RFC: userspace exception fixups
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Message-ID: <20181101175340.lS7xaBtD1y94YDkOSrimzTkPde0dZ2ZmPuFA6CrJ5nQ@z>

Hi all-

The people working on SGX enablement are grappling with a somewhat
annoying issue: the x86 EENTER instruction is used from user code and
can, as part of its normal-ish operation, raise an exception.  It is
also highly likely to be used from a library, and signal handling in
libraries is unpleasant at best.

There's been some discussion of adding a vDSO entry point to wrap
EENTER and do something sensible with the exceptions, but I'm
wondering if a more general mechanism would be helpful.

The basic idea would be to allow libc, or maybe even any library, to
register a handler that gets a chance to act on an exception caused by
a user instruction before a signal is delivered.  As a straw-man
example for how this could work, there could be a new syscall:

long register_exception_handler(void (*handler)(int, siginfo_t *, void *));

If a handler is registered, then, if a synchronous exception happens
(page fault, etc), the kernel would set up an exception frame as usual
but, rather than checking for signal handlers, it would just call the
registered handler.  That handler is expected to either handle the
exception entirely on its own or to call one of two new syscalls to
ask for normal signal delivery or to ask to retry the faulting
instruction.

Alternatively, we could do something a lot more like the kernel's
internal fixups where there's a table in user memory that maps
potentially faulting instructions to landing pads that handle
exceptions.

Do you think this would be useful?  Here are some use cases that I
think are valid:

(a) Enter an SGX enclave and handle errors.  There would be two
instructions that would need special handling: EENTER and ERESUME.

(b) Do some math and catch division by zero.  I think it would be a
bad idea to have user code call a function and say that it wants to
handle *any* division by zero, but having certain specified division
instructions have special handling seems entirely reasonable.

(c) Ditto for floating point errors.

(d) Try an instruction and see if it gets #UD.

(e) Run a bunch of code and handle page faults to a given address
range by faulting something in.  This is not like the others, in that
a handler wants to handle a range of target addresses, not
instructions.  And userfaultfd is plausibly a better solution anyway.

(f) Run NaCl-like sandboxed code where the code can cause page faults
to certain mapped-but-intentionally-not-present ranges and those need
to be handled.

On Windows, you can use SEH to do crazy things like running
known-buggy code and eating the page faults.  I don't think we want to
go there.

All of this makes me think that the right solution is to have a way to
register fault handlers for instructions to cover (a) - (d) and to
treat (e) and (f) as something else entirely if there's enough demand.

--Andy
