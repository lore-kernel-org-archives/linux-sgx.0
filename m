Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51371C4360F
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 14:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F65B218D8
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 14:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfCUO7F (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:59:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:59850 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbfCUO7F (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 10:59:05 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 07:52:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,253,1549958400"; 
   d="scan'208";a="133532322"
Received: from dilu-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.254.184])
  by fmsmga008.fm.intel.com with ESMTP; 21 Mar 2019 07:51:55 -0700
Date:   Thu, 21 Mar 2019 16:51:53 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v19 13/27] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20190321145153.GO4603@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-14-jarkko.sakkinen@linux.intel.com>
 <20190319195907.GG25575@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319195907.GG25575@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 19, 2019 at 12:59:07PM -0700, Sean Christopherson wrote:
> On Sun, Mar 17, 2019 at 11:14:42PM +0200, Jarkko Sakkinen wrote:
> > ENCLS is an umbrella instruction for a variety of cpl0 SGX functions.
> > The ENCLS function that is executed is specified in EAX, with each
> > function potentially having more leaf-specific operands beyond EAX.
> > ENCLS introduces its own (positive value) error codes that (some)
> > leafs use to return failure information in EAX.  Leafs that return
> > an error code also modify RFLAGS.  And finally, ENCLS generates
> > ENCLS-specific non-fatal #GPs and #PFs, i.e. a bug-free kernel may
> > encounter faults on ENCLS that must be handled gracefully.
> > 
> > Because of the complexity involved in encoding ENCLS and handling its
> > assortment of failure paths, executing any given leaf is not a simple
> > matter of emitting ENCLS.
> > 
> > To enable adding support for ENCLS leafs with minimal fuss, add a
> > two-layer macro system along with an encoding scheme to allow wrappers
> > to return trap numbers along ENCLS-specific error codes.  The bottom
> > layer of the macro system splits between the leafs that return an
> > error code and those that do not.  The second layer generates the
> > correct input/output annotations based on the number of operands for
> > each leaf function.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/Makefile |   2 +-
> >  arch/x86/kernel/cpu/sgx/encls.c  |  21 +++
> >  arch/x86/kernel/cpu/sgx/encls.h  | 244 +++++++++++++++++++++++++++++++
> >  3 files changed, 266 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/x86/kernel/cpu/sgx/encls.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/encls.h
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
> > index b666967fd570..20ce33655ff4 100644
> > --- a/arch/x86/kernel/cpu/sgx/Makefile
> > +++ b/arch/x86/kernel/cpu/sgx/Makefile
> > @@ -1 +1 @@
> > -obj-y += main.o
> > +obj-y += main.o encls.o
> > diff --git a/arch/x86/kernel/cpu/sgx/encls.c b/arch/x86/kernel/cpu/sgx/encls.c
> > new file mode 100644
> > index 000000000000..5045f1365e07
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/sgx/encls.c
> > @@ -0,0 +1,21 @@
> > +#include <asm/cpufeature.h>
> > +#include <asm/traps.h>
> > +#include "encls.h"
> > +#include "sgx.h"
> > +
> > +/**
> > + * encls_failed() - Check if an ENCLS leaf function failed
> > + * @ret:	the return value of an ENCLS leaf function call
> > + *
> > + * Check if an ENCLS leaf function failed. This is a condition where the leaf
> > + * function causes a fault that is not caused by an EPCM conflict.
> 
> "conflict" is a poor word choice.  The SDM's refers to EPC conflicts as
> trying to concurrently access an EPC page from multiple logical CPUs.
> 
> Maybe "EPCM violation" or simply "EPCM fault"?

I think violation is better as we have also legit faults.

> 
> > + *
> > + * Return: true if there was a fault other than an EPCM conflict
> > + */
> > +bool encls_failed(int ret)
> 
> I really dislike this name.  IMO, "encls_failed" is inaccurate and to some
> extent an unnecessary abstraction.  Regardless of why it faulted, the
> ENCLS instruction "failed".  Just because the fault originated in the EPCM
> doesn't mean the instruction magically succeeded.
> 
> What if we inverted the logic, i.e. to identify EPCM violations?  And
> rename encls_fault() to is_encls_fault(), and encls_returned_code()
> to is_sgx_error_code().  E.g.:
> 
> bool is_epcm_violation(int ret)
> {
> 	return is_encls_fault(ret) && ENCLS_TRAPNR(ret) == epcm_trapnr;
> }
> 
> Then the usage becomes:
> 
> 	if (is_sgx_error_code(ret) ||
> 	    (is_encls_fault(ret) && !is_epcm_violation(ret))
> 		blah blah blah
> 
> The usage is more verbose, but explicitly clear.

These sounds like legit proposals!

> 
> > +{
> > +	int epcm_trapnr = boot_cpu_has(X86_FEATURE_SGX2) ?
> > +			  X86_TRAP_PF : X86_TRAP_GP;
> 
> epcm_trapnr should be calculated once during init.

Depends whether it is inline or not.

> 
> > +
> > +	return encls_faulted(ret) && ENCLS_TRAPNR(ret) != epcm_trapnr;
> > +}
> 
> Why isn't this function inlined in sgx.h?

I like to put kprobe or ftrace filter to it.

> 
> > diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> > new file mode 100644
> > index 000000000000..aea3b9d09936
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/sgx/encls.h
> > @@ -0,0 +1,244 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> > +#ifndef _X86_ENCLS_H
> > +#define _X86_ENCLS_H
> > +
> > +#include <linux/bitops.h>
> > +#include <linux/err.h>
> > +#include <linux/io.h>
> > +#include <linux/rwsem.h>
> > +#include <linux/types.h>
> > +#include <asm/asm.h>
> > +#include "arch.h"
> > +
> > +/**
> > + * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
> > + *
> > + * ENCLS has its own (positive value) error codes and also generates
> > + * ENCLS specific #GP and #PF faults.  And the ENCLS values get munged
> > + * with system error codes as everything percolates back up the stack.
> > + * Unfortunately (for us), we need to precisely identify each unique
> > + * error code, e.g. the action taken if EWB fails varies based on the
> > + * type of fault and on the exact SGX error code, i.e. we can't simply
> > + * convert all faults to -EFAULT.
> > + *
> > + * To make all three error types coexist, we set bit 30 to identify an
> > + * ENCLS fault.  Bit 31 (technically bits N:31) is used to differentiate
> > + * between positive (faults and SGX error codes) and negative (system
> > + * error codes) values.
> > + */
> > +#define ENCLS_FAULT_FLAG 0x40000000
> > +
> > +/**
> > + * Retrieve the encoded trapnr from the specified return code.
> > + */
> > +#define ENCLS_TRAPNR(r) ((r) & ~ENCLS_FAULT_FLAG)
> 
> I honestly can't remember, is there a reason ENCLS_TRAPNR is still a macro
> and not an inline function?

Not at all. And also the value should be unsigned and fault flag
should be 0x80* because we never should get negative values.

> 
> > +
> > +/* Issue a WARN() about an ENCLS leaf. */
> 
> If you're going to bother with a comment, might as well document the
> interesting part, i.e. why we print both the decimal and hexidecimal
> formats, which is the reason this macro exists at all.
> 
> > +#define ENCLS_WARN(r, name) {						\
> 
> Taking the warn condition and the raw error code in a single parameter
> makes the call sites ugly, e.g.
> 
> 	if (ret) {
> 		if (encls_failed(ret))
> 			ENCLS_WARN(ret, "EADD");
> 		return false;
> 	}
> 
> If the macro is instead something like:
> 
> #define ENCLS_WARN(do_warn, r, name) \
> 	WARN(w, "sgx: %s returned %d (0x%x)\n", (name), (r), (r); \
> 
> then we can drop the do-while wrapping and the callers are a little less
> ugly, e.g.:
> 
> 	if (ret) {
> 		ENCLS_WARN(encls_failed(ret), ret, "EADD");
> 		return ret;
> 	}
> 
> 
> Or with the is_epcm_violation() variant:
> 
> 	if (ret) {
> 		ENCLS_WARN(is_encls_fault(ret) && !is_epcm_violation(ret),
> 			   ret, "EADD");
> 		return ret;
> 	}
> 
> > +	do {								\
> > +		int _r = (r);						\
> > +		WARN(_r, "sgx: %s returned %d (0x%x)\n", (name), _r,	\
> > +		     _r);						\
> 
> There's no need to wrap this, just add spaces before the '\'.
> 
> > +	} while (0);							\
> > +}
> > +
> > +/**
> > + * encls_faulted() - Check if ENCLS leaf function faulted
> > + * @ret:	the return value of an ENCLS leaf function call
> > + *
> > + * Return: true if the fault flag is set
> > + */
> > +static inline bool encls_faulted(int ret)
> > +{
> > +	return (ret & ENCLS_FAULT_FLAG) != 0;
> > +}
> > +
> > +/**
> > + * encls_returned_code() - Check if an ENCLS leaf function returned a code
> > + * @ret:	the return value of an ENCLS leaf function call
> > + *
> > + * Check if an ENCLS leaf function returned an error or information code.
> > + *
> > + * Return: true if there was a fault other than an EPCM conflict
> > + */
> > +static inline bool encls_returned_code(int ret)
> > +{
> > +	return !encls_faulted(ret) && ret;
> 
> Nit: IMO checking for non-zero ret should be first, both from a readability
>      perspective and from a code generation perspective.
> 
> > +}
> > +
> > +bool encls_failed(int ret);
> > +
> > +/**
> > + * __encls_ret_N - encode an ENCLS leaf that returns an error code in EAX
> > + * @rax:	leaf number
> > + * @inputs:	asm inputs for the leaf
> > + *
> > + * Emit assembly for an ENCLS leaf that returns an error code, e.g. EREMOVE.
> > + * And because SGX isn't complex enough as it is, leafs that return an error
> > + * code also modify flags.
> > + *
> > + * Return:
> > + *	0 on success,
> > + *	SGX error code on failure
> > + */
> > +#define __encls_ret_N(rax, inputs...)				\
> > +	({							\
> > +	int ret;						\
> > +	asm volatile(						\
> > +	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
> > +	"2:\n"							\
> > +	".section .fixup,\"ax\"\n"				\
> > +	"3: orl $"__stringify(ENCLS_FAULT_FLAG)",%%eax\n"	\
> > +	"   jmp 2b\n"						\
> > +	".previous\n"						\
> > +	_ASM_EXTABLE_FAULT(1b, 3b)				\
> > +	: "=a"(ret)						\
> > +	: "a"(rax), inputs					\
> > +	: "memory", "cc");					\
> > +	ret;							\
> > +	})
> > +
> > +#define __encls_ret_1(rax, rcx)		\
> > +	({				\
> > +	__encls_ret_N(rax, "c"(rcx));	\
> > +	})
> > +
> > +#define __encls_ret_2(rax, rbx, rcx)		\
> > +	({					\
> > +	__encls_ret_N(rax, "b"(rbx), "c"(rcx));	\
> > +	})
> > +
> > +#define __encls_ret_3(rax, rbx, rcx, rdx)			\
> > +	({							\
> > +	__encls_ret_N(rax, "b"(rbx), "c"(rcx), "d"(rdx));	\
> > +	})
> > +
> > +/**
> > + * __encls_N - encode an ENCLS leaf that doesn't return an error code
> > + * @rax:	leaf number
> > + * @rbx_out:	optional output variable
> > + * @inputs:	asm inputs for the leaf
> > + *
> > + * Emit assembly for an ENCLS leaf that does not return an error code,
> > + * e.g. ECREATE.  Leaves without error codes either succeed or fault.
> > + * @rbx_out is an optional parameter for use by EDGBRD, which returns
> > + * the the requested value in RBX.
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   trapnr with ENCLS_FAULT_FLAG set on fault
> > + */
> > +#define __encls_N(rax, rbx_out, inputs...)			\
> > +	({							\
> > +	int ret;						\
> > +	asm volatile(						\
> > +	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
> > +	"   xor %%eax,%%eax;\n"					\
> > +	"2:\n"							\
> > +	".section .fixup,\"ax\"\n"				\
> > +	"3: orl $"__stringify(ENCLS_FAULT_FLAG)",%%eax\n"	\
> > +	"   jmp 2b\n"						\
> > +	".previous\n"						\
> > +	_ASM_EXTABLE_FAULT(1b, 3b)				\
> > +	: "=a"(ret), "=b"(rbx_out)				\
> > +	: "a"(rax), inputs					\
> > +	: "memory");						\
> > +	ret;							\
> > +	})
> > +
> > +#define __encls_2(rax, rbx, rcx)				\
> > +	({							\
> > +	unsigned long ign_rbx_out;				\
> > +	__encls_N(rax, ign_rbx_out, "b"(rbx), "c"(rcx));	\
> > +	})
> > +
> > +#define __encls_1_1(rax, data, rcx)			\
> > +	({						\
> > +	unsigned long rbx_out;				\
> > +	int ret = __encls_N(rax, rbx_out, "c"(rcx));	\
> > +	if (!ret)					\
> > +		data = rbx_out;				\
> > +	ret;						\
> > +	})
> > +
> > +static inline int __ecreate(struct sgx_pageinfo *pginfo, void *secs)
> > +{
> > +	return __encls_2(SGX_ECREATE, pginfo, secs);
> > +}
> > +
> > +static inline int __eextend(void *secs, void *addr)
> > +{
> > +	return __encls_2(SGX_EEXTEND, secs, addr);
> > +}
> > +
> > +static inline int __eadd(struct sgx_pageinfo *pginfo, void *addr)
> > +{
> > +	return __encls_2(SGX_EADD, pginfo, addr);
> > +}
> > +
> > +static inline int __einit(void *sigstruct, struct sgx_einittoken *einittoken,
> > +			  void *secs)
> > +{
> > +	return __encls_ret_3(SGX_EINIT, sigstruct, secs, einittoken);
> > +}
> > +
> > +static inline int __eremove(void *addr)
> > +{
> > +	return __encls_ret_1(SGX_EREMOVE, addr);
> > +}
> > +
> > +static inline int __edbgwr(void *addr, unsigned long *data)
> > +{
> > +	return __encls_2(SGX_EDGBWR, *data, addr);
> > +}
> > +
> > +static inline int __edbgrd(void *addr, unsigned long *data)
> > +{
> > +	return __encls_1_1(SGX_EDGBRD, *data, addr);
> > +}
> > +
> > +static inline int __etrack(void *addr)
> > +{
> > +	return __encls_ret_1(SGX_ETRACK, addr);
> > +}
> > +
> > +static inline int __eldu(struct sgx_pageinfo *pginfo, void *addr,
> > +			 void *va)
> > +{
> > +	return __encls_ret_3(SGX_ELDU, pginfo, addr, va);
> > +}
> > +
> > +static inline int __eblock(void *addr)
> > +{
> > +	return __encls_ret_1(SGX_EBLOCK, addr);
> > +}
> > +
> > +static inline int __epa(void *addr)
> > +{
> > +	unsigned long rbx = SGX_PAGE_TYPE_VA;
> > +
> > +	return __encls_2(SGX_EPA, rbx, addr);
> > +}
> > +
> > +static inline int __ewb(struct sgx_pageinfo *pginfo, void *addr,
> > +			void *va)
> > +{
> > +	return __encls_ret_3(SGX_EWB, pginfo, addr, va);
> > +}
> > +
> > +static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
> > +{
> > +	return __encls_2(SGX_EAUG, pginfo, addr);
> > +}
> > +
> > +static inline int __emodpr(struct sgx_secinfo *secinfo, void *addr)
> > +{
> > +	return __encls_ret_2(SGX_EMODPR, secinfo, addr);
> > +}
> > +
> > +static inline int __emodt(struct sgx_secinfo *secinfo, void *addr)
> > +{
> > +	return __encls_ret_2(SGX_EMODT, secinfo, addr);
> > +}
> > +
> > +#endif /* _X86_ENCLS_H */
> > -- 
> > 2.19.1
> > 

All of the feedback looks legit. Thanks. And in addition we should
assumed unigned value from the macros.

/Jarkko

/Jarkko
