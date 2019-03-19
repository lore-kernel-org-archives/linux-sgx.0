Return-Path: <SRS0=vqpH=RW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0349EC43381
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Mar 2019 22:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B87812075C
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Mar 2019 22:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfCSWJU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Mar 2019 18:09:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:28099 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbfCSWJU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 19 Mar 2019 18:09:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Mar 2019 15:09:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,246,1549958400"; 
   d="scan'208";a="156485371"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga001.fm.intel.com with ESMTP; 19 Mar 2019 15:09:16 -0700
Date:   Tue, 19 Mar 2019 15:09:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v19 18/27] x86/sgx: Add swapping code to the core and SGX
 driver
Message-ID: <20190319220916.GJ25575@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-19-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317211456.13927-19-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Mar 17, 2019 at 11:14:47PM +0200, Jarkko Sakkinen wrote:

...

> ---
>  arch/x86/Kconfig                       |   3 +
>  arch/x86/kernel/cpu/sgx/Makefile       |   1 +
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c |  59 +++-
>  arch/x86/kernel/cpu/sgx/encl.c         | 267 +++++++++++++++-
>  arch/x86/kernel/cpu/sgx/encl.h         |  38 +++
>  arch/x86/kernel/cpu/sgx/main.c         |  96 +++++-
>  arch/x86/kernel/cpu/sgx/reclaim.c      | 410 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h          |  34 +-
>  8 files changed, 887 insertions(+), 21 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/sgx/reclaim.c
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 34257b5659cc..424bd58fd299 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1953,6 +1953,9 @@ config INTEL_SGX_DRIVER
>  	specifying the public key hash for the launch enclave are writable so
>  	that Linux has the full control to run enclaves.
>  
> +	If the driver is enabled, the page reclaimer in the core will be
> +	enabled. It reclaims pages in LRU fashion from enclaves.
> +

IMO this is an implementation detail that belongs in the docs, not in
the kconfig description.  At the least, it should refer to "EPC page(s)".

>  	For details, see Documentation/x86/intel_sgx.rst
>  
>  config EFI

...

> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index bd8bcd748976..1b8874699dd3 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -7,11 +7,91 @@
>  #include <linux/sched/mm.h>
>  #include "arch.h"
>  #include "encl.h"
> +#include "encls.h"
>  #include "sgx.h"
>  
> +static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> +			   struct sgx_epc_page *epc_page)
> +{
> +	unsigned long addr = SGX_ENCL_PAGE_ADDR(encl_page);
> +	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
> +	struct sgx_encl *encl = encl_page->encl;
> +	pgoff_t page_index = sgx_encl_get_index(encl, encl_page);
> +	pgoff_t pcmd_index = sgx_pcmd_index(encl, page_index);
> +	unsigned long pcmd_offset = sgx_pcmd_offset(page_index);
> +	struct sgx_pageinfo pginfo;
> +	struct page *backing;
> +	struct page *pcmd;
> +	int ret;
> +
> +	backing = sgx_encl_get_backing_page(encl, page_index);
> +	if (IS_ERR(backing)) {
> +		ret = PTR_ERR(backing);
> +		goto err_backing;
> +	}
> +
> +	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
> +	if (IS_ERR(pcmd)) {
> +		ret = PTR_ERR(pcmd);
> +		goto err_pcmd;
> +	}
> +
> +	pginfo.addr = addr;
> +	pginfo.contents = (unsigned long)kmap_atomic(backing);
> +	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
> +	pginfo.secs = addr ? (unsigned long)sgx_epc_addr(encl->secs.epc_page) :
> +		      0;

Ick, letting the line poke out by a few chars seems preferable to wrapping "0;".

> +
> +	ret = __eldu(&pginfo, sgx_epc_addr(epc_page),
> +		     sgx_epc_addr(encl_page->va_page->epc_page) + va_offset);
> +	if (ret) {
> +		if (encls_failed(ret) || encls_returned_code(ret))
> +			ENCLS_WARN(ret, "ELDU");
> +
> +		ret = -EFAULT;
> +	}
> +
> +	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
> +	kunmap_atomic((void *)(unsigned long)pginfo.contents);
> +
> +	put_page(pcmd);
> +
> +err_pcmd:
> +	put_page(backing);
> +
> +err_backing:
> +	return ret;
> +}

