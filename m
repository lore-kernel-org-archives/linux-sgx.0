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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD24C4361B
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Dec 2020 19:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24EB222581
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Dec 2020 19:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440684AbgLNTCj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Dec 2020 14:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441011AbgLNTCU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 14 Dec 2020 14:02:20 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AB0C0613D3
        for <linux-sgx@vger.kernel.org>; Mon, 14 Dec 2020 11:01:40 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id b5so7193013pjl.0
        for <linux-sgx@vger.kernel.org>; Mon, 14 Dec 2020 11:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1kWGK0RczIOp+iVj83yQa4txxLqHCI2JyPCYLhw6aOc=;
        b=IW+b3fPAjrIiAyPxL8E1L3EkTc/tR/a3T8Sy0RT3363v51GzUV5oPr1UI8+DnrlBxq
         St9/drNjy7O9xsFp5+qK1zNcY7x8yjrhajfAVpVVgf6jW8Zlr5LVW4zTSNwnQBOk2IB0
         LF3pMIr5Iyt5KPecOQKlpx0tQF2nNA3e6Np16Pv91yeTs+BqPcvjW1p7QedlUe8s4+XK
         VtLxe+luT8Rls5RmhxvpteD0wFKihWdi4WTRsmVZvIlBiUjk72RQEbxU3hp9klM3TghG
         H6ZsA+oFqQnPb2oI2gRKpyC15lGjpR9+e3CBsQvlxDQD5imXYENxb3MBiynJOa+aVZpV
         Srfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1kWGK0RczIOp+iVj83yQa4txxLqHCI2JyPCYLhw6aOc=;
        b=cj2OziVlHy6+0FrDIS3dox8ts4B4b0+0r7omsCRmChO70EQHxDrwvKjZHfvGYaTTZw
         MX+TKrKc1J5FafDmZbbjeObcGhLY9Wez2jTW+MqYRR1WC/ZobXmzAGltAhofP+AOYzrl
         FoY3Ao9eHRrfIo8IIdjIdFKaf7rY6UFX+lCkLo/E17Gu56kFuyZFfxJoQJ4HRGCUXnId
         8DxuzPAondbocq/snFlokhHzsh1Y2c/C7rmWQK+C4059Bq8t8+7vL1I4QadxbeGO97wG
         izpeT8sRWDilDTaQyfSAqvu8EeRrc47qzqDVMgqZ13SZUC2e5WzB6PWDNWYb3oeOwrKA
         yi/Q==
X-Gm-Message-State: AOAM533Ajn3TIXjjlws5mcMyKuSlMjGuw0MIZYfljgkXjoUdnXmL1Di0
        MMppEcMQRC2of/Nk25LAz09Pew==
X-Google-Smtp-Source: ABdhPJzraNIBSIy+w0M5cqMA9btGHAYdNbSsyVAmIQl/cbkk91bRRZyEK/1b//gmtkxzZwpCP8NQFw==
X-Received: by 2002:a17:90a:d307:: with SMTP id p7mr26891434pju.214.1607972499565;
        Mon, 14 Dec 2020 11:01:39 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id b13sm4727079pfi.162.2020.12.14.11.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 11:01:38 -0800 (PST)
Date:   Mon, 14 Dec 2020 11:01:32 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <X9e2jOWz1hfXVpQ5@google.com>
References: <20201211113230.28909-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211113230.28909-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 11, 2020, Jarkko Sakkinen wrote:
> Each sgx_mmun_notifier_release() starts a grace period, which means that

Should be sgx_mmu_notifier_release(), here and in the comment.

> one extra synchronize_rcu() in sgx_encl_release(). Add it there.
> 
> sgx_release() has the loop that drains the list but with bad luck the
> entry is already gone from the list before that loop processes it.

Why not include the actual analysis that "proves" the bug?  The splat that
Haitao reported would also be useful info.

> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Reported-by: Sean Christopherson <seanjc@google.com>

Haitao reported the bug, and for all intents and purposes provided the fix.  I
just did the analysis to verify that there was a legitimate bug and that the
synchronization in sgx_encl_release() was indeed necessary.

> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index ee50a5010277..48539a6ee315 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -438,6 +438,13 @@ void sgx_encl_release(struct kref *ref)
>  	if (encl->backing)
>  		fput(encl->backing);
>  
> +	/*
> +	 * Each sgx_mmun_notifier_release() starts a grace period. Thus one
> +	 * "extra" synchronize_rcu() is required here. This can go undetected by
> +	 * sgx_release() when it drains the mm list.
> +	 */
> +	synchronize_srcu(&encl->srcu);
> +
>  	cleanup_srcu_struct(&encl->srcu);
>  
>  	WARN_ON_ONCE(!list_empty(&encl->mm_list));
> -- 
> 2.27.0
> 
