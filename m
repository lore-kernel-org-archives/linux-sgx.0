Return-Path: <SRS0=BG2U=5X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968F2C2D0EC
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 19:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CF5B20730
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 19:54:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gp6gjjVW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgDGTyv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Apr 2020 15:54:51 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33830 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgDGTyu (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Apr 2020 15:54:50 -0400
Received: by mail-lf1-f66.google.com with SMTP id x23so3370631lfq.1
        for <linux-sgx@vger.kernel.org>; Tue, 07 Apr 2020 12:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qcwsrmOKmvw7qqa1Tiy114Fzoj4jXowlcj6m5kmNP94=;
        b=gp6gjjVW/VZ3EWP1tUfttET0/H85MY9ciDBzb/5UJD05JIqrEdDb+dlYapx9RoKJfJ
         mALWv7HjA0MDnuySPpiIWLRCy4fEfwxJk8iKAZfoaf8TYW+WlJTlpDibi1EXW1D225D3
         ddLzq9g5ECYG0dX+GqoN01jnHu/JUu2fngfIukmdHgRvNj+1fihjcFnYV5Ca3IIx35eh
         F6uCWFKjciw3ZSi8E0Zpm2P5DncVEKwLuG7N8b1AUMEC05WNiVFYsk8qGxcUOLnf8AZG
         BSV6+Ly3ko4HmBdnuwK7Nv2h4M+MywHJoK5EoGjgsUYs3b4k/MgXwIXzxNV0ul0dqYmU
         38wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qcwsrmOKmvw7qqa1Tiy114Fzoj4jXowlcj6m5kmNP94=;
        b=Ly8mp+kyOW8vY9npQVjAmGN1/TrU3eOwcjrjqsnalsXalwxWd4yNgDFWbrgsgSgzUR
         Kk8eh6xKf8YsiWdlMkx3kW4H569/XhdOnYdx76ZisGRtE5MGcYMhvWpplR/VNUMHPfKP
         SptUJc3IafwKFEoU839PY9gk8Nv/5IUN4WwMX9zhl3nPsoCcH87O7OUcDSKcf4btXBgc
         AWxOAwUz8knjOJYK+LnOes7VOkw/g9w9Z08bhrnEjHGmJq3LBgF3hjrz5bYBJk0t6QGW
         IugNpEpDzd0NDj/DzTuePNjyk9mG9OdwRl8xG4pvZZqL8rkximeqjOkMEv93CvCGt+3Y
         Ok8A==
X-Gm-Message-State: AGi0PuabWCaiWPuu7pi0UPk3bsbceIuYGVuFPe5YCZDSb1DEvpH2VDL3
        4ZowXJYQoGUYVozMlteknYs=
X-Google-Smtp-Source: APiQypJGLXp7Qcc1RiXiV2vbB3Haa9j4VRmwNNWfzasks/TUJ2y897zD9nJm5kRt1UoyBFEVWhLzuw==
X-Received: by 2002:a05:6512:108a:: with SMTP id j10mr2473105lfg.38.1586289288363;
        Tue, 07 Apr 2020 12:54:48 -0700 (PDT)
Received: from [192.168.1.38] (88-114-211-119.elisa-laajakaista.fi. [88.114.211.119])
        by smtp.gmail.com with ESMTPSA id i2sm14874463ljj.72.2020.04.07.12.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 12:54:47 -0700 (PDT)
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
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <7009f0e2-cdfc-1703-2b73-bb683a89c8d1@gmail.com>
Date:   Tue, 7 Apr 2020 22:54:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200407180410.GA17916@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7.4.2020 21.04, Jarkko Sakkinen wrote:
> On Tue, Apr 07, 2020 at 07:59:00PM +0300, Jarkko Sakkinen wrote:
>> On Tue, Apr 07, 2020 at 07:57:08PM +0300, Jarkko Sakkinen wrote:
>>> On Tue, Apr 07, 2020 at 12:04:58PM +0300, Topi Miettinen wrote:
>>>> Please correct me if I'm wrong, but isn't it the goal of SGX to let a
>>>> (suitably privileged) process designate some of its memory areas as part of
>>>> SGX enclave? If so, why don't you simply add a system call to do so, such as
>>>>
>>>> int sgx_mprotect(void *start, size_t length, int prot, u64 sgx_flags);
>>>>
>>>> like existing pkey_mprotect()? Or add a flag PROT_SGX to mprotect() like
>>>> existing PROT_SAO/PROT_SEM?
>>>>
>>>> -Topi
>>>
>>> New syscalls is always the last resort path, especially if they are
>>> associated with an arch.
>>>
>>> PROT_SGX sounds something worth of consideration.
>>>
>>> Another idea to throw would be noexec_dev mount option that would allow
>>> exec *only* for the device nodes (zero analysis done on feasibility).
>>
>> The 2nd proposal has the merit that it would scale above SGX and
>> does not give additional strengths to the adversary in the context
>> of the threat scenario.
> 
> Or.
> 
> Why couldn't kernel just disallow anything but device files to be
> created to devtmpfs unconditionally?

It seems to be just a regular tmpfs but with direct access to add device 
nodes when drivers are loaded. Nice idea, maybe something like that 
could be done with SELinux policy.

-Topi
