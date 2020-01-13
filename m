Return-Path: <SRS0=xaf1=3C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE72C33CA9
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 15:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BA3F21734
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 15:20:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJbVczFX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgAMPUk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 13 Jan 2020 10:20:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53740 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728811AbgAMPUk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 13 Jan 2020 10:20:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578928839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uk2Rw60C9empsCPBz+yjHsCIk1ZKyJSapT5XLrAHVms=;
        b=NJbVczFXfiSXxAoN8dOeYLfvCh392XCVRRCxo3/6XXAJyboxy/MrS1bXlNq5H+MECRYE81
        ZeXvpHQwtBlXh5FmjPQS5s9re6ZqTMVoB4O3qcTB48fCAF3tFTjqYwKDR4XYobboseKz1h
        01wNi39YL+HD+7giIXAgWdemu0mv3+U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-c0JzuBuuNvGOWbd3rcOSbQ-1; Mon, 13 Jan 2020 10:20:37 -0500
Received: by mail-wm1-f70.google.com with SMTP id q206so743186wme.9
        for <linux-sgx@vger.kernel.org>; Mon, 13 Jan 2020 07:20:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uk2Rw60C9empsCPBz+yjHsCIk1ZKyJSapT5XLrAHVms=;
        b=PS6vxa9PMzEHImxgubzY4+PmPrVZLfPD7Mp5Z0eaa0z/Zh04d4gtq13ryvcOVcmYkK
         pN+5tLO862mhM9bZp1dQ0omb6GbDH/TCfyOVIiRR/YD0uKPG2WD7gwgO5LJX5BaEasVN
         tXsKReG6GK3VbBwPwKJxc9E79ngB/oLMgF8JxazgeQUAttgTt+oyZ4Y5oeUHB228aZ1/
         hPBdmSQ1NBFb5qnJ0a+BaErVIQUj1mZ4DeRpuzb6RM9JJqrqs4V0Tbm3JJb6o+AE3Bfy
         U1etrRx2u0+UWCRknaUl8LmZhlpvD6SJTJd6rePxwCLxAtu1bOSZ10Y8t0BoqpHtnWZD
         vWAQ==
X-Gm-Message-State: APjAAAX2vlvGDADwXYGSlnX9WWRmYZ7o6Y56fJEeodg4E8o/y+TJLz03
        HHdDkV8Bpw3fxiz0eyztVfXdWdSBlZaBt/90satH65g1wtpnEXqWB6foAfjcIGDhKMQTJRxwwmN
        +dBFkzJhZ/MvaM15yNbfx
X-Received: by 2002:adf:df83:: with SMTP id z3mr19640241wrl.389.1578928836596;
        Mon, 13 Jan 2020 07:20:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqyuX80LXe7vG5R9Tep++dy/+n/FmqpEHR5D6l7UluSV9PcfFyy9LCUob6y6DDM17tTNllQawQ==
X-Received: by 2002:adf:df83:: with SMTP id z3mr19640218wrl.389.1578928836395;
        Mon, 13 Jan 2020 07:20:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:1475:5c37:e2e2:68ea? ([2001:b07:6468:f312:1475:5c37:e2e2:68ea])
        by smtp.gmail.com with ESMTPSA id y139sm15213176wmd.24.2020.01.13.07.20.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 07:20:35 -0800 (PST)
Subject: Re: v25-rc1
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200113035918.GA32455@linux.intel.com>
 <20200113084810.GB13310@zn.tnic>
 <95fc04cb-c305-2ef1-2449-ecb37796c661@redhat.com>
 <20200113140407.GI13310@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21550b11-3545-387c-f367-051919a1e193@redhat.com>
Date:   Mon, 13 Jan 2020 16:20:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200113140407.GI13310@zn.tnic>
Content-Language: en-US
X-MC-Unique: c0JzuBuuNvGOWbd3rcOSbQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 13/01/20 15:04, Borislav Petkov wrote:
> ... and I'll put all patches in it except the KVM ones:
> 
>   KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR
>   KVM: VMX: Use VMX feature flag to query BIOS enabling
>   KVM: VMX: Check for full VMX support when verifying CPU compatibility
>   KVM: VMX: Use VMX_FEATURE_* flags to define VMCS control bits
>   KVM: VMX: Allow KVM_INTEL when building for Centaur and/or Zhaoxin CPUs

Put them in too, it's even simpler.

Paolo

