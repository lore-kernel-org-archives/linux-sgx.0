Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A777EC43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 15:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 780B420850
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 15:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfCUPAG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:00:06 -0400
Received: from mga12.intel.com ([192.55.52.136]:6629 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbfCUPAG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 11:00:06 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 08:00:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,253,1549958400"; 
   d="scan'208";a="329371993"
Received: from dilu-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.254.184])
  by fmsmga006.fm.intel.com with ESMTP; 21 Mar 2019 07:59:53 -0700
Date:   Thu, 21 Mar 2019 16:59:52 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v19 18/27] x86/sgx: Add swapping code to the core and SGX
 driver
Message-ID: <20190321145952.GP4603@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-19-jarkko.sakkinen@linux.intel.com>
 <20190319220916.GJ25575@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319220916.GJ25575@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> Yuck.  Definitely should look at using RCU list.  I think the whole
> function would boil down to:
> 
> 	list_for_each_entry_rcu(...) {
> 		down_read(&mm->mm->mmap_sem);
> 		ret = !sgx_encl_test_and_clear_young(next_mm->mm, page);
> 		up_read(&mm->mm->mmap_sem);
> 
> 		if (ret || (encl->flags & SGX_ENCL_DEAD))
> 			break;
> 	}
> 
> 	if (!ret || (encl->flags & SGX_ENCL_DEAD)) {
> 		mutex_lock(&encl->lock);
> 		page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> 		mutex_unlock(&encl->lock);
> 	}

But yuo cnot

