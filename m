Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D23C433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Feb 2022 20:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiBNVAD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:00:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiBNVAA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 14 Feb 2022 16:00:00 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DE0139114
        for <linux-sgx@vger.kernel.org>; Mon, 14 Feb 2022 12:59:44 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id c188so21464186iof.6
        for <linux-sgx@vger.kernel.org>; Mon, 14 Feb 2022 12:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=04Ox5ixc4MPOE8Kua318ZsUJMu3rT8ky9xRJXJOyxF0=;
        b=aA8xCND2MGx+5OMZd1UPNNR3bzouVZeF3Pp/V3gAI6Y6VO3YKteYVgspznUv2NetBF
         Tc+o47xNGteAJPsCxg6xm0s7PLkDEAwdTocbmUrOX9vXxnJLf0YnFX9foX4HCjROGp2r
         J+OtRald/QoJMCAX6q501eL6WJoD9BwpZGyWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=04Ox5ixc4MPOE8Kua318ZsUJMu3rT8ky9xRJXJOyxF0=;
        b=Iv4GonGBZ9zxBqzBHngJUkxH7F3Do8U2lvoVaREA8/cs5QaDTSS+P7dQdRwdK7uZHp
         /Pe1XNaw+KQ2lcdGuf97Kejnjahghg7jx4y7ZprHM/w20u3TnVYXq/q+noUpTs+FG4dv
         yTwNcgzuY55kU14G1G+KlTnDm5mi3DsMAXYwdxLJbkvGviuBaz5xCtSu75gd5saCtB53
         FGh+4M0Z6M3hY8Z7bDElMTb4wVCHXyUtUOdY/757lyk+IG/bz9nPI1OLRb5XeDsOShiS
         VgmjLeCct9h7rrRvea37Ebrqz/ZBbv68vopeuq9ABp9UEUfZZhAG+OrMac8NWWM7i+vn
         3Q3A==
X-Gm-Message-State: AOAM530bMnTIuIGuHQPwZ7MIW0e6loN+Oo8bktWLmHN+f976tyNDnawA
        wWvvZS27agw0kGIaz1ThWKFe3MGKDUMxog==
X-Google-Smtp-Source: ABdhPJxOoTHzsjxeSWDebsZYfsiGHhSEEz60eKm+tUhCUtGJPeoRbM/EPLiEntjejkgFvCzl/lMIBQ==
X-Received: by 2002:a05:6638:190a:: with SMTP id p10mr477555jal.313.1644872383619;
        Mon, 14 Feb 2022 12:59:43 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id w10sm21193066iow.44.2022.02.14.12.59.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 12:59:43 -0800 (PST)
Subject: Re: [PATCH V2 1/2] selftests: x86: add validity check and allow field
 splitting
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
 <20220214184109.3739179-2-usama.anjum@collabora.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8f62537f-e191-1d60-530a-9eb9c31b0511@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 13:59:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220214184109.3739179-2-usama.anjum@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/14/22 11:41 AM, Muhammad Usama Anjum wrote:
> Add check to test if CC has a string. CC can have multiple sub-strings
> like "ccache gcc". Erorr pops up if it is treated as single string and
> double quotes are used around it. This can be fixed by removing the
> quotes and not treating CC as a single string.
> 
> Fixes: e9886ace222e ("selftests, x86: Rework x86 target architecture detection")
> Reported-by: "kernelci.org bot" <bot@kernelci.org>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
> Changes in V2:
> Update if condition to check if CC has a string
> ---
>   tools/testing/selftests/x86/check_cc.sh | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/x86/check_cc.sh b/tools/testing/selftests/x86/check_cc.sh
> index 3e2089c8cf549..8c669c0d662ee 100755
> --- a/tools/testing/selftests/x86/check_cc.sh
> +++ b/tools/testing/selftests/x86/check_cc.sh
> @@ -7,7 +7,7 @@ CC="$1"
>   TESTPROG="$2"
>   shift 2
>   
> -if "$CC" -o /dev/null "$TESTPROG" -O0 "$@" 2>/dev/null; then
> +if [ -n "$CC" ] && $CC -o /dev/null "$TESTPROG" -O0 "$@" 2>/dev/null; then
>       echo 1
>   else
>       echo 0
> 

Looks good to me.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
