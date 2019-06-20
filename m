Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29122C43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 21:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6668206BA
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 21:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfFTVDp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 17:03:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:33040 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfFTVDp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 17:03:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 14:03:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="181945633"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jun 2019 14:03:38 -0700
Date:   Fri, 21 Jun 2019 00:03:36 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 01/12] x86/sgx: Use mmu_notifier.release() instead
 of per-vma refcounting
Message-ID: <20190620210324.GF15383@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619222401.14942-2-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 03:23:50PM -0700, Sean Christopherson wrote:
> Using per-vma refcounting to track mm_structs associated with an enclave
> requires hooking .vm_close(), which in turn prevents the mm from merging
> vmas (precisely to allow refcounting).

Why having sgx_vma_close() prevents that? I do not understand the
problem statement.

> Avoid refcounting encl_mm altogether by registering an mmu_notifier at
> .mmap(), removing the dying encl_mm at mmu_notifier.release() and
> protecting mm_list during reclaim via a per-enclave SRCU.

Right, there is the potential collision with my changes:

1. Your patch: enclave life-cycle equals life-cycle of all processes
   that are associated with the enclave.
2. My (yet be sent) patch: enclave life-cycle equals the life cycle.

I won't rush with my patch. I rather merge neither at this point and
you can review mine after you come back from your vacation.

