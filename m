Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23F2C433E0
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 23:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B448064F5D
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 23:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhBBX5I (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Feb 2021 18:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhBBX5H (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 2 Feb 2021 18:57:07 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D634C061573
        for <linux-sgx@vger.kernel.org>; Tue,  2 Feb 2021 15:56:27 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o16so16024182pgg.5
        for <linux-sgx@vger.kernel.org>; Tue, 02 Feb 2021 15:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b2T9PQ4l/YYugYnX7ZP4GlOVWI5dL3LOQ1dsVnqyFvs=;
        b=XXdNI6hl0pa3AM8fe+eOpbtg2REQFRUurTyOlcjOQg90/ToJ8AEsCmkL8kRvMdJKlj
         +o3pWtnhVYpfQgNbFFaVaBa9o3BI8338Tr6kLVZZPnAzPDp907r6Ay2BC2UPMMkNJGum
         wA2CKLZPoEiFyMBukSyM+s5zllIwfZzQNWdb5E1UcCSk1KlEqLBZDAYk1zT2lF1qp2kt
         LZb0KjG7bgZWS+NULtdZcOkssjCqO6gzCaIeav1NCZsfhzwAFaENR5g4F7PcxBxc6wpU
         7EiU0414lKcwTYdOJ8/XFNEQFk7S5/c8joUcwRFglnJGMt9YNSUyiyQIiwrsdNLz4r/8
         BpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b2T9PQ4l/YYugYnX7ZP4GlOVWI5dL3LOQ1dsVnqyFvs=;
        b=rtWrUQP7HkkVinxDyXpJguGpM80/bnwNnDxmJMzDRgex44oag2vdGVzz0QDm4L+ben
         hg6HAf9lBHouimcrr6ZFIPkHdgxN2Tghsh/Il3rdp4x3kDiqXrcwepdFaHvxFz1LcMAs
         VMMwL4aXaSFLX7C97h1my0Mrmae7GNOAmOdQ7uIfXeIcWtIcsq6n1Zh0H9OWpYRe/WTN
         nAaBxyH4fqnNr8FGb0WYueh3QJjI+9uLZ8a5i+IWdY+eF27txB052rCIhXZCwYBuOCaQ
         wOB4MQXSPggLuu1k7EmoIS0/Wgnj+zyZ+Rk3GQn1Us/f3IFH3TpcQGcnCXGBzOG1tqE0
         HAOw==
X-Gm-Message-State: AOAM5331eX9LV+Tgn8id4OzCEJ1Ij/V2otrzGLr0GeP8/Oe1r2J1Y9dl
        dgbBV7+JHAg9QoMKFXL9JOLkYkP3WUaJLw==
X-Google-Smtp-Source: ABdhPJzQvLzh/KiU6HZCTS0iRoNr73zqZAVc1FThQLipKJ56IFfVJDQdvps7ic3gwh7dZ8sGfXxxzg==
X-Received: by 2002:a05:6a00:1506:b029:1bc:6f53:8eb8 with SMTP id q6-20020a056a001506b02901bc6f538eb8mr477622pfu.36.1612310186703;
        Tue, 02 Feb 2021 15:56:26 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id t6sm106477pfe.177.2021.02.02.15.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 15:56:26 -0800 (PST)
Date:   Tue, 2 Feb 2021 15:56:19 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
Message-ID: <YBnmow4e8WUkRl2H@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <4b4b9ed1d7756e8bccf548fc41d05c7dd8367b33.camel@intel.com>
 <YBnTPmbPCAUS6XNl@google.com>
 <99135352-8e10-fe81-f0dc-8d552d73e3d3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99135352-8e10-fe81-f0dc-8d552d73e3d3@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 02, 2021, Dave Hansen wrote:
> On 2/2/21 2:33 PM, Sean Christopherson wrote:
> >> Do we need to restrict normal KVM host kernel access to EPC (i.e. via
> >> __kvm_map_gfn() and friends)? As best I can tell the exact behavior of
> >> this kind of access is undefined. The concern would be if any HW ever
> >> treated it as an error, the guest could subject the host kernel to it.
> >> Is it worth a check in those?
> > I don't think so.  The SDM does state that the exact behavior is uArch specific,
> > but it also explicitly states that the access will be altered, which IMO doesn't
> > leave any wiggle room for a future CPU to fault instead of using some form of
> > abort semantics.
> > 
> >   Attempts to execute, read, or write to linear addresses mapped to EPC pages
> >   when not inside an enclave will result in the processor altering the access to
> >   preserve the confidentiality and integrity of the enclave. The exact behavior
> >   may be different between implementations.
> 
> I seem to remember much stronger language in the SDM about this.  I've
> always thought of SGX as a big unrecoverable machine-check party waiting
> to happen.
>
> I'll ask around internally at Intel and see what folks say.  Basically,
> should we be afraid of a big bad EPC access?

If bad accesses to the EPC can cause machine checks, then EPC should never be
mapped into userspace, i.e. the SGX driver should never have been merged.

The SGX architecture is predicated on using isolation to protect enclaves from
software, not by poisoning memory, a la TDX.  E.g. SGX on ICX's MKTME wouldn't
be a thing if that weren't the case.

A physical attack on DRAM can trigger #MC on systems that use the MEE as
opposed to MKTME, but that obviously doesn't require a guest to coerce KVM into
accessing the EPC.
