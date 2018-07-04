Date: Wed, 4 Jul 2018 20:26:29 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Borislav Petkov <bp@suse.de>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Janakarajan Natarajan
	<Janakarajan.Natarajan@amd.com>, David Woodhouse <dwmw@amazon.co.uk>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 03/13] x86/sgx: add SGX definitions to msr-index.h
Message-ID: <20180704172629.GF6724@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-4-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.21.1807032049270.1816@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.21.1807032049270.1816@nanos.tec.linutronix.de>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Jul 03, 2018 at 08:51:23PM +0200, Thomas Gleixner wrote:
> On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:
> 
> x86/msr: Add ....
> 
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > ENCLS and ENCLU are usable if and only if SGX_ENABLE is set and After
> > SGX is activated the IA32_SGXLEPUBKEYHASHn MSRs are writable if
> > SGX_LC_WR is set and the feature control is locked.
> > 
> > SGX related bits in IA32_FEATURE_CONTROL cannot be set before SGX is
> > activated by the pre-boot firmware. SGX activation is triggered by
> > setting bit 0 in the MSR 0x7a. Until SGX is activated, the LE hash MSRs
> > are writable to allow pre-boot firmware to lock down the LE root key
> > with a non-Intel value.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Haim Cohen <haim.cohen@intel.com>
> 
> Lacks SOB
> 
> > ---
> >  arch/x86/include/asm/msr-index.h | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > index fda2114197b3..a7355fb7344f 100644
> > --- a/arch/x86/include/asm/msr-index.h
> > +++ b/arch/x86/include/asm/msr-index.h
> > @@ -479,6 +479,8 @@
> >  #define FEATURE_CONTROL_LOCKED				(1<<0)
> >  #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
> >  #define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX	(1<<2)
> > +#define FEATURE_CONTROL_SGX_ENABLE                      (1<<18)
> 
> Tabs not spaces please. checkpatch.pl would have told you
> 
> > +#define FEATURE_CONTROL_SGX_LE_WR			(1<<17)
> 
> Thanks,
> 
> 	tglx

Thanks, will refine!

/Jarkko
