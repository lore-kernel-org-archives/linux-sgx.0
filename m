Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE9CC433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Sep 2021 15:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3065D6108B
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Sep 2021 15:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344737AbhIMPQP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:16:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347129AbhIMPPb (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 13 Sep 2021 11:15:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631546055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLiPuLulR0KEA9PC+ni4AmJzEqtKLqvlUOW8UTnUXUA=;
        b=TkUeuPD+RktE4BDxw18sinAGZ/GQmOwTcKUWBZ9CEcFut8dEZ46OV/ZJrNyuQZ6CjtJixm
        BP5F4BapauovUYiI7xbrnp/lFd0BvxCLAzrxTGh8T9ybV4+f/grPC5pcbNti4M+SdAdhq7
        H+RMDofCw3vxXrszfcOtlNJ7UIDCnk0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-6ETt1WV-PtOFXgvPW5gHsg-1; Mon, 13 Sep 2021 11:14:14 -0400
X-MC-Unique: 6ETt1WV-PtOFXgvPW5gHsg-1
Received: by mail-ej1-f69.google.com with SMTP id ak17-20020a170906889100b005c5d1e5e707so3806399ejc.16
        for <linux-sgx@vger.kernel.org>; Mon, 13 Sep 2021 08:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qLiPuLulR0KEA9PC+ni4AmJzEqtKLqvlUOW8UTnUXUA=;
        b=bizYekKWzUgkYVujBEvt96HX8DYMf5iRZKHnLAtIiuaxeMLCejHS6yEfkHHzP/Hd3+
         tqpcW9mrnH4aKzoSvewnrVqgkQqwjmey/fytuuco2R5P1MvzzJaoSgQh7tghS3dciY3R
         bmTQaO8Z621KycnqnrUP4Uo4wOEc+AwyN411LnxafMdm+LYrIMQ6W3VNMk4NYnIzKXQP
         Ic3UqFmqTUeScV3AzKlIr0vRRRXp27YbLvVf+jDv6zxP5zGPuQ8NNEV+/Yi0w9CMUYGS
         i5vMBOstcOtNe3Kx/IyuvH+NOi78YIKXcDG5aKlgPoK4k3NcS5me4LY2b9aOjDF65J9S
         sNtA==
X-Gm-Message-State: AOAM530HJfaC4agVV0pQ0299KZcpo94/sbqWRL3fN8hMElxLhpx+xDZO
        g1p5wStmkbESz6Kc4voVNehbkXV4juBiNhUdufv/CVEbG6m3NbqQKljX8Q4LWL1Va4CpZ0txAB7
        7NtMYXLo3iplwv52Lhn7t
X-Received: by 2002:a05:6402:26c4:: with SMTP id x4mr10020110edd.95.1631546050206;
        Mon, 13 Sep 2021 08:14:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXlKwyLGX/MszHYats7cUI5Peb1wU+RRlbm432xsjeZYS7I2KrziDTrcT1CMh7Kk82MNf3XA==
X-Received: by 2002:a05:6402:26c4:: with SMTP id x4mr10020087edd.95.1631546050016;
        Mon, 13 Sep 2021 08:14:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id eg14sm4193586edb.64.2021.09.13.08.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 08:14:09 -0700 (PDT)
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210913131153.1202354-2-pbonzini@redhat.com>
 <dc628588-3030-6c05-0ba4-d8fc6629c0d2@intel.com>
 <8105a379-195e-8c9b-5e06-f981f254707f@redhat.com>
 <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
Message-ID: <34632ea9-42d3-fdfa-ae47-e208751ab090@redhat.com>
Date:   Mon, 13 Sep 2021 17:14:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <06db5a41-3485-9141-10b5-56ca57ed1792@intel.com>
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

On 13/09/21 16:55, Dave Hansen wrote:
>> By "Windows startup" I mean even after guest reboot.  Because another
>> process could sneak in and steal your EPC pages between a close() and an
>> open(), I'd like to have a way to EREMOVE the pages while keeping them
>> assigned to the specific vEPC instance, i.e.*without*  going through
>> sgx_vepc_free_page().
> Oh, so you want fresh EPC state for the guest, but you're concerned that
> the previous guest might have left them in a bad state.  The current
> method of getting a new vepc instance (which guarantees fresh state) has
> some other downsides.
> 
> Can't another process steal pages via sgxd and reclaim at any time?

vEPC pages never call sgx_mark_page_reclaimable, don't they?

> What's the extra concern here about going through a close()/open()
> cycle?  Performance?

Apart from reclaiming, /dev/sgx_vepc might disappear between the first 
open() and subsequent ones.

Paolo

