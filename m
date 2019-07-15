Return-Path: <SRS0=tSvt=VM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2AD0C76191
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Jul 2019 13:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87E9B2083D
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Jul 2019 13:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbfGON7M (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Jul 2019 09:59:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:22039 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733242AbfGON7E (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 15 Jul 2019 09:59:04 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 06:59:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="157822309"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga007.jf.intel.com with ESMTP; 15 Jul 2019 06:59:03 -0700
Date:   Mon, 15 Jul 2019 06:59:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Return 0 when !CONFIG_INTEL_SGX_DRIVER
Message-ID: <20190715135902.GA442@linux.intel.com>
References: <20190714143212.971-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714143212.971-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Jul 14, 2019 at 05:32:12PM +0300, Jarkko Sakkinen wrote:
> When the config option is not enabled the initialization is always
> succesful.

Why would the be initialization be considered successful?  It's dead code
and memory consumption if the driver can't load.  When KVM support gets
added, the initialization can be considered successful if the driver *or*
virtual EPC are enabled and load cleanly.

> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> This was the reason why I got the -ENODEV error with my BuildRoot image.
> The config option was not enabled but took some time realize as I was
> kind of getting an error code from the driver initialization. Finally
> when I used ftrace with 'sgx*' I knew what was going on.
>  arch/x86/kernel/cpu/sgx/driver/driver.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
> index da60839b133a..aafa64a4f481 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/driver.h
> +++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
> @@ -37,7 +37,7 @@ int sgx_drv_init(void);
>  #else
>  static inline int sgx_drv_init(void)
>  {
> -	return -ENODEV;
> +	return 0;
>  }
>  #endif
>  
> -- 
> 2.20.1
> 
