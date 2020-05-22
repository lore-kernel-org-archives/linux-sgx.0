Return-Path: <SRS0=O4vE=7E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B13C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 19:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C91720723
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 19:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730982AbgEVTjW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 May 2020 15:39:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:9245 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730894AbgEVTjV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 May 2020 15:39:21 -0400
IronPort-SDR: P2Y0hb8PPAMIyFWVmjBjH/RiAjYEW2AmMogTRKNyRHa7o93+TWWF0j4LJIQYD1Uk7YFbWxkNeI
 a7CCLmW8a7Qg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 12:39:20 -0700
IronPort-SDR: Fd3haaiMcR6epj6Lwf0RAO7Vcu6h11rUPXWFv2XUJk3PogUpO/jRlywthEyJ5C35P2jd0uuh/G
 2Z4tRHj71yAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,422,1583222400"; 
   d="scan'208";a="440966479"
Received: from rpurrx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.58.10])
  by orsmga005.jf.intel.com with ESMTP; 22 May 2020 12:39:14 -0700
Date:   Fri, 22 May 2020 22:39:14 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Message-ID: <20200522193914.GF10319@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-11-jarkko.sakkinen@linux.intel.com>
 <20200521191236.GA23043@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521191236.GA23043@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 21, 2020 at 12:12:36PM -0700, Sean Christopherson wrote:
> On Fri, May 15, 2020 at 03:44:00AM +0300, Jarkko Sakkinen wrote:
> > +long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> > +{
> > +	struct sgx_encl *encl = filep->private_data;
> > +	int ret, encl_flags;
> > +
> > +	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
> > +	if (encl_flags & SGX_ENCL_IOCTL)
> > +		return -EBUSY;
> > +
> > +	if (encl_flags & SGX_ENCL_DEAD)
> > +		return -EFAULT;
> 
> Returning immediately is wrong as it leaves SGX_ENCL_IOCTL set.  This results
> in the application seeing -EBUSY on future ioctls() instead of -EFAULT.  Can be
> fixed as below.  Do you want me to send a formal patch on linux-sgx?
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 77757a74644d..df35a79e915c 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -751,8 +751,10 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>         if (encl_flags & SGX_ENCL_IOCTL)
>                 return -EBUSY;
> 
> -       if (encl_flags & SGX_ENCL_DEAD)
> -               return -EFAULT;
> +       if (encl_flags & SGX_ENCL_DEAD) {
> +               ret = -EFAULT;
> +               goto out;
> +       }
> 
>         switch (cmd) {
>         case SGX_IOC_ENCLAVE_CREATE:
> @@ -772,6 +774,7 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>                 break;
>         }
> 
> +out:
>         atomic_andnot(SGX_ENCL_IOCTL, &encl->flags);
> 
>         return ret;
> 
> 
> > +
> > +	switch (cmd) {
> > +	case SGX_IOC_ENCLAVE_CREATE:
> > +		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
> > +		break;
> > +	case SGX_IOC_ENCLAVE_ADD_PAGES:
> > +		ret = sgx_ioc_enclave_add_pages(encl, (void __user *)arg);
> > +		break;
> > +	case SGX_IOC_ENCLAVE_INIT:
> > +		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
> > +		break;
> > +	default:
> > +		ret = -ENOIOCTLCMD;
> > +		break;
> > +	}
> > +
> > +	atomic_andnot(SGX_ENCL_IOCTL, &encl->flags);
> > +
> > +	return ret;
> > +}

Thanks. Fixed in my tree:

v31:
* Unset SGX_ENCL_IOCTL in the error path of checking encl->flags in order
  to prevent leaving it set, and thus block any further ioctl calls.
* Added missing cleanup_srcu_struct() call to sgx_encl_release().
* Take encl->lock in sgx_encl_add_page() in order to prevent races with
  the page reclaimer.

 /Jarkko
