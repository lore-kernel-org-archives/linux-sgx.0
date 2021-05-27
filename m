Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2573DC47089
	for <linux-sgx@archiver.kernel.org>; Thu, 27 May 2021 23:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 089DE6113B
	for <linux-sgx@archiver.kernel.org>; Thu, 27 May 2021 23:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbhE0XXI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 May 2021 19:23:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236631AbhE0XXF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 May 2021 19:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622157691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nCWKzoy9kj1pT7s/LMAs2R0z3NMNhJpdEi2dqYprz/8=;
        b=AOKA4Sk6x1T+F8ZHPC2QSGD6sjwIhMjgKTUKZcDPAWJTAX0AvzjuSQfBJpSuUTQ15BNrp5
        V7JzX/J/Lde8johbmdW9QncVERnZbjVdj1DN9hflcFyU0FtDth9Yg619YNnz8F8enVjPoj
        +1/S9fCZH4Adm/83ku4jp4kyRa8ond0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-V2j0xtPDPPyDuwNayJLSuQ-1; Thu, 27 May 2021 19:21:27 -0400
X-MC-Unique: V2j0xtPDPPyDuwNayJLSuQ-1
Received: by mail-ej1-f72.google.com with SMTP id w13-20020a170906384db02903d9ad6b26d8so645775ejc.0
        for <linux-sgx@vger.kernel.org>; Thu, 27 May 2021 16:21:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nCWKzoy9kj1pT7s/LMAs2R0z3NMNhJpdEi2dqYprz/8=;
        b=NE+/PbpKpvoW58ccZSEWl5Tr02Y2XKLQae7c+0+3ZOTjdZ9TCzoA5BDuypWWFP0HKz
         574gcIHmZALERgunEUSeqhj76TFgFSnCQFgJpHAPj6f3qbzGwc7+kEBinTkmX4DOwUUC
         IO5CpGmBz0S53pJ6Axi2t9b80q5uHXtmUZit3Pzj8LJyBJRvIOIFBDfjd1sNMAnV7yz9
         kxUZQdHdZskZ5MghxhSnUEqhZFO7i7pO1RKtqdGY8Mbai0AshnUz/ikUDVGjiUKSkT3V
         585z29Jsg352is4ob6dD4Pq8j9Hp49S+q0Dodxakqct3qmkr7NgU5qBRHQAVZG42wgUt
         MUQA==
X-Gm-Message-State: AOAM531NnttInqJVw0uiXDVoCdipwwfyEyi4pFVaDpJkiL7Ksqgxhdi0
        9og9LEDNZUhMP0o1DMMzFZqgfEIZeB8m0A6addTUkltKPccHge6mSNJHcwxRYMBaBhWk1mHZWVo
        oNcQA44aOEagtVQX/mIIb
X-Received: by 2002:a17:906:68c:: with SMTP id u12mr6263659ejb.470.1622157686503;
        Thu, 27 May 2021 16:21:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzgiXFMi0YlkhIN3byuem1Kgwi4TTcVzAYR+6zTso/Cq/N5U9JF7ehTOA7isPY90/EHZ2CWQ==
X-Received: by 2002:a17:906:68c:: with SMTP id u12mr6263641ejb.470.1622157686347;
        Thu, 27 May 2021 16:21:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e22sm1889267edu.35.2021.05.27.16.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 16:21:25 -0700 (PDT)
Subject: Re: [syzbot] WARNING in x86_emulate_instruction
To:     Thomas Gleixner <tglx@linutronix.de>,
        syzbot <syzbot+71271244f206d17f6441@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, peterz@infradead.org, seanjc@google.com,
        steve.wahl@hpe.com, syzkaller-bugs@googlegroups.com,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <000000000000f3fc9305c2e24311@google.com>
 <87v9737pt8.ffs@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0f6e6423-f93a-5d96-f452-4e08dbad9b23@redhat.com>
Date:   Fri, 28 May 2021 01:21:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87v9737pt8.ffs@nanos.tec.linutronix.de>
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

On 28/05/21 00:52, Thomas Gleixner wrote:
> 
> So this is stale for a week now. It's fully reproducible and nobody
> can't be bothered to look at that?
> 
> What's wrong with you people?

Actually there's a patch on list ("KVM: X86: Fix warning caused by stale 
emulation context").  Take care.

Paolo

