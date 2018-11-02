Date: Sat, 3 Nov 2018 01:55:14 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, <andriy.shevchenko@linux.intel.com>, Kai Huang
	<kai.huang@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, David Woodhouse
	<dwmw@amazon.co.uk>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 02/23] x86/cpufeatures: Add Intel-defined SGX feature
 bit
Message-ID: <20181102235514.GA383@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-3-jarkko.sakkinen@linux.intel.com>
 <20181102233301.GD26770@zn.tnic>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20181102233301.GD26770@zn.tnic>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Sat, Nov 03, 2018 at 12:33:01AM +0100, Borislav Petkov wrote:
> On Sat, Nov 03, 2018 at 01:11:01AM +0200, Jarkko Sakkinen wrote:
> > From: Kai Huang <kai.huang@linux.intel.com>
> > 
> > X86_FEATURE_SGX reflects whether or not the CPU supports Intel's
> > Software Guard eXtensions (SGX).
> > 
> > Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
> 
> This and all the other patches of which you're not the author, need to
> have your SOB after the author's SOB.
> 
> See Documentation/process/submitting-patches.rst

Right. I know this but forgot to go through this step.

/Jarkko
