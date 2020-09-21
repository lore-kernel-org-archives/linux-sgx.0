Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69558C4363A
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 18:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7D520888
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 18:07:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="eoxk8SCF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgIUSHf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 14:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgIUSHf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 21 Sep 2020 14:07:35 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A4CC061755;
        Mon, 21 Sep 2020 11:07:35 -0700 (PDT)
Received: from zn.tnic (p200300ec2f07e300fdce2fa8e8fa3e27.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:e300:fdce:2fa8:e8fa:3e27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 351A11EC0281;
        Mon, 21 Sep 2020 20:07:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600711653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=wahZCqLRHJ6s4gwTioPt1wQsyT0dIRsptngyIn/tpk8=;
        b=eoxk8SCFiSF0PVOxe4Kep/f7Zv7V4qI6hJkoqIw1+iKcnx/6Q4qDUCgdhR1U1x5VZOprF5
        2syiaYZ0QLo/GkwRweS/1UEQD2n2u/EUoFynlz7J8Kb46ckMlMhKGrNAzvrkfWVO23sday
        86VJIaDzBvJHfvIzYM3WkoHJ0MNaukQ=
Date:   Mon, 21 Sep 2020 20:07:28 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v38 15/24] x86/sgx: Enable provisioning for remote
 attestation
Message-ID: <20200921180728.GJ5901@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-16-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200915112842.897265-16-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 02:28:33PM +0300, Jarkko Sakkinen wrote:
> @@ -181,5 +192,12 @@ int __init sgx_drv_init(void)
>  		return ret;
>  	}
>  
> +	ret = misc_register(&sgx_dev_provision);
> +	if (ret) {
> +		pr_err("Creating /dev/sgx/provision failed with %d.\n", ret);
> +		misc_deregister(&sgx_dev_enclave);

The comment over misc_deregister() says:

 *      Unregister a miscellaneous device that was previously
 *      successfully registered with misc_register().

but this is not a successful registration here, in the if (ret) case...

> +		return ret;
> +	}
> +
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
> index e4063923115b..72747d01c046 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.h
> +++ b/arch/x86/kernel/cpu/sgx/driver.h
> @@ -23,6 +23,8 @@ extern u64 sgx_attributes_reserved_mask;
>  extern u64 sgx_xfrm_reserved_mask;
>  extern u32 sgx_xsave_size_tbl[64];
>  
> +extern const struct file_operations sgx_provision_fops;
> +
>  long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
>  
>  int sgx_drv_init(void);
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index de2ed4f35ffb..4227bca7b477 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -673,6 +673,50 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
>  	return ret;
>  }
>  
> +/**
> + * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_PROVISION
> + * @filep:	open file to /dev/sgx
       ^^^^^^

Can you guess what my comment to that would be...?

> + * @arg:	userspace pointer to a struct sgx_enclave_provision instance
> + *
> + * Mark the enclave as being allowed to access a restricted attribute bit.
> + * The requested attribute is specified via the attribute_fd field in the
> + * provided struct sgx_enclave_provision.  The attribute_fd must be a
> + * handle to an SGX attribute file, e.g. "/dev/sgx/provision".
> + *
> + * Failure to explicitly request access to a restricted attribute will cause
> + * sgx_ioc_enclave_init() to fail.  Currently, the only restricted attribute
> + * is access to the PROVISION_KEY.
> + *
> + * Note, access to the EINITTOKEN_KEY is disallowed entirely.
> + *
> + * Return: 0 on success, -errno otherwise
> + */
> +static long sgx_ioc_enclave_provision(struct sgx_encl *encl,
> +					  void __user *arg)

No need for the line break: both function args can fit on the same line.

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
