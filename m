Date: Wed, 4 Jul 2018 20:33:33 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 08/13] x86/sgx: wrappers for ENCLS opcode leaf
 functions
Message-ID: <20180704173333.GI6724@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-9-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.21.1807032149300.1816@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.21.1807032149300.1816@nanos.tec.linutronix.de>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Jul 03, 2018 at 10:16:12PM +0200, Thomas Gleixner wrote:
> On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:
> 
> > This commit adds wrappers for Intel(R) SGX ENCLS opcode leaf functions
> 
> Add...
> 
> > except for ENCLS(EINIT). The ENCLS instruction invokes the privileged
> > functions for managing (creation, initialization and swapping) and
> > debugging enclaves.
> >  
> > +#define IS_ENCLS_FAULT(r) ((r) & 0xffff0000)
> > +#define ENCLS_FAULT_VECTOR(r) ((r) >> 16)
> > +
> > +#define ENCLS_TO_ERR(r) (IS_ENCLS_FAULT(r) ? -EFAULT :		\
> > +			(r) == SGX_UNMASKED_EVENT ? -EINTR :	\
> > +			(r) == SGX_MAC_COMPARE_FAIL ? -EIO :	\
> > +			(r) == SGX_ENTRYEPOCH_LOCKED ? -EBUSY : -EPERM)
> 
> Inlines please along with proper comments.
> 
> > +#define __encls_ret_N(rax, inputs...)			\
> > +	({						\
> > +	int ret;					\
> > +	asm volatile(					\
> > +	"1: .byte 0x0f, 0x01, 0xcf;\n\t"		\
> > +	"2:\n"						\
> > +	".section .fixup,\"ax\"\n"			\
> > +	"3: shll $16,%%eax\n"				\
> 
> SHLL ??? _All_ the macro maze needs proper comments.

Yeah, agreed.

> > +	"   jmp 2b\n"					\
> > +	".previous\n"					\
> > +	_ASM_EXTABLE_FAULT(1b, 3b)			\
> > +	: "=a"(ret)					\
> > +	: "a"(rax), inputs				\
> > +	: "memory");					\
> > +	ret;						\
> > +	})
> 
> ....
> 
> > +static inline int __emodt(struct sgx_secinfo *secinfo, void *epc)
> > +{
> > +	return __encls_ret_2(EMODT, secinfo, epc);
> > +}
> > +
> >  #define SGX_MAX_EPC_BANKS 8
> >  
> >  #define SGX_EPC_BANK(epc_page) \
> > @@ -39,4 +190,29 @@ extern bool sgx_lc_enabled;
> >  void *sgx_get_page(struct sgx_epc_page *ptr);
> >  void sgx_put_page(void *epc_page_ptr);
> 
> > +#define SGX_FN(name, params...)		\
> > +{					\
> > +	void *epc;			\
> > +	int ret;			\
> > +	epc = sgx_get_page(epc_page);	\
> > +	ret = __##name(params);		\
> > +	sgx_put_page(epc);		\
> 
> This whole get/put magic is totally pointless. The stuff is 64bit only, so
> all it needs is the address, because 'put' is a noop on 64bit.

I did some early/proto versions of SGX code with 32-bit environment. I
guess it is better to strip this stuff simply off.

> 
> > +	return ret;			\
> > +}
> > +
> > +#define BUILD_SGX_FN(fn, name)				\
> > +static inline int fn(struct sgx_epc_page *epc_page)	\
> > +	SGX_FN(name, epc)
> > +BUILD_SGX_FN(sgx_eremove, eremove)
> > +BUILD_SGX_FN(sgx_eblock, eblock)
> > +BUILD_SGX_FN(sgx_etrack, etrack)
> > +BUILD_SGX_FN(sgx_epa, epa)
> > +
> > +static inline int sgx_emodpr(struct sgx_secinfo *secinfo,
> > +			     struct sgx_epc_page *epc_page)
> > +	SGX_FN(emodpr, secinfo, epc)
> > +static inline int sgx_emodt(struct sgx_secinfo *secinfo,
> > +			    struct sgx_epc_page *epc_page)
> > +	SGX_FN(emodt, secinfo, epc)
> 
> Bah this is really unreadable crap. What's so horribly wrong with writing
> this simply as:
> 
> static inline int sgx_eremove(struct sgx_epc_page *epc_page)
> {
> 	return __encls_ret_1(EREMOVE, epc_page_addr(epc_page));
> }
> 
> static inline int sgx_emodt(struct sgx_secinfo *secinfo,
> 			    struct sgx_epc_page *epc_page)
> {
> 	return __encls_ret_2(EREMOVE, secinfo, epc_page_addr(epc_page));
> }
> 
> instead of all these completely pointless meta functions and build macro
> maze around it.
> 
> Why? Because then every function which is actually used in code has a
> proper prototype instead of nongrepable magic and a gazillion of wrappers.

I do agree with you as I would NAK this kind of code from TPM
because this is basically stuff that needs to be written only once
(maybe some minor fixes later on but anyway) and after that the
unrolled form is easier to maintain and debug.

I will do as you adviced.

> Thanks,
> 
> 	tglx

Thank you!

/Jarkko
