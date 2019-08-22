Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEBAC3A59D
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C790022CF7
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfHVDsZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 23:48:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:6076 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbfHVDsY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 23:48:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 20:48:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,415,1559545200"; 
   d="scan'208";a="178704285"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Aug 2019 20:48:23 -0700
Date:   Wed, 21 Aug 2019 20:48:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christpherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH 3/5] x86/sgx: Make sgx_validate_secinfo() more readable
Message-ID: <20190822034823.GU29345@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-4-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819152544.7296-4-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 06:25:42PM +0300, Jarkko Sakkinen wrote:
> Split the huge conditional statement to three separate ones in
> order to make it easier to understand what is going on in the
> validation code.
> 
> Cc: Sean Christopherson <sean.j.christpherson@intel.com>
> Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Cc: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index d5f326411df0..99b1b9776c3a 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -415,10 +415,15 @@ static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
>  	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
>  	u64 perm = secinfo->flags & SGX_SECINFO_PERMISSION_MASK;
>  
> -	if ((secinfo->flags & SGX_SECINFO_RESERVED_MASK) ||
> -	    ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R)) ||
> -	    (page_type != SGX_SECINFO_TCS && page_type != SGX_SECINFO_TRIM &&
> -	     page_type != SGX_SECINFO_REG))
> +	if ((page_type != SGX_SECINFO_REG &&
> +	     page_type != SGX_SECINFO_TCS &&
> +	     page_type != SGX_SECINFO_TRIM))

Shouldn't we disallow TRIM until SGX2 is supported?

> +		return -EINVAL;
> +
> +	if ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R))
> +		return -EINVAL;
> +
> +	if (secinfo->flags & SGX_SECINFO_RESERVED_MASK)
>  		return -EINVAL;
>  
>  	if (memchr_inv(secinfo->reserved, 0, SGX_SECINFO_RESERVED_SIZE))
> -- 
> 2.20.1
> 
