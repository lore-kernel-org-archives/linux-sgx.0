Return-Path: <SRS0=4dFz=7H=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220A2C433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 25 May 2020 09:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC8382078B
	for <linux-sgx@archiver.kernel.org>; Mon, 25 May 2020 09:23:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="U0cxrNIA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389445AbgEYJXL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 25 May 2020 05:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389334AbgEYJXL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 25 May 2020 05:23:11 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20083C061A0E;
        Mon, 25 May 2020 02:23:11 -0700 (PDT)
Received: from zn.tnic (p200300ec2f06f30089d08c3691e46ece.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:f300:89d0:8c36:91e4:6ece])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 819B71EC0116;
        Mon, 25 May 2020 11:23:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590398589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OnEGbWxDPpaI9jKXg4+GIyJRv1KGvS3jKj4n9w8JBPk=;
        b=U0cxrNIAQlKSXB7QPu9oLfvxMibd/2godoJHBf1CG5xY1khQQCNwwFfE5zXuGu8y+0IKYr
        vsVAo3y1qK/jBLGGZ6xIxH3mXcf0s6yIJJKGIbguCtsIQpcPzTs4CJGysht2K0GHkuq6zl
        /WhmoEhRm2cJgrIXiRLpeY2yt+WIg44=
Date:   Mon, 25 May 2020 11:23:04 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 07/20] x86/sgx: Enumerate and track EPC sections
Message-ID: <20200525092304.GD25636@zn.tnic>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-8-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200515004410.723949-8-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 15, 2020 at 03:43:57AM +0300, Jarkko Sakkinen wrote:
> +config INTEL_SGX
> +	bool "Intel SGX"
> +	depends on X86_64 && CPU_SUP_INTEL
> +	select SRCU
> +	select MMU_NOTIFIER
> +	help
> +	  Intel(R) SGX is a set of CPU instructions that can be used by
> +	  applications to set aside private regions of code and data, referred
> +	  to as enclaves. An enclave's private memory can only be accessed by
> +	  code running within the enclave. Accesses from outside the enclave,
> +	  including other enclaves, are disallowed by hardware.
> +
> +	  If unsure, say N.
> +

Enabling this gives:

In file included from arch/x86/kernel/cpu/sgx/main.c:11:
arch/x86/kernel/cpu/sgx/encls.h:189:51: warning: ‘struct sgx_einittoken’ declared inside parameter list will not be visible outside of this definition or declaration
  189 | static inline int __einit(void *sigstruct, struct sgx_einittoken *einittoken,
      |                                                   ^~~~~~~~~~~~~~
In file included from arch/x86/kernel/cpu/sgx/reclaim.c:12:
arch/x86/kernel/cpu/sgx/encls.h:189:51: warning: ‘struct sgx_einittoken’ declared inside parameter list will not be visible outside of this definition or declaration
  189 | static inline int __einit(void *sigstruct, struct sgx_einittoken *einittoken,
      |

You need a forward declaration somewhere.

>  config EFI
>  	bool "EFI runtime service support"
>  	depends on ACPI
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index 7dc4ad68eb41..45534fb81007 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -46,6 +46,7 @@ obj-$(CONFIG_X86_MCE)			+= mce/
>  obj-$(CONFIG_MTRR)			+= mtrr/
>  obj-$(CONFIG_MICROCODE)			+= microcode/
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= resctrl/
> +obj-$(CONFIG_INTEL_SGX)			+= sgx/
>  
>  obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
>  
> diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
> new file mode 100644
> index 000000000000..2dec75916a5e
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/Makefile
> @@ -0,0 +1,3 @@
> +obj-y += \
> +	main.o \
> +	reclaim.o
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> new file mode 100644
> index 000000000000..38424c1e8341
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -0,0 +1,151 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-17 Intel Corporation.
> +
> +#include <linux/freezer.h>
> +#include <linux/highmem.h>
> +#include <linux/kthread.h>
> +#include <linux/pagemap.h>
> +#include <linux/ratelimit.h>
> +#include <linux/sched/signal.h>
> +#include <linux/slab.h>
> +#include "encls.h"
> +
> +struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> +int sgx_nr_epc_sections;

We have become very averse against global stuff. What is going to use
those, only sgx code I assume...?

> +static bool __init sgx_page_cache_init(void)
> +{
> +	u32 eax, ebx, ecx, edx, type;
> +	u64 pa, size;
> +	int i;
> +
> +	for (i = 0; i <= ARRAY_SIZE(sgx_epc_sections); i++) {
> +		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
> +			    &eax, &ebx, &ecx, &edx);
> +
> +		type = eax & SGX_CPUID_SUB_LEAF_TYPE_MASK;
> +		if (type == SGX_CPUID_SUB_LEAF_INVALID)
> +			break;
> +
> +		if (type != SGX_CPUID_SUB_LEAF_EPC_SECTION) {
> +			pr_err_once("Unknown EPC section type: %u\n", type);
> +			break;
> +		}
> +
> +		if (i == ARRAY_SIZE(sgx_epc_sections)) {
> +			pr_warn("No free slot for an EPC section\n");
> +			break;
> +		}

This is also the loop termination: do we really need this warn or can
the loop simply do "i < ARRAY_SIZE" ?

If the warn is needed, it can be after the loop too.

> +
> +		pa = sgx_calc_section_metric(eax, ebx);
> +		size = sgx_calc_section_metric(ecx, edx);
> +
> +		pr_info("EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);

I'm assuming that's useful information to issue in dmesg?

> diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> new file mode 100644
> index 000000000000..215371588a25
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-19 Intel Corporation.
> +
> +#include <linux/freezer.h>
> +#include <linux/highmem.h>
> +#include <linux/kthread.h>
> +#include <linux/pagemap.h>
> +#include <linux/ratelimit.h>
> +#include <linux/slab.h>
> +#include <linux/sched/mm.h>
> +#include <linux/sched/signal.h>
> +#include "encls.h"
> +
> +struct task_struct *ksgxswapd_tsk;

Same for this one: also shared only among sgx code?

> +/**
> + * enum sgx_epc_page_desc - bits and masks for an EPC page's descriptor
> + * %SGX_EPC_SECTION_MASK:	SGX allows to have multiple EPC sections in the
> + *				physical memory. The existing and near-future
> + *				hardware defines at most eight sections, hence
> + *				three bits to hold a section.
> + */
> +enum sgx_epc_page_desc {
> +	SGX_EPC_SECTION_MASK			= GENMASK_ULL(3, 0),

If that should be three bits, then it should be (2, 0). Because now you
have 4 bits:

# arch/x86/kernel/cpu/sgx/sgx.h:56:     return &sgx_epc_sections[page->desc & SGX_EPC_SECTION_MASK];
        andl    $15, %edx       #, _22
		^^^

> +	/* bits 12-63 are reserved for the physical page address of the page */
> +};
> +
> +#define SGX_MAX_EPC_SECTIONS (SGX_EPC_SECTION_MASK + 1)
> +
> +extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> +
> +static inline struct sgx_epc_section *sgx_epc_section(struct sgx_epc_page *page)

This function name needs a verb. "get" sounds fitting. :)

> +{
> +	return &sgx_epc_sections[page->desc & SGX_EPC_SECTION_MASK];
> +}
> +
> +static inline void *sgx_epc_addr(struct sgx_epc_page *page)

Ditto.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
