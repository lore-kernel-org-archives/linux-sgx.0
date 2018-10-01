Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/
 PF_SGX
To: Jethro Beekman <jethro@fortanix.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com>
 <CALCETrVAhiwv+g5fzVO3ZSHZgcQKbeeG8r3HUcXO9k7Gi94NdQ@mail.gmail.com>
 <20180926173516.GA10920@linux.intel.com>
 <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
 <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com>
 <20180926204400.GA11446@linux.intel.com>
 <b7e14c6e-fc05-93fa-eef9-5e3f06ab4729@intel.com>
 <CALCETrXByb2UVuZ6AXUeOd8y90NAikbZuvdN3wf_TjHZ+CxNhA@mail.gmail.com>
 <992b1d6d-cc0f-776f-d938-2a1f7cad52c8@intel.com>
 <20180927135603.GF8242@linux.intel.com>
 <ae76dfe7-3587-0d21-37b7-535279edc235@fortanix.com>
CC: Andy Lutomirski <luto@amacapital.net>, "Christopherson, Sean J"
	<sean.j.christopherson@intel.com>, Andrew Lutomirski <luto@kernel.org>, "X86
 ML" <x86@kernel.org>, Platform Driver <platform-driver-x86@vger.kernel.org>,
	"nhorman@redhat.com" <nhorman@redhat.com>, "npmccallum@redhat.com"
	<npmccallum@redhat.com>, "Ayoun, Serge" <serge.ayoun@intel.com>,
	"shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
	"Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <2e7b81e1-818f-7d76-e2b4-793d9ec5d5a6@intel.com>
Date: Mon, 1 Oct 2018 15:03:30 -0700
In-Reply-To: <ae76dfe7-3587-0d21-37b7-535279edc235@fortanix.com>
Content-Type: text/plain; charset="utf-8"
Return-Path: dave.hansen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 10/01/2018 02:42 PM, Jethro Beekman wrote:
> 
> 1) Even though the vDSO function exists, userspace may still call 
> `ENCLU[EENTER]` manually, so the fault handling as described in the 
> current patch should also be maintained.

Why?
