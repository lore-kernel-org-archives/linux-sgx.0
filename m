Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE87C433DB
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Mar 2021 19:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAF34619A0
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Mar 2021 19:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhCVTMW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Mar 2021 15:12:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47702 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231826AbhCVTMG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 22 Mar 2021 15:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616440325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UfnyDJKd+AIhgsgjhm7fjzOjPp4nvTJYPKMus8kh4Is=;
        b=F0+MLa17xC+D2q9rbpbeo+J2h04zQwBWwRKOzW/LiON+J2Jv6MVe7HTAhV6IexdRUOhnrW
        PL2qiYlKxacr0jOtJ0LH3INq9zuo31WqRdwN8D5yRHc06JdRiQFNS848QARAhid/cfILzi
        cw7zWmr7lt6slOGsPN+1L8QVtGi+T7Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-V8Kl8UozOFurgjR5C4a3Jg-1; Mon, 22 Mar 2021 15:12:01 -0400
X-MC-Unique: V8Kl8UozOFurgjR5C4a3Jg-1
Received: by mail-wr1-f71.google.com with SMTP id z6so26535183wrh.11
        for <linux-sgx@vger.kernel.org>; Mon, 22 Mar 2021 12:12:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UfnyDJKd+AIhgsgjhm7fjzOjPp4nvTJYPKMus8kh4Is=;
        b=GRxCe69t5aj6Q6G0E0fSVRk59JzS7ZvTJ33IRwzSDTBibuWxXVQDbGKGesj+6E338b
         ml6koJwH5IsPykV/ic/oqNvvMHJNvGAD/3pAzOZDNVnR3Jp8J3TY4hA5WM5f7jYCut4Q
         meYbuX8xNe+9YOVTWfEHgls//wQDI9JZZSQOLepFevq1O4pIFEBI6Bz9hEQBidfzo99w
         9LVVWDl9gzBqOF3NhVeg/zl4DRAa2AMorIqE2T6mB7eAry6ysbaHMaxNfd6lM+zAdMUt
         m4XEna/m46tm0z5/RpfE4PsPvdMpbNBYxN5jHaPXN2dpyc+zrjL5ZuOhMlGWL2qLKri+
         XVPw==
X-Gm-Message-State: AOAM533L0eqHSjkicRRRpemaZ8MIFqm2U6TNBgjEbv23U0wplLF55qEc
        kHuAT/ol/ipX5RBWgGQX5ajUFPAsUr48r1fiQlwCjZfO1+LBFxkc3J2vRSjkwFiUpZRmt1e7NkM
        u4U1m77M5kqKJ5jxDjA5j
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr71231wrd.47.1616440320267;
        Mon, 22 Mar 2021 12:12:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/cLnNqtKWv7V1/Fpeb5aRH7hZpgdnHA/Zo2qiXqHKF8asFjWbETSgysqD6vFP3G2Q+t5LNw==
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr71209wrd.47.1616440320100;
        Mon, 22 Mar 2021 12:12:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x11sm347291wme.9.2021.03.22.12.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 12:11:59 -0700 (PDT)
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
References: <cover.1616136307.git.kai.huang@intel.com>
 <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic> <YFjoZQwB7e3oQW8l@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2e01d7b-255d-bf64-f258-f3b7f211fc2a@redhat.com>
Date:   Mon, 22 Mar 2021 20:11:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YFjoZQwB7e3oQW8l@google.com>
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

On 22/03/21 19:56, Sean Christopherson wrote:
> EREMOVE can only fail if there's a kernel or hardware bug (or a VMM bug if
> running as a guest).  IME, nearly every kernel/KVM bug that I introduced that
> led to EREMOVE failure was also quite fatal to SGX, i.e. this is just the canary
> in the coal mine.

That was my recollection as well from previous threads but, to be fair 
to Boris, the commit message is a lot more scary (and, which is what 
triggers me, puts the blame on KVM).  It just says "KVM does not track 
how guest pages are used, which means that SGX virtualization use of 
EREMOVE might fail".

Paolo

