Return-Path: <SRS0=hsGO=7D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0446CC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 21 May 2020 19:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB56B20738
	for <linux-sgx@archiver.kernel.org>; Thu, 21 May 2020 19:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgEUTMn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 May 2020 15:12:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:54393 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbgEUTMn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 May 2020 15:12:43 -0400
IronPort-SDR: WUGujn535E645ts12xvcEdV4hSqc+xtcb7TzyVFlLlsMCJwuC2K/Mj5UQLuw7GvC06tDj8g6RZ
 PvAMdp6BJi2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 12:12:37 -0700
IronPort-SDR: k/gY0kMbbAgEsAcR2SVVvwo0+gbzdvmVDEPkiFO+SzsNMG8QVCti7p6M4jGEEQfa4CY2hW8/rD
 I5GaEw5gzZ0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,418,1583222400"; 
   d="scan'208";a="466911464"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 21 May 2020 12:12:36 -0700
Date:   Thu, 21 May 2020 12:12:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Seth Moore <sethmo@google.com>
Subject: Re: [PATCH v30 10/20] x86/sgx: Linux Enclave Driver
Message-ID: <20200521191236.GA23043@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-11-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515004410.723949-11-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 15, 2020 at 03:44:00AM +0300, Jarkko Sakkinen wrote:
> +long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> +{
> +	struct sgx_encl *encl = filep->private_data;
> +	int ret, encl_flags;
> +
> +	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
> +	if (encl_flags & SGX_ENCL_IOCTL)
> +		return -EBUSY;
> +
> +	if (encl_flags & SGX_ENCL_DEAD)
> +		return -EFAULT;

Returning immediately is wrong as it leaves SGX_ENCL_IOCTL set.  This results
in the application seeing -EBUSY on future ioctls() instead of -EFAULT.  Can be
fixed as below.  Do you want me to send a formal patch on linux-sgx?

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 77757a74644d..df35a79e915c 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -751,8 +751,10 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
        if (encl_flags & SGX_ENCL_IOCTL)
                return -EBUSY;

-       if (encl_flags & SGX_ENCL_DEAD)
-               return -EFAULT;
+       if (encl_flags & SGX_ENCL_DEAD) {
+               ret = -EFAULT;
+               goto out;
+       }

        switch (cmd) {
        case SGX_IOC_ENCLAVE_CREATE:
@@ -772,6 +774,7 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
                break;
        }

+out:
        atomic_andnot(SGX_ENCL_IOCTL, &encl->flags);

        return ret;


> +
> +	switch (cmd) {
> +	case SGX_IOC_ENCLAVE_CREATE:
> +		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
> +		break;
> +	case SGX_IOC_ENCLAVE_ADD_PAGES:
> +		ret = sgx_ioc_enclave_add_pages(encl, (void __user *)arg);
> +		break;
> +	case SGX_IOC_ENCLAVE_INIT:
> +		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
> +		break;
> +	default:
> +		ret = -ENOIOCTLCMD;
> +		break;
> +	}
> +
> +	atomic_andnot(SGX_ENCL_IOCTL, &encl->flags);
> +
> +	return ret;
> +}
