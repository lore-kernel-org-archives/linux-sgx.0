Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D8DC433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 17:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA38961151
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 17:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhINRIt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Sep 2021 13:08:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230008AbhINRIl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Sep 2021 13:08:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631639243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VSPaTs/Ana3c5AjdJic+DfXIvcN63Hc2gA/Tf0kL54c=;
        b=L5YzArE2ZYPhCEnuYwEcBNKJ7gV9Y66vX6a7uW9JWw0V+uX06gVf0jj2GHrGOvYF8RuUzB
        0XdzgVV4oyhOrmCBAdDiknrC4WEId3l88p6Z7JXheomGNx9h5UN5jnqdhwVVpHOrLzXQWT
        1AHAMjt1tYtvLNA4aT//TFl+/M+hCxg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-UbS1oxN4OA-kBCQ0McXtDw-1; Tue, 14 Sep 2021 13:07:20 -0400
X-MC-Unique: UbS1oxN4OA-kBCQ0McXtDw-1
Received: by mail-ej1-f72.google.com with SMTP id r21-20020a1709067055b02904be5f536463so8384ejj.0
        for <linux-sgx@vger.kernel.org>; Tue, 14 Sep 2021 10:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VSPaTs/Ana3c5AjdJic+DfXIvcN63Hc2gA/Tf0kL54c=;
        b=uoqHCkOihtjnsCwpR1Bhe7CU8O4H3vbQwUx6gzN2ojgZ9rx5SfFeVQGBoCK+McF21S
         qDpW2xHwQMg/GkJdVqEBrvhH2f7fPzGZB8zbx6Ar4RTyZX5zFFG5QnBwJJkT1p88x7Jr
         B300WICtHYc1ln61vcIsoz04i0kWzC+7Hlhlot0a1DMh3g828i99pPWAdkB+8Cs1DRMI
         SO0qZEYg3qXu7oKMLbfAsjExQu14Sy3GBR076WJCF1grfRsjFCMbWkpjLYPRxt5c1OlF
         GuO3Nnn1AJD4u848Y4r1tIc/DE4XYzQJ4iUUfyyCCn/WpF60pt5EOXjFvQD9c2WVS0sQ
         Meyg==
X-Gm-Message-State: AOAM5338SwuYdWxpHeY2CLeKTTwT+jIxFwLORhEWYzk4ThG43RMwY94J
        wOlvvq5ghqykTWURw0P1bI1bovx9n6BdgMOKYdIKvhAInEJvC8bWwRXLatTXDOZXT6VD7gUcXWK
        1cQ8MTwGbV6Zk5DKPSqDq
X-Received: by 2002:a17:906:6148:: with SMTP id p8mr19508106ejl.17.1631639239595;
        Tue, 14 Sep 2021 10:07:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyz+fGJykczhq+9IbbmATrEW/jUyWNpQF9sYky1OwNDGdYkM+u3sKi6b2acRNQYiL90BljSkw==
X-Received: by 2002:a17:906:6148:: with SMTP id p8mr19508091ejl.17.1631639239377;
        Tue, 14 Sep 2021 10:07:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id h2sm5905306edd.43.2021.09.14.10.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 10:07:18 -0700 (PDT)
Subject: Re: [RFC/RFT PATCH 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Yang Zhong <yang.zhong@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210914071030.GA28797@yangzhon-Virtual>
 <8e1c6b6d-6a73-827e-f496-b17b3c0f8c89@redhat.com>
 <fb04eae72ca0b24fdb533585775f2f20de9f5beb.camel@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1afa3ed3-d77b-163d-e35e-30bf4f5d3a9e@redhat.com>
Date:   Tue, 14 Sep 2021 19:07:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fb04eae72ca0b24fdb533585775f2f20de9f5beb.camel@kernel.org>
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

On 14/09/21 18:42, Jarkko Sakkinen wrote:
>> Let's wait for this patch to be accepted first.  I'll wait a little more
>> for Jarkko and Dave to comment on this, and include your "Tested-by".
>>
>> I will also add cond_resched() on the final submission.
> Why these would be conflicting tasks? I.e. why could not QEMU use
> what is available now and move forward using better mechanism, when
> they are available?

The implementation using close/open is quite ugly (destroying and 
recreating the memory block breaks a few levels of abstractions), so 
it's not really something I'd like to commit.

Paolo

