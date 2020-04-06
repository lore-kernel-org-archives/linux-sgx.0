Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD35C2BA17
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 16:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50DE9248C4
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 16:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgDFQP7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 12:15:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:30203 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbgDFQP6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 12:15:58 -0400
IronPort-SDR: cR9MBYkQKviTz6lU/42lh4t2wAgNmGprbHWPm/O/GLB6WeuPtVlYj71517E2hpz7pDEw7W0pNy
 oRz5U/HtGIMQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 09:15:57 -0700
IronPort-SDR: WvaQh0wH+vL4Fi9cuQ/IGwBlHPuNgSn4CnzIIwcxQdqMZ+414teuFTZiwi0/73ySYTao6gv2Xh
 w6wNGU9A1gvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,351,1580803200"; 
   d="scan'208";a="296698028"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Apr 2020 09:15:57 -0700
Date:   Mon, 6 Apr 2020 09:15:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH v3] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200406161557.GE21330@linux.intel.com>
References: <20200404010741.24486-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404010741.24486-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Apr 04, 2020 at 04:07:41AM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index e0124a2f22d5..5b15352b3d4f 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -196,6 +196,9 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
>  	struct sgx_encl_mm *encl_mm;
>  	int ret;
>  
> +	/* mm_list can be accessed only by a single thread at a time. */

s/accessed/mutated


