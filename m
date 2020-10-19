Return-Path: <SRS0=Kf/c=D2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4122DC433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 21:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E653522246
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 21:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732736AbgJSVPd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Oct 2020 17:15:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:60821 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732734AbgJSVPd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Oct 2020 17:15:33 -0400
IronPort-SDR: sTYEyd0zpjy+4EPBUZ4MvgrWPXJs9QbOwTjFZZwFo7tM3e1wpTY6UoUvdid159v1UHJa3s/M03
 nJgcXodRt/cA==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="231299130"
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="231299130"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 14:15:30 -0700
IronPort-SDR: fpbTZzZ+xbJmRxd3HoRK+zOUkRUusKX5alXGiFtUDaYbzclHa/ICEyXK1jNaVYJcND7ryFKKWQ
 ofuqWnMyRUtw==
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="347587143"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 14:15:28 -0700
Date:   Mon, 19 Oct 2020 14:15:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20201019211525.GC23072@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-14-jarkko.sakkinen@linux.intel.com>
 <1739984e-0010-2031-1561-809a0b6380bb@intel.com>
 <20201018050311.GK68722@linux.intel.com>
 <516a1b7a-38cc-adde-833b-b661cbee97f2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516a1b7a-38cc-adde-833b-b661cbee97f2@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 19, 2020 at 01:48:32PM -0700, Dave Hansen wrote:
> On 10/17/20 10:03 PM, Jarkko Sakkinen wrote:
> >>> +		if (ret) {
> >>> +			if (encls_failed(ret))
> >>> +				ENCLS_WARN(ret, "EEXTEND");
> >>> +			return -EIO;
> >>
> >> How frequent should we expect these to be?  Can users cause them?  You
> >> should *proably* call it ENCLS_WARN_ONCE() if it's implemented that way.

Ya, it's implemented using WARN_ONCE.  It doesn't append _ONCE mostly to avoid
unnecessary verbosity, e.g. there's no existing SGX code that uses vanilla
WARN, nor does it seem likely that there will ever be a case where using WARN
is justified.

> > If power cycle happens.
> 
> So, we get one warning per power cycle?  Practically, do you mean a
> suspend/resume cycle, or is this more like hibernation-to-disk-resume?
> 
> In any case, if this is normal system operation (which closing my laptop
> lid qualifies as), it should produce zero warnings.

encls_failed() filters out EPCM faults (which, by the by, is why the kernel
cares about that #GP vs. #PF erratum).  So what you describe is the implemented
behavior, i.e. WARNs are triggerable if and only if there is a hardware or
kernel bug.

FWIW, I prefer burying the encls_failed() logic in ENCLS_WARN.  encls_failed()
is only used to gate ENCLS_WARN, and ENCLS_WARN is always wrapped with
encls_failed() excepted for EREMOVE.  The only downside to applying the logic
to EREMOVE is that it could theoretically suppress kernel bugs on CPUs that are
subject to the #GP instead of #PF errata.
 
> >>> +static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> >>> +			     unsigned long offset, struct sgx_secinfo *secinfo,
> >>> +			     unsigned long flags)
> >>> +{
> >>> +	struct sgx_encl_page *encl_page;
> >>> +	struct sgx_epc_page *epc_page;
> >>> +	int ret;
> >>> +
> >>> +	encl_page = sgx_encl_page_alloc(encl, offset, secinfo->flags);
> >>> +	if (IS_ERR(encl_page))
> >>> +		return PTR_ERR(encl_page);
> >>> +
> >>> +	epc_page = __sgx_alloc_epc_page();
> >>> +	if (IS_ERR(epc_page)) {
> >>> +		kfree(encl_page);
> >>> +		return PTR_ERR(epc_page);
> >>> +	}
> >>
> >> Looking at these, I'm forgetting why we need to both allocate an
> >> encl_page and an epc_page.  Commends might remind me.  So would better
> >> names.
> > 
> > Should the struct names be renamed?
> > 
> > Like sgx_phys_epc_page and sgx_virt_epc_page?
> 
> "epc" is additional acronym nonsense and redundant with "sgx" and "page"
> anyway.
> 
> I'd probably call then 'sgx_phys_page' and 'sgx_virt_slot' or something.

I don't too much deeply about whether or not sgx_encl_page is renamed, but I
would very strongly prefer keeping sgx_epc_page.  Nearly all of the SGX
literature refers to the physical pages residing in the EPC as "EPC pages".
IMO, the "sgx" is the somewhat superfluous part that is tacked on to add
namespacing in case of collisions with "epc".

> >>> +	mmap_read_lock(current->mm);
> >>> +	mutex_lock(&encl->lock);
> >>> +
> >>> +	/*
> >>> +	 * Insert prior to EADD in case of OOM.
> >>> +	if (copy_from_user(&addp, arg, sizeof(addp)))
> >>> +		return -EFAULT;
> >>> +
> >>> +	if (!IS_ALIGNED(addp.offset, PAGE_SIZE) ||
> >>> +	    !IS_ALIGNED(addp.src, PAGE_SIZE))
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (!(access_ok(addp.src, PAGE_SIZE)))
> >>> +		return -EFAULT;
> >>
> >> This worries me.  You're doing an access_ok() check on addp.src because
> >> you evidently don't trust it.  But, below, it looks to be accessed
> >> directly with an offset, bound by addp.length, which I think can be
> >>> PAGE_SIZE.
> >>
> >> I'd feel a lot better if addp.src's value was being passed around as a
> >> __user pointer.
> > 
> > I'm not sure if that call is even needed. Each page is pinned with
> > get_user_pages(). AFAIK, it should be enough. This must be legacy cruft.
> 
> get_user_pages() and access_ok() do *very* different things.  Even if
> the pages are pinned, you might still be tricked into referencing off
> the end of the page, or up into the kernel address space.
> 
> >>> +	if (addp.length & (PAGE_SIZE - 1))
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (addp.offset + addp.length - PAGE_SIZE >= encl->size)
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
> >>> +			   sizeof(secinfo)))
> >>> +		return -EFAULT;
> >>> +
> >>> +	if (sgx_validate_secinfo(&secinfo))
> >>> +		return -EINVAL;
> >>> +
> >>> +	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
> >>> +		if (signal_pending(current)) {
> >>> +			if (!c)
> >>> +				ret = -ERESTARTSYS;
> >>> +
> >>> +			break;
> >>> +		}
> >>> +
> >>> +		if (c == SGX_MAX_ADD_PAGES_LENGTH)
> >>> +			break;
> >>> +
> >>> +		if (need_resched())
> >>> +			cond_resched();
> >>> +
> >>> +		ret = sgx_encl_add_page(encl, addp.src + c, addp.offset + c,
> >>> +					&secinfo, addp.flags);
> >>
> >> Yeah...  Don't we need to do another access_ok() check here, if we
> >> needed one above since we are moving away from addrp.src?
> > 
> > I don't think so because the page is pinned with get_user_pages().
> 
> No, get_user_pages() is orthogonal.
> 
> Looking at this again, you _might_ be OK since you validated addp.length
> against encl->size.  But, it's all very convoluted and doesn't look very
> organized or obviously right.

The easiest fix would be to have the existing access_ok() check the entire
range, no?  Or am I missing something obvious?
