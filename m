Subject: Re: [PATCH v12 05/13] x86/sgx: architectural structures
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-6-jarkko.sakkinen@linux.intel.com>
CC: <sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <f9fe78ca-0ff4-814c-3681-a2366be01337@intel.com>
Date: Thu, 5 Jul 2018 08:31:42 -0700
In-Reply-To: <20180703182118.15024-6-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Return-Path: dave.hansen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 07/03/2018 11:19 AM, Jarkko Sakkinen wrote:
> +struct sgx_secs {
> +	uint64_t size;
> +	uint64_t base;
> +	uint32_t ssaframesize;
> +	uint32_t miscselect;
> +	uint8_t reserved1[SGX_SECS_RESERVED1_SIZE];
> +	uint64_t attributes;
> +	uint64_t xfrm;
> +	uint32_t mrenclave[8];
> +	uint8_t reserved2[SGX_SECS_RESERVED2_SIZE];
> +	uint32_t mrsigner[8];
> +	uint8_t	reserved3[SGX_SECS_RESERVED3_SIZE];
> +	uint16_t isvvprodid;
> +	uint16_t isvsvn;
> +	uint8_t reserved4[SGX_SECS_RESERVED4_SIZE];
> +} __packed __aligned(4096);

Why are the uint* versions in use here?  Those are for userspace ABI,
but this is entirely for in-kernel-use, right?

We've used u8/16/32/64 in arch code in a bunch of places.  They're at
least a bit more compact and easier to read.  It's this:

	u8	foo;
	u64	bar;

vs. this:

	uint8_t	 foo;
	uint64_t bar;
