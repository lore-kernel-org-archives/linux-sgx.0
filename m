Date: Tue, 4 Sep 2018 14:09:52 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>, Dave Hansen
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, <serge.ayoun@intel.com>,
	<suresh.b.siddha@intel.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 08/13] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20180904110952.GD5423@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-9-jarkko.sakkinen@linux.intel.com>
 <CAHp75VdHmfx70=4jZnGZcgk5HTegDtizo7Uauk_bH43RpDXCfg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHp75VdHmfx70=4jZnGZcgk5HTegDtizo7Uauk_bH43RpDXCfg@mail.gmail.com>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Sep 03, 2018 at 06:01:26PM +0300, Andy Shevchenko wrote:
> On Mon, Aug 27, 2018 at 9:58 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > Add wrappers for Intel(R) SGX ENCLS opcode leaf functions except
> > ENCLS(EINIT). ENCLS invokes privileged functions for managing (creation,
> > initialization and swapping) and debugging enclaves.
> 
> > +#define ENCLS_FAULT_FLAG 0x40000000UL
> > +#define ENCLS_FAULT_FLAG_ASM "$0x40000000"
> 
> Hmm... Why it can't have same name?
> 
> See, how _AC() macro is defined and being used.

Thanks, we'll migrate this to use _AC().

> > +#define ENCLS_TRAPNR(r) ((r) & ~ENCLS_FAULT_FLAG)
> 
> If result of macro is assigned to some variable and (r) by some reason
> is 32-bit type
> and you compile as 64-bit object, compiler will warn here.
> Please, check this is not the case in any of use of this macro.
> Otherwise you need a type casting, like
> 
> foo = bar & (u32)~BAR;
> 
> (or using typeof() might work)

Thanks for spotting this. I will check the use of this macro.

> 
> -- 
> With Best Regards,
> Andy Shevchenko

/Jarkko
