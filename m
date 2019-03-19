Return-Path: <SRS0=vqpH=RW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374DAC43381
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Mar 2019 23:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02BE82175B
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Mar 2019 23:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfCSXAt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Mar 2019 19:00:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:35451 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbfCSXAt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 19 Mar 2019 19:00:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Mar 2019 16:00:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,246,1549958400"; 
   d="scan'208";a="135494751"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga003.jf.intel.com with ESMTP; 19 Mar 2019 16:00:47 -0700
Date:   Tue, 19 Mar 2019 16:00:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190319230047.GL25575@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Mar 17, 2019 at 11:14:45PM +0200, Jarkko Sakkinen wrote:
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the enclave is disallowed to access the memory
> inside the enclave by the CPU access control.
> 
> This commit adds the Linux SGX Enclave Driver that provides an ioctl API
> to manage enclaves. The address range for an enclave, commonly referred
> as ELRANGE in the documentation (e.g. Intel SDM), is reserved with
> mmap() against /dev/sgx. After that a set ioctls is used to build
> the enclave to the ELRANGE.


...

> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> new file mode 100644
> index 000000000000..bd8bcd748976
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/encl.c

...

> +/**
> + * sgx_encl_next_mm() - Iterate to the next mm
> + * @encl:	an enclave
> + * @mm:		an mm list entry
> + * @iter:	iterator status
> + *
> + * Return: the enclave mm or NULL
> + */
> +struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
> +				     struct sgx_encl_mm *mm, int *iter)
> +{
> +	struct list_head *entry;
> +
> +	WARN(!encl, "%s: encl is NULL", __func__);
> +	WARN(!iter, "%s: iter is NULL", __func__);
> +
> +	spin_lock(&encl->mm_lock);
> +
> +	entry = mm ? mm->list.next : encl->mm_list.next;
> +	WARN(!entry, "%s: entry is NULL", __func__);
> +
> +	if (entry == &encl->mm_list) {
> +		mm = NULL;
> +		*iter = SGX_ENCL_MM_ITER_DONE;
> +		goto out;
> +	}
> +
> +	mm = list_entry(entry, struct sgx_encl_mm, list);
> +
> +	if (!kref_get_unless_zero(&mm->refcount)) {
> +		*iter = SGX_ENCL_MM_ITER_RESTART;
> +		mm = NULL;
> +		goto out;
> +	}
> +
> +	if (!atomic_add_unless(&mm->mm->mm_count, 1, 0)) {

This is a use-after-free scenario if mm_count==0.  Once the count goes
to zero, __mmdrop() begins, at which point this code is racing against
free_mm().  What you want here (or rather, in flows where mm != current->mm
and you want to access PTEs) is mmget_not_zero(), i.e. "unless zero"
on mm_users.  mm_count prevents the mm_struct from being freed, but
doesn't protect the page tables.  mm_users protects the page tables,
i.e. lets us safely call sgx_encl_test_and_clear_young in the reclaimer.

To ensure liveliness of the mm itself, register an mmu_notifier for each
mm_struct (I think in sgx_vma_open()).  The enclave's .release callback
would then delete the mm from its list and drop its reference (exit_mmap()
holds a reference to mm_count so it's safe to do mmdrop() in the .release
callback).  E.g.:

static void sgx_vma_open(struct vm_area_struct *vma)
{
	...

	rcu_read_lock();
	list_for_each_entry_rcu(...) {
		if (vma->vm_mm == tmp->mm) {
			encl_mm = tmp;
			break;
		}
	}
	rcu_read_unlock();

	if (!encl_mm) {
		mm = kzalloc(sizeof(*mm), GFP_KERNEL);
		if (!mm) {
			goto error;

		encl_mm->encl = encl;
		encl_mm->mm = vma->vm_mm;

		if (mmu_notifier_register(&encl->mmu_notifier, encl_mm)) {
			kfree(encl_mm);
			goto error;
		}

		spin_lock(&encl->mm_lock);
		list_add(&encl_mm->list, &encl->mm_list);
		spin_unlock(&encl->mm_lock);
	}

	...
error:
	<not sure what should go here if we don't kill the enclave>
}

static void sgx_encl_mmu_release(struct mmu_notifier *mn, struct mm_struct *mm)
{
	struct sgx_encl_mm *encl_mm =
		container_of(mn, struct sgx_encl_mm, mmu_notifier);

	spin_lock(encl_mm->encl->mm_lock);
	list_del_rcu(&encl_mm->list);
	spin_unlock(encl_mm->encl->mm_lock);

	synchronize_rcu();

	mmdrop(mm);
}

Alternatively, the sgx_encl_mmu_release() could mark the encl_mm as dead
instead of removing it from the list, but I don't think that'd mesh well
with an RCU list, i.e. we'd need a regular lock-protected list and a
custom walker.

The only downside with the RCU approach that I can think of is that the
encl_mm would stay on the enclave's list until the enclave or the mm
itself died.  That could result in unnecessary IPIs during reclaim (or
invalidation), but that seems like a minor corner case that could be
avoided in userspace, e.g. don't mmap() an enclave unless you actually
plan on running it.

> +		kref_put(&mm->refcount, sgx_encl_release_mm);
> +		mm = NULL;
> +		*iter = SGX_ENCL_MM_ITER_RESTART;
> +		goto out;
> +	}
> +
> +	*iter = SGX_ENCL_MM_ITER_NEXT;
> +
> +out:
> +	spin_unlock(&encl->mm_lock);
> +	return mm;
> +}
> 
