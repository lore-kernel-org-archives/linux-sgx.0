Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAD7C433DB
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Mar 2021 16:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6734F61993
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Mar 2021 16:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhCWQjK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:39:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233268AbhCWQjF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 23 Mar 2021 12:39:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616517544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D6weZtocFnBCEx2KB5301dgGufT240mULVdpXRdDCN0=;
        b=TJTAE7xPRdyGR5DuArQcmMfStDPThO2PemoLbkFplHIPTsMkzGFpKuyN8zf6Z53dLe4P0L
        Qg7dXNpmsAa598nIteWC8fulQEtrRR3F3g3lmeerq4onsHXT4VlU6ZhtwU0o6Zs3rqzVWq
        LJLG9e3SiH5uon9s9AIXLqTJq0umwio=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-xiUp0Q4VMfuj0tW6-yFdgQ-1; Tue, 23 Mar 2021 12:39:02 -0400
X-MC-Unique: xiUp0Q4VMfuj0tW6-yFdgQ-1
Received: by mail-wm1-f70.google.com with SMTP id n17so699135wmi.2
        for <linux-sgx@vger.kernel.org>; Tue, 23 Mar 2021 09:39:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D6weZtocFnBCEx2KB5301dgGufT240mULVdpXRdDCN0=;
        b=Zp9eHSNmaOpMUEQ7rZFaOP+xKZ26TNpE37u1v7Dzf2qOp6hWDfegYJgCW0eKbjAJIp
         a+hqdznbvOzFnXtKdq0Kwr9YTgqzCFJTICWAdtvWHd2anX8jXtuAYEKRiSjUj8QPQ/y3
         qQUASDnS9bAPaeg5D+s4gGWC50nqJkbUe16ax8NBRW9KofCjcFE/VjgqnDYn6/PIu8vV
         BDdrOGXj43TsLxlyEHVmRfhwEplUzYz7BxPmy4TSBdvgjESMhMJUZFpfJmb9GGvCMQrD
         2qdv1/vtEUH69cRs525zd0HgOkslA4/2nRswL9T7q8l4o9oT4Trr8xXAhwuG/4wnyKjc
         hJRw==
X-Gm-Message-State: AOAM532FgDNedXg8vofcaoeKCEuVv2uDBZbdW5QUGhpbJ1nkj4Dix2t8
        FCFhkb8zOx2qbI53x4vTouuTxAl5FlV5X65ndqdqrZGqfF3BX7jML5W18dkKqHlVgoTD5OpOZF3
        g0pU08PrVAMRhCvOjsXgq
X-Received: by 2002:adf:8562:: with SMTP id 89mr4930798wrh.101.1616517541374;
        Tue, 23 Mar 2021 09:39:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKvUUe1NQSERBzHVlgA+GOPmHPOwJubTjgP1O9G/oYv5jEATOiJ0EW7ujfn570henkj75IQA==
X-Received: by 2002:adf:8562:: with SMTP id 89mr4930777wrh.101.1616517541194;
        Tue, 23 Mar 2021 09:39:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j136sm3281428wmj.35.2021.03.23.09.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 09:39:00 -0700 (PDT)
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
References: <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic> <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic> <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com> <20210323160604.GB4729@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41dd6e78-5fe4-259e-cd0b-209de452a760@redhat.com>
Date:   Tue, 23 Mar 2021 17:38:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210323160604.GB4729@zn.tnic>
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

On 23/03/21 17:06, Borislav Petkov wrote:
>> Practically speaking, "basic" deployments of SGX VMs will be insulated from
>> this bug.  KVM doesn't support EPC oversubscription, so even if all EPC is
>> exhausted, new VMs will fail to launch, but existing VMs will continue to chug
>> along with no ill effects....
>
> Ok, so it sounds to me like*at*  *least*  there should be some writeup in
> Documentation/ explaining to the user what to do when she sees such an
> EREMOVE failure, perhaps the gist of this thread and then possibly the
> error message should point to that doc.

That's important, but it's even more important *to developers* that the 
commit message spells out why this would be a kernel bug more often than 
not.  I for one do not understand it, and I suspect I'm not alone.

Maybe (optimistically) once we see that explanation we decide that the 
documentation is not important.  Sean, Kai, can you explain it?

Paolo

