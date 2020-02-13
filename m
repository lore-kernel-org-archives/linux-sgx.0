Return-Path: <SRS0=OjbW=4B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EC8C2BA83
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Feb 2020 13:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54ED6222C2
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Feb 2020 13:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="HOaayirW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgBMNaA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Feb 2020 08:30:00 -0500
Received: from mail-dm6nam11on2132.outbound.protection.outlook.com ([40.107.223.132]:59297
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729588AbgBMN37 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Feb 2020 08:29:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvWMHCJWy3vVKUiHYChHGpAbdhkae9efL6CQ+FDxAvZ6wunJNqh69yZGEKBVTG/pjRgfF+cFmExnW9WpULbiFMfsTBNJIE90Rhowz6suKqilMMNw1n2ZVfh1cOOjdtRym+ZF7SJq6DVpdvYChD9LoxXWqqvX6cKL+fQA7UdUAugKRurtgyO7AGm1hA9y1I8YpWGQm6OwXrzYXrWFF3/umMHdsZ80WKWZTdGAocVvvvkA6oGhwsTgFUW+tWXGt/Wvk+MGruBtOaQChU1OZ1Qc5i1gaW7lxZYEBc+HDBuS7CZjYvtLYy5TuT9Eb93J/p7TaeIfVsP8b03o2wrdaDaoeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVmaogsyZvX8ij3vibQhdy/ko6E0z2tez6rzoA1i1Vo=;
 b=Fqg0LtM8jbLoYeR7lKTK10u0JmVyxiAFFXHRLUCA6ibjM8hKA0zRuo+lT0uWLre0I2sm1aJbrAx1Cab+iNrJy97GdEyAflMDZg3dh2lIDux+npnhLtHsQ4GzmxpZmLJiIGegJfj5/0PqSsKq7uES4b4aGAVW04WbpKktVRbXYFloR+jc5MQ0Z66FyFme8/X9oBOHc4PzCXhs1qtXJnYtGFMWcxiq7b2CwC9/S17bEaFj+8Xa+5sKJ5cI4JNw7Fo/CtG03IleAx3MKTXLD6Lp56qSPAATVHhMfhnGJl3ypn40qLyqdD8a3CddtzMr45ar8RWenybl4QLE1GTNuaORPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVmaogsyZvX8ij3vibQhdy/ko6E0z2tez6rzoA1i1Vo=;
 b=HOaayirWjlZV+7PMLvWl55E8HSU95SL35T/gIWKS6ywc65YG7mA+vjE9CPt7PwRviMISwLXJiiA1rwgExYnoM+AALDjLUtUpDJi1ZGgfZVLmBpI9yro4T/W+y4eVUpi5y3DoiHZC71nFEh0BmcgvIXpo9C+GousQCPEWUsrKU80=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (20.178.239.29) by
 BYAPR11MB3141.namprd11.prod.outlook.com (20.177.226.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.25; Thu, 13 Feb 2020 13:29:55 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99%7]) with mapi id 15.20.2729.025; Thu, 13 Feb 2020
 13:29:54 +0000
