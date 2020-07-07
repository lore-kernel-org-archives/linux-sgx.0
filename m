Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96A2C433E0
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E26120684
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgGGEMG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jul 2020 00:12:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:22633 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgGGEMG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 7 Jul 2020 00:12:06 -0400
IronPort-SDR: 0W/5Vy1dfoxvbNGDIHUC8W6lLn2fgTx3XoVW6MAVLnQ6FsJE/doVeitgQfIzhHimfdtYHpXLvu
 aLk53coCoOFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="135001683"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="135001683"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 21:12:05 -0700
IronPort-SDR: YHarQfFVnkfUOum/EoAPHkcF95ItQQCHMuQQp34Q+s/pMrOJeo8DrUZ9F4+e8CxeNfxTKxYD6k
 MMs02+aqpxGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="268078883"
Received: from apiccion-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.45.178])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jul 2020 21:11:52 -0700
Date:   Tue, 7 Jul 2020 07:11:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v34 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20200707041151.GE143804@linux.intel.com>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-12-jarkko.sakkinen@linux.intel.com>
 <20200707033617.GF25523@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707033617.GF25523@casper.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 07, 2020 at 04:36:17AM +0100, Matthew Wilcox wrote:
> On Tue, Jul 07, 2020 at 06:01:51AM +0300, Jarkko Sakkinen wrote:
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the SGX hosted software entity is disallowed to
> 
> s/disallowed to/prevented from/
> 
> > access the memory inside the enclave enforced by the CPU. We call these
> 
> s/enforced//
> 
> > entities enclaves.
> > 
> > Add a driver that provides an ioctl API to construct and run enclaves.
> > Enclaves are constructed from pages residing in reserved physical memory
> > areas. The contents of these pages can only be accessed when they are
> > mapped as part of an enclave, by a hardware thread running inside the
> > enclave.
> > 
> > The starting state of an enclave consists of a fixed measured set of
> > pages that are copied to the EPC during the construction process by
> > using ENCLS leaf functions and Software Enclave Control Structure (SECS)
> > that defines the enclave properties.
> > 
> > Enclaves are constructed by using ENCLS leaf functions ECREATE, EADD and
> > EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
> > the EPC and EINIT checks a given signed measurement and moves the enclave
> > into a state ready for execution.
> 
> What's a leaf function?  Is it like a CPU instruction?

Yeah, the opcode is ENCLS for ring-0 (enclave management and
construction) and ENCLU for ring-3 (entrance to the enclave etc).
The leaf function number goes to EAX.

> 
> > The mmap() permissions are capped by the contained enclave page
> > permissions. The mapped areas must also be opaque, i.e. each page address
> > must contain a page. This logic is implemented in sgx_encl_may_map().
> 
> do you mean "populated" instead of "opaque"?

Yes, that would be a better word to use. I'll change this.

> 
> > +	atomic_set(&encl->flags, 0);
> > +	kref_init(&encl->refcount);
> > +	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
> 
> Why are you using a radix tree instead of an xarray?

Because xarray did not exist in 2017 and nobody has pointed out to use
it. Now I know it exists (yet do not know what it is).

> 
> > +int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> > +		     unsigned long end, unsigned long vm_prot_bits)
> > +{
> > +	unsigned long idx, idx_start, idx_end;
> > +	struct sgx_encl_page *page;
> > +
> > +	/*
> > +	 * Disallow RIE tasks as their VMA permissions might conflict with the
> > +	 * enclave page permissions.
> > +	 */
> > +	if (!!(current->personality & READ_IMPLIES_EXEC))
> > +		return -EACCES;
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
> 
> You should really use an iterator here instead of repeated lookups.
> xas_for_each() will probably be what you want.

Thank you for your remarks. I'll look into using xarray for this.

/Jarkko
