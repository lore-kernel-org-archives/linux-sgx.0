Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F0CC433E6
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 18:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F49464F99
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 18:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhBBSHO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Feb 2021 13:07:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238163AbhBBSEy (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 2 Feb 2021 13:04:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612289006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mLPn7R460RnvC3cVkzpTkUrq1JeELO52BKdk3debVIg=;
        b=HAGl4UFBQxZ3VhXjxClaMpFNM3aJ32ZzkSSd3i8L4rNAC0A5CrJ+HTfLHDeTfTjfCfF0GZ
        nY87lgoaDxMXTPg5Wfw2wYCyIN4J5+4xOWaGChXhH3JrBq29t7WcM+CGDMv7AYID+WarKE
        vZ1VpVua9GTFKA2AkYbz/raaEk3pwpM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-ZjFUwswEMh2vn2oV1diEqQ-1; Tue, 02 Feb 2021 13:03:20 -0500
X-MC-Unique: ZjFUwswEMh2vn2oV1diEqQ-1
Received: by mail-ed1-f69.google.com with SMTP id f21so10027436edx.23
        for <linux-sgx@vger.kernel.org>; Tue, 02 Feb 2021 10:03:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mLPn7R460RnvC3cVkzpTkUrq1JeELO52BKdk3debVIg=;
        b=M1dfgZLqaroUurqFEc4rCnzvyIdCegPcCV/o8/RxOUCXSENRnQSEg2MFobOrToOusq
         Q6K1KvQdN+O35hgzwG5Dpi8ZR/RVWzLJq7CTLJNul/6wU9I3bePGKD6b2yuq78v2awkt
         hz+Ba81J7bWNDdEeTRmvzU9BUi5EMwx6c16pvABCnPBny0yNIZFYi+VteJql3aCY9tIO
         5BvF3Vvm4jsmAodwkrM94EQWa9W9IhkaH8COCPiPIPNFtx9hdRyplMdNc3JbUho4y03w
         rk4xSMsiKwsUWs3fevIJy6ntxbLbYLPCdHcrUkFFuitl6pKjWQvSWt6cjWFpE4ZvLBvg
         hqVQ==
X-Gm-Message-State: AOAM530fHj/XEI4RuaD+37rjFmVJ80zitKIi+Lz+YrckzMoREjC1LYpM
        dTp4R9jY2BWe3oihDe+sgLfpvYTAYLRZYTvydLGaHHqiytb6JHiPpC6hioFXoilosd+OF+S7QqZ
        6BL5BPMiDosQBC5UkpuIn
X-Received: by 2002:a17:906:178d:: with SMTP id t13mr23170044eje.455.1612288999413;
        Tue, 02 Feb 2021 10:03:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzADgOhy6qNZuRtdUs4hh0I8tuFK0SynhOmPwZtOUx5lL+jJiUlY5P4NVnCn9SVSxL6EgWhzg==
X-Received: by 2002:a17:906:178d:: with SMTP id t13mr23170023eje.455.1612288999265;
        Tue, 02 Feb 2021 10:03:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i6sm9567406ejd.110.2021.02.02.10.03.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 10:03:18 -0800 (PST)
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
To:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, haitao.huang@intel.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
References: <cover.1611634586.git.kai.huang@intel.com>
 <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
 <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
 <3a82563d5a25b52f0b5f01560d70c50a2323f7e5.camel@intel.com>
 <YBVdNl+pTBBm6igw@kernel.org>
 <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
 <89755f15-a873-badc-b3d6-d4f0f817326e@redhat.com>
 <87a8a3f4-3775-21f1-cb67-107cca1a78e5@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <88e25510-a2e0-c4b8-4dcf-0afb78d5532c@redhat.com>
Date:   Tue, 2 Feb 2021 19:03:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87a8a3f4-3775-21f1-cb67-107cca1a78e5@intel.com>
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

On 02/02/21 19:00, Dave Hansen wrote:
>> /* "" Basic SGX */
>> /* "" SGX Enclave Dynamic Memory Mgmt */
> Do you actually want to suppress these from /proc/cpuinfo with the ""?
> 

sgx1 yes.  However sgx2 can be useful to have there, I guess.

Paolo

