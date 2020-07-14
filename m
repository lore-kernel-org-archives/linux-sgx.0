Return-Path: <SRS0=Ypn8=AZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0ECC433E5
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jul 2020 11:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C90122201
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jul 2020 11:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgGNLig (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Jul 2020 07:38:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:34288 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgGNLif (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 Jul 2020 07:38:35 -0400
IronPort-SDR: SmvZ08RtyydZXGJnnJTsFwDnBKv28WdZXHL5z/8frNKEpjvNNa7/hdnQHzUIQzSvaqIB/r2v0b
 UtvkHKJmavvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="148877249"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="148877249"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 04:38:34 -0700
IronPort-SDR: TfN49Isde+x9FpipDxnhPjJBAtBS+4rw3tXDearN898DYP7ezRDo28sNxqWY3Pt6CXz8FhjjIV
 7Yo8qBKK+w/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="459659896"
Received: from pipper-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.46.185])
  by orsmga005.jf.intel.com with ESMTP; 14 Jul 2020 04:38:22 -0700
Date:   Tue, 14 Jul 2020 14:38:21 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v35 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200714113821.GA1463346@linux.intel.com>
References: <20200707033747.142828-1-jarkko.sakkinen@linux.intel.com>
 <20200707033747.142828-22-jarkko.sakkinen@linux.intel.com>
 <dcebec2e-ea46-48ec-e49b-292b10282373@fortanix.com>
 <20200714095649.GC1442951@linux.intel.com>
 <dedb73fd-f543-e0e3-dff8-b4150c22bd94@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dedb73fd-f543-e0e3-dff8-b4150c22bd94@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 14, 2020 at 12:07:54PM +0200, Jethro Beekman wrote:
