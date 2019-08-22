Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD7BC3A59D
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 04:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEAD02173E
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 04:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbfHVEAr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 00:00:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:10597 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfHVEAr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 00:00:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 21:00:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,415,1559545200"; 
   d="scan'208";a="196143336"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 21 Aug 2019 21:00:46 -0700
Date:   Wed, 21 Aug 2019 21:00:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christpherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH 5/5] x86/sgx: Rename vm_prot_bits as max_vm_flags
Message-ID: <20190822040046.GW29345@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-6-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819152544.7296-6-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 06:25:44PM +0300, Jarkko Sakkinen wrote:
> vm_prot_bits is very bad and misleading name for the field in struct
> sgx_encl_page. What the field contains exactly is not @prot of
> mprotect() but the *maximum* VM flags for the VMA that contains the
> given enclave page.
> 
> Thus, the only viable name for the field is max_vm_flags. In functions
> that also pass VM flags the parameter name is renamed from vm_prot_bits
> to vm_flags.

Why not max_vm_prot_bits?  'vm_flags' implies the field contains all
manner of VM_FLAGS.  The 'vm_prot_bits' name was derived from
calc_vm_prot_bits() to provide this differentiation, especially since
there's also a calc_vm_flag_bits(),

> To summarize, this commit makes two improvements to clarify the
> permission handling:
> 
> 1. Changes the name to match better the contents.
> 2. Uses naming to differentiate the field inside the struct and
>    the parameter passed to functions.
> 
> Cc: Sean Christopherson <sean.j.christpherson@intel.com>
> Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Cc: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c |  2 +-
>  arch/x86/kernel/cpu/sgx/encl.c         | 14 +++++++-------
>  arch/x86/kernel/cpu/sgx/encl.h         |  4 ++--
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index 2415dcb20a6e..b61e06daad6e 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -261,7 +261,7 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
>  	encl_page->encl = encl;
>  
>  	/* Calculate maximum of the VM flags for the page. */
> -	encl_page->vm_prot_bits = calc_vm_prot_bits(prot, 0);
> +	encl_page->max_vm_flags = calc_vm_prot_bits(prot, 0);
>  
>  	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
>  				encl_page);
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index a20d498e9dcd..890eacb45a80 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -292,25 +292,25 @@ static unsigned int sgx_vma_fault(struct vm_fault *vmf)
>   * @encl:		an enclave
>   * @start:		lower bound of the address range, inclusive
>   * @end:		upper bound of the address range, exclusive
> - * @vm_prot_bits:	requested protections of the address range
> + * @vm_flags:		requested VM flags for the address range
>   *
>   * Iterate through the enclave pages contained within [@start, @end) to verify
> - * the permissions requested by @vm_prot_bits do not exceed that of any enclave
> - * page to be mapped.  Page addresses that do not have an associated enclave
> - * page are interpreted to zero permissions.
> + * the the VM flags do not exceed that of any enclave page to be mapped. Page
> + * addresses that do not have an associated enclave page are interpreted to zero
> + * permissions.
>   *
>   * Return:
>   *   0 on success,
>   *   -EACCES if VMA permissions exceed enclave page permissions
>   */
>  int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> -		     unsigned long end, unsigned long vm_prot_bits)
> +		     unsigned long end, unsigned long vm_flags)

If 'vm_prot_bits' is distasteful, 'prot' would be preferrable as its used
throughout the kernel for variable that hold only the prot bits.

>  {
>  	unsigned long idx, idx_start, idx_end;
>  	struct sgx_encl_page *page;
>  
>  	/* PROT_NONE always succeeds. */
> -	if (!vm_prot_bits)
> +	if (!vm_flags)
>  		return 0;
>  
>  	idx_start = PFN_DOWN(start);
> @@ -321,7 +321,7 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
>  		page = radix_tree_lookup(&encl->page_tree, idx);
>  		mutex_unlock(&encl->lock);
>  
> -		if (!page || (~page->vm_prot_bits & vm_prot_bits))
> +		if (!page || (~page->max_vm_flags & vm_flags))
>  			return -EACCES;
>  	}
>  
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index d3a1687ed84c..0e28b784a8c5 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -44,7 +44,7 @@ enum sgx_encl_page_desc {
>  
>  struct sgx_encl_page {
>  	unsigned long desc;
> -	unsigned long vm_prot_bits;
> +	unsigned long max_vm_flags;
>  	struct sgx_epc_page *epc_page;
>  	struct sgx_va_page *va_page;
>  	struct sgx_encl *encl;
> @@ -134,6 +134,6 @@ void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
>  bool sgx_va_page_full(struct sgx_va_page *va_page);
>  
>  int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> -		     unsigned long end, unsigned long vm_prot_bits);
> +		     unsigned long end, unsigned long vm_flags);
>  
>  #endif /* _X86_ENCL_H */
> -- 
> 2.20.1
> 
