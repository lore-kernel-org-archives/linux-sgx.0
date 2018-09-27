Date: Thu, 27 Sep 2018 16:42:23 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Andy Lutomirski <luto@amacapital.net>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Andy Lutomirski <luto@kernel.org>, X86 ML
	<x86@kernel.org>, Platform Driver <platform-driver-x86@vger.kernel.org>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>,
	<linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs
 w/ PF_SGX
Message-ID: <20180927134223.GA8242@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com>
 <CALCETrVAhiwv+g5fzVO3ZSHZgcQKbeeG8r3HUcXO9k7Gi94NdQ@mail.gmail.com>
 <20180926173516.GA10920@linux.intel.com>
 <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
 <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Wed, Sep 26, 2018 at 01:16:59PM -0700, Dave Hansen wrote:
> On 09/26/2018 11:12 AM, Andy Lutomirski wrote:
> >> e omniscient.
> >>
> >> How about this?  With formatting changes since it's long-winded...
> >>
> >>        /*
> >>         * Access is blocked by the Enclave Page Cache Map (EPCM), i.e. the
> >>         * access is allowed by the PTE but not the EPCM.  This usually happens
> >>         * when the EPCM is yanked out from under us, e.g. by hardware after a
> >>         * suspend/resume cycle.  In any case, software, i.e. the kernel, can't
> >>         * fix the source of the fault as the EPCM can't be directly modified
> >>         * by software.  Handle the fault as an access error in order to signal
> >>         * userspace, e.g. so that userspace can rebuild their enclave(s), even
> >>         * though userspace may not have actually violated access permissions.
> >>         */
> >>
> > Looks good to me.
> 
> Including the actual architectural definition of the bit might add some
> clarity.  The SDM explicitly says (Vol 3a section 4.7):
> 
> 	The fault resulted from violation of SGX-specific access-control
> 	requirements.
> 
> Which totally squares with returning true from access_error().
> 
> There's also a tidbit that says:
> 
> 	This flag is 1 if the exception is unrelated to paging and
> 	resulted from violation of SGX-specific access-control
> 	requirements. ... such a violation can occur only if there
> 	is no ordinary page fault...
> 
> This is pretty important.  It means that *none* of the other
> paging-related stuff that we're doing applies.
> 
> We also need to clarify how this can happen.  Is it through something
> than an app does, or is it solely when the hardware does something under
> the covers, like suspend/resume.

When you change page permissions lets say with mprotect after the and
try to do an invalid access according to the EPCM permissions this can
happen.

/Jarkko
