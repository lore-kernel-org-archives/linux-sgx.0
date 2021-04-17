Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FCAC433B4
	for <linux-sgx@archiver.kernel.org>; Sat, 17 Apr 2021 13:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6186561245
	for <linux-sgx@archiver.kernel.org>; Sat, 17 Apr 2021 13:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhDQN4P (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 17 Apr 2021 09:56:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhDQN4O (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 17 Apr 2021 09:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618667748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3zM8GNArDQFQU+fCtcRtFkotH8jOBWUvSl/L7VRU3Q=;
        b=jJ8hHyiGG3G+heLcs89zgf8H6j4QGRLehXaI+SCKJJ3NbUR4u7vHZjJgHN6sal03KzSXyk
        ms6twvay2o8dVQNj5/awqNqOHI3B0wgPg7oLzT78whVJpYj2q8HY2TCKe96XZ5LlYD7IFd
        dzPpL85buXZe7msberJ6h9jEBraUwH8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-bo4iDNTNO7SUUw6EpU7Dfg-1; Sat, 17 Apr 2021 09:55:45 -0400
X-MC-Unique: bo4iDNTNO7SUUw6EpU7Dfg-1
Received: by mail-ed1-f72.google.com with SMTP id co5-20020a0564020c05b02903825bcdad12so8643155edb.0
        for <linux-sgx@vger.kernel.org>; Sat, 17 Apr 2021 06:55:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y3zM8GNArDQFQU+fCtcRtFkotH8jOBWUvSl/L7VRU3Q=;
        b=OFGIgg+yVTsjHR0864OhCASFiQZO/b1WKduu7rjU871O1jm1QvCYRpUnHIRFy1QX7q
         3fHdXhxkWPHo7nisXkp1lKVumUbztYjskKIIFSUKiB5DizolraE2E1nZU28WUmg7nwMM
         Etx045S3/tWl6jEfDuwipGDk3uWeagP/nVczUrpTPBOBa9JVluyrl846BJnRMd0pbHx6
         TFixM+g+5ubqrn/TcCFrgSnYXsCad+hPwNFbwurRxfPFuIkcVfSvLGzYvwe7IksKp2lB
         giud4z7Spex7iaKlnPhpbxrJdpljIO1xI1i+n+RQprq0ZJjkuI2dArj2KiglL56OAlsw
         yrSg==
X-Gm-Message-State: AOAM531XjRq2EYTzGV6yDfmBE/q1lr1wnegjqfeDPEnrGXBdfaQBO1pk
        9d7X0KDcE6VzxFMLh4aOZKeWdXDnod1BPciFqdCVHI5w/i2GaXd1pAg144VtpaZvxRG/xqSdVIa
        OwRIhggIBkNKHcI+QP95A
X-Received: by 2002:a17:906:cc48:: with SMTP id mm8mr13615871ejb.58.1618667744684;
        Sat, 17 Apr 2021 06:55:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfCPABMiEfuYMcCF876MI75fGVSG83AMNlzATH77YxIJTywlQcOcLINn51+qGSh3mnpsJU5A==
X-Received: by 2002:a17:906:cc48:: with SMTP id mm8mr13615860ejb.58.1618667744555;
        Sat, 17 Apr 2021 06:55:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q12sm6432375ejy.91.2021.04.17.06.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:55:43 -0700 (PDT)
Subject: Re: [PATCH v5 08/11] KVM: VMX: Add emulation of SGX Launch Control LE
 hash MSRs
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
 <c58ef601ddf88f3a113add837969533099b1364a.1618196135.git.kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0f4eaeb2-df66-af8e-d716-7060edf03e90@redhat.com>
Date:   Sat, 17 Apr 2021 15:55:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c58ef601ddf88f3a113add837969533099b1364a.1618196135.git.kai.huang@intel.com>
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
> Note, KVM allows writes to the LE hash MSRs if IA32_FEATURE_CONTROL is
> unlocked.  This is technically not architectural behavior, but it's
> roughly equivalent to the arch behavior of the MSRs being writable prior
> to activating SGX[1].  Emulating SGX activation is feasible, but adds no
> tangible benefits and would just create extra work for KVM and guest
> firmware.
> 
> [1] SGX related bits in IA32_FEATURE_CONTROL cannot be set until SGX
>      is activated, e.g. by firmware.  SGX activation is triggered by
>      setting bit 0 in MSR 0x7a.  Until SGX is activated, the LE hash
>      MSRs are writable, e.g. to allow firmware to lock down the LE
>      root key with a non-Intel value.

I turned these into a comment in vmx_set_msr:

                 /*
                  * On real hardware, the LE hash MSRs are writable before
                  * the firmware sets bit 0 in MSR 0x7a ("activating" SGX),
                  * at which point SGX related bits in IA32_FEATURE_CONTROL
                  * become writable.
                  *
                  * KVM does not emulate SGX activation for simplicity, so
                  * allow writes to the LE hash MSRs if IA32_FEATURE_CONTROL
                  * is unlocked.  This is technically not architectural
                  * behavior, but close enough.
                  */

Paolo

