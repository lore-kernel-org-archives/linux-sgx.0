Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4309CC433ED
	for <linux-sgx@archiver.kernel.org>; Sat, 17 Apr 2021 13:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C98610A1
	for <linux-sgx@archiver.kernel.org>; Sat, 17 Apr 2021 13:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbhDQNkO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 17 Apr 2021 09:40:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhDQNkN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 17 Apr 2021 09:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618666787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vl5fT45qmNUBaYknifrhJQO3g3agY4f1Yqsmx8Sy+5Y=;
        b=SXCdJDLTgdEMdB2c2WMrGVnuka4OIT5BhAnTeHK5ulkg4aGbIO/2DWD/LE+wndIRF0IzZc
        DLav+lZ4Dsv564LenQNSRjdHsBak6xRXcdK22zXBgzBkeKXmdpjaBxVXiE4hRip7swbI+C
        txMD0+X0MKdBQSYU3/LtfIjmyibiZfw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304--6LZBaGuNLqY2b3FDyRfgA-1; Sat, 17 Apr 2021 09:39:45 -0400
X-MC-Unique: -6LZBaGuNLqY2b3FDyRfgA-1
Received: by mail-ed1-f69.google.com with SMTP id f1-20020a0564021941b02903850806bb32so2706686edz.9
        for <linux-sgx@vger.kernel.org>; Sat, 17 Apr 2021 06:39:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vl5fT45qmNUBaYknifrhJQO3g3agY4f1Yqsmx8Sy+5Y=;
        b=me+5ojYQKi1hrmYsBWekpFCUYvBqc8lhYFDUdxqbKsHY28VthwcA+YxHNi4JbtZU/a
         fp8YVqChFD1uzyofN9XOMoUsNe3VqCXfKFJGNAJQkZ59kBtK0QwM0vo7BnDSQtOhDCXB
         yj/0/wDBKUKTUZqhJptB5jXDD9EP5zQVSN6fZ02IVn13rRX3cslo664F//ciRiftb5fv
         lgxmlJr+bM5liZKHjEN7FnTtnmP1DUztUWuKHcJc1OoMo9ytvjORpZL4B9F34T/8pdBP
         KXlO7vISpeV+ePnWqOMn4sDqJrWEiEaKIhQNqvqDK5ddco5pxGdg5Z3DXZRw+Si8iyj7
         mHLQ==
X-Gm-Message-State: AOAM530OfXx3CJ8bkuXE46DT+jfjTWUHXhx+FCI3fBH2LgU5FbI3eO/s
        DorS93s2JSQ8KFDkmhJXNrnTZTgtiH+K/9yV8HtH8s6JnyrfhUcF0gYSR3zwYSLDZU/59njXeTs
        XF6ehCg8iavU2jBipafhu
X-Received: by 2002:a05:6402:34c8:: with SMTP id w8mr16306160edc.235.1618666784645;
        Sat, 17 Apr 2021 06:39:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR9R4cU944IIgU8B3fJdUEocoEuj0CXFfF2muB+7EaJv4fMyvTv3uAp0s0i/UKukmgnBrwlg==
X-Received: by 2002:a05:6402:34c8:: with SMTP id w8mr16306144edc.235.1618666784528;
        Sat, 17 Apr 2021 06:39:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ga28sm6200588ejc.82.2021.04.17.06.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:39:43 -0700 (PDT)
Subject: Re: [PATCH v5 04/11] KVM: x86: Add reverse-CPUID lookup support for
 scattered SGX features
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
 <e797c533f4c71ae89265bbb15a02aef86b67cbec.1618196135.git.kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9bd47d7a-79cb-43fc-0f74-b13512ede0d2@redhat.com>
Date:   Sat, 17 Apr 2021 15:39:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e797c533f4c71ae89265bbb15a02aef86b67cbec.1618196135.git.kai.huang@intel.com>
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
>   #define X86_KVM_FEATURE(w, f)		((w)*32 + (f))
>   
> +/* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
> +#define __X86_FEATURE_SGX1		X86_KVM_FEATURE(CPUID_12_EAX, 0)
> +#define __X86_FEATURE_SGX2		X86_KVM_FEATURE(CPUID_12_EAX, 1)

And these to KVM_X86_FEATURE and KVM_X86_FEATURE_SGX{1,2}.

Paolo

