Date: Wed, 26 Sep 2018 14:11:39 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, David Woodhouse
	<dwmw@amazon.co.uk>, David Wang <davidwang@zhaoxin.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, "Levin, Alexander (Sasha Levin)"
	<alexander.levin@verizon.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 04/19] x86/cpufeatures: Add SGX feature bits
Message-ID: <20180926111139.GA12037@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-5-jarkko.sakkinen@linux.intel.com>
 <20180925164854.GF23986@zn.tnic>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180925164854.GF23986@zn.tnic>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Sep 25, 2018 at 06:48:54PM +0200, Borislav Petkov wrote:
> > +	eax = cpuid_eax(SGX_CPUID);
> > +
> > +	if (eax & _X86_FEATURE_SGX1)
> > +		set_cpu_cap(c, X86_FEATURE_SGX1);
> > +
> > +	if (eax & _X86_FEATURE_SGX2)
> > +		set_cpu_cap(c, X86_FEATURE_SGX2);
> > +
> > +	if (eax & _X86_FEATURE_SGX_ENCLV)
> > +		set_cpu_cap(c, X86_FEATURE_SGX_ENCLV);
> > +
> > +	if (eax & _X86_FEATURE_SGX_ENCLS_C)
> > +		set_cpu_cap(c, X86_FEATURE_SGX_ENCLS_C);
> 
> 
> Look at arch/x86/kernel/cpu/scattered.c for how to do this properly.

Thank you. I guess I understand what you want me to do i.e.

+       { X86_FEATURE_SGX1,             CPUID_EAX,  0, 0x00000012, 0 },
+       { X86_FEATURE_SGX2,             CPUID_EAX,  1, 0x00000012, 0 },
+       { X86_FEATURE_ENCLV,            CPUID_EAX,  5, 0x00000012, 0 },
+       { X86_FEATURE_ENCLS_C,          CPUID_EAX,  6, 0x00000012, 0 },

What puzzles me is that I cannot find any call site for
get_scattered_cpuid_leaf():

$ git grep get_scattered
arch/x86/kernel/cpu/cpu.h:extern u32 get_scattered_cpuid_leaf(unsigned int level,
arch/x86/kernel/cpu/scattered.c:u32 get_scattered_cpuid_leaf(unsigned int level, unsigned int sub_leaf,
arch/x86/kernel/cpu/scattered.c:EXPORT_SYMBOL_GPL(get_scattered_cpuid_leaf);

/Jarkko
