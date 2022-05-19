Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5422EC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 19 May 2022 05:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiESFgU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 May 2022 01:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiESFgU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 19 May 2022 01:36:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A98B29839
        for <linux-sgx@vger.kernel.org>; Wed, 18 May 2022 22:36:18 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i17-20020a259d11000000b0064cd3084085so3513082ybp.9
        for <linux-sgx@vger.kernel.org>; Wed, 18 May 2022 22:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+mOeU0zYyZNrut5u+oizuXhzDSBpVolUtmDQznpEMWY=;
        b=Lof6YSPulz06XaUmNrUy0S7pXdV6ehb+LARBONQnDxR9M9zg9jXWhZ8hCJZmQf8s9f
         v+25Szh4he0Bky19+3CVNKakFy65IR7KO0+jB+Ex/vItcV9RwbVbvjH2A5e2/OE/x4k4
         N55kjd827z4uYRiC+/sV8O/PtldTZzs+8eq6kSg/ytpAhebqCQI17u4vZ1h3u8huxetw
         uqcVnmwyGecNdoS9OkxrC8SiIu9G3KQyqUPN6oavhb6RxpAcvEJyHFyvviq2HH+eNrRJ
         MJ29LdBxKOOFwOHXkXlpHnm2GegaoZzvXBLyAvl9p9vQ3+h0UqXiggjjlAfXkgG2JJr3
         CMfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+mOeU0zYyZNrut5u+oizuXhzDSBpVolUtmDQznpEMWY=;
        b=0BB2QV4nykjaKvrDR1SRNBG0BHMAkwu5nnxaRSyID+9xrReZBODdcCgYBIabPsZysA
         clenvnBJjm/tfpQ3lkXHNNG+TDZG3B4GNBWzXREEKLVueo4FT4nQQ8Pvod9Zw27LmpLd
         2DbH4+ugcoS/FzI63kIUBoDKYZ6RhNBRtsrMZ1X+QeCsW5fasVCIJmpzPcCEygQiyDe/
         Onz8IIQJnUmA1eXPr5ZzEW6eBNzha1LOgc0SlRJP41/2kLou9cmbKwWBTFxJLndutGeB
         opM1qUKSNTW27GONF7p0MiIxEdtmbZJUuc3w+AM1Ua3dm6Zw5vZav19XwXnmH53ltVCe
         NV+A==
X-Gm-Message-State: AOAM531DxnQpc3yQGvdULuutuqp9js3iD90NmWoCuUU1Eaqrv2npS1Nf
        aFMRC/kEBBLC1qrdrD+PAlXIy7UfnjY7gw==
X-Google-Smtp-Source: ABdhPJwbIxmVNXNi5PAO0LjjYUs6ekZ3dNU6Pl9cHr6CHypPt7Y1BaKjX5Y+Xl8T522BNsfZhbLJlHsqNDB1rA==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:28b])
 (user=shakeelb job=sendgmr) by 2002:a5b:dcd:0:b0:64e:2365:69a8 with SMTP id
 t13-20020a5b0dcd000000b0064e236569a8mr2660064ybr.254.1652938577861; Wed, 18
 May 2022 22:36:17 -0700 (PDT)
Date:   Thu, 19 May 2022 05:36:15 +0000
In-Reply-To: <20220517164713.4610-1-kristen@linux.intel.com>
Message-Id: <20220519053615.zqwecsooceqzwjdf@google.com>
Mime-Version: 1.0
References: <20220517164713.4610-1-kristen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Set active memcg prior to shmem allocation
From:   Shakeel Butt <shakeelb@google.com>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 17, 2022 at 09:47:13AM -0700, Kristen Carlson Accardi wrote:
>  
[...]
> +int sgx_encl_alloc_backing(struct sgx_encl *encl, unsigned long page_index,
> +			   struct sgx_backing *backing)
> +{
> +	struct mem_cgroup *old_memcg;
> +	int ret;
> +
> +	old_memcg = sgx_encl_set_active_memcg(encl);

This function is leaking memcg reference. Please change
sgx_encl_set_active_memcg() to sgx_encl_get_mem_cgroup() or something
which will return the memcg with the refcount elevated. Then use
set_active_memcg(returned_memcg) here.

> +
> +	ret = sgx_encl_get_backing(encl, page_index, backing);
> +
> +	set_active_memcg(old_memcg);

mem_cgroup_put(returned_memcg) here.

> +
> +	return ret;
> +}
