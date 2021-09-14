Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593ECC433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 05:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF5C60EB6
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 05:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbhINFiI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Sep 2021 01:38:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38770 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239672AbhINFiH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Sep 2021 01:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631597809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZQpALJRO2DRj77s2ycL1tcep9ZQbvDn5QtKFTncmIU=;
        b=H7Kp3yNeFhoQ0hWL0UoejFWcroaSK/CJTfN5erwvTmabbaU6HxAdccCJa+HucNkYV3U/Jb
        i8IF/asWuO7JqYg3HBGLMeDzzyasN9/aZGdOBDDvf2KSOTskcA9XQ+oBQjXShHlRDZrZMj
        3kX2PykxH/HwmtZTdhgiCqstHsEzpcs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-EtlTnZLVNwKptq1yNONjeA-1; Tue, 14 Sep 2021 01:36:48 -0400
X-MC-Unique: EtlTnZLVNwKptq1yNONjeA-1
Received: by mail-ed1-f69.google.com with SMTP id e7-20020aa7d7c7000000b003d3e6df477cso56100eds.20
        for <linux-sgx@vger.kernel.org>; Mon, 13 Sep 2021 22:36:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZQpALJRO2DRj77s2ycL1tcep9ZQbvDn5QtKFTncmIU=;
        b=pc1nPq6Rpj1GYgPemdWidZJMkpTw6OxnBNqDNI0ACRqcenfHaZrAmAMHwB58KXKce5
         O3fsgV27NwKlRgBD/LvN4tajdfOn4lhLl9AoHYuBL8bt7eA1oqYRa0pXsj6MulejuV4u
         H6GlVTvseaR4FAJ5syQlAWSaxSpMmWkv+iobC45oxrHgwbdyiaQz6b6laHgzIXmlDgPM
         ts01PXU72VfzipGshPaMqOYYX23ba85V99FzoMMvkBlhfGwB3wCJoo/yimoZ63x9doWp
         PL9NAwIBS9xdEbc86KJJa9geRSNn3AHxYrOgRdETxvts9j+ZoP9t22ZQiwLoouJWwb6d
         CKSQ==
X-Gm-Message-State: AOAM5339uYEIZaPQ0mBSHHwlqo9WxQis72iLDGSIbog7gl3g8HPludyy
        kGTtkzrTj8GkfAl3zJFVYInm57ACueWIYWQKMlVWVIF5vIh+YCZQzO51pNqf+CjEqu5p8sCwYfH
        xzNy7ZIdMEu32PII3i+te
X-Received: by 2002:aa7:d619:: with SMTP id c25mr17109539edr.365.1631597806944;
        Mon, 13 Sep 2021 22:36:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmANg/+bLpe7zpuvdvos4IkOjD3/HKp62bKU9//cD9FY70/rlU7rBvF5UxBlMBoRQft30l5g==
X-Received: by 2002:aa7:d619:: with SMTP id c25mr17109523edr.365.1631597806770;
        Mon, 13 Sep 2021 22:36:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e11sm1494456ejm.41.2021.09.13.22.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 22:36:45 -0700 (PDT)
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210913131153.1202354-2-pbonzini@redhat.com>
 <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
 <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
 <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
 <34632ea9-42d3-fdfa-ae47-e208751ab090@redhat.com>
 <3409573ac76aad2e7c3363343fc067d5b4621185.camel@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <734abf89-8be2-dd13-b649-fde5744ba465@redhat.com>
Date:   Tue, 14 Sep 2021 07:36:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3409573ac76aad2e7c3363343fc067d5b4621185.camel@kernel.org>
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

On 13/09/21 23:13, Jarkko Sakkinen wrote:
>> Apart from reclaiming, /dev/sgx_vepc might disappear between the first
>> open() and subsequent ones.
>
> If /dev/sgx_vepc disappears, why is it a problem *for the software*, and
> not a sysadmin problem?

Rather than disappearing, it could be that a program first gets all the 
resources it needs before it gets malicious input, and then enter a 
restrictive sandbox.  In this case open() could be completely forbidden.

I will improve the documentation and changelogs when I post the non-RFC 
version; that could have been done better, sorry.

Paolo

