From: "Huang, Kai" <kai.huang@intel.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "Christopherson, Sean J"
	<sean.j.christopherson@intel.com>, "nhorman@redhat.com" <nhorman@redhat.com>,
	"npmccallum@redhat.com" <npmccallum@redhat.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, Kai Huang <kai.huang@linux.intel.com>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Konrad Rzeszutek Wilk
	<konrad.wilk@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, "open
 list:X86 ARCHITECTURE (32-BIT AND        64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v13 02/13] x86/cpufeature: Add SGX and SGX_LC CPU
 features
Date: Mon, 27 Aug 2018 17:07:41 -0700
Message-ID: 
 <105F7BF4D0229846AF094488D65A09893540B623@PGSMSX112.gar.corp.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-3-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180827185507.17087-3-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

> +#define X86_FEATURE_SGX_LC		(16*32+30) /* supports SGX launch
> configuration */

Sorry if it was me who wrote the comment "SGX launch configuration". I think we should just use "SGX launch control". :)

Thanks,
-Kai
> 
>  /* AMD-defined CPU features, CPUID level 0x80000007 (EBX), word 17 */
>  #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* MCA overflow
> recovery support */
> --
> 2.17.1
