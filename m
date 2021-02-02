Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC9CC433E0
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 22:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5DD364D9E
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 22:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbhBBWqX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Feb 2021 17:46:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233511AbhBBWqW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 2 Feb 2021 17:46:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 718DD64F68;
        Tue,  2 Feb 2021 22:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612305941;
        bh=ZyPBR6LBIEzTmxhQyTuRnZ0//Ac+FOOWAJENdiy81lg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lrr6XlKUF/fIAdcdGvCeH5fUn5EDF7fPTRUepmNi8uZeTDLwdnCzzN4UXH4llQg/f
         ngEFpQp4Wo5nmeqUzeX9EFIdk75lN9/qozFSrmKdGhZpP5rGohWAXzorw7zUF547eN
         4hOeGBPk5dfyfZogxMpEFrXI5LwPSO308tOQQ0pHf/feb+Dd+DCT0ETQ4aSnG1yRJF
         B6kIPb2h3lqqYxun+YqfEUsTju0EbA109Zy4LUZvx7PHCslyLcfvBtZnm9+Ay4ADLf
         Y1EbMVEE8LfDvJx1nMJl0zkvBllYs6YpmBMfYQD6ZVYG/iJPfYUv7BFuSSjT3Ft9sV
         U97VM6HlBtJ2g==
Date:   Wed, 3 Feb 2021 00:45:33 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     ira.weiny@intel.com
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH V3] x86: Remove unnecessary kmap() from
 sgx_ioc_enclave_init()
Message-ID: <YBnWDTlhE3K26CTp@kernel.org>
References: <20210202194719.3525076-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202194719.3525076-1-ira.weiny@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 02, 2021 at 11:47:19AM -0800, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> kmap is inefficient and we are trying to reduce the usage in the kernel.
> There is no readily apparent reason why initp_page needs to be allocated
> and kmap'ed() but sigstruct needs to be page aligned and token
> 512 byte aligned.
> 
> kmalloc() can give us this alignment but we need to allocate PAGE_SIZE
> bytes to do so.  Rather than change this kmap() to kmap_local_page() use
> kmalloc() instead.
> 
> Remove the alloc_page()/kmap() and replace with kmalloc() to get a
> kernel address to use.
> 
> In addition add a comment to document the alignment requirements so that
> others like myself don't attempt to 'fix' this again.  Finally, add 2
> BUILD_BUG_ON's to ensure future changes to sigstruct and token do not go
> unnoticed and cause a bug.
> 
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes from v2[1]:
> 	When allocating a power of 2 size kmalloc() now guarantees the
> 	alignment of the respective size.  So go back to using kmalloc() but
> 	with a PAGE_SIZE allocation to get the alignment.  This also follows
> 	the pattern in sgx_ioc_enclave_create()
> 
> Changes from v1[1]:
> 	Use page_address() instead of kcmalloc() to ensure sigstruct is
> 	page aligned
> 	Use BUILD_BUG_ON to ensure token and sigstruct don't collide.
> 
> [1] https://lore.kernel.org/lkml/20210129001459.1538805-1-ira.weiny@intel.com/
> [2] https://lore.kernel.org/lkml/20210202013725.3514671-1-ira.weiny@intel.com/
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 90a5caf76939..e0c3301ccd67 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -604,7 +604,6 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
>  {
>  	struct sgx_sigstruct *sigstruct;
>  	struct sgx_enclave_init init_arg;
> -	struct page *initp_page;
>  	void *token;
>  	int ret;
>  
> @@ -615,11 +614,16 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
>  	if (copy_from_user(&init_arg, arg, sizeof(init_arg)))
>  		return -EFAULT;
>  
> -	initp_page = alloc_page(GFP_KERNEL);
> -	if (!initp_page)
> +	/*
> +	 * sigstruct must be on a page boundry and token on a 512 byte boundry
> +	 * kmalloc() gives us this alignment when allocating PAGE_SIZE bytes
> +	 */
> +	sigstruct = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!sigstruct)
>  		return -ENOMEM;
>  
> -	sigstruct = kmap(initp_page);
> +	BUILD_BUG_ON(sizeof(*sigstruct) > (PAGE_SIZE/2));
> +	BUILD_BUG_ON(SGX_LAUNCH_TOKEN_SIZE > (PAGE_SIZE/2));

Please remove these.

>  	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
>  	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
>  
> @@ -645,8 +649,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
>  	ret = sgx_encl_init(encl, sigstruct, token);
>  
>  out:
> -	kunmap(initp_page);
> -	__free_page(initp_page);
> +	kfree(sigstruct);
>  	return ret;
>  }
>  
> -- 
> 2.28.0.rc0.12.gb6a658bd00c9
> 
> 

/Jarkko
