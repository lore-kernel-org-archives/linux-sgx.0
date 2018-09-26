Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/
 PF_SGX
To: Sean Christopherson <sean.j.christopherson@intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com>
 <CALCETrVAhiwv+g5fzVO3ZSHZgcQKbeeG8r3HUcXO9k7Gi94NdQ@mail.gmail.com>
 <20180926173516.GA10920@linux.intel.com>
 <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
 <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com>
 <20180926204400.GA11446@linux.intel.com>
CC: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, X86 ML <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, "Ayoun, Serge" <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <b7e14c6e-fc05-93fa-eef9-5e3f06ab4729@intel.com>
Date: Wed, 26 Sep 2018 13:49:35 -0700
In-Reply-To: <20180926204400.GA11446@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Return-Path: dave.hansen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 09/26/2018 01:44 PM, Sean Christopherson wrote:
> On Wed, Sep 26, 2018 at 01:16:59PM -0700, Dave Hansen wrote:
>> We also need to clarify how this can happen.  Is it through something
>> than an app does, or is it solely when the hardware does something under
>> the covers, like suspend/resume.
> 
> Are you looking for something in the changelog, the comment, or just
> a response?  If it's the latter...

Comments, please.

> On bare metal with a bug-free kernel, the only scenario I'm aware of
> where we'll encounter these faults is when hardware pulls the rug out
> from under us.  In a virtualized environment all bets are off because
> the architecture allows VMMs to silently "destroy" the EPC at will,
> e.g. KVM, and I believe Hyper-V, will take advantage of this behavior
> to support live migration.  Post migration, the destination system
> will generate PF_SGX because the EPC{M} can't be migrated between
> system, i.e. the destination EPCM sees all EPC pages as invalid.

OK, cool.

That's good background fodder for the changelog.

But, for the comment, I'm happy with something like this:

	/*
	 * The fault resulted from violation of SGX-specific access-
	 * controls.  This is expected to be the result of some lower
	 * layer action (CPU suspend/resume, VM migration) and is
	 * not related to anything the OS did.  Treat it as an access
	 * error to ensure it is passed up to the app via a signal where
	 * it can be handled.
	 */

I really don't think we need to delve too deeply into the relationship
between EPCM and PTEs or anything.  Let's just say, "it's not the
kernel's fault, it's not the app's fault, so throw up our hands".
