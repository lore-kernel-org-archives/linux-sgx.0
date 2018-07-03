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
Message-ID: <a77924a0-a99f-f352-d115-6bbbd864e8ed@intel.com>
Date: Tue, 3 Jul 2018 12:02:31 -0700
In-Reply-To: <20180703182118.15024-6-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 07/03/2018 11:19 AM, Jarkko Sakkinen wrote:
> This commit adds arch/x86/include/asm/sgx_arch.h that contains definitions
> for data structures used by the SGX.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/include/asm/sgx_arch.h | 183 ++++++++++++++++++++++++++++++++
>  1 file changed, 183 insertions(+)
>  create mode 100644 arch/x86/include/asm/sgx_arch.h
> 
> diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
> new file mode 100644
> index 000000000000..41a37eaa3f51
> --- /dev/null
> +++ b/arch/x86/include/asm/sgx_arch.h
> @@ -0,0 +1,183 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-17 Intel Corporation.

It would also be anice to have a description of what this contains.
"Don't put software data structures in here, or else"

> +#include <linux/types.h>
> +
> +#define SGX_CPUID 0x12

Shouldn't you be introducing this earlier and using it here?

+	/* Intel SGX features: level 0x00000012 */
+	if (c->cpuid_level >= 0x00000012) {
+		cpuid(0x00000012, &eax, &ebx, &ecx, &edx);
+
+		c->x86_capability[CPUID_12_EAX] = eax;
+	}

> +enum sgx_cpuid {
> +	SGX_CPUID_CAPABILITIES	= 0,
> +	SGX_CPUID_ATTRIBUTES	= 1,
> +	SGX_CPUID_EPC_BANKS	= 2,
> +};
> +
> +#define SGX_SSA_GPRS_SIZE		182
> +#define SGX_SSA_MISC_EXINFO_SIZE	16
> +
> +enum sgx_misc {
> +	SGX_MISC_EXINFO		= 0x01,
> +};
> +
> +#define SGX_MISC_RESERVED_MASK 0xFFFFFFFFFFFFFFFEL
> +
> +enum sgx_attribute {
> +	SGX_ATTR_DEBUG		= 0x02,
> +	SGX_ATTR_MODE64BIT	= 0x04,
> +	SGX_ATTR_PROVISIONKEY	= 0x10,
> +	SGX_ATTR_EINITTOKENKEY	= 0x20,
> +};
> +
> +#define SGX_ATTR_RESERVED_MASK 0xFFFFFFFFFFFFFFC9L
> +
> +#define SGX_SECS_RESERVED1_SIZE 24
> +#define SGX_SECS_RESERVED2_SIZE 32
> +#define SGX_SECS_RESERVED3_SIZE 96
> +#define SGX_SECS_RESERVED4_SIZE 3836
> +
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

It would be nice to align these a _bit_, like:

> +	uint32_t mrsigner[8];
> +	uint8_t	 reserved3[SGX_SECS_RESERVED3_SIZE];
> +	uint16_t isvvprodid;
> +	uint16_t isvsvn;
> +	uint8_t  reserved4[SGX_SECS_RESERVED4_SIZE];

Is the SECS *defined* to be a single page, or can it be bigger?

> +enum sgx_tcs_flags {
> +	SGX_TCS_DBGOPTIN	= 0x01, /* cleared on EADD */
> +};
> +
> +#define SGX_TCS_RESERVED_MASK 0xFFFFFFFFFFFFFFFEL
> +
> +struct sgx_tcs {
> +	uint64_t state;
> +	uint64_t flags;
> +	uint64_t ossa;
> +	uint32_t cssa;
> +	uint32_t nssa;
> +	uint64_t oentry;
> +	uint64_t aep;
> +	uint64_t ofsbase;
> +	uint64_t ogsbase;
> +	uint32_t fslimit;
> +	uint32_t gslimit;
> +	uint64_t reserved[503];
> +} __packed __aligned(4096);

