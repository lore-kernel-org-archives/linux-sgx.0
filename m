Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0325C3A59E
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9364F22CF7
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 03:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfHVDn5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 23:43:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:61518 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbfHVDn5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 23:43:57 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 20:43:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,415,1559545200"; 
   d="scan'208";a="190428168"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 21 Aug 2019 20:43:56 -0700
Date:   Wed, 21 Aug 2019 20:43:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christpherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH 1/5] x86/sgx: Document permission handling better
Message-ID: <20190822034356.GS29345@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-2-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819152544.7296-2-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 06:25:40PM +0300, Jarkko Sakkinen wrote:
> The way permissions are managed inside the driver is not trivial and
> intuitive. The non-obvious parts were not properly remarked in the
> source code. This patch refines them a bit.
> 
> Cc: Sean Christopherson <sean.j.christpherson@intel.com>
> Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Cc: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index 9b784a061a47..64d3286f3324 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -259,7 +259,10 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
>  		return ERR_PTR(-ENOMEM);
>  	encl_page->desc = addr;
>  	encl_page->encl = encl;
> +
> +	/* Calculate maximum of the VM flags for the page. */
>  	encl_page->vm_prot_bits = calc_vm_prot_bits(prot, 0);
> +
>  	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
>  				encl_page);
>  	if (ret) {
> @@ -640,11 +643,15 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
>  
>  	data = kmap(data_page);
>  
> +	/* Set prot bits matching to the SECINFO permissions. */
>  	prot = _calc_vm_trans(secinfo.flags, SGX_SECINFO_R, PROT_READ)  |
>  	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_W, PROT_WRITE) |
>  	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_X, PROT_EXEC);
>  
> -	/* TCS pages need to be RW in the PTEs, but can be 0 in the EPCM. */
> +	/* TCS pages must always RW set for CPU access while the SECINFO

Should be

	/*
	 * TCS pages ...

> +	 * permissions are *always* zero - the CPU ignores the user provided
> +	 * values and silently overwrites zero permissions.

Maybe 'overwrites with zero permissions'?

> +	 */
>  	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
>  		prot |= PROT_READ | PROT_WRITE;
>  
> -- 
> 2.20.1
> 
