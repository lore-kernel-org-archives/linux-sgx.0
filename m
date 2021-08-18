Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B718C4320A
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Aug 2021 18:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A4D61103
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Aug 2021 18:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhHRSej (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Aug 2021 14:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhHRSei (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 18 Aug 2021 14:34:38 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDAFC061764
        for <linux-sgx@vger.kernel.org>; Wed, 18 Aug 2021 11:34:03 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id n1-20020a9d1e810000b0290514da4485e4so5248899otn.4
        for <linux-sgx@vger.kernel.org>; Wed, 18 Aug 2021 11:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vgeh/MzsdgwRSXW6dyIwI2/BL0uvJknZ4Sn+7U4jq50=;
        b=DhCQE9W2ArEvgMqCCf1kvbZPaabjdblH2zbUsaT4Jgemxapu3HQp0ev2pW9UhBaxXz
         eBamkvJRYr/6gZES2Wi4gkMgt77GnYA/bJaC6EcaEFJaXe6/OPtusvv7eb5NUfYKswOr
         uw34Gz62iOzUc4iMbHzdngw0NEN+Y0zN+vTLo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vgeh/MzsdgwRSXW6dyIwI2/BL0uvJknZ4Sn+7U4jq50=;
        b=PeTSg4tMNC5+SoLGFcuE0zxNexkE+BcfXZsUExozpjCtd+qip1qWM3lb7gNSAI2B4g
         /sfd2gRHn0LCMVD69JYMQq4SupEJEZm/waktbXJFyIjR53caX0QEksMl5ekUwJgCz/QJ
         xfClMgN9GiyGcg1c/fjHDtKoeYwFBe98p6AcG7NbLUSnfo9E/HNzUMMDDOBB0oioiP94
         YrmdlLawg86R9Rv8A/M7hSZsYWLO4lbTj7d1Qd4BU9DG+h7Pj5CDVkebeato/1OqTFoO
         xqJMrwItIphdU94RqZysJW82ZIp6/spmvrPXMrYjFZ11nd60IDJ2zI2gwd3mdbEmsi1o
         OSwg==
X-Gm-Message-State: AOAM530g/cy++oTIJLNlFZS6UgiXANsyxYc13C4NsxVQDQxBm9rfYEru
        rQrbkLuWkF63V3X35SYZTiQOpg==
X-Google-Smtp-Source: ABdhPJxMhv6/aTc07g+aRu0kKwlSBZngH3ac2/UzBiPg0iYY592dYXV1r/vGD/eQSlFnx2neGTkSkg==
X-Received: by 2002:a9d:887:: with SMTP id 7mr8265142otf.120.1629311642661;
        Wed, 18 Aug 2021 11:34:02 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j6sm112299ooj.11.2021.08.18.11.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 11:34:02 -0700 (PDT)
Subject: Re: [PATCH] x86/sgx: Add SGX_MemTotal to /proc/meminfo
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>
Cc:     linux-sgx@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Saravanan D <saravanand@fb.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210818132509.545997-1-jarkko@kernel.org>
 <acd5a925-ce86-9934-5e1c-d0bcee3f606b@fortanix.com>
 <20210818134026.GA7967@iki.fi>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ffcef189-78fd-1b57-88bb-577708fb7abc@linuxfoundation.org>
Date:   Wed, 18 Aug 2021 12:34:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210818134026.GA7967@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8/18/21 7:40 AM, Jarkko Sakkinen wrote:
> On Wed, Aug 18, 2021 at 03:29:59PM +0200, Jethro Beekman wrote:
>> On 2021-08-18 15:25, Jarkko Sakkinen wrote:
>>> The amount of SGX memory on the system is determined by the BIOS and it
>>> varies wildly between systems.  It can be from dozens of MB's on desktops
>>> or VM's, up to many GB's on servers.  Just like for regular memory, it is
>>> sometimes useful to know the amount of usable SGX memory in the system.
>>>
>>> Add SGX_MemTotal field to /proc/meminfo, which shows the total amount of
>>> usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from
>>> BIOS, the printout would be:
>>>
>>> SGX_MemTotal:      22528 kB
>>>
>>> It is less than 32 MB because some of the space is reserved for Enclave
>>> Page Cache Metadata (EPCM), which contains state variables for all the
>>> pages in the Enclave Page Cache (EPC).  The latter contains the pages,
>>> which applications can use to create enclaves.
>>>
>>> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
>>> ---
>>>   Documentation/x86/sgx.rst      |  6 ++++++
>>>   arch/x86/include/asm/sgx.h     | 10 +++++++---
>>>   arch/x86/kernel/cpu/sgx/main.c |  7 ++++++-
>>>   arch/x86/mm/pat/set_memory.c   |  5 +++++
>>>   4 files changed, 24 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
>>> index dd0ac96ff9ef..68ee171e1d8f 100644
>>> --- a/Documentation/x86/sgx.rst
>>> +++ b/Documentation/x86/sgx.rst
>>> @@ -250,3 +250,9 @@ user wants to deploy SGX applications both on the host and in guests
>>>   on the same machine, the user should reserve enough EPC (by taking out
>>>   total virtual EPC size of all SGX VMs from the physical EPC size) for
>>>   host SGX applications so they can run with acceptable performance.
>>> +
>>> +Supplemental fields for /proc/meminfo
>>> +=====================================
>>> +
>>> +SGX_MemTotal
>>> +	The total usable SGX protected memory in kilobytes.
>>> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
>>> index 05f3e21f01a7..2ae9dc8c9411 100644
>>> --- a/arch/x86/include/asm/sgx.h
>>> +++ b/arch/x86/include/asm/sgx.h
>>> @@ -365,6 +365,13 @@ struct sgx_sigstruct {
>>>    * comment!
>>>    */
>>>   
>>> +#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
>>> +extern unsigned long sgx_nr_all_pages;
>>> +
>>> +int sgx_set_attribute(unsigned long *allowed_attributes,
>>> +		      unsigned int attribute_fd);
>>> +#endif
>>> +
>>>   #ifdef CONFIG_X86_SGX_KVM
>>>   int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
>>>   		     int *trapnr);
>>> @@ -372,7 +379,4 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
>>>   		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
>>>   #endif
>>>   
>>> -int sgx_set_attribute(unsigned long *allowed_attributes,
>>> -		      unsigned int attribute_fd);
>>> -
>>
>> This change seems unrelated?
> 
> It's just a good practice not to define symbols that do not exist, so that
> if the symbol is ever used, we get a compilation error, not linking error.
> 
> Since this is included to set_memory.c, based on this conclusion, I added
> the check.
> 

It would make sense to make this change in a separate patch since.

thanks,
-- Shuah



