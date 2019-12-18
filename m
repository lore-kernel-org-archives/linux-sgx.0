Return-Path: <SRS0=GWrB=2I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C854CC43603
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Dec 2019 09:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76ADB24650
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Dec 2019 09:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="Fk43jeqA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfLRJTH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Dec 2019 04:19:07 -0500
Received: from mail.skyhub.de ([5.9.137.197]:59382 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfLRJTH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Dec 2019 04:19:07 -0500
Received: from zn.tnic (p200300EC2F0B8B0019D63FEBF10F193B.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:8b00:19d6:3feb:f10f:193b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A73691EC01AD;
        Wed, 18 Dec 2019 10:19:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1576660745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PhrSdgcZwoPWDd5jU9umv1jFxMc9F4x5Z412X3Mg6pc=;
        b=Fk43jeqA8gwd5wYwY2mkCGqqN5MMH3lErnH4PGyybkqjtNrLsvJRczDjvqWnc6tcZKnV3E
        0sKXn6MTArug6yqQ8bv+MHvq9CM3DpvXuOPxEnNygpnkqU/6AW0zMdsDTk6Dud6V0OIOy0
        qREtqb+Z8/GPXpf+MVu1sGmLgqUnAuA=
Date:   Wed, 18 Dec 2019 10:18:56 +0100
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
Subject: Re: [PATCH v24 08/24] x86/sgx: Enumerate and track EPC sections
Message-ID: <20191218091856.GA24886@zn.tnic>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20191129231326.18076-9-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191129231326.18076-9-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 30, 2019 at 01:13:10AM +0200, Jarkko Sakkinen wrote:
> +static bool __init sgx_alloc_epc_section(u64 addr, u64 size,
> +					 unsigned long index,
> +					 struct sgx_epc_section *section)
> +{
> +	unsigned long nr_pages = size >> PAGE_SHIFT;

I'm assuming here that size which gets communicated through CPUID -
which is an interesting way to communicate SGX settings in itself :-) - is
in multiples of 4K? SDM doesn't say...

And last time I asked:

"This size comes from CPUID but it might be prudent to sanity-check it
nevertheless, before doing the memremap()."

but it was left uncommented.

> +/**
> + * A section metric is concatenated in a way that @low bits 12-31 define the
> + * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
> + * metric.
> + */
> +static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
> +{
> +	return (low & GENMASK_ULL(31, 12)) +
> +	       ((high & GENMASK_ULL(19, 0)) << 32);
> +}
> +
> +static bool __init sgx_page_cache_init(void)
> +{
> +	u32 eax, ebx, ecx, edx, type;
> +	u64 pa, size;
> +	int i;
> +
> +	BUILD_BUG_ON(SGX_MAX_EPC_SECTIONS > (SGX_EPC_SECTION_MASK + 1));
> +
> +	for (i = 0; i < (SGX_MAX_EPC_SECTIONS + 1); i++) {

Those brackets are still here from the last time. You said:

"For nothing :-)

I'll change it as:

  for (i = 0; i <= SGX_MAX_EPC_SECTIONS; i++) {"

but probably forgot...

and looking at my review comments here:

https://lkml.kernel.org/r/20191005092627.GA25699@zn.tnic

and your reply:

https://lkml.kernel.org/r/20191007115850.GA20830@linux.intel.com

you clearly missed addressing some so I'm going to stop reviewing here.

Please have a look at those review comments again and check whether the
apply - and then do them - or they don't and they pls explain why they
don't.

And do that for the rest of the patchset, please, before you send it
again.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
