Date: Mon, 3 Sep 2018 21:15:09 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "nhorman@redhat.com" <nhorman@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "suresh.b.siddha@intel.com"
	<suresh.b.siddha@intel.com>, "Ayoun, Serge" <serge.ayoun@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "npmccallum@redhat.com"
	<npmccallum@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>
Subject: Re: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing
 enclaves
Message-ID: <20180903181509.GA9265@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
 <1535406078.3416.9.camel@intel.com>
 <20180828070129.GA5301@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893541037C@PGSMSX112.gar.corp.intel.com>
 <20180829203351.GB7142@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893541195D@PGSMSX112.gar.corp.intel.com>
 <20180829210901.GA7176@linux.intel.com>
 <105F7BF4D0229846AF094488D65A098935412392@PGSMSX112.gar.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <105F7BF4D0229846AF094488D65A098935412392@PGSMSX112.gar.corp.intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:45:29AM +0000, Huang, Kai wrote:
> > > > Refresh my brain, does hardware reset the MSRs on a transition to S3 or
> > lower?
> 
> Sorry I missed this one. To be honest I don't know. I checked the SDM and all I can find is:
> 
> "On reset, the default value is the digest of Intel's signing key."
> 
> Jarkko may know.

I found this out by testing. The cached MSR values stop working after
waking up from S3. Have not found anything better from the SDM but it
is the behavior that I've observed on my GLK NUC at least.

/Jarkko
