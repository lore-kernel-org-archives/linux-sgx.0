Return-Path: <SRS0=hoRE=5Y=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93D0C2D0F4
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Apr 2020 21:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A836A2075E
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Apr 2020 21:15:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S1FAjpKG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgDHVPm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Apr 2020 17:15:42 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36329 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbgDHVPm (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Apr 2020 17:15:42 -0400
Received: by mail-lf1-f66.google.com with SMTP id w145so6295339lff.3
        for <linux-sgx@vger.kernel.org>; Wed, 08 Apr 2020 14:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kmO2/8pWfHHeQs80hNu3h9vKBOXwRcxjAKU2IRKNi9U=;
        b=S1FAjpKGxoQg70iQtiw8eOb9jU/GvA7s4961mlJhv/Yxzkzh4fbVqwlvFyWiK4phi4
         Mo0ldg2i0anvmOjdWVITNan/80V8I1e2vW745H/mt4oBk3fyD7MQzlE1RjfY2QNpiopD
         /vrqCh60u2w71pPSRWHCEqbthOpAylyKHpfRWNmyJvWh7LDGMnp/BdO5wsXMpIM/7Hmj
         gCq8QMoUJn3W3Kkkf5NeQTCMEVwL57MMUHyawezU7eWco3E9lqPVWyxcKfBTn4UnVhps
         vIloiG1WrKzyahBMKOj/Cy0pbjpvelZrCA82QCrGKwIvC0VDx0w/Cw4zO6Wljc7cOSlm
         RsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kmO2/8pWfHHeQs80hNu3h9vKBOXwRcxjAKU2IRKNi9U=;
        b=cUiEWYu1XLqcW+Btk8764pvU59HZnxS1gzyNGhaAB/w4HCG2PXomdV4vtqsas7fv4N
         aL6JmKINJFLuSgKMp7lVWF5u+GAVlQbFqTQvNEirlYzqhITNQwHky0+rh8I80JN91PlI
         m7EvY8cHZYFmQ1And+ErtxA4tZogQw+UrLNhoPE4H2beT3YCkZDp4Hw/GBbpgyWDQ7Zy
         R7+/g5ztwH8e29IpLSHqIu/pUJ4ZGG+Ft0FUGVAJWXHg9twG4MRav9gLGmSojrwmgNHj
         34gpuJkg0L+WRWp28tVuPBgeQV1bvJHuo7lWdyKNuN3+CakXPuyL0UBZI88/qsOD22bq
         fOkQ==
X-Gm-Message-State: AGi0PuZZv2pcrXCSmOZbxggfGbwb5EZLciYyLvwTFRTI2hGipMPTedJf
        uG7mX+8n2zN6xrzclaqfcvbawW4rGcE=
X-Google-Smtp-Source: APiQypJ51J18UlZ4OQyiae1P2aPvzbjTNXWSU5v9uQ+ylJOJ9IvuifrIjrANjPPqCND5bra2YT8LvQ==
X-Received: by 2002:a05:6512:3e2:: with SMTP id n2mr998460lfq.129.1586380538239;
        Wed, 08 Apr 2020 14:15:38 -0700 (PDT)
Received: from [192.168.1.38] (88-114-211-119.elisa-laajakaista.fi. [88.114.211.119])
        by smtp.gmail.com with ESMTPSA id e2sm14161094ljl.83.2020.04.08.14.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 14:15:37 -0700 (PDT)
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
 <ed382297-1488-1cdc-bd3f-a8a45de6c488@gmail.com>
 <20200407165704.GA14583@linux.intel.com>
 <20200407165900.GB14583@linux.intel.com>
 <20200407180410.GA17916@linux.intel.com>
 <7009f0e2-cdfc-1703-2b73-bb683a89c8d1@gmail.com>
 <20200408134049.GB4097@linux.intel.com>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <64ee4f81-0169-e4f1-9bfb-1b369ee917c4@gmail.com>
Date:   Thu, 9 Apr 2020 00:15:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200408134049.GB4097@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8.4.2020 16.40, Jarkko Sakkinen wrote:
> On Tue, Apr 07, 2020 at 10:54:46PM +0300, Topi Miettinen wrote:
>> On 7.4.2020 21.04, Jarkko Sakkinen wrote:
>>> On Tue, Apr 07, 2020 at 07:59:00PM +0300, Jarkko Sakkinen wrote:
>>>> On Tue, Apr 07, 2020 at 07:57:08PM +0300, Jarkko Sakkinen wrote:
>>>>> On Tue, Apr 07, 2020 at 12:04:58PM +0300, Topi Miettinen wrote:
>>>>>> Please correct me if I'm wrong, but isn't it the goal of SGX to let a
>>>>>> (suitably privileged) process designate some of its memory areas as part of
>>>>>> SGX enclave? If so, why don't you simply add a system call to do so, such as
>>>>>>
>>>>>> int sgx_mprotect(void *start, size_t length, int prot, u64 sgx_flags);
>>>>>>
>>>>>> like existing pkey_mprotect()? Or add a flag PROT_SGX to mprotect() like
>>>>>> existing PROT_SAO/PROT_SEM?
>>>>>>
>>>>>> -Topi
>>>>>
>>>>> New syscalls is always the last resort path, especially if they are
>>>>> associated with an arch.
>>>>>
>>>>> PROT_SGX sounds something worth of consideration.
>>>>>
>>>>> Another idea to throw would be noexec_dev mount option that would allow
>>>>> exec *only* for the device nodes (zero analysis done on feasibility).
>>>>
>>>> The 2nd proposal has the merit that it would scale above SGX and
>>>> does not give additional strengths to the adversary in the context
>>>> of the threat scenario.
>>>
>>> Or.
>>>
>>> Why couldn't kernel just disallow anything but device files to be
>>> created to devtmpfs unconditionally?
>>
>> It seems to be just a regular tmpfs but with direct access to add device
>> nodes when drivers are loaded. Nice idea, maybe something like that could be
>> done with SELinux policy.
> 
> Anyway, thank you for all the feedback.
> 
> What starts to be obvious is that we don't do anything in code level
> in SGX particular but instead workaround something around /dev.

If you take the /dev/sgx path, perhaps you could use KVM as a reference. 
It uses a similar special device /dev/kvm, works well with noexec /dev 
but still it can be used to do much more complex stuff than SGX.

-Topi
