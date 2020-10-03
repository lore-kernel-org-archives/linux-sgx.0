Return-Path: <SRS0=MzOG=DK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B1FC41604
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 19:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E130206C1
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 19:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vu4pehAF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgJCTys (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Oct 2020 15:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgJCTys (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 3 Oct 2020 15:54:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5AEC0613D0;
        Sat,  3 Oct 2020 12:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=W91k3LCW0i8GaFaTnB4fYPopTgDFqdCkBGVaCwOmypo=; b=Vu4pehAFr4Izzs7kVvo8QHam4c
        GwMRn1Xr0yyFEnta3Ltnog0qMNCygc1WaZXWFQFEFnYTEOwWmsuNddecs7EvcW3k9tUtMAkGXiD22
        K12hMwY7MTTiTxADz9yQmL9RBcWgwsIolqcBiWgrXCuL6baXFI8Rr4kfcr6WvTbLTKP3FCHFkS7mO
        OV8xX5eNmMqBaUktFU9hh4wIgCUb12z1UnLtGXs9cVb5m6Unk19WMmW44WACNX1tM4AUP1jnHoL0u
        ON8vmnTZx6n9l0zXdRm9kuITDoEpiIv6eyuTHrk2A10+UR9Ti0IYBL1DBHQ9e4piXhEetDUHUG2JP
        n9/XQlTQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kOnc8-0004A5-JD; Sat, 03 Oct 2020 19:54:40 +0000
Date:   Sat, 3 Oct 2020 20:54:40 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201003195440.GD20115@casper.infradead.org>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 03, 2020 at 07:50:46AM +0300, Jarkko Sakkinen wrote:
> +	XA_STATE(xas, &encl->page_array, idx_start);
> +
> +	/*
> +	 * Disallow READ_IMPLIES_EXEC tasks as their VMA permissions might
> +	 * conflict with the enclave page permissions.
> +	 */
> +	if (current->personality & READ_IMPLIES_EXEC)
> +		return -EACCES;
> +
> +	xas_for_each(&xas, page, idx_end)
> +		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> +			return -EACCES;

You're iterating the array without holding any lock that the XArray knows
about.  If you're OK with another thread adding/removing pages behind your
back, or there's a higher level lock (the mmap_sem?) protecting the XArray
from being modified while you walk it, then hold the rcu_read_lock()
while walking the array.  Otherwise you can prevent modification by
calling xas_lock(&xas) and xas_unlock()..

> +	return 0;
> +}
> +
> +static int sgx_vma_mprotect(struct vm_area_struct *vma,
> +			    struct vm_area_struct **pprev, unsigned long start,
> +			    unsigned long end, unsigned long newflags)
> +{
> +	int ret;
> +
> +	ret = sgx_encl_may_map(vma->vm_private_data, start, end, newflags);
> +	if (ret)
> +		return ret;
> +
> +	return mprotect_fixup(vma, pprev, start, end, newflags);
> +}
> +
> +const struct vm_operations_struct sgx_vm_ops = {
> +	.open = sgx_vma_open,
> +	.fault = sgx_vma_fault,
> +	.mprotect = sgx_vma_mprotect,
> +};
> +
> +/**
> + * sgx_encl_find - find an enclave
> + * @mm:		mm struct of the current process
> + * @addr:	address in the ELRANGE
> + * @vma:	the resulting VMA
> + *
> + * Find an enclave identified by the given address. Give back a VMA that is
> + * part of the enclave and located in that address. The VMA is given back if it
> + * is a proper enclave VMA even if an &sgx_encl instance does not exist yet
> + * (enclave creation has not been performed).
> + *
> + * Return:
> + *   0 on success,
> + *   -EINVAL if an enclave was not found,
> + *   -ENOENT if the enclave has not been created yet
> + */
> +int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
> +		  struct vm_area_struct **vma)
> +{
> +	struct vm_area_struct *result;
> +	struct sgx_encl *encl;
> +
> +	result = find_vma(mm, addr);
> +	if (!result || result->vm_ops != &sgx_vm_ops || addr < result->vm_start)
> +		return -EINVAL;
> +
> +	encl = result->vm_private_data;
> +	*vma = result;
> +
> +	return encl ? 0 : -ENOENT;
> +}
> +
> +/**
> + * sgx_encl_destroy() - destroy enclave resources
> + * @encl:	an enclave pointer
> + */
> +void sgx_encl_destroy(struct sgx_encl *encl)
> +{
> +	struct sgx_encl_page *entry;
> +	unsigned long index;
> +
> +	atomic_or(SGX_ENCL_DEAD, &encl->flags);
> +
> +	xa_for_each(&encl->page_array, index, entry) {
> +		if (entry->epc_page) {
> +			sgx_free_epc_page(entry->epc_page);
> +			encl->secs_child_cnt--;
> +			entry->epc_page = NULL;
> +		}
> +
> +		kfree(entry);
> +	}
> +
> +	xa_destroy(&encl->page_array);
> +
> +	if (!encl->secs_child_cnt && encl->secs.epc_page) {
> +		sgx_free_epc_page(encl->secs.epc_page);
> +		encl->secs.epc_page = NULL;
> +	}
> +}
> +
> +/**
> + * sgx_encl_release - Destroy an enclave instance
> + * @kref:	address of a kref inside &sgx_encl
> + *
> + * Used together with kref_put(). Frees all the resources associated with the
> + * enclave and the instance itself.
> + */
> +void sgx_encl_release(struct kref *ref)
> +{
> +	struct sgx_encl *encl = container_of(ref, struct sgx_encl, refcount);
> +
> +	sgx_encl_destroy(encl);
> +
> +	if (encl->backing)
> +		fput(encl->backing);
> +
> +	cleanup_srcu_struct(&encl->srcu);
> +
> +	WARN_ON_ONCE(!list_empty(&encl->mm_list));
> +
> +	/* Detect EPC page leak's. */
> +	WARN_ON_ONCE(encl->secs_child_cnt);
> +	WARN_ON_ONCE(encl->secs.epc_page);
> +
> +	kfree(encl);
> +}
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> new file mode 100644
> index 000000000000..8ff445476657
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -0,0 +1,85 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +/**
> + * Copyright(c) 2016-19 Intel Corporation.
> + */
> +#ifndef _X86_ENCL_H
> +#define _X86_ENCL_H
> +
> +#include <linux/cpumask.h>
> +#include <linux/kref.h>
> +#include <linux/list.h>
> +#include <linux/mm_types.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/mutex.h>
> +#include <linux/notifier.h>
> +#include <linux/srcu.h>
> +#include <linux/workqueue.h>
> +#include <linux/xarray.h>
> +#include "sgx.h"
> +
> +/**
> + * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
> + * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
> + *
> + * The page address for SECS is zero and is used by the subsystem to recognize
> + * the SECS page.
> + */
> +enum sgx_encl_page_desc {
> +	/* Bits 11:3 are available when the page is not swapped. */
> +	SGX_ENCL_PAGE_ADDR_MASK		= PAGE_MASK,
> +};
> +
> +#define SGX_ENCL_PAGE_ADDR(page) \
> +	((page)->desc & SGX_ENCL_PAGE_ADDR_MASK)
> +
> +struct sgx_encl_page {
> +	unsigned long desc;
> +	unsigned long vm_max_prot_bits;
> +	struct sgx_epc_page *epc_page;
> +	struct sgx_encl *encl;
> +};
> +
> +enum sgx_encl_flags {
> +	SGX_ENCL_CREATED	= BIT(0),
> +	SGX_ENCL_INITIALIZED	= BIT(1),
> +	SGX_ENCL_DEBUG		= BIT(2),
> +	SGX_ENCL_DEAD		= BIT(3),
> +	SGX_ENCL_IOCTL		= BIT(4),
> +};
> +
> +struct sgx_encl_mm {
> +	struct sgx_encl *encl;
> +	struct mm_struct *mm;
> +	struct list_head list;
> +	struct mmu_notifier mmu_notifier;
> +};
> +
> +struct sgx_encl {
> +	atomic_t flags;
> +	unsigned int page_cnt;
> +	unsigned int secs_child_cnt;
> +	struct mutex lock;
> +	struct list_head mm_list;
> +	spinlock_t mm_lock;
> +	struct file *backing;
> +	struct kref refcount;
> +	struct srcu_struct srcu;
> +	unsigned long base;
> +	unsigned long size;
> +	unsigned long ssaframesize;
> +	struct xarray page_array;
> +	struct sgx_encl_page secs;
> +	cpumask_t cpumask;
> +};
> +
> +extern const struct vm_operations_struct sgx_vm_ops;
> +
> +int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
> +		  struct vm_area_struct **vma);
> +void sgx_encl_destroy(struct sgx_encl *encl);
> +void sgx_encl_release(struct kref *ref);
> +int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
> +int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> +		     unsigned long end, unsigned long vm_flags);
> +
> +#endif /* _X86_ENCL_H */
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 97c6895fb6c9..4137254fb29e 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -9,6 +9,8 @@
>  #include <linux/sched/mm.h>
>  #include <linux/sched/signal.h>
>  #include <linux/slab.h>
> +#include "driver.h"
> +#include "encl.h"
>  #include "encls.h"
>  
>  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> @@ -260,6 +262,8 @@ static bool __init sgx_page_cache_init(void)
>  
>  static void __init sgx_init(void)
>  {
> +	int ret;
> +
>  	if (!boot_cpu_has(X86_FEATURE_SGX))
>  		return;
>  
> @@ -269,8 +273,15 @@ static void __init sgx_init(void)
>  	if (!sgx_page_reclaimer_init())
>  		goto err_page_cache;
>  
> +	ret = sgx_drv_init();
> +	if (ret)
> +		goto err_kthread;
> +
>  	return;
>  
> +err_kthread:
> +	kthread_stop(ksgxswapd_tsk);
> +
>  err_page_cache:
>  	sgx_page_cache_teardown();
>  }
> -- 
> 2.25.1
> 
