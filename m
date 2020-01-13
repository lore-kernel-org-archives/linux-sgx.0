Return-Path: <SRS0=xaf1=3C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07CCC33CAD
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 14:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B470920678
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 14:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zn7HtzR/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgAMOBH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 13 Jan 2020 09:01:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27527 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726976AbgAMOBH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 13 Jan 2020 09:01:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578924064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4oKEBQXoQCm4s9uriD6UPqkxdRy5/d5wiT56eUIpNi8=;
        b=Zn7HtzR/cZuYcOlU8dhZZoEiVN+oxaHGu9mHEtOUqAIswrIegpsWwjoEvdu4NEkozT3vpq
        j/em2Tix+DdmfcJHSbBK1YuSSj2k/sIH/u1wV3Y3kVkM4kA1KH8bSyJUw5K55o9j2s8Gcr
        5U1Tv5g9rRDBAwsncDscdD3J9vzqFGA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-IqRcqSekPQaGYxfxSvbfdQ-1; Mon, 13 Jan 2020 09:00:49 -0500
Received: by mail-wm1-f71.google.com with SMTP id p2so2535963wma.3
        for <linux-sgx@vger.kernel.org>; Mon, 13 Jan 2020 06:00:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4oKEBQXoQCm4s9uriD6UPqkxdRy5/d5wiT56eUIpNi8=;
        b=qGfYCDZoD9bNirwv69CvXM50PKmNxP1o9ynFiDDUSkOVmMEfd+iG8/sPQQMC+ICsUN
         IpPyUvKEKVLA/+iOJ+ZQcMEk9rNwLutrJZOZNn7bjT2XlrTzSx8Dw6sL54c9y2N56R5B
         2RLseauSo7Zey9dEfUDGRq+YDdZT4AeYr0vFFMP+GXQ2G6QRJUIsjAMFtralAbmebUzR
         wF83/CCWU1HtPrnonlGdVhc/RoEKthan9dbTEYg4Xhheze9NPiW30hQ1XG7/bAKeID4v
         IyCxerx732kdDpyqX5k38XAb92k7l0Lpz232FMsOXvBlU7IQrVbjrv9t7zOvKM6iNJ/4
         EueA==
X-Gm-Message-State: APjAAAUCxE55yhtZw7an2tNS1wtEAnqkIOww+vf2PLAd31dVVi/7C/VC
        kR2KwCCGwtDuDEFWLICVtp/RqK6aBmPMOhsIbc40iyvo+3vHcFxOLTCENihaTUKLx6AtkbiV3SE
        y5HyIlgUgBktd0NWkVRt0
X-Received: by 2002:adf:8b4f:: with SMTP id v15mr19126481wra.231.1578924047799;
        Mon, 13 Jan 2020 06:00:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqyGhec7vGC5TwOI3mdftLo6IbVY0hJBJLbbm6rqROcyLDQ/v6o11pHAmJN5QnrENvG0OagyVg==
X-Received: by 2002:adf:8b4f:: with SMTP id v15mr19126457wra.231.1578924047532;
        Mon, 13 Jan 2020 06:00:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:1475:5c37:e2e2:68ea? ([2001:b07:6468:f312:1475:5c37:e2e2:68ea])
        by smtp.gmail.com with ESMTPSA id z3sm15001822wrs.94.2020.01.13.06.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 06:00:47 -0800 (PST)
Subject: Re: v25-rc1
To:     Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200113035918.GA32455@linux.intel.com>
 <20200113084810.GB13310@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <95fc04cb-c305-2ef1-2449-ecb37796c661@redhat.com>
Date:   Mon, 13 Jan 2020 15:00:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200113084810.GB13310@zn.tnic>
Content-Language: en-US
X-MC-Unique: IqRcqSekPQaGYxfxSvbfdQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 13/01/20 09:48, Borislav Petkov wrote:
>> Before final v25, this patch set needs to reach mainline:
>>
>> https://lore.kernel.org/kvm/20191221044513.21680-1-sean.j.christopherson@intel.com
> ... and I'm still waiting for Paolo to agree on how to merge this.

Sorry I missed that.  What about sending me a topic branch, that will be
merged into both tip and kvm-next?

Thanks,

Paolo

