Date: Tue, 3 Jul 2018 20:54:56 +0200
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?=
	<rkrcmar@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov
	<bp@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Alexei
 Starovoitov" <ast@kernel.org>, David Woodhouse <dwmw@amazon.co.uk>, Andi
 Kleen <ak@linux.intel.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	"Tom Lendacky" <thomas.lendacky@amd.com>, Janakarajan Natarajan
	<Janakarajan.Natarajan@amd.com>, Andy Lutomirski <luto@kernel.org>, "Ricardo
 Neri" <ricardo.neri-calderon@linux.intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <linux-kernel@vger.kernel.org>, "open list:KERNEL VIRTUAL MACHINE
 FOR X86 (KVM/x86)" <kvm@vger.kernel.org>
Subject: Re: [PATCH v12 04/13] x86/cpufeatures: add Intel-defined SGX leaf
 CPUID_12_EAX
In-Reply-To: <20180703182118.15024-5-jarkko.sakkinen@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1807032051510.1816@nanos.tec.linutronix.de>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com> <20180703182118.15024-5-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="US-ASCII"
Return-Path: tglx@linutronix.de
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:

> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> CPUID_12_EAX is an Intel-defined feature bits leaf dedicated for SGX.
> There are currently four documented feature bits, with more expected in
> the not-too-distant future.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Lacks SOB

Thanks,

	tglx
