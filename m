Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B964C433EF
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Apr 2022 14:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347951AbiDAOge (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347573AbiDAOdM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 10:33:12 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9195F243702
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 07:29:48 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 741D11EC05F1;
        Fri,  1 Apr 2022 16:29:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1648823383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=VJc+B2DAIeN+N6wUv/vPlmu4url/ee74EKg/XQZSwac=;
        b=J+Awif0uJCB77rBHX43NCOqxqhMLF1TENGsezdDH7eM4jOBf7f9vR4O7Ibmb1YjN+oa/+D
        F6+U5dqPcQZG62mdHa0gkJQGx81SMi0nT2yhv0SdWd3hOO0isr4/CaOiV5tlzoDPKpf4ZN
        LBaP6Qv+THTmfNZ7uedqQC4U1cs6ePo=
Date:   Fri, 1 Apr 2022 16:29:42 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com
Subject: Re: [RFC PATCH v3 09/10] x86/cpu: Call ENCLS[EUPDATESVN] procedure
 in microcode update
Message-ID: <YkcMVh2ostXlhr5t@zn.tnic>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-10-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220401142409.26215-10-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 01, 2022 at 10:24:08PM +0800, Cathy Zhang wrote:
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

Stick all that above...

> +		update_cpusvn_intel();

...inside this function so that you have only the call here. Inside the
function you can do all the ifdeffery, checking and commenting and so
on. Just like perf_check_microcode() does.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
