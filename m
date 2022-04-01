Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3AAC433F5
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Apr 2022 16:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241829AbiDAQVO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 12:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352826AbiDAQSZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 12:18:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595D11FF40A
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 08:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648827741; x=1680363741;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=enTTT1u05QL27R5WKlsM+YriT+zSV8ItqwAFZJ/0GvU=;
  b=AdqByq0V+eEbG2wav5nZzPjzaC0KbJc8PRzyC6EBZGZ4FI6pn34rU1+u
   sIZBd3ZF0hWH3mjN2SLR56begzzGqqUWxMmEuPOG+7tyj4GIXddjcp6Gn
   ZQWePG4NVVEnSA/NSFCaXR8VW06uenKQ6kwV006HwqU7rHM56qZ26JrgB
   yz+GTMnUiyeEcU10+uUmTYloMfhnAhPiuPczauQ4HIyZl9tBLgZPkK/Jp
   WsuALyJ3yRbnl8+dCLW4xUAFI3Uhub3lEKQJ6KSTYCWT9Ir6VtK9O8rlT
   pCjAY0R+wp3IZTYW/rMiXIGeJX8NoRfXPH9vJ68/OXATs5J7gye7DSNx3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="242309742"
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="242309742"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 08:42:20 -0700
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="567580076"
Received: from dajones-mobl.amr.corp.intel.com (HELO [10.212.134.9]) ([10.212.134.9])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 08:42:20 -0700
Message-ID: <64c85acb-429b-ee40-22e6-d5ba7e4abee1@intel.com>
Date:   Fri, 1 Apr 2022 08:42:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com, ashok.raj@intel.com
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-10-cathy.zhang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH v3 09/10] x86/cpu: Call ENCLS[EUPDATESVN] procedure in
 microcode update
In-Reply-To: <20220401142409.26215-10-cathy.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/1/22 07:24, Cathy Zhang wrote:
> +#ifndef update_cpusvn_intel
> +static inline void update_cpusvn_intel(void) {}
> +#endif
> +
>  #endif /* _ASM_X86_MICROCODE_H */
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 74bcb6841a4b..5867f5a78d13 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -409,4 +409,9 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
>  int sgx_set_attribute(unsigned long *allowed_attributes,
>  		      unsigned int attribute_fd);
>  
> +#ifdef CONFIG_X86_SGX
> +void update_cpusvn_intel(void);
> +#define update_cpusvn_intel update_cpusvn_intel
> +#endif
> +
>  #endif /* _ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 7b8382c11788..f53fd877ba0d 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -59,6 +59,7 @@
>  #include <asm/cpu_device_id.h>
>  #include <asm/uv/uv.h>
>  #include <asm/sigframe.h>
> +#include <asm/sgx.h>
>  
>  #include "cpu.h"
>  
> @@ -2086,6 +2087,14 @@ void microcode_check(void)
>  
>  	perf_check_microcode();
>  
> +	/*
> +	 * SGX related microcode update requires EUPDATESVN to update CPUSVN, which
> +	 * will destroy all enclaves to ensure EPC is not in use. If SGX is configured
> +	 * and EUPDATESVN is supported, call the EUPDATESVN procecure.
> +	 */
> +	if (IS_ENABLED(CONFIG_X86_SGX) && (cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN))
> +		update_cpusvn_intel();

In addition to what Borislav said, these #ifdefs are not how we do things.

The update_cpusvn_intel() shouldn't be declared in two different
headers.  Just imagine what happens if some code happens to include the
microcode header *then* the sgx.h header.

Please define both the 'static inline' stub *and* the declaration in
sgx.h.  Then you won't even need the #ifndef trickery.  Please also add
an "sgx_" to its name prefix while you're at it.

That comment is also not great.  A reader will likely have *ZERO* idea
what EUPDATESVN is or what a CPUSVN is.  Try to focus on what the code
*means* rather than just repeat the if() conditions in the comment.

