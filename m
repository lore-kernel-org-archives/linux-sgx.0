Date: Wed, 4 Jul 2018 20:27:23 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?=
	<rkrcmar@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov
	<bp@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Alexei
 Starovoitov" <ast@kernel.org>, David Woodhouse <dwmw@amazon.co.uk>, "Andi
 Kleen" <ak@linux.intel.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, Janakarajan Natarajan
	<Janakarajan.Natarajan@amd.com>, Andy Lutomirski <luto@kernel.org>, "Ricardo
 Neri" <ricardo.neri-calderon@linux.intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <linux-kernel@vger.kernel.org>, "open list:KERNEL VIRTUAL MACHINE
 FOR X86 (KVM/x86)" <kvm@vger.kernel.org>
Subject: Re: [PATCH v12 04/13] x86/cpufeatures: add Intel-defined SGX leaf
 CPUID_12_EAX
Message-ID: <20180704172723.GG6724@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-5-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.21.1807032051510.1816@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.21.1807032051510.1816@nanos.tec.linutronix.de>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Jul 03, 2018 at 08:54:56PM +0200, Thomas Gleixner wrote:
> On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:
> 
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > CPUID_12_EAX is an Intel-defined feature bits leaf dedicated for SGX.
> > There are currently four documented feature bits, with more expected in
> > the not-too-distant future.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Lacks SOB
> 
> Thanks,
> 
> 	tglx

Thanks, will refine!

/Jarkko
