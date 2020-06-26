Return-Path: <SRS0=bCPb=AH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1C7C433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 09:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49AD20675
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 09:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="iuZIDL/4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgFZJO1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 26 Jun 2020 05:14:27 -0400
Received: from mail.skyhub.de ([5.9.137.197]:44528 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgFZJO1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 26 Jun 2020 05:14:27 -0400
Received: from zn.tnic (p200300ec2f0d14002d5f36c4e9373ada.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1400:2d5f:36c4:e937:3ada])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 49A211EC037C;
        Fri, 26 Jun 2020 11:14:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593162865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=QqkODfEAET3aFljfnSs28wqN/EdGoMwTbRGyQvGA1RQ=;
        b=iuZIDL/4plAlI8etKmVUTIGhM94uPDMKqyfSxiGNmpiCgccGZBpqUxNdAe8yu/MGUpRT09
        BDFyOKX+FkZKU5auGi0IWVe+t5lI4C9b2PG0o1c0ZZmYhOHf/h4jsFjzCQmx30qyU1JujY
        wnbB7+jUHmBRyXTWy71ZLTqHVnC7MuI=
Date:   Fri, 26 Jun 2020 11:14:19 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200626091419.GB27151@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 59472cd6a11d..35f713e3a267 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -323,6 +323,7 @@ Code  Seq#    Include File                                           Comments
>                                                                       <mailto:tlewis@mindspring.com>
>  0xA3  90-9F  linux/dtlk.h
>  0xA4  00-1F  uapi/linux/tee.h                                        Generic TEE subsystem
> +0xA4  00-1F  uapi/asm/sgx.h                                          Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)

Maybe add <mailto:linux-sgx@vger.kernel.org> ?

>  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>  0xAB  00-1F  linux/nbd.h
>  0xAC  00-1F  linux/raw.h

...

> +static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> +{
> +	unsigned long encl_size = secs->size + PAGE_SIZE;

Wait, you just copied @secs from user memory in sgx_ioc_enclave_create()
and now use ->size unverified? You're kidding, right?

> +	struct sgx_epc_page *secs_epc;
> +	unsigned long ssaframesize;
> +	struct sgx_pageinfo pginfo;
> +	struct sgx_secinfo secinfo;
> +	struct file *backing;
> +	long ret;
> +
> +	if (atomic_read(&encl->flags) & SGX_ENCL_CREATED)
> +		return -EINVAL;
> +
> +	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);

So this is using more un-validated user input to do further calculations.
What can possibly go wrong?

I sure hope *I* am wrong and am missing something here.

If not, please, for the next version, audit all your user input and
validate it before using it. Srsly.

> +	if (sgx_validate_secs(secs, ssaframesize)) {
> +		pr_debug("invalid SECS\n");
> +		return -EINVAL;
> +	}
> +
> +	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
> +				   VM_NORESERVE);
> +	if (IS_ERR(backing))
> +		return PTR_ERR(backing);
> +
> +	encl->backing = backing;
> +
> +	secs_epc = __sgx_alloc_epc_page();
> +	if (IS_ERR(secs_epc)) {
> +		ret = PTR_ERR(secs_epc);
> +		goto err_out_backing;
> +	}
> +
> +	encl->secs.epc_page = secs_epc;
> +
> +	pginfo.addr = 0;
> +	pginfo.contents = (unsigned long)secs;
> +	pginfo.metadata = (unsigned long)&secinfo;
> +	pginfo.secs = 0;
> +	memset(&secinfo, 0, sizeof(secinfo));
> +
> +	ret = __ecreate((void *)&pginfo, sgx_get_epc_addr(secs_epc));
> +	if (ret) {
> +		pr_debug("ECREATE returned %ld\n", ret);
> +		goto err_out;
> +	}
> +
> +	if (secs->attributes & SGX_ATTR_DEBUG)
> +		atomic_or(SGX_ENCL_DEBUG, &encl->flags);
> +
> +	encl->secs.encl = encl;
> +	encl->secs_attributes = secs->attributes;
> +	encl->allowed_attributes |= SGX_ATTR_ALLOWED_MASK;
> +	encl->base = secs->base;
> +	encl->size = secs->size;
> +	encl->ssaframesize = secs->ssa_frame_size;
> +
> +	/*
> +	 * Set SGX_ENCL_CREATED only after the enclave is fully prepped.  This
> +	 * allows setting and checking enclave creation without having to take
> +	 * encl->lock.
> +	 */
> +	atomic_or(SGX_ENCL_CREATED, &encl->flags);
> +
> +	return 0;
> +
> +err_out:
> +	sgx_free_epc_page(encl->secs.epc_page);
> +	encl->secs.epc_page = NULL;
> +
> +err_out_backing:
> +	fput(encl->backing);
> +	encl->backing = NULL;
> +
> +	return ret;
> +}
> +
> +/**
> + * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
> + * @filep:	open file to /dev/sgx

That's

@encl: enclave pointer

or so.

> + * @arg:	userspace pointer to a struct sgx_enclave_create instance
> + *
> + * Allocate kernel data structures for a new enclave and execute ECREATE after
> + * verifying the correctness of the provided SECS.
> + *
> + * Note, enforcement of restricted and disallowed attributes is deferred until
> + * sgx_ioc_enclave_init(), only the architectural correctness of the SECS is
> + * checked by sgx_ioc_enclave_create().

Well, I don't see that checking. Where is it?

> + *
> + * Return:
> + *   0 on success,
> + *   -errno otherwise
> + */
> +static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
> +{
> +	struct sgx_enclave_create ecreate;
> +	struct page *secs_page;
> +	struct sgx_secs *secs;
> +	int ret;
> +
> +	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
> +		return -EFAULT;
> +
> +	secs_page = alloc_page(GFP_KERNEL);
> +	if (!secs_page)
> +		return -ENOMEM;
> +
> +	secs = kmap(secs_page);
> +	if (copy_from_user(secs, (void __user *)ecreate.src, sizeof(*secs))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret = sgx_encl_create(encl, secs);
> +
> +out:
> +	kunmap(secs_page);
> +	__free_page(secs_page);
> +	return ret;
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
