Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF09C433FE
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Dec 2020 23:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99840223DB
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Dec 2020 23:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgLHXQT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Dec 2020 18:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgLHXQT (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 8 Dec 2020 18:16:19 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DC5C0613CF;
        Tue,  8 Dec 2020 15:15:33 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id m12so741772lfo.7;
        Tue, 08 Dec 2020 15:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ACbaX0gBcc5vkLD/S0ZGL1yZPmSTA5BQ4b+fx1Pz6UY=;
        b=OOA75LYubR3kwpsUfQGbq2oQaXm+YcjwUwZkpZYy8dNCTjV3/uHc6dr5CveXczWrjy
         KN5AvIQmgYU8CLmT8/p+UxLLm+BSyer77l0RmlCzfkp/zRFoGYwM95HR0e7Yvu/Mc4R3
         +kGNyZc/n+jFiXTGOatOfHRIUUnW8DJ/8QH1oJxW/dra92ApXyy4qKwhBnzzw7fs8Uai
         K7p/Ga7pAoy+L9qTwBwMpGAbWUfkNIMBaCHXb3KSICHSgl5a1+c5E9SWoXq5tHVd/vdJ
         mEwsZpP2QVyD15i/1/qWQgbGf7DuvsWA9rpjE4ckb8/7jEmN5Gey6GJAmB58hhOPbo6P
         5ikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ACbaX0gBcc5vkLD/S0ZGL1yZPmSTA5BQ4b+fx1Pz6UY=;
        b=cN6acMMCWpIwBAnLWu22Ajzb9ODkOmv5O+vnFddnhKpX9wqCe1XaoRsJ32aXBZMVL2
         ecWBk1HJQKBqj002E2UhDmq38YInuOgj2A6vmOO9JW7y/RLBH52fgGeI1FKHEiwP8rP5
         9qPcfpuceTIQlNf8/XBZmFmsld8Q+T3dwTKIeajm17AjNOPeWxvAuYhTluBs+GbIjHzc
         GgXSVcxiY5kHZVuTFbhvCcKXrCEwtRWvWMqlCUBoUmuqEvnir5C1PAnphpFMTXYa4+C0
         xHLpF7S19ZDmy3unF05raXa7Cdg69gnYTKQBOa9XJx1BPilSu1bell1w7R/VP976c4vW
         UBvA==
X-Gm-Message-State: AOAM5307xASjDsV7z56cn6CZlzsG6zCjkYhpWnDu6KmAQlk+/vFS0v5A
        qdh2vigp0X4mwq9JNkSjn9TNXVPazv0=
X-Google-Smtp-Source: ABdhPJwCppYGsZFZmFoEL4a7sWrVucXefAfkxoDa2o067FBrXZzWWG68o3JppQ4IhJ5S0PYDXnuNCQ==
X-Received: by 2002:a05:6512:786:: with SMTP id x6mr1185430lfr.643.1607469331634;
        Tue, 08 Dec 2020 15:15:31 -0800 (PST)
Received: from [192.168.1.40] (88-114-216-158.elisa-laajakaista.fi. [88.114.216.158])
        by smtp.gmail.com with ESMTPSA id 26sm7727ljg.73.2020.12.08.15.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 15:15:31 -0800 (PST)
Subject: Re: Creating executable device nodes in /dev?
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Andy Lutomirski <luto@kernel.org>,
        =?UTF-8?Q?Zbigniew_J=c4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
        linux-hotplug@vger.kernel.org,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
Date:   Wed, 9 Dec 2020 01:15:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8.12.2020 23.30, Andy Lutomirski wrote:
> 
>> On Dec 8, 2020, at 12:45 PM, Topi Miettinen <toiwoton@gmail.com> wrote:
>>
>> ﻿On 8.12.2020 20.07, Andy Lutomirski wrote:
>>>> On Thu, Nov 19, 2020 at 10:05 AM Topi Miettinen <toiwoton@gmail.com> wrote:
>>>>
>>>> On 19.11.2020 18.32, Zbigniew Jędrzejewski-Szmek wrote:
>>>>> On Thu, Nov 19, 2020 at 08:17:08AM -0800, Andy Lutomirski wrote:
>>>>>> Hi udev people-
>>>>>>
>>>>>> The upcoming Linux SGX driver has a device node /dev/sgx.  User code
>>>>>> opens it, does various setup things, mmaps it, and needs to be able to
>>>>>> create PROT_EXEC mappings.  This gets quite awkward if /dev is mounted
>>>>>> noexec.
>>>>>>
>>>>>> Can udev arrange to make a device node executable on distros that make
>>>>>> /dev noexec?  This could be done by bind-mounting from an exec tmpfs.
>>>>>> Alternatively, the kernel could probably learn to ignore noexec on
>>>>>> /dev/sgx, but that seems a little bit evil.
>>>>>
>>>>> I'd be inclined to simply drop noexec from /dev by default.
>>>>> We don't do noexec on either /tmp or /dev/shm (because that causes immediate
>>>>> problems with stuff like Java and cffi). And if you have those two at your
>>>>> disposal anyway, having noexec on /dev doesn't seem important.
>>>>
>>>> I'd propose to not enable exec globally, but if a service needs SGX, it
>>>> could use something like MountOptions=/dev:exec only in those cases
>>>> where it's needed. That way it's possible to disallow writable and
>>>> executable file systems for most services (which typically don't need
>>>> /tmp or /dev/shm either). Of course the opposite
>>>> (MountOptions=/dev:noexec) would be also possible, but I'd expect that
>>>> this would be needed to be used more often.
>>>>
>>> I imagine the opposite would be more sensible.  It seems odd to me
>>> that we would want any SGX-using service to require both special mount
>>> options and regular ACL permissions.
>>
>> How common are thes SGX-using services? Will every service start using it without any special measures taken on it's behalf, or perhaps only a special SGX control tool needs access? What about unprivileged user applications, do they ever want to access SGX? Could something like Widevine deep in a browser need to talk to SGX in a DRM scheme?
> 
> I honestly don’t know. Widevine is probably some unholy mess of SGX and ME crud. But regular user programs may well end up using SGX for little non-evil enclaves, e.g. storing their keys securely.  It would be nice if unprivileged enclaves just work as long as the use has appropriate permissions on the device nodes.

Maybe, it would be also great if the access could be limited to those 
users or services which actually need it, by principle of least privilege.

> SGX adoption has been severely hampered by the massive series of recent vulnerabilities and by Intel’s silly licensing scheme. The latter won’t be supported upstream.
> 
>>
>>> As  a further argument, I just did this on a Fedora system:
>>> $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
>>> No results.  So making /dev noexec doesn't seem to have any benefit.
>>
>> It's no surprise that there aren't any executables in /dev since removing MAKEDEV ages ago. That's not the issue, which is that /dev is a writable directory (for UID=0 but no capabilities are needed) and thus a potential location for constructing unapproved executables if it is also mounted exec (W^X).
> 
> UID 0 can just change mount options, though, unless SELinux or similar is used. And SELinux can protect /dev just fine without noexec.

Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also 
SELinux is not universal and the policies might not contain all users or 
services.

-Topi
