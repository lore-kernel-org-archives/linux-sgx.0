Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4888C433FE
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 19:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98E8623C41
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 19:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgLITW4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Dec 2020 14:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbgLITW4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Dec 2020 14:22:56 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFC1C0613D6;
        Wed,  9 Dec 2020 11:22:15 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id f24so3711218ljk.13;
        Wed, 09 Dec 2020 11:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IX5zrYemBuqu6q8LTcF2s2JzdukT55vN2qrP/q8aYMk=;
        b=DEcFfAaCDWI72bSJBs5cYKcTojcP78YQlxK6AXG0y1AYfqCTVs7/BsYG7tI8lZYItl
         Yp7RjdFlKKG6Tlzqb+MnQLIc9ldGWXKtsK2uqpeuDd55gpuxJTqHbd3VWCWokSHyVO+D
         OL/SI1QhbaFX9bx70plFgmlWOKCMSl14kY3+jJZyEL/p5UnuouBbBDwI3QVF3FkmeJoC
         nBgVY5wshuweg3GCf4OLYq//st6+6ePjLELDH7SB5XYZ42Zi/m87meZwVZ+Q+U+gl9PB
         aowDCxXogXC1EX12nKnWrDemM3+dEBLT7x9NXReQ//YOdQ8lYKnJsEoX4uhwNFj6FWgS
         szzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IX5zrYemBuqu6q8LTcF2s2JzdukT55vN2qrP/q8aYMk=;
        b=WrrIIrq1jno2wnMtphrhDCxelV6/G3v+SskePkMLAzVCV8ICDg9z3jZhgQyGYcm4vO
         4IA7sJcHLaYOP8JTQab6GQKKuZR27Zb3PPcjS35pAWfWl/zR7qWb62QfU9/Q0o/B2mUK
         LHRPlymbVUgW0IqPZlqnjY4M7zmv1ShLXfqn2C/6Vd5JPwbqUe97h8L2KTxPeSn/UaN1
         /suIlJTGKIOEhntAaVTA/HWn6cXhXK3dkxAaspv1CYdGQ8Cx9qVh95QtP8uvhmeV70qD
         x50sYN5ZH/rAg6dIQ97SzIkt3EJjxSg+Mjfir0qV6PhQU5+rRbPCDMcIrOV8t/60l/rZ
         B1yA==
X-Gm-Message-State: AOAM530PVX9bkCnc7kAtS6JXTkp6TshEvF/Tp4Oaaew2mJK9OnaZfASt
        p5emmoAjCYLXKSKqYPO0Rc0=
X-Google-Smtp-Source: ABdhPJzkMjxlBgMFbVukhtLSMtu45PZQr3M3OAYUszQ1hGbScjLZvgo8Lu9JOTqX6/OA9JqOtuRvxg==
X-Received: by 2002:a05:651c:1a4:: with SMTP id c4mr1575470ljn.243.1607541734082;
        Wed, 09 Dec 2020 11:22:14 -0800 (PST)
Received: from [192.168.1.33] (88-114-222-21.elisa-laajakaista.fi. [88.114.222.21])
        by smtp.gmail.com with ESMTPSA id 131sm262495lfb.248.2020.12.09.11.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 11:22:13 -0800 (PST)
Subject: Re: Creating executable device nodes in /dev?
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
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
References: <f2279f2d-f0a6-a948-9691-96f47a0bd997@gmail.com>
 <308AE66A-F401-4D2D-9D53-17E11EAF68E3@amacapital.net>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <293dd2c6-972f-b2ae-666e-aa6b01b94b26@gmail.com>
