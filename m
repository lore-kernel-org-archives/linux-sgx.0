Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09ADC48BE5
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Jun 2021 06:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D438F613BF
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Jun 2021 06:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhFPGFV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Jun 2021 02:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhFPGFV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 16 Jun 2021 02:05:21 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1740C061574;
        Tue, 15 Jun 2021 23:03:14 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id g6so1333619pfq.1;
        Tue, 15 Jun 2021 23:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/o2SwDIVJgGnKgQ3WXZqgj/1RbxNUK13ChH6AkxAuUI=;
        b=MTd1zaIhz3xvuaeEBCMMGN48Er9lGN3XzYwwpjHMxQ7OxPlEbaK6VONIkK5r3CiVU+
         mSAYrIOnqxFzN7dj6MyXIJrcruWjX9hxWOFjyxIn7H2jRMRdxyByQtJDbB4dCPu3ARJe
         us+1vqXmv00waDEs/tfqjMm0qqpTdR5JvuVOMya9YQT4q9G5lUehnBDrAJdiP9DcW9Q+
         71gajVZ2DI0k9cIt5icqZQydDD5BjnknBVsOPmw5eRmJqxLMHsEfmjDx8H8mv5EOriVx
         BhI9r9Jhh+ZB3GoC3Aw7Ug7Z0p4QkcBdtBM3+mMapr18vlYg+X60G2sLisRyk3Xhpuvj
         5RRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/o2SwDIVJgGnKgQ3WXZqgj/1RbxNUK13ChH6AkxAuUI=;
        b=NFkFXLtDTrrPenqRyMa2/PlSThvdWlX41Zv54+lX6/jcMRQa/s3t9sfxk3ra3PnS2V
         SJmRmte7YAmsDDrtGMonEGYH3t/UIUshi3BJtvw2A6wlyBiaJOZ676bDodLUQzDMqTk0
         jBLFtfXLy+fnZ6yGZLYuAxPpujdfJ9tU6aSC8gcZBtqpq+8+vA8Gm15u0KFiqJTfpkwG
         kJO57guwx4qlSOOP5P/U9u55tSyGbXtReAoJzdF3R03Qf7NBEdtXjtrYbHgAwNEYsQzQ
         IeNCQFsSXhWzRUnNCsgiF29b/mvRepCwbUu/wFNUW/huAyttWx9UUuR781pVRDkooekN
         msnw==
X-Gm-Message-State: AOAM531tv2QgoiLEh0hhlUe671y7iMwK1rVFwWCNJZ86337FI7IYTg+w
        xAX8nYSg7dZRwJ53/gAx6fk=
X-Google-Smtp-Source: ABdhPJzMbpYhpE2ej8kXe4T3Iv5+EnFOo8hEQypBdHiU1jDX0v29oNvIcUJt2b6lRnRE25tdoUj1Dg==
X-Received: by 2002:a63:e64a:: with SMTP id p10mr3358177pgj.424.1623823394365;
        Tue, 15 Jun 2021 23:03:14 -0700 (PDT)
Received: from nuc ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id b21sm1024984pgj.74.2021.06.15.23.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 23:03:13 -0700 (PDT)
Date:   Wed, 16 Jun 2021 14:03:09 +0800
From:   Du Cheng <ducheng2@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Suppress WARN on inability to sanitize EPC if
 ksgxd is stopped
Message-ID: <YMmUHRGwXSIYJTDf@nuc>
References: <20210616004458.2192889-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210616004458.2192889-1-seanjc@google.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Le Tue, Jun 15, 2021 at 05:44:58PM -0700, Sean Christopherson a écrit :
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
> 2.32.0.272.g935e593368-goog
> 

I applied this patch on 5.13-rc6, and it no longer causes to trigger WARN_ON()
on my NUC:

```

[    0.669411] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.669412] software IO TLB: mapped [mem 0x0000000017cb9000-0x000000001bcb9000] (64MB)
[    0.672788] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.672805] sgx: EPC section 0x30200000-0x35f7ffff
[    0.674239] Initialise system trusted keyrings
[    0.674254] Key type blacklist registered

```

Regards,
Du Cheng
