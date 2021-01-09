Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2503C433E0
	for <linux-sgx@archiver.kernel.org>; Sat,  9 Jan 2021 01:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8047923A75
	for <linux-sgx@archiver.kernel.org>; Sat,  9 Jan 2021 01:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbhAIBCN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 8 Jan 2021 20:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbhAIBCM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 8 Jan 2021 20:02:12 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85755C0613CF
        for <linux-sgx@vger.kernel.org>; Fri,  8 Jan 2021 17:01:32 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id p18so8693132pgm.11
        for <linux-sgx@vger.kernel.org>; Fri, 08 Jan 2021 17:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VAuMoiKLdCWGFL+8WHc++7W2S54mQ6a1Rj7M8Uus0Wc=;
        b=WoEOzI7mMwukLesyNRiiF7wLtxLHWF9IQ8lW2Gh3+KHiWHn3D7yB2Y3Pdaeu+E1qEK
         FujfpjdW3i3jcQQgkOAMCDDQQBhfK8/iOjK5BTul7NrR8SSU2zx8FU4vvwCe82vmZaUp
         3LPk/7lFL8fNGLemZ+fCYqAbjAcaV1klLozdIDYs0++wy3SqkZQJ3FWDjV/KADDCikv2
         zyW83GXED2qQo62rJGudK3xXHI0ahQY1WeIEcxU0n7UKrHOR5Csv+N/aN56Nl2Uh70fu
         fPm+e1ls3Unfz+3Ec3+5dxd6zEuUol/9tWJY+ByHgk3sKYTkPPwveKHr8/oA/APRhwpn
         33Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VAuMoiKLdCWGFL+8WHc++7W2S54mQ6a1Rj7M8Uus0Wc=;
        b=skNauJh1KRTUf5EMfS3DPZQ7QOQ7jM5g7Uo3XZvf51wSAhdFYJID7SP/pmxFvcq5Hi
         gxnenwnTLzdKE69G3gK9XvMM1Sdw2qoZLRB13EGgm7cy4UpE1iE54AWkOiGHIdJXDvam
         pEVSvqTFRmQrw6TV1ZXhGJbHBtszowCd7lNBYM+69SS8YJeD4p+uecIXg6oEyrTV+Vc0
         BcaORPweH+Xk4QRwvmNwgV2bdYKJmENOE87ILlTA3FLOAa+XWSY8CWZ71NiVQ2zhj3Po
         l/9kykd5qWv9/cU38whL2/HSHF39dI24fCHcOMFP3Ocf8BKcng6oCQoGhjFk6PPIpl4I
         xmsg==
X-Gm-Message-State: AOAM531QlfwOFxbrB3s1CjH19unUIa4l170SbvO01k5GdwDK12dmOhAK
        nOTLyUrJZIT68KwlDdqV3i81ag==
X-Google-Smtp-Source: ABdhPJymWC2GjzMYRUkUGpMULobhStzMJlfi0GalUgRhKIrG5Au05nevOKY7Kn09HZeAtO+ItpCCvw==
X-Received: by 2002:a63:a516:: with SMTP id n22mr9418531pgf.125.1610154091913;
        Fri, 08 Jan 2021 17:01:31 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 21sm10048096pfx.84.2021.01.08.17.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 17:01:31 -0800 (PST)
Date:   Fri, 8 Jan 2021 17:01:24 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <X/kAZEXSZuOjq3h9@google.com>
References: <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
 <20210106221527.GB24607@zn.tnic>
 <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
 <20210107064125.GB14697@zn.tnic>
 <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
 <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
 <X/jxCOLG+HUO4QlZ@google.com>
 <20210109003502.GK4042@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109003502.GK4042@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Jan 09, 2021, Borislav Petkov wrote:
> On Fri, Jan 08, 2021 at 03:55:52PM -0800, Sean Christopherson wrote:
> > To be fair, this is the third time we've got conflicting, direct feedback on
> > this exact issue.  I do agree that it doesn't make sense to burn a whole word
> > for just two features, I guess I just feel like whining.
> > 
> > [*] https://lore.kernel.org/kvm/20180828102140.GA31102@nazgul.tnic/
> > [*] https://lore.kernel.org/linux-sgx/20190924162520.GJ19317@zn.tnic/
> 
> Well, sorry that I confused you guys but in hindsight we probably should
> have stopped you right then and there from imposing kvm requirements on
> the machinery behind *_cpu_has() and kvm should have been a regular user
> of those interfaces like the rest of the kernel code - nothing more.
> 
> And if you'd like to do your own X86_FEATURE_* querying but then extend
> it with its own functionality, then that should have been decoupled.
> 
> And I will look at your patch later when brain is actually awake but
> I strongly feel that in order to avoid such situations in the future,
> *_cpu_has() internal functionality should be separate from kvm's
> respective CPUID leafs representation. For obvious reasons.

I kinda agree, but I'd prefer not to fully decouple KVM's CPUID stuff.  The more
manual definitions/translations we have to create, the more likely it is that
we'll screw something up.

> And if there should be some partial sharing - if that makes sense at all
> - then that should be first agreed upon.

Assuming the code I wrote actually works, I think that gets KVM to the point
where handling scattered features isn't awful, which should eliminate most of
the friction.  KVM would still be relying on the internals of *_cpu_has(), but
there are quite a few build-time assertions that help keep things aligned.  And,
what's best for the kernel will be what's best for KVM the vast majority of the
time, e.g. I don't anticipate the kernel scattering densely populated words just
for giggles.
