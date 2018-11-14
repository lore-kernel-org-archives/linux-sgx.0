Return-Path: <SRS0=MATl=NZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB1BC07E85
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Nov 2018 16:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA45922360
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Nov 2018 16:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA45922360
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbeKOCNe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Nov 2018 21:13:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:23225 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbeKOCNd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 14 Nov 2018 21:13:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2018 08:09:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,233,1539673200"; 
   d="scan'208";a="281047338"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga006.fm.intel.com with ESMTP; 14 Nov 2018 08:09:42 -0800
Date:   Wed, 14 Nov 2018 08:09:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, Shuah Khan <shuah@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andy Lutomirski <luto@kernel.org>,
        Dmitry Safonov <dima@arista.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH RFC] selftests/x86: Add a selftest for SGX
Message-ID: <20181114160941.GA1387@linux.intel.com>
References: <20181113214038.16136-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113214038.16136-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 13, 2018 at 11:40:09PM +0200, Jarkko Sakkinen wrote:
> Add a selftest for SGX. It is a trivial test where a simple enclave
> copies one 64-bit word of memory between two memory locations given to
> the enclave as arguments.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> +SUBDIRS_64 := sgx
> +ASSERT(!DEFINED(.altinstructions), "ALTERNATIVES are not supported in the SGX LE")
> +ASSERT(!DEFINED(.altinstr_replacement), "ALTERNATIVES are not supported in the SGX LE")
> +ASSERT(!DEFINED(.discard.retpoline_safe), "RETPOLINE ALTERNATIVES are not supported in the SGX LE")
> +ASSERT(!DEFINED(.discard.nospec), "RETPOLINE ALTERNATIVES are not supported in the SGX LE")

Maybe this?

s/LE/Test Enclave

> diff --git a/tools/testing/selftests/x86/sgx/encl_bootstrap.S b/tools/testing/selftests/x86/sgx/encl_bootstrap.S
> new file mode 100644
> index 000000000000..62251c7d9927
> --- /dev/null
> +++ b/tools/testing/selftests/x86/sgx/encl_bootstrap.S
> @@ -0,0 +1,94 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +/*
> + * Copyright(c) 2016-18 Intel Corporation.
> + */
> +
> +	.macro ENCLU
> +	.byte 0x0f, 0x01, 0xd7
> +	.endm
> +
> +	.section ".tcs", "a"
> +	.balign	4096
> +
> +	.fill	1, 8, 0			# STATE (set by CPU)
> +	.fill	1, 8, 0			# FLAGS
> +	.long	encl_ssa		# OSSA

Any reason not to do .quad for OSSA and OENTRY?

> +	.fill	1, 4, 0
> +	.fill	1, 4, 0			# CSSA (set by CPU)
> +	.fill	1, 4, 1			# NSSA
> +	.long	encl_entry		# OENTRY
> +	.fill	1, 4, 0
> +	.fill	1, 8, 0			# AEP (set by EENTER and ERESUME)
> +	.fill	1, 8, 0			# OFSBASE
> +	.fill	1, 8, 0			# OGSBASE
> +	.fill	1, 4, 0xFFFFFFFF 	# FSLIMIT
> +	.fill	1, 4, 0xFFFFFFFF	# GSLIMIT
> +	.fill	503, 8, 0		# Reserved

I'd prefer to do 1-byte fill with a size of 4024 to match the SDM.

> +
> +	.text
> +
> +encl_entry:
> +	# %rbx contains the base address for TCS, which is also the first
> +	# address inside the enclave. By adding $le_stack_end to it, we get the
> +	# absolute address for the stack.
> +	lea	(encl_stack)(%rbx), %rax
> +	xchg	%rsp, %rax
> +	push	%rax
> +
> +	push	%rcx # push the address after EENTER
> +	push	%rbx # push the enclave base address
> +
> +	call	encl_body
> +
> +	pop	%rbx # pop the enclave base address
> +
> +	# Restore XSAVE registers to a synthetic state.
> +	mov     $0xFFFFFFFF, %rax
> +	mov     $0xFFFFFFFF, %rdx
> +	lea	(xsave_area)(%rbx), %rdi
> +	fxrstor	(%rdi)
> +
> +	# Clear GPRs
> +	xor     %rcx, %rcx
> +	xor     %rdx, %rdx
> +	xor     %rdi, %rdi
> +	xor     %rsi, %rsi
> +	xor     %r8, %r8
> +	xor     %r9, %r9
> +	xor     %r10, %r10
> +	xor     %r11, %r11
> +	xor     %r12, %r12
> +	xor     %r13, %r13
> +	xor     %r14, %r14
> +	xor     %r15, %r15
> +
> +	# Reset status flags
> +	add     %rdx, %rdx # OF = SF = AF = CF = 0; ZF = PF = 1
> +
> +	pop	%rbx # pop the address after EENTER

Probably worth expanding the comment to explain that ENCLU[EEXIT] takes the
target address via %rbx, i.e. we're "returning" from the EENTER "call".

> +
> +	# Restore the caller stack.
> +	pop	%rax
> +	mov	%rax, %rsp
> +
> +	# EEXIT
> +	mov	$4, %rax
> +	enclu
> +
> +	.section ".data", "aw"
> +
> +encl_ssa:
> +	.space 4096
> +
> +xsave_area:
> +	.fill	1, 4, 0x037F		# FCW
> +	.fill	5, 4, 0
> +	.fill	1, 4, 0x1F80		# MXCSR
> +	.fill	1, 4, 0xFFFF		# MXCSR_MASK
> +	.fill	123, 4, 0
> +	.fill	1, 4, 0x80000000	# XCOMP_BV[63] = 1, compaction mode
> +	.fill	12, 4, 0
> +
> +	.balign 4096
> +	.space 8192
> +encl_stack:
