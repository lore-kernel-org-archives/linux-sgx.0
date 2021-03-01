Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3FBC433DB
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Mar 2021 17:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 775E0650F1
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Mar 2021 17:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbhCAQ7b (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Mar 2021 11:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbhCAQ55 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Mar 2021 11:57:57 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B87C06178C
        for <linux-sgx@vger.kernel.org>; Mon,  1 Mar 2021 08:57:14 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w18so11905380pfu.9
        for <linux-sgx@vger.kernel.org>; Mon, 01 Mar 2021 08:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uSzfJ/93YMknjPDz4PQh9DdYSErIJ1NNCgMgGR8WQnk=;
        b=Fx/29T8n9gPHuTiUoMGejmlBgDnStMl7VqnjLeAMCkhNZNdNhrrLidNaIeTH1pnieR
         +6+TlTt9mH5E8D4hgHJKQYBqJ3iCSK+0+RUIEVFPg5AgWfrmm+bhDs3jagIWurja2Y2Q
         dlyVbE5gU82jKsuLsjfqPPr3MQRDnNsP7lmTX6LVmc6uV6Jb/NZMyC68qCbotrSaSq9Y
         jAyOzoqWtteKwF9Sr/eKbeBzux3jt7JJhNgyFsyyxHWQ4KTVRQZQzqJpsuTr+8bP13fT
         K5CxXHW/1x88TX2W1Zz8ognjItQ94B/GF+NQQfovnpr7J1bapGOwic+9kj69K1J8ZNUz
         FNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uSzfJ/93YMknjPDz4PQh9DdYSErIJ1NNCgMgGR8WQnk=;
        b=gSSorimjPsbm5HMTsO3rLTeC97LoxCMKd1kKDqQ3E5r9ogg4/Wwm5F1mG7D1gwB6ZO
         zQ8XRXlqQeyTvBDuqioFvNtbcyUWkxWLrW3K+iyrN9NpVNf1U/6iakmJf0CBhE5cKcms
         mZBywH0aO9fT/vTehekovPGEcdOom+ECXkcCGg/0d8JGf3Dyf1htUZ94zYJYoj+hdE2g
         TR7RWZfzkuxnK8A7gTg84CaqdbEMdso1MIKOdv1mYhTqbwJ5RY6te3rWL/0cIn2Fg3G9
         4v53zPf3qqMD7laVXj0xXBBf9dOKSdceRHfpbFYGx/ofVFe8WIh7ertX60edBhjef0Bj
         DqJg==
X-Gm-Message-State: AOAM531B+vO1W0hft0BVmvlM4XMmMF81AxXWQGeHmfuxIhXivKQwsgY4
        +UDa3/T7BofG12SzpsnpGj1Ayg==
X-Google-Smtp-Source: ABdhPJy1kElmhwp8IZJODrLqbmCcdia6P1qMdzbtc4xrPIUFjBNDMIL/CpnUSfDz+MJCygAto620rQ==
X-Received: by 2002:aa7:8ad5:0:b029:1df:5a5a:80e1 with SMTP id b21-20020aa78ad50000b02901df5a5a80e1mr15913031pfd.52.1614617833999;
        Mon, 01 Mar 2021 08:57:13 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id c4sm11339613pfo.2.2021.03.01.08.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 08:57:13 -0800 (PST)
Date:   Mon, 1 Mar 2021 08:57:06 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 12/25] x86/sgx: Add helper to update SGX_LEPUBKEYHASHn
 MSRs
Message-ID: <YD0c4rEAbx2y5CXT@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
 <6730fbd2f7b26532f09e5a5e416a58f03a66d222.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6730fbd2f7b26532f09e5a5e416a58f03a66d222.1614590788.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 01, 2021, Kai Huang wrote:
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 8c922e68274d..276220d0e4b5 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -696,6 +696,21 @@ static bool __init sgx_page_cache_init(void)
>  	return true;
>  }
>  
> +
> +/*
> + * Update the SGX_LEPUBKEYHASH MSRs to the values specified by caller.
> + * Bare-metal driver requires to update them to hash of enclave's signer
> + * before EINIT. KVM needs to update them to guest's virtual MSR values
> + * before doing EINIT from guest.
> + */
> +void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
> +{
> +	int i;

Probably worth adding:

	WARN_ON_ONCE(preemptible());

> +
> +	for (i = 0; i < 4; i++)
> +		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
> +}
> +
>  static int __init sgx_init(void)
>  {
>  	int ret;
