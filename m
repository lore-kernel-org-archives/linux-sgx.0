Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6B6C433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Feb 2022 18:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346433AbiBBSE0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Feb 2022 13:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346455AbiBBSEU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 2 Feb 2022 13:04:20 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715ACC06173D
        for <linux-sgx@vger.kernel.org>; Wed,  2 Feb 2022 10:04:20 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id i62so101644ioa.1
        for <linux-sgx@vger.kernel.org>; Wed, 02 Feb 2022 10:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HLkmXCB4AfYdAm9hiqZaqGV6EKc/FUxTrxh9W8wogF4=;
        b=gGMebvLeJDhoY6TiETyWGvgv4gT6UwBM6EFgUgxNI3TVlTRioqhkQgaFEcePzO6Tzm
         KhadLqVClZyvRbbfxh9L0ETwhMppREgEHVke9PYpQ+NjWvEx9wDLMF2lTZ009bArbgcu
         Spw/BLAauRt1jIkA2QVh0dmI1n7BjCIjfFnc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HLkmXCB4AfYdAm9hiqZaqGV6EKc/FUxTrxh9W8wogF4=;
        b=zBTOz4QfG3P0k0ih3UBBgYxc6nnRd/UMJglSsdL2AFL7g/eRZl5u8OsF1cGf438ML5
         vkNkwOXhVAx2cOGB7UgoT6qCiBlHH+ZUJMD0q8UcFH9CcjmDXU2Gw92mstwfncrTxKRz
         UDIROfAE1DPLmXVL6l5WVXaIR8xI+52PEvmkYZGhYwtvugwOClp8PnIDP4hqX5Su9V7P
         ZEWMPCcrq6KEdmOzmwyObMloWKiDZSDmBkEPn9o2aNZBBdzmtDxmabR/7v+mJlVsSitP
         G/XaGHlUM8on+kmebILsrMP5yTwjt+Lf652juCekMJNXGl8czZDvtSqbHGZOkpSorlOz
         vnvw==
X-Gm-Message-State: AOAM5332678uTtDbvd2hPxq9M9vlJEoiFU4hg0dM4CKhWDJNGDelqJq9
        5Mj5jPBw67PLKqcvylfB2ou0wg==
X-Google-Smtp-Source: ABdhPJyjZbG5YLnI2cwY+L7WSqUOnWQg23FK0SGTMU9yq3T03EBOmn/Rl1HlkL2q67VzfUbyk67Hlg==
X-Received: by 2002:a05:6602:2c83:: with SMTP id i3mr14752471iow.105.1643825059943;
        Wed, 02 Feb 2022 10:04:19 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id b5sm21121433iln.54.2022.02.02.10.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 10:04:19 -0800 (PST)
Subject: Re: [PATCH V2 3/4] selftests/sgx: Ensure enclave data available
 during debug print
To:     Reinette Chatre <reinette.chatre@intel.com>, jarkko@kernel.org,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        shuah@kernel.org
Cc:     linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1643754040.git.reinette.chatre@intel.com>
 <eaaeeb9122916d831942fc8a3043c687137314c1.1643754040.git.reinette.chatre@intel.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <644ac230-0a50-a555-a621-5f72087f54c5@linuxfoundation.org>
Date:   Wed, 2 Feb 2022 11:04:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <eaaeeb9122916d831942fc8a3043c687137314c1.1643754040.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/1/22 3:47 PM, Reinette Chatre wrote:
> In support of debugging the SGX tests print details from
> the enclave and its memory mappings if any failure is encountered
> during enclave loading.
> 
> When a failure is encountered no data is printed because the
> printing of the data is preceded by cleanup of the data.
> 
> Move the data cleanup after the data print.
> 
> Fixes: 147172148909 ("selftests/sgx: Dump segments and /proc/self/maps only on failure")
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---


Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
