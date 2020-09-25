Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05587C4727C
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 22:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3E9023119
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 22:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgIYWh5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 18:37:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:49071 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbgIYWh4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 18:37:56 -0400
IronPort-SDR: jwty8pPP8LavWVNaDBq3vhrAI0H7kV0+Dzae5XMipYQ54ieuiXrDGAkGyqkkLyP8z/zGiiQtts
 J9ZQMF1h51Kg==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="246439561"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="246439561"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 15:37:56 -0700
IronPort-SDR: g1P/W0WSXpvqYtJ+RK6vmgiPnlKkCFM5ZGrgrPwdC1lcsWkmurjz/yyKmX6ekgqUYQMBbdT9US
 VHa7bmLanv4Q==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="512409967"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 15:37:55 -0700
Date:   Fri, 25 Sep 2020 15:37:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, yaozhangx@google.com
Subject: Re: [PATCH v38 24/24] x86/sgx: Update MAINTAINERS
Message-ID: <20200925223753.GA9998@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-25-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915112842.897265-25-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 02:28:42PM +0300, Jarkko Sakkinen wrote:
> Add the maintainer information for the SGX subsystem.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  MAINTAINERS | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3b186ade3597..1d4daeb12d0a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9051,6 +9051,17 @@ F:	Documentation/x86/intel_txt.rst
>  F:	arch/x86/kernel/tboot.c
>  F:	include/linux/tboot.h
>  
> +INTEL SGX
> +M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> +M:	Sean Christopherson <sean.j.christopherson@intel.com>
> +L:	linux-sgx@vger.kernel.org
> +S:	Maintained
> +Q:	https://patchwork.kernel.org/project/intel-sgx/list/
> +T:	git https://github.com/jsakkine-intel/linux-sgx.git

This is stale, you moved your tree to kernel.org.

> +F:	arch/x86/include/uapi/asm/sgx.h
> +F:	arch/x86/kernel/cpu/sgx/*
> +K:	\bSGX_
> +
>  INTERCONNECT API
>  M:	Georgi Djakov <georgi.djakov@linaro.org>
>  L:	linux-pm@vger.kernel.org
> -- 
> 2.25.1
> 
