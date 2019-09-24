Return-Path: <SRS0=S/Hi=XT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E731C432C1
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 15:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC1E020665
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 15:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="Ah4V2Y1C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbfIXP2u (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Sep 2019 11:28:50 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55546 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbfIXP2u (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Sep 2019 11:28:50 -0400
Received: from zn.tnic (p200300EC2F0DB700DCC45CFC64A01FDA.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:b700:dcc4:5cfc:64a0:1fda])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 12EB71EC03F6;
        Tue, 24 Sep 2019 17:28:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569338929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LtNkIhYtzZ/fSLb+hlvCu4hqnbeOcZTKSutkYY729Ow=;
        b=Ah4V2Y1C6XT9qdCd+m8NCyjExYvexZndou3aLdHN7V/0brF96jTFulJDoLBLoRwWje+OJn
        LebFupY5YsOtDeCDRT3nMt2x/T2X7SZoXWBXEqYKJOMjzQ0a+f6NbCxN/Ikr+korubwnXj
        5pnhx05KO0HF0zkOXtSs6LvQgbLSpLk=
Date:   Tue, 24 Sep 2019 17:28:48 +0200
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
        Kai Huang <kai.huang@linux.intel.com>
Subject: Re: [PATCH v22 01/24] x86/cpufeatures: x86/msr: Add Intel SGX
 hardware bits
Message-ID: <20190924152848.GF19317@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-2-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190903142655.21943-2-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 03, 2019 at 05:26:32PM +0300, Jarkko Sakkinen wrote:
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 998c2cc08363..c5582e766121 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -222,12 +222,22 @@
>  #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
>  #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
>  
> -/* Virtualization flags: Linux defined, word 8 */
> -#define X86_FEATURE_TPR_SHADOW		( 8*32+ 0) /* Intel TPR Shadow */
> -#define X86_FEATURE_VNMI		( 8*32+ 1) /* Intel Virtual NMI */
> -#define X86_FEATURE_FLEXPRIORITY	( 8*32+ 2) /* Intel FlexPriority */
> -#define X86_FEATURE_EPT			( 8*32+ 3) /* Intel Extended Page Table */
> -#define X86_FEATURE_VPID		( 8*32+ 4) /* Intel Virtual Processor ID */
> +/*
> + * Scattered Intel features: Linux defined, word 8.
> + *
> + * Note that the bit location of the SGX features is meaningful as KVM expects
> + * the Linux defined bit to match the Intel defined bit, e.g. X86_FEATURE_SGX1
> + * must remain at bit 0, SGX2 at bit 1, etc...

Eww, no.

> + */
> +#define X86_FEATURE_SGX1		( 8*32+ 0) /* SGX1 leaf functions */
> +#define X86_FEATURE_SGX2		( 8*32+ 1) /* SGX2 leaf functions */
> +/* Bits [0:7] are reserved for SGX */

That leaf has "Bits 31 - 07: Reserved." So what happens if they start
adding more bits there? We shoosh the other defines even further into
the word?

Talk to your hw guys, if the plan is to leave those bits for other
feature flags, then let's allocate a new capability word for F12_EAX.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
