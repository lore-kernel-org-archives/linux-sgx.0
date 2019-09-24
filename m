Return-Path: <SRS0=S/Hi=XT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B85C432C1
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 16:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F5D2168B
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 16:04:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="ff/YhN34"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391509AbfIXQEn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Sep 2019 12:04:43 -0400
Received: from mail.skyhub.de ([5.9.137.197]:60798 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391013AbfIXQEn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Sep 2019 12:04:43 -0400
Received: from zn.tnic (p200300EC2F0DB700CDA5DCD899733FA6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:b700:cda5:dcd8:9973:3fa6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 50C9B1EC067D;
        Tue, 24 Sep 2019 18:04:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569341082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=B65A+4m2oOkrdOYhHvIUF/+WeMZC/CwF40XD3ZWO76o=;
        b=ff/YhN34wwlnqB0jOpcUhTUPwOU7CjnP7rjUYW9LF59y1ukJeOYLRdHjJQ4b0FnuKWHfbL
        XeIiVlFy9spVsRlSev5rnAUXwZtpEbgCMufoytjtV3p/T4qClxPUPJiybzhsBbd9PwJ/cP
        R21px6jw4ed3uQbEYgo2o5OVGp/q+20=
Date:   Tue, 24 Sep 2019 18:04:42 +0200
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
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v22 03/24] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20190924160442.GH19317@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-4-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190903142655.21943-4-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 03, 2019 at 05:26:34PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Include SGX bit to the PF error codes and throw SIGSEGV with PF_SGX when
> a #PF with SGX set happens.
> 
> CPU throws a #PF with the SGX bit in the event of Enclave Page Cache Map
> (EPCM) conflict. The EPCM is a CPU-internal table, which describes the
> properties for a enclave page. Enclaves are measured and signed software
> entities, which SGX hosts. [1]
> 
> Although the primary purpose of the EPCM conflict checks  is to prevent
> malicious accesses to an enclave, an illegit access can happen also for
> legit reasons.
> 
> All SGX reserved memory, including EPCM is encrypted with a transient
> key that does not survive from the power transition. Throwing a SIGSEGV
> allows user space software react when this happens (e.g. rec-create the
> enclave, which was invalidated).
> 
> [1] Intel SDM: 36.5.1 Enclave Page Cache Map (EPCM)
> 
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/asm/traps.h |  1 +
>  arch/x86/mm/fault.c          | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index b25e633033c3..81472cae4024 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -171,5 +171,6 @@ enum x86_pf_error_code {
>  	X86_PF_RSVD	=		1 << 3,
>  	X86_PF_INSTR	=		1 << 4,
>  	X86_PF_PK	=		1 << 5,
> +	X86_PF_SGX	=		1 << 15,
>  };
>  #endif /* _ASM_X86_TRAPS_H */
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 9ceacd1156db..c2dea3f9e263 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1178,6 +1178,19 @@ access_error(unsigned long error_code, struct vm_area_struct *vma)
>  	if (error_code & X86_PF_PK)
>  		return 1;
>  
> +	/*
> +	 * Access is blocked by the Enclave Page Cache Map (EPCM), i.e. the
> +	 * access is allowed by the PTE but not the EPCM.  This usually happens
> +	 * when the EPCM is yanked out from under us, e.g. by hardware after a
> +	 * suspend/resume cycle.  In any case, software, i.e. the kernel, can't
> +	 * fix the source of the fault as the EPCM can't be directly modified
> +	 * by software.  Handle the fault as an access error in order to signal
> +	 * userspace, e.g. so that userspace can rebuild their enclave(s), even

s/, e.g.//

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
