Date: Wed, 4 Jul 2018 20:24:43 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Kai Huang <kai.huang@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, David Woodhouse
	<dwmw@amazon.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 02/13] x86/sgx: add SGX definitions to cpufeature
Message-ID: <20180704172443.GD6724@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-3-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.21.1807032041310.1816@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.21.1807032041310.1816@nanos.tec.linutronix.de>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Jul 03, 2018 at 08:48:54PM +0200, Thomas Gleixner wrote:
> On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:
> 
> Subject: x86/sgx: add SGX definitions to cpufeature
> 
> The prefix is bogus. Not everything you touch is SGX just because.
> 
> The proper prefix is 'x86/cpufeatures:' 
> The following sentence starts with an uppercase letter.
> 
> And with the proper prefix the subject wants to be something like:
> 
>   x86/cpufeatures: Add SGX and SGX_LC CPU features
> 
> > From: Kai Huang <kai.huang@linux.intel.com>
> > 
> > Added X86_FEATURE_SGX and X86_FEATURE_SGX_LC definitions that define the
> 
> Add the ...
> 
> ->						definitions that define
> 
> That's redundant.
> 
> > bits CPUID level 7 bits for determining whether the CPU supports SGX and
> 
> bits ... bits ?? 
> 
> > launch configuration other than the Intel proprietary key. If this the
> > case, IA32_SGXLEPUBKEYHASHn MSRs (0 < n < 4) are available for defining the
> > root key for enclaves.
> > 
> > Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
> 
> Lacks your SOB
> 
> Thanks,
> 
> 	tglx

Thanks, will refine!

/Jarkko
