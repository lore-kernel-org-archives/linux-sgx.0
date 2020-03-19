Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3554C4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 21:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0B392072C
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 21:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgCSVUg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 17:20:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:11232 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgCSVUg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 17:20:36 -0400
IronPort-SDR: kgY40Plc3ZdCuK6GRU4SlXkem4vJ5fOYhBOJjSlB8JpSRh71i7aPa6tPvn7hCvZyh943Gh8/Km
 kD2ZOwnsMzug==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 14:20:35 -0700
IronPort-SDR: ES0jLNvZKE+ZtdWQqHjIFI5u9X7aWz/ZIxWeTogwH1TWKmjAVVM7JRZE3LPsxfovHw5U6+XPND
 aGY6OZ4qlZPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,573,1574150400"; 
   d="scan'208";a="237054930"
Received: from oamor-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.182.181])
  by fmsmga007.fm.intel.com with ESMTP; 19 Mar 2020 14:20:33 -0700
Date:   Thu, 19 Mar 2020 23:20:32 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] x86/vdso: Use named constant for ENCLU leaves
Message-ID: <20200319212032.GA169489@linux.intel.com>
References: <20200319205116.124166-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319205116.124166-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 19, 2020 at 10:51:16PM +0200, Jarkko Sakkinen wrote:
> Rather than using magic numbers and a comment, replace the magic
> numbers with named constants.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> Already pushed (as is RSA key generation). Just something noted when
> going through 2/8 patch.
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 5 +++--
>  arch/x86/include/asm/enclu.h             | 8 ++++++++
>  2 files changed, 11 insertions(+), 2 deletions(-)
>  create mode 100644 arch/x86/include/asm/enclu.h
> 
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index 22a22e0774d8..7c01a629dc7e 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -3,6 +3,7 @@
>  #include <linux/linkage.h>
>  #include <asm/export.h>
>  #include <asm/errno.h>
> +#include <asm/enclu.h>
>  
>  #include "extable.h"
>  
> @@ -85,9 +86,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  
>  .Lenter_enclave:
>  	/* EENTER <= leaf <= ERESUME */
> -	cmp	$0x2, %eax
> +	cmp	EENTER, %eax
>  	jb	.Linvalid_leaf
> -	cmp	$0x3, %eax
> +	cmp	ERESUME, %eax

These are correct in my tree ('$').

/Jarkko
