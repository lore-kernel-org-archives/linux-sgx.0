Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/
 PF_SGX
To: Sean Christopherson <sean.j.christopherson@intel.com>
CC: Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>,
	Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, "nhorman@redhat.com"
	<nhorman@redhat.com>, "npmccallum@redhat.com" <npmccallum@redhat.com>,
	"Ayoun, Serge" <serge.ayoun@intel.com>, "shay.katz-zamir@intel.com"
	<shay.katz-zamir@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
	"Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>
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
 <20181031213036.GA23089@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <a9c23203-476d-875d-9fbb-263716833e17@intel.com>
Date: Wed, 31 Oct 2018 14:35:34 -0700
In-Reply-To: <20181031213036.GA23089@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Return-Path: dave.hansen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 10/31/18 2:30 PM, Sean Christopherson wrote:
> On Mon, Oct 01, 2018 at 03:03:30PM -0700, Dave Hansen wrote:
>> On 10/01/2018 02:42 PM, Jethro Beekman wrote:
>>>
>>> 1) Even though the vDSO function exists, userspace may still call 
>>> `ENCLU[EENTER]` manually, so the fault handling as described in the 
>>> current patch should also be maintained.
>>
>> Why?
> 
> Circling back to this question, what if we take the easy way out and
> simply signal SIGSEGV without an SGX-specific code?  I.e. treat #PF
> with X86_PF_SGX as an access error, no more no less.  That should be
> sufficient for userspace to function, albeit with a little more effort,
> but presumably no more than would be needed to run on SGX1 hardware.

There are two sides to this ABI: what the kernel does to support SGX and
what userspace does.  If we do what you suggest, we remove any (most?)
needed kernel changes and foist the burden entirely into userspace.
But, we end up with two ABIs: the old one and the new vDSO one.

IOW, once we start doing SIGSEGV, we have to do it forever, despite if
we have a newer mechanism.

> AFAIK there isn't a way to prevent userspace from manually invoking
> EENTER, short of doing some really nasty text poking or PTE swizzling.
> We could declare using EENTER as unsupported,

Yep, userspace can call it all it wants, and we can also say that
calling it outside the vdso is "undefined".
