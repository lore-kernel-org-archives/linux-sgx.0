Return-Path: <SRS0=YLWQ=2B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684DBC43603
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Dec 2019 11:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43B59208C3
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Dec 2019 11:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfLKLLz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 Dec 2019 06:11:55 -0500
Received: from mga05.intel.com ([192.55.52.43]:56565 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbfLKLLy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 11 Dec 2019 06:11:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 03:11:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="207644116"
Received: from unknown (HELO localhost) ([10.237.50.137])
  by orsmga008.jf.intel.com with ESMTP; 11 Dec 2019 03:11:52 -0800
Date:   Wed, 11 Dec 2019 13:11:52 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Huang Haitao <haitao.huang@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix double-free when EADD fails
Message-ID: <20191211111152.GB16450@linux.intel.com>
References: <20191205100151.18950-1-jarkko.sakkinen@linux.intel.com>
 <20191209205254.GE4042@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209205254.GE4042@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 09, 2019 at 12:52:55PM -0800, Sean Christopherson wrote:
> On Thu, Dec 05, 2019 at 12:01:51PM +0200, Jarkko Sakkinen wrote:
> > radix_tree_delete() gets called twice for the same page  when EADD
> > fails. This commit fixes the issue.
> > 
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Reported-by: Huang Haitao <haitao.huang@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/ioctl.c | 23 ++++++++++-------------
> >  1 file changed, 10 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> > index ab9e48cd294b..2ff12038a8a4 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -413,13 +413,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> >  
> >  	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
> >  				  src);
> > -	if (ret) {
> > -		/* ENCLS failure. */
> > -		if (ret == -EIO)
> > -			sgx_encl_destroy(encl);
> > -
> > +	if (ret)
> >  		goto err_out;
> > -	}
> >  
> >  	/*
> >  	 * Complete the "add" before doing the "extend" so that the "add"
> > @@ -432,17 +427,12 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> >  
> >  	if (flags & SGX_PAGE_MEASURE) {
> >  		ret = __sgx_encl_extend(encl, epc_page);
> > -
> > -		/* ENCLS failure. */
> > -		if (ret) {
> > -			sgx_encl_destroy(encl);
> > -			goto out_unlock;
> > -		}
> > +		if (ret)
> > +			goto err_out;
> >  	}
> >  
> >  	sgx_mark_page_reclaimable(encl_page->epc_page);
> >  
> > -out_unlock:
> >  	mutex_unlock(&encl->lock);
> >  	up_read(&current->mm->mmap_sem);
> >  	return ret;
> > @@ -460,6 +450,13 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> >  	sgx_free_page(epc_page);
> >  	kfree(encl_page);
> >  
> > +	/*
> > +	 * Destroy enclave on ENCLS failure as this means that EPC has been
> > +	 * invalidated.
> 
> This comment is wrong, EADD can fail due to bad userspace input, and both
> EADD and EEXTEND can fail due to hardware/software bugs. 

Any piece of kernel code can fail because of either hardware or software
bug. Still almost none of the comments explicitly state this.

However, userspace input is a valid remark.

> 
> > +	 */
> > +	if (ret == -EIO)
> 
> Not a fan of making this dependent on -EIO, IMO invalidating iff EEXTEND
> fails is cleaner.  In other words, I still think killing the enclave on
> on EADD failure is unnecessary.

This comes down to whether you consider them as a transaction. I do
and it makes a coherent API.

If user code wants to give on purpose bad input for EADD, I think
it is sane to kill the enclave also in that case. There is no legit
use case where user code would do that.

Potentially that could be malicious behaviour (maybe nothing useful can
be done with that primitive but that is only thing that it could be
theoretically used for since legit use cases do not exist).

> Side topic, __sgx_encl_add_page() doesn't correctly get_user_pages()
> returning zero, e.g. the code should be something like:
> 
> 	ret = get_user_pages(src, 1, 0, &src_page, NULL);
> 	if (!ret)
> 		return -EBUSY:
> 	if (ret < 0)
> 		return ret;

Thanks! I'll update the GIT based on your feedback (it's probably
better that at this point for small scoped changes you just
describe the change and I'll update. With all squashing and
rebasing that is fastest).

/Jarkko
