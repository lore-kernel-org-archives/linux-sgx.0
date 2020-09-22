Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CE3C4363D
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 14:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 335B220936
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 14:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgIVODi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 10:03:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:38185 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgIVODh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Sep 2020 10:03:37 -0400
IronPort-SDR: gISH8xOQdQgHhDJZhCQEBJTQNtIlshRNdTaBOB0H9o/dLttka2op45rdjUqQHS00r7wu0yRTpT
 Gh4AxmJMC4/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="148355521"
X-IronPort-AV: E=Sophos;i="5.77,290,1596524400"; 
   d="scan'208";a="148355521"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 07:03:35 -0700
IronPort-SDR: //JSbquJ3crr4TnUhHSTmhoc61lX1lZnrVo/7i0jEjzvAlM9YcztaO3dOz1MyPS+XOyldSh/i7
 Jgkt4gJvsYXA==
X-IronPort-AV: E=Sophos;i="5.77,290,1596524400"; 
   d="scan'208";a="485970502"
Received: from haijindi-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.132])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 07:03:25 -0700
Date:   Tue, 22 Sep 2020 17:03:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 16/24] x86/sgx: Add a page reclaimer
Message-ID: <20200922140314.GA164527@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-17-jarkko.sakkinen@linux.intel.com>
 <20200922104538.GE22660@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922104538.GE22660@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 12:45:38PM +0200, Borislav Petkov wrote:
> > + * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version Array
> > + *					(VA) page for a swapped page.
> >   * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
> >   *
> >   * The page address for SECS is zero and is used by the subsystem to recognize
> 
> ...

So what's wrong over here?

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
> Also, should the growing happen *after* the SECS validation?

Yes, it would make sense. I'll move it.

> Let's add some comment blurb about "Write back/invalidate an EPC page"
> to at least start to explain what that "ewb" is.

OK, I'll try to write something understandable.

> > +	spin_lock(&sgx_active_page_list_lock);
> > +	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
> > +		if (list_empty(&sgx_active_page_list))
> 
> Isn't it enough to do this once, i.e., not in the loop? You're holding
> sgx_active_page_list_lock...

I think that would make sense. Distantly analogous to the EINIT
discussion. Too complex code for yet to be known problem workloads I'd
say.


> >  static void sgx_sanitize_section(struct sgx_epc_section *section)
> 
> ...

Is this about documenting this function?

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

Thanks, this was valuable feedback.

/Jarkko
