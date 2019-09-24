Return-Path: <SRS0=S/Hi=XT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B95C432C1
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 15:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E15F9214AF
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 15:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="XgWGhZQQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390645AbfIXPwc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Sep 2019 11:52:32 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58816 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390621AbfIXPwc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Sep 2019 11:52:32 -0400
Received: from zn.tnic (p200300EC2F0DB700DCC45CFC64A01FDA.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:b700:dcc4:5cfc:64a0:1fda])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 23C671EC03F6;
        Tue, 24 Sep 2019 17:52:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569340351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=l3jFh3vc0yWIg+y9vM+gn/zUH4p7Zpw4IM2PNranPm4=;
        b=XgWGhZQQV+Iw40yB7ykRGEOcn5mBvdNHEHu1yGH6Z1ofug0Xpe+I5u1CCnTkehCHOUpiuM
        WeaAILMu94hybPkqnrkI0njXNca6PZqpk6hyprFWUTG+GAPhSf0frPvOOCcpIJcx3PAhPY
        Ptye33yvUKfABQoDAYgTULUlIo8jSp8=
Date:   Tue, 24 Sep 2019 17:52:32 +0200
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
        Kai Huang <kai.huang@linux.intel.com>,
        Haim Cohen <haim.cohen@intel.com>
Subject: Re: [PATCH v22 02/24] x86/cpufeatures: x86/msr: Intel SGX Launch
 Control hardware bits
Message-ID: <20190924155232.GG19317@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 03, 2019 at 05:26:33PM +0300, Jarkko Sakkinen wrote:
> From: Kai Huang <kai.huang@linux.intel.com>
> 
> Add X86_FEATURE_SGX_LC, which informs whether or not the CPU supports SGX
> Launch Control.
> 
> Add MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}, which when combined contain a
> SHA256 hash of a 3072-bit RSA public key. SGX backed software packages, so
> called enclaves, are always signed. All enclaves signed with the public key
> are unconditionally allowed to initialize. [1]
> 
> Add FEATURE_CONTROL_SGX_LE_WR bit of the feature control MSR, which informs
> whether the formentioned MSRs are writable or not. If the bit is off, the
> public key MSRs are read-only for the OS.
> 
> If the MSRs are read-only, the platform must provide a launch enclave (LE).
> LE can create cryptographic tokens for other enclaves that they can pass
> together with their signature to the ENCLS(EINIT) opcode, which is used
> to initialize enclaves.
> 
> Linux is unlikely to support the locked configuration because it takes away
> the control of the launch decisions from the kernel.

Right, who has control over FEATURE_CONTROL_SGX_LE_WR? Can the
kernel set it and put another hash in there or there will be locked
configurations where setting that bit will trap?

I don't want to leave anything in the hands of the BIOS controlling
whether the platform can set its own key because BIOS is known to f*ck
it up almost every time. And so I'd like for us to be able to fix up
things without depending on the mood of some OEM vendor's BIOS fixing
desire.

> [1] Intel SDM: 38.1.4 Intel SGX Launch Control Configuration
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Haim Cohen <haim.cohen@intel.com>
> Signed-off-by: Haim Cohen <haim.cohen@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

This time checkpatch is right:

WARNING: Missing Signed-off-by: line by nominal patch author 'Kai Huang <kai.huang@linux.intel.com>'

And looking at the SOB chain, sounds like people need to make up their
mind about authorship...

> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/include/asm/msr-index.h   | 7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index c5582e766121..ca82226e25ec 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -355,6 +355,7 @@
>  #define X86_FEATURE_CLDEMOTE		(16*32+25) /* CLDEMOTE instruction */
>  #define X86_FEATURE_MOVDIRI		(16*32+27) /* MOVDIRI instruction */
>  #define X86_FEATURE_MOVDIR64B		(16*32+28) /* MOVDIR64B instruction */
> +#define X86_FEATURE_SGX_LC		(16*32+30) /* Software Guard Extensions Launch Control */

Amazing. SGX feature bits are spread around at least three CPUID leafs:

7_EBX, 7_ECX, 12_EAX. Maybe there's a 4th somewhere because hey... :-\

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
