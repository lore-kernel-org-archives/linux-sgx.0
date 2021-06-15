Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFBFC49361
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Jun 2021 21:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF9A6128B
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Jun 2021 21:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhFOV5c (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Jun 2021 17:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhFOV5c (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Jun 2021 17:57:32 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1470C061760
        for <linux-sgx@vger.kernel.org>; Tue, 15 Jun 2021 14:55:27 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id i13so506120ilk.3
        for <linux-sgx@vger.kernel.org>; Tue, 15 Jun 2021 14:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gGlMil9gXKdK98e+z/3//0TEFr3A94FGVQzcCF7IEdg=;
        b=E4n+xiU6XmWOto6x2oSKuUqg2Y3hZugY9I+InERxKH2yDgoypfGzeYm/zUcDsuVgGv
         YAgCOFaxAKVvwJo2xWx8EwQ6T775mKH02/W8MY7JdDXMymNvvl34Lqdv2k6eWwKNmpJ2
         hKHQxlHRfGZvDh+wZ6DNEw551U1ZdDPC3mXY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gGlMil9gXKdK98e+z/3//0TEFr3A94FGVQzcCF7IEdg=;
        b=Ap72Bjv3lgo/fyZ32pC451LDfm9lzDUSNXYY+u1rRaNFPdq/+TKtMnrjND7q7iTKtO
         nq5BSN1JaKTVhsSUxfDRZDTKB9YzMIWZoOKnsNv5HRz4Wnf9peMsB124g8nxS2KuObCa
         zVm0sqv2eZfsqS7FdrxLGFqyt75sd9ufgCcCRHnmIjJglzujv9l8u0WECw+IiNTQufGE
         XP4xi1Jb+a+igR+CEsMtNXKvV3XzUDjBwmhSQsmjjIHDzWyIIoCQ8YuwaGadf7yk4HiB
         bdHEmm67JJVPrfiFZ62+Nt8vqjVJisCKqMPIuj+r1PDKP3ImOrXtGaDRUXPOeIVCwLsk
         2OQg==
X-Gm-Message-State: AOAM5306zC/UCmfYZWWm5FQJru0o3AwHV2v2EigO8uWXK/1pBiaNjQc8
        /FrXizBp12BjBHsEG7HKw0eeGw==
X-Google-Smtp-Source: ABdhPJw0IoVMLrcQF6VHs508bDV1rbR9v5A1SXOl7hjsDfXWcFRqvfFr0np1QIn9PrKEnOo0RQ9C6Q==
X-Received: by 2002:a05:6e02:11b1:: with SMTP id 17mr1027938ilj.225.1623794127136;
        Tue, 15 Jun 2021 14:55:27 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k10sm161902ion.38.2021.06.15.14.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:55:26 -0700 (PDT)
Subject: Re: [PATCH v8 5/5] selftests/sgx: Refine the test enclave to have
 storage
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     shuah@kernel.org, linux-kselftest@vger.kernel.org,
        linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210610083021.392269-1-jarkko@kernel.org>
 <20210610083021.392269-5-jarkko@kernel.org>
 <b1bf69f5-e203-d69e-d15d-3fb5e98b63dd@linuxfoundation.org>
 <20210615131359.zrfvi36sjdpxghzl@kernel.org>
 <20210615131553.5y3jssldqc3sv2ge@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <adcc7797-db49-4dbc-ef87-5c12ad1d6a44@linuxfoundation.org>
Date:   Tue, 15 Jun 2021 15:55:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210615131553.5y3jssldqc3sv2ge@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/15/21 7:15 AM, Jarkko Sakkinen wrote:
> On Tue, Jun 15, 2021 at 04:14:02PM +0300, Jarkko Sakkinen wrote:
>> On Mon, Jun 14, 2021 at 02:16:15PM -0600, Shuah Khan wrote:
>>> On 6/10/21 2:30 AM, Jarkko Sakkinen wrote:
>>>> Extend the enclave to have two operations: ENCL_OP_PUT and ENCL_OP_GET.
>>>> ENCL_OP_PUT stores value inside the enclave address space and
>>>> ENCL_OP_GET reads it. The internal buffer can be later extended to be
>>>> variable size, and allow reclaimer tests.
>>>>
>>>> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
>>>> ---
>>>>    tools/testing/selftests/sgx/defines.h     | 10 ++++
>>>>    tools/testing/selftests/sgx/main.c        | 57 ++++++++++++++++++-----
>>>>    tools/testing/selftests/sgx/test_encl.c   | 19 +++++++-
>>>>    tools/testing/selftests/sgx/test_encl.lds |  3 +-
>>>>    4 files changed, 74 insertions(+), 15 deletions(-)
>>>>
>>>
>>> Test output before applying the series:
>>>
>>> TAP version 13
>>> 1..1
>>> # selftests: sgx: test_sgx
>>> # Unable to open /dev/sgx_enclave: No such file or directory
>>> # 1..0 # SKIP cannot load enclaves
>>> ok 1 selftests: sgx: test_sgx # SKIP
>>>
>>> Test output after applying second patch
>>>
>>> selftests/sgx: Migrate to kselftest harness
>>>
>>> Output changes to the following. It doesn't look like the second
>>> patch adds any new tests. What is the point in running the tests
>>> that fail if /dev/sgx_enclave is missing.
>>>
>>> Unfortunately this series doesn't have a cover letter that explains
>>> what this series is doing. I don't like the fact that the test
>>> output and behavior changes when migrating the test to kselftest
>>> harness. Shouldn't the output stay the same as in skip the tests
>>> if /dev/sgx_enclave fails.
>>
>> I get what you are saying but actually I do not know how with
>> fixtures I can skip "the rest" when FIXTURE_SETUP() fails.
>>
>> The reason for the output below is that with fixtures for all
>> tests enclave is initialized for each test case. And it kind of
>> makes sense because all tests start from the clean expected
>> state.
>>
>> I don't how to do that with zero change in the output.
>>

Yeah. I took a look at the FIXTURE. Doesn't look like it is possible.

>> The reason to do this change is to make it easy to add more tests,
>> and return correct status codes to the framework.
> 
> To add: everything I did I based purely to the existing kernel
> documentation, following the examples on how to use fixture.
> 

I will pick these up and will add a note to the last commit that
output changes, so test rings that run kselftest are aware of the
change.

thanks,
-- Shuah
