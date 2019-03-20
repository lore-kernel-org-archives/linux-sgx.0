Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD709C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 18:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AA602175B
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 18:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfCTSa3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 14:30:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:32556 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727196AbfCTSa2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 14:30:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 11:30:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="127137795"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2019 11:30:27 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 20 Mar 2019 11:30:27 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.81]) with mapi id 14.03.0415.000;
 Wed, 20 Mar 2019 11:30:27 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Haitao Huang" <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Topic: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fw
Date:   Wed, 20 Mar 2019 18:30:26 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2E4OTNhZDQtZWI2ZS00MDRmLTliMmUtYjU2Mjk4ZmE1YzMzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidW1sdnlmTnpLK3BEeHdIN2FncE4xdURXSVd5STA1U3h6TjFlMlFpd1lnbENoQTB1U2MrMjRCSUdzVlg3a1RBQiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> +/**
> + * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> + *
> + * %eax:        ENCLU leaf, must be EENTER or ERESUME
> + * %rbx:        TCS, must be non-NULL
> + * %rcx:        Optional pointer to 'struct sgx_enclave_exception'
> + *
> + * Return:
> + *  0 on a clean entry/exit to/from the enclave
> + *  -EINVAL if ENCLU leaf is not allowed or if TCS is NULL
> + *  -EFAULT if ENCLU or the enclave faults
> + *
> + * Note that __vdso_sgx_enter_enclave() is not compliant with the x86-
> 64 ABI.
> + * All registers except RSP must be treated as volatile from the
> +caller's
> + * perspective, including but not limited to GPRs, EFLAGS.DF, MXCSR,
> FCW, etc...
> + * Conversely, the enclave being run must preserve the untrusted RSP
> and stack.

By requiring preservation of RSP at both AEX and EEXIT, this precludes the possibility of using the untrusted stack as temporary storage by enclaves. While that looks reasonable at first glance, I'm afraid it isn't the case in reality. The untrusted stack is inarguably the most convenient way for data exchange between an enclave and its enclosing process, and is in fact being used for that purpose by almost all existing enclaves to date. Given the expectation that this API will be used by all future SGX application, it looks unwise to ban the most convenient and commonly used approach for data exchange.

Given an enclave can touch everything (registers and memory) of the enclosing process, it's reasonable to restrict the enclave by means of "calling convention" to allow the enclosing process to retain its context. And for that purpose, SGX ISA does offer 2 registers (i.e. RSP and RBP) for applications to choose. Instead of preserving RSP, I'd prefer RBP, which will end up with more flexibility in all SGX applications in future.

> + * __vdso_sgx_enter_enclave(u32 leaf, void *tcs,
> + *			    struct sgx_enclave_exception *exception_info)
> + * {
> + *	if (leaf != SGX_EENTER && leaf != SGX_ERESUME)
> + *		return -EINVAL;
> + *
> + *	if (!tcs)
> + *		return -EINVAL;
> + *
> + *	try {
> + *		ENCLU[leaf];
> + *	} catch (exception) {
> + *		if (e)
> + *	 		*e = exception;
> + *		return -EFAULT;
> + *	}
> + *
> + *	return 0;
> + * }
> + */
> +ENTRY(__vdso_sgx_enter_enclave)
> +	/* EENTER <= leaf <= ERESUME */
> +	cmp	$0x2, %eax
> +	jb	bad_input
> +
> +	cmp	$0x3, %eax
> +	ja	bad_input
> +
> +	/* TCS must be non-NULL */
> +	test	%rbx, %rbx
> +	je	bad_input
> +
> +	/* Save @exception_info */
> +	push	%rcx
> +
> +	/* Load AEP for ENCLU */
> +	lea	1f(%rip),  %rcx
> +1:	enclu
> +
> +	add	$0x8, %rsp
> +	xor	%eax, %eax
> +	ret
> +
> +bad_input:
> +	mov     $(-EINVAL), %rax
> +	ret
> +
> +.pushsection .fixup, "ax"
> +	/* Re-load @exception_info and fill it (if it's non-NULL) */
> +2:	pop	%rcx
> +	test    %rcx, %rcx
> +	je      3f
> +
> +	mov	%eax, EX_LEAF(%rcx)
> +	mov	%di,  EX_TRAPNR(%rcx)
> +	mov	%si,  EX_ERROR_CODE(%rcx)
> +	mov	%rdx, EX_ADDRESS(%rcx)
> +3:	mov	$(-EFAULT), %rax
> +	ret
> +.popsection
> +
> +_ASM_VDSO_EXTABLE_HANDLE(1b, 2b)
> +
> +ENDPROC(__vdso_sgx_enter_enclave)

Rather than preserving RSP, an alternative that preserves RBP will allow more flexibility inside SGX applications. Below is the assembly code based on that idea, that offers a superset of functionality over the current patch, yet at a cost of just 9 more lines of code (23 LOC here vs. 14 LOC in the patch).

/**
 * __vdso_sgx_enter_enclave() - Enter an SGX enclave
 *
 * %eax:        ENCLU leaf, must be either EENTER or ERESUME
 * 0x08(%rsp):  TCS
 * 0x10(%rsp):  Optional pointer to 'struct sgx_enclave_exception'
 * 0x18(%rsp):  Optional function pointer to 'sgx_exit_handler', defined below
 *              typedef int (*sgx_exit_handler)(struct sgx_enclave_exception *ex_info);
 * return:      Non-negative integer to indicate success, or a negative error
 *              code on failure.
 *
 * Note that __vdso_sgx_enter_enclave() is not compatible with x86_64 ABI.
 * All registers except RBP must be treated as volatile from the caller's
 * perspective, including but not limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc...
 * Enclave may decrement RSP, but must not increment it - i.e. existing content
 * of the stack shall be preserved.
 */
__vdso_sgx_enter_enclave:
        push    %rbp
        mov     %rsp, %rbp

        /* EENTER <= leaf <= ERESUME */
1:      cmp     $0x2, %eax
        jb      bad_input
        cmp     $0x3, %eax
        ja      bad_leaf

        /* Load TCS and AEP */
        mov     0x10(%rbp), %rbx
        lea     2f(%rip), %rcx

2:      enclu

        mov     0x18(%rbp), %rcx
        jrcxz   3f
        /* Besides leaf, this instruction also zeros trapnr and error_code */
        mov     %rax, EX_LEAF(%rcx)

3:      mov     %rcx, %rdi
        mov     0x20(%rbp), %rcx
        jrcxz   4f
        call    *%rcx
        jmp     1b

4:      leave
        ret

bad_leaf:
        cmp     $0, %eax
        jle     4b
        mov     $(-EINVAL), %eax
        jmp     4b

.pushsection    .fixup, "ax"
5:      mov     0x18(%rbp), %rcx
        jrcxz   6f
        mov     %eax, EX_LEAF(%rcx)
        mov     %di, EX_TRAPNR(%rcx)
        mov     %si, EX_ERROR_CODE(%rcx)
        mov     %rdx, EX_ADDRESS(%rcx)
6:      mov     $(-EFAULT), %eax
        jmp     3b
.popsection

_ASM_VDSO_EXTABLE_HANDLE(2b, 5b)