Subject: Re: [PATCH v26 19/22] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Andy Lutomirski <luto@amacapital.net>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-20-jarkko.sakkinen@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <2b61b106-4dfd-ed47-3333-99280e33ca88@fortanix.com>
Date:   Thu, 13 Feb 2020 14:29:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200209212609.7928-20-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0323.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::23) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
Received: from [10.195.0.226] (212.61.132.179) by LO2P265CA0323.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a4::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Thu, 13 Feb 2020 13:29:50 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c06abc3b-2b29-4a7d-a969-08d7b088cfde
X-MS-TrafficTypeDiagnostic: BYAPR11MB3141:
X-Microsoft-Antispam-PRVS: <BYAPR11MB31414E16576441FB397297B2AA1A0@BYAPR11MB3141.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39840400004)(376002)(346002)(136003)(189003)(199004)(2906002)(6666004)(66556008)(30864003)(8936002)(66476007)(36756003)(4326008)(6486002)(16526019)(8676002)(31696002)(186003)(66946007)(5660300002)(81156014)(26005)(52116002)(2616005)(316002)(7416002)(508600001)(86362001)(31686004)(16576012)(81166006)(956004)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3141;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MzP5jZtc3Ai93UDL2YLBBQOJ7DfMbHimX6GkEZoTPwjbRf70Mj9hPvrev957Y2zKch8P02QykOVm/aWOFLKHOLQxH6paoaDuk7OxxAfDpnBG1TZWVC91+BbL8hzO/dDjCd3Yud98VpSdFriMVPGsdpQoTLCvxTW9B4OAMFStMTwXs8VgP65AWsU0m5mjDYpn0nsUy/LPuWsIlGV5IMK0+NDhj40wlVuyKuvBy9aWc6w3hinVPddjLBSwjn6vfgwBmXx0ErqVeRXLm7TPluFl4YpxHoDebrL+UR0u461yCk+gKDxc4FihuzrHf8LrHvo0HGLwfmXkbA4QkosCWC/o5yGSmDtHvCkRh3yvQXXax/5sfkJDXUQJWdGuQ71cf9JrqV7w1It6s3CS1+89LSssecksZXmZgiPH6Lbe5raQ25ZTCXkh3O+QUz0hZvk4aYYS
X-MS-Exchange-AntiSpam-MessageData: ipmf+MhziyD8LCQxTgWYDChrVVNtqUO5iw4Dbb3Fwl+C1ggWVk8grUlHTaBsrjHe3jNyVcd+kXXZ5ft4DDCYjbtqXIC7/0yeKzbsGD+fotbJhF1Ov6/8no5AvaIR7z6sX4nr707/BVYRjUUv9ttYnw==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c06abc3b-2b29-4a7d-a969-08d7b088cfde
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 13:29:54.9079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: subjbTyqC2dfl0bVkqay3Pfkl6qJCdtXfAw/eBSrQ7TFTYEN+Lb5aJHncdOnohzM/yfSzmjFiFEy782jUl6GJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3141
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Tested-by: Jethro Beekman <jethro@fortanix.com>

--
Jethro Beekman | Fortanix

On 2020-02-09 22:26, Jarkko Sakkinen wrote:
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
>   1) Save/restore non-volatile GPRs, MXCSR and FCW, and clear EFLAGS.DF
> 
>      + 100% compliant with the x86-64 ABI
>      + Callable from any code
>      + Minimal documentation required
>      - Restoring MXCSR/FCW is likely unnecessary 99% of the time
>      - Slow
> 
>   2) Save/restore non-volatile GPRs and clear EFLAGS.DF
> 
>      + Mostly compliant with the x86-64 ABI
>      + Callable from any code that doesn't use SIMD registers
>      - Need to document deviations from x86-64 ABI, i.e. MXCSR and FCW
> 
>   3) Require the caller to save/restore everything.
> 
>      + Fast
>      + Userspace can pass all GPRs to the enclave (minus EAX, RBX and RCX)
>      - Custom ABI
>      - For all intents and purposes must be called from an assembly wrapper
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
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Cedric Xing <cedric.xing@intel.com>
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/entry/vdso/Makefile             |   2 +
>  arch/x86/entry/vdso/vdso.lds.S           |   1 +
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 187 +++++++++++++++++++++++
>  arch/x86/include/uapi/asm/sgx.h          |  37 +++++
>  4 files changed, 227 insertions(+)
>  create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
> 
> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
> index 629053b77e4a..d1d609d1626e 100644
> --- a/arch/x86/entry/vdso/Makefile
> +++ b/arch/x86/entry/vdso/Makefile
> @@ -24,6 +24,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)	:= y
>  
>  # files to link into the vdso
>  vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
> +vobjs-$(VDSO64-y)		+= vsgx_enter_enclave.o
>  
>  # files to link into kernel
>  obj-y				+= vma.o extable.o
> @@ -90,6 +91,7 @@ $(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS
>  CFLAGS_REMOVE_vclock_gettime.o = -pg
>  CFLAGS_REMOVE_vdso32/vclock_gettime.o = -pg
>  CFLAGS_REMOVE_vgetcpu.o = -pg
> +CFLAGS_REMOVE_vsgx_enter_enclave.o = -pg
>  
>  #
>  # X32 processes use x32 vDSO to access 64bit kernel data.
> diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso.lds.S
> index 36b644e16272..4bf48462fca7 100644
> --- a/arch/x86/entry/vdso/vdso.lds.S
> +++ b/arch/x86/entry/vdso/vdso.lds.S
> @@ -27,6 +27,7 @@ VERSION {
>  		__vdso_time;
>  		clock_getres;
>  		__vdso_clock_getres;
> +		__vdso_sgx_enter_enclave;
>  	local: *;
>  	};
>  }
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> new file mode 100644
> index 000000000000..94a8e5f99961
> --- /dev/null
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -0,0 +1,187 @@
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
> +/**
> + * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> + * @leaf:	ENCLU leaf, must be EENTER or ERESUME
> + * @tcs:	TCS, must be non-NULL
> + * @e:		Optional struct sgx_enclave_exception instance
> + * @handler:	Optional enclave exit handler
> + *
> + * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
> + * x86-64 ABI, i.e. cannot be called from standard C code.
> + *
> + * Input ABI:
> + *  @leaf	%eax
> + *  @tcs	8(%rsp)
> + *  @e 		0x10(%rsp)
> + *  @handler	0x18(%rsp)
> + *
> + * Output ABI:
> + *  @ret	%eax
> + *
> + * All general purpose registers except RAX, RBX and RCX are passed as-is to
> + * the enclave. RAX, RBX and RCX are consumed by EENTER and ERESUME and are
> + * loaded with @leaf, asynchronous exit pointer, and @tcs respectively.
> + *
> + * RBP and the stack are used to anchor __vdso_sgx_enter_enclave() to the
> + * pre-enclave state, e.g. to retrieve @e and @handler after an enclave exit.
> + * All other registers are available for use by the enclave and its runtime,
> + * e.g. an enclave can push additional data onto the stack (and modify RSP) to
> + * pass information to the optional exit handler (see below).
> + *
> + * Most exceptions reported on ENCLU, including those that occur within the
> + * enclave, are fixed up and reported synchronously instead of being delivered
> + * via a standard signal. Debug Exceptions (#DB) and Breakpoints (#BP) are
> + * never fixed up and are always delivered via standard signals. On synchrously
> + * reported exceptions, -EFAULT is returned and details about the exception are
> + * recorded in @e, the optional sgx_enclave_exception struct.
> +
> + * If an exit handler is provided, the handler will be invoked on synchronous
> + * exits from the enclave and for all synchronously reported exceptions. In
> + * latter case, @e is filled prior to invoking the handler.
> + *
> + * The exit handler's return value is interpreted as follows:
> + *  >0:		continue, restart __vdso_sgx_enter_enclave() with @ret as @leaf
> + *   0:		success, return @ret to the caller
> + *  <0:		error, return @ret to the caller
> + *
> + * The userspace exit handler is responsible for unwinding the stack, e.g. to
> + * pop @e, u_rsp and @tcs, prior to returning to __vdso_sgx_enter_enclave().
> + * The exit handler may also transfer control, e.g. via longjmp() or a C++
> + * exception, without returning to __vdso_sgx_enter_enclave().
> + *
> + * Return:
> + *  0 on success,
> + *  -EINVAL if ENCLU leaf is not allowed,
> + *  -EFAULT if an exception occurs on ENCLU or within the enclave
> + *  -errno for all other negative values returned by the userspace exit handler
> + */
> +#ifdef SGX_KERNEL_DOC
> +/* C-style function prototype to coerce kernel-doc into parsing the comment. */
> +int __vdso_sgx_enter_enclave(int leaf, void *tcs,
> +			     struct sgx_enclave_exception *e,
> +			     sgx_enclave_exit_handler_t handler);
> +#endif
> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> +	/* Prolog */
> +	.cfi_startproc
> +	push	%rbp
> +	.cfi_adjust_cfa_offset	8
> +	.cfi_rel_offset		%rbp, 0
> +	mov	%rsp, %rbp
> +	.cfi_def_cfa_register	%rbp
> +
> +.Lenter_enclave:
> +	/* EENTER <= leaf <= ERESUME */
> +	cmp	$0x2, %eax
> +	jb	.Linvalid_leaf
> +	cmp	$0x3, %eax
> +	ja	.Linvalid_leaf
> +
> +	/* Load TCS and AEP */
> +	mov	0x10(%rbp), %rbx
> +	lea	.Lasync_exit_pointer(%rip), %rcx
> +
> +	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> +.Lasync_exit_pointer:
> +.Lenclu_eenter_eresume:
> +	enclu
> +
> +	/* EEXIT jumps here unless the enclave is doing something fancy. */
> +	xor	%eax, %eax
> +
> +	/* Invoke userspace's exit handler if one was provided. */
> +.Lhandle_exit:
> +	cmp	$0, 0x20(%rbp)
> +	jne	.Linvoke_userspace_handler
> +
> +.Lout:
> +	leave
> +	.cfi_def_cfa		%rsp, 8
> +	ret
> +
> +	/* The out-of-line code runs with the pre-leave stack frame. */
> +	.cfi_def_cfa		%rbp, 16
> +
> +.Linvalid_leaf:
> +	mov	$(-EINVAL), %eax
> +	jmp	.Lout
> +
> +.Lhandle_exception:
> +	mov	0x18(%rbp), %rcx
> +	test    %rcx, %rcx
> +	je	.Lskip_exception_info
> +
> +	/* Fill optional exception info. */
> +	mov	%eax, EX_LEAF(%rcx)
> +	mov	%di,  EX_TRAPNR(%rcx)
> +	mov	%si,  EX_ERROR_CODE(%rcx)
> +	mov	%rdx, EX_ADDRESS(%rcx)
> +.Lskip_exception_info:
> +	mov	$(-EFAULT), %eax
> +	jmp	.Lhandle_exit
> +
> +.Linvoke_userspace_handler:
> +	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
> +	mov	%rsp, %rcx
> +
> +	/* Save the untrusted RSP in %rbx (non-volatile register). */
> +	mov	%rsp, %rbx
> +
> +	/*
> +	 * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
> +	 * _after_ pushing the parameters on the stack, hence the bonus push.
> +	 */
> +	and	$-0x10, %rsp
> +	push	%rax
> +
> +	/* Push @e, the "return" value and @tcs as params to the callback. */
> +	push	0x18(%rbp)
> +	push	%rax
> +	push	0x10(%rbp)
> +
> +	/* Clear RFLAGS.DF per x86_64 ABI */
> +	cld
> +
> +	/* Load the callback pointer to %rax and invoke it via retpoline. */
> +	mov	0x20(%rbp), %rax
> +	call	.Lretpoline
> +
> +	/* Restore %rsp to its post-exit value. */
> +	mov	%rbx, %rsp
> +
> +	/*
> +	 * If the return from callback is zero or negative, return immediately,
> +	 * else re-execute ENCLU with the postive return value interpreted as
> +	 * the requested ENCLU leaf.
> +	 */
> +	cmp	$0, %eax
> +	jle	.Lout
> +	jmp	.Lenter_enclave
> +
> +.Lretpoline:
> +	call	2f
> +1:	pause
> +	lfence
> +	jmp	1b
> +2:	mov	%rax, (%rsp)
> +	ret
> +	.cfi_endproc
> +
> +_ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
> +
> +SYM_FUNC_END(__vdso_sgx_enter_enclave)
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 57d0d30c79b3..e196cfd44b70 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -74,4 +74,41 @@ struct sgx_enclave_set_attribute {
>  	__u64 attribute_fd;
>  };
>  
> +/**
> + * struct sgx_enclave_exception - structure to report exceptions encountered in
> + *				  __vdso_sgx_enter_enclave()
> + *
> + * @leaf:	ENCLU leaf from \%eax at time of exception
> + * @trapnr:	exception trap number, a.k.a. fault vector
> + * @error_code:	exception error code
> + * @address:	exception address, e.g. CR2 on a #PF
> + * @reserved:	reserved for future use
> + */
> +struct sgx_enclave_exception {
> +	__u32 leaf;
> +	__u16 trapnr;
> +	__u16 error_code;
> +	__u64 address;
> +	__u64 reserved[2];
> +};
> +
> +/**
> + * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
> + *					__vdso_sgx_enter_enclave()
> + *
> + * @rdi:	RDI at the time of enclave exit
> + * @rsi:	RSI at the time of enclave exit
> + * @rdx:	RDX at the time of enclave exit
> + * @ursp:	RSP at the time of enclave exit (untrusted stack)
> + * @r8:		R8 at the time of enclave exit
> + * @r9:		R9 at the time of enclave exit
> + * @tcs:	Thread Control Structure used to enter enclave
> + * @ret:	0 on success (EEXIT), -EFAULT on an exception
> + * @e:		Pointer to struct sgx_enclave_exception (as provided by caller)
> + */
> +typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
> +					  long ursp, long r8, long r9,
> +					  void *tcs, int ret,
> +					  struct sgx_enclave_exception *e);
> +
>  #endif /* _UAPI_ASM_X86_SGX_H */
> 
