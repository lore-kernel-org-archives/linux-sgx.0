Date: Fri, 31 Aug 2018 15:19:25 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Christopherson, Sean J"
	<sean.j.christopherson@intel.com>, "nhorman@redhat.com" <nhorman@redhat.com>,
	"npmccallum@redhat.com" <npmccallum@redhat.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, Kai Huang <kai.huang@linux.intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Konrad Rzeszutek Wilk
	<konrad.wilk@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, "open
 list:X86 ARCHITECTURE (32-BIT AND        64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 02/13] x86/cpufeature: Add SGX and SGX_LC CPU features
Message-ID: <20180831121925.GB18075@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-3-jarkko.sakkinen@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893540B623@PGSMSX112.gar.corp.intel.com>
 <20180828071723.GA15508@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989354103A9@PGSMSX112.gar.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <105F7BF4D0229846AF094488D65A0989354103A9@PGSMSX112.gar.corp.intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Wed, Aug 29, 2018 at 07:36:13AM +0000, Huang, Kai wrote:
> > -----Original Message-----
> > From: Jarkko Sakkinen [mailto:jarkko.sakkinen@linux.intel.com]
> > Sent: Tuesday, August 28, 2018 7:17 PM
> > To: Huang, Kai <kai.huang@intel.com>
> > Cc: x86@kernel.org; platform-driver-x86@vger.kernel.org; Hansen, Dave
> > <dave.hansen@intel.com>; Christopherson, Sean J
> > <sean.j.christopherson@intel.com>; nhorman@redhat.com;
> > npmccallum@redhat.com; linux-sgx@vger.kernel.org; Kai Huang
> > <kai.huang@linux.intel.com>; Thomas Gleixner <tglx@linutronix.de>; Ingo
> > Molnar <mingo@redhat.com>; H. Peter Anvin <hpa@zytor.com>; Borislav
> > Petkov <bp@suse.de>; Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>;
> > David Woodhouse <dwmw@amazon.co.uk>; open list:X86 ARCHITECTURE (32-
> > BIT AND 64-BIT) <linux-kernel@vger.kernel.org>
> > Subject: Re: [PATCH v13 02/13] x86/cpufeature: Add SGX and SGX_LC CPU
> > features
> > 
> > On Tue, Aug 28, 2018 at 12:07:41AM +0000, Huang, Kai wrote:
> > > > +#define X86_FEATURE_SGX_LC		(16*32+30) /* supports SGX
> > launch
> > > > configuration */
> > >
> > > Sorry if it was me who wrote the comment "SGX launch configuration". I
> > > think we should just use "SGX launch control". :)
> > 
> > Not sure if we should change though. The former is more self-explaining, the
> > latter is "more official".
> 
> I'll let you decide.  To me the comment should explain what does "LC"
> mean, and to me it means "launch control". :)

Yea, maybe it is better to change as SDM speaks about launch control...

> Thanks,
> -Kai
> > 
> > /Jarkko

/Jarkko
