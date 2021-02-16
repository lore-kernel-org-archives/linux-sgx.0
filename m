Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01185C433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Feb 2021 19:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF6B564E79
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Feb 2021 19:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBPTQl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 16 Feb 2021 14:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhBPTQl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 16 Feb 2021 14:16:41 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E92C061756
        for <linux-sgx@vger.kernel.org>; Tue, 16 Feb 2021 11:15:58 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d15so6031268plh.4
        for <linux-sgx@vger.kernel.org>; Tue, 16 Feb 2021 11:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UNT4p+ndT2CF9uJiolrgGldwNqQhpBDFWUyxsDRx5GE=;
        b=qCOiDvhFBQYE/D1huT4njGW6vTXfkg1S9pyHSS15xIYSLbOWIuvdNsCftHYmizD17V
         tNa25FTCpt2mmJEgWcKr75wxHzEPA5W883gY/23TDGf7UrPvOdzLWEB6Z5hzeIMYm7oI
         JTTSUJ9EcM2J25y1YtcCwI33cbf3O0oUNW97vz1Phx0ktziMpKa6rUt0IaolbKXXS5Kj
         imn0+Yjmobv9ROABEhvlKa9s8czxqxnZmMqZmiuldeBONXvwhMhepwfCbhwBOfAEFqrE
         U4vwS9iywpbjPmDCKQp6GewntABq1jZsmJJMFCXzwPeR5Mqb9AGoLpFM2I12Sni25qNh
         LNdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UNT4p+ndT2CF9uJiolrgGldwNqQhpBDFWUyxsDRx5GE=;
        b=GS0qw9G5UormUnWtgBodhs57SUpmwy53LjoDxKdSsv7Dmm37fXk/N8eoyJCBudrxD3
         fiBW4t/K+8Hsc07szAkuGglUAUncoTADArCC1yz6PpK/YI4uNvR+bhFhpzcPIzUfL49y
         3F415uUF7MxeqWHeL+vrzijkbI3zqPlc7kOhOWHV3JAjJcT/xkCcD8Ti1dXg9J8/9MDX
         kxAfHmoiaR4rxNoH8/eFETnqmPon7b1ikZIDlwKHltrzK7gN/17357jPOFfwgC8zpTJM
         6oMDfM7mZtjJspyCq71K6OvFIv8Vhuc/sZ/lBB/MviE1brGKfKLKrqLKZSdq9oy303NT
         b3kw==
X-Gm-Message-State: AOAM531dnue95Wf1jdDflgraqqDSbUMrDi8J3KBxRsnkTtUan1Funs7/
        JE+u9fxrRnaprlJH1x6s3Hha1w==
X-Google-Smtp-Source: ABdhPJyXB0wyF3P7diNUHr5UTQ8EgVg+gtnluS2wMuZ34wnFoxWWkMzmwA5Qon7jA7FYNpPaOA2ZUw==
X-Received: by 2002:a17:902:778e:b029:de:b475:c430 with SMTP id o14-20020a170902778eb02900deb475c430mr21207524pll.53.1613502957186;
        Tue, 16 Feb 2021 11:15:57 -0800 (PST)
Received: from google.com ([2620:15c:f:10:6948:259b:72c6:5517])
        by smtp.gmail.com with ESMTPSA id j185sm22613248pge.46.2021.02.16.11.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 11:15:56 -0800 (PST)
Date:   Tue, 16 Feb 2021 11:15:49 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH v5 00/26] KVM SGX virtualization support
Message-ID: <YCwZ5fI/CVfPNATJ@google.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <0e4e044c-020e-51a3-1f27-123c81f22c33@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e4e044c-020e-51a3-1f27-123c81f22c33@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 16, 2021, Dave Hansen wrote:
> On 2/13/21 5:28 AM, Kai Huang wrote:
> >  arch/x86/kvm/vmx/sgx.c                        | 466 ++++++++++++++++++
> >  arch/x86/kvm/vmx/sgx.h                        |  34 ++
> 
> Changes to these files won't hit the SGX MAINTAINERS entry if you run
> get_maintainer.pl.  That means Jarkko (and me, and the SGX mailing list)
> probably won't get cc'd on changes here.
> 
> Is that a bug or a feature? :)

Feature.  The stuff in those files is pure KVM, there's nothing interesting from
an SGX subsystem persective.  That's another reason to have sgx/virt.c, the
stuff that does impact SGX can all go in there.

The KVM SGX code is in split out because virtualizing ENCLS leafs takes a
painful amount of code, and because SGX already has a separate Kconfig.
Association with the SGX subsystem was a non-factor in that choice.
