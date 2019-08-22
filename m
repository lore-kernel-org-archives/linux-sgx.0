Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D5CC3A59D
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D75F721848
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfHVDrO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 23:47:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:3159 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbfHVDrO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 23:47:14 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 20:47:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,415,1559545200"; 
   d="scan'208";a="207986313"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 21 Aug 2019 20:47:13 -0700
Date:   Wed, 21 Aug 2019 20:47:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christpherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH 2/5] x86/sgx: Use memchr_inv() in sgx_validate_secinfo()
Message-ID: <20190822034713.GT29345@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-3-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819152544.7296-3-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 06:25:41PM +0300, Jarkko Sakkinen wrote:
> Instead of looping through the array of reserved bytes use memchr_inv()
> to check the bytes.
> 
> Cc: Sean Christopherson <sean.j.christpherson@intel.com>
> Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Cc: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index 64d3286f3324..d5f326411df0 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -414,7 +414,6 @@ static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
>  {
>  	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
>  	u64 perm = secinfo->flags & SGX_SECINFO_PERMISSION_MASK;
> -	int i;
>  
>  	if ((secinfo->flags & SGX_SECINFO_RESERVED_MASK) ||
>  	    ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R)) ||
> @@ -422,9 +421,8 @@ static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
>  	     page_type != SGX_SECINFO_REG))
>  		return -EINVAL;
>  
> -	for (i = 0; i < SGX_SECINFO_RESERVED_SIZE; i++)
> -		if (secinfo->reserved[i])
> -			return -EINVAL;
> +	if (memchr_inv(secinfo->reserved, 0, SGX_SECINFO_RESERVED_SIZE))

Doing 'sizeof(secinfo->reserved)' would be preferable, that way we're not
dependent on SGX_SECINFO_RESERVED_SIZE being in bytes (I had to check).

Obviously not in this patch, but the same cleanup can be applied to
sgx_validate_secs().

> +		return -EINVAL;
>  
>  	return 0;
>  }
> -- 
> 2.20.1
> 
