Date: Thu, 27 Sep 2018 17:21:58 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Dave Hansen <dave.hansen@intel.com>, "Christopherson, Sean J"
	<sean.j.christopherson@intel.com>, Andrew Lutomirski <luto@kernel.org>, "X86
 ML" <x86@kernel.org>, Platform Driver <platform-driver-x86@vger.kernel.org>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>,
	<linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
	"Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs
 w/ PF_SGX
Message-ID: <20180927142158.GG8242@linux.intel.com>
References: <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com>
 <CALCETrVAhiwv+g5fzVO3ZSHZgcQKbeeG8r3HUcXO9k7Gi94NdQ@mail.gmail.com>
 <20180926173516.GA10920@linux.intel.com>
 <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
 <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com>
 <20180926204400.GA11446@linux.intel.com>
 <b7e14c6e-fc05-93fa-eef9-5e3f06ab4729@intel.com>
 <CALCETrXByb2UVuZ6AXUeOd8y90NAikbZuvdN3wf_TjHZ+CxNhA@mail.gmail.com>
 <992b1d6d-cc0f-776f-d938-2a1f7cad52c8@intel.com>
 <CALCETrXyjRh1sBk1V21iTtjdhiWGCYsHnUNktkJC5xFiZy6c9A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CALCETrXyjRh1sBk1V21iTtjdhiWGCYsHnUNktkJC5xFiZy6c9A@mail.gmail.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Wed, Sep 26, 2018 at 03:37:45PM -0700, Andy Lutomirski wrote:
> Yeah.  Maybe like this: > > xorl %eax,%eax > eenter_insn:
> ENCLU[whatever]
> eenter_landing_pad:
> ret
> 
> And the kernel would use the existing vdso2c vdso-symbol-finding
> mechanism to do the fixup.
> 
> >
> > How would a syscall work, though?  I assume we can't just enter the
> > enclave from ring0.
> 
> My understanding of how AEX works is a bit vague, but maybe a syscall
> could reuse the mechanism?  The vDSO approach seems considerably
> simpler.
> 
> We do need to make sure that a fault that happens on or after return
> from an AEX event does the right thing.  But I'm still vague on how
> that works, sigh.
> 
> --Andy

Returning from AEX does not differ from any other memory access event so
AFAIK it should be handled right with the proposed solution already.
For convenience I think we could have a fixed trampoline for AEX e.g.
this how it is implemented in the open source LE that I did:

sgx_get_token:
	push	%rbx
	mov	$0x02, %rax
	mov	%rsi, %rbx
	mov	%rdx, %rsi
	mov	$sgx_async_exit, %rcx
sgx_async_exit:
	ENCLU
	pop	%rbx
	ret

BTW, if I converted the in-kernel LE as a standalone test program, would
that be useful for basic testing of the series?

/Jarkko
