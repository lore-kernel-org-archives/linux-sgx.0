Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECBBC433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 22:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E44C64E38
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Mar 2021 22:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbhCLWEV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Mar 2021 17:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235308AbhCLWEJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 12 Mar 2021 17:04:09 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19992C061761
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 14:04:09 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id t85so2762908pfc.13
        for <linux-sgx@vger.kernel.org>; Fri, 12 Mar 2021 14:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A4VBsrBTExFTzIIWcPXbIbC/3bW0Rh8AXlm1Zd+kSVM=;
        b=NjH4RVnGKMIxKJmjG8GJYkllQ1jn5WinSXrj5QQRa9jO0Xde2Ix/dTfn+DGEgHo/+J
         e0AnLosaiKgvaYM4ekP9CXZF3svmwXDuzQFYggDL+Ia0bzzGNI9XWw767L0PyW5SdzFY
         AbLfmN3IgXG0tx+lK1z5UYKGYDDCHfa1lYjKyGaED/g9lgURliXZVPqWqGduEPxPSNq0
         MMH7EPiYVB2atFo59ii+Oix5uuvXOfQfvWuPo2eG3hdcApTsYAZPCBbBay6zHq+4TV/d
         NeKYqm6cF1nshehYoz+OGOSBt+Gwtut0ADAcVX9WPyp/b9NTw7VkOcrYyGTqeP0BbV6T
         T8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A4VBsrBTExFTzIIWcPXbIbC/3bW0Rh8AXlm1Zd+kSVM=;
        b=I6hfn+C5agH3UCYeC5Bp+NZDaXgE1K59C7uhclTPtlQXEBJAn6vaiETPFr2SOK4/sL
         mB4M0sa6OzPejHKDO1P3nRwCQaDGAZAc0e67oS52HHENDgCaT5cdM/w2UTDgub22BiRd
         +F8Enf0MCnfUk6aixkLgzUuLNoYEBTYQr0CyOqUNLtGfcOsuHv9nZAKoSMrql0Xpr2xo
         eW9/y8V63pTtzOM9h+oCZXGSyxp90UQ/U1pY8IRhx52qYV854mSAoH0/QifjqvzqUISx
         b4wPqHomJeS4/NggsHJuRObtML0tFxZj9lmLJ3hE+nojV5DnY+q47JYE2ADPFgeFNZx6
         t8+g==
X-Gm-Message-State: AOAM532O40EGawsh4oqlmAbPjR/GZ5gDIkz+BLSLELZ67SMG1mnZOYzB
        aZGBd86Rfib1em+N4gvujdWZJg==
X-Google-Smtp-Source: ABdhPJzlKX+1AMolFVpoKeUDirUHQ8igoQVFpdlwloDkDpmWVWtEkvEWq9iSY7yLrXxykyepl8xQIw==
X-Received: by 2002:a63:fd50:: with SMTP id m16mr13671152pgj.256.1615586648426;
        Fri, 12 Mar 2021 14:04:08 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id i22sm3032705pjz.56.2021.03.12.14.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 14:04:07 -0800 (PST)
Date:   Fri, 12 Mar 2021 14:04:00 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, Kai Huang <kai.huang@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, jethro@fortanix.com, b.thiel@posteo.de,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, corbet@lwn.net
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
Message-ID: <YEvlUIOWGstrgh7H@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
 <20210309093037.GA699@zn.tnic>
 <51ebf191-e83a-657a-1030-4ccdc32f0f33@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ebf191-e83a-657a-1030-4ccdc32f0f33@redhat.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 09, 2021, Paolo Bonzini wrote:
> On 09/03/21 10:30, Borislav Petkov wrote:
> > On Tue, Mar 09, 2021 at 02:38:49PM +1300, Kai Huang wrote:
> > > This series adds KVM SGX virtualization support. The first 14 patches starting
> > > with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> > > support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> > 
> > Ok, I guess I'll queue 1-14 once Sean doesn't find anything
> > objectionable then give Paolo an immutable commit to base the KVM stuff
> > ontop.
> 
> Sounds great.

Patches 1-14 look good, just a few minor nits, nothing functional.  I'll look at
the KVM patches next week.

Thanks for picking this up Kai!
