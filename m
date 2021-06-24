Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B387C49EA5
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Jun 2021 00:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDFAF6135A
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Jun 2021 00:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFXAnD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Jun 2021 20:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhFXAnB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 23 Jun 2021 20:43:01 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21907C061760
        for <linux-sgx@vger.kernel.org>; Wed, 23 Jun 2021 17:40:42 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id r16so5439326oiw.3
        for <linux-sgx@vger.kernel.org>; Wed, 23 Jun 2021 17:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8aXNnJPgzFasgRQ/3SZjZxHB/iETrErIxFti8LCKPuw=;
        b=WaocPTyfDGVh9mLxAuyWMDCc0iZt0OY5B0UMEUpVasi85XWfRxg82NX3/0H4ZjKXcQ
         NPJRoYB3S6TQOiiz5UzaWct2FYfX+sIa91Zic1jKpg4IuGww7HWKxLGQ3uBfqtWa11AF
         QTHorlW9bTAWxgOJVcE8Q895b8vrbq/x/8Vos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8aXNnJPgzFasgRQ/3SZjZxHB/iETrErIxFti8LCKPuw=;
        b=gpY9W6+WrHzKMJbNhsuK6LdbYHlS+YrCp8HMMumdo9iI9XIv6Z1cTirb3S74QfGCCy
         P3BZe+RMdSn9ljbxnnCs9Dg/Y/jS2v6CyA3LKF0Vaaj6lep/Zn7m/Eba8uULzjZKHVwE
         6Er4Qbr70WKJNyYtuCTUfIX113TEFRv7vJW1qFiqqMdq4YKDWP6rLByAD26eEshY931G
         7nrRpKsv+pFWlmn8KZZv+alM153HxLKERcaWS4gSG1DTRh1BO98yHbuMni7dP7ICgomG
         BGt4AaEv9hqqNWhHiVP6XbsO7m35yLyjSjq8m/jSGzKStnQvY6fzrLTeqS0phWhu0KO9
         s97A==
X-Gm-Message-State: AOAM530vzAtLxgQMcZzYzunfzyiinSNU5R5QWCxEaJuzbhFsiuqICWKd
        TrjzSXOmsRnSNoMBe2tP+BxfPg==
X-Google-Smtp-Source: ABdhPJySlB33W2z668j7Dkn6kxnqb+RezaTEux7Oz+cmN+pHAbGFZE2M5Nyvs0HY/kx97yoNlisVXA==
X-Received: by 2002:a05:6808:4c2:: with SMTP id a2mr5108035oie.73.1624495240315;
        Wed, 23 Jun 2021 17:40:40 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c11sm290426oot.25.2021.06.23.17.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 17:40:39 -0700 (PDT)
Subject: Re: [PATCH] selftests/sgx: remove checks for file execute permissions
To:     Dave Hansen <dave.hansen@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, tim.gardner@canonical.com,
        jarkko@kernel.org, shuah@kernel.org, linux-sgx@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210621190556.4B5DCBB1@viggo.jf.intel.com>
 <121f7215-f11d-2533-b736-9f18516c3220@intel.com>
 <1f46324e-2cbe-f4a7-65d5-24b22a8b36b1@intel.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a3c10daf-6531-5b09-c6fd-77ae02afdce0@linuxfoundation.org>
Date:   Wed, 23 Jun 2021 18:40:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1f46324e-2cbe-f4a7-65d5-24b22a8b36b1@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/21/21 3:18 PM, Dave Hansen wrote:
> On 6/21/21 2:08 PM, Reinette Chatre wrote:
>>
>> Thank you very much for fixing this. With this applied the SGX tests are
>> able to run again on my system.
>>
>> Tested-by: Reinette Chatre <reinette.chatre@intel.com>
>>
>> I think it is missing a "Signed-off-by".
> 
> Right you are.  I think I've done this twice in a row for one-off
> patches.  Sheesh.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> 
> If anyone wants a resend with this included, please let me know.
> 

Thanks to b4/patchwork - no need to resend. I have the signed-off-by
in the downloaded patch.

Thank you all. Now applied to linux-kselftest next for 5.14-rc1

-- Shuah
