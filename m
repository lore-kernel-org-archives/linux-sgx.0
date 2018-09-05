Date: Wed, 5 Sep 2018 20:32:48 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>, "maintainer:X86 ARCHITECTURE
 (32-BIT AND 64-BIT)" <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 04/13] x86/sgx: Architectural structures
Message-ID: <20180905173248.GD11368@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-5-jarkko.sakkinen@linux.intel.com>
 <CAHp75VchsQXGRrcrcB06w68PzUZb5NJLo2B_ZKf6ZLqyBbvWhA@mail.gmail.com>
 <83f5ec5f-1b31-15eb-7341-84ee9c7977e2@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <83f5ec5f-1b31-15eb-7341-84ee9c7977e2@intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Sep 04, 2018 at 09:04:44AM -0700, Dave Hansen wrote:
> On 09/03/2018 06:16 AM, Andy Shevchenko wrote:
> >> +       EBLOCK  = 0x9,
> >> +       EPA     = 0xA,
> >> +       EWB     = 0xB,
> >> +       ETRACK  = 0xC,
> >> +       EAUG    = 0xD,
> >> +       EMODPR  = 0xE,
> >> +       EMODT   = 0xF,
> >> +};
> > Hmm... This E prefix confuses me with (system wide) error codes. Has
> > it been discussed before? If so, can you point on the conclusion why
> > the current format is good?
> 
> Making them SGX_EWHATEVER isn't a horrible idea.

OK, going with that.

/Jarkko
