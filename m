Return-Path: <SRS0=nYZY=5T=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAA3C43331
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 23:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2207206F8
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 23:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgDCXmk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Apr 2020 19:42:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:12779 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgDCXmk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Apr 2020 19:42:40 -0400
IronPort-SDR: h9BXXORRZSxzidewDZvhtG1fZF/KvP2zG2ypVIEJi/VhHwNpzaIFrxT7tQRDPu61957hZcSQjr
 GiFhCPWVndzg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 16:42:40 -0700
IronPort-SDR: 0ZpsFunNm2zSVx7PPqZYIEbwSfViqQJMlkjxSNurr4OQSFXlGYJOR3qqcht1YZxCtQPUwdXGNr
 xcyOSHgC+New==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,341,1580803200"; 
   d="scan'208";a="253527807"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 03 Apr 2020 16:42:39 -0700
Date:   Fri, 3 Apr 2020 16:42:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200403234239.GJ2701@linux.intel.com>
References: <20200403093550.104789-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403093550.104789-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 03, 2020 at 12:35:50PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
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

You dropped the smp_wmb().

> +	encl->mm_list_version++;
>  	spin_unlock(&encl->mm_lock);
>  
> -	synchronize_srcu(&encl->srcu);
> -
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index 44b353aa8866..f0f72e591244 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -74,6 +74,7 @@ struct sgx_encl {
>  	struct mutex lock;
>  	struct list_head mm_list;
>  	spinlock_t mm_lock;
> +	unsigned long mm_list_version;
>  	struct file *backing;
>  	struct kref refcount;
>  	struct srcu_struct srcu;
> diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> index 39f0ddefbb79..5fb8bdfa6a1f 100644
> --- a/arch/x86/kernel/cpu/sgx/reclaim.c
> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -184,28 +184,38 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
>  	struct sgx_encl_page *page = epc_page->owner;
>  	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
>  	struct sgx_encl *encl = page->encl;
> +	unsigned long mm_list_version;
>  	struct sgx_encl_mm *encl_mm;
>  	struct vm_area_struct *vma;
>  	int idx, ret;
>  
> -	idx = srcu_read_lock(&encl->srcu);
> +	do {
> +		mm_list_version = encl->mm_list_version;
>  
> -	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> -		if (!mmget_not_zero(encl_mm->mm))
> -			continue;
> +		/* Fence reads as the CPU can reorder them. This guarantees
> +		 * that we don't access old list with a new version.

This comment is flat out wrong.  This has nothing to do the CPU reordering
things.  The smp_{r,w}mb() are nothing more than compiler barriers, and
even those go away when the kernel is built with SMP=0.

I don't mind gutting the other comments, but there is a well established
pattern form smb_wmb()/smp_rmb() pairs, I would strongly prefer to keep
the exact comment I submitted.

> +		 */
> +		smp_rmb();


>  
> -		down_read(&encl_mm->mm->mmap_sem);
> +		idx = srcu_read_lock(&encl->srcu);
>  
> -		ret = sgx_encl_find(encl_mm->mm, addr, &vma);
> -		if (!ret && encl == vma->vm_private_data)
> -			zap_vma_ptes(vma, addr, PAGE_SIZE);
> +		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> +			if (!mmget_not_zero(encl_mm->mm))
> +				continue;
>  
> -		up_read(&encl_mm->mm->mmap_sem);
> +			down_read(&encl_mm->mm->mmap_sem);
>  
> -		mmput_async(encl_mm->mm);
> -	}
> +			ret = sgx_encl_find(encl_mm->mm, addr, &vma);
> +			if (!ret && encl == vma->vm_private_data)
> +				zap_vma_ptes(vma, addr, PAGE_SIZE);
>  
> -	srcu_read_unlock(&encl->srcu, idx);
> +			up_read(&encl_mm->mm->mmap_sem);
> +
> +			mmput_async(encl_mm->mm);
> +		}
> +
> +		srcu_read_unlock(&encl->srcu, idx);
> +	} while (unlikely(encl->mm_list_version != mm_list_version));
>  
>  	mutex_lock(&encl->lock);
>  
> @@ -250,6 +260,11 @@ static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
>  	struct sgx_encl_mm *encl_mm;
>  	int idx;
>  
> +	/*
> +	 * Can race with sgx_encl_mm_add(), but ETRACK has already been
> +	 * executed, which means that the CPUs running in the new mm will enter
> +	 * into the enclave with a fresh epoch.
> +	 */
>  	cpumask_clear(cpumask);
>  
>  	idx = srcu_read_lock(&encl->srcu);
> -- 
> 2.25.1
> 
