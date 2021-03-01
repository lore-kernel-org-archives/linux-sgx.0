Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B17C4332D
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Mar 2021 16:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4164464F5D
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Mar 2021 16:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhCAQZR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Mar 2021 11:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237440AbhCAQWJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Mar 2021 11:22:09 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC248C06178A
        for <linux-sgx@vger.kernel.org>; Mon,  1 Mar 2021 08:21:27 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id t9so11593131pjl.5
        for <linux-sgx@vger.kernel.org>; Mon, 01 Mar 2021 08:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jC2WGY5IvJY5a5GaOcvwnDc85miRJPUWJYADM2oq/Vk=;
        b=RSfR2jcli1GleHaRZ8Ny/9wJRvHkoiPuBTy1nY6AzKOBtnWAcufVR2eThF7uMxrbd4
         SvCGy1dGOjeYf1HhmCoDZ/EvKnYgXPaJYPk09YdEcK5qALeK9p9zLRJPHI4NGz4qN8ms
         iIQhskrnUrHIIPW4aFVFr73y6frsAPhkGyu/lEl+uSA7r9o3/c7VpFCC1UT9ZLDhRlmL
         yz95t6qu75srosy1wuCKPV6h/87XbLBQIYmx3PT02V5jXdJkEhnWYrEAtgDp9gWo2xPv
         rHE2an4zDaVV6jHhu4JXXCUykswbc7dAHz52xBG5cIT0iIKVoLves2rKVfJ3107CpL7K
         /ELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jC2WGY5IvJY5a5GaOcvwnDc85miRJPUWJYADM2oq/Vk=;
        b=Jj+s8RLMxr17MoPxC7CfyibyeibGWCVkovONV6HNp5kwTXw1xD9oNJp9fbbiPdrgwb
         8TDPDMxtMMV6YzVCfnYQgf0zGZd72/5UjKmI/+8vp0P7Eqvgf6Z23PfhLC9aIlfeB2ur
         p9FaaHJXZ6v4O9G0ysiLf5H1luk7U8SqH9PRdprLoH6b9ZdHqXdV1ssExA/5JwhZ6KHk
         mNHHQs/v5Y7IvNXWnd6NSGh6d0wvgStzC9ZVxytlUkvt88vRmyjXolA0GzxA4LbOUDsD
         cAoNacOn2/ChJyxtBx0RDZuuTZ9BL5AiHv82PtwszZYMH+jM81E+lh/5ZxReMHHmXy2j
         tIhw==
X-Gm-Message-State: AOAM5312DO+NvhQQk2dF2cC8CtvL6Adgtacq8DEFlMIiJvsynCjU/Wcn
        jexXp1u2FRfPvK2YG8YuRQtWzQ==
X-Google-Smtp-Source: ABdhPJzDK3rT//fSp8J4fsSDT5s0A4TeJiUbKdNYMYyEOict+tnCU+C6QCR6dpG7EgSBrxC7OgBIEg==
X-Received: by 2002:a17:902:c582:b029:e4:c16d:b5eb with SMTP id p2-20020a170902c582b02900e4c16db5ebmr1867568plx.6.1614615686845;
        Mon, 01 Mar 2021 08:21:26 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id z22sm18134271pfa.41.2021.03.01.08.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 08:21:26 -0800 (PST)
Date:   Mon, 1 Mar 2021 08:21:19 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-ID: <YD0Uf1LS4jDlXGLo@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
 <aade4006c3474175f97ec149a969eb02f1720a89.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aade4006c3474175f97ec149a969eb02f1720a89.1614590788.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 01, 2021, Kai Huang wrote:
> +	/*
> +	 * SECS pages are "pinned" by child pages, an unpinned once all

s/an/and

> +	 * children have been EREMOVE'd.  A child page in this instance
> +	 * may have pinned an SECS page encountered in an earlier release(),
> +	 * creating a zombie.  Since some children were EREMOVE'd above,
> +	 * try to EREMOVE all zombies in the hopes that one was unpinned.
> +	 */
> +	mutex_lock(&zombie_secs_pages_lock);
> +	list_for_each_entry_safe(epc_page, tmp, &zombie_secs_pages, list) {
> +		/*
> +		 * Speculatively remove the page from the list of zombies,
> +		 * if the page is successfully EREMOVE it will be added to
> +		 * the list of free pages.  If EREMOVE fails, throw the page
> +		 * on the local list, which will be spliced on at the end.
> +		 */
> +		list_del(&epc_page->list);
> +
> +		if (sgx_vepc_free_page(epc_page))
> +			list_add_tail(&epc_page->list, &secs_pages);
> +	}
> +
> +	if (!list_empty(&secs_pages))
> +		list_splice_tail(&secs_pages, &zombie_secs_pages);
> +	mutex_unlock(&zombie_secs_pages_lock);
> +
> +	kfree(vepc);
> +
> +	return 0;
> +}
