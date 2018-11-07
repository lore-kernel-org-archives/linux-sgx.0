Date: Wed, 7 Nov 2018 18:30:19 +0200
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
Message-ID: <20181107163019.GA11509@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
 <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
 <20181106054911.GA15575@linux.intel.com>
 <e7b4c432-7005-308c-4da0-a80e0d294244@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <e7b4c432-7005-308c-4da0-a80e0d294244@intel.com>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Nov 06, 2018 at 08:45:37AM -0800, Dave Hansen wrote:
> On 11/5/18 9:49 PM, Jarkko Sakkinen wrote:
> > On Mon, Nov 05, 2018 at 12:27:11PM -0800, Dave Hansen wrote:
> >> The ABI seems entirely undocumented and rather lightly designed, which
> >> seems like something we should fix before this is merged.
> > 
> > ABI is documented in arch/x86/include/uapi/asm/sgx.h that from which the
> > documentation is included to intel_sgx.rst. I'm not saying that there is
> > no space refine it but it is neither undocumented.
> 
> I specifically mean the instruction flow around asynchronous exits or
> explicit enclave exit calls via EEXIT.  Signals are part of the ABI but
> go unmentioned in the documentation.

Ok, thanks for clarification. We will document it.
> 
> It's also worth noting that EENTER *can* act (from the kernel's
> perspective) like an instruction that both jumps and sets a bunch of
> registers (including %rsp).  It's certainly abnormal in that regard.

Agreed.

> In fact, in the docs:
> 
> > +Enclave can only execute code inside the ELRANGE. Instructions that may cause
> > +VMEXIT, IO instructions and instructions that require a privilege change are
> > +prohibited inside the enclave. Interrupts and exceptions always cause enclave
> > +to exit and jump to an address outside the enclave given when the enclave is
> > +entered by using the leaf instruction ENCLS(EENTER).
> 
> it's probably a really good idea to explain that the address outside of
> the enclave is enclave-provided, and is not, for instance, just the next
> instruction after EENTER.
> 
> >> Also, for a feature as massive and complicated as this one, it seems
> >> irresponsible to not have a selftest.  Is that not feasible for some reason?
> > 
> > I do have the in-kernel launch enclave stuff backed up here:
> > 
> > https://github.com/jsakkine-intel/sgx-le-host
> > https://github.com/jsakkine-intel/sgx-le
> > 
> > This is about as simple as it gets without any type of run-time.
> 
> Does this code run when I type "make kselftest"?  If not, I think we
> should rectify that.

No, it doesn't. It is just my backup for the non-SDK user space code
that I've made that I will use to fork my user space SGX projects in
the future.

I can work-out a selftest (and provide a new patch in the series) but
I'm still wondering what the enclave should do. I would suggest that
we start with an enclave that does just EEXIT and nothing else.

/Jarkko
