Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A01C433F5
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Sep 2021 15:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24F7E61101
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Sep 2021 15:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349632AbhICPbD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Sep 2021 11:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349658AbhICPbC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 3 Sep 2021 11:31:02 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D096CC061757
        for <linux-sgx@vger.kernel.org>; Fri,  3 Sep 2021 08:30:02 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s11so5852773pgr.11
        for <linux-sgx@vger.kernel.org>; Fri, 03 Sep 2021 08:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LHKYiZn1enaTL529IiH4EK/EtyfMkn7nwZWISrjiVhY=;
        b=M1hmIwSk2NFKnJOJ4Vgu+iHShzORT6dJIsRIp8JdNkhiOnx2AJdQ1bkLFvHmd8erXR
         KkANKbXwH/nLCgfjJR+XdN4Jcz7MNqpUzimseDcRtOhZ1dRfny7IUbMDN5inYeqVeSIf
         SFZ+Bn9jZYos1uBn7NfjX+9IVYRANzhTkx/CkkBbPMZ/PBTYfC6m7LCrUXZLfytVM1ZE
         bLYhwqg93Sn4s3Dv4Qu8R6gz96gztgR9EaYlTl1E4ZXcpjy73MQtMev4u0mXTg0cqNAp
         cehbFesspteHPSp9wOB8WwJZ+ucJqg3z7PQbmAIbsBMxBb49ku5JDs226YWY7WOPbaVs
         Q4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LHKYiZn1enaTL529IiH4EK/EtyfMkn7nwZWISrjiVhY=;
        b=PwY0+HXjc79VgYOc4uN14K8X3fuGN8/mPLJPM/438J8WCO20OfeESInL6Htkai4OoK
         c1ChaBrMITTP5wUTiMnjtjT5/XIdmi32KtMy4tXctRHrvMgfXD/TDkXDp9L2JrSQJdTH
         pyNyqTRcKqATICcRIb3UMPVN1YBCsG7YgHaYZt6Y5grxaw62zLkrD1ExKyIc/y/3yWTB
         hxLw8Mc6uTh5TybboJZaEgJKVVfdL/jIjI+uZprwaTk0qM2WxWajYpNgGw4ZUg2JOqR1
         tsQfQwMWln02B3VAf00Zm0rJ8qAGh5+CG6XIeZVqmUdHDjhW0SDuVRVqpyv+7F+sfosT
         JSbw==
X-Gm-Message-State: AOAM532dbRjwLqdpX0obQPHwrO+oT5YXedXTmBpz2AJvT19x/nPrRr+A
        nj9t67v58Jmoch8zpK+YL4UUYg==
X-Google-Smtp-Source: ABdhPJwMBaYVLR8cXvB6Z+9aj4+MXUcCaIeCuQlghLG74c5rWCjeRc3NgQRo85XQweiL3iOtRfcUEg==
X-Received: by 2002:a65:6a46:: with SMTP id o6mr4043496pgu.139.1630683002030;
        Fri, 03 Sep 2021 08:30:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h7sm619948pfe.125.2021.09.03.08.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 08:30:01 -0700 (PDT)
Date:   Fri, 3 Sep 2021 15:29:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Declare sgx_set_attribute() for !CONFIG_X86_SGX
Message-ID: <YTI/dTORBZEmGgux@google.com>
References: <20210903064156.387979-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903064156.387979-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 03, 2021, Jarkko Sakkinen wrote:
> Simplify sgx_set_attribute() usage by declaring a fallback
> implementation for it rather than requiring to have compilation
> flag checks in the call site. The fallback unconditionally returns
> -EINVAL.
> 
> Refactor the call site in kvm_vm_ioctl_enable_cap() accordingly.
> The net result is the same: KVM_CAP_SGX_ATTRIBUTE causes -EINVAL
> when kernel is compiled without CONFIG_X86_SGX_KVM.

Eh, it doesn't really simplify the usage.  If anything it makes it more convoluted
because the capability check in kvm_vm_ioctl_check_extension() still needs an
#ifdef, e.g. readers will wonder why the check is conditional but the usage is not.

> Cc: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/x86/include/asm/sgx.h | 8 ++++++++
>  arch/x86/kvm/x86.c         | 2 --
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 05f3e21f01a7..31ee106c0f4b 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -372,7 +372,15 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
>  		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
>  #endif
>  
> +#ifdef CONFIG_X86_SGX
>  int sgx_set_attribute(unsigned long *allowed_attributes,
>  		      unsigned int attribute_fd);
> +#else
> +static inline int sgx_set_attribute(unsigned long *allowed_attributes,
> +				    unsigned int attribute_fd)
> +{
> +	return -EINVAL;
> +}
> +#endif
>  
>  #endif /* _ASM_X86_SGX_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..a6a27a8f41eb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5633,7 +5633,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			kvm->arch.bus_lock_detection_enabled = true;
>  		r = 0;
>  		break;
> -#ifdef CONFIG_X86_SGX_KVM
>  	case KVM_CAP_SGX_ATTRIBUTE: {
>  		unsigned long allowed_attributes = 0;
>  
> @@ -5649,7 +5648,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			r = -EINVAL;
>  		break;
>  	}
> -#endif
>  	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
>  		r = -EINVAL;
>  		if (kvm_x86_ops.vm_copy_enc_context_from)
> -- 
> 2.25.1
> 
