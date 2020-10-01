Return-Path: <SRS0=F+z5=DI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86575C4727E
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 22:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45CCB20738
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 22:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgJAWK7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Oct 2020 18:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgJAWK6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Oct 2020 18:10:58 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC3C20706;
        Thu,  1 Oct 2020 22:10:58 +0000 (UTC)
Date:   Fri, 2 Oct 2020 01:10:56 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Update correct attributes variable when
 allowing provisioning
Message-ID: <20201001220824.GA24069@linux.intel.com>
References: <20201001210208.19070-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001210208.19070-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 01, 2020 at 02:02:08PM -0700, Sean Christopherson wrote:
> Set the PROVISIONKEY flag in attributes_mask, a.k.a. the mask of allowed
> attributes for the enclave, when the enclave's owner demonstrates access
> to /dev/sgx/provision.  Setting the flag in the enclave's attributes
> effectively declares intent to access the key, whereas the ioctl()'s
> intent is to grant access to the key.
> 
> Fixes: 80e062767a37 ("x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thank you!

For this kind of fixes ignore the fixes tag and just put at most a lore
link to the response or something. I feel bad that you went all that
trouble writing the paragraph :-)

Anyway, thanks again.

> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index ec38a9416788..16d0c9abafc2 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -763,7 +763,7 @@ static long sgx_ioc_enclave_provision(struct sgx_encl *encl, void __user *arg)
>  		goto out;
>  	}
>  
> -	encl->attributes |= SGX_ATTR_PROVISIONKEY;
> +	encl->attributes_mask |= SGX_ATTR_PROVISIONKEY;
>  	ret = 0;
>  
>  out:
> -- 
> 2.28.0
> 

/Jarkko
