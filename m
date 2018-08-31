Date: Fri, 31 Aug 2018 16:34:45 -0500
From: "Dr. Greg" <greg@enjellic.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"nhorman@redhat.com" <nhorman@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"npmccallum@redhat.com" <npmccallum@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing enclaves
Message-ID: <20180831213445.GA4098@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com> <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com> <1535406078.3416.9.camel@intel.com> <20180828070129.GA5301@linux.intel.com> <105F7BF4D0229846AF094488D65A09893541037C@PGSMSX112.gar.corp.intel.com> <20180829203351.GB7142@linux.intel.com> <105F7BF4D0229846AF094488D65A09893541195D@PGSMSX112.gar.corp.intel.com> <20180829210901.GA7176@linux.intel.com> <105F7BF4D0229846AF094488D65A098935412392@PGSMSX112.gar.corp.intel.com> <20180831174330.GA21555@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180831174330.GA21555@linux.intel.com>
Return-Path: greg@wind.enjellic.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:43:30AM -0700, Sean Christopherson wrote:

Good afternoon to everyone.

> > Sorry I missed this one. To be honest I don't know. I checked the
> > SDM and all I can find is:
> >
> > "On reset, the default value is the digest of Intel's signing key."

> I confirmed the MSRs are reset any time the EPC is lost.  Not sure
> what happens if the MSRs contained a non-Intel value but feature
> control is locked with SGX launch control disabled.  I'll post an
> update when I have an answer.

It was our interpretation from the SDM that the identity modulus
signature MSR's are 'trap-door' registers.  If flexible launch control
(FLC) is enabled the platform has one opportunity to write a new
signature value, after which the registers are locked from
modification until the next platform reset.
