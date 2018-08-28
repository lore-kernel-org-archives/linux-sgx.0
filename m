Date: Tue, 28 Aug 2018 10:17:23 +0300
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
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 02/13] x86/cpufeature: Add SGX and SGX_LC CPU features
Message-ID: <20180828071723.GA15508@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-3-jarkko.sakkinen@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893540B623@PGSMSX112.gar.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <105F7BF4D0229846AF094488D65A09893540B623@PGSMSX112.gar.corp.intel.com>
Sender: <linux-kernel-owner@vger.kernel.org>
Return-Path: linux-kernel-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Aug 28, 2018 at 12:07:41AM +0000, Huang, Kai wrote:
> > +#define X86_FEATURE_SGX_LC		(16*32+30) /* supports SGX launch
> > configuration */
> 
> Sorry if it was me who wrote the comment "SGX launch configuration". I
> think we should just use "SGX launch control". :)

Not sure if we should change though. The former is more self-explaining,
the latter is "more official".

/Jarkko
