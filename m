Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CCBC433B4
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Apr 2021 17:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF2E611F2
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Apr 2021 17:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239743AbhDSRPJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Apr 2021 13:15:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233867AbhDSRPI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 19 Apr 2021 13:15:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618852477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eylKqSPDKz9S5T2Q/ChqqD4u0vbwKNM9iAmrwjM6+PU=;
        b=aT697xUKPPFBTTkQj+j1XzwePuEd5B9GPnpBQFqgDVpNODLWUiQIJQTYVXXYH785/jLGbS
        oe06txL2PqiPyE1StRr6S0oBarJZbs2/U4UNXG7x8DFCVMuiF8jo7RQqHvfJnh5Y9fdZ7k
        ZwH+pOgbaEBmgDcrNVy1Zl9iKLmuN9U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-2bT_OYcqMdK-OkCT_aiUKg-1; Mon, 19 Apr 2021 13:14:18 -0400
X-MC-Unique: 2bT_OYcqMdK-OkCT_aiUKg-1
Received: by mail-ed1-f70.google.com with SMTP id i18-20020aa7c7120000b02903853032ef71so2625482edq.22
        for <linux-sgx@vger.kernel.org>; Mon, 19 Apr 2021 10:14:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eylKqSPDKz9S5T2Q/ChqqD4u0vbwKNM9iAmrwjM6+PU=;
        b=X6Wcrmb5gJCI5uK5V/lHvN4rsnLnbJxBitn55VW90SIF+pAj2Nw5m03AkZ5uo8IUkU
         8Jb0/la/Xfb43Ub0YnGAiS36lXETX+p2TWkKNASL65RpMTTT/LjXdM7V8d36WHRNb5bR
         RmhYL3LjXnJNqNeg28pN3Av3zaiadfvsmWpqrY1BfLP3AzYAL0RRBjwwh7n8EpDqqV97
         4PMVpReDKdhkIS8iLh5Wck4wekFSuqnpoPoTHE2mWuo5YCwCuPV6LiP9WK7Q7cpbbJB3
         Y4FzpEP9Nmyd5z0xQwCjBXyN5O7efLj7p60v6ryGZQ1p7ZQIYcqN2+yyb95n3Za2qCc9
         gMGA==
X-Gm-Message-State: AOAM530UuntKbDM4l7jQcHWnQuIh1DdAuyXS60tbhrXfrjtWewUvB+7C
        DL5hXZCsw0AXgjgVhrFEsS6GEUFRFn6UANWQq7Rbjpc8H6UV2hxQ3/5wBtfRmGUz6R9mInnYYqV
        d/feFXFYnPUP1iPF/jwFv
X-Received: by 2002:a17:906:70c4:: with SMTP id g4mr10585009ejk.443.1618852456747;
        Mon, 19 Apr 2021 10:14:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyz7HtCdHIFmzmfa3Pq5QOAbWngw9gcL3kk+4xm7U7h633rYwfO6lJbpER/0gieLXM52ttO2g==
X-Received: by 2002:a17:906:70c4:: with SMTP id g4mr10584990ejk.443.1618852456585;
        Mon, 19 Apr 2021 10:14:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q2sm10801191eje.24.2021.04.19.10.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 10:14:15 -0700 (PDT)
Subject: Re: [PATCH v5 10/11] KVM: VMX: Enable SGX virtualization for SGX1,
 SGX2 and LC
To:     Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
 <a99e9c23310c79f2f4175c1af4c4cbcef913c3e5.1618196135.git.kai.huang@intel.com>
 <9f568584-8b09-afe6-30a1-cbe280749f5d@redhat.com>
 <3d376fef419077376eecb017ab494ba7ffc393a7.camel@intel.com>
 <YH2e1lIckOBY2OGa@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <acff71e3-4a38-b858-551c-8b34cbf344af@redhat.com>
Date:   Mon, 19 Apr 2021 19:14:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YH2e1lIckOBY2OGa@google.com>
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 19/04/21 17:16, Sean Christopherson wrote:
> On Mon, Apr 19, 2021, Kai Huang wrote:
>> On Sat, 2021-04-17 at 16:11 +0200, Paolo Bonzini wrote:
>>> On 12/04/21 06:21, Kai Huang wrote:
>>>> @@ -4377,6 +4380,15 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>>>>    	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
>>>>    		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
>>>>    
>>>>
>>>> +	if (cpu_has_vmx_encls_vmexit() && nested) {
>>>> +		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX))
>>>> +			vmx->nested.msrs.secondary_ctls_high |=
>>>> +				SECONDARY_EXEC_ENCLS_EXITING;
>>>> +		else
>>>> +			vmx->nested.msrs.secondary_ctls_high &=
>>>> +				~SECONDARY_EXEC_ENCLS_EXITING;
>>>> +	}
>>>> +
>>>
>>> This is incorrect, I've removed it.  The MSRs can only be written by
>>> userspace.
> 
> vmx_compute_secondary_exec_control() violates that left, right, and center, it's
> just buried down in vmx_adjust_secondary_exec_control().  This is an open coded
> version of that helper, sans the actual update to exec_control since ENCLS needs
> to be conditionally intercepted even when it's exposed to the guest.

Hmm, that's true.  I'll place back the version that you had.

Paolo

>>> If SGX is disabled in the guest CPUID, nested_vmx_exit_handled_encls can
>>> just do:
>>>
>>> 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
>>> 	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING))
>>> 		return false;
>>>
>>> and the useless ENCLS exiting bitmap in vmcs12 will be ignored.
>>>
>>> Paolo
>>>
>>
>> Thanks for queuing this series!
>>
>> Looks good to me. However if I read code correctly, in this way a side effect would be
>> vmx->nested.msrs.secondary_ctls_high will always have SECONDARY_EXEC_ENCLS_EXITING bit
>> set, even SGX is not exposed to guest, which means a guest can set this even SGX is not
>> present, but I think it is OK since ENCLS exiting bitmap in vmcs12 will be ignored anyway
>> in nested_vmx_exit_handled_encls() as you mentioned above.
>>
>> Anyway, I have tested this code and it works at my side (by creating L2 with SGX support
>> and running SGX workloads inside it).
>>
>> Sean, please also comment if you have any.
>>
>>
> 

