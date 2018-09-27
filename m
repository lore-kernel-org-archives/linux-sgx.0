Date: Thu, 27 Sep 2018 17:52:38 +0300
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
Message-ID: <20180927145238.GA9769@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-5-jarkko.sakkinen@linux.intel.com>
 <20180925164854.GF23986@zn.tnic>
 <20180926111139.GA12037@linux.intel.com>
 <20180926113617.GD5584@zn.tnic>
 <20180927131642.GE5436@linux.intel.com>
 <20180927135139.GB19687@zn.tnic>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180927135139.GB19687@zn.tnic>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Thu, Sep 27, 2018 at 03:51:39PM +0200, Borislav Petkov wrote:
> On Thu, Sep 27, 2018 at 04:16:42PM +0300, Jarkko Sakkinen wrote:
> > Still kind of leaves me puzzled about the situation :-) Why this wasn't
> > used for example to replace detect_vmx_virtcap()?
> 
> I don't understand - detect_vmx_virtcap() is setting X86_FEATURE bits
> based on MSR settings. get_scattered_cpuid_leaf() is regenerating a
> CPUID leaf from the scattered bits.
> 
> Looks like apples and oranges to me...
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Good mailing practices for 400: avoid top-posting and trim the reply.

Ugh, sorry, I was not thinking clearly :-)

/Jarkko
