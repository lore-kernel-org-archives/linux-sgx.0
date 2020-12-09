Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4406EC4167B
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 08:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFDAB23A79
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 08:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgLII6r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Dec 2020 03:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgLII6r (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Dec 2020 03:58:47 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5440C0613CF;
        Wed,  9 Dec 2020 00:58:06 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id e7so1326163ljg.10;
        Wed, 09 Dec 2020 00:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1OP6rHqneqNKk5uYvA35TGi9JcfZ+IDErf0wgntakZQ=;
        b=La5Hi4BE9+PMtY5EcqslRej2B0IFFJzgvL3bxMwW59IBNJhiyutT0+9v0Wgb5XUU4h
         ylhUNQ3c8cuRVER8YGxgcram2mi2NdNw/LIJju4lIMUD+VTuiPnrUjju8yVZRb5H/lUu
         Svltmqo+lt77EC+Sal++uqp4C24bdX5a5YDJUDQP6kNE/BHFfw0TAhJZzJvjlFJ0SfJ9
         0XK/7NMaKPOHOeGY0GbTgG/DCUrvV+UApWy6z42adfY0Y3nSVLN+KFLprcaJS6jXrtBS
         HaK1UQUaaCNK24M3EWameLhhfXXOuLO0Ehi/r8jyNlVo/OsPCRc4PVpzbdLgMQjT3Oqc
         fXzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1OP6rHqneqNKk5uYvA35TGi9JcfZ+IDErf0wgntakZQ=;
        b=gCaROKamzDADdKPtwyHF+Kb7tyIrEimvIAH0xJV1um5utbyVCSIewaShp2SwcT17JU
         EJW0NcGStlCOxpzj4nXZt7d0jOwJQpfcVphk85SugI6PvIONw3CG2lSnZb/KjejW1H1Q
         6LhZN0STQObYRTplvmZdH5sFQBLJ26RZoBEK9ymSQ/ATl5wEl56JH1yXI8cmJL3gvs1g
         qMo4H5CpAivb1AYeRcdq259ANsM6vS2YxzeXz18wut5HAT6TQSdTUGPPsxqc7zT7w8Sw
         hb2ntNrkGtHHJATsVA1FdWcJHV4CEbLyhO+wr+4lDLfjDJnP8Vm7OjAk9VjR2DjmU12C
         rkEA==
X-Gm-Message-State: AOAM5308JOruYQaHQiWngrJFKH1LUKJf9rgFbM8fF/czEZAO9jCKRB4/
        Cwh++MZbnSoByGIxUjrtoZw=
X-Google-Smtp-Source: ABdhPJw9mVTTFIZSheBo9orTErjMhT2HVtjUlaT5f7BiIslLDiav/+SwqWS5dnwBw2+/uDJr5a5NaQ==
X-Received: by 2002:a2e:b4a9:: with SMTP id q9mr708859ljm.140.1607504285483;
        Wed, 09 Dec 2020 00:58:05 -0800 (PST)
Received: from [192.168.1.33] (88-114-222-21.elisa-laajakaista.fi. [88.114.222.21])
        by smtp.gmail.com with ESMTPSA id o15sm144434ljh.57.2020.12.09.00.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 00:58:04 -0800 (PST)
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
 <20201209001521.GA64007@kernel.org> <20201209004214.GA64820@kernel.org>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <f2279f2d-f0a6-a948-9691-96f47a0bd997@gmail.com>
Date:   Wed, 9 Dec 2020 10:58:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209004214.GA64820@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9.12.2020 2.42, Jarkko Sakkinen wrote:
> On Wed, Dec 09, 2020 at 02:15:28AM +0200, Jarkko Sakkinen wrote:
>> On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
>>>>>> As  a further argument, I just did this on a Fedora system:
>>>>>> $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
>>>>>> No results.  So making /dev noexec doesn't seem to have any benefit.
>>>>>
>>>>> It's no surprise that there aren't any executables in /dev since
>>>>> removing MAKEDEV ages ago. That's not the issue, which is that
>>>>> /dev is a writable directory (for UID=0 but no capabilities are
>>>>> needed) and thus a potential location for constructing unapproved
>>>>> executables if it is also mounted exec (W^X).
>>>>
>>>> UID 0 can just change mount options, though, unless SELinux or similar is used. And SELinux can protect /dev just fine without noexec.
>>>
>>> Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also SELinux
>>> is not universal and the policies might not contain all users or services.
>>>
>>> -Topi
>>
>> What's the data that supports having noexec /dev anyway? With root
>> access I can then just use something else like /dev/shm mount.
>>
>> Has there been out in the wild real world cases that noexec mount
>> of would have prevented?
> 
> Typo: "of" = "of /dev"
> 
>> For me this sounds a lot just something that "feels more secure"
>> without any measurable benefit. Can you prove me wrong?
> 
> The debate is circled around something not well defined. Of course you
> get theoretically more safe system when you decrease priviliges anywhere
> in the system. Like you could start do grazy things with stuff that
> unprivilged user has access, in order to prevent malware to elevate to
> UID 0 in the first place.
> 
> I think where this go intellectually wrong is that we are talking about
> *default installation* of a distribution. That should have somewhat sane
> common sense access control settings. For like a normal desktop user
> noexec /dev will not do any possible favor.
> 
> Then there is the case when you want to harden installation for an
> application, let's' say some server. In that case you will anyway
> fine-tune the security settings and go grazy enough with hardening.
> When you tailor a server, it's a standard practice to enumerate and
> adjust the mount points if needed.

I think we agree that there's a need for either way to allow SGX (if 
default is hardened) or a hardening option (in the opposite case). For 
systemd I see two approaches:

1. Default noexec /dev, override with something like
- ExecPaths=/dev
- MountOptions=/dev:rw,exec,dev,nosuid
- or even MountOptions=/dev/sgx:rw,exec,dev,nosuid
- ProtectDev=no
- AllowSGX=yes

2. Default exec /dev, override with
- NoExecPaths=/dev
- MountOptions=/dev:rw,noexec,dev,nosuid
- ProtectDev=yes
- DenySGX=yes

I'd prefer 1. but of course 2. would be reasonable.

> To summarize, I neither understand the intended target audience.

We have something in common: me neither. What's the target audience for 
SGX? What's the use case? What are the users: browsers, system services? 
How would applications use SGX? Should udev rules for /dev/sgx make it 
available to any logged in users with uaccess tags?

-Topi