...

> +
> +
> +	while (!list_empty(&encl->va_pages)) {
> +		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
> +					   list);

list_for_each_entry_safe()?

> +		list_del(&va_page->list);
> +		sgx_free_page(va_page->epc_page);
> +		kfree(va_page);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(sgx_encl_destroy);
>  
> @@ -356,3 +465,157 @@ void sgx_encl_release_mm(struct kref *ref)
>  
>  	kfree(mm);
>  }
> +
> +static int sgx_encl_test_and_clear_young_cb(pte_t *ptep, pgtable_t token,
> +					    unsigned long addr, void *data)
> +{
> +	pte_t pte;
> +	int ret;
> +
> +	ret = pte_young(*ptep);
> +	if (ret) {
> +		pte = pte_mkold(*ptep);
> +		set_pte_at((struct mm_struct *)data, addr, ptep, pte);
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * sgx_encl_test_and_clear_young() - Test and reset the accessed bit
> + * @mm:		mm_struct that is checked
> + * @page:	enclave page to be tested for recent access
> + *
> + * Checks the Access (A) bit from the PTE corresponding to the enclave page and
> + * clears it.
> + *
> + * Return: 1 if the page has been recently accessed and 0 if not.
> + */
> +int sgx_encl_test_and_clear_young(struct mm_struct *mm,
> +				  struct sgx_encl_page *page)
> +{
> +	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
> +	struct sgx_encl *encl = page->encl;
> +	struct vm_area_struct *vma;
> +	int ret;
> +
> +	ret = sgx_encl_find(mm, addr, &vma);
> +	if (ret)
> +		return 0;
> +
> +	if (encl != vma->vm_private_data)
> +		return 0;
> +
> +	ret = apply_to_page_range(vma->vm_mm, addr, PAGE_SIZE,
> +				  sgx_encl_test_and_clear_young_cb, vma->vm_mm);
> +	if (ret < 0)
> +		return 0;
> +
> +	return ret;
> +}
> +
> +/**
> + * sgx_encl_reserve_page() - Reserve an enclave page
> + * @encl:	an enclave
> + * @addr:	a page address
> + *
> + * Load an enclave page and lock the enclave so that the page can be used by
> + * EDBG* and EMOD*.
> + *
> + * Return:
> + *   an enclave page on success
> + *   -EFAULT	if the load fails
> + */
> +struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
> +					    unsigned long addr)
> +{
> +	struct sgx_encl_page *entry;
> +
> +	for ( ; ; ) {
> +		mutex_lock(&encl->lock);
> +
> +		entry = sgx_encl_load_page(encl, addr);
> +		if (PTR_ERR(entry) != -EBUSY)
> +			break;
> +
> +		mutex_unlock(&encl->lock);
> +	}
> +
> +	if (IS_ERR(entry))
> +		mutex_unlock(&encl->lock);
> +
> +	return entry;
> +}
> +EXPORT_SYMBOL(sgx_encl_reserve_page);

I think you meant to introduce this in the ptrace support patch.

> +
> +/**
> + * sgx_alloc_page - allocate a VA page
      ^^^^^^^^^^^^^^
      sgx_alloc_va_page

> + *
> + * Allocates an &sgx_epc_page instance and converts it to a VA page.
> + *
> + * Return:
> + *   a &struct sgx_va_page instance,
> + *   -errno otherwise
> + */
> +struct sgx_epc_page *sgx_alloc_va_page(void)
> +{
> +	struct sgx_epc_page *epc_page;
> +	int ret;
> +
> +	epc_page = sgx_alloc_page(NULL, true);
> +	if (IS_ERR(epc_page))
> +		return ERR_CAST(epc_page);
> +
> +	ret = __epa(sgx_epc_addr(epc_page));
> +	if (ret) {
> +		WARN_ONCE(1, "sgx: EPA returned %d (0x%x)", ret, ret);

Hmm, maybe add ENCLS_WARN_ONCE?

> +		sgx_free_page(epc_page);
> +		return ERR_PTR(-EFAULT);
> +	}
> +
> +	return epc_page;
> +}
> +EXPORT_SYMBOL_GPL(sgx_alloc_va_page);

...

> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index 374ad3396684..41c55e565e92 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -10,6 +10,10 @@
>  /**
>   * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
>   * %SGX_ENCL_PAGE_TCS:			The page is a TCS page.
> + * %SGX_ENCL_PAGE_RECLAIMED:		The page is in the process of being
> + *					reclaimed.
> + * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version Array
> + *					(VA) page for a swapped page.
>   * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
>   *
>   * The page address for SECS is zero and is used by the subsystem to recognize
> @@ -18,6 +22,8 @@
>  enum sgx_encl_page_desc {
>  	SGX_ENCL_PAGE_TCS		= BIT(0),
>  	/* Bits 11:3 are available when the page is not swapped. */
> +	SGX_ENCL_PAGE_RECLAIMED		= BIT(3),
> +	SGX_ENCL_PAGE_VA_OFFSET_MASK	= GENMASK_ULL(11, 3),
>  	SGX_ENCL_PAGE_ADDR_MASK		= PAGE_MASK,
>  };
>  
> @@ -29,6 +35,7 @@ enum sgx_encl_page_desc {
>  struct sgx_encl_page {
>  	unsigned long desc;
>  	struct sgx_epc_page *epc_page;
> +	struct sgx_va_page *va_page;
>  	struct sgx_encl *encl;
>  };
>  
> @@ -60,15 +67,37 @@ struct sgx_encl {
>  	unsigned long base;
>  	unsigned long size;
>  	unsigned long ssaframesize;
> +	struct list_head va_pages;
>  	struct radix_tree_root page_tree;
>  	struct list_head add_page_reqs;
>  	struct work_struct work;
>  	struct sgx_encl_page secs;
>  	struct notifier_block pm_notifier;
> +	cpumask_t cpumask;
> +};
> +
> +#define SGX_VA_SLOT_COUNT 512

Th SGX_VA_SLOT_COUNT definition probably belongs in sgx_arch.h

> +
> +struct sgx_va_page {
> +	struct sgx_epc_page *epc_page;
> +	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
> +	struct list_head list;
>  };
>  
>  extern const struct vm_operations_struct sgx_vm_ops;
>  
> +static inline pgoff_t sgx_pcmd_index(struct sgx_encl *encl,
> +				     pgoff_t page_index)
> +{
> +	return PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> +}
> +
> +static inline unsigned long sgx_pcmd_offset(pgoff_t page_index)
> +{
> +	return (page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
> +	       sizeof(struct sgx_pcmd);
> +}
> +
>  enum sgx_encl_mm_iter {
>  	SGX_ENCL_MM_ITER_DONE		= 0,
>  	SGX_ENCL_MM_ITER_NEXT		= 1,
> @@ -84,5 +113,14 @@ struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index);
>  struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
>  				     struct sgx_encl_mm *mm, int *iter);
>  void sgx_encl_release_mm(struct kref *ref);
> +int sgx_encl_test_and_clear_young(struct mm_struct *mm,
> +				  struct sgx_encl_page *page);
> +struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
> +					    unsigned long addr);
> +
> +struct sgx_epc_page *sgx_alloc_va_page(void);
> +unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
> +void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
> +bool sgx_va_page_full(struct sgx_va_page *va_page);
>  
>  #endif /* _X86_ENCL_H */
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index d88dc3d1d4a7..a9485a73c58c 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -17,13 +17,13 @@ EXPORT_SYMBOL_GPL(sgx_epc_sections);
>  bool sgx_enabled;
>  EXPORT_SYMBOL_GPL(sgx_enabled);
>  
> -static int sgx_nr_epc_sections;
> +int sgx_nr_epc_sections;

