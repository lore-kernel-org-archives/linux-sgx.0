References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-16-jarkko.sakkinen@linux.intel.com> <CAHp75VdhSwy8zzf64PZnHhZVikJEzasu-=a+UOz4cLAxEJW-YA@mail.gmail.com>
 <20181105173038.GD4502@linux.intel.com>
In-Reply-To: <20181105173038.GD4502@linux.intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 5 Nov 2018 22:39:46 +0200
Message-ID: <CAHp75Vfa2jvjOtvERB_Td1zCrfKyJp24Prd+foYz02kUCjNr-g@mail.gmail.com>
Subject: Re: [PATCH v15 15/23] x86/sgx: Add wrappers for ENCLS leaf functions
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, <suresh.b.siddha@intel.com>, "Linux Kernel Mailing
 List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Return-Path: andy.shevchenko@gmail.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Nov 5, 2018 at 7:30 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Sat, Nov 03, 2018 at 03:17:35PM +0200, Andy Shevchenko wrote:
> > On Sat, Nov 3, 2018 at 1:18 AM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > ENCLS is an umbrella instruction for a variety of cpl0 SGX functions.
> > > The ENCLS function that is executed is specified in EAX, with each
> > > function potentially having more leaf-specific operands beyond EAX.
> > > ENCLS introduces its own (positive value) error codes that (some)
> > > leafs use to return failure information in EAX.  Leafs that return
> > > an error code also modify RFLAGS.  And finally, ENCLS generates
> > > ENCLS-specific non-fatal #GPs and #PFs, i.e. a bug-free kernel may
> > > encounter faults on ENCLS that must be handled gracefully.
> > >
> > > Because of the complexity involved in encoding ENCLS and handling its
> > > assortment of failure paths, executing any given leaf is not a simple
> > > matter of emitting ENCLS.
> > >
> > > To enable adding support for ENCLS leafs with minimal fuss, add a
> > > two-layer macro system along with an encoding scheme to allow wrappers
> > > to return trap numbers along ENCLS-specific error codes.  The bottom
> > > layer of the macro system splits between the leafs that return an
> > > error code and those that do not.  The second layer generates the
> > > correct input/output annotations based on the number of operands for
> > > each leaf function.
> >
> > > +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> >
> > > +/**
> >
> > I dunno if kernel-doc script still complains about this.
>
> Is there a way to ask for make htmldocs to do only a subset of docs?
> Still kind of trying to figure out what would be  a good flow for
> working with Sphinx.

What I'm telling here is about Copyright notice, which in my
understanding is not a part of kernel-doc formatting. Though I might
be mistaken.
I remember some USB code has that and I saw a warning.

-- 
With Best Regards,
Andy Shevchenko
