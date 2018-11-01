Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6A6C0044C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 18:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9679A2064C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 18:45:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9679A2064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=libc.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbeKBDt4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Nov 2018 23:49:56 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:57898 "EHLO
        brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbeKBDt4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 1 Nov 2018 23:49:56 -0400
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2018 23:49:55 EDT
Received: from dalias by brightrain.aerifal.cx with local (Exim 3.15 #2)
        id 1gIHh2-0001Vu-00; Thu, 01 Nov 2018 18:27:44 +0000
Date:   Thu, 1 Nov 2018 14:27:44 -0400
From:   Rich Felker <dalias@libc.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
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
        Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: RFC: userspace exception fixups
Message-ID: <20181101182744.GA5150@brightrain.aerifal.cx>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181101182744.MLIObIopCDsHdWwmJFHxvmtRmbTM8K8e02QMSGg8QzU@z>

On Thu, Nov 01, 2018 at 10:53:40AM -0700, Andy Lutomirski wrote:
> Hi all-
> 
> The people working on SGX enablement are grappling with a somewhat
> annoying issue: the x86 EENTER instruction is used from user code and
> can, as part of its normal-ish operation, raise an exception.  It is
> also highly likely to be used from a library, and signal handling in
> libraries is unpleasant at best.
> 
> There's been some discussion of adding a vDSO entry point to wrap
> EENTER and do something sensible with the exceptions, but I'm
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
> registered handler.  That handler is expected to either handle the
> exception entirely on its own or to call one of two new syscalls to
> ask for normal signal delivery or to ask to retry the faulting
> instruction.
> 
> Alternatively, we could do something a lot more like the kernel's
> internal fixups where there's a table in user memory that maps
> potentially faulting instructions to landing pads that handle
> exceptions.

This strikes me as just an "extra layer of signal handlers"; rather
than replacing global state with something that's library-safe, it's
just making new global state that has to have a singleton owner
managing it. If these handlers were thread-local (vs process-global
signal disposition) then you could just register/unregister them on
entry/exit to the library code that needs them, but that has
nontrivial execution time cost.

Moreover, thread-local signal handlers can already be done really
nicely if you don't care about having a global handler (which doesn't
really make sense for synchronous signals). I have fairly canonical
draft code I wrote to demonstrate this a while back which I can share
if there's interest.

One possible advantage of your approach is that it could distinguish
actual synchronous signals from ones sent by kill/sigqueue/etc. This
matters in contexts where the application wants the signal blocked or
ignored. For example if you temporarily set a handler for SIGILL or
SIGSEGV, then unblock it and try to do something that might generate
the signal, you risk consuming an unrelated pending signal sent by
kill/sigqueue/etc. As far as I know there is no way to do this
"transparently". It came up as an issue for why libc init code cannot
do this kind of probing for instruction availability at startup (or
any time).

> Do you think this would be useful?  Here are some use cases that I
> think are valid:
> 
> (a) Enter an SGX enclave and handle errors.  There would be two
> instructions that would need special handling: EENTER and ERESUME.

I'm not familiar with SGX but the vdso approach sounds like a better
abstraction.

> (b) Do some math and catch division by zero.  I think it would be a
> bad idea to have user code call a function and say that it wants to
> handle *any* division by zero, but having certain specified division
> instructions have special handling seems entirely reasonable.

I don't think this is useful. If you really need a division that needs
to survive invalid operands, a simple check before the div
(100%-predictable branch in non-erroneous usage) is dirt cheap.

> (c) Ditto for floating point errors.

Signaling floating point exceptions (rather than sticky flags) are
something of an oddity that's never enabled by default, not supported
on all platforms, and largely (IMO) useless. Generating code that can
support them can be moderately costly too.

> (d) Try an instruction and see if it gets #UD.

In general this seems fairly useful.

> (e) Run a bunch of code and handle page faults to a given address
> range by faulting something in.  This is not like the others, in that
> a handler wants to handle a range of target addresses, not
> instructions.  And userfaultfd is plausibly a better solution anyway.

Agree re: userfaultfd.

> (f) Run NaCl-like sandboxed code where the code can cause page faults
> to certain mapped-but-intentionally-not-present ranges and those need
> to be handled.
> 
> On Windows, you can use SEH to do crazy things like running
> known-buggy code and eating the page faults.  I don't think we want to
> go there.

Agree, this is a huge rabbit hole of filth. Don't go there.

Rich
