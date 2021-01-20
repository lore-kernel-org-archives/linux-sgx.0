Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55DDC43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 16:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A01ED233E2
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 16:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403791AbhATQ4D (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388514AbhATQgX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 20 Jan 2021 11:36:23 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DDEC061575
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 08:35:42 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id kx7so2493680pjb.2
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 08:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JlixcYoHW4Z0fDOypVjt+k/RzFyLIGGaYIsPPyEDmtA=;
        b=kiUbWi2Y/tw5HB/SPzF8PCMPP4iwKt9x6KHIDxh2jc0Kr+A7L7jlKuSOXONu0APQAn
         t7nD5ylrF/seaYBSZPEl+pA2OK7ZlsHDGwPQv8l+QzTf1VAVPHnyZxs+CFKTUui6c7N2
         Tf8IMWQemacCb7UNQs3wWXZYhiwNjE6vi44Lsi23Ywqk4Z9x/QnowUm5qdzfbTzrG0b1
         iMiT/Wxnbe3Tq61yESgxXv03KDjmfT6gYMyCKBvOwzXyrvA1Huonk/Qb8hhxhDf73OpA
         nMJQMWqkNvA3YdB8gF6ACqrm339J4Gffn4VlJI3t+Uyj+ZJ+HoZORc+6C5C+OVja9YRG
         fiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JlixcYoHW4Z0fDOypVjt+k/RzFyLIGGaYIsPPyEDmtA=;
        b=iqfqcUjHxm17p8YSmTZEzhxiHJlijzkXrdYndLvqvfq8z0MUeu/Hf8juLHXZuxM41f
         ZU4TNTTZwhpyuy4UhF1ZZAK4p77cIdYr4nzJ9B5F3Q/Mt9DcpEkzWYBHvsCWjpzPvFMR
         6LirRU5n1lNGCd7D/pWKdhkU6YDTCF234cg2rQhNg/14g26UGiid8dgc4AA7fVqrq1Iy
         okvPEAhHC4duvytwyu+oWzAQqtE2fo7POW5alJ5N3CFCt4sqvRBkfPuvQksaRH73DaDF
         zDWJum1r/qDV37f44iZ5Tm8o3VYuMCExIB0JNJBth0P5aEQFhsQaBVLuPc5zNzv3uPOZ
         9koA==
X-Gm-Message-State: AOAM530uqw5qMaB3hEnaEU1FU50G5usJxezBje9zJ+R45885s9RNqtjw
        /qocdEi+wIgqFGrv4zp7zVGxLQ==
X-Google-Smtp-Source: ABdhPJzZbs1JiU9eeCn0Q6AG2mfq6aHzox/28oq3WFdAQIFNbYAaNMpTggajWXVCHeJn/3AKL5ePRg==
X-Received: by 2002:a17:902:d891:b029:de:369c:6bc7 with SMTP id b17-20020a170902d891b02900de369c6bc7mr10756044plz.31.1611160542240;
        Wed, 20 Jan 2021 08:35:42 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id j6sm2882089pfg.159.2021.01.20.08.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 08:35:41 -0800 (PST)
Date:   Wed, 20 Jan 2021 08:35:34 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH v2 00/26] KVM SGX virtualization support
Message-ID: <YAhb1mYB3ajc2/n9@google.com>
References: <cover.1610935432.git.kai.huang@intel.com>
 <YAaW5FIkRrLGncT5@kernel.org>
 <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 20, 2021, Kai Huang wrote:
> I'd like to take this chance to ask: when this series is ready to be merged, what is
> the properly way to merge? This series has x86 non-sgx (cpufeature, feat_ctl) and sgx
> changes, and it obviously has KVM changes too. So instance, who should be the one to
> take this series? And which tree and branch should I rebase to in next version?

The path of least resistance is likely to get acks for the x86 and sgx changes,
and let Paolo take it through the KVM tree.  The KVM changes are much more
likely to have non-trivial conflicts, e.g. making exit_reason a union touches a
ton of code; getting and carrying acked-by for those will be tough sledding.
