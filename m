Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2755AC433E9
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Mar 2021 18:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2FC46522D
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Mar 2021 18:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhCISuJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Mar 2021 13:50:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230159AbhCIStw (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 9 Mar 2021 13:49:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615315791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m9Xym80t0AfeRZOHjiWsVqVWWv3spvSFZ9P4PZSjvAg=;
        b=O7DG2O1ZuaFb7o/C3fA5F+cdG8pXgcpdyM20cg8jM/5vzjFbMKZ4mIMpKcjSjcp+7D7f2D
        sT/lj9yub13ipCqOz8CtvcSlWMReib3SHy/lIWA68j6167EatjO/ZmW7WHqVLoJAFyed/x
        BmG+0NpWz4nWd0GIDC/sZjS+N0phdU8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-l-yjoIyJOtagnNl-NtgMYQ-1; Tue, 09 Mar 2021 13:49:49 -0500
X-MC-Unique: l-yjoIyJOtagnNl-NtgMYQ-1
Received: by mail-wm1-f70.google.com with SMTP id s192so1536093wme.6
        for <linux-sgx@vger.kernel.org>; Tue, 09 Mar 2021 10:49:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m9Xym80t0AfeRZOHjiWsVqVWWv3spvSFZ9P4PZSjvAg=;
        b=IwkKrRxq0p1xkabUghFbFbD7dz2xoHnE2iwRIcbVBTVO6RrwcgqArLIr4u98EZN8Kw
         9tKEwHWlkT9o8xgVS9OOQAwXWWPYKFnuh88TGPW2fTDPO2ilhL7i3NS8c1g4wVFIbokM
         R24QPZLuSw96ZaPxEmGH9cLj0h7aGKI+YNFv0YtpPFIPwjDeBUHqpUjb7RslZXxDCLs7
         A/cYYIWaRSGO3HnFmxM7c2oURVSagg5NHUnvPbDfdo3znuHLY7zdP2iUpT9UKLjrpI24
         LWe6EohF3xlcHMewwZ8CVqFdVUEsNes4IOXx5T4cuPjAPPOX53FqJZOe1K8a7oWvr6lB
         E6+g==
X-Gm-Message-State: AOAM531cyCljdvlTuUBnzUAaZRalSfigdVm/t18icVK+y3h4SR1LW/3T
        cy57xEIUTKkSPSWDVp2lW+3LYCfr9hGev2UgvLyWt/DcKgmGLsEiqL4bdtag82jTidni6inGDam
        c/1SnxaOBsUkG63oQqS0E
X-Received: by 2002:a05:6000:1a8c:: with SMTP id f12mr29860107wry.173.1615315788524;
        Tue, 09 Mar 2021 10:49:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLvc9I8lVKzz6AHteBnYBDwX8zS4xde1F0yjVbAXTx+neuz8trrr19wOyyEGbfiZBgdAWiUw==
X-Received: by 2002:a05:6000:1a8c:: with SMTP id f12mr29860076wry.173.1615315788359;
        Tue, 09 Mar 2021 10:49:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n66sm5211597wmn.25.2021.03.09.10.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 10:49:47 -0800 (PST)
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
To:     Borislav Petkov <bp@alien8.de>, Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, jethro@fortanix.com, b.thiel@posteo.de,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, corbet@lwn.net
References: <cover.1615250634.git.kai.huang@intel.com>
 <20210309093037.GA699@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <51ebf191-e83a-657a-1030-4ccdc32f0f33@redhat.com>
Date:   Tue, 9 Mar 2021 19:49:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210309093037.GA699@zn.tnic>
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 09/03/21 10:30, Borislav Petkov wrote:
> On Tue, Mar 09, 2021 at 02:38:49PM +1300, Kai Huang wrote:
>> This series adds KVM SGX virtualization support. The first 14 patches starting
>> with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
>> support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> 
> Ok, I guess I'll queue 1-14 once Sean doesn't find anything
> objectionable then give Paolo an immutable commit to base the KVM stuff
> ontop.

Sounds great.

Paolo