Alternatively, sgx_calc_free_cnt() can be implemented in main.c and then
sgx_nr_epc_sections can remain static.

>  
>  /* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
>  static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);

...

> @@ -113,6 +170,7 @@ void sgx_free_page(struct sgx_epc_page *page)
>  	int ret;
>  
>  	ret = __sgx_free_page(page);
> +	WARN(ret < 0, "sgx: cannot free page, reclaim in-progress");
>  	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);

Not actually this patch, but the EREMOVE case can use ENCLS_WARN.

>  }
>  EXPORT_SYMBOL_GPL(sgx_free_page);
> @@ -285,6 +343,12 @@ static __init int sgx_init(void)
>  	if (ret)
>  		return ret;
>  
> +	ret = sgx_page_reclaimer_init();
> +	if (ret) {
> +		sgx_page_cache_teardown();
> +		return ret;
> +	}
> +
>  	sgx_enabled = true;
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> new file mode 100644
> index 000000000000..ba67576f6515
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -0,0 +1,410 @@
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
> +#include "driver/driver.h"
> +#include "sgx.h"
> +
> +LIST_HEAD(sgx_active_page_list);
> +DEFINE_SPINLOCK(sgx_active_page_list_lock);
> +DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
> +
> +static struct task_struct *ksgxswapd_tsk;
> +
> +/**
> + * sgx_mark_page_reclaimable() - Mark a page as reclaimable
> + * @page:	EPC page
> + *
> + * Mark a page as reclaimable and add it to the active page list. Pages
> + * are automatically removed from the active list when freed.
> + */
> +void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
> +{
> +	spin_lock(&sgx_active_page_list_lock);
> +	page->desc |= SGX_EPC_PAGE_RECLAIMABLE;
> +	list_add_tail(&page->list, &sgx_active_page_list);
> +	spin_unlock(&sgx_active_page_list_lock);
> +}
> +EXPORT_SYMBOL_GPL(sgx_mark_page_reclaimable);
> +
> +bool sgx_reclaimer_get(struct sgx_epc_page *epc_page)
> +{
> +	struct sgx_encl_page *encl_page = epc_page->owner;
> +	struct sgx_encl *encl = encl_page->encl;
> +
> +	return kref_get_unless_zero(&encl->refcount) != 0;
> +}
> +
> +void sgx_reclaimer_put(struct sgx_epc_page *epc_page)
> +{
> +	struct sgx_encl_page *encl_page = epc_page->owner;
> +	struct sgx_encl *encl = encl_page->encl;
> +
> +	kref_put(&encl->refcount, sgx_encl_release);
> +}
> +
> +static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
> +{
> +	struct sgx_encl_page *page = epc_page->owner;
> +	struct sgx_encl *encl = page->encl;
> +	struct sgx_encl_mm *next_mm = NULL;
> +	struct sgx_encl_mm *prev_mm = NULL;
> +	bool ret = true;
> +	int iter;
> +
> +	while (true) {
> +		next_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
> +		if (prev_mm) {
> +			mmdrop(prev_mm->mm);
> +			kref_put(&prev_mm->refcount, sgx_encl_release_mm);
> +		}
> +		prev_mm = next_mm;
> +
> +		if (iter == SGX_ENCL_MM_ITER_DONE)
> +			break;
> +
> +		if (iter == SGX_ENCL_MM_ITER_RESTART)
> +			continue;

Yuck.  Definitely should look at using RCU list.  I think the whole
function would boil down to:

	list_for_each_entry_rcu(...) {
		down_read(&mm->mm->mmap_sem);
		ret = !sgx_encl_test_and_clear_young(next_mm->mm, page);
		up_read(&mm->mm->mmap_sem);

		if (ret || (encl->flags & SGX_ENCL_DEAD))
			break;
	}

	if (!ret || (encl->flags & SGX_ENCL_DEAD)) {
		mutex_lock(&encl->lock);
		page->desc |= SGX_ENCL_PAGE_RECLAIMED;
		mutex_unlock(&encl->lock);
	}
> +
> +		down_read(&next_mm->mm->mmap_sem);
> +		mutex_lock(&encl->lock);

Acquiring encl->lock just to check if its dead is a bit silly.

> +
> +		if (encl->flags & SGX_ENCL_DEAD) {
> +			page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> +			ret = true;
> +			goto out_stop;
> +		}
> +
> +		ret = !sgx_encl_test_and_clear_young(next_mm->mm, page);
> +		if (!ret)
> +			goto out_stop;
> +
> +		mutex_unlock(&encl->lock);
> +		up_read(&next_mm->mm->mmap_sem);
> +	}
> +
> +	page->desc |= SGX_ENCL_PAGE_RECLAIMED;

SGX_ENCL_PAGE_RECLAIMED needs to be while holding encl->lock.  Putting
everything together, I think the function would boil down to:

	list_for_each_entry_rcu(...) {
		if (encl->flags & SGX_ENCL_DEAD)
			break;

		down_read(&mm->mm->mmap_sem);
		ret = !sgx_encl_test_and_clear_young(next_mm->mm, page);
		up_read(&mm->mm->mmap_sem);

		if (!ret)
			return false;
	}

	mutex_lock(&encl->lock);
	page->desc |= SGX_ENCL_PAGE_RECLAIMED;
	mutex_unlock(&encl->lock);

	return true;

> +	return true;
> +out_stop:
> +	mutex_unlock(&encl->lock);
> +	up_read(&next_mm->mm->mmap_sem);
> +	mmdrop(next_mm->mm);
> +	kref_put(&next_mm->refcount, sgx_encl_release_mm);
> +	return ret;
> +}
> +
> +static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
> +{
> +	struct sgx_encl_page *page = epc_page->owner;
> +	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
> +	struct sgx_encl *encl = page->encl;
> +	struct sgx_encl_mm *next_mm = NULL;
> +	struct sgx_encl_mm *prev_mm = NULL;
> +	struct vm_area_struct *vma;
> +	int iter;
> +	int ret;
> +
> +	while (true) {
> +		next_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
> +		if (prev_mm) {
> +			mmdrop(prev_mm->mm);
> +			kref_put(&prev_mm->refcount, sgx_encl_release_mm);
> +		}
> +		prev_mm = next_mm;
> +
> +		if (iter == SGX_ENCL_MM_ITER_DONE)
> +			break;
> +
> +		if (iter == SGX_ENCL_MM_ITER_RESTART)
> +			continue;
> +
> +		down_read(&next_mm->mm->mmap_sem);
> +		mutex_lock(&encl->lock);

There's no need to acquire encl->lock, only mmap_sem needs to be held
to zap PTEs.

> +		ret = sgx_encl_find(next_mm->mm, addr, &vma);
> +		if (!ret && encl == vma->vm_private_data)
> +			zap_vma_ptes(vma, addr, PAGE_SIZE);
> +
> +		mutex_unlock(&encl->lock);
> +		up_read(&next_mm->mm->mmap_sem);
> +	}
> +
> +	mutex_lock(&encl->lock);
> +
> +	if (!(encl->flags & SGX_ENCL_DEAD)) {
> +		ret = __eblock(sgx_epc_addr(epc_page));
> +		if (encls_failed(ret))
> +			ENCLS_WARN(ret, "EBLOCK");
> +	}
> +
> +	mutex_unlock(&encl->lock);
> +}
> +
> +static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
> +			  struct sgx_va_page *va_page, unsigned int va_offset)
> +{
> +	struct sgx_encl_page *encl_page = epc_page->owner;
> +	pgoff_t page_index = sgx_encl_get_index(encl, encl_page);
> +	pgoff_t pcmd_index = sgx_pcmd_index(encl, page_index);
> +	unsigned long pcmd_offset = sgx_pcmd_offset(page_index);
> +	struct sgx_pageinfo pginfo;
> +	struct page *backing;
> +	struct page *pcmd;
> +	int ret;
> +
> +	backing = sgx_encl_get_backing_page(encl, page_index);
> +	if (IS_ERR(backing)) {
> +		ret = PTR_ERR(backing);
> +		goto err_backing;
> +	}
> +
> +	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
> +	if (IS_ERR(pcmd)) {
> +		ret = PTR_ERR(pcmd);
> +		goto err_pcmd;
> +	}
> +
> +	pginfo.addr = 0;
> +	pginfo.contents = (unsigned long)kmap_atomic(backing);
> +	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
> +	pginfo.secs = 0;
> +	ret = __ewb(&pginfo, sgx_epc_addr(epc_page),
> +		    sgx_epc_addr(va_page->epc_page) + va_offset);
> +	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
> +	kunmap_atomic((void *)(unsigned long)pginfo.contents);
> +
> +	set_page_dirty(pcmd);
> +	put_page(pcmd);
> +	set_page_dirty(backing);
> +
> +err_pcmd:
> +	put_page(backing);
> +
> +err_backing:
> +	return ret;
> +}
> +
> +static void sgx_ipi_cb(void *info)
> +{
> +}
> +
> +static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool do_free)
> +{
> +	struct sgx_encl_page *encl_page = epc_page->owner;
> +	struct sgx_encl *encl = encl_page->encl;
> +	struct sgx_encl_mm *next_mm = NULL;
> +	struct sgx_encl_mm *prev_mm = NULL;
> +	struct sgx_va_page *va_page;
> +	unsigned int va_offset;
> +	int iter;
> +	int ret;
> +
> +	cpumask_clear(&encl->cpumask);
> +
> +	while (true) {
> +		next_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
> +		if (prev_mm) {
> +			mmdrop(prev_mm->mm);
> +			kref_put(&prev_mm->refcount, sgx_encl_release_mm);
> +		}
> +		prev_mm = next_mm;
> +
> +		if (iter == SGX_ENCL_MM_ITER_DONE)
> +			break;
> +
> +		if (iter == SGX_ENCL_MM_ITER_RESTART)
> +			continue;
> +
> +		cpumask_or(&encl->cpumask, &encl->cpumask,
> +			   mm_cpumask(next_mm->mm));
> +	}

Sending IPIs to flush CPUs out of the enclave is only necessary if the
enclave is alive, untracked and there are threads actively running in
the enclave.  I.e. calculate cpumask only when necessary.

This open coding of IPI sending made me realize the driver no long
invalidates an enclave if an ENCLS instruction fails unexpectedly.  That
is going to lead to absolute carnage if something does go wrong as there
will be no recovery path, i.e. the kernel log will be spammed to death
with ENCLS WARNings.  Debugging future development will be a nightmare if
a single ENCLS bug obliterates the kernel.

> +
> +	encl_page->desc &= ~SGX_ENCL_PAGE_RECLAIMED;
> +
> +	if (!(encl->flags & SGX_ENCL_DEAD)) {
> +		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
> +					   list);
> +		va_offset = sgx_alloc_va_slot(va_page);
> +		if (sgx_va_page_full(va_page))
> +			list_move_tail(&va_page->list, &encl->va_pages);
> +
> +		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset);
> +		if (ret == SGX_NOT_TRACKED) {
> +			ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
> +			if (ret) {
> +				if (encls_failed(ret) ||
> +				    encls_returned_code(ret))
> +					ENCLS_WARN(ret, "ETRACK");

Oof, this doesn't even return if ret != 0, e.g. we could WARN due to a
driver bug and then WARN again on EWB failure, or worse, somehow succeed
and continue on in some frankenstein state.

> +			}
> +
> +			ret = __sgx_encl_ewb(encl, epc_page, va_page,
> +					     va_offset);
> +			if (ret == SGX_NOT_TRACKED) {
> +				/* slow path, IPI needed */
> +				on_each_cpu_mask(&encl->cpumask, sgx_ipi_cb,
> +						 NULL, 1);
> +				ret = __sgx_encl_ewb(encl, epc_page, va_page,
> +						     va_offset);
> +			}
> +		}
> +
> +		if (ret)
> +			if (encls_failed(ret) || encls_returned_code(ret))
> +				ENCLS_WARN(ret, "EWB");

