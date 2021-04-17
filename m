Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61ACC433ED
	for <linux-sgx@archiver.kernel.org>; Sat, 17 Apr 2021 13:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1616120C
	for <linux-sgx@archiver.kernel.org>; Sat, 17 Apr 2021 13:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbhDQNjt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 17 Apr 2021 09:39:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230442AbhDQNjs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 17 Apr 2021 09:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618666762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHM7HKI6L6KI7GdsoopUjMZPwFe/oDUGoMfSWD/vPeE=;
        b=QnzjOS7XkhFezXeafbvgOdF8HRCM4UsXzlcZvUAwZJH0VO0a1uaK8ySlnosExuOVjgnWf6
        QMjx2J4V6g5KiZWMrGfXTsq4dtAJzK/yiE9NnW0/LE62ZzOtSmUZqNokgfqhte1qbC4dd3
        RrPfinNmVPD3pZe60FmcUbDivFCbUMs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-jeW9ydf-NmSpWlFbR1Gh0Q-1; Sat, 17 Apr 2021 09:39:20 -0400
X-MC-Unique: jeW9ydf-NmSpWlFbR1Gh0Q-1
Received: by mail-ed1-f72.google.com with SMTP id y10-20020a50f1ca0000b0290382d654f75eso8644585edl.1
        for <linux-sgx@vger.kernel.org>; Sat, 17 Apr 2021 06:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xHM7HKI6L6KI7GdsoopUjMZPwFe/oDUGoMfSWD/vPeE=;
        b=LxsKtC/G2LJUL2tU9BIntkPXNZ62489nQG4R3/03T+s0igek1FteRszkEGC7h5uRBc
         bbOnFbMQQc3AdoqhlAUmJc9KaieeUROAWE4yUjJF0/n+qua8Ue7TZi5m8IHG6tp1f7U2
         X6PjeG4Mx3qKACPnsPmQ817wiwmEyAedmC8Yl6nDFKpgHy6Ot98tDgaiZ7cOJf3SgPXz
         FlL+42yaryPm+b8fgj0xEMfe9LRv2D/KPNV927Y5b+AdJhyqY4gf06en/o3io90u+Psh
         y6DL1BKu8WUDx7Ikq8kCCa0RW+kCYtbaXhYG/FHDK8+ioekfNqs5xYFj+7+At0/oCixS
         eYpw==
X-Gm-Message-State: AOAM532vpsGj75MxKOJ4xjZy3Ryvm/mgs25ou+f4a3tVyyoUK1Q5Ip5+
        dLGh6BCl4F2Ow3PV+G1jIK0ztHXsmfYEkNW/WnNd7YNSHPSUDY5O4hvmepeQYqtTogUk0MDZE4U
        F0omTqivNN3nswxBzfY0o
X-Received: by 2002:a17:907:629e:: with SMTP id nd30mr13050801ejc.407.1618666759156;
        Sat, 17 Apr 2021 06:39:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCKJijVAFcWGcPxk6FDkmBwSIVPf1Q0S/aSWmk61bF7uyBTJTAgS4M7uMCyqAGsUk78Z8gMQ==
X-Received: by 2002:a17:907:629e:: with SMTP id nd30mr13050790ejc.407.1618666759024;
        Sat, 17 Apr 2021 06:39:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bw14sm6339207ejb.89.2021.04.17.06.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:39:18 -0700 (PDT)
Subject: Re: [PATCH v5 03/11] KVM: x86: Add support for reverse CPUID lookup
 of scattered features
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
 <16cad8d00475f67867fb36701fc7fb7c1ec86ce1.1618196135.git.kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0399df7d-862e-1d22-41dd-82b804c97f4c@redhat.com>
Date:   Sat, 17 Apr 2021 15:39:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <16cad8d00475f67867fb36701fc7fb7c1ec86ce1.1618196135.git.kai.huang@intel.com>
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

On 12/04/21 06:21, Kai Huang wrote:
> +static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)

Just a small nit, I renamed this to kvm_cpu_cap_init_scattered.

Paolo

