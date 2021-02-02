Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF9FC433E0
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 18:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1222F64F97
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 18:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbhBBSE1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Feb 2021 13:04:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237978AbhBBSC0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 2 Feb 2021 13:02:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612288859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Xo/ste6mcKDasiY2TP0mhB7WxKM/bwzUGagnvWcl28=;
        b=P51UIpvk8GemtIYLBlg2ak5kaU03FMqKYH8QKY7AS1XRxxhn5u7kkZdC4NVH8m7A7zIrsv
        +t1QA0If9SKg+rBXQGwa3jVuJx3frkJVoBsla5vmCXOUudFil3BXdZgBFI0eo8JIPPgCR9
        LdZbJJA2wzh6WGGID02w0+mfJ2Yb0L0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-l5F6lugTNceON4ps_e1IlQ-1; Tue, 02 Feb 2021 13:00:52 -0500
X-MC-Unique: l5F6lugTNceON4ps_e1IlQ-1
Received: by mail-ed1-f69.google.com with SMTP id a24so9939885eda.14
        for <linux-sgx@vger.kernel.org>; Tue, 02 Feb 2021 10:00:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Xo/ste6mcKDasiY2TP0mhB7WxKM/bwzUGagnvWcl28=;
        b=ePFSwjleoXFWtO1moGsRPrZYLLK4fQDFjCC8Y125PaiJvpe9cokS1Nj9Zh1rdFxWZ9
         LlXNJQMuu0JWLGOCVs4kvEf9GTyAer8esbxbhDRXooMZ/qihz3yalOL0+c/bNXxZJU2f
         H7DAUCUvAm3i24n13/GWqkLQ7GifsugQanQn5SHI9M1S+62O9mGM4CZMTZSNAAeRsC4p
         Js/ewaIlyTtFMdPf10ibYgNlt9svAsVK//iqEfH8AUfjBZUmwYyfh7+e3L981TFi7jU/
         yHNyK8DhaunsfbdCEMi61a24CUW7Uj8T20riPan4Txlio2jJHFvpGBdNB0O6VGpnKoGN
         nmpg==
X-Gm-Message-State: AOAM5300tPofLO7hznp2LaROz33IA0mgvRityOfSaMqn42pleYP6knt5
        qOIsmzMXaW4Ue95eDwO4RCwZslNIbb8AQRU/LjcLa/Ih62I/+3UYUSdGIps4s5Pmfdm3Z9YQrAV
        gfQ/58OG87WA+BAGPfBp5
X-Received: by 2002:a05:6402:3553:: with SMTP id f19mr108419edd.271.1612288851497;
        Tue, 02 Feb 2021 10:00:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6E/THy8dCvBqoufmpSDqbBDoV6tnoQXAMUyy8ufzV4ooUyX80TCNxOcS4oMEXqF5ZNHS54g==
X-Received: by 2002:a05:6402:3553:: with SMTP id f19mr108393edd.271.1612288851291;
        Tue, 02 Feb 2021 10:00:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u2sm9792589ejb.65.2021.02.02.10.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 10:00:49 -0800 (PST)
Subject: Re: [RFC PATCH v3 04/27] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
References: <cover.1611634586.git.kai.huang@intel.com>
 <d93adaec3d4371638f4ea2d9c6efb28e22eafcb3.1611634586.git.kai.huang@intel.com>
 <8250aedb-a623-646d-071a-75ece2c41c09@intel.com>
 <20210127142537.9e831f66f925cbf82b9ab45d@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <32df1e72-b53d-bdf7-9018-a5eee4550dc4@redhat.com>
Date:   Tue, 2 Feb 2021 19:00:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210127142537.9e831f66f925cbf82b9ab45d@intel.com>
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

On 27/01/21 02:25, Kai Huang wrote:
> On Tue, 26 Jan 2021 08:04:35 -0800 Dave Hansen wrote:
>> On 1/26/21 1:30 AM, Kai Huang wrote:
>>> From: Jarkko Sakkinen <jarkko@kernel.org>
>>>
>>> Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
>>> sgx_reset_epc_page(), which is a static helper function for
>>> sgx_encl_release().  It's the only function existing, which deals with
>>> initialized pages.
>>
>> Yikes.  I have no idea what that is saying.  Here's a rewrite:
>>
>> EREMOVE takes a pages and removes any association between that page and
>> an enclave.  It must be run on a page before it can be added into
>> another enclave.  Currently, EREMOVE is run as part of pages being freed
>> into the SGX page allocator.  It is not expected to fail.
>>
>> KVM does not track how guest pages are used, which means that SGX
>> virtualization use of EREMOVE might fail.
>>
>> Break out the EREMOVE call from the SGX page allocator.  This will allow
>> the SGX virtualization code to use the allocator directly.  (SGX/KVM
>> will also introduce a more permissive EREMOVE helper).
> 
> Thanks.
> 
> Hi Jarkko,
> 
> Do you want me to update your patch directly, or do you want to take the
> change, and send me the patch again?

I think you should treat all these 27 patches as yours now (including 
removing them, reordering them, adjusting commit message etc.).


>> OK, so if you're going to say "the caller must put the page in
>> uninitialized state", let's also add a comment to the place that *DO*
>> that, like the shiny new sgx_reset_epc_page().
> 
> Hi Dave,
> 
> Sorry I am a little bit confused here. Do you mean we should add a comment in
> sgx_reset_epc_page() to say, for instance: sgx_free_epc_page() requires the EPC
> page already been EREMOVE'd?

I also don't understand Dave's comment.  I would say

It's the caller's responsibility to make sure that the page is in 
uninitialized state with EREMOVE (sgx_reset_epc_page), EWB etc. before 
calling this function.

Paolo

