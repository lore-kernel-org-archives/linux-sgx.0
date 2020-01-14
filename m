Return-Path: <SRS0=lkUJ=3D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604DDC33CB1
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jan 2020 10:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AF3924676
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jan 2020 10:44:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ATLoUUfT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgANKo5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:44:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40240 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728746AbgANKo4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Jan 2020 05:44:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578998695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yVnj0Jtl+p7yXdiYyCGaqcJzs+UG+XAxoLlEGu34OvQ=;
        b=ATLoUUfTskcIcdfvHWoBF/m7Po2N1v4pnM/Qvd6jAk4VFM775jlgpTk1MBL8GHV053/6GD
        nNheim68XlEfPZ+ykSvPosy1qrFkE0MyMSRHVOCgLNAfenhZ9UeCQqzctPUCzWzktoOc+p
        GwrmLaz+9uTrmNjXZ+22jYE7u3m9V5A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-KsBHqmfaMm6jzApCRO7B3A-1; Tue, 14 Jan 2020 05:44:55 -0500
Received: by mail-wr1-f72.google.com with SMTP id i9so6317121wru.1
        for <linux-sgx@vger.kernel.org>; Tue, 14 Jan 2020 02:44:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yVnj0Jtl+p7yXdiYyCGaqcJzs+UG+XAxoLlEGu34OvQ=;
        b=iWbx9m8Cr0fGoZmsiKAorKVuefkpnePY9Cgj9+MnV07xLVwGn+XhGV+Godyt8PV4Hl
         pK2R3cTGGw/2cegrfYZpJGxvXsVGvumgZFRrWGdzv9KWphHNfvYmRBL0cUNb/gdoP7xz
         l6iJ+JgjhQI5go3urEXZpMcIvzDL/yqmeOaoncQUSX9fBU2Gxmbl3FFmhJfkCtlVSMxn
         Vs9MrREp/Ek77m+qTlrDMoJwoovpGM3l5LPOOhB6TldO4TnUo3Qu4x+h+3gO67DRTn/m
         oP+L7dMW7sZ/Z3C17bp1Y8WyRRkiivbAvRaLrTa6V+qQi2RPuzbjFY/9KV4dA/pqGpGI
         Ctlw==
X-Gm-Message-State: APjAAAVuRVA5+sRJSwCavyeMfTd8bmC/NpWKd04+YYQQNyUZp5oRusQB
        J5iekB0vByrcGQ7jpwQ4q3B51U1pcBr555rBw6FJe6mitBiPC8niYa0k3QNK2bT9cjrrcjre7Ep
        v2kZUYUXQ8GSv1Mg/pqp1
X-Received: by 2002:adf:e3d0:: with SMTP id k16mr24605678wrm.241.1578998693608;
        Tue, 14 Jan 2020 02:44:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxmlctFY07dQlh/A37wI8ot/VgKSuZBTCxre58iQXNSy1DSIkORgRG/3ER468hPJeJKroBKgw==
X-Received: by 2002:adf:e3d0:: with SMTP id k16mr24605651wrm.241.1578998693332;
        Tue, 14 Jan 2020 02:44:53 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id l15sm18282143wrv.39.2020.01.14.02.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 02:44:52 -0800 (PST)
Subject: Re: v25-rc1
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200113035918.GA32455@linux.intel.com>
 <20200113084810.GB13310@zn.tnic>
 <95fc04cb-c305-2ef1-2449-ecb37796c661@redhat.com>
 <20200113140407.GI13310@zn.tnic>
 <21550b11-3545-387c-f367-051919a1e193@redhat.com>
 <20200113160748.GJ13310@zn.tnic> <20200114093921.GC31032@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7aa767e6-c8fa-669b-9bda-26ad18d31615@redhat.com>
Date:   Tue, 14 Jan 2020 11:44:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200114093921.GC31032@zn.tnic>
Content-Language: en-US
X-MC-Unique: KsBHqmfaMm6jzApCRO7B3A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 14/01/20 10:39, Borislav Petkov wrote:
> JFYI: there'll be a merge conflict, below is me merging into linux-next
> from today.
> 
> Also, don't forget to fixup CPU_BASED_USE_TSC_OFFSETTING with "TT" since
> you hav                                                                e
> 
>   5e3d394fdd9e ("KVM: VMX: Fix the spelling of CPU_BASED_USE_TSC_OFFSETTING")
> 
> in your tree but this tree still has:
> 
> + #define CPU_BASED_USE_TSC_OFFSETING             VMCS_CONTROL_BIT(TSC_OFFSETTING)
> 
> Lemme know if there's something else I should do.

Nope, thanks for the heads up.  The topic branch will remove the need
for Linus to solve the conflict so it's definitely the way to go.

Paolo

