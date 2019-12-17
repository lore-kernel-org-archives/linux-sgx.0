Return-Path: <SRS0=a1ch=2H=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B60C43603
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Dec 2019 15:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 137A9218AC
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Dec 2019 15:17:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="IgvRwOM0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLQPRy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Dec 2019 10:17:54 -0500
Received: from mail.skyhub.de ([5.9.137.197]:40798 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbfLQPRy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Dec 2019 10:17:54 -0500
Received: from zn.tnic (p200300EC2F0BBF00B1FF9AA6AAA46E12.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:bf00:b1ff:9aa6:aaa4:6e12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3E7211EC0ABC;
        Tue, 17 Dec 2019 16:17:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1576595873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=eMPRb1cz3Nt28bOIAgvze0vVdLfDNbhPiLCjieiXvPg=;
        b=IgvRwOM0qg8wEd4JMvkhf5NcFcChnH2T+nAaI8DilOhfGUq/o51WiLa8tL5G3bV7q7eDZj
        YN3wzHwN3uisJTfNImBcWCzTgf7LymqJflfElCgg1g6+v3SuE6of3/fouMnEPaPsYQsNbr
        E/0wOJ3MIYeFtXVSrxFfD8e/Z2HFiVc=
Date:   Tue, 17 Dec 2019 16:17:44 +0100
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
Message-ID: <20191217151744.GG28788@zn.tnic>
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

Typo in the subject:

Subject: Re: [PATCH v24 07/24] x86/cpu/intel: Detect SGX supprt
							 ^^^^^^
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

...

> @@ -761,6 +797,11 @@ static void init_intel(struct cpuinfo_x86 *c)
>  	if (cpu_has(c, X86_FEATURE_TME))
>  		detect_tme(c);
>  
> +#ifdef CONFIG_INTEL_SGX
> +	if (cpu_has(c, X86_FEATURE_SGX))
> +		detect_sgx(c);
> +#endif

You can remove the ifdeffery here and put the ifdef around the function
body and drop the __maybe_unused tag:

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ef41431b3f70..2f3414eff99d 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -624,8 +624,9 @@ static void detect_tme(struct cpuinfo_x86 *c)
 	c->x86_phys_bits -= keyid_bits;
 }
 
-static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
+static void detect_sgx(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_INTEL_SGX
 	unsigned long long fc;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
@@ -658,6 +659,7 @@ static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
 
 err_msrs_rdonly:
 	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
+#endif
 }
 
 static void init_cpuid_fault(struct cpuinfo_x86 *c)
@@ -797,10 +799,8 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_TME))
 		detect_tme(c);
 
-#ifdef CONFIG_INTEL_SGX
 	if (cpu_has(c, X86_FEATURE_SGX))
 		detect_sgx(c);
-#endif
 
 	init_intel_misc_features(c);
 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
