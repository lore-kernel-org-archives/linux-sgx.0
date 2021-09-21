Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF787C433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Sep 2021 10:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13A8610A1
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Sep 2021 10:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhIUKaf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 21 Sep 2021 06:30:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231799AbhIUKae (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 21 Sep 2021 06:30:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632220146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ttx288q8wLdtdWWF2QymL+a9cWj2Gh8ncjXNg61K68k=;
        b=KBz6nBDiwP5D6Tkwujlj3yTb+YU6HaHPgnIN3JratI4KuoK4x0Y2UGFOjG51pS34IWGBoH
        rIeD6fN1CuKv3u/ah+PoBx7lCbsxy/8lZZvo7t7udvKVHnWbd23v4NVAK8Wq16CJvbeFtA
        a8USBc7VsesNiZmxYyqSSxUgBaIyIxg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-B2IefhV9Oj6pUpKRO5v2SA-1; Tue, 21 Sep 2021 06:29:05 -0400
X-MC-Unique: B2IefhV9Oj6pUpKRO5v2SA-1
Received: by mail-ed1-f70.google.com with SMTP id q17-20020a50c351000000b003d81427d25cso12087120edb.15
        for <linux-sgx@vger.kernel.org>; Tue, 21 Sep 2021 03:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ttx288q8wLdtdWWF2QymL+a9cWj2Gh8ncjXNg61K68k=;
        b=tizNxC37qY2QTP942Zzk4+SU87MD4xZyy3bcMZlA5z0NlgzoEcBQ9R3odYg4ErIX1s
         HU79aZY4NGfxJ92DDi2GoKKfqtJ+ErrGTFkESsYGTD3GR6yUtuGudVpU8S2hFlJQGkxZ
         8E+E890TJt8Si9GD4dfH0e1vLYUhCqySFOPbrn0FRffzyTD81wIdpLblODxyRUGJ/Oe+
         h1zEDRGKGMFCQoaRuOo/mNwgXhZU36acSBb/MWloUyRFAJoduycF43o/eLfu3Ux3w/se
         raxPA2xl39LD8fLmRpqCUtlqprkKMrAt2pCFlEZVFJE4w8G+gKCGOrbOH2t6hyWOUFVX
         BPhA==
X-Gm-Message-State: AOAM533y7AANPm434cb1dnBcMzUfDV+HgDn0p7QA82g8OToImIiftxiC
        OQRce1FNEPdAtuiae7F4VnMEpZoWG2wFTH7d4JGtoZbL7DBOXEksk+TXUVHxkQgnXD87mjfmzjG
        WNNlS4Qfa3Qy8xpxtEoaW
X-Received: by 2002:a05:6402:5163:: with SMTP id d3mr35269260ede.220.1632220143988;
        Tue, 21 Sep 2021 03:29:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgLRBigh5K8LJJ+14RCQJFiDpnbVVX0GBmEXBh2FC2cpkj99qZcgWH+kGe4mNA5vY3sW0rrw==
X-Received: by 2002:a05:6402:5163:: with SMTP id d3mr35269235ede.220.1632220143834;
        Tue, 21 Sep 2021 03:29:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i6sm7182873ejd.57.2021.09.21.03.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 03:29:03 -0700 (PDT)
Subject: Re: [PATCH 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL
 ioctl
To:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
References: <20210920125401.2389105-1-pbonzini@redhat.com>
 <20210920125401.2389105-3-pbonzini@redhat.com>
 <20210921101702.8672a0f1e356289e21864a76@intel.com>
 <4db02f44-fec0-b78e-b9ae-0aa41ac7819f@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c69d1eca-0175-0bbd-8902-1f7f380a1159@redhat.com>
Date:   Tue, 21 Sep 2021 12:29:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4db02f44-fec0-b78e-b9ae-0aa41ac7819f@intel.com>
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

On 21/09/21 01:09, Dave Hansen wrote:
>> Maybe also worth to mention userspace should guarantee there's no vcpu running
>> inside guest enclave when resetting guest's virtual EPC.
> Why, specifically?
> 
> Is it because EREMOVE will also fail if there is a CPU running in the
> enclave?

Yes, and SGX_ENCLAVE_ACT would cause a WARN.  Good catch, Kai, I'll fix it.

Paolo

