Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D025CC433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 995CE64F89
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 21:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhCLVKV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Mar 2021 16:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235140AbhCLVKT (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 12 Mar 2021 16:10:19 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B08AC061761
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:10:19 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id b23so2696013pfo.8
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 13:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pAFjvyG2BbuTR3wtn+p9SqjjHJsHfZYBaKEIukNmkVY=;
        b=vc6FxzbYVVZjdJEOtsXsduPQatLfiaVPUx7lsOMuWZRohiMgayTvLyeV0MwzdexptK
         Bm7Vc9Au744meaK5aoM+NFWSf8U+JGpmsaD445FNT5K1mQiBDhIeJgdCw5AL+rShRVPy
         752uzcppiFQZa6/ExdAzCZp8TnMbPQAH6uXQyeZlZKEVfzTp7Lg0iqLaqSzDJy0v5KzE
         OkPackqgyz9EWoFSsQFavX3gYpLEv4l/p0vqPrC4Si/JVzFXxtE3HBhtHu8wUUxlKVlU
         PZX92mQZuR9qYIdAFlwntQDcqmYC4GAiPD+zK/xpmWPeCm62eZg2gx0iZ2pFPtOeqP7Q
         rgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pAFjvyG2BbuTR3wtn+p9SqjjHJsHfZYBaKEIukNmkVY=;
        b=LTggePFtbVJPHKcpgiQbFhgURZdypRDk0TURk/Wnt+F+MM+tDml4fUbIK0HTVzhS3h
         t1pk8SvOrfUOuxTNW70VZZ93QkaWXm5bhP43drR41X4GTczt7tEmuV75Dx+B0hNSQRtX
         wd+Pzqfixi3oevHQBVjNQK5Ip0JI4eXybaq0Uu7D9QgbTSuKS7jgOt65oDBEpgfJlbmr
         OP2Jc4zX4sLkkHEm2QpN7KKzdfpsiDvEvzY2llnNsDKtkv3UOjZlG2S61cEIu7/WsHpW
         tBa169gqeRvawyQEAfOpxDb/HbFTeQH7H60q5vQ4A2UEhfTnUCaSIwnJf0K4by9hGqE/
         9wgA==
X-Gm-Message-State: AOAM533KWCh+BRHbsSmJt3m9iraIe263kjaKRyDoetKUETXcA3BdRGXu
        GYU2r26URKs9tIpJZDhSbmQoNw==
X-Google-Smtp-Source: ABdhPJzZqo8fypR7EoA+WAQj0FiBpOz4ZTPpaT51JQKOswutZAbZB0I1mU0vdImvhQDzgMdCafHRuA==
X-Received: by 2002:a63:cd08:: with SMTP id i8mr13355788pgg.49.1615583418687;
        Fri, 12 Mar 2021 13:10:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id q95sm2911339pjq.20.2021.03.12.13.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:10:18 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:10:11 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <YEvYsx+jUfALD8Py@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
 <164745a2de1b9c5bede8c08a3a57566b75a61ae1.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164745a2de1b9c5bede8c08a3a57566b75a61ae1.1615250634.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 09, 2021, Kai Huang wrote:
> @@ -290,6 +290,8 @@
>  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
>  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
>  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> +#define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
> +#define X86_FEATURE_SGX2        	(11*32+ 9) /* "" SGX Enclave Dynamic Memory Management (EDMM) */

There are spaces immediately after _SGX2 that can be replace by a tab.
