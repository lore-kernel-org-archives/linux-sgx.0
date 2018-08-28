Date: Tue, 28 Aug 2018 10:23:55 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim
 =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Borislav Petkov <bp@suse.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, David Woodhouse <dwmw@amazon.co.uk>, "Alexei
 Starovoitov" <ast@kernel.org>, Andi Kleen <ak@linux.intel.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Ricardo Neri
	<ricardo.neri-calderon@linux.intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>,
	"open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" <kvm@vger.kernel.org>
Subject: Re: [PATCH v13 03/13] x86/cpufeatures: Add Intel-defined SGX leaf
 CPUID_12_EAX
Message-ID: <20180828072355.GB15508@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-4-jarkko.sakkinen@linux.intel.com>
 <70dec13f-2182-e4d6-da71-a568d6e9354b@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <70dec13f-2182-e4d6-da71-a568d6e9354b@intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Aug 27, 2018 at 12:39:36PM -0700, Dave Hansen wrote:
> On 08/27/2018 11:53 AM, Jarkko Sakkinen wrote:
> > +	/* Intel SGX features: level 0x00000012 */
> > +	if (c->cpuid_level >= 0x00000012) {
> > +		cpuid(0x00000012, &eax, &ebx, &ecx, &edx);
> > +
> > +		c->x86_capability[CPUID_12_EAX] = eax;
> > +	}
> 
> I've given this specific bit of feedback at least once in the past.
> These patches are not ordered properly.  You introduce this in the next
> patch:
> 
> +#define SGX_CPUID 0x12

Yeah, my mistake probably when squashing fixups.

/Jarkko
