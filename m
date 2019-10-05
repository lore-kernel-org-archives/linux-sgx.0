Return-Path: <SRS0=Nw9Y=X6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985A8C3E8AB
	for <linux-sgx@archiver.kernel.org>; Sat,  5 Oct 2019 09:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F3312133F
	for <linux-sgx@archiver.kernel.org>; Sat,  5 Oct 2019 09:26:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="XyFHlpMz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfJEJ0g (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 5 Oct 2019 05:26:36 -0400
Received: from mail.skyhub.de ([5.9.137.197]:60314 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfJEJ0f (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 5 Oct 2019 05:26:35 -0400
Received: from zn.tnic (p200300EC2F1EF900BD73D6DEF6CFFA47.dip0.t-ipconnect.de [IPv6:2003:ec:2f1e:f900:bd73:d6de:f6cf:fa47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5EB601EC090E;
        Sat,  5 Oct 2019 11:26:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570267593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ool3GTVJie0UMLlkKeE7+wTsYbIYeXtKlpM1diyjJ5c=;
        b=XyFHlpMzgPKs5G8f4v/ktTZFeV1pE5X57pW5E6GWDz1iKvselD3XtwNZSIjUkhm0DS3snI
        LwU2PL0bOorSyYCs5Ry0HivJYTN+jcryt/QnBGzuxxQXN+cOueSg2VbEqvyACmjkTfUDbk
        olegrYTC6rJkj5KTYCIZr9MuGqMovR0=
Date:   Sat, 5 Oct 2019 11:26:27 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v22 08/24] x86/sgx: Enumerate and track EPC sections
Message-ID: <20191005092627.GA25699@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-9-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190903142655.21943-9-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 03, 2019 at 05:26:39PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Enumerate Enclave Page Cache (EPC) sections via CPUID and add the data
> structures necessary to track EPC pages so that they can be allocated,
> freed and managed. As a system may have multiple EPC sections, invoke
> CPUID on SGX sub-leafs until an invalid leaf is encountered.
> 
> On NUMA systems, a node can have at most one bank. A bank can be at

Is that a DRAM bank or what exactly is a "bank" here?

> most part of two nodes. SGX supports both nodes with a single memory
> controller and also sub-cluster nodes with severals memory controllers

s/severals/several/

> on a single die.
> 
> For simplicity, support a maximum of eight EPC sections. Exisiting

s/Exisiting/Existing/g

Please introduce a spellchecker into your patch creation workflow and
run all your text through it.

> client hardware supports only a single section, while upcoming server
> hardware will support at most eight sections. Bounding the number of
> sections also allows the section ID to be embedded along with a page's
> offset in a single unsigned long, enabling easy retrieval of both the
> VA and PA for a given page.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>

As before, your SOB needs to come last as you're handling the patch now
but you know already. :)

> ---
>  arch/x86/Kconfig                  |  14 +++
>  arch/x86/kernel/cpu/Makefile      |   1 +
>  arch/x86/kernel/cpu/sgx/Makefile  |   2 +-
>  arch/x86/kernel/cpu/sgx/main.c    | 158 ++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/reclaim.c |  84 ++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h     |  67 +++++++++++++
>  6 files changed, 325 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kernel/cpu/sgx/main.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/reclaim.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/sgx.h
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 222855cc0158..2a8988aaa074 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1934,6 +1934,20 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
>  
>  	  If unsure, say y.
>  
> +config INTEL_SGX
> +	bool "Intel SGX core functionality"

This sounds like there's other functionality which will have a separate
config option(s) ?

It is not in this patchset though...

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
>  config EFI
>  	bool "EFI runtime service support"
>  	depends on ACPI
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index d7a1e5a9331c..97deac5108df 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -45,6 +45,7 @@ obj-$(CONFIG_X86_MCE)			+= mce/
>  obj-$(CONFIG_MTRR)			+= mtrr/
>  obj-$(CONFIG_MICROCODE)			+= microcode/
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= resctrl/
> +obj-$(CONFIG_INTEL_SGX)			+= sgx/
>  
>  obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
>  
> diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
> index 4432d935894e..fa930e292110 100644
> --- a/arch/x86/kernel/cpu/sgx/Makefile
> +++ b/arch/x86/kernel/cpu/sgx/Makefile
> @@ -1 +1 @@
> -obj-y += encls.o
> +obj-y += encls.o main.o reclaim.o
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> new file mode 100644
> index 000000000000..e2317f6e4374
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -0,0 +1,158 @@
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
> +#include "arch.h"
> +#include "sgx.h"
> +
> +struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> +EXPORT_SYMBOL_GPL(sgx_epc_sections);

This export gets removed again in patch 12. Please audit your whole
patchset for stuff being added and later removed and kill it so that the
diffstat is decreased.

> +
> +int sgx_nr_epc_sections;
> +
> +static __init void sgx_free_epc_section(struct sgx_epc_section *section)
> +{
> +	struct sgx_epc_page *page;
> +
> +	while (!list_empty(&section->page_list)) {
> +		page = list_first_entry(&section->page_list,
> +					struct sgx_epc_page, list);
> +		list_del(&page->list);
> +		kfree(page);
> +	}
> +
> +	while (!list_empty(&section->unsanitized_page_list)) {
> +		page = list_first_entry(&section->unsanitized_page_list,
> +					struct sgx_epc_page, list);
> +		list_del(&page->list);
> +		kfree(page);
> +	}
> +
> +	memunmap(section->va);
> +}
> +
> +static __init int sgx_init_epc_section(u64 addr, u64 size, unsigned long index,
> +				       struct sgx_epc_section *section)

If the "free" function above is the counterpart of this, then this
should be called sgx_alloc_epc_section() or so.

> +{
> +	unsigned long nr_pages = size >> PAGE_SHIFT;
> +	struct sgx_epc_page *page;
> +	unsigned long i;
> +
> +	section->va = memremap(addr, size, MEMREMAP_WB);
> +	if (!section->va)
> +		return -ENOMEM;
> +
> +	section->pa = addr;
> +	spin_lock_init(&section->lock);
> +	INIT_LIST_HEAD(&section->page_list);
> +	INIT_LIST_HEAD(&section->unsanitized_page_list);
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		page = kzalloc(sizeof(*page), GFP_KERNEL);
> +		if (!page)
> +			goto out;

<---- newline here.

> +		page->desc = (addr + (i << PAGE_SHIFT)) | index;
> +		list_add_tail(&page->list, &section->unsanitized_page_list);
> +		section->free_cnt++;
> +	}
> +
> +	return 0;
> +out:
> +	sgx_free_epc_section(section);
> +	return -ENOMEM;
> +}
> +
> +static __init void sgx_page_cache_teardown(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < sgx_nr_epc_sections; i++)
> +		sgx_free_epc_section(&sgx_epc_sections[i]);
> +}
> +
> +/**
> + * A section metric is concatenated in a way that @low bits 12-31 define the
> + * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
> + * metric.
> + */
> +static inline u64 sgx_calc_section_metric(u64 low, u64 high)
> +{
> +	return (low & GENMASK_ULL(31, 12)) +
> +	       ((high & GENMASK_ULL(19, 0)) << 32);
> +}
> +
> +static __init int sgx_page_cache_init(void)
> +{
> +	u32 eax, ebx, ecx, edx, type;
> +	u64 pa, size;
> +	int ret;
> +	int i;
> +
> +	BUILD_BUG_ON(SGX_MAX_EPC_SECTIONS > (SGX_EPC_SECTION_MASK + 1));
> +
> +	for (i = 0; i < (SGX_MAX_EPC_SECTIONS + 1); i++) {

			^			 ^ - what are those brackets for?

> +		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
> +			    &eax, &ebx, &ecx, &edx);
> +
> +		type = eax & SGX_CPUID_SUB_LEAF_TYPE_MASK;
> +		if (type == SGX_CPUID_SUB_LEAF_INVALID)
> +			break;

<---- newline here.

> +		if (type != SGX_CPUID_SUB_LEAF_EPC_SECTION) {
> +			pr_err_once("sgx: Unknown sub-leaf type: %u\n", type);
				     ^^^^

That's done with:

#undef pr_fmt
#define pr_fmt(fmt)     "sgx: " fmt

for the whole compilation unit or you can simply raise it into sgx.h for
the whole sgx pile.


> +			return -ENODEV;
> +		}

<---- newline here.

Yeah, let's space out those a bit, for better readability.

> +		if (i == SGX_MAX_EPC_SECTIONS) {
> +			pr_warn("sgx: More than "
> +				__stringify(SGX_MAX_EPC_SECTIONS)
> +				" EPC sections\n");

Huh, what's wrong with using "%d" like a normal printk does?

> +			break;
> +		}
> +
> +		pa = sgx_calc_section_metric(eax, ebx);
> +		size = sgx_calc_section_metric(ecx, edx);

This size comes from CPUID but it might be prudent to sanity-check it
nevertheless, before doing the memremap().

> +		pr_info("sgx: EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
> +
> +		ret = sgx_init_epc_section(pa, size, i, &sgx_epc_sections[i]);
> +		if (ret) {
> +			sgx_page_cache_teardown();

So even if one section fails to allocate, we teardown the whole thing?
I.e., can't run with only 7 or so? IOW, do we absolutely have to fail
here or can we fail more gracefully?

> +			return ret;
> +		}
> +
> +		sgx_nr_epc_sections++;
> +	}
> +
> +	if (!sgx_nr_epc_sections) {
> +		pr_err("sgx: There are zero EPC sections.\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static __init int sgx_init(void)
> +{
> +	int ret;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SGX))
> +		return false;
> +
> +	ret = sgx_page_cache_init();
> +	if (ret)
> +		return ret;
> +
> +	ret = sgx_page_reclaimer_init();
> +	if (ret) {
> +		sgx_page_cache_teardown();
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +arch_initcall(sgx_init);

Why does this have to be an arch initcall and can't it run after
detect_sgx() in init_intel()? You'd need to run it only once but that's
easy.

> diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> new file mode 100644
> index 000000000000..042769f03be9
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -0,0 +1,84 @@
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
> +#include "sgx.h"
> +
> +static struct task_struct *ksgxswapd_tsk;
> +
> +static void sgx_sanitize_section(struct sgx_epc_section *section)
> +{
> +	struct sgx_epc_page *page, *tmp;
> +	LIST_HEAD(secs_list);
> +	int ret;
> +
> +	while (!list_empty(&section->unsanitized_page_list)) {
> +		if (kthread_should_stop())
> +			return;
> +
> +		spin_lock(&section->lock);
> +
> +		page = list_first_entry(&section->unsanitized_page_list,
> +					struct sgx_epc_page, list);
> +
> +		ret = __eremove(sgx_epc_addr(page));
> +		if (!ret)
> +			list_move(&page->list, &section->page_list);
> +		else
> +			list_move_tail(&page->list, &secs_list);
> +
> +		spin_unlock(&section->lock);
> +
> +		cond_resched();
> +	}
> +
> +	list_for_each_entry_safe(page, tmp, &secs_list, list) {
> +		if (kthread_should_stop())
> +			return;
> +
> +		ret = __eremove(sgx_epc_addr(page));
> +		if (!WARN_ON_ONCE(ret)) {
> +			spin_lock(&section->lock);
> +			list_move(&page->list, &section->page_list);
> +			spin_unlock(&section->lock);
> +		} else {
> +			list_del(&page->list);
> +			kfree(page);
> +		}
> +
> +		cond_resched();
> +	}
> +}

I could use a sentence or two above this function explaining what the
idea behind those page lists is and why we're moving off pages to and
from lists, what the unsanitized_page_list is, how it is being used,
etc. That probably has come up already so pointing me to the text would
suffice too.

> +
> +static int ksgxswapd(void *p)
> +{
> +	int i;
> +
> +	set_freezable();
> +
> +	for (i = 0; i < sgx_nr_epc_sections; i++)
> +		sgx_sanitize_section(&sgx_epc_sections[i]);
> +
> +	return 0;
> +}
> +
> +int sgx_page_reclaimer_init(void)
> +{
> +	struct task_struct *tsk;
> +
> +	tsk = kthread_run(ksgxswapd, NULL, "ksgxswapd");
> +	if (IS_ERR(tsk))
> +		return PTR_ERR(tsk);
> +
> +	ksgxswapd_tsk = tsk;
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> new file mode 100644
> index 000000000000..3009ec816339
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -0,0 +1,67 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +#ifndef _X86_SGX_H
> +#define _X86_SGX_H
> +
> +#include <linux/bitops.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/rwsem.h>
> +#include <linux/types.h>
> +#include <asm/asm.h>
> +#include <uapi/asm/sgx_errno.h>
> +
> +struct sgx_epc_page {
> +	unsigned long desc;
> +	struct list_head list;
> +};
> +
> +/**
> + * struct sgx_epc_section
> + *
> + * The firmware can define multiple chunks of EPC to the different areas of the

My usual question: what if fw doesn't? Can we define our own chunks or
do we need special firmware support for the whole EPC thing to even
exist?

> + * physical memory e.g. for memory areas of the each node. This structure is
> + * used to store EPC pages for one EPC section and virtual memory area where
> + * the pages have been mapped.
> + */

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