> > +
> > +		down_read(&next_mm->mm->mmap_sem);
> > +		mutex_lock(&encl->lock);
> 
> Acquiring encl->lock just to check if its dead is a bit silly.
> 
> > +
> > +		if (encl->flags & SGX_ENCL_DEAD) {
> > +			page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> > +			ret = true;
> > +			goto out_stop;
> > +		}
> > +
> > +		ret = !sgx_encl_test_and_clear_young(next_mm->mm, page);
> > +		if (!ret)
> > +			goto out_stop;
> > +
> > +		mutex_unlock(&encl->lock);
> > +		up_read(&next_mm->mm->mmap_sem);
> > +	}
> > +
> > +	page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> 
> SGX_ENCL_PAGE_RECLAIMED needs to be while holding encl->lock.  Putting
> everything together, I think the function would boil down to:
> 
> 	list_for_each_entry_rcu(...) {
> 		if (encl->flags & SGX_ENCL_DEAD)
> 			break;
> 
> 		down_read(&mm->mm->mmap_sem);
> 		ret = !sgx_encl_test_and_clear_young(next_mm->mm, page);
> 		up_read(&mm->mm->mmap_sem);
> 
> 		if (!ret)
> 			return false;
> 	}
> 
> 	mutex_lock(&encl->lock);
> 	page->desc |= SGX_ENCL_PAGE_RECLAIMED;
> 	mutex_unlock(&encl->lock);
> 
> 	return true;
> 
> > +	return true;
> > +out_stop:
> > +	mutex_unlock(&encl->lock);
> > +	up_read(&next_mm->mm->mmap_sem);
> > +	mmdrop(next_mm->mm);
> > +	kref_put(&next_mm->refcount, sgx_encl_release_mm);
> > +	return ret;
> > +}
> > +
> > +static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
> > +{
> > +	struct sgx_encl_page *page = epc_page->owner;
> > +	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
> > +	struct sgx_encl *encl = page->encl;
> > +	struct sgx_encl_mm *next_mm = NULL;
> > +	struct sgx_encl_mm *prev_mm = NULL;
> > +	struct vm_area_struct *vma;
> > +	int iter;
> > +	int ret;
> > +
> > +	while (true) {
> > +		next_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
> > +		if (prev_mm) {
> > +			mmdrop(prev_mm->mm);
> > +			kref_put(&prev_mm->refcount, sgx_encl_release_mm);
> > +		}
> > +		prev_mm = next_mm;
> > +
> > +		if (iter == SGX_ENCL_MM_ITER_DONE)
> > +			break;
> > +
> > +		if (iter == SGX_ENCL_MM_ITER_RESTART)
> > +			continue;
> > +
> > +		down_read(&next_mm->mm->mmap_sem);
> > +		mutex_lock(&encl->lock);
> 
> There's no need to acquire encl->lock, only mmap_sem needs to be held
> to zap PTEs.
> 
> > +		ret = sgx_encl_find(next_mm->mm, addr, &vma);
> > +		if (!ret && encl == vma->vm_private_data)
> > +			zap_vma_ptes(vma, addr, PAGE_SIZE);
> > +
> > +		mutex_unlock(&encl->lock);
> > +		up_read(&next_mm->mm->mmap_sem);
> > +	}
> > +
> > +	mutex_lock(&encl->lock);
> > +
> > +	if (!(encl->flags & SGX_ENCL_DEAD)) {
> > +		ret = __eblock(sgx_epc_addr(epc_page));
> > +		if (encls_failed(ret))
> > +			ENCLS_WARN(ret, "EBLOCK");
> > +	}
> > +
> > +	mutex_unlock(&encl->lock);
> > +}
> > +
> > +static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
> > +			  struct sgx_va_page *va_page, unsigned int va_offset)
> > +{
> > +	struct sgx_encl_page *encl_page = epc_page->owner;
> > +	pgoff_t page_index = sgx_encl_get_index(encl, encl_page);
> > +	pgoff_t pcmd_index = sgx_pcmd_index(encl, page_index);
> > +	unsigned long pcmd_offset = sgx_pcmd_offset(page_index);
> > +	struct sgx_pageinfo pginfo;
> > +	struct page *backing;
> > +	struct page *pcmd;
> > +	int ret;
> > +
> > +	backing = sgx_encl_get_backing_page(encl, page_index);
> > +	if (IS_ERR(backing)) {
> > +		ret = PTR_ERR(backing);
> > +		goto err_backing;
> > +	}
> > +
> > +	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
> > +	if (IS_ERR(pcmd)) {
> > +		ret = PTR_ERR(pcmd);
> > +		goto err_pcmd;
> > +	}
> > +
> > +	pginfo.addr = 0;
> > +	pginfo.contents = (unsigned long)kmap_atomic(backing);
> > +	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
> > +	pginfo.secs = 0;
> > +	ret = __ewb(&pginfo, sgx_epc_addr(epc_page),
> > +		    sgx_epc_addr(va_page->epc_page) + va_offset);
> > +	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
> > +	kunmap_atomic((void *)(unsigned long)pginfo.contents);
> > +
> > +	set_page_dirty(pcmd);
> > +	put_page(pcmd);
> > +	set_page_dirty(backing);
> > +
> > +err_pcmd:
> > +	put_page(backing);
> > +
> > +err_backing:
> > +	return ret;
> > +}
> > +
> > +static void sgx_ipi_cb(void *info)
> > +{
> > +}
> > +
> > +static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool do_free)
> > +{
> > +	struct sgx_encl_page *encl_page = epc_page->owner;
> > +	struct sgx_encl *encl = encl_page->encl;
> > +	struct sgx_encl_mm *next_mm = NULL;
> > +	struct sgx_encl_mm *prev_mm = NULL;
> > +	struct sgx_va_page *va_page;
> > +	unsigned int va_offset;
> > +	int iter;
> > +	int ret;
> > +
> > +	cpumask_clear(&encl->cpumask);
> > +
> > +	while (true) {
> > +		next_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
> > +		if (prev_mm) {
> > +			mmdrop(prev_mm->mm);
> > +			kref_put(&prev_mm->refcount, sgx_encl_release_mm);
> > +		}
> > +		prev_mm = next_mm;
> > +
> > +		if (iter == SGX_ENCL_MM_ITER_DONE)
> > +			break;
> > +
> > +		if (iter == SGX_ENCL_MM_ITER_RESTART)
> > +			continue;
> > +
> > +		cpumask_or(&encl->cpumask, &encl->cpumask,
> > +			   mm_cpumask(next_mm->mm));
> > +	}
> 
> Sending IPIs to flush CPUs out of the enclave is only necessary if the
> enclave is alive, untracked and there are threads actively running in
> the enclave.  I.e. calculate cpumask only when necessary.
> 
> This open coding of IPI sending made me realize the driver no long
> invalidates an enclave if an ENCLS instruction fails unexpectedly.  That
> is going to lead to absolute carnage if something does go wrong as there
> will be no recovery path, i.e. the kernel log will be spammed to death
> with ENCLS WARNings.  Debugging future development will be a nightmare if
> a single ENCLS bug obliterates the kernel.

Responding below. I get your RCU idea but you cannot sleep inside normal
RCU. Also, the current implemntation deals with that mmap_sem cn be
gone. I'm open for using RCU (i.e. SRCU) if these can be somehow dealt
with.

/Jarkko
