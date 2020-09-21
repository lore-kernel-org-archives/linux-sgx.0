Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A5BC4347E
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 17:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432EA20C09
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 17:35:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="pXrW8SG9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgIURfR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 13:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIURfR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 21 Sep 2020 13:35:17 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858F9C061755;
        Mon, 21 Sep 2020 10:35:17 -0700 (PDT)
Received: from zn.tnic (p200300ec2f07e300fdce2fa8e8fa3e27.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:e300:fdce:2fa8:e8fa:3e27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 54B291EC03C9;
        Mon, 21 Sep 2020 19:35:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600709716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7ORCFbqkiADo7YFY8rmEqS924FVCV+kqi+Mr4lMH92w=;
        b=pXrW8SG93VVXOthwqE+A/3j3p0cGHPg8lUYkHd6TlFSze13p079hi3co0Akh8UpRtY9hQf
        x4j9FNP1LuNab6B9+w4zCfBrjpCn6Y8fXQKKKUxBTPNb2KmPbcM6/vMCdxVvMZHeZwuWps
        SJ6J46u6DFGJhWnDTwig8lnktrKU94k=
Date:   Mon, 21 Sep 2020 19:35:14 +0200
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
Subject: Re: [PATCH v38 14/24] x86/sgx: Add SGX_IOC_ENCLAVE_INIT
Message-ID: <20200921173514.GI5901@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 02:28:32PM +0300, Jarkko Sakkinen wrote:
> +static int sgx_einit(struct sgx_sigstruct *sigstruct, void *token,
> +		     struct sgx_epc_page *secs, u64 *lepubkeyhash)
> +{
> +	int ret;
> +
> +	preempt_disable();
> +	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);

So this will update the cached copies *and* the MSRs itself if what's
cached is stale...

> +	ret = __einit(sigstruct, token, sgx_get_epc_addr(secs));
> +	if (ret == SGX_INVALID_EINITTOKEN) {

... so why would it return this error here?

Definition of this error says:

 * %SGX_INVALID_EINITTOKEN:     EINITTOKEN is invalid and enclave signer's
 *                              public key does not match IA32_SGXLEPUBKEYHASH.

when you just updated them?!

> +		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);

So why force a second time?

> +		ret = __einit(sigstruct, token, sgx_get_epc_addr(secs));
> +	}
> +	preempt_enable();
> +	return ret;
> +}
> +
> +static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
> +			 void *token)
> +{
> +	u64 mrsigner[4];
> +	int ret;
> +	int i;
> +	int j;
> +
> +	/* Deny initializing enclaves with attributes (namely provisioning)
> +	 * that have not been explicitly allowed.
> +	 */

Comments style is with the first line empty:

	/*
	 * A sentence ending with a full-stop.
	 * Another sentence. ...
	 * More sentences. ...
	 */

> +	if (encl->attributes & ~encl->attributes_mask)
> +		return -EACCES;
> +
> +	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&encl->lock);
> +
> +	/*
> +	 * ENCLS[EINIT] is interruptible because it has such a high latency,
> +	 * e.g. 50k+ cycles on success. If an IRQ/NMI/SMI becomes pending,
> +	 * EINIT may fail with SGX_UNMASKED_EVENT so that the event can be
> +	 * serviced.
> +	 */
> +	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
> +		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
> +			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
> +					mrsigner);
> +			if (ret == SGX_UNMASKED_EVENT)
> +				continue;
> +			else
> +				break;
> +		}
> +
> +		if (ret != SGX_UNMASKED_EVENT)
> +			break;
> +
> +		msleep_interruptible(SGX_EINIT_SLEEP_TIME);
> +
> +		if (signal_pending(current)) {
> +			ret = -ERESTARTSYS;
> +			goto err_out;
> +		}
> +	}
> +
> +	if (ret & ENCLS_FAULT_FLAG) {
> +		if (encls_failed(ret))
> +			ENCLS_WARN(ret, "EINIT");
> +
> +		sgx_encl_destroy(encl);
> +		ret = -EFAULT;
> +	} else if (ret) {
> +		pr_debug("EINIT returned %d\n", ret);
> +		ret = -EPERM;
> +	} else {
> +		atomic_or(SGX_ENCL_INITIALIZED, &encl->flags);
> +	}
> +
> +err_out:
> +	mutex_unlock(&encl->lock);
> +	return ret;
> +}
> +
> +/**
> + * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
> + *
> + * @filep:	open file to /dev/sgx

Aaand again:

"@encl:       pointer to an enclave instance (via ioctl() file pointer)"

this is also from a previous review.

> + * @arg:	userspace pointer to a struct sgx_enclave_init instance
> + *
> + * Flush any outstanding enqueued EADD operations and perform EINIT.  The
> + * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
> + * the enclave's MRSIGNER, which is caculated from the provided sigstruct.
> + *
> + * Return:
> + *   0 on success,
> + *   SGX error code on EINIT failure,
> + *   -errno otherwise
> + */
> +static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> +{

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
