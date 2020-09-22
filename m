Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C33C4363D
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 15:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C07F2388B
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 15:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="ot2mqXZ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgIVPob (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:44:31 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45438 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgIVPob (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Sep 2020 11:44:31 -0400
Received: from zn.tnic (p200300ec2f0bfb00281bee649a1894f0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:fb00:281b:ee64:9a18:94f0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AB6641EC00EC;
        Tue, 22 Sep 2020 17:44:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600789469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ofmUrseAbycCQWoSGsPSBEr7sPcQODqh36PCqwBgOQE=;
        b=ot2mqXZ8ahJI5pqNoMHX56jTHjhYaeu3jczmnUSz7PsVyifLgzuVMFY0/aPFwYQAevE0NF
        9OPHMeuCl227HhPaIdM9Uy0g/9tNSlMM+oadQBgE/9f4/8ycLpwpoNUc7DaEyOuRRGbDjp
        vN5YXLlyCyVVspH2kmvDVKR+oWCnT94=
Date:   Tue, 22 Sep 2020 17:44:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver
Message-ID: <20200922154424.GL22660@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-18-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200915112842.897265-18-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> Subject: Re: [PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver
			     ... x86/sgx: Add ptrace() support...

subject needs a verb.

On Tue, Sep 15, 2020 at 02:28:35PM +0300, Jarkko Sakkinen wrote:
> Add VMA callbacks for ptrace() that can be used with debug enclaves.
> With debug enclaves data can be read and write the memory word at a time

I think you wanna say here

"... data can be read and/or written a memory word at a time by using..."

> by using ENCLS(EDBGRD) and ENCLS(EDBGWR) leaf instructions.
> 
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 87 ++++++++++++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 11ec2df59b54..7f8df2c8ef35 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -333,10 +333,97 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma,
>  	return mprotect_fixup(vma, pprev, start, end, newflags);
>  }
>  
> +static int sgx_edbgrd(struct sgx_encl *encl, struct sgx_encl_page *page,
> +		      unsigned long addr, void *data)
> +{
> +	unsigned long offset = addr & ~PAGE_MASK;
> +	int ret;
> +
> +
> +	ret = __edbgrd(sgx_get_epc_addr(page->epc_page) + offset, data);
> +	if (ret)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int sgx_edbgwr(struct sgx_encl *encl, struct sgx_encl_page *page,
> +		      unsigned long addr, void *data)
> +{
> +	unsigned long offset = addr & ~PAGE_MASK;
> +	int ret;
> +
> +	ret = __edbgwr(sgx_get_epc_addr(page->epc_page) + offset, data);
> +	if (ret)
> +		return -EIO;
> +
> +	return 0;
> +}

I know those are supposed to correspond to the ENCLS leafs but the
function names are totally unreadable. I guess you could name them

sgx_encl_dbg_read
sgx_encl_dbg_write

and leave the lowlevel helpers like the insn names.

> +static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
> +			  void *buf, int len, int write)
> +{
> +	struct sgx_encl *encl = vma->vm_private_data;
> +	struct sgx_encl_page *entry = NULL;
> +	char data[sizeof(unsigned long)];
> +	unsigned long align;
> +	unsigned int flags;
> +	int offset;
> +	int cnt;
> +	int ret = 0;
> +	int i;
> +
> +	/* If process was forked, VMA is still there but vm_private_data is set
> +	 * to NULL.
> +	 */

Kernel comments style is:

	/*
	 * A sentence ending with a full-stop.
	 * Another sentence. ...
	 * More sentences. ...
	 */

> +	if (!encl)
> +		return -EFAULT;
> +
> +	flags = atomic_read(&encl->flags);
> +
> +	if (!(flags & SGX_ENCL_DEBUG) || !(flags & SGX_ENCL_INITIALIZED) ||
> +	    (flags & SGX_ENCL_DEAD))
> +		return -EFAULT;
> +
> +	for (i = 0; i < len; i += cnt) {
> +		entry = sgx_encl_reserve_page(encl, (addr + i) & PAGE_MASK);
> +		if (IS_ERR(entry)) {
> +			ret = PTR_ERR(entry);
> +			break;
> +		}
> +
> +		align = ALIGN_DOWN(addr + i, sizeof(unsigned long));
> +		offset = (addr + i) & (sizeof(unsigned long) - 1);
> +		cnt = sizeof(unsigned long) - offset;
> +		cnt = min(cnt, len - i);
> +
> +		ret = sgx_edbgrd(encl, entry, align, data);
> +		if (ret)
> +			goto out;
> +
> +		if (write) {
> +			memcpy(data + offset, buf + i, cnt);
> +			ret = sgx_edbgwr(encl, entry, align, data);
> +			if (ret)
> +				goto out;
> +		} else

		} else {

> +			memcpy(buf + i, data + offset, cnt);

		}

Put the else branch in {} too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
