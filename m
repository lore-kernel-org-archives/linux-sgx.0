Return-Path: <SRS0=a1ch=2H=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C9DC43603
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Dec 2019 14:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 547F224672
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Dec 2019 14:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="KzqHlTMn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfLQOp5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Dec 2019 09:45:57 -0500
Received: from mail.skyhub.de ([5.9.137.197]:35976 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbfLQOp4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Dec 2019 09:45:56 -0500
Received: from zn.tnic (p200300EC2F0BBF00B1FF9AA6AAA46E12.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:bf00:b1ff:9aa6:aaa4:6e12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 53EF31EC0C98;
        Tue, 17 Dec 2019 15:45:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1576593955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=4Z3n2EH/Q0VRUKMKsCjrgjVpECFcgut+s/l07f0q4KQ=;
        b=KzqHlTMnAxbxCs4KE/SDF5ei56nQeE+tLbIS3dTJN7rDw1vGM3hz6vyYTX8HdiUSntYNG6
        TBze4+Fy7qr6GDN20idaL3ly5eYL1IqNv7ekgn3Dqw0UshJMok7GIj8z4Mis1UNsHR+Y6O
        pgmSPsocd1sn6GhNrFCczQafMRXNFbU=
Date:   Tue, 17 Dec 2019 15:45:48 +0100
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
Subject: Re: [PATCH v24 06/24] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20191217144548.GF28788@zn.tnic>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20191129231326.18076-7-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191129231326.18076-7-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 30, 2019 at 01:13:08AM +0200, Jarkko Sakkinen wrote:
> +/**
> + * encls_failed() - Check if an ENCLS leaf function failed
> + * @ret:	the return value of an ENCLS leaf function call
> + *
> + * Check if an ENCLS leaf function failed. This happens when the leaf function
> + * causes a fault that is not caused by an EPCM conflict or when the leaf
> + * function returns a non-zero value.
> + */
> +static inline bool encls_failed(int ret)
> +{
> +	int epcm_trapnr =
> +		boot_cpu_has(X86_FEATURE_SGX2) ? X86_TRAP_PF : X86_TRAP_GP;
> +	bool fault = ret & ENCLS_FAULT_FLAG;
> +
> +	return (fault && ENCLS_TRAPNR(ret) != epcm_trapnr) || (!fault && ret);
> +}

Can we make this function more readable?

static inline bool encls_failed(int ret)
{
        int epcm_trapnr;

        if (boot_cpu_has(X86_FEATURE_SGX2))
                epcm_trapnr = X86_TRAP_PF;
        else
                epcm_trapnr = X86_TRAP_GP;

        if (ret & ENCLS_FAULT_FLAG)
                return ENCLS_TRAPNR(ret) != epcm_trapnr;

        return !!ret;
}

I hope I've converted it correctly but I might've missed some corner
case...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
