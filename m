Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E182FC48BE5
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Jun 2021 16:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA33A613F5
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Jun 2021 16:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhFQQsG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhFQQsG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 17 Jun 2021 12:48:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D817C061574;
        Thu, 17 Jun 2021 09:45:58 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0eb200a2ba6960566addd7.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:b200:a2ba:6960:566a:ddd7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 01AC81EC056D;
        Thu, 17 Jun 2021 18:45:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1623948357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KFh/6rBf6SzM2VUxNtLAtGp5uhos/qKeopubwm+bLmY=;
        b=hf7bWtOuDWMMxOa8xQLjMoSg8RGz62emzpsmp6i3L/b3nrfmnH3p99YWsIlkM31i04PiuH
        dxQwZv2GUFnadx/X2HDWyAs5BNNly65+M8RlAEudjKFqDSdJH6t5Hqg/ksuvUzJaJG2RMR
        bGnNeUcWZTaDq7vjXeZXDsjF616GXJY=
Date:   Thu, 17 Jun 2021 18:45:46 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Du Cheng <ducheng2@gmail.com>
Subject: Re: [PATCH] x86/sgx: Suppress WARN on inability to sanitize EPC if
 ksgxd is stopped
Message-ID: <YMt8Orz6KdF3GqZv@zn.tnic>
References: <20210616004458.2192889-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210616004458.2192889-1-seanjc@google.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 15, 2021 at 05:44:58PM -0700, Sean Christopherson wrote:
> Don't WARN on having unsanitized EPC pages if ksgxd is stopped early,
> e.g. if sgx_init() realizes there will be no downstream consumers of EPC.
> If ksgxd is stopped early, EPC pages may be left on the dirty list, but
> that's ok because ksgxd is only stopped if SGX initialization failed or
> if the kernel is going down.  In either case, the EPC won't be used.
> 
> This bug was exposed by the addition of KVM support, but has existed and
> was hittable since the original sanitization code was added.  Prior to
> adding KVM support, if Launch Control was not fully enabled, e.g. when
> running on older hardware, sgx_init() bailed immediately before spawning
> ksgxd because X86_FEATURE_SGX was cleared if X86_FEATURE_SGX_LC was
> unsupported.
> 
> With KVM support, sgx_drv_init() handles the X86_FEATURE_SGX_LC check
> manually, so now there's any easy-to-hit case where sgx_init() will spawn
> ksgxd and _then_ fail to initialize, which results in sgx_init() stopping
> ksgxd before it finishes sanitizing the EPC.
> 
> Prior to KVM support, the bug was much harder to hit because it basically
> required char device registration to fail.
> 
> Reported-by: Du Cheng <ducheng2@gmail.com>
> Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Lightly tested due to lack of hardware.  I hacked the flow to verify that
> stopping early will leave work pending, and that rechecking should_stop()
> suppress the resulting WARN.
> 
>  arch/x86/kernel/cpu/sgx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index ad904747419e..fbad2b9625a5 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -425,7 +425,7 @@ static int ksgxd(void *p)
>  	__sgx_sanitize_pages(&sgx_dirty_page_list);
>  
>  	/* sanity check: */
> -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> +	WARN_ON(!list_empty(&sgx_dirty_page_list) && !kthread_should_stop());
>  
>  	while (!kthread_should_stop()) {
>  		if (try_to_freeze())
> -- 

Hmm, this looks weird. Why aren't we starting ksgxd only after
*everything* has initialized successfully? I.e., after both kvm and
native drivers' init functions have succeeded?

Then you won't have to do this kthread_should_stop() thing after the
fact.

Btw, you have the same thing in the while loop's termination condition
two lines down which, if I have to look at it later, would make me
scratch head as to what TH is going on here.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