> On 2020-07-14 11:56, Jarkko Sakkinen wrote:
> > On Tue, Jul 14, 2020 at 09:30:03AM +0200, Jethro Beekman wrote:
> >> On 2020-07-07 05:37, Jarkko Sakkinen wrote:
> >>> From: Sean Christopherson <sean.j.christopherson@intel.com>
> >>>
> >>> An SGX runtime must be aware of the exceptions, which happen inside an
> >>> enclave. Introduce a vDSO call that wraps EENTER/ERESUME cycle and returns
> >>> the CPU exception back to the caller exactly when it happens.
> >>>
> >>> Kernel fixups the exception information to RDI, RSI and RDX. The SGX call
> >>> vDSO handler fills this information to the user provided buffer or
> >>> alternatively trigger user provided callback at the time of the exception.
> >>>
> >>> The calling convention is custom and does not follow System V x86-64 ABI.
> >>>
> >>> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> >>> Acked-by: Jethro Beekman <jethro@fortanix.com>
> >>> Tested-by: Jethro Beekman <jethro@fortanix.com>
> >>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >>> Co-developed-by: Cedric Xing <cedric.xing@intel.com>
> >>> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> >>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> >>> ---
> >>>  arch/x86/entry/vdso/Makefile             |   2 +
> >>>  arch/x86/entry/vdso/vdso.lds.S           |   1 +
> >>>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 131 +++++++++++++++++++++++
> >>>  arch/x86/include/asm/enclu.h             |   8 ++
> >>>  arch/x86/include/uapi/asm/sgx.h          |  98 +++++++++++++++++
> >>>  5 files changed, 240 insertions(+)
> >>>  create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
> >>>  create mode 100644 arch/x86/include/asm/enclu.h
> >>>
> >>> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
> >>> index ebe82b7aecda..f71ad5ebd0c4 100644
> >>> --- a/arch/x86/entry/vdso/Makefile
> >>> +++ b/arch/x86/entry/vdso/Makefile
> >>> @@ -29,6 +29,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)	:= y
> >>>  vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
> >>>  vobjs32-y := vdso32/note.o vdso32/system_call.o vdso32/sigreturn.o
> >>>  vobjs32-y += vdso32/vclock_gettime.o
> >>> +vobjs-$(VDSO64-y)		+= vsgx_enter_enclave.o
> >>>  
> >>>  # files to link into kernel
> >>>  obj-y				+= vma.o extable.o
> >>> @@ -100,6 +101,7 @@ $(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS
> >>>  CFLAGS_REMOVE_vclock_gettime.o = -pg
> >>>  CFLAGS_REMOVE_vdso32/vclock_gettime.o = -pg
> >>>  CFLAGS_REMOVE_vgetcpu.o = -pg
> >>> +CFLAGS_REMOVE_vsgx_enter_enclave.o = -pg
> >>>  
> >>>  #
> >>>  # X32 processes use x32 vDSO to access 64bit kernel data.
> >>> diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso.lds.S
> >>> index 36b644e16272..4bf48462fca7 100644
> >>> --- a/arch/x86/entry/vdso/vdso.lds.S
> >>> +++ b/arch/x86/entry/vdso/vdso.lds.S
> >>> @@ -27,6 +27,7 @@ VERSION {
> >>>  		__vdso_time;
> >>>  		clock_getres;
> >>>  		__vdso_clock_getres;
> >>> +		__vdso_sgx_enter_enclave;
> >>>  	local: *;
> >>>  	};
> >>>  }
> >>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >>> new file mode 100644
> >>> index 000000000000..be7e467e1efb
> >>> --- /dev/null
> >>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >>> @@ -0,0 +1,131 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0 */
> >>> +
> >>> +#include <linux/linkage.h>
> >>> +#include <asm/export.h>
> >>> +#include <asm/errno.h>
> >>> +#include <asm/enclu.h>
> >>> +
> >>> +#include "extable.h"
> >>> +
> >>> +#define EX_LEAF		0*8
> >>> +#define EX_TRAPNR	0*8+4
> >>> +#define EX_ERROR_CODE	0*8+6
> >>> +#define EX_ADDRESS	1*8
> >>> +
> >>> +.code64
> >>> +.section .text, "ax"
> >>> +
> >>> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >>> +	/* Prolog */
> >>> +	.cfi_startproc
> >>> +	push	%rbp
> >>> +	.cfi_adjust_cfa_offset	8
> >>> +	.cfi_rel_offset		%rbp, 0
> >>> +	mov	%rsp, %rbp
> >>> +	.cfi_def_cfa_register	%rbp
> >>> +	push	%rbx
> >>> +	.cfi_rel_offset		%rbx, -8
> >>> +
> >>> +	mov	%ecx, %eax
> >>> +.Lenter_enclave:
> >>> +	/* EENTER <= leaf <= ERESUME */
> >>> +	cmp	$EENTER, %eax
> >>> +	jb	.Linvalid_leaf
> >>> +	cmp	$ERESUME, %eax
> >>> +	ja	.Linvalid_leaf
> >>> +
> >>> +	/* Load TCS and AEP */
> >>> +	mov	0x10(%rbp), %rbx
> >>> +	lea	.Lasync_exit_pointer(%rip), %rcx
> >>> +
> >>> +	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> >>> +.Lasync_exit_pointer:
> >>> +.Lenclu_eenter_eresume:
> >>> +	enclu
> >>
> >> After thinking about this some more, I'd like to come back to this
> >> setup. Prior discussion at https://lkml.org/lkml/2018/11/2/597 . I
> >> hope I'm not derailing the discussion so much as to delay the patch
> >> set :(
> >>
> >> I previously mentioned “Userspace may want fine-grained control over
> >> enclave scheduling” as a reason userspace may want to specify a
> >> different AEP, but gave a bad example. Here's a better example: If I'm
> >> running my enclave in an M:N threading model (where M user threads run
> >> N TCSs, with N > M), an AEX is a good oppurtunity to switch contexts.
> >> Yes, I could implement this with alarm() or so, but that adds overhead
> >> while missing out on a lot of opportunities for context switching.
> > 
> > The vDSO interface also provides optional callback. Wonder if that
> > works for this or can it be refined to work for this?
> 
> Yeah I think if the callback was called instead of ENCLU, the callback
> has the opportunity to return non-positive which will trigger a return
> from __vdso_sgx_enter_enclave. Moving .Lasync_exit_pointer to
> .Lhandle_exit might be sufficient. But I imagine not all users would
> want this behavior (although calling the few userspace instructions is
> likely negligible compared to the actual ERESUME).

Have you tried the callback interface if it suits for your workload?

/Jarkko
