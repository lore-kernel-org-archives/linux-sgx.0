Return-Path: <SRS0=L1tv=Y4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99424CA9EB5
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 20:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7583A20842
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 20:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbfKDUyC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:54:02 -0500
Received: from mga07.intel.com ([134.134.136.100]:16232 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbfKDUyC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Nov 2019 15:54:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 12:54:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="403103841"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 04 Nov 2019 12:54:01 -0800
Date:   Mon, 4 Nov 2019 12:54:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 2/3] x86/sgx: Destroy enclave if EADD fails
Message-ID: <20191104205401.GB5960@linux.intel.com>
References: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
 <20191104200141.5385-2-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104200141.5385-2-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 04, 2019 at 10:01:40PM +0200, Jarkko Sakkinen wrote:
> __sgx_encl_add_page() can only fail in the case of EPCM conflict at least
> in non-artificial situations.

Huh?  EADD can fail for a variety of reasons.  I can't think of a use case
where userspace _won't_ kill the enclave in response to failure, but that
doesn't justify killing the enclave, e.g. we don't kill the enclave in any
other error path that is just as indicative of a userspace bug.

> Also, it consistent semantics in rollback is something to pursue for.

I don't follow this at all.  How is it inconsistent to state that errors
are handled gracefully unless they're unrecoverable?

> Thus, destroy enclave when the EADD fails as we do when EEXTEND fails
> already.
> 
> In the cases it is sane to return -EIO. From this the caller can deduce
> the failure and knows that the enclave was destroyed. The previous
> -EFAULT could happen in numerous situations.

This should be a separate patch.

> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index d53aee5a64c1..289af607f634 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -338,7 +338,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
>  	kunmap_atomic((void *)pginfo.contents);
>  	put_page(src_page);
>  
> -	return ret ? -EFAULT : 0;
> +	return ret ? -EIO : 0;
>  }
>  
>  static int __sgx_encl_extend(struct sgx_encl *encl,
> @@ -353,7 +353,7 @@ static int __sgx_encl_extend(struct sgx_encl *encl,
>  		if (ret) {
>  			if (encls_failed(ret))
>  				ENCLS_WARN(ret, "EEXTEND");
> -			return -EFAULT;
> +			return -EIO;
>  		}
>  	}
>  
> @@ -413,8 +413,10 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
>  
>  	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
>  				  addp->src);
> -	if (ret)
> +	if (ret) {
> +		sgx_encl_destroy(encl);
>  		goto err_out;
> +	}
>  
>  	/*
>  	 * Complete the "add" before doing the "extend" so that the "add"
> @@ -498,10 +500,9 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
>   *
>   * Return:
>   *   0 on success,
> - *   -EINVAL if any input param or the SECINFO contains invalid data,
>   *   -EACCES if an executable source page is located in a noexec partition,
> - *   -ENOMEM if any memory allocation, including EPC, fails,
> - *   -ERESTARTSYS if a pending signal is recognized

Why are you removing the documentation for EINVAL, ENOMEM and ERESTARTSYS?

> + *   -EIO if either ENCLS[EADD] or ENCLS[EEXTEND] fails
> + *   -errno otherwise
>   */
>  static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
>  {
> -- 
> 2.20.1
> 
