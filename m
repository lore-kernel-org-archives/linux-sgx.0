Received: from mga01.intel.com ([192.55.52.88]:58967 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726141AbeKCHQ6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Sat, 3
 Nov 2018 03:16:58 -0400
Date: Sat, 3 Nov 2018 00:07:52 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Lutomirski <luto@kernel.org>
CC: Dave Hansen <dave.hansen@linux.intel.com>, "Christopherson, Sean J"
	<sean.j.christopherson@intel.com>, Jethro Beekman <jethro@fortanix.com>,
	Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>,
	Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>,
	X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Rich
 Felker" <dalias@libc.org>, <nhorman@redhat.com>, <npmccallum@redhat.com>,
	"Ayoun, Serge" <serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>,
	<linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: RFC: userspace exception fixups
Message-ID: <20181102220752.GA24373@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Thu, Nov 01, 2018 at 10:53:40AM -0700, Andy Lutomirski wrote:
> If a handler is registered, then, if a synchronous exception happens
> (page fault, etc), the kernel would set up an exception frame as usual
> but, rather than checking for signal handlers, it would just call the
> registered handler.  That handler is expected to either handle the
> exception entirely on its own or to call one of two new syscalls to
> ask for normal signal delivery or to ask to retry the faulting
> instruction.

Why the syscalls are required? Couldn't the handler have just a return
value to indicate the appropriate action?

Another thing that I'm wondering is that what if a signal occurs inside
the exception handler?

/Jarkko
