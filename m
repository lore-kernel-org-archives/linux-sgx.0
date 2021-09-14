Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AF6C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 10:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E7B6112E
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 10:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhINKUz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Sep 2021 06:20:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231308AbhINKUx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Sep 2021 06:20:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631614775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DRAlggCC+PYlUePAB0cF2Y6j/OP0F7mIhm9zbgJqV5g=;
        b=Bt0kNv/q4NZMamPIMD/8Fe4X3wcGWv1zk85EnYXvhHCi4PiuDtdlc4AOu7YiiQ/2ApMaLX
        /JaxtflW5d69M0kuqRuh3110nNoFyzCAJjp5OiUfIhY0qcMfz4dov0PcJGwWw6vL8lZxX7
        Pdhn+KNyKrquRMUTt6Am5o2gE7Tg394=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-WM-UxKZhM7CxQBVRdxykvg-1; Tue, 14 Sep 2021 06:19:34 -0400
X-MC-Unique: WM-UxKZhM7CxQBVRdxykvg-1
Received: by mail-ed1-f70.google.com with SMTP id n5-20020a05640206c500b003cf53f7cef2so6517903edy.12
        for <linux-sgx@vger.kernel.org>; Tue, 14 Sep 2021 03:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DRAlggCC+PYlUePAB0cF2Y6j/OP0F7mIhm9zbgJqV5g=;
        b=lc9d3HCADucKmCAcdPwd7Q3QUWcdcD5oJIhwr5BVQaZYe7eVYwmbk63eZmoDqQmxOY
         92Jk8Dp/z2vN7RUiMyGD2HzrewYZI5mMoJGQ+/9c8+AqO+5aI3Mpj86pFgMdxWJfPxTQ
         Kp1IKt1OIrT5yh1VHSESzhz4przd0x30kGgmYXNNZcLYUwTT3jyzgcI9Wep17g/j8B01
         9VfqCh40DFPAt/oLLq4ozCfXasGmpNMyTAEerrDb++hDDrrUI3cXJcf3+T65ZUykoKGW
         gGO5gwUYxDEtOZyW9ewu8DTHr2/WlaXAn+NYS5+/IRV7erfvlp7syyl9ebgGEwm4U9Rc
         2i1Q==
X-Gm-Message-State: AOAM531CG7ZJjS7nmPa4/UsXCCpeU00n0Z81pvKFuSWDbyCItNUFjf8c
        NYgtfsSVQ+Y9k1AmTRfjpgBCh0FACOuLLfPwcVZHx9/iCDAIPMVzDQZabM81uno5VSCn21+FWf9
        J10/GvCvo7u4FVlewkG5u
X-Received: by 2002:a17:907:76e7:: with SMTP id kg7mr16778432ejc.344.1631614773414;
        Tue, 14 Sep 2021 03:19:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbCELqwjjt8QQVuD+3BuPAl2MJy/czcHXmaprwjH6qzNCYuRmte+5SasZsQL6iipLwMo7OSg==
X-Received: by 2002:a17:907:76e7:: with SMTP id kg7mr16778412ejc.344.1631614773211;
        Tue, 14 Sep 2021 03:19:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dg18sm2398050edb.44.2021.09.14.03.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 03:19:32 -0700 (PDT)
Subject: Re: [RFC/RFT PATCH 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210914071030.GA28797@yangzhon-Virtual>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e1c6b6d-6a73-827e-f496-b17b3c0f8c89@redhat.com>
Date:   Tue, 14 Sep 2021 12:19:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210914071030.GA28797@yangzhon-Virtual>
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

On 14/09/21 09:10, Yang Zhong wrote:
> On Mon, Sep 13, 2021 at 09:11:51AM -0400, Paolo Bonzini wrote:
>> Based on discussions from the previous week(end), this series implements
>> a ioctl that performs EREMOVE on all pages mapped by a /dev/sgx_vepc
>> file descriptor.  Other possibilities, such as closing and reopening
>> the device, are racy.
>>
>> The patches are untested, but I am posting them because they are simple
>> and so that Yang Zhong can try using them in QEMU.
>>
> 
>    Paolo, i re-implemented one reset patch in the Qemu side to call this ioctl(),
>    and did some tests on Windows and Linux guest, the Windows/Linux guest reboot
>    work well.
> 
>    So, it is time for me to send this reset patch to Qemu community? or wait for
>    this kernel patchset merged? thanks!

Let's wait for this patch to be accepted first.  I'll wait a little more 
for Jarkko and Dave to comment on this, and include your "Tested-by".

I will also add cond_resched() on the final submission.

Paolo

