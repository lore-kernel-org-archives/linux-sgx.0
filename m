Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E49C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Feb 2022 18:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiBBSDV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Feb 2022 13:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiBBSDU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 2 Feb 2022 13:03:20 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEF6C06173B
        for <linux-sgx@vger.kernel.org>; Wed,  2 Feb 2022 10:03:20 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id n17so76563iod.4
        for <linux-sgx@vger.kernel.org>; Wed, 02 Feb 2022 10:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SI1shEwOrMkmq2fon/SPYzxLuIxmD/6oDSkyJhsld/s=;
        b=VYXEdwzhlRZAhmyKOsQKpqq7IikInC9lQzt8vPumRq3SCSIS0EyKjXWyjcPOvwi7AU
         GF9ALa4xHXdpkGkkH+bBrYfZ18PhwiV3Zz807BOmVlf9+z8a6ut2/9dtgNTTLRV/7TQQ
         DQASI3+WsxjE34ZaO0IGSfVFoICsh7as7npZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SI1shEwOrMkmq2fon/SPYzxLuIxmD/6oDSkyJhsld/s=;
        b=6O6gmYFKfwJA25OijCnzlMPv8TeCkrjGW7T+WEZXsOfF1DFrQtFP3lk7k3/Mg7H6YC
         F4BxxfajQJkuFDLt7vlCCH5HzymSHEE2znwt6Ney4jkd5wdmH0MMu4HGJCj6zTwbJLbn
         9lAfwNb6fVeeXue0XxsPQJTCHgDemeRrClSfiA/rAo1SY5YuQzPCV66jNzNu+C1+YEYK
         FVR4aDhvu3x0aKlWirfynIK3UCXKNYKtya4rFSNIlJMhkqurQY38dALI9mvI9YIlrmbb
         Z8fq+xck+DfyUZp7hRSUWbkoYM3+vLhH8Synpqi9XF4oz5bgMTj6KZiQ/v7pHFpRF5UP
         B86w==
X-Gm-Message-State: AOAM532+1bE65rmCOoH5AwBH4E9C2aOaXlIy5GBpafR6/uF0uKHeELHP
        WkkWFGp7s1rb7ENddM5Ek205kg==
X-Google-Smtp-Source: ABdhPJzB44zSHiZP6Q5KDJoX6x/kno+8nM3uBcm6ZA4ksTVVijnP1B9QjQ3E4YJtSuBJg4PO4z7NXw==
X-Received: by 2002:a05:6638:3e8:: with SMTP id s8mr12350195jaq.284.1643824999049;
        Wed, 02 Feb 2022 10:03:19 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id a6sm2569336iow.22.2022.02.02.10.03.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 10:03:18 -0800 (PST)
Subject: Re: [PATCH V2 2/4] selftests/sgx: Do not attempt enclave build
 without valid enclave
To:     Reinette Chatre <reinette.chatre@intel.com>, jarkko@kernel.org,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        shuah@kernel.org
Cc:     linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1643754040.git.reinette.chatre@intel.com>
 <4e4ea6d70c286c209964bec1e8d29ac8e692748b.1643754040.git.reinette.chatre@intel.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f6124d90-1036-0eef-b64a-94072302dd44@linuxfoundation.org>
Date:   Wed, 2 Feb 2022 11:03:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <4e4ea6d70c286c209964bec1e8d29ac8e692748b.1643754040.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/1/22 3:47 PM, Reinette Chatre wrote:
> It is not possible to build an enclave if it was not possible to load
> the binary from which it should be constructed. Do not attempt
> to make further progress but instead return with failure. A
> "return false" from setup_test_encl() is expected to trip an
> ASSERT_TRUE() and abort the rest of the test.
> 
> Fixes: 1b35eb719549 ("selftests/sgx: Encpsulate the test enclave creation")
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since V1:
> - Add Acked-by from Dave.
> - Detail in commit log what callers will see with this change (Dave).
> 
>   tools/testing/selftests/sgx/main.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
> index 370c4995f7c4..a7cd2c3e6f7e 100644
> --- a/tools/testing/selftests/sgx/main.c
> +++ b/tools/testing/selftests/sgx/main.c
> @@ -147,6 +147,7 @@ static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
>   	if (!encl_load("test_encl.elf", encl, heap_size)) {
>   		encl_delete(encl);
>   		TH_LOG("Failed to load the test enclave.\n");
> +		return false;
>   	}
>   
>   	if (!encl_measure(encl))
> 
Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

