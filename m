Return-Path: <SRS0=CuW6=XW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE69FC4360C
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 16:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9719620872
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 16:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="XWy65qVU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfI0Q1l (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Sep 2019 12:27:41 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58802 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbfI0Q1l (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 27 Sep 2019 12:27:41 -0400
Received: from zn.tnic (p200300EC2F0ABB004403369600A4C2F6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:bb00:4403:3696:a4:c2f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B85841EC03F6;
        Fri, 27 Sep 2019 18:27:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569601654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bzUHzRHgCzLLNVb4xQdR2HsiS3SSRgRSDcqXL7xXSA8=;
        b=XWy65qVU7edK7EuBN2xvLq2EDLuN3jG9+ieqVlaL8pAH0iGNiE9UUXmdMKMN/iI00y8sHh
        Iq7i1ZnJk7K+7OFT7HXitFjotbKSd1KQWA5jZzmUeWIx68tF5nJYe9UdgQT2F17YzTlLme
        4U+hdUPU1Vb/xVNdeocaQqrKR0p9CC8=
Date:   Fri, 27 Sep 2019 18:27:35 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 06/24] x86/sgx: Add SGX microarchitectural data
 structures
Message-ID: <20190927162735.GC23002@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-7-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190903142655.21943-7-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 03, 2019 at 05:26:37PM +0300, Jarkko Sakkinen wrote:
> Define the SGX microarchitectural data structures used by various SGX
> opcodes. This is not an exhaustive representation of all SGX data
> structures but only those needed by the kernel.
> 
> [1] Intel SDM: 37.6 INTEL® SGX DATA STRUCTURES OVERVIEW

That footnote is not being referred to. Just make it a sentence.

Btw, you could tell your SDM folks to fix formulations like:

"The use of EAX is implied implicitly by the ENCLS, ENCLU, and ENCLV
		   ^^^^^^^^^^^^^^^^^^^

instructions.... The use of additional registers does not use ModR/M
encoding and is implied implicitly by the respective leaf function
		^^^^^^^^^^^^^^^^^^^

index."

"implied" alone wasn't enough I guess. :)

> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/arch.h | 423 +++++++++++++++++++++++++++++++++
>  1 file changed, 423 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/sgx/arch.h
> 
> diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/kernel/cpu/sgx/arch.h
> new file mode 100644
> index 000000000000..725a47f9f761
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/arch.h
> @@ -0,0 +1,423 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +/**
> + * Copyright(c) 2016-18 Intel Corporation.
> + *
> + * Contains data structures defined by the SGX architecture.  Data structures
> + * defined by the Linux software stack should not be placed here.
> + */
> +#ifndef _ASM_X86_SGX_ARCH_H
> +#define _ASM_X86_SGX_ARCH_H
> +
> +#include <linux/types.h>
> +
> +#define SGX_CPUID				0x12
> +#define SGX_CPUID_FIRST_VARIABLE_SUB_LEAF	2
> +
> +/**
> + * enum sgx_sub_leaf_types - SGX CPUID variable sub-leaf types
> + * %SGX_CPUID_SUB_LEAF_INVALID:		Indicates this sub-leaf is invalid.
> + * %SGX_CPUID_SUB_LEAF_EPC_SECTION:	Sub-leaf enumerates an EPC section.
> + */
> +enum sgx_sub_leaf_types {
> +	SGX_CPUID_SUB_LEAF_INVALID	= 0x0,
> +	SGX_CPUID_SUB_LEAF_EPC_SECTION	= 0x1,
> +};
> +
> +#define SGX_CPUID_SUB_LEAF_TYPE_MASK	GENMASK(3, 0)
> +
> +/**
> + * enum sgx_encls_leaves - ENCLS leaf functions
> + * %SGX_ECREATE:	Create an enclave.
> + * %SGX_EADD:		Add a page to an uninitialized enclave.
> + * %SGX_EINIT:		Initialize an enclave, i.e. launch an enclave.
> + * %SGX_EREMOVE:	Remove a page from an enclave.
> + * %SGX_EDBGRD:		Read a word from an enclve (peek).
> + * %SGX_EDBGWR:		Write a word to an enclave (poke).
> + * %SGX_EEXTEND:	Measure 256 bytes of an added enclave page.
> + * %SGX_ELDB:		Load a swapped page in blocked state.
> + * %SGX_ELDU:		Load a swapped page in unblocked state.
> + * %SGX_EBLOCK:		Change page state to blocked i.e. entering hardware
> + *			threads cannot access it and create new TLB entries.
> + * %SGX_EPA:		Create a Version Array (VA) page used to store isvsvn
> + *			number for a swapped EPC page.
> + * %SGX_EWB:		Swap an enclave page to the regular memory. Checks that
> + *			all threads have exited that were in the previous
> + *			shoot-down sequence.
> + * %SGX_ETRACK:		Start a new shoot down sequence. Used to together with
> + *			EBLOCK to make sure that a page is safe to swap.
> + * %SGX_EAUG:		Add a page to an initialized enclave.
> + * %SGX_EMODPR:		Restrict an EPC page's permissions.
> + * %SGX_EMODT:		Modify the page type of an EPC page.
> + */
> +enum sgx_encls_leaves {
> +	SGX_ECREATE	= 0x00,
> +	SGX_EADD	= 0x01,
> +	SGX_EINIT	= 0x02,
> +	SGX_EREMOVE	= 0x03,
> +	SGX_EDGBRD	= 0x04,
> +	SGX_EDGBWR	= 0x05,
> +	SGX_EEXTEND	= 0x06,
> +	SGX_ELDB	= 0x07,
> +	SGX_ELDU	= 0x08,
> +	SGX_EBLOCK	= 0x09,
> +	SGX_EPA		= 0x0A,
> +	SGX_EWB		= 0x0B,
> +	SGX_ETRACK	= 0x0C,
> +	SGX_EAUG	= 0x0D,
> +	SGX_EMODPR	= 0x0E,
> +	SGX_EMODT	= 0x0F,
> +};
> +
> +#define SGX_MODULUS_SIZE 384
> +
> +/**
> + * enum sgx_miscselect - additional information to an SSA frame
> + * %SGX_MISC_EXINFO:	Report #PF or #GP to the SSA frame.
> + *
> + * Save State Area (SSA) is a stack inside the enclave used to store processor
> + * state when an exception or interrupt occurs. This enum defines additional
> + * information stored to an SSA frame.
> + */
> +enum sgx_miscselect {
> +	SGX_MISC_EXINFO		= BIT(0),
> +};
> +
> +#define SGX_MISC_RESERVED_MASK	GENMASK_ULL(63, 1)
> +
> +#define SGX_SSA_GPRS_SIZE		182
> +#define SGX_SSA_MISC_EXINFO_SIZE	16
> +
> +/**
> + * enum sgx_attributes - the attributes field in &struct sgx_secs
> + * %SGX_ATTR_INIT:		Enclave can be entered (is initialized).
> + * %SGX_ATTR_DEBUG:		Allow ENCLS(EDBGRD) and ENCLS(EDBGWR).
> + * %SGX_ATTR_MODE64BIT:		Tell that this a 64-bit enclave.
> + * %SGX_ATTR_PROVISIONKEY:      Allow to use provisioning keys for remote
> + *				attestation.
> + * %SGX_ATTR_KSS:		Allow to use key separation and sharing (KSS).
> + * %SGX_ATTR_EINITTOKENKEY:	Allow to use token signing key that is used to
> + *				sign cryptographic tokens that can be passed to
> + *				EINIT as an authorization to run an enclave.
> + */
> +enum sgx_attribute {
> +	SGX_ATTR_INIT		= BIT(0),
> +	SGX_ATTR_DEBUG		= BIT(1),
> +	SGX_ATTR_MODE64BIT	= BIT(2),
> +	SGX_ATTR_PROVISIONKEY	= BIT(4),
> +	SGX_ATTR_EINITTOKENKEY	= BIT(5),
> +	SGX_ATTR_KSS		= BIT(7),
> +};
> +
> +#define SGX_ATTR_RESERVED_MASK	(BIT_ULL(3) | BIT_ULL(7) | GENMASK_ULL(63, 8))

