Return-Path: <SRS0=uCKf=ZU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A78C432C3
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Nov 2019 18:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0103217BA
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Nov 2019 18:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574965494;
	bh=mMXc779SXeCQxnAgqrWY8WGkspesVFib9Q6I1MXzP/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=g4ZDjKLqFzO+BQIomfGrc1WRmtNtXmW1vAe4fDqEY5IU3kkfiXRunM3QsATDDRsJO
	 93omoieQ9RSAV+rDdh5/d2DV1hrB+olmv3TQ2AgWSxTdzhCuh+ax4p8vuEUKCeALqN
	 77GACrQxaNY/Cd0MNS9gNYTdId9Q4kUZpRetmHPg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfK1SYy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Nov 2019 13:24:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfK1SYy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 Nov 2019 13:24:54 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6F7521775;
        Thu, 28 Nov 2019 18:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574965492;
        bh=mMXc779SXeCQxnAgqrWY8WGkspesVFib9Q6I1MXzP/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Te/vPvcm6LPF/MJkwAUZuqL4Y/6nRQC1uGtL8nGJCJWq475Gjta4WmfGFImY/WEx5
         flFT3V3/PnWOi0rSsLIext9zrrEmBM8JC6yIKo8CQ4PeyrZOEQC75i1vmzxB+shUJQ
         4NM7WrQMn4lpF4Ai+K5rPenkl0GT12awRLhkfYSw=
Date:   Thu, 28 Nov 2019 19:24:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191128182450.GA3493127@kroah.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 28, 2019 at 11:03:12PM +0200, Jarkko Sakkinen wrote:
> +static struct device sgx_encl_dev;

Ugh, really?  After 23 versions of this patchset no one saw this?

> +static struct cdev sgx_encl_cdev;
> +static dev_t sgx_devt;
> +
> +static void sgx_dev_release(struct device *dev)
> +{
> +}

The old kernel documentation used to say I was allowed to make fun of
people who did this, but that was removed as it really wasn't that nice.

But I'm seriously reconsidering that at the moment.

No, this is NOT OK!

Think about what you are doing here, and why you feel that it is ok to
work around a kernel message that was added there explicitly to help you
do things the right way.  I didn't add it just because I felt like it, I
was trying to give you a chance to not get the use of this api
incorrect.

That failed :(

Ugh, not ok.  Seriously, not ok...

> +static __init int sgx_dev_init(const char *name, struct device *dev,
> +			       struct cdev *cdev,
> +			       const struct file_operations *fops, int minor)
> +{
> +	int ret;
> +
> +	device_initialize(dev);

Why do you even need a struct device in the first place?

> +
> +	dev->bus = &sgx_bus_type;
> +	dev->devt = MKDEV(MAJOR(sgx_devt), minor);
> +	dev->release = sgx_dev_release;
> +
> +	ret = dev_set_name(dev, name);
> +	if (ret) {
> +		put_device(dev);
> +		return ret;
> +	}
> +
> +	cdev_init(cdev, fops);

Why a whole cdev?

Why not use a misc device?  YOu only have 2 devices right?  Why not 2
misc devices then?  That saves the use of a whole major number and makes
your code a _LOT_ simpler.

> +	ret = bus_register(&sgx_bus_type);

I'm afraid to look at this bus code.

Instead I'm going to ask, why do you need a bus at all?  What drivers do
you have for this bus?

ugh I don't know why I looked at this code, but it's not ok as-is and
anyone who reviewed the driver model interaction needs to rethink
things...

greg k-h
