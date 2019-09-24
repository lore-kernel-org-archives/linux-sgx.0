Return-Path: <SRS0=S/Hi=XT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63282C432C1
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 16:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3116520673
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 16:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="AnhHD+VH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409749AbfIXQM5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Sep 2019 12:12:57 -0400
Received: from mail.skyhub.de ([5.9.137.197]:33926 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388230AbfIXQM5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Sep 2019 12:12:57 -0400
Received: from zn.tnic (p200300EC2F0DB700CDA5DCD899733FA6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:b700:cda5:dcd8:9973:3fa6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6437E1EC03F6;
        Tue, 24 Sep 2019 18:12:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569341576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=W577OKhXs7McAt+1hRM93NGDWmaU/qKgednaLVKc6wY=;
        b=AnhHD+VHe0wWGjWlq8g9iL8/9jTsEwZW/rZOKxnFH+1DJd9iuWJSY0suk+bPu7AEFOD53A
        4VdXtrnEvH3QVVupbwQgWvEfnNTIzHll8WOr5Y9vysGTPnDxyfvp+7k0VFTjpTHEd5ftEY
        njcE1E8sd5M4rAFOx8DH1K4D1vh6/Qw=
Date:   Tue, 24 Sep 2019 18:13:01 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 04/24] x86/cpu/intel: Detect SGX supprt
Message-ID: <20190924161301.GI19317@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-5-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190903142655.21943-5-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 03, 2019 at 05:26:35PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> When the CPU supports SGX, check that the BIOS has enabled SGX and SGX1
> opcodes are available. Otherwise, all the SGX related capabilities.
> 
> In addition, clear X86_FEATURE_SGX_LC also in the case when the launch
> enclave are read-only. This way the feature bit reflects the level that
> Linux supports the launch control.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/intel.c | 39 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 8d6d92ebeb54..777ea63b4f85 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -623,6 +623,42 @@ static void detect_tme(struct cpuinfo_x86 *c)
>  	c->x86_phys_bits -= keyid_bits;
>  }
>  
> +static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
> +{
> +	unsigned long long fc;
> +
> +	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
> +	if (!(fc & FEATURE_CONTROL_LOCKED)) {
> +		pr_err_once("sgx: The feature control MSR is not locked\n");
> +		goto err_unsupported;
> +	}
> +
> +	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
> +		pr_err_once("sgx: SGX is not enabled in IA32_FEATURE_CONTROL MSR\n");
> +		goto err_unsupported;
> +	}
> +
> +	if (!cpu_has(c, X86_FEATURE_SGX1)) {
> +		pr_err_once("sgx: SGX1 instruction set is not supported\n");
> +		goto err_unsupported;
> +	}
> +
> +	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
> +		pr_info_once("sgx: The launch control MSRs are not writable\n");
> +		goto err_msrs_rdonly;
> +	}
> +
> +	return;
> +
> +err_unsupported:
> +	setup_clear_cpu_cap(X86_FEATURE_SGX);
> +	setup_clear_cpu_cap(X86_FEATURE_SGX1);
> +	setup_clear_cpu_cap(X86_FEATURE_SGX2);
> +
> +err_msrs_rdonly:
> +	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> +}
> +
>  static void init_cpuid_fault(struct cpuinfo_x86 *c)
>  {
>  	u64 msr;
> @@ -760,6 +796,9 @@ static void init_intel(struct cpuinfo_x86 *c)
>  	if (cpu_has(c, X86_FEATURE_TME))
>  		detect_tme(c);
>  
> +	if (IS_ENABLED(CONFIG_INTEL_SGX) && cpu_has(c, X86_FEATURE_SGX))
> +		detect_sgx(c);

Looks to me like this should run only once on the BSP instead of on
every CPU. The pr_*_once things above are a good sign for that, I'd say.

If so, define your own ->c_bsp_init function and run that from there
instead.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
