Return-Path: <SRS0=gNuZ=2N=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B479DC2D0C0
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Dec 2019 09:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88F5F20715
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Dec 2019 09:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="fTMpOfmt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfLWJqY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 23 Dec 2019 04:46:24 -0500
Received: from mail.skyhub.de ([5.9.137.197]:36658 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbfLWJqY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 23 Dec 2019 04:46:24 -0500
Received: from zn.tnic (p200300EC2F0ED600ADBBD4693F09EE6A.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:d600:adbb:d469:3f09:ee6a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BA7541EC0391;
        Mon, 23 Dec 2019 10:46:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1577094382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=e00xLS3wvMXuUpar8VvqyPvkT9aL3MNsXz6CAS0DPiU=;
        b=fTMpOfmtWjlC7dDCmoRgPup2HzK38xsqvsy/5QT3+29JHaRNRmig2ExPdwLOJ7/iSLGYV4
        nworLXMnrzytNjpcQ/EMMvOPnCbfL4J7PQJj2AeARGgHRNJaRz9w7rGuo2X/mWcHtMjzTo
        m0doIrPahHJ3I9RcnAeSR5woS/229wE=
Date:   Mon, 23 Dec 2019 10:46:14 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
Subject: Re: [PATCH v24 07/24] x86/cpu/intel: Detect SGX supprt
Message-ID: <20191223094614.GB16710@zn.tnic>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20191129231326.18076-8-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191129231326.18076-8-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 30, 2019 at 01:13:09AM +0200, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> When the CPU supports SGX, check that the BIOS has enabled SGX and SGX1
> opcodes are available. Otherwise, all the SGX related capabilities.
> 
> In addition, clear X86_FEATURE_SGX_LC also in the case when the launch
> enclave are read-only. This way the feature bit reflects the level that
> Linux supports the launch control.
> 
> The check is done for every CPU, not just BSP, in order to verify that
> MSR_IA32_FEATURE_CONTROL is correctly configured on all CPUs. The other
> parts of the kernel, like the enclave driver, expect the same
> configuration from all CPUs.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/intel.c | 41 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index c2fdc00df163..89a71367716c 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -624,6 +624,42 @@ static void detect_tme(struct cpuinfo_x86 *c)
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

One more thing - and we talked about this already - when the hash
MSRs are not writable, the kernel needs to disable all SGX support by
default. Basically, no SGX support is present.

If the user wants to run KVM guests with SGX enclaves, then she should
probably boot with a special kvm param or so. Details on how can exactly
control that can be discussed later - just making sure you guys are not
forgetting this use angle.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
