Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22F0C742A2
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 21:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 740CA206B8
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 21:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfGKVNP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 17:13:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:24095 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfGKVNP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 17:13:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 14:13:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="160192420"
Received: from mmoerth-mobl6.ger.corp.intel.com (HELO localhost) ([10.249.35.82])
  by orsmga008.jf.intel.com with ESMTP; 11 Jul 2019 14:13:09 -0700
Date:   Fri, 12 Jul 2019 00:13:07 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v21 1/2] x86/sgx: Use SRCU to protect mm_list during
 reclaim
Message-ID: <20190711211307.cymfaxeuq73v63xg@linux.intel.com>
References: <20190711161625.15786-1-sean.j.christopherson@intel.com>
 <20190711161625.15786-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711161625.15786-2-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 09:16:24AM -0700, Sean Christopherson wrote:
> Reclaiming enclaves faces a bit of a conundrum when it comes to lock
> ordering.  The reclaim flows need to take mmap_sem for read, e.g. to age
> and zap PTEs on arbitrary mm_structs.  But reclaim must first walk the
> enclave's list of mm_structs, which could be modified asynchronously to
> reclaim.  Because modifying the list of mm_structs is done in reaction
> to vma changes, i.e. with mmap_sem held exclusively, taking enclave's
> mm_lock to protect the list walk in reclaim would lead to deadlocks due
> to conflicting lock ordering.  To avoid this, SGX currently uses a
> custom walker that drops mm_lock and restarts the walk as needed.

+1

> Use SRCU to protect reclaim instead of using a custom walker to avoid
> the aforementioned lock issues.  Using SRCU improves readability in the
> reclaimer by eliminating the need to juggle mm_lock during reclaim since
> it can take mmap_sem() underneath srcu_read_lock().  And since relcaim
> doesn't drop its SRCU read lock, there is no need to grab a reference to
> encl_mm.

Speaking about "lock issue" would mean to me an actual regression. I do
agree that SRCU is a the right step forward.

> Not taking a reference to encl_mm is not just an optimization, it's also
> functionally necessary and a major motivation to moving to SRCu. Putting
> the reference can invoke sgx_encl_mm_release(), which calls
> synchronize_srcu() and will deadlock if done while holding the SRCU read
> lock.  Not taking a reference paves the way for additional refcounting
> improvements that would be extremely difficult to implement when using
> the custom walker due to cyclical dependencies on the refcount.

I'm not sure I get this. The existing code does not have a call to
synchronize_srcu().

> Speaking of sgx_encl_mm_release(), the whole purpose of using SRCU is
> that sgx_encl_mm_release() is blocked (if called on another cpu) by
> synchronize_srcu(), which in turn prevents mmdrop() from freeing the
> mm_struct while reclaim is in the SRCU critical section.  Ultimately,
> reclaim just needs to ensure mm_struct isn't freed so that it can call
> mmget_not_zero() to prevent the page tables from being dropped while it
> accesses PTEs, i.e. it doesn't matter if the encl_mm is dying, reclaim
> just needs to make sure it's not fully dead.

+1

> To avoid calling synchronize_rcu() while holding rcu_read_lock(), use
> mmput_async() in the reclaimer, e.g. __mmput() closes all VMAs, thus
> triggering sgx_encl_mm_release() and synchronize_srcu().  Alternatively
> sgx_encl_mm_release() could always call synchronize_rcu() in a worker
> thread (see below), but doing __mmput() in a worker thread is desirable
> from an SGX performance perspective, i.e. doesn't stall the reclaimer
> CPU to release the mm.

+1

