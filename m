Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52ACAC10F14
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 17:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E91521835
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 17:41:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="T4/df+dZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfJHRl0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 13:41:26 -0400
Received: from mail.skyhub.de ([5.9.137.197]:49666 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727677AbfJHRl0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 13:41:26 -0400
Received: from zn.tnic (p200300EC2F0B51004985F04ADA683F0C.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:5100:4985:f04a:da68:3f0c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 222B71EC0B7A;
        Tue,  8 Oct 2019 19:41:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570556485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=SJ6v4MwSJT7jj9CBnRfAH7LZOjGb4kHK+HeAwATot6c=;
        b=T4/df+dZX8mBsyqL9k4W5yymLxF55rVWyYiXSXy53Rajj5ewuoTAED/n01TuDsDISQECml
        lf7j/EICTE+/D5ctIsbOtBi/SrHL+OUDURkPqlV/NB5pPaRBQ7iF3PlEyPnf7DbOO9t7uB
        uM697X/jY0ktmDHrbmhBMzSXw9gxjaI=
Date:   Tue, 8 Oct 2019 19:41:18 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 11/24] mm: Introduce vm_ops->may_mprotect()
Message-ID: <20191008174118.GL14765@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-12-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190903142655.21943-12-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

+ linux-mm.

On Tue, Sep 03, 2019 at 05:26:42PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add vm_ops()->may_mprotect() to check additional constrains set by a

constraints

Leaving in the rest for MM folks:

> subsystem for a mprotect() call.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  include/linux/mm.h |  2 ++
>  mm/mprotect.c      | 13 ++++++++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0334ca97c584..405cea65057a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -469,6 +469,8 @@ struct vm_operations_struct {
>  	void (*close)(struct vm_area_struct * area);
>  	int (*split)(struct vm_area_struct * area, unsigned long addr);
>  	int (*mremap)(struct vm_area_struct * area);
> +	int (*may_mprotect)(struct vm_area_struct *vma, unsigned long start,
> +			    unsigned long end, unsigned long prot);
>  	vm_fault_t (*fault)(struct vm_fault *vmf);
>  	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
>  			enum page_entry_size pe_size);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index bf38dfbbb4b4..18732543b295 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -547,13 +547,20 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>  			goto out;
>  		}
>  
> +		tmp = vma->vm_end;
> +		if (tmp > end)
> +			tmp = end;
> +
> +		if (vma->vm_ops && vma->vm_ops->may_mprotect) {
> +			error = vma->vm_ops->may_mprotect(vma, nstart, tmp, prot);
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
> 2.20.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
