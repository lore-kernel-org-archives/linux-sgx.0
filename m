Date: Wed, 31 Oct 2018 14:30:36 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>,
	Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, "nhorman@redhat.com"
	<nhorman@redhat.com>, "npmccallum@redhat.com" <npmccallum@redhat.com>,
	"Ayoun, Serge" <serge.ayoun@intel.com>, "shay.katz-zamir@intel.com"
	<shay.katz-zamir@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs
 w/ PF_SGX
Message-ID: <20181031213036.GA23089@linux.intel.com>
References: <20180926173516.GA10920@linux.intel.com>
 <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
 <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com>
 <20180926204400.GA11446@linux.intel.com>
 <b7e14c6e-fc05-93fa-eef9-5e3f06ab4729@intel.com>
 <CALCETrXByb2UVuZ6AXUeOd8y90NAikbZuvdN3wf_TjHZ+CxNhA@mail.gmail.com>
 <992b1d6d-cc0f-776f-d938-2a1f7cad52c8@intel.com>
 <20180927135603.GF8242@linux.intel.com>
 <ae76dfe7-3587-0d21-37b7-535279edc235@fortanix.com>
 <2e7b81e1-818f-7d76-e2b4-793d9ec5d5a6@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <2e7b81e1-818f-7d76-e2b4-793d9ec5d5a6@intel.com>
Return-Path: sean.j.christopherson@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Oct 01, 2018 at 03:03:30PM -0700, Dave Hansen wrote:
> On 10/01/2018 02:42 PM, Jethro Beekman wrote:
> > 
> > 1) Even though the vDSO function exists, userspace may still call 
> > `ENCLU[EENTER]` manually, so the fault handling as described in the 
> > current patch should also be maintained.
> 
> Why?

Circling back to this question, what if we take the easy way out and
simply signal SIGSEGV without an SGX-specific code?  I.e. treat #PF
with X86_PF_SGX as an access error, no more no less.  That should be
sufficient for userspace to function, albeit with a little more effort,
but presumably no more than would be needed to run on SGX1 hardware.

AFAIK there isn't a way to prevent userspace from manually invoking
EENTER, short of doing some really nasty text poking or PTE swizzling.
We could declare using EENTER as unsupported, but that seems like
cutting off the nose to spite the face.  Supporting userspace EENTER
in a limited capacity would allow people to do whatever crazy tricks
they're wont to do without having to deal with absurd requests for
the vDSO interface.

If we go this route we could also add the vDSO stuff after basic SGX
support is in mainline, obviously with approval from the powers that
be.
