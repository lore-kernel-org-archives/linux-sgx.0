Return-Path: <SRS0=L1tv=Y4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BADFCA9EB5
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 20:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0F4320869
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 20:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfKDUqD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:46:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:15624 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbfKDUqD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Nov 2019 15:46:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 12:46:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="352936124"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 04 Nov 2019 12:46:02 -0800
Date:   Mon, 4 Nov 2019 12:46:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 1/3] x86/sgx: Use GFP_KERNEL for allocations
Message-ID: <20191104204602.GA5960@linux.intel.com>
References: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 04, 2019 at 10:01:39PM +0200, Jarkko Sakkinen wrote:
> The reasoning is the same as in
> 
> http://git.infradead.org/users/jjs/linux-tpmdd.git/commit/abd55954f91a3aacc1d260d2411cf776ec4d5fd2
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 5b28a9c0cb68..d53aee5a64c1 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -259,7 +259,7 @@ static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
>  	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
>  		return -EFAULT;
>  
> -	secs_page = alloc_page(GFP_HIGHUSER);
> +	secs_page = alloc_page(GFP_KERNEL);
>  	if (!secs_page)
>  		return -ENOMEM;
>  
> @@ -674,7 +674,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
>  	if (copy_from_user(&einit, arg, sizeof(einit)))
>  		return -EFAULT;
>  
> -	initp_page = alloc_page(GFP_HIGHUSER);
> +	initp_page = alloc_page(GFP_KERNEL);

Would it make sense to use GFP_KERNEL_ACCOUNT?  The accounting would be
weird for the case where userspace is using a builder process, but even in
that case it's not flat out wrong to account per-enclave memory allocations.

>  	if (!initp_page)
>  		return -ENOMEM;
>  
> -- 
> 2.20.1
> 
