Date: Tue, 6 Nov 2018 08:20:02 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, <andriy.shevchenko@linux.intel.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open
 list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 23/23] x86/sgx: Driver documentation
Message-ID: <20181106062002.GA18360@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
 <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
 <20181106054911.GA15575@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20181106054911.GA15575@linux.intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Nov 06, 2018 at 07:49:11AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 05, 2018 at 12:27:11PM -0800, Dave Hansen wrote:
> > The ABI seems entirely undocumented and rather lightly designed, which
> > seems like something we should fix before this is merged.
> 
> ABI is documented in arch/x86/include/uapi/asm/sgx.h that from which the
> documentation is included to intel_sgx.rst. I'm not saying that there is
> no space refine it but it is neither undocumented.
> 
> > Also, for a feature as massive and complicated as this one, it seems
> > irresponsible to not have a selftest.  Is that not feasible for some reason?
> 
> I do have the in-kernel launch enclave stuff backed up here:
> 
> https://github.com/jsakkine-intel/sgx-le-host
> https://github.com/jsakkine-intel/sgx-le
> 
> This is about as simple as it gets without any type of run-time.

Of course the enclave could be simplified considerably since now it has
full code for EINITTOKEN generation, which is probably an overkill for a
selftest.

It could be simple as just enter and return to and from enclave or
something in-between in terms of complexity.

Even for the simplest enclave you need a signing tool (see sgxsign.c in
my sgx-le repository), a custom linker script and a sophisticated
makefile.

/Jarkko
