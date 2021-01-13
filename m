Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF21C433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 13 Jan 2021 01:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E97E23135
	for <linux-sgx@archiver.kernel.org>; Wed, 13 Jan 2021 01:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbhAMBKC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 12 Jan 2021 20:10:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:42082 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbhAMBKB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 12 Jan 2021 20:10:01 -0500
IronPort-SDR: SMqF4z9G7eyX6hLwisOQl6QPj8AFvsoXklcUQKo97uq8ykUO3m/2vWFq08FeWyI6lavv0jZv0t
 mMItqBFeQLjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="239673392"
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="239673392"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 17:09:21 -0800
IronPort-SDR: LhQHngKa4H0CjDPuaRQbC/e4N9rAt1KV0Kz/5JYqDU03UPTPsexYgQjh4z3ula3L3l635kuXUV
 QEQFWOgSwiZA==
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="381647869"
Received: from rjchin-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.18.242])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 17:09:19 -0800
Date:   Wed, 13 Jan 2021 14:09:17 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     jarkko@kernel.org
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 2/2] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210113140917.d02dd73185604bc5d2f1501e@intel.com>
In-Reply-To: <20210112233351.68678-3-jarkko@kernel.org>
References: <20210112233351.68678-1-jarkko@kernel.org>
        <20210112233351.68678-3-jarkko@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 13 Jan 2021 01:33:51 +0200 jarkko@kernel.org wrote:
> From: "jarkko@kernel.org" <jarkko@kernel.org>
> 
> Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
> sgx_reset_epc_page(), which is a static helper function for
> sgx_encl_release(). It's the only function existing, which deals with
> initialized pages.
> 
> Signed-off-by: jarkko@kernel.org <jarkko@kernel.org>
> ---
> v2: Fixed a compilation error s/page/epc_page/ change not amended
>     to the patches.
>  arch/x86/kernel/cpu/sgx/encl.c | 15 ++++++++++++++-
>  arch/x86/kernel/cpu/sgx/main.c | 10 ++++------
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index fe7256db6e73..511f4bc70699 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -389,6 +389,16 @@ const struct vm_operations_struct sgx_vm_ops = {
>  	.access = sgx_vma_access,
>  };
>  
> +
> +static void sgx_reset_epc_page(struct sgx_epc_page *epc_page)
> +{
> +	int ret;
> +
> +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> +		return;
> +}
> +
>  /**
>   * sgx_encl_release - Destroy an enclave instance
>   * @kref:	address of a kref inside &sgx_encl
> @@ -412,6 +422,7 @@ void sgx_encl_release(struct kref *ref)
>  			if (sgx_unmark_page_reclaimable(entry->epc_page))
>  				continue;
>  
> +			sgx_reset_epc_page(entry->epc_page);
>  			sgx_free_epc_page(entry->epc_page);
>  			encl->secs_child_cnt--;
>  			entry->epc_page = NULL;
> @@ -423,6 +434,7 @@ void sgx_encl_release(struct kref *ref)
>  	xa_destroy(&encl->page_array);
>  
>  	if (!encl->secs_child_cnt && encl->secs.epc_page) {
> +		sgx_reset_epc_page(encl->secs.epc_page);
>  		sgx_free_epc_page(encl->secs.epc_page);
>  		encl->secs.epc_page = NULL;
>  	}
> @@ -431,7 +443,8 @@ void sgx_encl_release(struct kref *ref)
>  		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
>  					   list);
>  		list_del(&va_page->list);
> -		sgx_free_epc_page(va_page->epc_page);
> +		sgx_reset_epc_page(entry->epc_page);
> +		sgx_free_epc_page(entry->epc_page);

Reply so that Sean can see, since he just subscribed to linux-sgx list.

As Sean pointed out in KVM SGX virtualization thread, entry should be va_page.

>  		kfree(va_page);
>  	}
>  
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index b2996cb63a8a..89d52fb56d4b 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -629,16 +629,14 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
>   * sgx_free_epc_page() - Free an EPC page
>   * @page:	an EPC page
>   *
> - * Call EREMOVE for an EPC page and insert it back to the list of free pages.
> + * Put the EPC page back to the list of free pages. It's the callers
> + * responsibility to make sure that the page is in uninitialized state In other
> + * words, do EREMOVE, EWB or whatever operation is necessary before calling
> + * this function.
>   */
>  void sgx_free_epc_page(struct sgx_epc_page *page)
>  {
>  	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
> -	int ret;
> -
> -	ret = __eremove(sgx_get_epc_virt_addr(page));
> -	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> -		return;
>  
>  	spin_lock(&section->lock);
>  	list_add_tail(&page->list, &section->page_list);
> -- 
> 2.29.2
> 
