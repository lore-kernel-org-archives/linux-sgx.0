Date: Mon, 3 Sep 2018 22:27:54 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: "Dr. Greg" <greg@enjellic.com>
CC: Sean Christopherson <sean.j.christopherson@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"nhorman@redhat.com" <nhorman@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"npmccallum@redhat.com" <npmccallum@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing
 enclaves
Message-ID: <20180903192754.GD13497@linux.intel.com>
References: <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
 <1535406078.3416.9.camel@intel.com>
 <20180828070129.GA5301@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893541037C@PGSMSX112.gar.corp.intel.com>
 <20180829203351.GB7142@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893541195D@PGSMSX112.gar.corp.intel.com>
 <20180829210901.GA7176@linux.intel.com>
 <105F7BF4D0229846AF094488D65A098935412392@PGSMSX112.gar.corp.intel.com>
 <20180831174330.GA21555@linux.intel.com>
 <20180831213445.GA4098@wind.enjellic.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180831213445.GA4098@wind.enjellic.com>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Fri, Aug 31, 2018 at 04:34:45PM -0500, Dr. Greg wrote:
> On Fri, Aug 31, 2018 at 10:43:30AM -0700, Sean Christopherson wrote:
> 
> Good afternoon to everyone.
> 
> > > Sorry I missed this one. To be honest I don't know. I checked the
> > > SDM and all I can find is:
> > >
> > > "On reset, the default value is the digest of Intel's signing key."
> 
> > I confirmed the MSRs are reset any time the EPC is lost.  Not sure
> > what happens if the MSRs contained a non-Intel value but feature
> > control is locked with SGX launch control disabled.  I'll post an
> > update when I have an answer.
> 
> It was our interpretation from the SDM that the identity modulus
> signature MSR's are 'trap-door' registers.  If flexible launch control
> (FLC) is enabled the platform has one opportunity to write a new
> signature value, after which the registers are locked from
> modification until the next platform reset.

In the driver we support only MSRs that are left writable by the BIOS
before locking the feature control.

> From a security architecture perspective it seemed that an FLC based
> SGX implementation would use a modified version of TBOOT to securely
> write that register once per platform boot/reset.  The architecture
> that is being discussed where there is a need to continually check
> whether or not the correct root signing key is loaded sounds a bit
> clunky at best.
> 
> At worst it has potential security implications since it is the
> reponsibility of the enclave launch control infrastructure to control
> which enclaves are allowed to have the PROVISION_KEY attribute bit
> set.

Based on the previous feedback supporting read-only MSRs in the driver
is an unwanted feature i.e. the kernel must be able to decide what gets
lauched (i.e. no launch enclave).

> Have a good weekend.
> 
> Dr. Greg
> 
> As always,
> Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
> 4206 N. 19th Ave.           Specializing in information infra-structure
> Fargo, ND  58102            development.
> PH: 701-281-1686
> FAX: 701-281-3949           EMAIL: greg@enjellic.com
> ------------------------------------------------------------------------------
> "Extensive interviews show that not one alcoholic has ever actually seen
>  a pink elephant."
>                                 -- Yale University
>                                    Center of Alcohol Studies

/Jarkko
