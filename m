Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFA6C433C1
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 23:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9442B61A28
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 23:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238655AbhCXXjZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:39:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238641AbhCXXjJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 24 Mar 2021 19:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616629149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IwWYUWbH/O+ZLyF6/ulGgJAuRE4t3ADflrWSsYnyfOo=;
        b=aQM8+Kg7HX4gh8w0FKH78s8vji9brQtgEhY4cgWDcPZxZnhP6ksZbUL0FY/0n6MQipX1nR
        KH6+wHcXMJGl6b36+adDfTDxsnx0cPWts0TVsCenSTLgiKHG9uRDtIH/d4D5wXO0dxlYON
        jrYA1xNTpmu6QXjGKKG8bq6trr7jgx8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-19XtHHUOMDqbMBv-dtQLtw-1; Wed, 24 Mar 2021 19:39:05 -0400
X-MC-Unique: 19XtHHUOMDqbMBv-dtQLtw-1
Received: by mail-wr1-f69.google.com with SMTP id x9so1733214wro.9
        for <linux-sgx@vger.kernel.org>; Wed, 24 Mar 2021 16:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IwWYUWbH/O+ZLyF6/ulGgJAuRE4t3ADflrWSsYnyfOo=;
        b=hTcHOQhWHx3ODo1TXEzYdFnZvgRHBDwA0mZ2CEY0hqQZkaAUUwfzQtPYURY0M2vZaM
         mF58io+mcae4AoMcvPcdJ9KL9RhQcVkbsh/ohTLJTi0PS5a1RcXJqeNpFrby7z1s4YsM
         ywHf6yIVrSE3KzOsQ4e6Gz/RlTlaAmkUHu8JrgMGMDZBcsFG8dPLTQiMikZGgP+v7tL8
         x8ORo4tZgkOlwUx08IVbyX825Nt7l06Ua54X0q45lACUdG6i1ZqWXVFPLWLzw+Tffwqx
         103UzXCDSDX7BimfL0yv1so8MOed05oq7QUWoc7Bbgk8oREcoBq3APGGnh1UFsic+pzR
         q+gA==
X-Gm-Message-State: AOAM530Lj+4MSYsUnHDyvnAC51kc6rTpEcwPhsgtTHaWmO230lPQ9XKh
        aGXemryfm7MYZxqgOw34hib+mP5AEJOknVXJ5dBoK1QDgYIToAEHy6e5gBj54tVkDGjOoo7hl/H
        sASyoPA6Qg7X3+pG4gA5+
X-Received: by 2002:a7b:c399:: with SMTP id s25mr5003496wmj.124.1616629144399;
        Wed, 24 Mar 2021 16:39:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXwn0MoeyxCDyz8NSf8yX5IpbArGpPL9aZKH6/X67zK8iNOQIaVxgtrIvPshMsUd92GFsCIA==
X-Received: by 2002:a7b:c399:: with SMTP id s25mr5003479wmj.124.1616629144189;
        Wed, 24 Mar 2021 16:39:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id 21sm4308042wme.6.2021.03.24.16.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 16:39:03 -0700 (PDT)
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
 <20210325122343.008120ef70c1a1b16b5657ca@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e833f7c-ea24-1044-4c69-780a84b47ce1@redhat.com>
Date:   Thu, 25 Mar 2021 00:39:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210325122343.008120ef70c1a1b16b5657ca@intel.com>
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

On 25/03/21 00:23, Kai Huang wrote:
> I changed to below (with slight modification on Paolo's):
> 
> /* Error message for EREMOVE failure, when kernel is about to leak EPC page */
> #define EREMOVE_ERROR_MESSAGE \
>          "EREMOVE returned %d (0x%x) and an EPC page was leaked.  SGX may become unusuable.  " \
>          "This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more information."
> 
> I got a checkpatch warning however:
> 
> WARNING: It's generally not useful to have the filename in the file
> #60: FILE: Documentation/x86/sgx.rst:223:
> +This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more

Yeah, this is more or less a false positive.

Paolo

