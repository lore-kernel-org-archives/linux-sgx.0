Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/
 PF_SGX
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com>
 <CALCETrVAhiwv+g5fzVO3ZSHZgcQKbeeG8r3HUcXO9k7Gi94NdQ@mail.gmail.com>
 <20180926173516.GA10920@linux.intel.com>
 <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
 <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com>
 <20180927134223.GA8242@linux.intel.com>
CC: Andy Lutomirski <luto@amacapital.net>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Andy Lutomirski <luto@kernel.org>, X86 ML
	<x86@kernel.org>, Platform Driver <platform-driver-x86@vger.kernel.org>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>,
	<linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
	"Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <d0e47333-18b9-51c3-7d79-f27d6005f24f@intel.com>
Date: Thu, 27 Sep 2018 07:58:41 -0700
In-Reply-To: <20180927134223.GA8242@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 09/27/2018 06:42 AM, Jarkko Sakkinen wrote:
>> 	This flag is 1 if the exception is unrelated to paging and
>> 	resulted from violation of SGX-specific access-control
>> 	requirements. ... such a violation can occur only if there
>> 	is no ordinary page fault...
>>
>> This is pretty important.  It means that *none* of the other
>> paging-related stuff that we're doing applies.
>>
>> We also need to clarify how this can happen.  Is it through something
>> than an app does, or is it solely when the hardware does something under
>> the covers, like suspend/resume.
> When you change page permissions lets say with mprotect after the and
> try to do an invalid access according to the EPCM permissions this can
> happen.

So, there are pages that are non-executable, non-readable, or
non-writable both via the page tables and via underlying SGX
permissions.  Then, we allow an mprotect() and a later access will
result in one of these SGX faults?

What permissions are these, exactly?  Is it even a good idea to let that
mprotect() go through in the first place?

Either way, it sounds like we have some new conditions to spell out in
that comment.
