Return-Path: <SRS0=Uuw6=4I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61577C11D0C
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 18:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3861024672
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 18:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgBTSNr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Feb 2020 13:13:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:51193 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbgBTSNq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Feb 2020 13:13:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 10:13:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="259357572"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Feb 2020 10:13:45 -0800
Date:   Thu, 20 Feb 2020 10:13:45 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jordan Hand <jorhand@linux.microsoft.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200220181345.GD3972@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
 <15074c16-4832-456d-dd12-af8548e46d6d@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15074c16-4832-456d-dd12-af8548e46d6d@linux.microsoft.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 18, 2020 at 07:26:31PM -0800, Jordan Hand wrote:
> I ran our validation tests for the Open Enclave SDK against this patch
> set and came across a potential issue.
> 
> On 2/9/20 1:25 PM, Jarkko Sakkinen wrote:
> > +/**
> > + * sgx_encl_may_map() - Check if a requested VMA mapping is allowed
> > + * @encl:		an enclave
> > + * @start:		lower bound of the address range, inclusive
> > + * @end:		upper bound of the address range, exclusive
> > + * @vm_prot_bits:	requested protections of the address range
> > + *
> > + * Iterate through the enclave pages contained within [@start, @end) to verify
> > + * the permissions requested by @vm_prot_bits do not exceed that of any enclave
> > + * page to be mapped.  Page addresses that do not have an associated enclave
> > + * page are interpreted to zero permissions.
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   -EACCES if VMA permissions exceed enclave page permissions
> > + */
> > +int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> > +		     unsigned long end, unsigned long vm_prot_bits)
> > +{
> > +	unsigned long idx, idx_start, idx_end;
> > +	struct sgx_encl_page *page;
> > +
> > +	/* PROT_NONE always succeeds. */
> > +	if (!vm_prot_bits)
> > +		return 0;
> > +
> > +	idx_start = PFN_DOWN(start);
> > +	idx_end = PFN_DOWN(end - 1);
> > +
> > +	for (idx = idx_start; idx <= idx_end; ++idx) {
> > +		mutex_lock(&encl->lock);
> > +		page = radix_tree_lookup(&encl->page_tree, idx);
> > +		mutex_unlock(&encl->lock);
> > +
> > +		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> > +			return -EACCES;
> > +	}
> > +
> > +	return 0;
> > +}
> > +static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
> > +						 unsigned long offset,
> > +						 u64 secinfo_flags)
> > +{
> > +	struct sgx_encl_page *encl_page;
> > +	unsigned long prot;
> > +
> > +	encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
> > +	if (!encl_page)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	encl_page->desc = encl->base + offset;
> > +	encl_page->encl = encl;
> > +
> > +	prot = _calc_vm_trans(secinfo_flags, SGX_SECINFO_R, PROT_READ)  |
> > +	       _calc_vm_trans(secinfo_flags, SGX_SECINFO_W, PROT_WRITE) |
> > +	       _calc_vm_trans(secinfo_flags, SGX_SECINFO_X, PROT_EXEC);
> > +
> > +	/*
> > +	 * TCS pages must always RW set for CPU access while the SECINFO
> > +	 * permissions are *always* zero - the CPU ignores the user provided
> > +	 * values and silently overwrites them with zero permissions.
> > +	 */
> > +	if ((secinfo_flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
> > +		prot |= PROT_READ | PROT_WRITE;
> > +
> > +	/* Calculate maximum of the VM flags for the page. */
> > +	encl_page->vm_max_prot_bits = calc_vm_prot_bits(prot, 0);
> 
> During mprotect (in mm/mprotect.c line 525) the following checks if
> READ_IMPLIES_EXECUTE and a PROT_READ is being requested. If so and
> VM_MAYEXEC is set, it also adds PROT_EXEC to the request.
> 
> 	if (rier && (vma->vm_flags & VM_MAYEXEC))
> 		prot |= PROT_EXEC;
> 
> But if we look at sgx_encl_page_alloc(), we see vm_max_prot_bits is set
> without taking VM_MAYEXEC into account:
> 
> 	encl_page->vm_max_prot_bits = calc_vm_prot_bits(prot, 0);
> 
> sgx_encl_may_map() checks that the requested protection can be added with:
> 
> 	if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> 		return -EACCESS
> 
> This means that for any process where READ_IMPLIES_EXECUTE is set and
> page where (vma->vm_flags & VM_MAYEXEC) == true, mmap/mprotect calls to
> that request PROT_READ on a page that was not added with PROT_EXEC will
> fail.

I could've sworn this was discussed on the SGX list at one point, but
apparently we only discussed it internally.  Anyways...

More than likely, the READ_IMPLIES_EXECUTE (RIE) crud rears its head
because part of the enclave loader is written in assembly.  Unless
explicitly told otherwise, the linker assumes that any program with
assembly code may need an executable stack, which leads to the RIE
personality being set for the process.  Here's a fantastic write up for
more details: https://www.airs.com/blog/archives/518

There are essentially two paths we can take:

 1) Exempt EPC pages from RIE during mmap()/mprotect(), i.e. don't add
    PROT_EXEC for enclaves.

 2) Punt the issue to userspace.

Option (1) is desirable in some ways:

  - Enclaves will get an executable stack if and only if the loader/creator
    intentionally configures it to have an executable stack.

  - Separates enclaves from the personality of the loader.

  - Userspace doesn't have to do anything for the common case of not
    wanting an executable stack for its enclaves.

The big down side to (1) is that it'd require an ugly hook in architecture
agnostic code.  And arguably, it reduces the overall security of the
platform (more below).

For (2), userspace has a few options:

 a) Tell the linker the enclave loader doesn't need RIE, either via a .note
    in assembly files or via the global "-z noexecstack" flag.

 b) Spawn a separate process to run/map the enclave if the enclave loader
    needs RIE.

 c) Require enclaves to allow PROT_EXEC on all pages.  Note, this is an
    absolutely terrible idea and only included for completeness.

As shown by the lack of a mmap()/mprotect() hook in this series to squash
RIE, we chose option (2).  Given that enclave loaders are not legacy code
and hopefully following decent coding practices, option (2a) should suffice
for all loaders.  The security benefit mentioned above is that forcing
enclave loaders to squash RIE eliminates an exectuable stack as an attack
vector on the loader.

If for some reason a loader "needs" an executable stack, requiring such a
beast to jump through a few hoops to run sane enclaves doesn't seem too
onerous.

This obviously needs to be called out in the kernel docs.