Date:   Wed, 9 Dec 2020 21:22:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <308AE66A-F401-4D2D-9D53-17E11EAF68E3@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9.12.2020 17.14, Andy Lutomirski wrote:
> 
>> On Dec 9, 2020, at 12:58 AM, Topi Miettinen <toiwoton@gmail.com> wrote:
>>
>> ﻿On 9.12.2020 2.42, Jarkko Sakkinen wrote:
>>>> On Wed, Dec 09, 2020 at 02:15:28AM +0200, Jarkko Sakkinen wrote:
>>>> On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
>>>>>>>> As  a further argument, I just did this on a Fedora system:
>>>>>>>> $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
>>>>>>>> No results.  So making /dev noexec doesn't seem to have any benefit.
>>>>>>>
>>>>>>> It's no surprise that there aren't any executables in /dev since
>>>>>>> removing MAKEDEV ages ago. That's not the issue, which is that
>>>>>>> /dev is a writable directory (for UID=0 but no capabilities are
>>>>>>> needed) and thus a potential location for constructing unapproved
>>>>>>> executables if it is also mounted exec (W^X).
>>>>>>
>>>>>> UID 0 can just change mount options, though, unless SELinux or similar is used. And SELinux can protect /dev just fine without noexec.
>>>>>
>>>>> Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also SELinux
>>>>> is not universal and the policies might not contain all users or services.
>>>>>
>>>>> -Topi
>>>>
>>>> What's the data that supports having noexec /dev anyway? With root
>>>> access I can then just use something else like /dev/shm mount.
>>>>
>>>> Has there been out in the wild real world cases that noexec mount
>>>> of would have prevented?
>>> Typo: "of" = "of /dev"
>>>> For me this sounds a lot just something that "feels more secure"
>>>> without any measurable benefit. Can you prove me wrong?
>>> The debate is circled around something not well defined. Of course you
>>> get theoretically more safe system when you decrease priviliges anywhere
>>> in the system. Like you could start do grazy things with stuff that
>>> unprivilged user has access, in order to prevent malware to elevate to
>>> UID 0 in the first place.
>>> I think where this go intellectually wrong is that we are talking about
>>> *default installation* of a distribution. That should have somewhat sane
>>> common sense access control settings. For like a normal desktop user
>>> noexec /dev will not do any possible favor.
>>> Then there is the case when you want to harden installation for an
>>> application, let's' say some server. In that case you will anyway
>>> fine-tune the security settings and go grazy enough with hardening.
>>> When you tailor a server, it's a standard practice to enumerate and
>>> adjust the mount points if needed.
>>
>> I think we agree that there's a need for either way to allow SGX (if default is hardened) or a hardening option (in the opposite case). For systemd I see two approaches:
>>
>> 1. Default noexec /dev, override with something like
>> - ExecPaths=/dev
>> - MountOptions=/dev:rw,exec,dev,nosuid
>> - or even MountOptions=/dev/sgx:rw,exec,dev,nosuid
>> - ProtectDev=no
>> - AllowSGX=yes
>>
>> 2. Default exec /dev, override with
>> - NoExecPaths=/dev
>> - MountOptions=/dev:rw,noexec,dev,nosuid
>> - ProtectDev=yes
>> - DenySGX=yes
>>
>> I'd prefer 1. but of course 2. would be reasonable.
> 
> I would argue for 2, for the following reason.  I absolutely agree that hardening a system by making it impossible to create executable code dynamically is valuable, but I don’t think it’s a good default. By default, programs like gcc and clang should work, but so should JITs, and JITs are getting more popular and powerful all the time.  In a default setting that allows JITs, etc, I see no benefit at all to making /dev noexec. To the contrary, making /dev noexec seems like plugging a little restricted corner of code creation (because it requires UID=0) while allowing the easy ways (/tmp, /home, /dev/shm, unshare(2), mmap(), etc).  By all means let admins harden this, but I see no reason to apply some of the hardening when the rest is disabled.

Makes sense, especially if anything in theory could be expected to use 
SGX. In practice, probably no system services will at least initially, 
so hardening knobs make also sense.

> 
>>
>>> To summarize, I neither understand the intended target audience.
>>
>> We have something in common: me neither. What's the target audience for SGX? What's the use case? What are the users: browsers, system services? How would applications use SGX? Should udev rules for /dev/sgx make it available to any logged in users with uaccess tags?
>>
>>
> 
> I would certainly like it to be available to all software, with the possible exception of extra-hardened systems. Using SGX is not really an interesting attack surface. The main threat is that malware might use SGX to make itself hard to reverse engineer.

Maybe also malware which can escape all means of detection, enforced by 
the CPU? Though I don't know if any malware scanners for Linux work can 
check for fileless, memory only malware.

> 
> In Intel’s original vision, only specially licensed vendors could create SGX software, but Linux pushed back against this quite hard, and new CPUs allow unlicensed enclaves. So your Skylake CPUs support SGX, but not on Linux.

Kudos to Linux for the push.

-Topi
