Return-Path: <SRS0=Np89=7O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC23C433DF
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 15:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5E6720678
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 15:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JF51AjHp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgFAPPf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jun 2020 11:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgFAPPf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Jun 2020 11:15:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49574C05BD43;
        Mon,  1 Jun 2020 08:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=jLa9Cs6KPFDIq/LauwWoS8nPQuTY0fDFirA+0P0b6ZQ=; b=JF51AjHplOuNk7/7URmurCtVK5
        ZKxzJFW50E1hDmvsJNBhFDgGUg6madQNpOFN+9+FghrZD2zhAga6AzC2zo/KW8H2tOXDIIoI5Wnuc
        S9j/lagThXNJ9uYibYzZIgSd+SN7Zi+tkgGx0hiRcx1YcZ5P75hqyqcseiGOlyHP+oAWAdyoyqxtM
        m+v3NWm9QaFoKL/P0KXX48a55FTSvhi1jAaTW20v6f7TO/jiJDNGxc64eiVeZShx1fY7sEfUtekr2
        +h/QDa64j5t0Q/NxCO4RldVw+mmn+PBBK5WvWsXlgmE01VJ6ON6P4Ru0l7sp58pfOQWNYwYrm/zbz
        eNAvHNQA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jfm9o-0004ma-50; Mon, 01 Jun 2020 15:15:20 +0000
Subject: Re: [PATCH v32 08/21] x86/sgx: Initialize metadata for Enclave Page
 Cache (EPC) sections
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
References: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
 <20200601075218.65618-9-jarkko.sakkinen@linux.intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2b95a9c4-c7fc-103c-5bc9-f5d13ce7d897@infradead.org>
Date:   Mon, 1 Jun 2020 08:15:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200601075218.65618-9-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi,

Sorry I didn't respond to v31 with this so that it could
have been fixed in v32.

On 6/1/20 12:52 AM, Jarkko Sakkinen wrote:
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 2d3f963fd6f1..d246c6071e8d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1948,6 +1948,22 @@ config X86_INTEL_TSX_MODE_AUTO
>  	  side channel attacks- equals the tsx=auto command line parameter.
>  endchoice
>  
> +config INTEL_SGX
> +	bool "Intel SGX"
> +	depends on X86_64 && CPU_SUP_INTEL
> +	depends on CRYPTO=y
> +	depends on CRYPTO_SHA256=y
> +	select SRCU
> +	select MMU_NOTIFIER
> +	help
> +	  Intel(R) SGX is a set of CPU instructions that can be used by
> +	  applications to set aside private regions of code and data, referred
> +	  to as enclaves. An enclave's private memory can only be accessed by
> +	  code running within the enclave. Accesses from outside the enclave,
> +	  including other enclaves, are disallowed by hardware.

Either the prompt
	bool "Intel SGX"
or the help text should tell us what SGX means.
(Software Guard eXtensions)

> +
> +	  If unsure, say N.
> +
>  config EFI
>  	bool "EFI runtime service support"
>  	depends on ACPI

thanks.
-- 
~Randy

