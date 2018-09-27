Date: Thu, 27 Sep 2018 16:13:00 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Reinette
 Chatre" <reinette.chatre@intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 10/19] x86/sgx: Detect Intel SGX
Message-ID: <20180927131300.GC5436@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-11-jarkko.sakkinen@linux.intel.com>
 <7ea823ce-d6ee-1ff0-efb4-3ca93536fb7e@infradead.org>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <7ea823ce-d6ee-1ff0-efb4-3ca93536fb7e@infradead.org>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Sep 25, 2018 at 01:02:14PM -0700, Randy Dunlap wrote:
> On 9/25/18 6:06 AM, Jarkko Sakkinen wrote:
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 1a0be022f91d..b47e1a144409 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1913,6 +1913,23 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
> >  
> >  	  If unsure, say y.
> >  
> > +config INTEL_SGX_CORE
> > +	bool "Intel SGX core functionality"
> > +	depends on X86_64 && CPU_SUP_INTEL
> > +	help
> > +	Intel Software Guard eXtensions (SGX) CPU feature that allows ring 3
> > +	applications to create enclaves: private regions of memory that are
> > +	architecturally protected from unauthorized access and/or modification.
> > +
> > +	This option enables kernel recognition of SGX, high-level management
> > +	of the Enclave Page Cache (EPC), tracking and writing of SGX Launch
> > +	Enclave Hash MSRs, and allows for virtualization of SGX via KVM. By
> > +	itself, this option does not provide SGX support to userspace.
> > +
> > +	For details, see Documentation/x86/intel_sgx.rst
> > +
> > +	If unsure, say N.
> > +
> 
> Hi,
> coding-style.rst says that help text should be indented with
> one tab + 2 spaces.
> 
> thanks.

Thank you.

/Jarkko
