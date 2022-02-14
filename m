Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B05C433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Feb 2022 21:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiBNVAQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:00:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiBNVAP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 14 Feb 2022 16:00:15 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345CA15B982
        for <linux-sgx@vger.kernel.org>; Mon, 14 Feb 2022 13:00:03 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id f13so13321377ilq.5
        for <linux-sgx@vger.kernel.org>; Mon, 14 Feb 2022 13:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2wZJbdTfpo7iXD69QMlhy8jUhbjvxJ1xWrqMBSAFcxI=;
        b=RaKgYvDC1w1SCgT1O6gDTYjDDGxquf+UgjnTkl84HMl/FmLZ7hfBAZg6Ef5umJfQ73
         BysBuNsGfvIUTxfTA1H96WsOdUEmauZRBs6TS1AHYHQSjzz+S6SA/UFhNtODJ5+QxAFZ
         UAN3G3kV2O5sG6jntb5tkoB01w1SN13dU/1kI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2wZJbdTfpo7iXD69QMlhy8jUhbjvxJ1xWrqMBSAFcxI=;
        b=TuwMuolVVE9utS5Ykps3Wm8hnOCd3o3WdpiWd58vk5spe8etJtXO8OuIki8EMBX46M
         4tE6aYnk9Ewx8mHaf6nnO400HpCgHjbUNy5DRNsbjNWijxp8GlPaT5nmKMcXoC50YyXH
         aFGFqaZeMj9z1ewGS1FKGsiVb30Q9q4jHyLheQ3Yl8nsNm2zeMiL+fwacLqRTgB/7oPO
         1McpZ+J9CNFzuX2pXFnTFCdsDpkiGArjEYdEedkw2a9UHw+E4u4E9+KAuP1iR4kEZzij
         w7/2XAW6w/jYe9bM9EuPurT8kC3Rl7DEdN8MONS2hE3M2THlnsXR/VSRJ4+FZzS+Vy00
         NEcQ==
X-Gm-Message-State: AOAM530ZZNOhHW+hcPmxb+a5Q2s/oawBo7f0gqvf7jNgSxKEcPiYbA01
        /rRvSSBnNq37/6avl3h3yc6tIg==
X-Google-Smtp-Source: ABdhPJx57do0GjCIjdw2SoDd29KXMYNHF9pvXnPL0FZMgucvaDnLzBZmUu41yHaQT5+YMMjDeqBE0Q==
X-Received: by 2002:a05:6e02:1c08:: with SMTP id l8mr419719ilh.241.1644872402579;
        Mon, 14 Feb 2022 13:00:02 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id n3sm21568919ioz.9.2022.02.14.13.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 13:00:02 -0800 (PST)
Subject: Re: [PATCH V2 2/2] selftests: sgx: Treat CC as one argument
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Borislav Petkov <bp@suse.de>,
        "open list:INTEL SGX" <linux-sgx@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        David.Laight@ACULAB.COM
Cc:     kernel@collabora.com, kernelci@groups.io,
        "kernelci.org bot" <bot@kernelci.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220214184109.3739179-1-usama.anjum@collabora.com>
 <20220214184109.3739179-3-usama.anjum@collabora.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d6212372-5239-c903-4f0f-9b3bcfc9b52d@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 14:00:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220214184109.3739179-3-usama.anjum@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/14/22 11:41 AM, Muhammad Usama Anjum wrote:
> CC can have multiple sub-strings like "ccache gcc". For check_cc.sh,
> CC needs to be treated like one argument. Put double quotes around it to
> make CC one string and hence one argument.
> 
> Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
> Reported-by: "kernelci.org bot" <bot@kernelci.org>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>   tools/testing/selftests/sgx/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
> index 2956584e1e37f..75af864e07b65 100644
> --- a/tools/testing/selftests/sgx/Makefile
> +++ b/tools/testing/selftests/sgx/Makefile
> @@ -4,7 +4,7 @@ include ../lib.mk
>   
>   .PHONY: all clean
>   
> -CAN_BUILD_X86_64 := $(shell ../x86/check_cc.sh $(CC) \
> +CAN_BUILD_X86_64 := $(shell ../x86/check_cc.sh "$(CC)" \
>   			    ../x86/trivial_64bit_program.c)
>   
>   ifndef OBJCOPY
> 

Looks good to me.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

