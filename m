Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A753DC2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 21:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5023D2083B
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 21:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgI1VY2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:24:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:52923 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgI1VY2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 17:24:28 -0400
IronPort-SDR: 6S6FrWXuD68E4sNXgYZZA7Mor50ZUV9vxY6/I3w2sYzWB3XGbd/PKnXbaRvZwPk5H5HzI1VKe8
 HkK5NhTRkPvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="226212451"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="226212451"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:24:26 -0700
IronPort-SDR: 1eG40k5B7TzoDsHZBGJC0oRGYrFFXHr9BccPhRTe4k1VTsLixYC4LtYdUV9DJWGrEfKP3HXTFL
 BUNEczx1Hpdg==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="488767075"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO mqcpg7oapc828.gar.corp.intel.com) ([10.255.35.193])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 28 Sep 2020 14:24:25 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     linux-sgx@vger.kernel.org,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc:     "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Borislav Petkov" <bp@alien8.de>
Subject: Re: [PATCH] x86/sgx: Refine rollback in SGX_IOC_ENCLAVE_ADD_PAGE
References: <20200918130226.39530-1-jarkko.sakkinen@linux.intel.com>
Date:   Mon, 28 Sep 2020 16:24:23 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0roax0jswjvjmi@mqcpg7oapc828.gar.corp.intel.com>
In-Reply-To: <20200918130226.39530-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 18 Sep 2020 08:02:26 -0500, Jarkko Sakkinen  
<jarkko.sakkinen@linux.intel.com> wrote:

> Revert back 'count' to struct sgx_enclave_add_pages as in most of the
> cases enclave can be recovered. Refine the documentation to better
> describe the enclave is persisted.
>
> Move the check for -EIO from sgx_encl_add_page() to
> sgx_ioc_enclave_pages() to make it more visible. It was quite
> hidden over there.
>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Haitao Huang <haitao.huang@linux.intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/uapi/asm/sgx.h | 12 +++++++-----
>  arch/x86/kernel/cpu/sgx/ioctl.c | 29 ++++++++++++++---------------
>  2 files changed, 21 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/include/uapi/asm/sgx.h  
> b/arch/x86/include/uapi/asm/sgx.h
> index 1564d7f88597..ec5157b2ff50 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -45,13 +45,15 @@ struct sgx_enclave_create  {
>   * @length:	length of the data (multiple of the page size)
>   * @secinfo:	address for the SECINFO data
>   * @flags:	page control flags
> + * @count:	number of bytes added (multiple of the page size)
>   */
>  struct sgx_enclave_add_pages {
> -	__u64	src;
> -	__u64	offset;
> -	__u64	length;
> -	__u64	secinfo;
> -	__u64	flags;
> +	__u64 src;
> +	__u64 offset;
> +	__u64 length;
> +	__u64 secinfo;
> +	__u64 flags;
> +	__u64 count;
>  };
> /**
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c  
> b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 30de66f4247b..d10179b47daa 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -449,16 +449,6 @@ static int sgx_encl_add_page(struct sgx_encl *encl,  
> unsigned long src,
>  	sgx_free_epc_page(epc_page);
>  	kfree(encl_page);
> -	/*
> -	 * Destroy enclave on ENCLS failure as this means that EPC has been
> -	 * invalidated.
> -	 */
> -	if (ret == -EIO) {
> -		mutex_lock(&encl->lock);
> -		sgx_encl_destroy(encl);
> -		mutex_unlock(&encl->lock);
> -	}
> -
>  	return ret;
>  }
> @@ -487,12 +477,15 @@ static int sgx_encl_add_page(struct sgx_encl  
> *encl, unsigned long src,
>   *
>   * If ENCLS opcode fails, that effectively means that EPC has been  
> invalidated.
>   * When this happens the enclave is destroyed and -EIO is returned to  
> the
> - * caller.
> + * caller. In this situation the function destroys the enclave as it  
> cannot
> + * be recovered.
>   *
>   * Return:
>   *   length of the data processed on success,
>   *   -EACCES if an executable source page is located in a noexec  
> partition,
> - *   -EIO if either ENCLS[EADD] or ENCLS[EEXTEND] fails
> + *   -ENOMEM if the system is out of EPC pages,
> + *   -EINTR if the call was interrupted before any data was processed,
> + *   -EIO if either ENCLS[EADD] or ENCLS[EEXTEND] fails,
>   *   -errno otherwise
>   */
>  static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void  
> __user *arg)
> @@ -549,10 +542,16 @@ static long sgx_ioc_enclave_add_pages(struct  
> sgx_encl *encl, void __user *arg)
>  			break;
>  	}
> -	if (ret)
> -		return ret;
> +	addp.count = c;
> +
> +	/* On EADD or EEXTEND failure, destroy the enclave. */
> +	if (ret == -EIO) {
> +		mutex_lock(&encl->lock);
> +		sgx_encl_destroy(encl);
> +		mutex_unlock(&encl->lock);
> +	}
> -	return c;

missing copy_to_user for addp.count?

> +	return ret;
>  }
> static int __sgx_get_key_hash(struct crypto_shash *tfm, const void  
> *modulus,
