Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53911C47082
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Jun 2021 13:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4210D61159
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Jun 2021 13:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFGOAS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Jun 2021 10:00:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60493 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230264AbhFGOAR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Jun 2021 10:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623074305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qaZbcAf5eiKLkS93+DRSvuWGnuST7UIbnXTeiPSRJ1s=;
        b=GoQ4kFS2iDH3JHRcY1DDdeGU5nmcNfbBnkKWg+mPmz57N0PrXLArpwDxKDfLy54WX4A/1e
        04nQA3XYNzS30PCAryywRYlRxslaGUUq3UG4AGbkA/6CntwSYCfoLxa4xGPrsl7r/a5vBh
        PkDoMyWmiUEOtxEPhsF/OnEj6VIogZ0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-hYzNRzq-N7CTlHTCgJhKiw-1; Mon, 07 Jun 2021 09:58:23 -0400
X-MC-Unique: hYzNRzq-N7CTlHTCgJhKiw-1
Received: by mail-wm1-f72.google.com with SMTP id w3-20020a1cf6030000b0290195fd5fd0f2so2849wmc.4
        for <linux-sgx@vger.kernel.org>; Mon, 07 Jun 2021 06:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qaZbcAf5eiKLkS93+DRSvuWGnuST7UIbnXTeiPSRJ1s=;
        b=oXSPr2dxKeEvYwfh/zpBTH//EhZjnylxv6qxcK3/W+JsqqYBaYkCzIDcr8QSOj+Sby
         IL8YBT4LLbrXBhmFOqJ6uQrRO62zOaYQXSXe/keK8hvVA8k2nngQh4TQsPzlNJ0tNgLq
         o/15sMejsNUKjE4l8jg9zQABfOOXmTTm47AeMXKPB7+Hzq7VnejTRBABxjrWdNl8YM5e
         qrI/Bpe8PWYuNeYkpsY2N7uvyoOrr1ETOI7uRnS0WI284fV+ilR4oWKsVZO35xpV1dNe
         pEBfUqMiQnqHBA69psXg9y44ERlDQXodxDSYJ5uv6n/JFNS/RulIdDmUSQgQ2+R8PEmN
         phDw==
X-Gm-Message-State: AOAM532TVAHomAy7vfNnx0UFd75IHOK76Zx5TL48R1RelUlxGHzVaz5a
        SmlJ/mlsSapBCxThAZjWFvtWD9RQAahKJ1Wa1B07ZCbW0DWcn9WC25pz+xwfR9N872keN2MJ6OF
        Y7d7DvL4kj9DKe1ve2sMT
X-Received: by 2002:adf:f043:: with SMTP id t3mr16841808wro.422.1623074301930;
        Mon, 07 Jun 2021 06:58:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1MZD6Vvun57JTNyHHjVmCPd//9h6LSDBCJGLlCz6Ek50lE2EWGyJmwHb5DdxDm7nOe7TD0w==
X-Received: by 2002:adf:f043:: with SMTP id t3mr16841771wro.422.1623074301708;
        Mon, 07 Jun 2021 06:58:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id o18sm6406465wrx.59.2021.06.07.06.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 06:58:21 -0700 (PDT)
Subject: Re: [syzbot] WARNING in x86_emulate_instruction
To:     Dmitry Vyukov <dvyukov@google.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     syzbot <syzbot+71271244f206d17f6441@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, jarkko@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kan.liang@linux.intel.com,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>, steve.wahl@hpe.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        the arch/x86 maintainers <x86@kernel.org>
References: <000000000000f3fc9305c2e24311@google.com>
 <87v9737pt8.ffs@nanos.tec.linutronix.de>
 <0f6e6423-f93a-5d96-f452-4e08dbad9b23@redhat.com>
 <87sg277muh.ffs@nanos.tec.linutronix.de>
 <CANRm+CxaJ2Wu-f0Ys-1Fi7mo4FY9YBXNymdt142poSuND-K36A@mail.gmail.com>
 <CACT4Y+YDtBf1GebeAA=twsfuv9e0HN+w7Lt5ZqDJhMJ5-PWYXQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fa3c04ea-f27f-eeb2-d118-77f8fb805a8a@redhat.com>
Date:   Mon, 7 Jun 2021 15:58:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACT4Y+YDtBf1GebeAA=twsfuv9e0HN+w7Lt5ZqDJhMJ5-PWYXQ@mail.gmail.com>
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

On 07/06/21 12:34, Dmitry Vyukov wrote:
> On Fri, May 28, 2021 at 2:34 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>>
>> On Fri, 28 May 2021 at 08:31, Thomas Gleixner <tglx@linutronix.de> wrote:
>>>
>>> On Fri, May 28 2021 at 01:21, Paolo Bonzini wrote:
>>>> On 28/05/21 00:52, Thomas Gleixner wrote:
>>>>>
>>>>> So this is stale for a week now. It's fully reproducible and nobody
>>>>> can't be bothered to look at that?
>>>>>
>>>>> What's wrong with you people?
>>>>
>>>> Actually there's a patch on list ("KVM: X86: Fix warning caused by stale
>>>> emulation context").  Take care.
>>>
>>> That's useful, but does not change the fact that nobody bothered to
>>> reply to this report ...
>>
>> Will do it next time. Have a nice evening, guys!
> 
> There was an idea to do this automatically by syzbot:
> 
> dashboard/app: notify bug report about fix patches
> https://github.com/google/syzkaller/issues/1574
> 
> Namely: if syzbot discovers a fix anywhere (by the hash), it could
> send a notification email to the bug report email thread.
> The downside is that the robot sends even more emails, so I am not
> sure how it will be accepted. Any opinions?

I would like it.  Usually somebody replies _before_ they start working 
on it, but sometimes they send a patch right away.

Paolo

