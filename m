Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C04C433FE
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 11:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7480C23DE3
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 11:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgLKLrP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Dec 2020 06:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgLKLqt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 11 Dec 2020 06:46:49 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB24C0613CF;
        Fri, 11 Dec 2020 03:46:08 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id n11so5700085lji.5;
        Fri, 11 Dec 2020 03:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JzbBB7+A9mLRJoe+bbqSBmrJkuV0MEemKS6dLG4PqK8=;
        b=NTxwgIpMtsOxIsXK5ZsJnKXpDBZ9tUBjpwk+t0R7sGptIcdlNXS07JyHyyvisiqLdU
         5e8u50Kq2ErKSz7xe6yE56cqbF7Zu3g8Rrt3q3cjXSwefWJu5r9aH0iUpNZt8pKvdSoH
         hHUX4sIT/BJOGqj9xWzbHGE3IC3O+tqVCqIRkP54PjQ65vrU6NVlnU3gOGSpk3HOjWPo
         Vxo5R2NJx5s/ksbgPB7uNn6Neikn6ISelpw0DB9RprIWcsTZsGNAmOlbD52LVSHoXVXE
         Q8KM7EkscVyQWirbBjdIciyax3vJK4UsMRHrVcFoRAPf6Ny8GV/TFrJAIWE7U9Y3azKZ
         UCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JzbBB7+A9mLRJoe+bbqSBmrJkuV0MEemKS6dLG4PqK8=;
        b=agATqyZ/4ohyrc/jjvmAzvavrqa7/FW1L0+1/NAoZ26QQTgX4Xy3pHgJKYBMboVA2K
         rofkKr95XoLZV3bel6ehlno6g7asFTI/RHNXR/2nnuJ0h/GZ7lc5VGXqV1ze4R0DrZmb
         ANgw0Ldr6fXbdskKAC6VOAMfy4pg7ml16GVVCSHu+wRb2fyGhdM6cuPeJ6mM2FERxjRE
         WSIvz9sJJo8QquWpNE1NbJj4JfHpsWMUaoj0YxoN27BODjoBSNBZ++/yc58M2Zb/vq0k
         vYsqaZV+6WT7JeQd+8yoUNhm5JJgGOAVMnTfi492ypoeq1TIa7ux+kAW9Zdb8piY8P35
         YPiQ==
X-Gm-Message-State: AOAM531liyN6WfCO8NPYRvcrYgV/twCRCI7Tts10GsdzaSXgjuv2J801
        U3A3090AObZZa+3QgknPODI=
X-Google-Smtp-Source: ABdhPJya9GqLKhLi4q267mgJhlufyLWlIUhAtVOXkjibp6EkdFBTYIws8866cLAsczgMs4U/nHizmw==
X-Received: by 2002:a05:651c:2121:: with SMTP id a33mr5227530ljq.381.1607687167420;
        Fri, 11 Dec 2020 03:46:07 -0800 (PST)
Received: from [192.168.1.33] (88-114-222-21.elisa-laajakaista.fi. [88.114.222.21])
        by smtp.gmail.com with ESMTPSA id c2sm857465lft.35.2020.12.11.03.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 03:46:06 -0800 (PST)
Subject: Re: Creating executable device nodes in /dev?
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
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
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
 <b1cf9503-0c1c-ab9e-3cc4-ef2b7611b280@gmail.com>
 <20201211104635.GD12091@kernel.org>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <27796c04-249e-6cf0-c3e1-0fd657a82f9c@gmail.com>
Date:   Fri, 11 Dec 2020 13:46:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201211104635.GD12091@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 11.12.2020 12.46, Jarkko Sakkinen wrote:
> On Wed, Dec 09, 2020 at 10:35:21AM +0200, Topi Miettinen wrote:
>> On 9.12.2020 2.15, Jarkko Sakkinen wrote:
>>> On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
>>>>>>> As  a further argument, I just did this on a Fedora system:
>>>>>>> $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
>>>>>>> No results.  So making /dev noexec doesn't seem to have any benefit.
>>>>>>
>>>>>> It's no surprise that there aren't any executables in /dev since
>>>>>> removing MAKEDEV ages ago. That's not the issue, which is that
>>>>>> /dev is a writable directory (for UID=0 but no capabilities are
>>>>>> needed) and thus a potential location for constructing unapproved
>>>>>> executables if it is also mounted exec (W^X).
>>>>>
>>>>> UID 0 can just change mount options, though, unless SELinux or similar is used. And SELinux can protect /dev just fine without noexec.
>>>>
>>>> Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also SELinux
>>>> is not universal and the policies might not contain all users or services.
>>>>
>>>> -Topi
>>>
>>> What's the data that supports having noexec /dev anyway? With root
>>> access I can then just use something else like /dev/shm mount.
>>>
>>> Has there been out in the wild real world cases that noexec mount
>>> of would have prevented?
>>>
>>> For me this sounds a lot just something that "feels more secure"
>>> without any measurable benefit. Can you prove me wrong?
>>
>> I don't think security works that way. An attacker has various methods to
>> choose from, some are more interesting than others. The case where rw,exec
>> /dev would be interesting would imply that easier or more common avenues
>> would be blocked, for example rw,exec /dev/shm, /tmp, /var/tmp, or
>> /run/user/$UID/ for user. Also fileless malware with pure ROP/JOP approach
>> with no need for any file system access is getting more common. It does not
>> mean that it would not be prudent to block the relatively easy approaches
>> too, including /dev.
> 
> What if we add a new mount option "chrexec", which allows exec
> for character devices (S_IFCHR).

I think devices are a bad match for SGX because devices haven't been 
executable and SGX is actually an operation for memory. So something 
like memfd_create(, MFD_SGX) or mmap(,, PROT_READ|PROT_EXEC|PROT_SGX) 
would be much more natural. Even better would be something that 
conceptully also works for AMD version (either with the same flags or 
MFD_SGX / MFD_whatever_the_AMD_version_is).

-Topi
