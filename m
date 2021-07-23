Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B22C432BE
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Jul 2021 19:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB8C60ED7
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Jul 2021 19:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhGWTMh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Jul 2021 15:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhGWTMg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 23 Jul 2021 15:12:36 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87E2C06175F
        for <linux-sgx@vger.kernel.org>; Fri, 23 Jul 2021 12:53:08 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id k3so2623383ilu.2
        for <linux-sgx@vger.kernel.org>; Fri, 23 Jul 2021 12:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WyoEwHnKGH7mDIf/X1k+fNngkECDQL+TuqJrMYUO1bE=;
        b=J+DClaB2GhxOmF3mOWGmx0CyyTx0NYaFU/djLERSc6MD6pNa/oda8sxnLTTW40bWzI
         XP/LywH9I+3PhChS6JW1ypXgX6PolOk4H+glyI1PajwSzcAE3pslRmTOK5Fi2uvbHpnB
         ehKy+V/kCBaV9AcRHgUuzX0sgnSBMP+ogAdc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WyoEwHnKGH7mDIf/X1k+fNngkECDQL+TuqJrMYUO1bE=;
        b=cXgVK7Y+Ee8TtTuLEIayAcZBP7XLyup25oIqINiFC1QQ+ZbqAuK+QbzjspXORdMNvO
         uPboEHBOtu5S/4UZKnoNdKURWF7Fok5TU1nytmZ5hitq9R2owoYlCYai625xVejj3x9G
         kQr9Iz9UflY6dHqlSgrHDAzPaoAGIO3rXvCOVqwy7mJq1+KkOcvmSOdJ8QwoDqzuWU9R
         2X3MTZfoWTpe3UMddtOx4ONc8M5JayZOm5Kz2kicOUlX4UdDrOwpDTikMyMx4ve20HQE
         nBHCCpQ2veNtZbnR6+fTM6LY4hGRs+UAKgG9/EqENADQ0Jo512oSdtNDP6Shum8lEPpF
         lp5w==
X-Gm-Message-State: AOAM533d9+kHwk5A1bnl+ki/eN/qHTObUOC+Tw5GhoPsEotIVZh44774
        Be0yzjvEDq7sdg0uCsCPT8fvug==
X-Google-Smtp-Source: ABdhPJwwQNksgKngs+yqWz7rFffKFNrfmaYy4udoxC9PAS7TNy2cALYC75+HK6O9GxAK0Ea7IgjGsg==
X-Received: by 2002:a05:6e02:1c0b:: with SMTP id l11mr4555920ilh.126.1627069988053;
        Fri, 23 Jul 2021 12:53:08 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t1sm16925109ilf.34.2021.07.23.12.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 12:53:07 -0700 (PDT)
Subject: Re: [PATCH v2] selftests/sgx: Fix Q1 and Q2 calculation in
 sigstruct.c
To:     Jarkko Sakkinen <jarkko@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kselftest@vger.kernel.org, linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210705050922.63710-1-jarkko@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <be6227d1-728a-c658-f962-380c28afc926@linuxfoundation.org>
Date:   Fri, 23 Jul 2021 13:53:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210705050922.63710-1-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/4/21 11:09 PM, Jarkko Sakkinen wrote:
> From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> Q1 and Q2 are numbers with *maximum* length of 384 bytes. If the calculated
> length of Q1 and Q2 is less than 384 bytes, things will go wrong.
> 
> E.g. if Q2 is 383 bytes, then
> 
> 1. The bytes of q2 are copied to sigstruct->q2 in calc_q1q2().
> 2. The entire sigstruct->q2 is reversed, which results it being
>     256 * Q2, given that the last byte of sigstruct->q2 is added
>     to before the bytes given by calc_q1q2().
> 
> Either change in key or measurement can trigger the bug. E.g. an unmeasured
> heap could cause a devastating change in Q1 or Q2.
> 
> Reverse exactly the bytes of Q1 and Q2 in calc_q1q2() before returning to
> the caller.
> 
> Fixes: dedde2634570 ("selftests/sgx: Trigger the reclaimer in the selftests")
> Link: https://lore.kernel.org/linux-sgx/20210301051836.30738-1-tianjia.zhang@linux.alibaba.com/
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> The original patch did a bad job explaining the code change but it
> turned out making sense. I wrote a new description.
> 
> v2:
> - Added a fixes tag.
>   tools/testing/selftests/sgx/sigstruct.c | 41 +++++++++++++------------
>   1 file changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
> index dee7a3d6c5a5..92bbc5a15c39 100644
> --- a/tools/testing/selftests/sgx/sigstruct.c
> +++ b/tools/testing/selftests/sgx/sigstruct.c
> @@ -55,10 +55,27 @@ static bool alloc_q1q2_ctx(const uint8_t *s, const uint8_t *m,
>   	return true;
>   }
>   
> +static void reverse_bytes(void *data, int length)
> +{
> +	int i = 0;
> +	int j = length - 1;
> +	uint8_t temp;
> +	uint8_t *ptr = data;
> +
> +	while (i < j) {
> +		temp = ptr[i];
> +		ptr[i] = ptr[j];
> +		ptr[j] = temp;
> +		i++;
> +		j--;
> +	}
> +}

I was just about apply this one and noticed this reverse_bytes().
Aren't there byteswap functions you could call instead of writing
your own?

thanks,
-- Shuah
