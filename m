Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1464BC433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Feb 2022 18:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344934AbiBBSEk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Feb 2022 13:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiBBSEk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 2 Feb 2022 13:04:40 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD5BC06173B
        for <linux-sgx@vger.kernel.org>; Wed,  2 Feb 2022 10:04:40 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id h7so90333iof.3
        for <linux-sgx@vger.kernel.org>; Wed, 02 Feb 2022 10:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c0JEtni+MDhJCxKTxYFonasXrWHhXi3K1Hd10rK0nd0=;
        b=cTEH45eH2RoxkO0HD4GKL0atJHjQB7ZMmWHpkOG0QfoV9waAeZ5+hmzjhlQBPHy/D8
         iyDP7jtzECMfuwZwduEt8NCgULHGU5uWeZ/+0EBvdlUbOnxpzb+htfT2Ojxas8iAZaKW
         V49HTXWQxEcn+rMUVGvW/WoCNtRRmqY/SUIec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c0JEtni+MDhJCxKTxYFonasXrWHhXi3K1Hd10rK0nd0=;
        b=eZJa0hNumrwJqIdyR1eBP4bkWIcSFe5FbKc3jym5EuoSbWXUDm/FXOFTU5VPYA5USm
         40lPanWKk+STFvzSHOFwzfQQ9OrpQfKpNa+WN2gelCL0XCFxvvz7unvTClOoYeBLB4qp
         78N3HKgvcSrOG4/bYrEynOOsTWXgIfbPmyOr/V9l8E46/OdX8DEnTjmBsgVbJ8zbHKnE
         pUuXtxFFgYOVBfUrTQtumFoW4UAphpmYnQ/qJP1KxsWMB0SsDqdGMRDo0vfpnK++9MRa
         1NxLPcNbrKe/cDuHgMf20XiPE1kpwR1sDe2Nk0ZgLRRCM5qr9cFnMKc/fkl0KgS3qCmq
         RsOA==
X-Gm-Message-State: AOAM53309+LPVUnARzqp9HiJ2RoXaTKYMjtg6wz5frNPZ7usopp8yNQ+
        i7S+vB918SA2CTZmBF5WJ16LMw==
X-Google-Smtp-Source: ABdhPJy1ONdqSlRMRKB8s3INeUzv4z2Hx0qs271RqyFJWpVZxrOQfMd/+1/jZrY6BCtbanzSKd8aOg==
X-Received: by 2002:a05:6602:29d0:: with SMTP id z16mr16408447ioq.122.1643825079672;
        Wed, 02 Feb 2022 10:04:39 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id y4sm21041267ili.26.2022.02.02.10.04.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 10:04:39 -0800 (PST)
Subject: Re: [PATCH V2 4/4] selftests/sgx: Remove extra newlines in test
 output
To:     Reinette Chatre <reinette.chatre@intel.com>, jarkko@kernel.org,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        shuah@kernel.org
Cc:     linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1643754040.git.reinette.chatre@intel.com>
 <16317683a1822bbd44ab3ca48b60a9a217ac24de.1643754040.git.reinette.chatre@intel.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5cea376e-7e80-8105-f81d-4738c737ad75@linuxfoundation.org>
Date:   Wed, 2 Feb 2022 11:04:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <16317683a1822bbd44ab3ca48b60a9a217ac24de.1643754040.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/1/22 3:47 PM, Reinette Chatre wrote:
> The TH_LOG() macro is an optional debug logging function made
> available by kselftest itself. When TH_LOG_ENABLED is set it
> prints the provided message with additional information and
> formatting that already includes a newline.
> 
> Providing a newline to the message printed by TH_LOG() results
> in a double newline that produces irregular test output.
> 
> Remove the unnecessary newlines from the text provided to
> TH_LOG().
> 
> Fixes: 1b35eb719549 ("selftests/sgx: Encpsulate the test enclave creation")
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since V1:
> - Add Acked-by from Dave.
> 
>   tools/testing/selftests/sgx/main.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
> index b0bd95a4730d..dd74fa42302e 100644
> --- a/tools/testing/selftests/sgx/main.c
> +++ b/tools/testing/selftests/sgx/main.c
> @@ -146,7 +146,7 @@ static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
>   
>   	if (!encl_load("test_encl.elf", encl, heap_size)) {
>   		encl_delete(encl);
> -		TH_LOG("Failed to load the test enclave.\n");
> +		TH_LOG("Failed to load the test enclave.");
>   		return false;
>   	}
>   
> @@ -204,7 +204,7 @@ static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
>   		fclose(maps_file);
>   	}
>   
> -	TH_LOG("Failed to initialize the test enclave.\n");
> +	TH_LOG("Failed to initialize the test enclave.");
>   
>   	encl_delete(encl);
>   
> 

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
