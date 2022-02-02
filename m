Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62CAC433FE
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Feb 2022 18:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbiBBS73 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Feb 2022 13:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiBBS73 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 2 Feb 2022 13:59:29 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC121C061714
        for <linux-sgx@vger.kernel.org>; Wed,  2 Feb 2022 10:59:28 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id e8so135719ilm.13
        for <linux-sgx@vger.kernel.org>; Wed, 02 Feb 2022 10:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LKQOVFVN71g018P6uGT3AYWuYj7GuCe1P7Bm+nnZRwE=;
        b=fxH3bOToTGUFI56YmSI62W8tYxQXlJhwvR1zKXldU1Nc8HvXiKm5ODIKV2LpLM++it
         9yLyS4omdzmsONKA9hbJLENVC0AJaAGKKkl+9EMR2BnKS1LgcBZfzCrwsd1ZDfHRxZGW
         gmDx5NsbeSMtexIGQP2FXXWrr4lqBGbdF2glg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LKQOVFVN71g018P6uGT3AYWuYj7GuCe1P7Bm+nnZRwE=;
        b=Ib23iyMkpVGIjnyUYVAaL4sHL5ML0PINvHDckz6JV/Bi8aa8TaJkBXAuaOP3OS7VDv
         7Fks5KaMMTmOQyPFAa12qaszxULGCZgHb5wccfy/mBp/26ClWhEI5dlnEH8n6a4OVAs4
         SLvrvtsKWe6OMz22s5tvA6NcjApSFR3h2ONsAy1X9gUsDx1QkgFdyfVxiy/z1uHRtYRm
         +A3SWUEc3ZLukO1w468Vi8gIKwR4C2shrtthwboZ8diqDHzFfYjSGWyYAoFE6v9/ym1W
         LR2J6zBJ3wlWo/YoPiPeac3adnWSQtz2Xm9jJs2uhQczYTFkN8e0DhXPVyESZ9Cp+fJ+
         amvA==
X-Gm-Message-State: AOAM5301PuZYwVRo+on6O5hWLgF4tleXioa4Y6mvhzi0Ss4jQ/MNKsiF
        kNbnOfJRzsK3amn36gzYUc2XTg==
X-Google-Smtp-Source: ABdhPJxqJ7UiVPv7ePVBJdS0ykvHDvQKTxACPBva633hTVfjDcYRLd08xr2Ye78GFhbWhcLU//HKjg==
X-Received: by 2002:a05:6e02:2144:: with SMTP id d4mr18564611ilv.247.1643828368294;
        Wed, 02 Feb 2022 10:59:28 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id j14sm21090409ilc.62.2022.02.02.10.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 10:59:28 -0800 (PST)
Subject: Re: [PATCH V2 1/4] selftests/sgx: Fix NULL-pointer-dereference upon
 early test failure
To:     Reinette Chatre <reinette.chatre@intel.com>, jarkko@kernel.org,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        shuah@kernel.org
Cc:     linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1643754040.git.reinette.chatre@intel.com>
 <89824888783fd8e770bfc64530c7549650a41851.1643754040.git.reinette.chatre@intel.com>
 <b8ee2381-d1a2-89c6-d199-15b0fdba0553@linuxfoundation.org>
 <e6d3c912-5382-bab5-3eb8-40a9d6b8a293@intel.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e188c62e-f75e-2bec-b544-76063098611d@linuxfoundation.org>
Date:   Wed, 2 Feb 2022 11:59:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <e6d3c912-5382-bab5-3eb8-40a9d6b8a293@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/2/22 11:52 AM, Reinette Chatre wrote:
> Hi Shuah and Dave,
> 
> On 2/2/2022 10:01 AM, Shuah Khan wrote:
>> On 2/1/22 3:47 PM, Reinette Chatre wrote:
>>> == Background ==
>>>
>>> The SGX selftests track parts of the enclave binaries in an array:
>>> encl->segment_tbl[]. That array is dynamically allocated early
>>> (but not first) in the test's lifetime. The array is referenced
>>> at the end of the test in encl_delete().
>>>
>>> == Problem ==
>>>
>>> encl->segment_tbl[] can be NULL if the test fails before its
>>> allocation. That leads to a NULL-pointer-dereference in encl_delete().
>>> This is triggered during early failures of the selftest like if the
>>> enclave binary ("test_encl.elf") is deleted.
>>>
>>> == Solution ==
>>>
>>
>> "==" usage looks a bit odd in the change log.
> 
> This is a new trend in the x86/ area and I was asked to modify the commit
> message to follow suit in:
> https://lore.kernel.org/linux-sgx/df2248d2-eb61-22d6-3a51-d8091f9eaad6@intel.com/
> 
> 

Good to know. Thanks for the link.

>>
>> The rest looks good to me. I can take this through kselftest tree, if not,
>>
>> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>>
> 
> Thank you very much for reviewing the changes.
> 
> None of the patches in this series have external dependencies (all patches
> in the "Fixes:" can be found in v5.17-rc1) but my understanding is that Dave
> (for now) prefers to take them via the tip.git tree. This is because there
> are more SGX features and tests for those features [1] in flight to the
> SGX area and at least for now it would make things easier if the changes to
> the SGX selftests are contained in the same tree.
> 
> Dave: please do correct me if I am wrong.
> 

Sounds good to me.

thanks,
-- Shuah

