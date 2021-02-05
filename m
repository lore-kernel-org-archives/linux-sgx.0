Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D25C433E0
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 17:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4589064F20
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 17:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhBEP27 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Feb 2021 10:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbhBEP1Q (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 5 Feb 2021 10:27:16 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F1DC06174A
        for <linux-sgx@vger.kernel.org>; Fri,  5 Feb 2021 08:52:06 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id e9so3867097plh.3
        for <linux-sgx@vger.kernel.org>; Fri, 05 Feb 2021 08:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RO4dIZbXCHxgGtgQUSgkK1eNDMrMfPhO1PoHqkge4zU=;
        b=Xmwyxyw3v/HXwd2nQjd/2BUg2EEGJ5fX90Q6UKMSb4EzTrgBS5iYjcbnOepw0ncPUX
         MNKRaX9tjSsWjsVhxWSdBngwSbpeBhJA1hYjeMjhCkXxhPahOwzUzje5amZL9b4pM4OU
         rdf5QRfhRnNvAWtcdfSXgGgHVJ/emBbbgX20A3/lpPcujpGHAjusmJ8SkdwBP7LWj+jx
         vWh9xHx36kYxY5z9RxKdqCtioNQF7vhvuEVA6KHeBDeL+vaWV8toxBiZO8owVG64oCf9
         Ji7V2MEAIt0ZZK1pYiejoy4ukDl7Qa4ssBnyt//2y+oz/T5MX96qYqW+YanUaYzkv7F1
         zUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RO4dIZbXCHxgGtgQUSgkK1eNDMrMfPhO1PoHqkge4zU=;
        b=Pn7I1c1w/5ka9UIYPqmbcUyLlo8Ujw4+UfqyWVBF8Nexy+Cqs2u2IZIAre7dS+zyIt
         RX7ecCNb1EBWjnlEQ2+SQxw2ZYO91UwclaakxMct7ljfzIH2RHtwmFSuqhvhjjzANOoi
         VwFRm4T1Yn7O/HkHqcnsbJO3MAZkQMdbRcgoqxUe6EFsRBE6vq4N+ou1oJuVyKeTx0Zw
         eAWVDa4Gm6PaQOdWPYserRLJ49MUoxNDliHNC6SvjupF/ohXHzvQd3sVZqmlvZX55b2q
         KE3U8F5o24mU4vcpXjK92O1L4jlZOXMsX6DMizrwHvzf1tokfJ2z1en35pykcW6OMjsu
         EmRQ==
X-Gm-Message-State: AOAM532EbcRo8LAB6MXutgBsSLDC+4IkZtC2b7RKtFrm5MiQFh8lUPh7
        yBwR/ZIhDnzCrS9dJKhW5jLZyA==
X-Google-Smtp-Source: ABdhPJw+8Tef3Qby15x0TyDv1F69X4SxvY97339jGVjxV1d4q0Ziwccau8NBcqd2KIPUvOoRgK2HLQ==
X-Received: by 2002:a17:90a:657:: with SMTP id q23mr5076265pje.192.1612543925784;
        Fri, 05 Feb 2021 08:52:05 -0800 (PST)
Received: from google.com ([2620:15c:f:10:d169:a9f7:513:e5])
        by smtp.gmail.com with ESMTPSA id x141sm9765955pfc.128.2021.02.05.08.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 08:52:05 -0800 (PST)
Date:   Fri, 5 Feb 2021 08:51:58 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
Message-ID: <YB13rk29J8Obs80J@google.com>
References: <c827fed1-d7af-a94a-b69e-114d4a2ec988@intel.com>
 <d044ccde68171dc319d77917c8ab9f83e9a98645.camel@intel.com>
 <YBsyqLHPtYOpqeW4@google.com>
 <b6e0a32f-0070-f97e-5d94-d12f7972d474@intel.com>
 <44b5a747aaf1d42fb8ef388bd28f49614d42cd50.camel@intel.com>
 <YBs/vveIBg00Im0U@google.com>
 <5bd3231e05911bc64f5c51e1eddc3ed1f6bfe6c4.camel@intel.com>
 <YBwgw0vVCjlhFvqP@google.com>
 <635e339e-e3f5-c437-0265-b9d44c180858@intel.com>
 <35808048da366b7e531f291c3611c1172f988d6a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35808048da366b7e531f291c3611c1172f988d6a.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Feb 06, 2021, Kai Huang wrote:
> Hi Sean,
> 
> If we all agree the fix is needed here, do you want to work on the patch (since you
> already provided your thought), or do you want me to do it, with Suggested-by you?

Nope, all yours.