Yeesh, modding ENCLS_WARN to separate the warn condition and the raw error
code would eliminate both if statements.

> +
> +		encl_page->desc |= va_offset;
> +		encl_page->va_page = va_page;
> +	} else if (!do_free) {
> +		ret = __eremove(sgx_epc_addr(epc_page));
> +		WARN(ret, "EREMOVE returned %d\n", ret);

This can be ENCLS_WARN.

> +	}
> +
> +	if (do_free)
> +		sgx_free_page(epc_page);
> +
> +	encl_page->epc_page = NULL;
> +}
> +
> +static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
> +{
> +	struct sgx_encl_page *encl_page = epc_page->owner;
> +	struct sgx_encl *encl = encl_page->encl;
> +
> +	mutex_lock(&encl->lock);
> +
> +	sgx_encl_ewb(epc_page, false);
> +	encl->secs_child_cnt--;
> +	if (!encl->secs_child_cnt &&
> +	    (encl->flags & (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED))) {
> +		sgx_encl_ewb(encl->secs.epc_page, true);
> +	}
> +
> +	mutex_unlock(&encl->lock);
> +}
> +
> +/**
> + * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
> + * Takes a fixed chunk of pages from the global list of consumed EPC pages and
> + * tries to swap them. Only the pages that are either being freed by the
> + * consumer or actively used are skipped.
> + */
> +void sgx_reclaim_pages(void)
> +{
> +	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];
> +	struct sgx_epc_page *epc_page;
> +	struct sgx_epc_section *section;
> +	int i, j;
> +
> +	spin_lock(&sgx_active_page_list_lock);
> +	for (i = 0, j = 0; i < SGX_NR_TO_SCAN; i++) {
> +		if (list_empty(&sgx_active_page_list))
> +			break;
> +
> +		epc_page = list_first_entry(&sgx_active_page_list,
> +					    struct sgx_epc_page, list);
> +		list_del_init(&epc_page->list);
> +
> +		if (sgx_reclaimer_get(epc_page))
> +			chunk[j++] = epc_page;
> +		else
> +			/* The owner is freeing the page. No need to add the
> +			 * page back to the list of reclaimable pages.
> +			 */
> +			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> +	}
> +	spin_unlock(&sgx_active_page_list_lock);
> +
> +	for (i = 0; i < j; i++) {
> +		epc_page = chunk[i];
> +		if (sgx_reclaimer_evict(epc_page))
> +			continue;
> +
> +		sgx_reclaimer_put(epc_page);
> +
> +		spin_lock(&sgx_active_page_list_lock);
> +		list_add_tail(&epc_page->list, &sgx_active_page_list);
> +		spin_unlock(&sgx_active_page_list_lock);
> +
> +		chunk[i] = NULL;
> +	}
> +
> +	for (i = 0; i < j; i++) {
> +		epc_page = chunk[i];
> +		if (epc_page)
> +			sgx_reclaimer_block(epc_page);
> +	}
> +
> +	for (i = 0; i < j; i++) {
> +		epc_page = chunk[i];
> +		if (epc_page) {
> +			sgx_reclaimer_write(epc_page);
> +			sgx_reclaimer_put(epc_page);
> +			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> +
> +			section = sgx_epc_section(epc_page);
> +			spin_lock(&section->lock);
> +			sgx_section_put_page(section, epc_page);
> +			spin_unlock(&section->lock);
> +		}
> +	}
> +}
> +
> +unsigned long sgx_calc_free_cnt(void)
> +{
> +	struct sgx_epc_section *section;
> +	unsigned long free_cnt = 0;
> +	int i;
> +
> +	for (i = 0; i < sgx_nr_epc_sections; i++) {
> +		section = &sgx_epc_sections[i];
> +		free_cnt += section->free_cnt;
> +	}
> +
> +	return free_cnt;
> +}
> +
> +static inline bool sgx_should_reclaim(void)
> +{
> +	return sgx_calc_free_cnt() < SGX_NR_HIGH_PAGES &&
> +	       !list_empty(&sgx_active_page_list);
> +}
> +
> +static int ksgxswapd(void *p)
> +{
> +	set_freezable();
> +
> +	while (!kthread_should_stop()) {
> +		if (try_to_freeze())
> +			continue;
> +
> +		wait_event_freezable(ksgxswapd_waitq, kthread_should_stop() ||
> +						      sgx_should_reclaim());
> +
> +		if (sgx_should_reclaim())
> +			sgx_reclaim_pages();
> +
> +		cond_resched();
> +	}
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
> index 2337b63ba487..ed587627ca81 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -12,6 +12,7 @@
>  
>  struct sgx_epc_page {
>  	unsigned long desc;
> +	struct sgx_encl_page *owner;
>  	struct list_head list;
>  };
>  
> @@ -42,9 +43,14 @@ extern bool sgx_enabled;
>   *				physical memory. The existing and near-future
>   *				hardware defines at most eight sections, hence
>   *				three bits to hold a section.
> + * %SGX_EPC_PAGE_RECLAIMABLE:	The page has been been marked as reclaimable.
> + *				Pages need to be colored this way because a page
> + *				can be out of the active page list in the
> + *				process of being swapped out.
>   */
>  enum sgx_epc_page_desc {
>  	SGX_EPC_SECTION_MASK			= GENMASK_ULL(3, 0),
> +	SGX_EPC_PAGE_RECLAIMABLE		= BIT(4),
>  	/* bits 12-63 are reserved for the physical page address of the page */
>  };
>  
> @@ -60,10 +66,36 @@ static inline void *sgx_epc_addr(struct sgx_epc_page *page)
>  	return section->va + (page->desc & PAGE_MASK) - section->pa;
>  }
>  
> -struct sgx_epc_page *sgx_alloc_page(void);
> +void sgx_section_put_page(struct sgx_epc_section *section,
> +			  struct sgx_epc_page *page);
> +struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
>  int __sgx_free_page(struct sgx_epc_page *page);
>  void sgx_free_page(struct sgx_epc_page *page);
>  int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
>  	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
>  
> +/**
> + * enum sgx_swap_constants - the constants used by the swapping code
> + * %SGX_NR_TO_SCAN:	the number of pages to scan in a single round
> + * %SGX_NR_LOW_PAGES:	the low watermark for ksgxswapd when it starts to swap
> + *			pages.
> + * %SGX_NR_HIGH_PAGES:	the high watermark for ksgxswapd what it stops swapping
> + *			pages.
> + */
> +enum sgx_swap_constants {
> +	SGX_NR_TO_SCAN		= 16,
> +	SGX_NR_LOW_PAGES	= 32,
> +	SGX_NR_HIGH_PAGES	= 64,
> +};
> +
> +extern int sgx_nr_epc_sections;
> +extern struct list_head sgx_active_page_list;
> +extern spinlock_t sgx_active_page_list_lock;
> +extern struct wait_queue_head(ksgxswapd_waitq);
> +
> +void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
> +unsigned long sgx_calc_free_cnt(void);
> +void sgx_reclaim_pages(void);
> +int sgx_page_reclaimer_init(void);
> +
>  #endif /* _X86_SGX_H */
> -- 
> 2.19.1
> 
