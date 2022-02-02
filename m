Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E57C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Feb 2022 18:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbiBBSGS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Feb 2022 13:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbiBBSGR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 2 Feb 2022 13:06:17 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE681C061714
        for <linux-sgx@vger.kernel.org>; Wed,  2 Feb 2022 10:06:17 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id i62so108749ioa.1
        for <linux-sgx@vger.kernel.org>; Wed, 02 Feb 2022 10:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hNV2f3cPKa/gkBJtO8//6fZlmNRzoYVhR6xKSXFe4bw=;
        b=RT/HOtnlSeSa4BCmXs3+5JE3Zlwo23R/iJOAI5BY19ui41M03xUP+IsqTHbdv04REf
         l8vdcW+MB+vuYcDtoQULlOTblKnsZm6prBHxZ5lbLk0+5cGCHQi1igtk34KY8bplVEn4
         320XEz4BPG/NVaSHnuZT2MRrUo9sX73DfCoJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hNV2f3cPKa/gkBJtO8//6fZlmNRzoYVhR6xKSXFe4bw=;
        b=XmYsGGNINEnflqE4W0tf2WHLTxo37lmuTyTuycTmfSLpz0ye86N17DSW0PZgEna2Fu
         NnswU+8mvY/khVpckXR8LiMcIu8V3XPrhwMFQHG+qM/74lLt9Ge4Q2vluzRkukgiC0OS
         ZvjlWlhnwr7dccYsDcKLNvLdqEbOdFunzYBdyzWVKxYiD1rfdWg9ju/tlLvpVBLHqj3W
         20a1GblxSgVtPfHD/1lc1yZsZog6Q/ZssXcs7QRCGI7sTrpF6ymu3e+fhVxqT0tzfd/I
         THYlHudUe1du5eDMchHk/zSi2xNhC9vBwyiaCIJg2w0aURLRynQgmgFjcZA67dPnACBl
         OLpw==
X-Gm-Message-State: AOAM530Vj6SE7SrcNQw9vmdgSFnt8wIggxbegU60DVCNGSTMfZIrnTCU
        GqGoRHIeCmFNWRu6sVSW/TMlIg==
X-Google-Smtp-Source: ABdhPJzIpUTqSUbLVW+ir23UJNN3C9kuHv/LBunZ/bu/F4vXdk2QT4v48VLk4yh70UanR972nIcQPw==
X-Received: by 2002:a05:6638:6a9:: with SMTP id d9mr9390403jad.92.1643825177189;
        Wed, 02 Feb 2022 10:06:17 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id g8sm21141841ilc.10.2022.02.02.10.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 10:06:16 -0800 (PST)
Subject: Re: [PATCH V2 0/4] selftests/sgx: Early enclave loading error path
 fixes
To:     Reinette Chatre <reinette.chatre@intel.com>, jarkko@kernel.org,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        shuah@kernel.org
Cc:     linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1643754040.git.reinette.chatre@intel.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5217a735-336a-4c34-5eba-5141b758cbcd@linuxfoundation.org>
Date:   Wed, 2 Feb 2022 11:06:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <cover.1643754040.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/1/22 3:47 PM, Reinette Chatre wrote:
> Changes since V1:
> - V1: https://lore.kernel.org/linux-sgx/cover.1643393473.git.reinette.chatre@intel.com/
> - All changes impact the commit messages only, no changes to code.
> - Rewrite commit message of 1/4 (Dave).
> - Detail in 2/4 commit log what callers will see with this change (Dave).
> - Add Acked-by from Dave to 2/4 and 4/4.
> 
> Hi Everybody,
> 
> Please find included a few fixes that address problems encountered after
> venturing into the enclave loading error handling code of the SGX
> selftests.
> 
> Reinette
> 
> Reinette Chatre (4):
>    selftests/sgx: Fix NULL-pointer-dereference upon early test failure
>    selftests/sgx: Do not attempt enclave build without valid enclave
>    selftests/sgx: Ensure enclave data available during debug print
>    selftests/sgx: Remove extra newlines in test output
> 
>   tools/testing/selftests/sgx/load.c | 9 +++++----
>   tools/testing/selftests/sgx/main.c | 9 +++++----
>   2 files changed, 10 insertions(+), 8 deletions(-)
> 
> 
> base-commit: 2056e2989bf47ad7274ecc5e9dda2add53c112f9
> 

I can take these through kselftest tree if there are no dependencies on
another tree.

thanks,
-- Shuah
