Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DF5C433DF
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB05A206E6
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgGGD3R (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Jul 2020 23:29:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:28189 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgGGD3R (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Jul 2020 23:29:17 -0400
IronPort-SDR: 0GZfAX8HVhKhKxdKV/6z6oq7vv8llFbutaA351CkJrKiOxxaywI1XKXYnF81iTcc8l/5DeEEPa
 iuVTdwclc09A==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="146608350"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="146608350"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 20:29:16 -0700
IronPort-SDR: H8KT56GEXLD5pKzEdF6wMA2uyeJxhHusaHKn0kLUP8xcVC8nM1ige2zJ9snTIMuNmdR/JYNFJB
 66gwjOawDvoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="305509109"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jul 2020 20:29:15 -0700
Date:   Mon, 6 Jul 2020 20:29:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v34 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20200707032915.GC5208@linux.intel.com>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-13-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707030204.126021-13-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 07, 2020 at 06:01:52AM +0300, Jarkko Sakkinen wrote:
> +long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> +{
> +	struct sgx_encl *encl = filep->private_data;
> +	int ret, encl_flags;
> +
> +	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
> +	if (encl_flags & SGX_ENCL_IOCTL)
> +		return -EBUSY;

As called out in my belated feedback, SGX_ENCL_DEAD needs to be checked
here to prevent invoking ENCLS operations on a dead enclave.  If you're
splitting hairs, the check could technically be deferred until the next
patch, "Add SGX_IOC_ENCLAVE_ADD_PAGES", which is the first usage of
sgx_encl_destroy() from an ioctl(), but that seems a bit gratuitous.

> +
> +	switch (cmd) {
> +	case SGX_IOC_ENCLAVE_CREATE:
> +		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
> +		break;
> +	default:
> +		ret = -ENOIOCTLCMD;
> +		break;
> +	}
> +
> +	atomic_andnot(SGX_ENCL_IOCTL, &encl->flags);
> +	return ret;
> +}
> -- 
> 2.25.1
> 
