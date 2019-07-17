Return-Path: <SRS0=+VJP=VO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EF4C7618F
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Jul 2019 22:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C640820880
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Jul 2019 22:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfGQWHH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 17 Jul 2019 18:07:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:60303 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfGQWHH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 17 Jul 2019 18:07:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 15:07:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,275,1559545200"; 
   d="scan'208";a="366711687"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jul 2019 15:07:05 -0700
Subject: Re: [PATCH v21 23/28] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-24-jarkko.sakkinen@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <d6a6865f-d7a9-dbe9-66b4-3f5cf62aaf6f@intel.com>
Date:   Wed, 17 Jul 2019 15:07:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190713170804.2340-24-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/13/2019 10:07 AM, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Intel Software Guard Extensions (SGX) introduces a new CPL3-only enclave
> mode that runs as a sort of black box shared object that is hosted by an
> untrusted normal CPL3 process.
> 
> Skipping over a great deal of gory architecture details[1], SGX was
> designed in such a way that the host process can utilize a library to
> build, launch and run an enclave.  This is roughly analogous to how
> e.g. libc implementations are used by most applications so that the
> application can focus on its business logic.
> 
> The big gotcha is that because enclaves can generate *and* handle
> exceptions, any SGX library must be prepared to handle nearly any
> exception at any time (well, any time a thread is executing in an
> enclave).  In Linux, this means the SGX library must register a
> signal handler in order to intercept relevant exceptions and forward
> them to the enclave (or in some cases, take action on behalf of the
> enclave).  Unfortunately, Linux's signal mechanism doesn't mesh well
> with libraries, e.g. signal handlers are process wide, are difficult
> to chain, etc...  This becomes particularly nasty when using multiple
> levels of libraries that register signal handlers, e.g. running an
> enclave via cgo inside of the Go runtime.
> 
> In comes vDSO to save the day.  Now that vDSO can fixup exceptions,
> add a function, __vdso_sgx_enter_enclave(), to wrap enclave transitions
> and intercept any exceptions that occur when running the enclave.
> 
> __vdso_sgx_enter_enclave() does NOT adhere to the x86-64 ABI and instead
> uses a custom calling convention.  The primary motivation is to avoid
> issues that arise due to asynchronous enclave exits.  The x86-64 ABI
> requires that EFLAGS.DF, MXCSR and FCW be preserved by the callee, and
> unfortunately for the vDSO, the aformentioned registers/bits are not
> restored after an asynchronous exit, e.g. EFLAGS.DF is in an unknown
> state while MXCSR and FCW are reset to their init values.  So the vDSO
> cannot simply pass the buck by requiring enclaves to adhere to the
> x86-64 ABI.  That leaves three somewhat reasonable options:
> 
>    1) Save/restore non-volatile GPRs, MXCSR and FCW, and clear EFLAGS.DF
> 
>       + 100% compliant with the x86-64 ABI
>       + Callable from any code
>       + Minimal documentation required
>       - Restoring MXCSR/FCW is likely unnecessary 99% of the time
>       - Slow
> 
>    2) Save/restore non-volatile GPRs and clear EFLAGS.DF
> 
>       + Mostly compliant with the x86-64 ABI
>       + Callable from any code that doesn't use SIMD registers
>       - Need to document deviations from x86-64 ABI, i.e. MXCSR and FCW
> 
>    3) Require the caller to save/restore everything.
> 
>       + Fast
>       + Userspace can pass all GPRs to the enclave (minus EAX, RBX and RCX)
>       - Custom ABI
>       - For all intents and purposes must be called from an assembly wrapper
> 
> __vdso_sgx_enter_enclave() implements option (3).  The custom ABI is
> mostly a documentation issue, and even that is offset by the fact that
> being more similar to hardware's ENCLU[EENTER/ERESUME] ABI reduces the
> amount of documentation needed for the vDSO, e.g. options (2) and (3)
> would need to document which registers are marshalled to/from enclaves.
> Requiring an assembly wrapper imparts minimal pain on userspace as SGX
> libraries and/or applications need a healthy chunk of assembly, e.g. in
> the enclave, regardless of the vDSO's implementation.
> 
> Note, the C-like pseudocode describing the assembly routine is wrapped
> in a non-existent macro instead of in a comment to trick kernel-doc into
> auto-parsing the documentation and function prototype.  This is a double
> win as the pseudocode is intended to aid kernel developers, not userland
> enclave developers.
> 
> [1] Documentation/x86/sgx/1.Architecture.rst
> 
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Haitao Huang <haitao.huang@linux.intel.com>
> Cc: Jethro Beekman <jethro@fortanix.com>
> Cc: Dr. Greg Wettstein <greg@enjellic.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Cedric Xing <cedric.xing@intel.com>
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> ---
>   arch/x86/entry/vdso/Makefile             |   2 +
>   arch/x86/entry/vdso/vdso.lds.S           |   1 +
>   arch/x86/entry/vdso/vsgx_enter_enclave.S | 169 +++++++++++++++++++++++
>   arch/x86/include/uapi/asm/sgx.h          |  18 +++
>   4 files changed, 190 insertions(+)
>   create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
> 
> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
> index 715106395c71..1ae23e7d54a9 100644
> --- a/arch/x86/entry/vdso/Makefile
> +++ b/arch/x86/entry/vdso/Makefile
> @@ -24,6 +24,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)	:= y
>   
>   # files to link into the vdso
>   vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
> +vobjs-$(VDSO64-y)		+= vsgx_enter_enclave.o
>   
>   # files to link into kernel
>   obj-y				+= vma.o extable.o
> @@ -92,6 +93,7 @@ CFLAGS_REMOVE_vdso-note.o = -pg
>   CFLAGS_REMOVE_vclock_gettime.o = -pg
>   CFLAGS_REMOVE_vgetcpu.o = -pg
>   CFLAGS_REMOVE_vvar.o = -pg
> +CFLAGS_REMOVE_vsgx_enter_enclave.o = -pg
>   
>   #
>   # X32 processes use x32 vDSO to access 64bit kernel data.
> diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso.lds.S
> index 36b644e16272..4bf48462fca7 100644
> --- a/arch/x86/entry/vdso/vdso.lds.S
> +++ b/arch/x86/entry/vdso/vdso.lds.S
> @@ -27,6 +27,7 @@ VERSION {
>   		__vdso_time;
>   		clock_getres;
>   		__vdso_clock_getres;
> +		__vdso_sgx_enter_enclave;
>   	local: *;
>   	};
>   }
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> new file mode 100644
> index 000000000000..9331279b8fa6
> --- /dev/null
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -0,0 +1,169 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include <linux/linkage.h>
> +#include <asm/export.h>
> +#include <asm/errno.h>
> +
> +#include "extable.h"
> +
> +#define EX_LEAF		0*8
> +#define EX_TRAPNR	0*8+4
> +#define EX_ERROR_CODE	0*8+6
> +#define EX_ADDRESS	1*8
> +
> +.code64
> +.section .text, "ax"
> +
> +#ifdef SGX_KERNEL_DOC
> +/**
> + * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> + * @leaf:	ENCLU leaf, must be EENTER or ERESUME
> + * @tcs:	TCS, must be non-NULL
> + * @ex_info:	Optional struct sgx_enclave_exception instance
> + * @callback:	Optional callback function to be called on enclave exit or
> + *		exception
> + *
> + * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
> + * x86-64 ABI, i.e. cannot be called from standard C code. As noted above,
> + * input parameters must be passed via ``%eax``, ``8(%rsp)``, ``0x10(%rsp)`` and
> + * ``0x18(%rsp)``, with the return value passed via ``%eax``. All other
> + * registers will be passed through to the enclave as is. All registers except
> + * ``%rbp`` must be treated as volatile from the caller's perspective, including
> + * but not limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc... Conversely, the
> + * enclave being run **must** preserve the untrusted ``%rbp``.
> + *
> + * ``callback`` has the following signature:
> + * int callback(long rdi, long rsi, long rdx,
> + *		struct sgx_enclave_exinfo *exinfo, long r8, long r9,
> + *		void *tcs, long ursp);
> + * ``callback`` **shall** follow x86_64 ABI. All GPRs **except** ``%rax``,
> + * ``%rbx`` and ``rcx`` are passed through to ``callback``. ``%rdi``, ``%rsi``,
> + * ``%rdx``, ``%r8``, ``%r9``, along with the value of ``%rsp`` when the enclave
> + * exited/excepted, can be accessed directly as input parameters, while other
> + * GPRs can be accessed in assembly if needed.  A positive value returned from
> + * ``callback`` will be treated as an ENCLU leaf (e.g. EENTER/ERESUME) to
> + * reenter the enclave (without popping the extra data pushed by the enclave off
> + * the stack), while 0 (zero) or a negative return value will be passed back to
> + * the caller of __vdso_sgx_enter_enclave(). It is also safe to leave
> + * ``callback`` via ``longjmp()`` or by throwing a C++ exception.
> + *
> + * Return:
> + *    0 on success,
> + *    -EINVAL if ENCLU leaf is not allowed,
> + *    -EFAULT if ENCL or the enclave faults or non-positive value is returned
> + *     from the callback.
> + */
> +typedef int (*sgx_callback)(long rdi, long rsi, long rdx,
> +			    struct sgx_enclave_exinfo *exinfo, long r8,
> +			    long r9, void *tcs, long ursp);
> +int __vdso_sgx_enter_enclave(int leaf, void *tcs,
> +			     struct sgx_enclave_exinfo *exinfo,
> +			     sgx_callback callback)

I may not have invoked kernel-doc properly but it seems kernel-doc isn't 
able to pick up the parameters correctly.
