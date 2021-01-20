Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1F5C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 03:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81D852312B
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 03:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbhATD6u (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Jan 2021 22:58:50 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:45449 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731757AbhATD6H (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 19 Jan 2021 22:58:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0UMI0fsI_1611115039;
Received: from 30.25.183.227(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UMI0fsI_1611115039)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Jan 2021 11:57:20 +0800
Subject: Re: [PATCH] x86/sgx: Allows ioctl PROVISION to execute before CREATE
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
References: <20210118133335.98907-1-tianjia.zhang@linux.alibaba.com>
 <YAc7h3zQR06eWPhZ@google.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <5037ee56-0211-f16c-3ea0-86cf8146b7f8@linux.alibaba.com>
Date:   Wed, 20 Jan 2021 11:57:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAc7h3zQR06eWPhZ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi,

On 1/20/21 4:05 AM, Sean Christopherson wrote:
> On Mon, Jan 18, 2021, Tianjia Zhang wrote:
>> In function sgx_encl_create(), the logic of directly assigning
>> value to attributes_mask determines that the call to
>> SGX_IOC_ENCLAVE_PROVISION must be after the command of
>> SGX_IOC_ENCLAVE_CREATE. If change this assignment statement to
>> or operation, the PROVISION command can be executed earlier and
>> more flexibly.
>>
>> Reported-by: Jia Zhang <zhang.jia@linux.alibaba.com>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>   arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
>> index f45957c05f69..0ca3fc238bc2 100644
>> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
>> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
>> @@ -108,7 +108,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>>   	encl->base = secs->base;
>>   	encl->size = secs->size;
>>   	encl->attributes = secs->attributes;
>> -	encl->attributes_mask = SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | SGX_ATTR_KSS;
>> +	encl->attributes_mask |= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | SGX_ATTR_KSS;
> 
> Alternatively, move the existing code to sgx_open()?  Initializing the field
> when the encl object is allocated feels more correct.
> 


This seems like a good idea. Thanks for your suggestion. I have sent v2 
patch, include the next two patches.

Best regards,
Tianjia
