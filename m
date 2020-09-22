Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AD3C4363D
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 16:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92DAD239D2
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 16:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgIVQYn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:24:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:37808 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgIVQYn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Sep 2020 12:24:43 -0400
IronPort-SDR: 7hTIauPfYvYv5uYEyD8OPqvEnLlWxm+mz4R/bfQe8tFBYFw0Fpyeb79PTS9Isw53jubTfugVFd
 lj7X7STKK+bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="158024839"
X-IronPort-AV: E=Sophos;i="5.77,291,1596524400"; 
   d="scan'208";a="158024839"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 09:24:40 -0700
IronPort-SDR: wuqh49QQJio1BVTpfU/c7hE0z70Jgl7uxuSoosblsld/K3Pa7LM/WNKsClx4w1yR5Mktgys9zW
 BQH7r5068EnA==
X-IronPort-AV: E=Sophos;i="5.77,291,1596524400"; 
   d="scan'208";a="335081762"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 09:24:39 -0700
Date:   Tue, 22 Sep 2020 09:24:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 16/24] x86/sgx: Add a page reclaimer
Message-ID: <20200922162437.GA30827@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-17-jarkko.sakkinen@linux.intel.com>
 <20200922104538.GE22660@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922104538.GE22660@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 12:45:38PM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 02:28:34PM +0300, Jarkko Sakkinen wrote:
> > + * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version Array
> > + *					(VA) page for a swapped page.
> >   * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
> >   *
> >   * The page address for SECS is zero and is used by the subsystem to recognize
> 
> ...
> 
> > @@ -86,24 +123,34 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> >  {
> >  	unsigned long encl_size = secs->size + PAGE_SIZE;
> >  	struct sgx_epc_page *secs_epc;
> > +	struct sgx_va_page *va_page;
> >  	struct sgx_pageinfo pginfo;
> >  	struct sgx_secinfo secinfo;
> >  	struct file *backing;
> >  	long ret;
> >  
> > +	va_page = sgx_encl_grow(encl);
> > +	if (IS_ERR(va_page))
> > +		return PTR_ERR(va_page);
> > +	else if (va_page)
> 
> Not "else" simply?
> 
> AFAICT, sgx_encl_grow() would either return an ERR_PTR or the actual
> page...
> 

The "else if" is correct.  Version Array (VA) pages have 512 slots that hold
metadata for evicted EPC pages, i.e. swapping a page out of the EPC requires
a VA slot.  For simplicity (LOL), the approach we are taking for initial
support is to reserve a VA slot when adding a page to the enclave[*].  In most
cases, reserving a slot does not require allocating a new VA page, e.g. to
reserve slots 1-511 of the "current" VA page.   The if-elif is handling the
case where the current VA page is fully reserved and a new one needs to be
allocated. The if handles the error, the elif handles success, i.e.

	if (IS_ERR(va_page)) <- needed a new VA page, allocation failed
		return PTR_ERR(va_page);
	else if (va_page)    <- needed a new VA page, allocation succeeded
		list_add(&va_page->list, &encl->va_pages);
	else
		             <- reused the current VA page

When reusing a VA page, we obviously don't want to readd the page to the list
of va_pages, and the error handling path also shouldn't free the VA page.

> Also, should the growing happen *after* the SECS validation?
> 
> > +		list_add(&va_page->list, &encl->va_pages);
> > +
> >  	if (sgx_validate_secs(secs)) {
> >  		pr_debug("invalid SECS\n");
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		goto err_out_shrink;
> >  	}
