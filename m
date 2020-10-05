Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177ABC4363D
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 02:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBD252065C
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 02:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgJEC3q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 22:29:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:5400 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgJEC3q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 22:29:46 -0400
IronPort-SDR: jmIPTjqnfw49WJjZjhNm+2Tca2qztm5JHBRuplCl36HN11V3NvNDQs2Ifqv+cWuJpGosqb5XjS
 Lb2QWOIHpkZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="150947009"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="150947009"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 19:29:44 -0700
IronPort-SDR: xWE6DLjP3bQjGicIqAbAJ8xcoKeFanp+U84/7veBTfg4FOKPYysOYW3UwzP9A50yiODVvtQILW
 TEHWi/e+KD6Q==
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="523061014"
Received: from sidorovd-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.48.68])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 19:29:42 -0700
Date:   Mon, 5 Oct 2020 05:29:40 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Remove checks for platform limits from
 sgx_validate_secs()
Message-ID: <20201005022940.GA125332@linux.intel.com>
References: <20201005020819.124724-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005020819.124724-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 05:08:19AM +0300, Jarkko Sakkinen wrote:
> Remove from sgx_validate_secs():
> 
> 	if (secs->miscselect & sgx_misc_reserved_mask ||
> 	    secs->attributes & sgx_attributes_reserved_mask ||
> 	    secs->xfrm & sgx_xfrm_reserved_mask)
> 		return -EINVAL;
> 
> SECS can surpass the platform limits because it's the SIGSTRUCT that
> defines the limits that are used at run-time.
> 
> What SECS does is that it defines the overall limits that must apply for
> any platform, i.e.  SECS limits and platform limits are orthogonal. They
> are not dependent.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Jethro Beekman <jethro@fortanix.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I think I got this now.

I think it would be less confusing if the variables were renamed as:

- sgx_cpu_misc
- sgx_cpu_attributes
- sgx_cpu_xfrm

These names nail their role better and do not imply any possible
dependency with SIGSTRUCT masks.

'cpu' is better than 'platform' because it is more exact.

Does anyone mind if I do these renames?

/Jarkko

> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 6b3cc8483008..008752cb54f0 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -86,11 +86,6 @@ static int sgx_validate_secs(const struct sgx_secs *secs)
>  	if (secs->base & (secs->size - 1))
>  		return -EINVAL;
>  
> -	if (secs->miscselect & sgx_misc_reserved_mask ||
> -	    secs->attributes & sgx_attributes_reserved_mask ||
> -	    secs->xfrm & sgx_xfrm_reserved_mask)
> -		return -EINVAL;
> -
>  	if (secs->size > max_size)
>  		return -EINVAL;
>  
> -- 
> 2.25.1
> 
