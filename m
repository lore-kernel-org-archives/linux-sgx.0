Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65EAC433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Mar 2021 08:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67EC064F7F
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Mar 2021 08:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhCQIGz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:06:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:6247 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230484AbhCQIGj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 17 Mar 2021 04:06:39 -0400
IronPort-SDR: QAaGQt/bEyk9zKGoHlwOMVJKJF+nyAzKLaUSbeFhLMktT1LG82Q/fJEZV4EnhBoK0ryk84ecQ1
 I1kfLLAjZOnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="177011795"
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="177011795"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 01:06:38 -0700
IronPort-SDR: AFfPD6e/qJw85vHEsNRJ78zYJsTaOt+Z9hM4Rf3KL45vIq4fGU7sbZGZIFvrZAHQVNrQgo3oN0
 WgyGwZF5VBmw==
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="405841553"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 01:06:38 -0700
Date:   Wed, 17 Mar 2021 01:06:38 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] x86: Remove unnecessary kmap() from
 sgx_ioc_enclave_init()
Message-ID: <20210317080638.GU3014244@iweiny-DESK2.sc.intel.com>
References: <20210306002058.303796-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210306002058.303796-1-ira.weiny@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 05, 2021 at 04:20:58PM -0800, 'Ira Weiny' wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> kmap is inefficient and we are trying to reduce the usage in the kernel.
> There is no readily apparent reason why initp_page needs to be allocated
> and kmap'ed() but sigstruct needs to be page aligned and token
> 512 byte aligned.

Friendly ping, maybe I missed a response?
Ira

> 
> kmalloc() can give us this alignment but we need to allocate PAGE_SIZE
> bytes to do so.  Rather than change this kmap() to kmap_local_page() use
> kmalloc() instead.
> 
> Remove the alloc_page()/kmap() and replace with kmalloc(PAGE_SIZE, ...)
> to get a page aligned kernel address to use.
> 
> In addition add a comment to document the alignment requirements so that
> others like myself don't attempt to 'fix' this again.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Jethro Beekman <jethro@fortanix.com>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes from v4[4]:
> 	Add Ack and Reviews
> 	Send to the correct maintainers
> 
> Changes from v3[3]:
> 	Remove BUILD_BUG_ONs
> 
> Changes from v2[2]:
>         When allocating a power of 2 size kmalloc() now guarantees the
>         alignment of the respective size.  So go back to using kmalloc() but
>         with a PAGE_SIZE allocation to get the alignment.  This also follows
>         the pattern in sgx_ioc_enclave_create()
> 
> Changes from v1[1]:
> 	Use page_address() instead of kcmalloc() to ensure sigstruct is
> 	page aligned
> 	Use BUILD_BUG_ON to ensure token and sigstruct don't collide.
> 
> [1] https://lore.kernel.org/lkml/20210129001459.1538805-1-ira.weiny@intel.com/
> [2] https://lore.kernel.org/lkml/20210202013725.3514671-1-ira.weiny@intel.com/
> [3] https://lore.kernel.org/lkml/20210205050850.GC5033@iweiny-DESK2.sc.intel.com/#t
> [4] https://lore.kernel.org/lkml/YCBY02iEKLVyj7Ix@kernel.org/
> 
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 90a5caf76939..38e540de5e2a 100644
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
> @@ -615,11 +614,14 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
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
>  	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
>  	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
>  
> @@ -645,8 +647,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
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
