Return-Path: <SRS0=HhcF=C2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3ADC43461
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Sep 2020 16:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EC242222B
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Sep 2020 16:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgIQQDU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Sep 2020 12:03:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:19081 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgIQQC2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 17 Sep 2020 12:02:28 -0400
IronPort-SDR: deeMkiJ+nr199VecKtJVBP3ExqULDxM4bHct0x4Ab/dZi4xiWU5PLMBulZAEkcbfasNEMzyheW
 GP1VdnLjfA0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="147422442"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="147422442"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 09:02:16 -0700
IronPort-SDR: mns0jnbCJ8ARFfpNBAkKQnj4kgYrozX6LyDUT1wKTgy+U79Gft8JmCE+l+WBEyebHZqoW6Frtb
 8J5nP4azBurg==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="483802353"
Received: from sdompke-mobl.ger.corp.intel.com (HELO localhost) ([10.249.45.123])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 09:02:08 -0700
Date:   Thu, 17 Sep 2020 19:02:06 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20200917160206.GF8530@linux.intel.com>
References: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
 <20200915110522.893152-14-jarkko.sakkinen@linux.intel.com>
 <op.0q2prldowjvjmi@mqcpg7oapc828.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0q2prldowjvjmi@mqcpg7oapc828.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 17, 2020 at 12:34:18AM -0500, Haitao Huang wrote:
> On Tue, 15 Sep 2020 06:05:11 -0500, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> ...
> 
> > +static int __sgx_encl_add_page(struct sgx_encl *encl,
> > +			       struct sgx_encl_page *encl_page,
> > +			       struct sgx_epc_page *epc_page,
> > +			       struct sgx_secinfo *secinfo, unsigned long src)
> > +{
> > +	struct sgx_pageinfo pginfo;
> > +	struct vm_area_struct *vma;
> > +	struct page *src_page;
> > +	int ret;
> > +
> > +	/* Query vma's VM_MAYEXEC as an indirect path_noexec() check. */
> > +	if (encl_page->vm_max_prot_bits & VM_EXEC) {
> > +		vma = find_vma(current->mm, src);
> > +		if (!vma)
> > +			return -EFAULT;
> > +
> > +		if (!(vma->vm_flags & VM_MAYEXEC))
> > +			return -EACCES;
> > +	}
> > +
> > +	ret = get_user_pages(src, 1, 0, &src_page, NULL);
> > +	if (ret < 1)
> > +		return ret;
> > +
> > +	pginfo.secs = (unsigned long)sgx_get_epc_addr(encl->secs.epc_page);
> > +	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
> > +	pginfo.metadata = (unsigned long)secinfo;
> > +	pginfo.contents = (unsigned long)kmap_atomic(src_page);
> > +
> > +	ret = __eadd(&pginfo, sgx_get_epc_addr(epc_page));
> > +
> > +	kunmap_atomic((void *)pginfo.contents);
> > +	put_page(src_page);
> > +
> > +	return ret ? -EIO : 0;
> > +}
> > +
> > +/*
> > + * If the caller requires measurement of the page as a proof for the
> > content,
> > + * use EEXTEND to add a measurement for 256 bytes of the page. Repeat
> > this
> > + * operation until the entire page is measured."
> > + */
> > +static int __sgx_encl_extend(struct sgx_encl *encl,
> > +			     struct sgx_epc_page *epc_page)
> > +{
> > +	int ret;
> > +	int i;
> > +
> > +	for (i = 0; i < 16; i++) {
> > +		ret = __eextend(sgx_get_epc_addr(encl->secs.epc_page),
> > +				sgx_get_epc_addr(epc_page) + (i * 0x100));
> > +		if (ret) {
> > +			if (encls_failed(ret))
> > +				ENCLS_WARN(ret, "EEXTEND");
> > +			return -EIO;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> > +			     unsigned long offset, struct sgx_secinfo *secinfo,
> > +			     unsigned long flags)
> > +{
> > +	struct sgx_encl_page *encl_page;
> > +	struct sgx_epc_page *epc_page;
> > +	int ret;
> > +
> > +	encl_page = sgx_encl_page_alloc(encl, offset, secinfo->flags);
> > +	if (IS_ERR(encl_page))
> > +		return PTR_ERR(encl_page);
> > +
> > +	epc_page = __sgx_alloc_epc_page();
> > +	if (IS_ERR(epc_page)) {
> > +		kfree(encl_page);
> > +		return PTR_ERR(epc_page);
> > +	}
> > +
> > +	mmap_read_lock(current->mm);
> > +	mutex_lock(&encl->lock);
> > +
> > +	/*
> > +	 * Insert prior to EADD in case of OOM.  EADD modifies MRENCLAVE, i.e.
> > +	 * can't be gracefully unwound, while failure on EADD/EXTEND is limited
> > +	 * to userspace errors (or kernel/hardware bugs).
> > +	 */
> > +	ret = xa_insert(&encl->page_array, PFN_DOWN(encl_page->desc),
> > +			encl_page, GFP_KERNEL);
> > +	if (ret)
> > +		goto err_out_unlock;
> > +
> > +	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
> > +				  src);
> > +	if (ret)
> > +		goto err_out;
> > +
> > +	/*
> > +	 * Complete the "add" before doing the "extend" so that the "add"
> > +	 * isn't in a half-baked state in the extremely unlikely scenario
> > +	 * the enclave will be destroyed in response to EEXTEND failure.
> > +	 */
> > +	encl_page->encl = encl;
> > +	encl_page->epc_page = epc_page;
> > +	encl->secs_child_cnt++;
> > +
> > +	if (flags & SGX_PAGE_MEASURE) {
> > +		ret = __sgx_encl_extend(encl, epc_page);
> > +		if (ret)
> > +			goto err_out;
> > +	}
> > +
> > +	mutex_unlock(&encl->lock);
> > +	mmap_read_unlock(current->mm);
> > +	return ret;
> > +
> > +err_out:
> > +	xa_erase(&encl->page_array, PFN_DOWN(encl_page->desc));
> > +
> > +err_out_unlock:
> > +	mutex_unlock(&encl->lock);
> > +	mmap_read_unlock(current->mm);
> > +
> > +	sgx_free_epc_page(epc_page);
> > +	kfree(encl_page);
> > +
> > +	/*
> > +	 * Destroy enclave on ENCLS failure as this means that EPC has been
> > +	 * invalidated.
> > +	 */
> > +	if (ret == -EIO) {
> > +		mutex_lock(&encl->lock);
> > +		sgx_encl_destroy(encl);
> > +		mutex_unlock(&encl->lock);
> > +	}
> > +
> 
> I think originally we return both count of succeeded EADDs and the errors.
> So we only destroy enclaves in cases of fatal ENCLS failures.
> 
> Now we only return errors in all failures other than interrupted operations
> or SGX_MAX_ADD_PAGES_LENGTH is reached.
> 
> So, for the new design we should destroy enclaves in all cases here, not
> just for -EIO.
> 
> On the other hand, I do like the old way returning both the count and error
> better. It helps greatly for debugging any issues in enclave image or user
> space code, and also keeps flexibility for user space to recover in certain
> errors, such as out of EPC.

Right, I do get the OOM case but wouldn't in that case the reasonable
thing to do destroy the enclave that is not even running? I mean that
means that we are globally out of EPC.

/Jarkko
