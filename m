Return-Path: <SRS0=urvj=XN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9EDDC4CEC9
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Sep 2019 04:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A9A420862
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Sep 2019 04:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfIREKc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Sep 2019 00:10:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:23658 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfIREKc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Sep 2019 00:10:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 21:10:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,519,1559545200"; 
   d="scan'208";a="198916440"
Received: from mordehay-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.53])
  by orsmga002.jf.intel.com with ESMTP; 17 Sep 2019 21:10:29 -0700
Date:   Wed, 18 Sep 2019 07:10:28 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v3 16/17] x86/sgx: Introduce sgx_encl_get_backing()
Message-ID: <20190918040950.GC22434@linux.intel.com>
References: <20190916101803.30726-1-jarkko.sakkinen@linux.intel.com>
 <20190916101803.30726-17-jarkko.sakkinen@linux.intel.com>
 <20190917230518.GD10319@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917230518.GD10319@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 17, 2019 at 04:05:18PM -0700, Sean Christopherson wrote:
> On Mon, Sep 16, 2019 at 01:18:02PM +0300, Jarkko Sakkinen wrote:
> > Since __sgx_encl_eldu() and __sgx_encl_ewb() pin the backing storage in the
> > same way, consolidate this to sgx_encl_get_backing() replacing
> > sgx_encl_get_backing_page().
> > 
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
> > Cc: Serge Ayoun <serge.ayoun@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.c    | 86 +++++++++++++++++++------------
> >  arch/x86/kernel/cpu/sgx/encl.h    | 20 +++----
> >  arch/x86/kernel/cpu/sgx/reclaim.c | 39 ++++----------
> >  3 files changed, 71 insertions(+), 74 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index 66762b9c1517..a71414ce05b1 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -17,11 +17,8 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >  	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
> >  	struct sgx_encl *encl = encl_page->encl;
> >  	struct sgx_pageinfo pginfo;
> > -	unsigned long pcmd_offset;
> > -	struct page *backing;
> > +	struct sgx_backing b;
> >  	pgoff_t page_index;
> > -	pgoff_t pcmd_index;
> > -	struct page *pcmd;
> >  	int ret;
> >  
> >  	if (secs_page)
> > @@ -29,24 +26,14 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >  	else
> >  		page_index = PFN_DOWN(encl->size);
> >  
> > -	pcmd_index = sgx_pcmd_index(encl, page_index);
> > -	pcmd_offset = sgx_pcmd_offset(page_index);
> > -
> > -	backing = sgx_encl_get_backing_page(encl, page_index);
> > -	if (IS_ERR(backing)) {
> > -		ret = PTR_ERR(backing);
> > -		goto err_backing;
> > -	}
> > -
> > -	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
> > -	if (IS_ERR(pcmd)) {
> > -		ret = PTR_ERR(pcmd);
> > -		goto err_pcmd;
> > -	}
> > +	ret = sgx_encl_get_backing(encl, page_index, &b);
> > +	if (ret)
> > +		return ret;
> >  
> >  	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
> > -	pginfo.contents = (unsigned long)kmap_atomic(backing);
> > -	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
> > +	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
> > +	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) +
> > +			  b.pcmd_offset;
> >  
> >  	if (secs_page)
> >  		pginfo.secs = (u64)sgx_epc_addr(secs_page);
> > @@ -62,15 +49,12 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >  		ret = -EFAULT;
> >  	}
> >  
> > -	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
> > +	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - b.pcmd_offset));
> >  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
> >  
> > -	put_page(pcmd);
> > +	put_page(b.pcmd);
> > +	put_page(b.contents);
> 
> If we're going to have sgx_encl_get_backing(), it should be paired with
> sgx_encl_put_backing(), e.g. it's not immediately obvious whose doing the
> "get page" corresponding to the put_page() calls.

OK, I can add that.

/Jarkko
