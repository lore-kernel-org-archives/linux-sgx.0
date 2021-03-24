Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1181CC433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 11:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAB3B61A11
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 11:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhCXLZC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Mar 2021 07:25:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232889AbhCXLYn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 24 Mar 2021 07:24:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616585083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lh92eKH08v+5P713WfsuE7oYAeLerhzo8+IyAgchy40=;
        b=JE24VgcWr+Gocs0ukC7SGnMkxlb05HIFdwmjcrQFS979/Yltz7q09PouG2Cu8cs95DyTH/
        Igemqf6LpmRqe3CWtL75gos207i1W3NSkTPuRBhl2TvwZisykwnTlilTXHRMHwqUkhxxFB
        1loc9shbvR4LmJpNs8HBuN8KsFzWqlM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-woLAWaJgOaSdpIKndmwQxw-1; Wed, 24 Mar 2021 07:24:41 -0400
X-MC-Unique: woLAWaJgOaSdpIKndmwQxw-1
Received: by mail-wm1-f70.google.com with SMTP id f9so381228wml.0
        for <linux-sgx@vger.kernel.org>; Wed, 24 Mar 2021 04:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lh92eKH08v+5P713WfsuE7oYAeLerhzo8+IyAgchy40=;
        b=IeI92G2dQH7KOP1BoXlIsoBVU8YpnuEOdud3ZrEbrmCrThFNmonVKdZrlmsN6U2fVJ
         RPaAhK9G7v+fDJBWMr8W/EEnIidHOg7jZoY+TguFqfGjRACOEVDiCsSDAQXPRY7jC3MB
         h7sIrfPoEsahVNaDaAQojYOxbMDAfacbq8hmpBHLDVr5BM0F6IbF6Bry4w4yPVV8Aoud
         xpUw4tG+DRq1HmXHU+4LEShvhxfAm0YocO4aPComuNljAt96HkSweh2rPfur7v1c0rjZ
         JCf0Bav6iemYBgwe9RB+dWFa9ImowmibC/+JxIrIIZLG2BT4oAeVBFfukNnPptk6GkVi
         FGZg==
X-Gm-Message-State: AOAM532rnQHfGu+pqyIAJT2zk7BJAk+Q2nifs65uGtATmCMVCexD5hiW
        NDgiNTOuXAjhO75zfzJAHlbOjW6UnQUA16oP7bcxMhsR9/gTNzs2MbJRka2xAmH47n/SkZBaKUl
        jWhSB3FdcmI8QEK0HYO91
X-Received: by 2002:a5d:47c4:: with SMTP id o4mr2910650wrc.138.1616585080068;
        Wed, 24 Mar 2021 04:24:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzISiGwzhOJ3OFW1AOV7TUCEjxSzOLMAw0VEpovQznGB5jkO7qA6BNwL6xgIZ4D1NB0cUGCFQ==
X-Received: by 2002:a5d:47c4:: with SMTP id o4mr2910626wrc.138.1616585079801;
        Wed, 24 Mar 2021 04:24:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id s9sm2306712wmh.31.2021.03.24.04.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 04:24:38 -0700 (PDT)
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Kai Huang <kai.huang@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
References: <YFjoZQwB7e3oQW8l@google.com> <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com> <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com> <20210323160604.GB4729@zn.tnic>
 <YFoVmxIFjGpqM6Bk@google.com> <20210323163258.GC4729@zn.tnic>
 <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
 <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
 <20210324234839.bf5bef54fd7a84030cf1bcf8@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <da541070-e884-4f97-531d-d97409a42e02@redhat.com>
Date:   Wed, 24 Mar 2021 12:24:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210324234839.bf5bef54fd7a84030cf1bcf8@intel.com>
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

On 24/03/21 11:48, Kai Huang wrote:
>>> +/* Error message for EREMOVE failure, when kernel is about to leak EPC page */
>>> +#define EREMOVE_ERROR_MESSAGE \
>>> +       "EREMOVE returned %d (0x%x), kernel bug likely.  EPC page leaked, SGX may become
>>> unusuable.  Please refer to Documentation/x86/sgx.rst for more information."
>> Rewritten:
>>
>> EREMOVE returned %d and an EPC page was leaked; SGX may become unusable.
>> This is a kernel bug, refer to Documentation/x86/sgx.rst for more information.
> Fine to me, although this would have %d (0x%x) -> %d change in the code.
> 

Yeah you can of course keep the 0x%x part.

Paolo

