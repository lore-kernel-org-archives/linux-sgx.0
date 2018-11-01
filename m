Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1159C0044C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 18:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A54B7205F4
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 18:09:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A54B7205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbeKBDNh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Nov 2018 23:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52488 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbeKBDNh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Nov 2018 23:13:37 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EAE51308A948;
        Thu,  1 Nov 2018 18:09:33 +0000 (UTC)
Received: from oldenburg.str.redhat.com (ovpn-116-136.ams2.redhat.com [10.36.116.136])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8872105705E;
        Thu,  1 Nov 2018 18:09:20 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        "Christopherson\, Sean J" <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linux API <linux-api@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rich Felker <dalias@libc.org>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun\, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Adhemerval Zanella <adhemerval.zanella@linaro.org>,
        carlos@redhat.com
Subject: Re: RFC: userspace exception fixups
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Date:   Thu, 01 Nov 2018 19:09:17 +0100
In-Reply-To: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
        (Andy Lutomirski's message of "Thu, 1 Nov 2018 10:53:40 -0700")
Message-ID: <877ehwisaa.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 01 Nov 2018 18:09:34 +0000 (UTC)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181101180917.H6Is7XsV4s2_4Gqpmuf5rjymQ2lFvvQHxBXYALN-0ew@z>

* Andy Lutomirski:

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

Would the exception handler be a per-thread resource?

If it is: Would the setup and teardown overhead be prohibitive for many
use cases (at least those do not expect a fault)?

Something peripherally related to this interface: Wrappers for signal
handlers (and not just CPU exceptions).  Ideally, we want to maintain a
flag that indicates whether we are in a signal handler, and save and
restore errno around the installed handler.

> Alternatively, we could do something a lot more like the kernel's
> internal fixups where there's a table in user memory that maps
> potentially faulting instructions to landing pads that handle
> exceptions.

GCC already supports that on most Linux targets.  You can unwind from
synchronously invoked signal handlers if you compile with
-fnon-call-exceptions.

However, it's tough to set up a temporary signal handler to trigger such
unwinding because those aren't per-thread.

> On Windows, you can use SEH to do crazy things like running
> known-buggy code and eating the page faults.  I don't think we want to
> go there.

The original SEH was also a rich target for exploiting vulnerabilities.
That's something we really should avoid as well.

I wonder if it would be possible to tack this function onto rseq.

Thanks,
Florian
