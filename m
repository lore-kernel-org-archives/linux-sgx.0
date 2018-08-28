Date: Tue, 28 Aug 2018 11:11:23 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Haim Cohen
	<haim.cohen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
	<bp@suse.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, "David
 Woodhouse" <dwmw@amazon.co.uk>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Janakarajan Natarajan
	<Janakarajan.Natarajan@amd.com>, Matt Turner <mattst88@gmail.com>, "Andy
 Lutomirski" <luto@kernel.org>, "open list:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 05/13] x86/msr: Add SGX definitions to msr-index.h
Message-ID: <20180828081123.GF15508@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-6-jarkko.sakkinen@linux.intel.com>
 <c4c85a47-6de4-1171-4fd5-4a4bdd4d31db@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <c4c85a47-6de4-1171-4fd5-4a4bdd4d31db@intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Aug 27, 2018 at 12:42:32PM -0700, Dave Hansen wrote:
> On 08/27/2018 11:53 AM, Jarkko Sakkinen wrote:
> > @@ -866,10 +867,9 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
> >  		}
> >  	}
> >  
> > -	/* Intel SGX features: level 0x00000012 */
> > -	if (c->cpuid_level >= 0x00000012) {
> > -		cpuid(0x00000012, &eax, &ebx, &ecx, &edx);
> > -
> > +	/* Intel SGX features */
> > +	if (c->cpuid_level >= SGX_CPUID) {
> > +		cpuid(SGX_CPUID,  &eax, &ebx, &ecx, &edx);
> >  		c->x86_capability[CPUID_12_EAX] = eax;
> >  	}
> 
> This hunk has no apparent connection to the changelog.

Thanks for catching this, the same squashing mistake :-)

/Jarkko
