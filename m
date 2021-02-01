Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D55EC433DB
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Feb 2021 12:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E30764EA2
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Feb 2021 12:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhBAMkv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Feb 2021 07:40:51 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:38531 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhBAMks (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Feb 2021 07:40:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UNbCbFm_1612183069;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UNbCbFm_1612183069)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Feb 2021 20:37:50 +0800
Subject: Re: [PATCH v3 5/5] x86/sgx: Remove redundant if conditions in
 sgx_encl_create
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Shuah Khan <shuah@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
References: <20210124062907.88229-1-tianjia.zhang@linux.alibaba.com>
 <20210124062907.88229-6-tianjia.zhang@linux.alibaba.com>
 <YBVuLFriVAm5EiEc@kernel.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <96dad409-e00e-6b2f-ab4d-cef80921c1f4@linux.alibaba.com>
Date:   Mon, 1 Feb 2021 20:37:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YBVuLFriVAm5EiEc@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 1/30/21 10:33 PM, Jarkko Sakkinen wrote:
> On Sun, Jan 24, 2021 at 02:29:07PM +0800, Tianjia Zhang wrote:
>> In this scenario, there is no case where va_page is NULL, and
>> the error has been checked. The if condition statement here is
>> redundant, so remove the condition detection.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>   arch/x86/kernel/cpu/sgx/ioctl.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
>> index 1c6ecf9fbeff..b0b829f1b761 100644
>> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
>> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
>> @@ -66,9 +66,11 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>>   	va_page = sgx_encl_grow(encl);
>>   	if (IS_ERR(va_page))
>>   		return PTR_ERR(va_page);
>> -	else if (va_page)
>> -		list_add(&va_page->list, &encl->va_pages);
>> -	/* else the tail page of the VA page list had free slots. */
> 
> This is fine. The check does not make sense.
> 
>> +
>> +	if (WARN_ONCE(!va_page, "non-empty VA page list before ECREATE"))
>> +		return -EIO;
> 
> No need for this WARN_ONCE().
> 
>> +
>> +	list_add(&va_page->list, &encl->va_pages);
> 
> This is fine.
> 
>>   
>>   	/* The extra page goes to SECS. */
>>   	encl_size = secs->size + PAGE_SIZE;
>> -- 
>> 2.19.1.3.ge56e4f7
>>
>>
> 
> /Jarkko
> 

Will be improved in the next version.

Thanks,
Tianjia