It's interesting that you defined a reserved[] array here with a
hard-coded number and a (nicely-aligned, I'll point out) uint64_t, but
the sgx_secs was defined using #defined reserve sizes and a uint8_t.
Seems like we should just be consistent.  No?

Also, are these truly structures that need alignment?  Or are they just
the *format* of a page (which is obviously aligned)?  For instance, if
we copied the hardware structure into a temporary buffer, we wouldn't
need it aligned.

I sometimes prefer asking for an instance of a variable to be aligned
rather than the type for things like this.

> +struct sgx_pageinfo {
> +	uint64_t linaddr;
> +	uint64_t srcpge;
> +	union {
> +		uint64_t secinfo;
> +		uint64_t pcmd;
> +	};
> +	uint64_t secs;
> +} __packed __aligned(32);

I see these were verbatim names taken from the SDM.  Could you also
please add some small comments about them?  "secs", for instance, is a
pretty common abbreviation for "seconds".  It would really help to have
this at _least_ say:

	uint64_t sgx_secs;

> +#define SGX_SECINFO_PERMISSION_MASK	0x0000000000000007L
> +#define SGX_SECINFO_PAGE_TYPE_MASK	0x000000000000FF00L
> +#define SGX_SECINFO_RESERVED_MASK	0xFFFFFFFFFFFF00F8L
> +
> +enum sgx_page_type {
> +	SGX_PAGE_TYPE_SECS	= 0x00,
> +	SGX_PAGE_TYPE_TCS	= 0x01,
> +	SGX_PAGE_TYPE_REG	= 0x02,
> +	SGX_PAGE_TYPE_VA	= 0x03,
> +	SGX_PAGE_TYPE_TRIM	= 0x04,
> +};
> +
> +enum sgx_secinfo_flags {
> +	SGX_SECINFO_R		= 0x01,
> +	SGX_SECINFO_W		= 0x02,
> +	SGX_SECINFO_X		= 0x04,
> +	SGX_SECINFO_SECS	= (SGX_PAGE_TYPE_SECS << 8),
> +	SGX_SECINFO_TCS		= (SGX_PAGE_TYPE_TCS << 8),
> +	SGX_SECINFO_REG		= (SGX_PAGE_TYPE_REG << 8),
> +	SGX_SECINFO_VA          = (SGX_PAGE_TYPE_VA << 8),
> +	SGX_SECINFO_TRIM	= (SGX_PAGE_TYPE_TRIM << 8),
> +};
> +
> +struct sgx_secinfo {
> +	uint64_t flags;
> +	uint64_t reserved[7];
> +} __packed __aligned(64);
> +
> +struct sgx_pcmd {
> +	struct sgx_secinfo secinfo;
> +	uint64_t enclave_id;
> +	uint8_t reserved[40];
> +	uint8_t mac[16];
> +} __packed __aligned(128);

I don't see any sign of this alignment restriction in the SDM.

> +#define SGX_MODULUS_SIZE 384

This is #defined in a rather odd place.  Why here?  Also, please add a
unit.  SGX_MODULUS_SIZE_BYTES or SGX_MODULUS_BYTES is way better than _SIZE.

> +struct sgx_sigstruct_header {
> +	uint64_t header1[2];
> +	uint32_t vendor;
> +	uint32_t date;
> +	uint64_t header2[2];
> +	uint32_t swdefined;
> +	uint8_t reserved1[84];
> +} __packed;
> +
> +struct sgx_sigstruct_body {
> +	uint32_t miscselect;
> +	uint32_t miscmask;
> +	uint8_t reserved2[20];
> +	uint64_t attributes;
> +	uint64_t xfrm;
> +	uint8_t attributemask[16];

I've hit my limit on silly SDM names. :)

Please make these human-readable: "attribute_mask".  The divergence from
the SDM naming is justified at this point.

> +	uint8_t mrenclave[32];
> +	uint8_t reserved3[32];
> +	uint16_t isvprodid;
> +	uint16_t isvsvn;
> +} __packed;
> +
> +struct sgx_sigstruct {
> +	struct sgx_sigstruct_header header;
> +	uint8_t modulus[SGX_MODULUS_SIZE];
> +	uint32_t exponent;
> +	uint8_t signature[SGX_MODULUS_SIZE];
> +	struct sgx_sigstruct_body body;
> +	uint8_t reserved4[12];
> +	uint8_t q1[SGX_MODULUS_SIZE];
> +	uint8_t q2[SGX_MODULUS_SIZE];
> +} __packed __aligned(4096);

It's interesting that the SDM says "page aligned" in some places and
"4096-byte aligned" in others.  Oh well.

> +struct sgx_einittoken_payload {
> +	uint32_t valid;
> +	uint32_t reserved1[11];

... and back to different types being used for padding.  These really
need to at least be consistent.

> +	uint64_t attributes;
> +	uint64_t xfrm;
> +	uint8_t mrenclave[32];
> +	uint8_t reserved2[32];
> +	uint8_t mrsigner[32];
> +	uint8_t reserved3[32];
> +} __packed;
Just curious, why is this broken out into its own structure?  It doesn't
appear architectural.

> +struct sgx_einittoken {
> +	struct sgx_einittoken_payload payload;
> +	uint8_t cpusvnle[16];
> +	uint16_t isvprodidle;
> +	uint16_t isvsvnle;
> +	uint8_t reserved2[24];
> +	uint32_t maskedmiscselectle;
> +	uint64_t maskedattributesle;
> +	uint64_t maskedxfrmle;
> +	uint8_t keyid[32];
> +	uint8_t mac[16];
> +} __packed __aligned(512);
> +
> +#endif /* _ASM_X86_SGX_ARCH_H */
>
