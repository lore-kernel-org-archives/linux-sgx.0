Return-Path: <SRS0=F+z5=DI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9A1C4741F
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 17:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 273CB20872
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 17:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbgJARRF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Oct 2020 13:17:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:62435 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732096AbgJARRF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Oct 2020 13:17:05 -0400
IronPort-SDR: 3U9/b3DvuAGqiaQMQMk9u7v+y2W9Og0vQzkAkWCI+erwzE5b6kPkbBqp2njil281XjRfhq5Ddc
 emQyp91yVevA==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="180940018"
X-IronPort-AV: E=Sophos;i="5.77,324,1596524400"; 
   d="scan'208";a="180940018"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 10:17:03 -0700
IronPort-SDR: Qy9H7dXPMlyX8yx4rYKPmXJHd5qx2SPvXIFOuT2LtXocqtLi77HqI0gWkomHGvMFJhLIJaSdXP
 mu0UKvndlfqw==
X-IronPort-AV: E=Sophos;i="5.77,324,1596524400"; 
   d="scan'208";a="346154578"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 10:17:02 -0700
Date:   Thu, 1 Oct 2020 10:17:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 15/24] x86/sgx: Enable provisioning for remote
 attestation
Message-ID: <20201001171701.GF7474@linux.intel.com>
References: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
 <20200915110522.893152-16-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915110522.893152-16-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 02:05:13PM +0300, Jarkko Sakkinen wrote:
> +/**
> + * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_PROVISION
> + * @filep:	open file to /dev/sgx
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
> +{
> +	struct sgx_enclave_provision params;
> +	struct file *attribute_file;
> +	int ret;
> +
> +	if (copy_from_user(&params, arg, sizeof(params)))
> +		return -EFAULT;
> +
> +	attribute_file = fget(params.attribute_fd);
> +	if (!attribute_file)
> +		return -EINVAL;
> +
> +	if (attribute_file->f_op != &sgx_provision_fops) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	encl->attributes |= SGX_ATTR_PROVISIONKEY;

This is wrong, it needs to be

	encl->attributes_mask |= SGX_ATTR_PROVISION;

else sgx_encl_init() will fail this check

	if (encl->attributes & ~encl->attributes_mask)
		return -EACCES;

This obviously needs a selftest...

> +	ret = 0;
> +
> +out:
> +	fput(attribute_file);
> +	return ret;
> +}
