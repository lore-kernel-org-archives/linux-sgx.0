Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3913C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 08:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80FE32072E
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 08:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="VC01qKk3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389567AbgFYI7k (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 04:59:40 -0400
Received: from mail.skyhub.de ([5.9.137.197]:59440 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389430AbgFYI7k (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 04:59:40 -0400
Received: from zn.tnic (p200300ec2f0ed10059a0945b2d1dc694.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:d100:59a0:945b:2d1d:c694])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 697551EC0220;
        Thu, 25 Jun 2020 10:59:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593075578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rObu+L/lbl0DmC4rLxAJmp4yw0uI7VSyZYWkbmQZLlc=;
        b=VC01qKk3xbxxEtMBmhvvd3+fZchSJ8r+9RhuLzxkipm0dHSCR6jAeTlRc8SNiPyQfhmU7p
        InaYXnEYc3ajYiyVS2854IXmr9hMoRB3601Zp6AJ3x9TbCDHhqj8jcGNuqaWyMeaL4U4FN
        2Yxq3MCvxUMoVA+IFfoQ2EKG1oaBhD0=
Date:   Thu, 25 Jun 2020 10:59:31 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 03/21] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20200625085931.GB20319@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-4-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200617220844.57423-4-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 18, 2020 at 01:08:25AM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Include SGX bit to the PF error codes and throw SIGSEGV with PF_SGX when
> a #PF with SGX set happens.
> 
> CPU throws a #PF with the SGX bit in the event of Enclave Page Cache Map
				   ^
				   set

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
			    ^
			    to				   recreate

> enclave, which was invalidated).
> 
> [1] Intel SDM: 36.5.1 Enclave Page Cache Map (EPCM)
> 
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/asm/traps.h |  1 +
>  arch/x86/mm/fault.c          | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index 714b1a30e7b0..ee3617b67bf4 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -58,5 +58,6 @@ enum x86_pf_error_code {
>  	X86_PF_RSVD	=		1 << 3,
>  	X86_PF_INSTR	=		1 << 4,
>  	X86_PF_PK	=		1 << 5,
> +	X86_PF_SGX	=		1 << 15,

Needs to be added to the doc above it.

>  #endif /* _ASM_X86_TRAPS_H */
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 66be9bd60307..25d48aae36c1 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1055,6 +1055,19 @@ access_error(unsigned long error_code, struct vm_area_struct *vma)
>  	if (error_code & X86_PF_PK)
>  		return 1;
>  
> +	/*
> +	 * Access is blocked by the Enclave Page Cache Map (EPCM), i.e. the
> +	 * access is allowed by the PTE but not the EPCM. This usually happens
> +	 * when the EPCM is yanked out from under us, e.g. by hardware after a
> +	 * suspend/resume cycle. In any case, software, i.e. the kernel, can't
> +	 * fix the source of the fault as the EPCM can't be directly modified by
> +	 * software. Handle the fault as an access error in order to signal
> +	 * userspace so that userspace can rebuild their enclave(s), even though
> +	 * userspace may not have actually violated access permissions.
> +	 */

Lemme check whether I understand this correctly: userspace must check
whether the SIGSEGV is generated on an access to an enclave page?

Also, do I see it correctly that when this happens, dmesg will have

        printk("%s%s[%d]: segfault at %lx ip %px sp %px error %lx",

due to:

       if (likely(show_unhandled_signals))
               show_signal_msg(regs, error_code, address, tsk);

which does:

        if (!unhandled_signal(tsk, SIGSEGV))
                return;

or is the task expected to register a SIGSEGV handler so that the
segfault doesn't land in dmesg?

If so, are we documenting this?

If not, then we should not issue any "segfault" messages to dmesg
because that would be wrong.

Or maybe I'm not seeing it right but I don't have the hardware to test
this out...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
