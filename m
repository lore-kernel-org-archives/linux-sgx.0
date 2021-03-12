Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3766CC433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A34264DFB
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbhCLV7A (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Mar 2021 16:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbhCLV6t (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 12 Mar 2021 16:58:49 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C494CC061574
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:58:48 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gb6so5803169pjb.0
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4OFD8awhbCRVBvVU9tfirA58NlHooGhkMV6gA+cq84s=;
        b=tDMJxJ5FrubHWo19Sz0IePFOH5w/q6dR0/vttN27lil10pm+qsTDmK6HgZ7IE/pWFQ
         SVtvUn/DFot9H4uNZQc0/XT36tF3V4Y/LTsowBWud9C0+po1q0rzhjNts/UuxPq9545H
         3DFdopnfFKvRyLblthSXmV6qnWT+i4x4kAQ3pdaE1TVAQvldKvkP2dSZAi4WuDB7gVt2
         KPHHDOdF+OP4e3K9NegPDL29eJ0mVs2/iFaC+Ae6CluYLKKSUpzz31snkZDi2Rin9Fv5
         xHg4gqLKxBcZGbKuGwuMoAN6TGb4tBC0UuQC610M4J2Eq6HMXvmUNQWKc9310/6ZO3Lq
         RuOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4OFD8awhbCRVBvVU9tfirA58NlHooGhkMV6gA+cq84s=;
        b=hcNhXCAITBUoVEjlXUthWFdCYbqHP/qlhCs77HTmI2AN9utBoZf4tB6FcsVD+Dtf26
         QnN1ak21MChbjrJ44EcPvQ4ksLUpVo5fKuK8pUGZTugDyHpYmIWqUpil8AB3fw8aQ/bv
         lQKME47auI9hPo0iCkRz0whmWNTRDgGQzGuugnoqR2UTPBuZWAKsyOJWqJY5LIxyhG2N
         Xwz1Eu2+FAWkMpg4hEpmRDQBreaal9tycYAOtRuiDfHjJx0dmdWymkzoMuvX8JEBsnZ5
         z46dUuiRq6rBzLZCprdNJb0dLk0DUuqmU0KUk20RWchhGLIsxRelS8VY1TFzLkBKdZ3K
         jQCw==
X-Gm-Message-State: AOAM532y+gNvPsC942aUgXHT6sJKDeTlmlJ8Y19G7oUIUrKBfOzCzH5c
        ARPXiMpbcGMvoQUaVIdfZkl9Tg==
X-Google-Smtp-Source: ABdhPJzGp7R9OzNgnOWxM+HqJ9PI2076zNWqVW9t/2x1zcXK8tqTZxAJLrk8vfyoxVmx+X/WqMkFFw==
X-Received: by 2002:a17:90a:fd0b:: with SMTP id cv11mr332099pjb.183.1615586328229;
        Fri, 12 Mar 2021 13:58:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id w2sm6540983pgh.54.2021.03.12.13.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:58:47 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:58:40 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 08/25] x86/sgx: Expose SGX architectural definitions
 to the kernel
Message-ID: <YEvkEJkM0D7oZWE3@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
 <b60e1d665c17ed6430166d659bd0f547a53aea0f.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b60e1d665c17ed6430166d659bd0f547a53aea0f.1615250634.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 09, 2021, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Expose SGX architectural structures, as KVM will use many of the
> architectural constants and structs to virtualize SGX.
> 
> Name the new header file as asm/sgx.h, rather than asm/sgx_arch.h, to
> have single header to provide SGX facilities to share with other kernel
> componments.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>

Same checkpatch warning.  Probably doesn't matter.

> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  .../cpu/sgx/arch.h => include/asm/sgx.h}      | 20 ++++++++++++++-----
>  arch/x86/kernel/cpu/sgx/encl.c                |  2 +-
>  arch/x86/kernel/cpu/sgx/sgx.h                 |  2 +-
>  tools/testing/selftests/sgx/defines.h         |  2 +-
>  4 files changed, 18 insertions(+), 8 deletions(-)
>  rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx.h} (95%)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/include/asm/sgx.h
> similarity index 95%
> rename from arch/x86/kernel/cpu/sgx/arch.h
> rename to arch/x86/include/asm/sgx.h
> index abf99bb71fdc..d4ad35f6319a 100644
> --- a/arch/x86/kernel/cpu/sgx/arch.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -2,15 +2,20 @@
>  /**
>   * Copyright(c) 2016-20 Intel Corporation.
>   *
> - * Contains data structures defined by the SGX architecture.  Data structures
> - * defined by the Linux software stack should not be placed here.
> + * Intel Software Guard Extensions (SGX) support.
>   */
> -#ifndef _ASM_X86_SGX_ARCH_H
> -#define _ASM_X86_SGX_ARCH_H
> +#ifndef _ASM_X86_SGX_H
> +#define _ASM_X86_SGX_H
>  
>  #include <linux/bits.h>
>  #include <linux/types.h>
>  
> +/*
> + * This file contains both data structures defined by SGX architecture and Linux
> + * defined software data structures and functions.  The two should not be mixed
> + * together for better readibility.  The architectural definitions come first.
> + */
> +
>  /* The SGX specific CPUID function. */
>  #define SGX_CPUID		0x12
>  /* EPC enumeration. */
> @@ -337,4 +342,9 @@ struct sgx_sigstruct {
>  
>  #define SGX_LAUNCH_TOKEN_SIZE 304
>  
> -#endif /* _ASM_X86_SGX_ARCH_H */
> +/*
> + * Do not put any hardware-defined SGX structure representations below this
> + * line!

Heh, which line?  Yep, it's Friday afternoon...

> + */