Looking how bit 7 is part of the reserved mask but you have it above
as SGX_ATTR_KSS too. Bit 6, OTOH, is not mentioned anywhere and it
very much looks like you need to have BIT_ULL(6) above as part of the
reserved mask instead of bit 7.

Hmmm?

> +#define SGX_ATTR_ALLOWED_MASK	(SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | \
> +				 SGX_ATTR_KSS)
> +#define SGX_SECS_RESERVED1_SIZE 24
> +#define SGX_SECS_RESERVED2_SIZE 32
> +#define SGX_SECS_RESERVED3_SIZE 96
> +#define SGX_SECS_RESERVED4_SIZE 3836

I'd make those defines shorter...

> +
> +/**
> + * struct sgx_secs - SGX Enclave Control Structure (SECS)
> + * @size:		size of the address space
> + * @base:		base address of the  address space
> + * @ssa_frame_size:	size of an SSA frame
> + * @miscselect:		additional information stored to an SSA frame
> + * @attributes:		attributes for enclave
> + * @xfrm:		XSave-Feature Request Mask (subset of XCR0)
> + * @mrenclave:		SHA256-hash of the enclave contents
> + * @mrsigner:		SHA256-hash of the public key used to sign the SIGSTRUCT
> + * @isvprodid:		a user-defined value that is used in key derivation
> + * @isvsvn:		a user-defined value that is used in key derivation
> + *
> + * SGX Enclave Control Structure (SECS) is a special enclave page that is not
> + * visible in the address space. In fact, this structure defines the address
> + * range and other global attributes for the enclave and it is the first EPC
> + * page created for any enclave. It is moved from a temporary buffer to an EPC
> + * by the means of ENCLS(ECREATE) leaf.
> + */
> +struct sgx_secs {
> +	u64 size;
> +	u64 base;
> +	u32 ssa_frame_size;
> +	u32 miscselect;
> +	u8  reserved1[SGX_SECS_RESERVED1_SIZE];
> +	u64 attributes;
> +	u64 xfrm;
> +	u32 mrenclave[8];
> +	u8  reserved2[SGX_SECS_RESERVED2_SIZE];
> +	u32 mrsigner[8];
> +	u8  reserved3[SGX_SECS_RESERVED3_SIZE];
> +	u16 isvprodid;
> +	u16 isvsvn;
> +	u8  reserved4[SGX_SECS_RESERVED4_SIZE];

... so that they don't stick too much here.

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