> Removing refcounting/vm_close() allows merging of enclave vmas, at the
> cost of delaying removal of encl_mm structs from mm_list, i.e. an mm is
> disassociated from an enclave when the mm exits or the enclave dies, as
> opposed to when the last vma (in a given mm) is closed.
> 
> The impact of delying encl_mm removal is its memory footprint and
> whatever overhead is incurred during EPC reclaim (to walk an mm's vmas).
> Practically speaking, a stale encl_mm will exist for a meaningful amount
> of time if and only if the enclave is mapped in a long-lived process and
> then passed off to another long-lived process.  It is expected that the
> vast majority of use cases will not encounter this condition, e.g. even
> using a daemon to build enclaves should not result in a stale encl_mm as
> the builder should never need to mmap() the enclave.

This paragraph speaks only about "well behaving" software.

> Even if there are scenarios that lead to defunct encl_mms, the cost is
> likely far outweighed by the benefits of reducing the number of vmas
> across all enclaves.
> 
> Note, using SRCU to protect mm_list is not strictly necessary, i.e. the
> existing walker with encl_mm refcounting could be massaged to work with
> mmu_notifier.release(), but the resulting code is subtle and fragile (I
> never actually got it working).  The primary issue is that an encl_mm
> can't be moved off the list until its refcount goes to zero, otherwise
> the custom walker goes off into the weeds.  The refcount requirement
> then prevents using mm_list to identify if an mmu_notifier.release()
> has fired, i.e. another mechanism is needed to guard against races
> between exit_mmap() and sgx_release().

Is it really impossible to send a separate SRCU patch?

I fully agree with the SRCU whereas rest of this patch is still
under debate.

If you could do that, I can merge it in no time. It is a small
step into better direction.

> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Needs to be rebased because the master missing your earlier bug fix.

> ---
>  arch/x86/Kconfig                       |   2 +
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c |  14 --
>  arch/x86/kernel/cpu/sgx/driver/main.c  |  38 ++++
>  arch/x86/kernel/cpu/sgx/encl.c         | 234 +++++++++++--------------
>  arch/x86/kernel/cpu/sgx/encl.h         |  19 +-
>  arch/x86/kernel/cpu/sgx/reclaim.c      |  71 +++-----
>  6 files changed, 182 insertions(+), 196 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index a0fd17c32521..940c52762f24 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1918,6 +1918,8 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
>  config INTEL_SGX
>  	bool "Intel SGX core functionality"
>  	depends on X86_64 && CPU_SUP_INTEL
> +	select MMU_NOTIFIER
> +	select SRCU
>  	---help---
>  	  Intel(R) SGX is a set of CPU instructions that can be used by
>  	  applications to set aside private regions of code and data, referred
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index d17c60dca114..3552d642b26f 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -276,7 +276,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>  {
>  	unsigned long encl_size = secs->size + PAGE_SIZE;
>  	struct sgx_epc_page *secs_epc;
> -	struct sgx_encl_mm *encl_mm;
>  	unsigned long ssaframesize;
>  	struct sgx_pageinfo pginfo;
>  	struct sgx_secinfo secinfo;
> @@ -311,12 +310,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>  
>  	INIT_WORK(&encl->work, sgx_add_page_worker);
>  
> -	encl_mm = sgx_encl_mm_add(encl, current->mm);
> -	if (IS_ERR(encl_mm)) {
> -		ret = PTR_ERR(encl_mm);
> -		goto err_out;
> -	}
> -
>  	secs_epc = sgx_alloc_page(&encl->secs, true);
>  	if (IS_ERR(secs_epc)) {
>  		ret = PTR_ERR(secs_epc);
> @@ -369,13 +362,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>  		encl->backing = NULL;
>  	}
>  
> -	if (!list_empty(&encl->mm_list)) {
> -		encl_mm = list_first_entry(&encl->mm_list, struct sgx_encl_mm,
> -					   list);
> -		list_del(&encl_mm->list);
> -		kfree(encl_mm);
> -	}
> -
>  	mutex_unlock(&encl->lock);
>  	return ret;
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
> index 0c831ee5e2de..07aa5f91b2dd 100644
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
> @@ -46,6 +53,32 @@ static int sgx_open(struct inode *inode, struct file *file)
>  static int sgx_release(struct inode *inode, struct file *file)
>  {
>  	struct sgx_encl *encl = file->private_data;
> +	struct sgx_encl_mm *encl_mm;
> +
> +	/*
> +	 * Objects can't be *moved* off an RCU protected list (deletion is ok),
> +	 * nor can the object be freed until after synchronize_srcu().
> +	 */
> +restart:
> +	spin_lock(&encl->mm_lock);
> +	if (list_empty(&encl->mm_list)) {
> +		encl_mm = NULL;
> +	} else {
> +		encl_mm = list_first_entry(&encl->mm_list, struct sgx_encl_mm,
> +					   list);
> +		list_del_rcu(&encl_mm->list);
> +	}
> +	spin_unlock(&encl->mm_lock);
> +
> +	if (encl_mm) {
> +		synchronize_srcu(&encl->srcu);
> +
> +		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
> +
> +		sgx_encl_mm_release(encl_mm);
> +
> +		goto restart;
> +	}
>  
>  	kref_put(&encl->refcount, sgx_encl_release);
>  
> @@ -63,6 +96,11 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
>  static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	struct sgx_encl *encl = file->private_data;
> +	int ret;
> +
> +	ret = sgx_encl_mm_add(encl, vma->vm_mm);
> +	if (ret)
> +		return ret;
>  
>  	vma->vm_ops = &sgx_vm_ops;
>  	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 9566eb72d417..c6436bbd4a68 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -132,103 +132,125 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
>  	return entry;
>  }
>  
> -struct sgx_encl_mm *sgx_encl_mm_add(struct sgx_encl *encl,
> -				    struct mm_struct *mm)
> +static void sgx_encl_mm_release_wq(struct work_struct *work)
> +{
> +	struct sgx_encl_mm *encl_mm =
> +		container_of(work, struct sgx_encl_mm, release_work);
> +
> +	sgx_encl_mm_release(encl_mm);
> +}
> +
> +/*
> + * Being a call_srcu() callback, this needs to be short, and sgx_encl_release()
> + * is anything but short.  Do the final freeing in yet another async callback.
> + */
> +static void sgx_encl_mm_release_delayed(struct rcu_head *rcu)

Would rename this either as *_tail() or *_deferred().

> +{
> +	struct sgx_encl_mm *encl_mm =
> +		container_of(rcu, struct sgx_encl_mm, rcu);
> +
> +	INIT_WORK(&encl_mm->release_work, sgx_encl_mm_release_wq);
> +	schedule_work(&encl_mm->release_work);
> +}
> +
> +static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
> +				     struct mm_struct *mm)
> +{
> +	struct sgx_encl_mm *encl_mm =
> +		container_of(mn, struct sgx_encl_mm, mmu_notifier);
> +	struct sgx_encl_mm *tmp = NULL;
> +
> +	/*
> +	 * The enclave itself can remove encl_mm.  Note, objects can't be moved
> +	 * off an RCU protected list, but deletion is ok.
> +	 */
> +	spin_lock(&encl_mm->encl->mm_lock);
> +	list_for_each_entry(tmp, &encl_mm->encl->mm_list, list) {
> +		if (tmp == encl_mm) {
> +			list_del_rcu(&encl_mm->list);
> +			break;
> +		}
> +	}
> +	spin_unlock(&encl_mm->encl->mm_lock);
> +
> +	if (tmp == encl_mm) {
> +		synchronize_srcu(&encl_mm->encl->srcu);
> +
> +		/*
> +		 * Delay freeing encl_mm until after mmu_notifier releases any
> +		 * SRCU locks.  synchronize_srcu() must be called from process
> +		 * context, i.e. we can't throw mmu_notifier_unregister() in a
> +		 * work queue and be done with it.
> +		 */
> +		mmu_notifier_unregister_no_release(mn, mm);
> +		mmu_notifier_call_srcu(&encl_mm->rcu,
> +				       &sgx_encl_mm_release_delayed);
> +	}
> +}
> +
> +static const struct mmu_notifier_ops sgx_mmu_notifier_ops = {
> +	.release		= sgx_mmu_notifier_release,
> +};
> +
> +static struct sgx_encl_mm *sgx_encl_find_mm(struct sgx_encl *encl,
> +					    struct mm_struct *mm)
> +{
> +	struct sgx_encl_mm *encl_mm = NULL;
> +	struct sgx_encl_mm *tmp;
> +	int idx;
> +
> +	idx = srcu_read_lock(&encl->srcu);
> +
> +	list_for_each_entry_rcu(tmp, &encl->mm_list, list) {
> +		if (tmp->mm == mm) {
> +			encl_mm = tmp;
> +			break;
> +		}
> +	}
> +
> +	srcu_read_unlock(&encl->srcu, idx);
> +
> +	return encl_mm;
> +}
> +
> +int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
>  {
>  	struct sgx_encl_mm *encl_mm;
> +	int ret;
> +
> +	lockdep_assert_held_exclusive(&mm->mmap_sem);
> +
> +	/*
> +	 * mm_structs are kept on mm_list until the mm or the enclave dies,
> +	 * i.e. once an mm is off the list, it's gone for good, therefore it's
> +	 * impossible to get a false positive on @mm due to a stale mm_list.
> +	 */
> +	if (sgx_encl_find_mm(encl, mm))
> +		return 0;
>  
>  	encl_mm = kzalloc(sizeof(*encl_mm), GFP_KERNEL);
>  	if (!encl_mm)
> -		return ERR_PTR(-ENOMEM);
> +		return -ENOMEM;
>  
>  	encl_mm->encl = encl;
>  	encl_mm->mm = mm;
> -	kref_init(&encl_mm->refcount);
> +	encl_mm->mmu_notifier.ops = &sgx_mmu_notifier_ops;
> +
> +	ret = __mmu_notifier_register(&encl_mm->mmu_notifier, mm);
> +	if (ret) {
> +		kfree(encl_mm);
> +		return ret;
> +	}
> +
> +	kref_get(&encl->refcount);
>  
>  	spin_lock(&encl->mm_lock);
> -	list_add(&encl_mm->list, &encl->mm_list);
> +	list_add_rcu(&encl_mm->list, &encl->mm_list);
>  	spin_unlock(&encl->mm_lock);
>  
> -	return encl_mm;
> -}
> +	synchronize_srcu(&encl->srcu);
>  
> -void sgx_encl_mm_release(struct kref *ref)
> -{
> -	struct sgx_encl_mm *encl_mm =
> -		container_of(ref, struct sgx_encl_mm, refcount);
> -
> -	spin_lock(&encl_mm->encl->mm_lock);
> -	list_del(&encl_mm->list);
> -	spin_unlock(&encl_mm->encl->mm_lock);
> -
> -	kfree(encl_mm);
> -}
> -
> -static struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
> -					   struct mm_struct *mm)
> -{
> -	struct sgx_encl_mm *encl_mm = NULL;
> -	struct sgx_encl_mm *prev_mm = NULL;
> -	int iter;
> -
> -	while (true) {
> -		encl_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
> -		if (prev_mm)
> -			kref_put(&prev_mm->refcount, sgx_encl_mm_release);
> -		prev_mm = encl_mm;
> -
> -		if (iter == SGX_ENCL_MM_ITER_DONE)
> -			break;
> -
> -		if (iter == SGX_ENCL_MM_ITER_RESTART)
> -			continue;
> -
> -		if (mm == encl_mm->mm)
> -			return encl_mm;
> -	}
> -
> -	return NULL;
> -}
> -
> -static void sgx_vma_open(struct vm_area_struct *vma)
> -{
> -	struct sgx_encl *encl = vma->vm_private_data;
> -	struct sgx_encl_mm *encl_mm;
> -
> -	if (!encl)
> -		return;
> -
> -	if (encl->flags & SGX_ENCL_DEAD)
> -		goto error;
> -
> -	encl_mm = sgx_encl_get_mm(encl, vma->vm_mm);
> -	if (!encl_mm) {
> -		encl_mm = sgx_encl_mm_add(encl, vma->vm_mm);
> -		if (IS_ERR(encl_mm))
> -			goto error;
> -	}
> -
> -	return;
> -
> -error:
> -	vma->vm_private_data = NULL;
> -}
> -
> -static void sgx_vma_close(struct vm_area_struct *vma)
> -{
> -	struct sgx_encl *encl = vma->vm_private_data;
> -	struct sgx_encl_mm *encl_mm;
> -
> -	if (!encl)
> -		return;
> -
> -	encl_mm = sgx_encl_get_mm(encl, vma->vm_mm);
> -	if (encl_mm) {
> -		kref_put(&encl_mm->refcount, sgx_encl_mm_release);
> -
> -		/* Release kref for the VMA. */
> -		kref_put(&encl_mm->refcount, sgx_encl_mm_release);
> -	}
> +	return 0;
>  }
>  
>  static unsigned int sgx_vma_fault(struct vm_fault *vmf)
> @@ -366,8 +388,6 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
>  }
>  
>  const struct vm_operations_struct sgx_vm_ops = {
> -	.close = sgx_vma_close,
> -	.open = sgx_vma_open,
>  	.fault = sgx_vma_fault,
>  	.access = sgx_vma_access,
>  };
> @@ -465,7 +485,7 @@ void sgx_encl_release(struct kref *ref)
>  	if (encl->backing)
>  		fput(encl->backing);
>  
> -	WARN(!list_empty(&encl->mm_list), "sgx: mm_list non-empty");
> +	WARN_ONCE(!list_empty(&encl->mm_list), "sgx: mm_list non-empty");
>  
>  	kfree(encl);
>  }
> @@ -503,46 +523,6 @@ struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index)
>  	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
>  }
>  
> -/**
> - * sgx_encl_next_mm() - Iterate to the next mm
> - * @encl:	an enclave
> - * @mm:		an mm list entry
> - * @iter:	iterator status
> - *
> - * Return: the enclave mm or NULL
> - */
> -struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
> -				     struct sgx_encl_mm *encl_mm, int *iter)
> -{
> -	struct list_head *entry;
> -
> -	WARN(!encl, "%s: encl is NULL", __func__);
> -	WARN(!iter, "%s: iter is NULL", __func__);
> -
> -	spin_lock(&encl->mm_lock);
> -
> -	entry = encl_mm ? encl_mm->list.next : encl->mm_list.next;
> -	WARN(!entry, "%s: entry is NULL", __func__);
> -
> -	if (entry == &encl->mm_list) {
> -		spin_unlock(&encl->mm_lock);
> -		*iter = SGX_ENCL_MM_ITER_DONE;
> -		return NULL;
> -	}
> -
> -	encl_mm = list_entry(entry, struct sgx_encl_mm, list);
> -
> -	if (!kref_get_unless_zero(&encl_mm->refcount)) {
> -		spin_unlock(&encl->mm_lock);
> -		*iter = SGX_ENCL_MM_ITER_RESTART;
> -		return NULL;
> -	}
> -
> -	spin_unlock(&encl->mm_lock);
> -	*iter = SGX_ENCL_MM_ITER_NEXT;
> -	return encl_mm;
> -}
> -
>  static int sgx_encl_test_and_clear_young_cb(pte_t *ptep, pgtable_t token,
>  					    unsigned long addr, void *data)
>  {
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index c557f0374d74..0904b3c20ed0 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -9,9 +9,11 @@
>  #include <linux/kref.h>
>  #include <linux/list.h>
>  #include <linux/mm_types.h>
> +#include <linux/mmu_notifier.h>
>  #include <linux/mutex.h>
>  #include <linux/notifier.h>
>  #include <linux/radix-tree.h>
> +#include <linux/srcu.h>
>  #include <linux/workqueue.h>
>  
>  /**
> @@ -57,8 +59,10 @@ enum sgx_encl_flags {
>  struct sgx_encl_mm {
>  	struct sgx_encl *encl;
>  	struct mm_struct *mm;
> -	struct kref refcount;
>  	struct list_head list;
> +	struct mmu_notifier mmu_notifier;
> +	struct work_struct release_work;
> +	struct rcu_head rcu;
>  };
>  
>  struct sgx_encl {
> @@ -72,6 +76,7 @@ struct sgx_encl {
>  	spinlock_t mm_lock;
>  	struct file *backing;
>  	struct kref refcount;
> +	struct srcu_struct srcu;
>  	unsigned long base;
>  	unsigned long size;
>  	unsigned long ssaframesize;
> @@ -118,11 +123,13 @@ void sgx_encl_destroy(struct sgx_encl *encl);
>  void sgx_encl_release(struct kref *ref);
>  pgoff_t sgx_encl_get_index(struct sgx_encl *encl, struct sgx_encl_page *page);
>  struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index);
> -struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
> -				     struct sgx_encl_mm *encl_mm, int *iter);
> -struct sgx_encl_mm *sgx_encl_mm_add(struct sgx_encl *encl,
> -				    struct mm_struct *mm);
> -void sgx_encl_mm_release(struct kref *ref);
> +int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
> +static inline void sgx_encl_mm_release(struct sgx_encl_mm *encl_mm)
> +{
> +	kref_put(&encl_mm->encl->refcount, sgx_encl_release);
> +
> +	kfree(encl_mm);
> +}

Please just open code this to the two call sites. Makes the code hard to
follow.

Right now I did not find anything else questionable from the code
changes. Repeating myself but if it is by any means possible before
going away, can you construct a pure SRCU patch.

I could then reconstruct my changes on top off that, which would
make evalution of both heck a lot easier.

/Jarkko
