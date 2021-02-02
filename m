Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F14C433E0
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 18:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 504F664F69
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 18:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbhBBSAK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Feb 2021 13:00:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233969AbhBBR6E (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 2 Feb 2021 12:58:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612288598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dN94EaBZoEheJv2bVKF3aVQ488mV21cwDUunabYy/Qg=;
        b=hv7ntu2ImIGe6t8jFPVdClNrqgL0H++Tpfk48pkpT33hYw7v75FvzdLLjPCWfuMWSDPotU
        vbQ3ORDizXkd1sO3nK+KLdEzQsAluiqrCox0E0pYJYT7tvGLi5xPr2PGnPZCPjq+Ug/3Vh
        8Tnu0i5lngSEnlGjAhlWGwL2ZXV2k1I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-XG-DO64NOwqbLAq__YZ-bg-1; Tue, 02 Feb 2021 12:56:37 -0500
X-MC-Unique: XG-DO64NOwqbLAq__YZ-bg-1
Received: by mail-ed1-f70.google.com with SMTP id x13so9997024edi.7
        for <linux-sgx@vger.kernel.org>; Tue, 02 Feb 2021 09:56:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dN94EaBZoEheJv2bVKF3aVQ488mV21cwDUunabYy/Qg=;
        b=RDfDKwa+9jcFAA/6foLtdhpvSWrSflIOEngUKZGbccf8a//XFxxSgE2GNoj01xUK0D
         C1YOtducYO2zWUF17Zrqv487VXQtY+xQEjgeptXTm6404SxQsSTeatJP57/mkHHf8AaC
         zMYxzpBVSqQEZceVXZ7HFxQUMBAGnZ6ICpmK3MgYMc+uusPQqCWiWrqttfwxfrzatGYK
         I+178EX946xSxpCtK+1+Pd8Tcv+Dt21/eGGok/6i0jZiWJHzcLJehr1+XUNHW/GtFzAc
         5M/sgEBLQKBT3avUBBLnZ+19mKaNdjn+bh7d24jxhna0v4JhM4jDbGRR48kVMm8M4rnr
         F8VA==
X-Gm-Message-State: AOAM533qNez7PVUtTRlm0w+7m7Qza6DuMkBnErJOSiQ8PEkfPSSb/tNV
        g3fYFVLfZxExiP9chAq7v5+1dx9QIdOiFrY8lelX42s2J+nqN+rzyrEe4iXxIc2PWu12CX1m+qh
        KHNXpo493FGvo7+eOkPlC
X-Received: by 2002:aa7:c884:: with SMTP id p4mr139197eds.212.1612288595838;
        Tue, 02 Feb 2021 09:56:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweACfB87YxeuSAxTmHEDhxNUQg9iEM2Fqa37a/m/k4cY0OXCQZyW6QjL2h5dDB1cEfiavzBA==
X-Received: by 2002:aa7:c884:: with SMTP id p4mr139189eds.212.1612288595650;
        Tue, 02 Feb 2021 09:56:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z20sm10334643edx.15.2021.02.02.09.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 09:56:34 -0800 (PST)
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
To:     Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
References: <cover.1611634586.git.kai.huang@intel.com>
 <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
 <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
 <3a82563d5a25b52f0b5f01560d70c50a2323f7e5.camel@intel.com>
 <YBVdNl+pTBBm6igw@kernel.org>
 <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <89755f15-a873-badc-b3d6-d4f0f817326e@redhat.com>
Date:   Tue, 2 Feb 2021 18:56:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
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

On 01/02/21 01:01, Kai Huang wrote:
>>> I think we can remove comment for SGX1, since it is basically SGX.
>>>
>>> For SGX2, how about below?
>>>
>>> /* SGX Enclave Dynamic Memory Management */
>> (EDMM)
> Does EDMM obvious to everyone, instead of explicitly saying Enclave Dynamic
> Memory Management?
> 
> Also do you think we need a comment for SGX1 bit? I can add /* Basic SGX */,
> but I am not sure whether it is required.
> 

Yes, please use

/* "" Basic SGX */
/* "" SGX Enclave Dynamic Memory Mgmt */

Paolo

