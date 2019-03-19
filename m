Return-Path: <SRS0=vqpH=RW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2655C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Mar 2019 17:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B04C20863
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Mar 2019 17:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfCSRMb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Mar 2019 13:12:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:35955 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbfCSRMb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 19 Mar 2019 13:12:31 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Mar 2019 10:12:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,245,1549958400"; 
   d="scan'208";a="135411965"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga003.jf.intel.com with ESMTP; 19 Mar 2019 10:12:30 -0700
Date:   Tue, 19 Mar 2019 10:12:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v19 27/27] x86/sgx: Update MAINTAINERS
Message-ID: <20190319171229.GF25575@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-28-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317211456.13927-28-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Mar 17, 2019 at 11:14:56PM +0200, Jarkko Sakkinen wrote:
> Add the maintainer information for the SGX subsystem.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  MAINTAINERS | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e17ebf70b548..7abcb460dde9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8044,6 +8044,18 @@ L:	linux-gpio@vger.kernel.org
>  S:	Maintained
>  F:	drivers/gpio/gpio-intel-mid.c
>  
> +INTEL SGX

Alphabetically, this should slot in between "INTEL RDMA RNIC DRIVER" and
"INTEL TELEMETRY DRIVER".

Tangentially related, is it worth sending a patch to rename "INTEL-MID GPIO DRIVER"
to "INTEL MID GPIO DRIVER" and drop "(R)" from "INTEL(R) TRACE HUB"
and "INTEL(R) TRUSTED EXECUTION TECHNOLOGY (TXT)"?  They're silly
renegades that muck up the ordering.

> +M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> +M:	Sean Christopherson <sean.j.christopherson@intel.com>
> +L:	linux-sgx@vger.kernel.org
> +S:	Maintained
> +Q:	https://patchwork.kernel.org/project/intel-sgx/list/
> +T:	git https://github.com/jsakkine-intel/linux-sgx.git
> +F:	arch/x86/include/asm/sgx.h

arch/x86/include/asm/sgx.h doesn't exist in this version of the series.

> +F:	arch/x86/include/uapi/asm/sgx.h
> +F:	arch/x86/kernel/cpu/sgx/*

The trailing asterisk is unnecessary and wrong.  From MAINTAINER's docs:

        F: Files and directories with wildcard patterns.
           A trailing slash includes all files and subdirectory files.
           F:   drivers/net/    all files in and below drivers/net
           F:   drivers/net/*   all files in drivers/net, but not below

> +K:	\bSGX_
> +
>  INTERCONNECT API
>  M:	Georgi Djakov <georgi.djakov@linaro.org>
>  S:	Maintained
> -- 
> 2.19.1
> 
