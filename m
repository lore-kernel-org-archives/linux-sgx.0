Date: Wed, 4 Jul 2018 06:25:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>, <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "open list:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 09/13] x86/sgx: EPC page allocation routines
Message-ID: <20180704042516.GA20409@zn.tnic>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-10-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.21.1807032216390.1816@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <alpine.DEB.2.21.1807032216390.1816@nanos.tec.linutronix.de>
Return-Path: bp@alien8.de
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Jul 03, 2018 at 10:41:14PM +0200, Thomas Gleixner wrote:
> On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:
> >  
> > +#define SGX_NR_TO_SCAN	16
> > +#define SGX_NR_LOW_PAGES 32
> > +#define SGX_NR_HIGH_PAGES 64
> > +
> >  bool sgx_enabled __ro_after_init;
> >  EXPORT_SYMBOL(sgx_enabled);
> >  bool sgx_lc_enabled __ro_after_init;
> >  EXPORT_SYMBOL(sgx_lc_enabled);
> > +LIST_HEAD(sgx_active_page_list);
> > +EXPORT_SYMBOL(sgx_active_page_list);
> > +DEFINE_SPINLOCK(sgx_active_page_list_lock);
> > +EXPORT_SYMBOL(sgx_active_page_list_lock);
> 
> Why is all of this exported. If done right then no call site has to fiddle
> with the list and the lock at all.

... and also, why are the other exports not EXPORT_SYMBOL_GPL?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
