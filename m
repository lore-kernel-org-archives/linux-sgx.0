Return-Path: <SRS0=Lp6X=56=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F07C2BBFD
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Apr 2020 04:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79DD02072D
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Apr 2020 04:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405347AbgDNEcf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Apr 2020 00:32:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:34134 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728978AbgDNEce (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 Apr 2020 00:32:34 -0400
IronPort-SDR: Te+aZ8O5hha6pbAlR9B3rPNRc2UvhkNPmdzM2vC09vtcAsrSvpnvst2YiBtKQuy3A8qEs5zPcO
 c3Bqltae8wzQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 21:32:34 -0700
IronPort-SDR: owrB7uOg0f31uDYPy23XCCaenRs0e98ovf9boybvl3bW2i1RGyF0uxkhDpmpa44K0H4p2tl/GL
 mzdHtAxZXn4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="426930203"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 13 Apr 2020 21:32:34 -0700
Date:   Mon, 13 Apr 2020 21:32:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v4] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200414043234.GV21204@linux.intel.com>
References: <20200406205626.33264-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406205626.33264-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 06, 2020 at 11:56:26PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
  	spin_lock(&encl->mm_lock);
> +
>  	list_add_rcu(&encl_mm->list, &encl->mm_list);
> -	spin_unlock(&encl->mm_lock);
>  
> -	synchronize_srcu(&encl->srcu);
> +	/* Even if the CPU does not reorder writes, a compiler might. */

The preferred (by maintainers) style of comment for smp_wmb()/smp_rmb()
comments is to explicitly call out the associated reader/writer.  If you
want to go with a minimal comment, my vote is for something like:

	/*
	 * Add to list before updating version.  Pairs the with smp_rmb() in
	 * sgx_reclaimer_block().
	 */

And if you want to go really spartan, I'd take:

	/* Pairs with smp_rmb() in sgx_reclaimer_block(). */

over a generic comment about the compiler reordering instructions.

> +	smp_wmb();
> +	encl->mm_list_version++;
> +
> +	spin_unlock(&encl->mm_lock);
>  
>  	return 0;
>  }
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
> index 39f0ddefbb79..5e089f0db201 100644
> --- a/arch/x86/kernel/cpu/sgx/reclaim.c
> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -184,28 +184,39 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
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
> +		/*
> +		 * Fence the read. This guarantees that we don't mutate the old
> +		 * list with a new version.
> +		 */

As above, would prefer something like:

		/*
		 * Read the version before walking the list.  Pairs with the
		 * smp_wmb() in sgx_encl_mm_add().
		 */

or just

		/* Pairs with the smp_wmb() in sgx_encl_mm_add(). */
	

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
> @@ -250,6 +261,11 @@ static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
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
