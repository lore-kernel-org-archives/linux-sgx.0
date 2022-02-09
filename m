Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6205EC433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Feb 2022 20:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiBIUUI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Feb 2022 15:20:08 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiBIUUH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Feb 2022 15:20:07 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8C6E040DC8;
        Wed,  9 Feb 2022 12:19:58 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id d14-20020a05600c34ce00b0037bf4d14dc7so1829794wmq.3;
        Wed, 09 Feb 2022 12:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CqsKKaBJAfyykjVru6LPSv6oTLCyk2AFIDEOcj0IiF4=;
        b=NelNrri3yMogvk8gqSHXFa4cVb5szYFxMDKoVZN2TwaJf6iFBXO/zj6b5IRdnMR0oa
         gtJtfzDARIKdTdzSAmKQNTsVlFsXlgaSayYfuFQ/0pIr2CHWpdOTzdS2t63yCW5mTN+F
         Oq6lUfLouPhxy7Eqy7zhhFMeop0BtTdKMRsfoA5ea5zjreAZ5veH/BvrY2xctjQeZ3YK
         ROil9vg7lA/7ojCiZ3wB8qgzcPOf+kw6Qa04ORkVwCf3S64uF9yCpThWqQkT5MbJGiwj
         V2dBxgTZxfpu+Fjt1ZeLbYR7wHvQR4NECvs77qdl6bJW36Wm3BtQEhOhtUafXWXGk/vH
         vfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CqsKKaBJAfyykjVru6LPSv6oTLCyk2AFIDEOcj0IiF4=;
        b=kC8cstvDkx5XxbykUrDO9gyeuFdkYQIfEYKJ0c4A0X9mJszyhyrFiEeEHJo/ms0o4j
         xhNZEY22SZQ6y6XYMyhldI/m/or56GAZqvxe8ektFRdPTg02j7wegVmkkJFWS/StkBDq
         A+FaMv/hF4Ii4CeHxPfaTLT0P4tHPiV3vNJyMWEzMeKT421VL1aetOKk0Zwu0JZEZvAz
         lWfNHr942Ij7LA2Hm7TsWr/t9o7DZ50s7sTPRzzFnfD6IHyu3si6ih6DlDPgGS1laAyI
         RisiIpcaU8LY6ohY/W+MVODvdFXptUHQde4bTi4BCamMsfdBWpX7NpGY80mj65TgkTJ0
         czyg==
X-Gm-Message-State: AOAM533Xiz5ZxozU/rQSyqb+y2HA0Sb8YapKBoCAmTE8hvSckGJ+1dDy
        b7+oXPm1BKy4WAiXpdtyFn36XV7TOfU=
X-Google-Smtp-Source: ABdhPJx0ge3CY/5UnNcF3/zeuPDxr0gKdbfDvc2PjmvToGDsvGCaiAoziAx2kp1oixA1AAGVbLwo6w==
X-Received: by 2002:a05:600c:1d8b:: with SMTP id p11mr4135039wms.115.1644437996681;
        Wed, 09 Feb 2022 12:19:56 -0800 (PST)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id r12sm16910256wrw.73.2022.02.09.12.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 12:19:55 -0800 (PST)
Sender: Alejandro Colomar <alx.mailinglists@gmail.com>
Message-ID: <0bdb594e-7c3d-e05a-0d40-eff92b4cd252@gmail.com>
Date:   Wed, 9 Feb 2022 21:19:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v11] sgx.7: New page with overview of Software Guard
 eXtensions (SGX)
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-man@vger.kernel.org, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        nathaniel@profian.com, Michael Kerrisk <mtk.manpages@gmail.com>,
        Reinette Chatre <reinette.chatre@intel.com>
References: <20211211153320.17438-1-jarkko@kernel.org>
 <c58f3951-282c-ef66-fc62-844da06c5af4@gmail.com> <YfNElmmBbkw1Xpfy@iki.fi>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <YfNElmmBbkw1Xpfy@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 1/28/22 02:19, Jarkko Sakkinen wrote:
> On Fri, Dec 17, 2021 at 02:50:56AM +0100, Alejandro Colomar (man-pages) wrote:
>> Hi Jarkko,
>>
>> Please see some comments below.
>>
>> Thanks,
>> Alex
> 
> Thank you. I've addressed all the comments below. However, I feel that
> /dev/sgx_provision is not properly documented at all. I also think that
> Reinette's argument for v10 was fair that "remove VEPC" ioctl that QEMU
> uses should not be left out from the initial patch set.
> 
> I'm implementing user space that doest attestation, so I rather write a
> proper description of the attestation, once it is working, rather than add
> to the number of review rounds.

Fair enough.  Please send an v12 with those comments addressed, and I'll
merge it!  (if you miss anything, we'll fix it later, don't worry)

Thanks,

Alex
