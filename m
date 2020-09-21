Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D3AC43464
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 10:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADAFE221E2
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 10:04:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="C4UNaCAz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgIUKEJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 06:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgIUKEI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 21 Sep 2020 06:04:08 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6998DC061755
        for <linux-sgx@vger.kernel.org>; Mon, 21 Sep 2020 03:04:08 -0700 (PDT)
Received: from zn.tnic (p200300ec2f07e300a1766583a478f392.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:e300:a176:6583:a478:f392])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A330E1EC0323;
        Mon, 21 Sep 2020 12:04:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600682644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=1udGxMkFjeOfV8BEY6v5FP5Ybt85foi64B2PPrPSWuY=;
        b=C4UNaCAzsbKRZHDs/6SGErP8jpwET5CPKcp2z8WviAVsvwsAmOKv+llVqIWaLPSsIIiyml
        hl81akJ+0zpRqT4AO7VPJVCCF9/zbVu840ejXPuK502FGaV2LNVIFV4lXQ06SjKKRvc13g
        5Kp7LSnXpmobWWEsa5olMKCUNn5YNlk=
Date:   Mon, 21 Sep 2020 12:03:56 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20200921100356.GB5901@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-13-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200915112842.897265-13-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 02:28:30PM +0300, Jarkko Sakkinen wrote:
> +static int sgx_validate_secs(const struct sgx_secs *secs)
> +{
> +	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
> +		       sgx_encl_size_max_64 : sgx_encl_size_max_32;
> +
> +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> +		return -EINVAL;
> +
> +	if (secs->base & (secs->size - 1))
> +		return -EINVAL;
> +
> +	if (secs->miscselect & sgx_misc_reserved_mask ||
> +	    secs->attributes & sgx_attributes_reserved_mask ||
> +	    secs->xfrm & sgx_xfrm_reserved_mask)
> +		return -EINVAL;
> +
> +	if (secs->size > max_size)
> +		return -EINVAL;
> +
> +	if (!(secs->xfrm & XFEATURE_MASK_FP) ||
> +	    !(secs->xfrm & XFEATURE_MASK_SSE) ||
> +	    (((secs->xfrm >> XFEATURE_BNDREGS) & 1) !=
> +	     ((secs->xfrm >> XFEATURE_BNDCSR) & 1)))

Let that last line stick out so that you have each statement on a single line.

> +		return -EINVAL;
> +
> +	if (!secs->ssa_frame_size)
> +		return -EINVAL;
> +
> +	if (sgx_calc_ssa_frame_size(secs->miscselect, secs->xfrm) >
> +	    secs->ssa_frame_size)

Let that stick out.

> +		return -EINVAL;
> +
> +	if (memchr_inv(secs->reserved1, 0, sizeof(secs->reserved1)) ||
> +	    memchr_inv(secs->reserved2, 0, sizeof(secs->reserved2)) ||
> +	    memchr_inv(secs->reserved3, 0, sizeof(secs->reserved3)) ||
> +	    memchr_inv(secs->reserved4, 0, sizeof(secs->reserved4)))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> +{
> +	unsigned long encl_size = secs->size + PAGE_SIZE;

You're still using secs->size before validation. I know, we will return
early if sgx_validate_secs() fails but pls move that addition after the
validation call.

...

> +/**
> + * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
> + * @filep:	open file to /dev/sgx

Dammit, how many times do I have to type this comment here?!

"That's

@encl: enclave pointer

or so."

There's no filep - there is an encl!


> + * @arg:	userspace pointer to a struct sgx_enclave_create instance
> + *
> + * Allocate kernel data structures for a new enclave and execute ECREATE after
> + * verifying the correctness of the provided SECS.

... which is done in sgx_validate_secs()."

Yes, spell it out, otherwise one has to wonder where that validation is
happening in the function *below* because the comment is over it - not
over sgx_validate_secs().

And yes, you need to spell stuff like that out because this SGX crap is
complex and it better be properly documented!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