> 
> And finally, the last deadlock scenario is if sgx_encl_mm_release() is
> invoked on an in-use mm_struct, e.g. via munmap().
> 
> CPU0                     CPU1
> munmap()
> down_write(&mmap_sem)
>                          srcu_read_lock()
> 
> synchronize_srcu()
>                          down_read(&mmap_sem) <- deadlock
> 
> Avoid deadlock in this scenario by synchronizing SRCU via a worker
> thread.  SRCU ensures only the liveliness of the mm_struct itself,
> which is guaranteed by an mmgrab() prior to scheduling the work.
> The reclaimer is responsible for checking mm_users and the VMAs to
> ensure it doesn't touch stale PTEs, i.e. delaying synchronization does
> not affect the reclaimer's responsiblities.  The delay does add one new
> wrinkle in that sgx_encl_mm_add() and sgx_vma_open() can see a dying
> encl_mm.  Previously this was prevented by virtue of sgx_vma_close()
> being mutually exclusive (the caller must hold down_write(&mmap_sem)).
> Handle such a case by using kref_get_unless_zero().
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/Kconfig                      |   1 +
>  arch/x86/kernel/cpu/sgx/driver/main.c |  34 ++----
>  arch/x86/kernel/cpu/sgx/encl.c        | 165 ++++++++++++++------------
>  arch/x86/kernel/cpu/sgx/encl.h        |   9 +-
>  arch/x86/kernel/cpu/sgx/reclaim.c     |  71 ++++-------
>  5 files changed, 124 insertions(+), 156 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index a0fd17c32521..17558cf48a8a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1918,6 +1918,7 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
>  config INTEL_SGX
>  	bool "Intel SGX core functionality"
>  	depends on X86_64 && CPU_SUP_INTEL
> +	select SRCU
>  	---help---
>  	  Intel(R) SGX is a set of CPU instructions that can be used by
>  	  applications to set aside private regions of code and data, referred
> diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
> index c7fc32e26105..27076754f7d8 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/main.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/main.c
> @@ -25,6 +25,7 @@ u32 sgx_xsave_size_tbl[64];
>  static int sgx_open(struct inode *inode, struct file *file)
>  {
>  	struct sgx_encl *encl;
> +	int ret;
>  
>  	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
>  	if (!encl)
> @@ -38,6 +39,12 @@ static int sgx_open(struct inode *inode, struct file *file)
>  	INIT_LIST_HEAD(&encl->mm_list);
>  	spin_lock_init(&encl->mm_lock);
>  
> +	ret = init_srcu_struct(&encl->srcu);
> +	if (ret) {
> +		kfree(encl);
> +		return ret;
> +	}
> +
>  	file->private_data = encl;
>  
>  	return 0;
> @@ -65,25 +72,6 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
>  }
>  #endif
>  
> -static int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
> -{
> -	struct sgx_encl_mm *encl_mm;
> -
> -	encl_mm = kzalloc(sizeof(*encl_mm), GFP_KERNEL);
> -	if (!encl_mm)
> -		return -ENOMEM;
> -
> -	encl_mm->encl = encl;
> -	encl_mm->mm = mm;
> -	kref_init(&encl_mm->refcount);
> -
> -	spin_lock(&encl->mm_lock);
> -	list_add(&encl_mm->list, &encl->mm_list);
> -	spin_unlock(&encl->mm_lock);
> -
> -	return 0;
> -}
> -
>  /**
>   * sgx_calc_vma_prot() - Calculate VMA prot bits
>   * @encl:	an enclave
> @@ -129,11 +117,9 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC) & ~vm_prot_bits)
>  		return -EACCES;
>  
> -	if (!sgx_encl_get_mm(encl, vma->vm_mm)) {
> -		ret = sgx_encl_mm_add(encl, vma->vm_mm);
> -		if (ret)
> -			return ret;
> -	}
> +	ret = sgx_encl_mm_add(encl, vma->vm_mm);
> +	if (ret)
> +		return ret;
>  
>  	if (!(vm_prot_bits & VM_READ))
>  		vma->vm_flags &= ~VM_MAYREAD;
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 853ea8ef3ada..64ae7d705eb1 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -132,62 +132,116 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
>  	return entry;
>  }
>  
> -void sgx_encl_mm_release(struct kref *ref)
> +static void sgx_encl_mm_release_deferred(struct work_struct *work)
> +{
> +	struct sgx_encl_mm *encl_mm =
> +		container_of(work, struct sgx_encl_mm, release_work);
> +
> +	mmdrop(encl_mm->mm);
> +	synchronize_srcu(&encl_mm->encl->srcu);
> +	kfree(encl_mm);
> +}
> +
> +static void sgx_encl_mm_release(struct kref *ref)
>  {
>  	struct sgx_encl_mm *encl_mm =
>  		container_of(ref, struct sgx_encl_mm, refcount);
>  
>  	spin_lock(&encl_mm->encl->mm_lock);
> -	list_del(&encl_mm->list);
> +	list_del_rcu(&encl_mm->list);
>  	spin_unlock(&encl_mm->encl->mm_lock);
>  
> -	kfree(encl_mm);
> +	/*
> +	 * If the mm has users, then do SRCU synchronization in a worker thread
> +	 * to avoid a deadlock with the reclaimer.  The caller holds mmap_sem
> +	 * for write, while the reclaimer will acquire mmap_sem for read if it
> +	 * is reclaiming from this enclave.  Invoking synchronize_srcu() here
> +	 * will hang waiting for the reclaimer to drop its RCU read lock, while
> +	 * the reclaimer will get stuck waiting to acquire mmap_sem.  The async
> +	 * shenanigans can be avoided if there are no mm users as the reclaimer
> +	 * will not acquire mmap_sem in that case.
> +	 */
> +	if (atomic_read(&encl_mm->mm->mm_users)) {
> +		mmgrab(encl_mm->mm);
> +		INIT_WORK(&encl_mm->release_work, sgx_encl_mm_release_deferred);
> +		schedule_work(&encl_mm->release_work);
> +	} else {
> +		synchronize_srcu(&encl_mm->encl->srcu);
> +		kfree(encl_mm);
> +	}
>  }
>  
> -struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
> -				    struct mm_struct *mm)
> +static struct sgx_encl_mm *sgx_encl_find_mm(struct sgx_encl *encl,
> +					    struct mm_struct *mm)
>  {
>  	struct sgx_encl_mm *encl_mm = NULL;
> -	struct sgx_encl_mm *prev_mm = NULL;
> -	int iter;
> +	struct sgx_encl_mm *tmp;
> +	int idx;
>  
> -	while (true) {
> -		encl_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
> -		if (prev_mm)
> -			kref_put(&prev_mm->refcount, sgx_encl_mm_release);
> -		prev_mm = encl_mm;
> +	idx = srcu_read_lock(&encl->srcu);
>  
> -		if (iter == SGX_ENCL_MM_ITER_DONE)
> +	list_for_each_entry_rcu(tmp, &encl->mm_list, list) {
> +		if (tmp->mm == mm) {
> +			encl_mm = tmp;
>  			break;
> -
> -		if (iter == SGX_ENCL_MM_ITER_RESTART)
> -			continue;
> -
> -		if (mm == encl_mm->mm)
> -			return encl_mm;
> +		}
>  	}
>  
> -	return NULL;
> +	srcu_read_unlock(&encl->srcu, idx);
> +
> +	return encl_mm;
>  }
>  
> -
> -static void sgx_vma_open(struct vm_area_struct *vma)
> +int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
>  {
> -	struct sgx_encl *encl = vma->vm_private_data;
> +	struct sgx_encl_mm *encl_mm;
>  
> -	if (!encl)
> -		return;
> +	lockdep_assert_held_exclusive(&mm->mmap_sem);

Just a question: what does it check (12:10AM too tired to check,
apologies)?

Anyway, no blocking issues. Thank you.

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
