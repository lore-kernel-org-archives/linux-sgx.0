Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/
 PF_SGX
To: Jethro Beekman <jethro@fortanix.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>
CC: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Andy Lutomirski
	<luto@amacapital.net>, Andrew Lutomirski <luto@kernel.org>, X86 ML
	<x86@kernel.org>, Platform Driver <platform-driver-x86@vger.kernel.org>,
	"nhorman@redhat.com" <nhorman@redhat.com>, "npmccallum@redhat.com"
	<npmccallum@redhat.com>, "Ayoun, Serge" <serge.ayoun@intel.com>,
	"shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
	"Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
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
 <a9c23203-476d-875d-9fbb-263716833e17@intel.com>
 <dc0f8bc8-4d69-517e-68af-abda2d51423f@fortanix.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <a6deac4e-ce8f-aa43-2d75-a04c05bac104@intel.com>
Date: Wed, 31 Oct 2018 14:58:49 -0700
In-Reply-To: <dc0f8bc8-4d69-517e-68af-abda2d51423f@fortanix.com>
Content-Type: text/plain; charset="utf-8"
Return-Path: dave.hansen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 10/31/18 2:53 PM, Jethro Beekman wrote:
> On 2018-10-31 14:35, Dave Hansen wrote:
>> On 10/31/18 2:30 PM, Sean Christopherson wrote:
>>> AFAIK there isn't a way to prevent userspace from manually invoking
>>> EENTER, short of doing some really nasty text poking or PTE swizzling.
>>> We could declare using EENTER as unsupported,
>>
>> Yep, userspace can call it all it wants, and we can also say that
>> calling it outside the vdso is "undefined".
> 
> Is there a precedent for this? Are there any other ring 3 x86
> instructions that Linux is claiming to be "undefined" when executed by a
> user process?

We did it for MPX.  "Don't use MPX unless you first tell the kernel, or
we'll eat your puppy."
