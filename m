Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9E4C31E5B
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 885B72080A
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfFQWab (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:30:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:56211 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfFQWab (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jun 2019 18:30:31 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:30:30 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jun 2019 15:30:29 -0700
Date:   Mon, 17 Jun 2019 15:30:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>
Subject: Re: [PATCH RFC] x86/sgx: Check that the address is within ELRANGE
Message-ID: <20190617223029.GB30158@linux.intel.com>
References: <20190613164240.31326-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613164240.31326-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 13, 2019 at 07:42:40PM +0300, Jarkko Sakkinen wrote:
> In sgx_encl_page_alloc() check that the given address within the
> ELRANGE. Return -EINVAL if not.
> 
> Reported-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index d17c60dca114..9d3fc770b4d9 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -240,19 +240,26 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
>  	struct sgx_encl_page *encl_page;
>  	int ret;
>  
> +	if (addr < encl->base || addr > (encl->base + encl->size))

The upper bounds check should be "addr >= (encl->base + encl->size)" or
"addr > (encl->base + encl->size - 1)"

> +		return ERR_PTR(-EINVAL);
> +
>  	if (radix_tree_lookup(&encl->page_tree, PFN_DOWN(addr)))
>  		return ERR_PTR(-EEXIST);
> +
>  	encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
>  	if (!encl_page)
>  		return ERR_PTR(-ENOMEM);
> +
>  	encl_page->desc = addr;
>  	encl_page->encl = encl;
> +
>  	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
>  				encl_page);
>  	if (ret) {
>  		kfree(encl_page);
>  		return ERR_PTR(ret);
>  	}
> +
>  	return encl_page;
>  }
>  
> -- 
> 2.20.1
> 
