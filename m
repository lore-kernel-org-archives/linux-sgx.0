Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAB5C433E6
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Feb 2021 00:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2826164EB4
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Feb 2021 00:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhBIAKG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Feb 2021 19:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhBIAKE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 8 Feb 2021 19:10:04 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE73C061786
        for <linux-sgx@vger.kernel.org>; Mon,  8 Feb 2021 16:09:23 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id q9so14550567ilo.1
        for <linux-sgx@vger.kernel.org>; Mon, 08 Feb 2021 16:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=akc8PS5t2j1XjbrR6CgcuGW0rLr1kbq6jUz31C/0DcU=;
        b=G2F2sqG02nvIMHDsvW1ah8tVs6aTUU86GWEoocC4s68fvFgZeBRfGPD0Afl2r8MQYj
         Adtu53Ykg2YAWTl9Y3epbLqnHAOyfEK0rQwhueBcFELvDhCWJugi/relPLWnpeDs3CD4
         IDP6+7CbgKHFicHGBs5Xezd8iQ4NyOSmeHw4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=akc8PS5t2j1XjbrR6CgcuGW0rLr1kbq6jUz31C/0DcU=;
        b=kauWFbmDGtN/Dy1s6865OcgyoZdCcKhf6cTQgAd40xMCemmHmPcmF9/H/dBrFucgxG
         ylMWEoTxaJxeH+DD5mnUl19CwmbqwVwdy8YvMrp5j+QzrP7jEP1qzDTSlJGz8teSpvza
         SeJAQsp8UTDSo5my49jfrDzo/6jXNG/LwiPYbi/7ukvQvezsJXrPE+PcM2u/ajioCuiU
         2L6zJZN31RylcLFRacCnIdUm6RC9dVtCgRtm2i1/0D0e76RxFIRlXz6ZigRMFNdETOJT
         JR9vlm6gkvLCpM3Pv02//eptxQr28DOqXGWPQPYFKbojjkjN1yEr9yD19+4ZEmiofQ1Q
         /aeQ==
X-Gm-Message-State: AOAM533GS+Mm83xIauIns+149KuNfa7YjyawhJv3zTeGOlFB3ZyyxTi0
        rLP9KOQxhoAY/GZFaV4RicI94Q7zlGMIbg==
X-Google-Smtp-Source: ABdhPJxzZq3u/EH2OoAq4jOquUIpYtQ02A5RoV3cCqrI+bgqsz6vcFfm1uqwrlwomHTLPxsVSGfhhQ==
X-Received: by 2002:a05:6e02:cd4:: with SMTP id c20mr17789361ilj.189.1612829363145;
        Mon, 08 Feb 2021 16:09:23 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f9sm9401648ilu.36.2021.02.08.16.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 16:09:22 -0800 (PST)
Subject: Re: [PATCH v4 1/5] selftests/x86: Use getauxval() to simplify the
 code in sgx
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Shuah Khan <shuah@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210201132653.35690-1-tianjia.zhang@linux.alibaba.com>
 <20210201132653.35690-2-tianjia.zhang@linux.alibaba.com>
 <YBnMCWW8tux490JK@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <91629d56-a890-18ac-7b10-b20229343d2f@linuxfoundation.org>
Date:   Mon, 8 Feb 2021 17:09:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YBnMCWW8tux490JK@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/2/21 3:02 PM, Jarkko Sakkinen wrote:
> On Mon, Feb 01, 2021 at 09:26:49PM +0800, Tianjia Zhang wrote:
>> Simplify the sgx code implemntation by using library function
>> getauxval() instead of a custom function to get the base address
>> of vDSO.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> This needs also ack from Shuah.
> 

Looks good to me. Thank you.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

