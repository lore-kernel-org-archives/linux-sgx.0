Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF25DC433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 17:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86EB820707
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 17:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="FL2pn5Is"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406703AbgFYROT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 13:14:19 -0400
Received: from mail.skyhub.de ([5.9.137.197]:52274 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406692AbgFYROS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 13:14:18 -0400
Received: from zn.tnic (p200300ec2f0ed10035c3b797f40e07e6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:d100:35c3:b797:f40e:7e6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 36ED81EC03E4;
        Thu, 25 Jun 2020 19:14:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593105257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=pwFk3tY6wzwzqRQIVbe++S9TP2D9dvPT7s4Q9Ld9iPM=;
        b=FL2pn5IsO5ocOmzMz03WaR4pqC8CRX22FLQSuekwHQOmMANyFD+iJJWYZDariQztlfb0Mc
        RP7KxDO9z2pcXY4aR063+V9ZsxzvxBuI5Y1r6Z4I9J1ouajeB544TYEJjhOoU5FBE0NrCa
        A6DWo5qb7M07EGty9kkRVpAVFC+CyHc=
Date:   Thu, 25 Jun 2020 19:14:16 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        linux-mm@kvack.org
Subject: Re: [PATCH v33 10/21] mm: Introduce vm_ops->may_mprotect()
Message-ID: <20200625171416.GI20319@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-11-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200617220844.57423-11-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 18, 2020 at 01:08:32AM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add vm_ops()->may_mprotect() to check additional constraints.
> 
> SGX uses this callback to add two constraints:
> 
> 1. Verify that the address range does not have holes: for each page
>    address, there is an actual enclave page created.
> 2. Mapped permissions do not surpass the lowest enclave page permissions
>    in the address range.
> 
> linux-mm@kvack.org
> Andrew Morton <akpm@linux-foundation.org>

Something ate the Cc:s. Lemme add the mm list, akpm is already on Cc.

Leaving in the rest for mm folks.

> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  include/linux/mm.h |  2 ++
>  mm/mprotect.c      | 14 +++++++++++---
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dc7b87310c10..be40b9c29327 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -542,6 +542,8 @@ struct vm_operations_struct {
>  	void (*close)(struct vm_area_struct * area);
>  	int (*split)(struct vm_area_struct * area, unsigned long addr);
>  	int (*mremap)(struct vm_area_struct * area);
> +	int (*may_mprotect)(struct vm_area_struct *vma, unsigned long start,
> +			    unsigned long end, unsigned long prot);
>  	vm_fault_t (*fault)(struct vm_fault *vmf);
>  	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
>  			enum page_entry_size pe_size);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index ce8b8a5eacbb..f7731dc13ff0 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -603,13 +603,21 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>  			goto out;
>  		}
>  
> +		tmp = vma->vm_end;
> +		if (tmp > end)
> +			tmp = end;
> +
> +		if (vma->vm_ops && vma->vm_ops->may_mprotect) {
> +			error = vma->vm_ops->may_mprotect(vma, nstart, tmp,
> +							  prot);
> +			if (error)
> +				goto out;
> +		}
> +
>  		error = security_file_mprotect(vma, reqprot, prot);
>  		if (error)
>  			goto out;
>  
> -		tmp = vma->vm_end;
> -		if (tmp > end)
> -			tmp = end;
>  		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
>  		if (error)
>  			goto out;
> -- 
> 2.25.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