> +	lockdep_assert_held_write(&mm->mmap_sem);
> +
>  	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD)
>  		return -EINVAL;
>  
> @@ -221,12 +224,16 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
>  		return ret;
>  	}
>  
> +	/*
> +	 * The page reclaimer uses list version for synchronization instead of
> +	 * synchronize_scru() because otherwise we could conflict with
> +	 * dup_mmap().
> +	 */
>  	spin_lock(&encl->mm_lock);
>  	list_add_rcu(&encl_mm->list, &encl->mm_list);
> +	encl->mm_list_version++;
>  	spin_unlock(&encl->mm_lock);
>  
> -	synchronize_srcu(&encl->srcu);
> -
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index 44b353aa8866..aa664363f229 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -74,6 +74,7 @@ struct sgx_encl {
>  	struct mutex lock;
>  	struct list_head mm_list;
>  	spinlock_t mm_lock;
> +	uint64_t mm_list_version;
>  	struct file *backing;
>  	struct kref refcount;
>  	struct srcu_struct srcu;
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 3af0596530a8..9b516f41b4d9 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -212,6 +212,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>  	encl->base = secs->base;
>  	encl->size = secs->size;
>  	encl->ssaframesize = secs->ssa_frame_size;
> +	encl->mm_list_version = 1;

This is unnecessary.  A mm_list_version of '0' means the list walk started
when there were no mm structs associated with the enclave, i.e. skipping
everything related to walking the list is ok.  It's subtle, and I dislike
relying on that behavior, but IMO it's preferable to incorrectly implying
that a list version of '0' is somehow bad.

>  	/*
>  	 * Set SGX_ENCL_CREATED only after the enclave is fully prepped.  This
> diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> index 39f0ddefbb79..3483e9bc590a 100644
> --- a/arch/x86/kernel/cpu/sgx/reclaim.c
> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -186,26 +186,43 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
>  	struct sgx_encl *encl = page->encl;
>  	struct sgx_encl_mm *encl_mm;
>  	struct vm_area_struct *vma;
> +	uint64_t version, next;
>  	int idx, ret;
>  
> -	idx = srcu_read_lock(&encl->srcu);
> +	version = 0;
>  
> -	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> -		if (!mmget_not_zero(encl_mm->mm))
> -			continue;
> +	for ( ; ; ) {
> +		next = encl->mm_list_version;
>  
> -		down_read(&encl_mm->mm->mmap_sem);
> +		if (version == next)
> +			break;

Functionally this works, but I personally find it the logic kludgy, and it
generates worse code.  Not that we're at the point where counting uops is a
to priority, but I don't think it makes sense to go out of our way to make
the resulting code worse.

The main issue is that the "0 is invalid" approach means the loop
termination condition is both likely and unlikely, e.g. the first test of
"version == next", when version is explicitly 0 is unlikely, but subsequent
checks are likely since racing with adding a mm is expected to be very rare.


Without "likely", it requires a taken Jcc to break the loop.

        next = encl->mm_list_version;
0xffffffff8102e423 <+51>:    mov    0x58(%r12),%r15

        if (version == next) // if (next == 0)
                break;
0xffffffff8102e43d <+77>:    test   %r15,%r15
0xffffffff8102e440 <+80>:    je     0xffffffff8102e51f <sgx_reclaimer_block+303>

        next = encl->mm_list_version;
0xffffffff8102e509 <+281>:   mov    0x58(%r12),%rax

        if (version == next), i.e. if (nested != 0)
                break;
0xffffffff8102e50e <+286>:   cmp    %r15,%rax
0xffffffff8102e511 <+289>:   je     0xffffffff8102e51f <sgx_reclaimer_block+303>
0xffffffff8102e513 <+291>:   mov    %rax,%r15
0xffffffff8102e516 <+294>:   jmpq   0xffffffff8102e446 <sgx_reclaimer_block+86>
0xffffffff8102e51b <+299>:   ud2


Using likely results in even worse code because the guts of the loop get
out out of line at the bottom of the function, and executing the first (and
most likely, only) iteration of the loop requires a taken Jcc.

        next = encl->mm_list_version;
0xffffffff8102e41e <+46>:    mov    0x58(%rbx),%r12

        if (likely(version == next))  // if (next == 0)
0xffffffff8102e422 <+50>:    test   %r12,%r12
0xffffffff8102e425 <+53>:    jne    0xffffffff8102e4cf <sgx_reclaimer_block+223

        ...

        next = encl->mm_list_version;
0xffffffff8102e5ad <+445>:   mov    0x58(%rbx),%rax

        if (likely(version == next))
0xffffffff8102e5b1 <+449>:   cmp    %r12,%rax
0xffffffff8102e5b4 <+452>:   je     0xffffffff8102e42b <sgx_reclaimer_block+59>
0xffffffff8102e5ba <+458>:   mov    %rax,%r12
0xffffffff8102e5bd <+461>:   jmpq   0xffffffff8102e4e6 <sgx_reclaimer_block+246>


Contrast that with the do-while form, which puts everything inline and does
not require a taken Jcc.  Note, the number of reads from encl->mm_list_version
are identical, i.e. the compiler isn't stupid.

        mm_list_version = encl->mm_list_version;
0xffffffff8102e441 <+49>:    mov    0x58(%r12),%rax
0xffffffff8102e452 <+66>:    mov    %rax,0x8(%rsp)

	...

        } while (unlikely(encl->mm_list_version != mm_list_version));
0xffffffff8102e527 <+279>:   mov    0x58(%r12),%rax
0xffffffff8102e52c <+284>:   cmp    0x8(%rsp),%rax
0xffffffff8102e531 <+289>:   jne    0xffffffff8102e5e5 <sgx_reclaimer_block+469>

>  
> -		ret = sgx_encl_find(encl_mm->mm, addr, &vma);
> -		if (!ret && encl == vma->vm_private_data)
> -			zap_vma_ptes(vma, addr, PAGE_SIZE);
> +		version = next;
>  
> -		up_read(&encl_mm->mm->mmap_sem);
> +		/* Fence reads as the CPU can reorder them. This guarantees
> +		 * that we don't access old list with a new version.
> +		 */
> +		smp_rmb();
>  
> -		mmput_async(encl_mm->mm);
> -	}
> +		idx = srcu_read_lock(&encl->srcu);
>  
> -	srcu_read_unlock(&encl->srcu, idx);
> +		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> +			if (!mmget_not_zero(encl_mm->mm))
> +				continue;
> +
> +			down_read(&encl_mm->mm->mmap_sem);
> +
> +			ret = sgx_encl_find(encl_mm->mm, addr, &vma);
> +			if (!ret && encl == vma->vm_private_data)
> +				zap_vma_ptes(vma, addr, PAGE_SIZE);
> +
> +			up_read(&encl_mm->mm->mmap_sem);
> +
> +			mmput_async(encl_mm->mm);
> +		}
> +
> +		srcu_read_unlock(&encl->srcu, idx);
> +	}
>  
>  	mutex_lock(&encl->lock);
>  
> -- 
> 2.25.1
> 
