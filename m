Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90650C433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Sep 2021 05:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722E26113E
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Sep 2021 05:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347557AbhIHFhS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Sep 2021 01:37:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346949AbhIHFhS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Sep 2021 01:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631079369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dFD339gZoGagg4tSSmQme6S+gWZOs2ChudJRNUISs54=;
        b=HevrQU/guIvoqFmZlZZlPPFy6d/ZC8T3/g9omj6WJ2eFIZj0pKFqs6jJyOmJCdyPcgHZwW
        kewSuCooxvY++aqAcYvD3ZVfgOIt+HuXnyA8wI7dbUGMz/5JVoAsl226P7y3BXi6304y8j
        o8TrboOhBz7B9Q2t6HGm1pYjCvgq7Ys=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-fhpn83JTMZuxuhNm9JCXPA-1; Wed, 08 Sep 2021 01:36:08 -0400
X-MC-Unique: fhpn83JTMZuxuhNm9JCXPA-1
Received: by mail-ej1-f71.google.com with SMTP id n18-20020a170906089200b005dc91303dfeso432144eje.15
        for <linux-sgx@vger.kernel.org>; Tue, 07 Sep 2021 22:36:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dFD339gZoGagg4tSSmQme6S+gWZOs2ChudJRNUISs54=;
        b=hJDxp0/FNN45zMgfuAlN+2ROQi93uh0bsMUJ0a/imJzpJFYm0TZAQSRy1SzKik2hDr
         nqkOdpqa0AucL9ZyiyuDohXB0XQlLLMCsAnE0Tsz//JlDXdyegVhqtrqPlHlljxAKU4n
         Cv2laS8Padav4UC8oMWrKJsqPG0A14mVcdTj9A+DPSx/cXnm1ikaLX2c0PdaYlknsQWY
         NBD8JUwxH+pccbIcSSUvv3jQT0DU6NlnmfihK79hC9dPHW9FsVfUKsuxnnWoDwf0yhW0
         2LE+Wc+SB68h6VdjfQ2mLwj6WkePs+BsPoO3YyFt3g3RyvOQzR0y+WnHvcvyyyvTHWS8
         QBIQ==
X-Gm-Message-State: AOAM532Yxmyu2Wzul1NOF3WWPS8vVGjswdsUn9b7wciv4SbRWatGEfjg
        Unb/Dg5+U5PUIqTPNbDJJHHAvabhHhde9hNOGYrqsie3wNAWArkcHjvjobf3AUL9rVLfJLs8jE1
        X08eIeYC6UeJrwiL95Tix
X-Received: by 2002:a50:ab42:: with SMTP id t2mr2084744edc.113.1631079367434;
        Tue, 07 Sep 2021 22:36:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyc6RwiUcNrrlYLIs4pe6r1E3Z5trGvuncJEIl8W+/WZ0elXTSBFJvbD524S8a0IU4LMkBsQ==
X-Received: by 2002:a50:ab42:: with SMTP id t2mr2084726edc.113.1631079367262;
        Tue, 07 Sep 2021 22:36:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q9sm383547ejf.70.2021.09.07.22.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 22:36:06 -0700 (PDT)
Subject: Re: [syzbot] WARNING: kmalloc bug in memslot_rmap_alloc
To:     Sean Christopherson <seanjc@google.com>,
        syzbot <syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, mingo@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Gardon <bgardon@google.com>
References: <0000000000006096fa05cb454a9c@google.com>
 <YTehmR1+G34uOHh3@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2e6b9e6d-30b4-6cb4-1eb7-c626e5d2adb3@redhat.com>
Date:   Wed, 8 Sep 2021 07:36:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YTehmR1+G34uOHh3@google.com>
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

On 07/09/21 19:30, Sean Christopherson wrote:
> The allocation in question is for KVM's "rmap" to translate a guest pfn to a host
> virtual address.  The size of the rmap in question is an unsigned long per 4kb page
> in a memslot, i.e. on x86-64, 8 bytes per 4096 bytes of guest memory in a memslot.
> With INT_MAX=0x7fffffff, KVM will trip the WARN and fail rmap allocations for
> memslots >= 1tb, and Google already has VMs that create 1.5tb memslots (12tb of
> total guest memory spread across 8 virtual NUMA nodes).

We can just use vmalloc.  The warning was only added on kvmalloc, and 
vmalloc suits the KVM rmap just fine.

The maximum that Red Hat has tested, as far as I know, is about 4TiB 
(and it was back when there was no support for virtual NUMA nodes in 
QEMU, so it was all in a single memslot).

Paolo

