Return-Path: <SRS0=qYOK=Z7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A80C43603
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Dec 2019 21:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0FE5206E0
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Dec 2019 21:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfLIVWF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 Dec 2019 16:22:05 -0500
Received: from mga17.intel.com ([192.55.52.151]:12631 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfLIVWF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 9 Dec 2019 16:22:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 12:52:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="210203336"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 09 Dec 2019 12:52:55 -0800
Date:   Mon, 9 Dec 2019 12:52:55 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Huang Haitao <haitao.huang@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix double-free when EADD fails
Message-ID: <20191209205254.GE4042@linux.intel.com>
References: <20191205100151.18950-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205100151.18950-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Dec 05, 2019 at 12:01:51PM +0200, Jarkko Sakkinen wrote:
> radix_tree_delete() gets called twice for the same page  when EADD
> fails. This commit fixes the issue.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Reported-by: Huang Haitao <haitao.huang@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index ab9e48cd294b..2ff12038a8a4 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -413,13 +413,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
>  
>  	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
>  				  src);
> -	if (ret) {
> -		/* ENCLS failure. */
> -		if (ret == -EIO)
> -			sgx_encl_destroy(encl);
> -
> +	if (ret)
>  		goto err_out;
> -	}
>  
>  	/*
>  	 * Complete the "add" before doing the "extend" so that the "add"
> @@ -432,17 +427,12 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
>  
>  	if (flags & SGX_PAGE_MEASURE) {
>  		ret = __sgx_encl_extend(encl, epc_page);
> -
> -		/* ENCLS failure. */
> -		if (ret) {
> -			sgx_encl_destroy(encl);
> -			goto out_unlock;
> -		}
> +		if (ret)
> +			goto err_out;
>  	}
>  
>  	sgx_mark_page_reclaimable(encl_page->epc_page);
>  
> -out_unlock:
>  	mutex_unlock(&encl->lock);
>  	up_read(&current->mm->mmap_sem);
>  	return ret;
> @@ -460,6 +450,13 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
>  	sgx_free_page(epc_page);
>  	kfree(encl_page);
>  
> +	/*
> +	 * Destroy enclave on ENCLS failure as this means that EPC has been
> +	 * invalidated.

This comment is wrong, EADD can fail due to bad userspace input, and both
EADD and EEXTEND can fail due to hardware/software bugs. 

> +	 */
> +	if (ret == -EIO)

Not a fan of making this dependent on -EIO, IMO invalidating iff EEXTEND
fails is cleaner.  In other words, I still think killing the enclave on
on EADD failure is unnecessary.

Side topic, __sgx_encl_add_page() doesn't correctly get_user_pages()
returning zero, e.g. the code should be something like:

	ret = get_user_pages(src, 1, 0, &src_page, NULL);
	if (!ret)
		return -EBUSY:
	if (ret < 0)
		return ret;

> +		sgx_encl_destroy(encl);
> +
>  	return ret;
>  }
>  
> -- 
> 2.20.1
> 
