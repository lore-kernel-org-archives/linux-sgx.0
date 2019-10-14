Return-Path: <SRS0=YPfn=YH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254BCC4CECE
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 21:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 062D321882
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 21:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731784AbfJNVAd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Oct 2019 17:00:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:52408 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfJNVAd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Oct 2019 17:00:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 14:00:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="395317448"
Received: from kridax-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.7.178])
  by fmsmga005.fm.intel.com with ESMTP; 14 Oct 2019 14:00:31 -0700
Date:   Tue, 15 Oct 2019 00:00:27 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 3/9] x86/sgx: Fix a memory leak in
 sgx_encl_destroy()
Message-ID: <20191014210005.GT15552@linux.intel.com>
References: <20191010214301.25669-1-sean.j.christopherson@intel.com>
 <20191010214301.25669-4-sean.j.christopherson@intel.com>
 <20191010224947.GH23798@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010224947.GH23798@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 10, 2019 at 03:49:48PM -0700, Sean Christopherson wrote:
> On Thu, Oct 10, 2019 at 02:42:55PM -0700, Sean Christopherson wrote:
> > Delete an enclave page's entry in the radix tree regardless of whether
> > or not it has an associated EPC page.
> > 
> > Note, the reclaimer doesn't need the tree to reclaim EPC pages, i.e.
> > it's safe to delete the tree entry even if sgx_free_page() fails.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.c | 15 +++++++--------
> >  1 file changed, 7 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index ea21d3737a32..68ec8944692a 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -468,15 +468,14 @@ void sgx_encl_destroy(struct sgx_encl *encl)
> >  
> >  	radix_tree_for_each_slot(slot, &encl->page_tree, &iter, 0) {
> >  		entry = *slot;
> > -		if (entry->epc_page) {
> > -			if (!sgx_free_page(entry->epc_page)) {
> > -				encl->secs_child_cnt--;
> > -				entry->epc_page = NULL;
> > -			}
> > -
> > -			radix_tree_delete(&entry->encl->page_tree,
> > -					  PFN_DOWN(entry->desc));
> > +		if (entry->epc_page &&
> > +		    !sgx_free_page(entry->epc_page)) {
> > +			encl->secs_child_cnt--;
> > +			entry->epc_page = NULL;
> >  		}
> > +
> > +		radix_tree_delete(&entry->encl->page_tree,
> > +				  PFN_DOWN(entry->desc));
> 
> Uh, just realized we're not freeing the entry itself.  That's obviously
> not good.  I'll spin a v2 to fix this proper.

OK.

So I applied 1/9 and 2/9 from this one. I guess they were good
(just a sanity check)?

/Jarkko
