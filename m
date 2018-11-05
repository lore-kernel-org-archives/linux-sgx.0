Date: Mon, 5 Nov 2018 16:35:46 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 11/23] x86/sgx: Add definitions for SGX's CPUID leaf
 and variable sub-leafs
Message-ID: <20181105143415.GA2798@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-12-jarkko.sakkinen@linux.intel.com>
 <CAHp75VcgFstv5EjY2DzsLGAimxf3Z2g-Mych1zW40txS9b7Bmg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHp75VcgFstv5EjY2DzsLGAimxf3Z2g-Mych1zW40txS9b7Bmg@mail.gmail.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Sat, Nov 03, 2018 at 03:11:39PM +0200, Andy Shevchenko wrote:
> On Sat, Nov 3, 2018 at 1:16 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > SGX defines its own CPUID leaf, 0x12, along with a variable number of
> > sub-leafs.  Sub-leafs 0 and 1 are always available if SGX is supported
> > and enumerate various SGX features, e.g. instruction sets and enclave
> > capabilities.  Sub-leafs 2+ are variable, both in their existence and
> > in what they enumerate.  Bits 3:0 of EAX report the sub-leaf type,
> > with the remaining bits in EAX, EBX, ECX and EDX being type-specific.
> > Currently, the only known sub-leaf type enumerates an EPC section.  An
> > EPC section is simply a range of EPC memory available to software.
> > The "list" of varaible SGX sub-leafs is NULL-terminated, i.e. software
> > is expected to query CPUID until an invalid sub-leaf is encountered.
> 
> > +       SGX_CPUID_SUB_LEAF_TYPE_MASK    = 0xF,
> 
> GENMASK() if it suits here?
> 
> P.S. Btw, BIT() and GENMASK() macros are now in a separate header,
> i.e. linux/bits.h, perhaps you might need to revisit code to include
> it explicitly

Agreed. I would also think that is should be renamed simply as
SGX_CPUID_SUBLEAF_MASK.

/Jarkko
