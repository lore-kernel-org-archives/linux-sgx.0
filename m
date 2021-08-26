Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEA0C4320E
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 22:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B03B60E93
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 22:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbhHZW2E (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Aug 2021 18:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243782AbhHZW2D (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 26 Aug 2021 18:28:03 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFF8C0613C1;
        Thu, 26 Aug 2021 15:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=NmGVEeD4f8GyoVLFzkkr+SOsTZSFXpPD5NNKXMPh4iI=; b=BEfzKtSSzenCGG8PcnTcDRY7ka
        2EhoRY1gg1xloqLf0gyivyjnhKX/7/GxC1Oipx8t04nznYASqPUTPp0uzV1LnA0sc33N1aHH3nsDe
        bzzFf5pkvTZG+5UUwOETdLytj+5k3hjIYocA3KzpZop13YWHoLWYE+isMO+BKA44fMaHdqrXE75v1
        FrNGb/UZYgSXVojqkQOvW4ZXX5ZJkbx+t4JDxe5S6H6MVyE4SPUoply1T/AQVKriHg5ym4JZ0oOsU
        AML4LTaadXfoXYpxYauPsAsvukACTeM4yhwqnwxbhDudDwQ7pb+Wo3r7A91mBXzkWpEUU5YRzTix9
        LrEAEEUg==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJNq5-00B0BZ-0A; Thu, 26 Aug 2021 22:27:13 +0000
Subject: Re: [PATCH v3 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
To:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20210825235234.153013-1-jarkko@kernel.org>
 <20210825235234.153013-2-jarkko@kernel.org>
 <ba483b7e-19a3-d4d3-56c0-3371a77341cb@infradead.org>
 <e1ff36db0e7ed909653b6adb45094cc459dbad0b.camel@kernel.org>
 <e87c5c8f-dead-ebdc-62f1-aa635288671c@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <124ad6ff-ee0d-5d59-0857-f1355578b59b@infradead.org>
Date:   Thu, 26 Aug 2021 15:27:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <e87c5c8f-dead-ebdc-62f1-aa635288671c@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8/26/21 1:27 PM, Dave Hansen wrote:
> On 8/26/21 9:17 AM, Jarkko Sakkinen wrote:
>>> I would prefer to see this listed in Documentation/filesystems/proc.rst
>>> as an optional field, depending on CONFIG_X86_SGX.
>>> Or at least put a reference in proc.rst to this doc file and its
>>> supplemental fields.
>>>
>>> thanks.
>> I *can* put it there but I did have reason not to, i.e. these attributes
>> are neither there:
>>
>> DirectMap4k:     3930904 kB
>> DirectMap2M:    29440000 kB
>> DirectMap1G:     1048576 kB
>>
>> And they are implemented in arch specific code.
>>
>> Actually they are undocumented, e.g.
>>
>> $ git grep DirectMap4k
>> arch/powerpc/mm/book3s64/pgtable.c:     seq_printf(m, "DirectMap4k:    %8lu kB\n",
>> arch/s390/mm/pageattr.c:        seq_printf(m, "DirectMap4k:    %8lu kB\n",
>> arch/x86/mm/pat/set_memory.c:   seq_printf(m, "DirectMap4k:    %8lu kB\n",
> 
> Yeah, we need to add some arch-specific sections to the documentation.
> That *could* just be a reference over to a new file:
> 
> 	Documentation/x86/meminfo.rst
> 
> along with whatever other arches provide their own fields too.
> 

Yes, either way works. Thanks.

-- 
~Randy

