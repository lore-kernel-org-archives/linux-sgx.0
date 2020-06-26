Return-Path: <SRS0=bCPb=AH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A51C433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 14:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96278208C9
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 14:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgFZOQ3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 26 Jun 2020 10:16:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:14483 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgFZOQ3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 26 Jun 2020 10:16:29 -0400
IronPort-SDR: YRwsVwL0ruWTPZ6elDOP23iJzdXR84/WRXhorMZ5nRrQvn+aj+lgn8HIgXq6oVifw8Yj1+c+tN
 n2HHCMWbdgOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="230107487"
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="230107487"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 07:16:27 -0700
IronPort-SDR: M/vl6mS8rTsyZgRPKK3iGcThRIh0acsLSNoZJDRQefHw7EwhRQsy8xXji0oCS3FQvh5duKTBFP
 o5xut424moSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="294209872"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 26 Jun 2020 07:16:27 -0700
Date:   Fri, 26 Jun 2020 07:16:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
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
Message-ID: <20200626141627.GA6583@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200626091419.GB27151@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626091419.GB27151@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 26, 2020 at 11:14:19AM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> > +static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> > +{
> > +	unsigned long encl_size = secs->size + PAGE_SIZE;
> 
> Wait, you just copied @secs from user memory in sgx_ioc_enclave_create()
> and now use ->size unverified? You're kidding, right?

The size of the enclave is checked in sgx_validate_secs() before it is used
to configure the shmem backing.
 
> > +	struct sgx_epc_page *secs_epc;
> > +	unsigned long ssaframesize;
> > +	struct sgx_pageinfo pginfo;
> > +	struct sgx_secinfo secinfo;
> > +	struct file *backing;
> > +	long ret;
> > +
> > +	if (atomic_read(&encl->flags) & SGX_ENCL_CREATED)
> > +		return -EINVAL;
> > +
> > +	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);
> 
> So this is using more un-validated user input to do further calculations.
> What can possibly go wrong?

ssaframesize is also validated below, and the computations on miscselect and
xfm in sgx_calc_ssaframesize() are bounded such that bad input won't send
the kernel into the weeds.

That being said, I agree that it would be safer to move sgx_calc_ssaframesize()
inside sgx_validate_secs() and only compute encl_size after the secs is
validated.

> I sure hope *I* am wrong and am missing something here.
> 
> If not, please, for the next version, audit all your user input and
> validate it before using it. Srsly.
> 
> > +	if (sgx_validate_secs(secs, ssaframesize)) {
> > +		pr_debug("invalid SECS\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
> > +				   VM_NORESERVE);
> > +	if (IS_ERR(backing))
> > +		return PTR_ERR(backing);
> > +
> > +	encl->backing = backing;
> > +
> > +	secs_epc = __sgx_alloc_epc_page();
> > +	if (IS_ERR(secs_epc)) {
> > +		ret = PTR_ERR(secs_epc);
> > +		goto err_out_backing;
> > +	}
> > +
> > +	encl->secs.epc_page = secs_epc;
> > +
> > +	pginfo.addr = 0;
> > +	pginfo.contents = (unsigned long)secs;
> > +	pginfo.metadata = (unsigned long)&secinfo;
> > +	pginfo.secs = 0;
> > +	memset(&secinfo, 0, sizeof(secinfo));
> > +
> > +	ret = __ecreate((void *)&pginfo, sgx_get_epc_addr(secs_epc));
> > +	if (ret) {
> > +		pr_debug("ECREATE returned %ld\n", ret);
> > +		goto err_out;
> > +	}
> > +
> > +	if (secs->attributes & SGX_ATTR_DEBUG)
> > +		atomic_or(SGX_ENCL_DEBUG, &encl->flags);
> > +
> > +	encl->secs.encl = encl;
> > +	encl->secs_attributes = secs->attributes;
> > +	encl->allowed_attributes |= SGX_ATTR_ALLOWED_MASK;
> > +	encl->base = secs->base;
> > +	encl->size = secs->size;
> > +	encl->ssaframesize = secs->ssa_frame_size;
> > +
> > +	/*
> > +	 * Set SGX_ENCL_CREATED only after the enclave is fully prepped.  This
> > +	 * allows setting and checking enclave creation without having to take
> > +	 * encl->lock.
> > +	 */
> > +	atomic_or(SGX_ENCL_CREATED, &encl->flags);
> > +
> > +	return 0;
> > +
> > +err_out:
> > +	sgx_free_epc_page(encl->secs.epc_page);
> > +	encl->secs.epc_page = NULL;
> > +
> > +err_out_backing:
> > +	fput(encl->backing);
> > +	encl->backing = NULL;
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
> > + * @filep:	open file to /dev/sgx
> 
> That's
> 
> @encl: enclave pointer
> 
> or so.
> 
> > + * @arg:	userspace pointer to a struct sgx_enclave_create instance
> > + *
> > + * Allocate kernel data structures for a new enclave and execute ECREATE after
> > + * verifying the correctness of the provided SECS.
> > + *
> > + * Note, enforcement of restricted and disallowed attributes is deferred until
> > + * sgx_ioc_enclave_init(), only the architectural correctness of the SECS is
> > + * checked by sgx_ioc_enclave_create().
> 
> Well, I don't see that checking. Where is it?
> 
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   -errno otherwise
> > + */
> > +static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
> > +{
> > +	struct sgx_enclave_create ecreate;
> > +	struct page *secs_page;
> > +	struct sgx_secs *secs;
> > +	int ret;
> > +
> > +	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
> > +		return -EFAULT;
> > +
> > +	secs_page = alloc_page(GFP_KERNEL);
> > +	if (!secs_page)
> > +		return -ENOMEM;
> > +
> > +	secs = kmap(secs_page);
> > +	if (copy_from_user(secs, (void __user *)ecreate.src, sizeof(*secs))) {
> > +		ret = -EFAULT;
> > +		goto out;
> > +	}
> > +
> > +	ret = sgx_encl_create(encl, secs);
> > +
> > +out:
> > +	kunmap(secs_page);
> > +	__free_page(secs_page);
> > +	return ret;
> > +}
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
