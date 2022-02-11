Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C08C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Feb 2022 17:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352007AbiBKRNV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Feb 2022 12:13:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352004AbiBKRNU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 11 Feb 2022 12:13:20 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65DABD6
        for <linux-sgx@vger.kernel.org>; Fri, 11 Feb 2022 09:13:17 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id d3so7344125ilr.10
        for <linux-sgx@vger.kernel.org>; Fri, 11 Feb 2022 09:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s7mGcCDwRakb27nJ+hvyeCmB5+buamXTCZy5wLIRtRg=;
        b=fdomvHt9zMMnngWxveYBK7C1iFPQy7YFQkSeuwToo7/UZg+ppFxZs0Fw3zN6ixIwaQ
         VXQnU2ouajTpSQ2eoUlvf6o71S1OtOngn9AI/mJVsIkvRwcTaJ+L2voh+dW10QNq9D9b
         8F1hoRb4YxlbTzngZ1UTU8CJDV5l4NpeIjmzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s7mGcCDwRakb27nJ+hvyeCmB5+buamXTCZy5wLIRtRg=;
        b=OClv0vh02S7IBsukpR3wiI944BTZ5+0le0jf+atumTYvc2LZtnz0GEhGoKy5npGHf9
         xR6d33a2mGOu5/pS5JVuqRpda2Ymvbex8Hs5GCydZqr1SaCKcNUNAfR+dmIt4UPNLKDj
         PMro6ZhaEnteejUYVsCrdYXPI2klsL5XgzcmD9Wo3RrPH743fVfzaybBte5AcGcnMysR
         acE8qEpyWOJg1wJhKIbVDBXaQzQ2uMd4PxhQaUxfn2j/BccTL0mgOtT4dHLT9znT7/YK
         7zuBw4n1/ZtuWy4bDMKjFpNJ/xbpJHCEtxCSY0ZNsbYtjz4zcKXvt7++NcRIf17kjLsd
         dsLQ==
X-Gm-Message-State: AOAM532rQlckR5x4z1gM596H++yFVrG86B0cSNF6R8IepQ7dzaEQw82C
        XoDsonAPgXvUKLfYzvh342Sp2w==
X-Google-Smtp-Source: ABdhPJzQxZAzYhrwCZEUCoks+3wdFiATxCz/aohhMfPrkypn1nXkiEYj5RZUxC0OLhuRar6INy0rHQ==
X-Received: by 2002:a92:1311:: with SMTP id 17mr1371108ilt.42.1644599597132;
        Fri, 11 Feb 2022 09:13:17 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id u8sm5050640ilb.39.2022.02.11.09.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 09:13:16 -0800 (PST)
Subject: Re: [PATCH 1/2] selftests: x86: allow expansion of $(CC)
To:     David Laight <David.Laight@ACULAB.COM>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Jethro Beekman <jethro@fortanix.com>,
        "open list:INTEL SGX" <linux-sgx@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     "kernel@collabora.com" <kernel@collabora.com>,
        "kernelci@groups.io" <kernelci@groups.io>,
        "kernelci.org bot" <bot@kernelci.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220210190642.1477814-1-usama.anjum@collabora.com>
 <20220210190642.1477814-2-usama.anjum@collabora.com>
 <a34f2fc8-f4aa-fef4-d1dd-f3fdb5114f72@linuxfoundation.org>
 <99625ceecead4e9eb73de2fc8acb2ae9@AcuMS.aculab.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7a501981-e4ce-fb08-7c1e-6aca26245cef@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 10:13:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <99625ceecead4e9eb73de2fc8acb2ae9@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/11/22 9:47 AM, David Laight wrote:
> From: Shuah Khan
>> Sent: 10 February 2022 20:52
>>
>> On 2/10/22 12:06 PM, Muhammad Usama Anjum wrote:
>>> CC can have multiple sub-strings like "ccache gcc". Erorr pops up if
>>> it is treated as single string and double quote are used around it.
>>> This can be fixed by removing the quotes and not treating CC a single
>>> string.
>>>
>>> Fixes: e9886ace222e ("selftests, x86: Rework x86 target architecture detection")
>>> Reported-by: "kernelci.org bot" <bot@kernelci.org>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>>> ---
>>>    tools/testing/selftests/x86/check_cc.sh | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/x86/check_cc.sh b/tools/testing/selftests/x86/check_cc.sh
>>> index 3e2089c8cf549..aff2c15018b53 100755
>>> --- a/tools/testing/selftests/x86/check_cc.sh
>>> +++ b/tools/testing/selftests/x86/check_cc.sh
>>> @@ -7,7 +7,7 @@ CC="$1"
>>>    TESTPROG="$2"
>>>    shift 2
>>>
>>> -if "$CC" -o /dev/null "$TESTPROG" -O0 "$@" 2>/dev/null; then
>>> +if $CC -o /dev/null "$TESTPROG" -O0 "$@" 2>/dev/null; then
>>>        echo 1
>>>    else
>>>        echo 0
>>>
>>
>> The intent is testing if $CC is set. Does this change work when
>> $CC is not set?
> 
> More by luck than judgement. Before and after.
> If $CC might be empty you probably want:
> 
> [ -n "$CC" ] && { echo 0; return; }
> 
> The subject is also wrong. Should be "allow field splitting' of ${CC}.
> (no brace or curly braces, not round ones.)
> 

Good points. It would be good enhancement to add the check - since the
current logic doesn't handle the null CC

thanks,
-- Shuah
