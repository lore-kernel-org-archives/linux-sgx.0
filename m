Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1724AC433E6
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 16:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFDF9233EF
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 16:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391610AbhATQoB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:44:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390572AbhATQk7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 20 Jan 2021 11:40:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611160760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oQZfi4/Ce6D+3G99X+rNeEgrjpz/uKCb6ET5YSMJWLw=;
        b=EbMOdg+waz7DLZE+S5164Cr8kdiSok4bJNlYNJ3USeUhw/gtVOR6dkezm78NuD4Yjzy7qp
        91dn6QxfQLmdoKGALwawpxlQ4Xxa8FUGEMmpKIcdIrHplT/2q3/VjhWrw0/2jqW+Ul+qn1
        XRHpNme1Bqb3Eg05uwiy/xfbogXWB2I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-fylXKDsrMFSg-JKBpkWrRQ-1; Wed, 20 Jan 2021 11:39:17 -0500
X-MC-Unique: fylXKDsrMFSg-JKBpkWrRQ-1
Received: by mail-ed1-f70.google.com with SMTP id 32so9193251edy.22
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 08:39:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oQZfi4/Ce6D+3G99X+rNeEgrjpz/uKCb6ET5YSMJWLw=;
        b=meVlRkm2L+x+fLnuvHpTpDK1f3LhOe7NY69jH2P3+i9pJlaeQ4B31nqasH2yHhxwEl
         KTLeKfuzVBDLHux6zS1yhR/0GSppFMJN8zUBMOzeKLPrs46N+DgZUOMb/2stXntQUEyD
         jGq5mraRDrJJyMdSaWywCMAGpyoljYYI1Hn/E1JEbfXagJLeS2HT6vDHeyeHgd0Rj8/M
         3KCSBb222TWA0GTS16fDpGcWylOP5EJ/QJh2XPzsTBC70TRG5pJgA6cQnUoo3WaqNIy1
         8vGIN+HGZYOwsyVRrxrXTDIK7M31XAjnSoJOAWf2yvyG9DU98IX4GhZbUFVgF9QFaCVk
         Qv1w==
X-Gm-Message-State: AOAM531IBAxYfAI2MPH+6dpu96ELmGwcTYBEwpvXSfCWXG0kjs1WKCex
        cQ9k/MwiCt1elMftcKIKxcIfK4tC7v41TwadkI6SSt0pt9wPphZLB07wJSqDrUxPm7cKO6tep1a
        wu37MiuQ3Tz86GaEk1+le
X-Received: by 2002:a17:906:4151:: with SMTP id l17mr6963878ejk.54.1611160755920;
        Wed, 20 Jan 2021 08:39:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykBNkBj13lbMYLDJqbA4i/REeVCtiqYGD3w8w8hrVK4Ws+SkWQUFGojSHBZDpgHglL9Woc1Q==
X-Received: by 2002:a17:906:4151:: with SMTP id l17mr6963862ejk.54.1611160755782;
        Wed, 20 Jan 2021 08:39:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g2sm1105143ejk.108.2021.01.20.08.39.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 08:39:15 -0800 (PST)
Subject: Re: [RFC PATCH v2 00/26] KVM SGX virtualization support
To:     Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
References: <cover.1610935432.git.kai.huang@intel.com>
 <YAaW5FIkRrLGncT5@kernel.org>
 <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
 <YAhb1mYB3ajc2/n9@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7cd130cc-cda5-97d5-7c25-99fe813de824@redhat.com>
Date:   Wed, 20 Jan 2021 17:39:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YAhb1mYB3ajc2/n9@google.com>
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

On 20/01/21 17:35, Sean Christopherson wrote:
> On Wed, Jan 20, 2021, Kai Huang wrote:
>> I'd like to take this chance to ask: when this series is ready to be merged, what is
>> the properly way to merge? This series has x86 non-sgx (cpufeature, feat_ctl) and sgx
>> changes, and it obviously has KVM changes too. So instance, who should be the one to
>> take this series? And which tree and branch should I rebase to in next version?
> The path of least resistance is likely to get acks for the x86 and sgx changes,
> and let Paolo take it through the KVM tree.  The KVM changes are much more
> likely to have non-trivial conflicts, e.g. making exit_reason a union touches a
> ton of code; getting and carrying acked-by for those will be tough sledding.
> 

Yes, the best way is to get a topic branch from Thomas or Borislav.

Paolo

