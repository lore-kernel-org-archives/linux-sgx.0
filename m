Date: Mon, 3 Sep 2018 22:10:23 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>, Dave Hansen
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab
	<mchehab+samsung@kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Arnd
 Bergmann <arnd@arndb.de>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 01/13] x86/sgx: Update MAINTAINERS
Message-ID: <20180903191023.GA13497@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-2-jarkko.sakkinen@linux.intel.com>
 <CAHp75VfM6w6OrgczpMOY8wMK8Uw_SLm+RHDitYjrnNSX4aTepg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHp75VfM6w6OrgczpMOY8wMK8Uw_SLm+RHDitYjrnNSX4aTepg@mail.gmail.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Sep 03, 2018 at 03:56:05PM +0300, Andy Shevchenko wrote:
> On Mon, Aug 27, 2018 at 9:56 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > Add the maintainer information for the SGX subsystem.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  MAINTAINERS | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 24b200d91b30..877fbc6ef7a7 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7562,6 +7562,13 @@ L:       linux-gpio@vger.kernel.org
> >  S:     Maintained
> >  F:     drivers/gpio/gpio-intel-mid.c
> >
> > +INTEL SGX
> 
> It should go in between of
> 
> INTEL RDMA RNIC DRIVER
> ...
> INTEL SHA MULTIBUFFER DRIVER

Thanks, I'll put into the correct place.

/Jarkko
