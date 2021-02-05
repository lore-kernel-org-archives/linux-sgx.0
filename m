Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66627C433DB
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 02:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DCF964FB3
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 02:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhBEC0z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:26:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhBEC0y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 4 Feb 2021 21:26:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BA5C64FA7;
        Fri,  5 Feb 2021 02:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612491974;
        bh=Tt7fPc2aMv6Er+p4iAbI7zx3LAvEwfWk/aglb/uCJF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uhhu5yC6OAfecCy8KlhxDFImgVpp7fiCSFdORm+7/o4Pt31v2K2BfUY7znpnXhhzg
         oWyCuw5Tg0tnlVaTtsm6ixvVSBO2wCyMuael3yHAkbjZc8tvYQTlI3YWkE5akBlHYP
         0l6r9zvr18ZA305g20MaM/QD6a+Tw1GRNROOo7dq4p+t1ryNt1VhPaM8b+lcMaTR4H
         EWVAaGMesb+ThsdujDASOrkXeY9SBebQHN72ebF1oKmAyIZr8PYU1mURp8BziRn6ya
         VVCDOAvTc1QK5wG5wbS+n/MxvsU1EsFLpgYb2WpbasIQLK/NMPAMDnWPgceCt099WK
         gb2DBXXRZ/Qcg==
Date:   Fri, 5 Feb 2021 04:26:05 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] x86/sgx: Drop racy follow_pfn check
Message-ID: <YBysvZ3NcmsT4IHK@kernel.org>
References: <20210204184519.2809313-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204184519.2809313-1-daniel.vetter@ffwll.ch>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 04, 2021 at 07:45:19PM +0100, Daniel Vetter wrote:
> PTE insertion is fundamentally racy, and this check doesn't do
> anything useful. Quoting Sean:
> 
> "Yeah, it can be whacked.  The original, never-upstreamed code asserted that the
> resolved PFN matched the PFN being installed by the fault handler as a sanity
> check on the SGX driver's EPC management.  The WARN assertion got dropped for
> whatever reason, leaving that useless chunk."

Love the "whatever reason" part :-)

Shame, I was *going to* rip this off maybe around iteration v40. I have
no idea why I did not. Even backtraced years old email threads from lore.
Probably just forgot to remove it.

So, yeah, I fully agree removing it.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

> Jason stumbled over this as a new user of follow_pfn, and I'm trying
> to get rid of unsafe callers of that function so it can be locked down
> further.
> 
> This is independent prep work for the referenced patch series.

Apologies, consider it my bad...

/Jarkko

> 
> References: https://lore.kernel.org/dri-devel/20201127164131.2244124-1-daniel.vetter@ffwll.ch/
> Reported-by: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Sean Christopherson <seanjc@google.com>
> Fixes: 947c6e11fa43 ("x86/sgx: Add ptrace() support for the SGX driver")
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: linux-sgx@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index ee50a5010277..20a2dd5ba2b4 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -141,7 +141,6 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
>  	struct sgx_encl_page *entry;
>  	unsigned long phys_addr;
>  	struct sgx_encl *encl;
> -	unsigned long pfn;
>  	vm_fault_t ret;
>  
>  	encl = vma->vm_private_data;
> @@ -168,13 +167,6 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
>  
>  	phys_addr = sgx_get_epc_phys_addr(entry->epc_page);
>  
> -	/* Check if another thread got here first to insert the PTE. */
> -	if (!follow_pfn(vma, addr, &pfn)) {
> -		mutex_unlock(&encl->lock);
> -
> -		return VM_FAULT_NOPAGE;
> -	}
> -
>  	ret = vmf_insert_pfn(vma, addr, PFN_DOWN(phys_addr));
>  	if (ret != VM_FAULT_NOPAGE) {
>  		mutex_unlock(&encl->lock);
> -- 
> 2.30.0
> 
> 
