Received: from Galois.linutronix.de ([146.0.238.70]:45383 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbeGCUQX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 3 Jul 2018 16:16:23 -0400
Date: Tue, 3 Jul 2018 22:16:12 +0200
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 08/13] x86/sgx: wrappers for ENCLS opcode leaf
 functions
In-Reply-To: <20180703182118.15024-9-jarkko.sakkinen@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1807032149300.1816@nanos.tec.linutronix.de>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com> <20180703182118.15024-9-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="US-ASCII"
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:

> This commit adds wrappers for Intel(R) SGX ENCLS opcode leaf functions

Add...

> except for ENCLS(EINIT). The ENCLS instruction invokes the privileged
> functions for managing (creation, initialization and swapping) and
> debugging enclaves.
>  
> +#define IS_ENCLS_FAULT(r) ((r) & 0xffff0000)
> +#define ENCLS_FAULT_VECTOR(r) ((r) >> 16)
> +
> +#define ENCLS_TO_ERR(r) (IS_ENCLS_FAULT(r) ? -EFAULT :		\
> +			(r) == SGX_UNMASKED_EVENT ? -EINTR :	\
> +			(r) == SGX_MAC_COMPARE_FAIL ? -EIO :	\
> +			(r) == SGX_ENTRYEPOCH_LOCKED ? -EBUSY : -EPERM)

Inlines please along with proper comments.

> +#define __encls_ret_N(rax, inputs...)			\
> +	({						\
> +	int ret;					\
> +	asm volatile(					\
> +	"1: .byte 0x0f, 0x01, 0xcf;\n\t"		\
> +	"2:\n"						\
> +	".section .fixup,\"ax\"\n"			\
> +	"3: shll $16,%%eax\n"				\

SHLL ??? _All_ the macro maze needs proper comments.

> +	"   jmp 2b\n"					\
> +	".previous\n"					\
> +	_ASM_EXTABLE_FAULT(1b, 3b)			\
> +	: "=a"(ret)					\
> +	: "a"(rax), inputs				\
> +	: "memory");					\
> +	ret;						\
> +	})

....

> +static inline int __emodt(struct sgx_secinfo *secinfo, void *epc)
> +{
> +	return __encls_ret_2(EMODT, secinfo, epc);
> +}
> +
>  #define SGX_MAX_EPC_BANKS 8
>  
>  #define SGX_EPC_BANK(epc_page) \
> @@ -39,4 +190,29 @@ extern bool sgx_lc_enabled;
>  void *sgx_get_page(struct sgx_epc_page *ptr);
>  void sgx_put_page(void *epc_page_ptr);

> +#define SGX_FN(name, params...)		\
> +{					\
> +	void *epc;			\
> +	int ret;			\
> +	epc = sgx_get_page(epc_page);	\
> +	ret = __##name(params);		\
> +	sgx_put_page(epc);		\

This whole get/put magic is totally pointless. The stuff is 64bit only, so
all it needs is the address, because 'put' is a noop on 64bit.

> +	return ret;			\
> +}
> +
> +#define BUILD_SGX_FN(fn, name)				\
> +static inline int fn(struct sgx_epc_page *epc_page)	\
> +	SGX_FN(name, epc)
> +BUILD_SGX_FN(sgx_eremove, eremove)
> +BUILD_SGX_FN(sgx_eblock, eblock)
> +BUILD_SGX_FN(sgx_etrack, etrack)
> +BUILD_SGX_FN(sgx_epa, epa)
> +
> +static inline int sgx_emodpr(struct sgx_secinfo *secinfo,
> +			     struct sgx_epc_page *epc_page)
> +	SGX_FN(emodpr, secinfo, epc)
> +static inline int sgx_emodt(struct sgx_secinfo *secinfo,
> +			    struct sgx_epc_page *epc_page)
> +	SGX_FN(emodt, secinfo, epc)

Bah this is really unreadable crap. What's so horribly wrong with writing
this simply as:

static inline int sgx_eremove(struct sgx_epc_page *epc_page)
{
	return __encls_ret_1(EREMOVE, epc_page_addr(epc_page));
}

static inline int sgx_emodt(struct sgx_secinfo *secinfo,
			    struct sgx_epc_page *epc_page)
{
	return __encls_ret_2(EREMOVE, secinfo, epc_page_addr(epc_page));
}

instead of all these completely pointless meta functions and build macro
maze around it.

Why? Because then every function which is actually used in code has a
proper prototype instead of nongrepable magic and a gazillion of wrappers.

Thanks,

	tglx
