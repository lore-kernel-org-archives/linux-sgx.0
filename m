Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE341C43463
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 12:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85D0420739
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 12:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgIUMa6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 08:30:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:41366 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIUMa6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 08:30:58 -0400
IronPort-SDR: /+MrVm/4+jCAslV3p6f8KtAdT731YblHCCeHM3eXVUz4zgaBXlABgsjuiW7TBXcGP0CCOdaYv4
 XTfuRsHR3e6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9750"; a="139861733"
X-IronPort-AV: E=Sophos;i="5.77,286,1596524400"; 
   d="scan'208";a="139861733"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 05:28:33 -0700
IronPort-SDR: uuvW00qyo7NJoJvm1ajmNpK1USV0vARV+F/Rif7giE1iBFv73ds22JNjbzJYKfh86utnfC6OIG
 ucwlxwAaqJxQ==
X-IronPort-AV: E=Sophos;i="5.77,286,1596524400"; 
   d="scan'208";a="454024277"
Received: from clairemo-mobl.ger.corp.intel.com (HELO localhost) ([10.252.43.50])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 05:28:25 -0700
Date:   Mon, 21 Sep 2020 15:28:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
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
Subject: Re: [PATCH v38 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20200921122823.GE6038@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-13-jarkko.sakkinen@linux.intel.com>
 <20200921100356.GB5901@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921100356.GB5901@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 12:03:56PM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 02:28:30PM +0300, Jarkko Sakkinen wrote:
> > +static int sgx_validate_secs(const struct sgx_secs *secs)
> > +{
> > +	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
> > +		       sgx_encl_size_max_64 : sgx_encl_size_max_32;
> > +
> > +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> > +		return -EINVAL;
> > +
> > +	if (secs->base & (secs->size - 1))
> > +		return -EINVAL;
> > +
> > +	if (secs->miscselect & sgx_misc_reserved_mask ||
> > +	    secs->attributes & sgx_attributes_reserved_mask ||
> > +	    secs->xfrm & sgx_xfrm_reserved_mask)
> > +		return -EINVAL;
> > +
> > +	if (secs->size > max_size)
> > +		return -EINVAL;
> > +
> > +	if (!(secs->xfrm & XFEATURE_MASK_FP) ||
> > +	    !(secs->xfrm & XFEATURE_MASK_SSE) ||
> > +	    (((secs->xfrm >> XFEATURE_BNDREGS) & 1) !=
> > +	     ((secs->xfrm >> XFEATURE_BNDCSR) & 1)))
> 
> Let that last line stick out so that you have each statement on a single line.
> 
> > +		return -EINVAL;
> > +
> > +	if (!secs->ssa_frame_size)
> > +		return -EINVAL;
> > +
> > +	if (sgx_calc_ssa_frame_size(secs->miscselect, secs->xfrm) >
> > +	    secs->ssa_frame_size)
> 
> Let that stick out.
> 
> > +		return -EINVAL;
> > +
> > +	if (memchr_inv(secs->reserved1, 0, sizeof(secs->reserved1)) ||
> > +	    memchr_inv(secs->reserved2, 0, sizeof(secs->reserved2)) ||
> > +	    memchr_inv(secs->reserved3, 0, sizeof(secs->reserved3)) ||
> > +	    memchr_inv(secs->reserved4, 0, sizeof(secs->reserved4)))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> > +{
> > +	unsigned long encl_size = secs->size + PAGE_SIZE;
> 
> You're still using secs->size before validation. I know, we will return
> early if sgx_validate_secs() fails but pls move that addition after the
> validation call.

Is this appropriate:

	/* The extra page in swap space goes to SECS. */
	encl_size = secs->size + PAGE_SIZE;

	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
				   VM_NORESERVE);
	if (IS_ERR(backing)) {
		ret = PTR_ERR(backing);
		goto err_out_shrink;
	}

> ...
> 
> > +/**
> > + * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
> > + * @filep:	open file to /dev/sgx
> 
> Dammit, how many times do I have to type this comment here?!
> 
> "That's
> 
> @encl: enclave pointer
> 
> or so."
> 
> There's no filep - there is an encl!

I'm not actually sure what has happened. As you can easily grep, the
rename is done in five other sites. I also see a similar problem in
EINIT, which I will fix.

git grep "enclave pointer" arch/x86/kernel/cpu/sgx/ | wc -l
5

> > + * @arg:	userspace pointer to a struct sgx_enclave_create instance
> > + *
> > + * Allocate kernel data structures for a new enclave and execute ECREATE after
> > + * verifying the correctness of the provided SECS.
> 
> ... which is done in sgx_validate_secs()."
> 
> Yes, spell it out, otherwise one has to wonder where that validation is
> happening in the function *below* because the comment is over it - not
> over sgx_validate_secs().
> 
> And yes, you need to spell stuff like that out because this SGX crap is
> complex and it better be properly documented!

I agree with this but I also think it would make sense to rephrase
"verifying the correctness of the provided SECS" with something more
informative.

I would rephrase as:

"... after checking that the provided data for SECS meets the expectations
of ENCLS[ECREATE] for an unitialized enclave and size of the address
space does not surpass the platform expectations. This validation is
executed by sgx_validate_secs()."

Is this sufficient for you, or do you have further suggestions?

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
