Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F60FC433DB
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 18:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64C0E64E4F
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 18:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbhBBSoW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Feb 2021 13:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238874AbhBBSmx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 2 Feb 2021 13:42:53 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E81EC0613D6
        for <linux-sgx@vger.kernel.org>; Tue,  2 Feb 2021 10:42:13 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i63so14931597pfg.7
        for <linux-sgx@vger.kernel.org>; Tue, 02 Feb 2021 10:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YTgp3gQH+UBjxDnuoHSJe2E7rMRGSXfHDHxNctlP+No=;
        b=ONuysSWxPvPEF1csQbpuXTENOsPRO1RZpI/JgJrvWqnAUZ5mSJVlP7PKIsZT8LJCS7
         9nXfG65FT8ciJOv8Yoo3NHYrjrV02DmCZT3wu1IPfkIUnDQFE9Tyhy1442fO8Rh8BC18
         MsgU3qYQIiaTMjbgLbjkXr4EAw0l+bw2fCLcxAb08njGC6JnMm9bBVE9uAW1j2Db/zOg
         b/ijc+WpRMMc27QLLWt6tsv3Nx3RHOeJQ5sa1vUbuHAx4YQ6WntFtRrX4k1zQjsyKRgo
         pa6QX7qvCHqcgnmnqI+PqLwbzLGVVgUXfZz3l7cNkxjwRKiMbCsxjsDb97jJ/69ntFoa
         4Yxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YTgp3gQH+UBjxDnuoHSJe2E7rMRGSXfHDHxNctlP+No=;
        b=qWY9d6mb2mMqHusE+FmTV5fF27aQ+/amaTyUlyd0v81ac4BPUGFB5Esd0B9uRS5R4i
         QPeXqDWpz/z+b5XEI2ByOaGEFFedjUYMuY3i1hajWdC/peuejKej2QiirFX2YaMPE1ns
         mUmWcLkEcg73gEyeGaZVCD+VMkkXQe2FPVwGXtAReZQaSDIoJZb47wCBHwWSrrEm5jnk
         oih9huxlhpzJPxFTYoj+gkez/9oltaXNNGV4IKAsm7ofKrS1v35cUnxPPL6ykjMpZJA6
         7BIZ3omn6FazeVPi/u082naUGcC+rUNjleiY4CvOWwtWJpbXXzhuXxvkS/IfS9P1ctr8
         1dTg==
X-Gm-Message-State: AOAM530X7lljak6BoANELlPlw2F73QLfxQm903Hqz9y9P65xiKLykKWP
        hQAMgQ415wKKt08lRZUWoNFc8A==
X-Google-Smtp-Source: ABdhPJx/Fa72tAGu1Nd2n7c6WTneyUPE8P+QUh0M/5mPzebk3jNNAYe9MOCNHQ+TlvmegftvkHDFTg==
X-Received: by 2002:a63:4713:: with SMTP id u19mr8349192pga.209.1612291332414;
        Tue, 02 Feb 2021 10:42:12 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id t15sm3478875pjy.37.2021.02.02.10.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 10:42:11 -0800 (PST)
Date:   Tue, 2 Feb 2021 10:42:05 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-ID: <YBmc/T8L9RCoyeWr@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
 <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
 <3a82563d5a25b52f0b5f01560d70c50a2323f7e5.camel@intel.com>
 <YBVdNl+pTBBm6igw@kernel.org>
 <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
 <89755f15-a873-badc-b3d6-d4f0f817326e@redhat.com>
 <87a8a3f4-3775-21f1-cb67-107cca1a78e5@intel.com>
 <88e25510-a2e0-c4b8-4dcf-0afb78d5532c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88e25510-a2e0-c4b8-4dcf-0afb78d5532c@redhat.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 02, 2021, Paolo Bonzini wrote:
> On 02/02/21 19:00, Dave Hansen wrote:
> > > /* "" Basic SGX */
> > > /* "" SGX Enclave Dynamic Memory Mgmt */
> > Do you actually want to suppress these from /proc/cpuinfo with the ""?
> > 
> 
> sgx1 yes.  However sgx2 can be useful to have there, I guess.

Agreed, /proc/cpuinfo's sgx1 will always be in lockstep with sgx, so it won't
be useful for dealing with the fallout of hardware disabling SGX due to software
disabling a machine check bank via WRMSR(MCi_CTL).  I can't think of any other
use case for checking /proc/cpuinfo's sgx1.
