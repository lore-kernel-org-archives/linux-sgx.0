Date: Tue, 3 Jul 2018 22:44:24 +0200
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <rdunlap@infradead.org>
CC: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>, <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "open list:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 07/13] x86/sgx: data structures for tracking available
 EPC pages
In-Reply-To: <00ca61d5-5a1d-5c83-3b49-62c899a87041@infradead.org>
Message-ID: <alpine.DEB.2.21.1807032242140.1816@nanos.tec.linutronix.de>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com> <20180703182118.15024-8-jarkko.sakkinen@linux.intel.com> <alpine.DEB.2.21.1807032110460.1816@nanos.tec.linutronix.de> <00ca61d5-5a1d-5c83-3b49-62c899a87041@infradead.org>
Content-Type: text/plain; charset="US-ASCII"
Return-Path: tglx@linutronix.de
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, 3 Jul 2018, Randy Dunlap wrote:
> On 07/03/18 12:46, Thomas Gleixner wrote:
> > On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:
> > 
> >> SGX has a set of data structures to maintain information about the enclaves
> >> and their security properties. BIOS reserves a fixed size region of
> >> physical memory for these structures by setting Processor Reserved Memory
> >> Range Registers (PRMRR). This memory area is called Enclave Page Cache
> >> (EPC).
> >>
> >> This commit adds a database of EPC banks for kernel to easily access the
> 
> what kind of database?  How does one query it?
> 
> >> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> >> index 2130e639ab49..77b2294fcfb0 100644
> >> --- a/arch/x86/include/asm/sgx.h
> >> +++ b/arch/x86/include/asm/sgx.h
> 
> 
> >> +/**
> >> + * sgx_get_page - pin an EPC page
> > 
> > Description starts with an uppercase letter.
> 
> How would someone know that?  It's not documented anywhere.

It's a short sentence decribing the function and sentences start usually
with uppercase letters, right?

> I happen to disagree with it.

Then we have to agree that we disagree.

> >> +static __init int sgx_page_cache_init(void)
> >> +{
> >> +	unsigned long size;
> >> +	unsigned int eax;
> >> +	unsigned int ebx;
> >> +	unsigned int ecx;
> >> +	unsigned int edx;
> >> +	unsigned long pa;
> >> +	int i;
> >> +	int ret;
> > 
> > Please aggregate the declarations of the same type. No point in wasting all
> > the screen space. And please use 'u32' for ea-dx
> > 
> >> +
> >> +	for (i = 0; i < SGX_MAX_EPC_BANKS; i++) {
> >> +		cpuid_count(SGX_CPUID, i + SGX_CPUID_EPC_BANKS, &eax, &ebx,
> >> +			    &ecx, &edx);
> >> +		if (!(eax & 0xf))
> >> +			break;
> >> +
> >> +		pa = ((u64)(ebx & 0xfffff) << 32) + (u64)(eax & 0xfffff000);
> >> +		size = ((u64)(edx & 0xfffff) << 32) + (u64)(ecx & 0xfffff000);
> > 
> > These magic constants should be 'U', using uppercase 'F' and defines. Plus
> > this wants a comment how pa and size are cobbled together from the cpuid
> > regs.
> 
> Why the uppercase 'F'?

Makes is more readable IMO, but I'm not religious about that.

Thanks,

	tglx
