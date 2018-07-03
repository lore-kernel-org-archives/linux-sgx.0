Subject: Re: [PATCH v12 03/13] x86/sgx: add SGX definitions to msr-index.h
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-4-jarkko.sakkinen@linux.intel.com>
CC: <sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov
	<bp@suse.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Janakarajan Natarajan
	<Janakarajan.Natarajan@amd.com>, David Woodhouse <dwmw@amazon.co.uk>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <296d6c54-306d-ebec-0a7a-68e06d00e704@intel.com>
Date: Tue, 3 Jul 2018 11:31:59 -0700
In-Reply-To: <20180703182118.15024-4-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Return-Path: dave.hansen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 07/03/2018 11:19 AM, Jarkko Sakkinen wrote:
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -479,6 +479,8 @@
>  #define FEATURE_CONTROL_LOCKED				(1<<0)
>  #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
>  #define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX	(1<<2)
> +#define FEATURE_CONTROL_SGX_ENABLE                      (1<<18)
> +#define FEATURE_CONTROL_SGX_LE_WR			(1<<17)
>  #define FEATURE_CONTROL_LMCE				(1<<20)

Have you run checkpatch.pl on these?  There's a tabs-vs-spaces issue here.
