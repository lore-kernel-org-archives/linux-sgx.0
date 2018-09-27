Date: Thu, 27 Sep 2018 16:16:42 +0300
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
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>,
	"He Chen" <he.chen@linux.intel.com>, Luwei Kang <luwei.kang@intel.com>,
	<kvm@vger.kernel.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Piotr Luc <Piotr.Luc@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v14 04/19] x86/cpufeatures: Add SGX feature bits
Message-ID: <20180927131642.GE5436@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-5-jarkko.sakkinen@linux.intel.com>
 <20180925164854.GF23986@zn.tnic>
 <20180926111139.GA12037@linux.intel.com>
 <20180926113617.GD5584@zn.tnic>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180926113617.GD5584@zn.tnic>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Wed, Sep 26, 2018 at 01:36:17PM +0200, Borislav Petkov wrote:
> On Wed, Sep 26, 2018 at 02:11:39PM +0300, Jarkko Sakkinen wrote:
> > Thank you. I guess I understand what you want me to do i.e.
> > 
> > +       { X86_FEATURE_SGX1,             CPUID_EAX,  0, 0x00000012, 0 },
> > +       { X86_FEATURE_SGX2,             CPUID_EAX,  1, 0x00000012, 0 },
> > +       { X86_FEATURE_ENCLV,            CPUID_EAX,  5, 0x00000012, 0 },
> > +       { X86_FEATURE_ENCLS_C,          CPUID_EAX,  6, 0x00000012, 0 },
> 
> Yap.
> 
> > What puzzles me is that I cannot find any call site for
> > get_scattered_cpuid_leaf():
> > 
> > $ git grep get_scattered
> > arch/x86/kernel/cpu/cpu.h:extern u32 get_scattered_cpuid_leaf(unsigned int level,
> > arch/x86/kernel/cpu/scattered.c:u32 get_scattered_cpuid_leaf(unsigned int level, unsigned int sub_leaf,
> > arch/x86/kernel/cpu/scattered.c:EXPORT_SYMBOL_GPL(get_scattered_cpuid_leaf);
> 
> That used to be used in kvm last, see b7b27aa011a1df42728d1768fc181d9ce69e6911,
> which removed it.
> 
> And it got added by
> 
>   47bdf3378d62 ("x86/cpuid: Provide get_scattered_cpuid_leaf()")
> 
> Lemme add those people to CC.
> 
> If no one wants it, feel free to decomission it.

Still kind of leaves me puzzled about the situation :-) Why this wasn't
used for example to replace detect_vmx_virtcap()?

/Jarkko
