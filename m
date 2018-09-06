Date: Thu, 6 Sep 2018 12:21:00 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>, Dave Hansen
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>,
	<suresh.b.siddha@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Darren Hart
	<dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, "Linux
 Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 11/13] platform/x86: Intel SGX driver
Message-ID: <20180906092100.GA27302@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-12-jarkko.sakkinen@linux.intel.com>
 <CAHp75VcqKunkHYNdd287_F7APHwYr7K9QD2PVCkqBqJWG2_E-g@mail.gmail.com>
 <20180905173355.GE11368@linux.intel.com>
 <CAHp75Vc2SZUfRnBPZ9xJ_B=KJL7yK9hqRZiFOTswn0AzjnLD1A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHp75Vc2SZUfRnBPZ9xJ_B=KJL7yK9hqRZiFOTswn0AzjnLD1A@mail.gmail.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Wed, Sep 05, 2018 at 08:36:54PM +0300, Andy Shevchenko wrote:
> On Wed, Sep 5, 2018 at 8:34 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > On Tue, Sep 04, 2018 at 08:59:58PM +0300, Andy Shevchenko wrote:
> > > On Mon, Aug 27, 2018 at 9:58 PM Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:
> 
> > Thanks, very detailed! Does not make sense to ack these separately so I
> > just say that I try to fix them all with care.
> 
> Just comment on which you disagree.
> I think one of them is the header file location. It seems I missed
> it's current place.
> 
> -- 
> With Best Regards,
> Andy Shevchenko

Ah, right, sorry forgot to comment it in LKML.

There is another open. If I grep through the kernel tree I see SPDX
headers that are decorated both with C99- and C89-style comments. I
guess I ended up using C99-style because when I was instructed to add
SPDX headers in the first place that was the example I was given. Still
checkpatch.pl complains about C99-style comments.

Which one is right and why the kernel tree is polluted with C99-headers
when they do not pass checkpatch.pl? How those commits were ever
accepted?

/Jarkko
