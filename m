Return-Path: <SRS0=Qwf+=N3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA27C43441
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 14:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 389D12086C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 14:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="Yc4IPEMh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 389D12086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbeKQAt6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Nov 2018 19:49:58 -0500
Received: from mail.skyhub.de ([5.9.137.197]:44364 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbeKQAt5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Nov 2018 19:49:57 -0500
X-Virus-Scanned: Nedap ESD1 at mail.skyhub.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1542379037; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SFf5ykLr71pjcsM419kMkIcPambg9F1IeKlldI9ntVw=;
        b=Yc4IPEMhmPB+8y3eDXj1S+Q2tlhoDP2UOVS49EjZcWX/CtfMoFz1U8Hs0VAIdjdAwXX4rJ
        UoHG6IGcJU0v3sBW2efKEeetGkuVhhWrChPKRD/kdnitCQMX2YKBxacirhrNX7MPg9vM4T
        q5hP9NZwQL+FUe5bsDL7QHx84ZVxS8s=
Received: from mail.skyhub.de ([127.0.0.1])
        by localhost (blast.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XGuUpSrINTZ5; Fri, 16 Nov 2018 15:37:16 +0100 (CET)
Received: from zn.tnic (p200300EC2BD0FE004D130AD2F34E6DE4.dip0.t-ipconnect.de [IPv6:2003:ec:2bd0:fe00:4d13:ad2:f34e:6de4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9633D1EC0198;
        Fri, 16 Nov 2018 15:37:16 +0100 (CET)
Date:   Fri, 16 Nov 2018 15:37:15 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 03/23] x86/cpufeatures: Add SGX sub-features (as
 Linux-defined bits)
Message-ID: <20181116143715.GJ20313@zn.tnic>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-4-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20181116010412.23967-4-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 03:01:10AM +0200, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> CPUID_12_EAX is an Intel-defined feature bits leaf dedicated for SGX
> that enumerates the SGX instruction sets that are supported by the
> CPU, e.g. SGX1, SGX2, etc...  Because Linux currently only cares about
> two bits (SGX1 and SGX2) and there are currently only four documented
> bits in total, relocate the bits to Linux-defined word 8 to conserve
> space.
> 
> But, keep the bit positions identical between the Intel-defined value
> and the Linux-defined value, e.g. keep SGX1 at bit 0.  This allows KVM
> to use its existing code for probing guest CPUID bits using Linux's
> X86_FEATURE_* definitions.  To do so, shift around some existing bits
> to effectively reserve bits 0-7 of word 8 for SGX sub-features.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h       | 21 +++++++++++++++------
>  arch/x86/kernel/cpu/scattered.c          |  2 ++
>  tools/arch/x86/include/asm/cpufeatures.h | 21 +++++++++++++++------
>  3 files changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index da7fed4939a3..afdf5f2e13b5 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -222,12 +222,21 @@
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
> + */
> +#define X86_FEATURE_SGX1		( 8*32+ 0) /* SGX1 leaf functions */
> +#define X86_FEATURE_SGX2		( 8*32+ 1) /* SGX2 leaf functions */
> +

Yeah, add here	^^^^

/* Bits [0:7] are reserved for SGX */

or so, so that people don't use those. Once CPUID(12) gets more bits
added to it, I don't see anything wrong with allocating a separate leaf
for that.

BUT(!), the question then is whether kvm would still be ok with that?
I'm thinking yes, as it will simply use the new definitions, or?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
