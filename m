Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1759AC19437
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Dec 2020 20:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A28222F9
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Dec 2020 20:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgLHUqc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgLHUqc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 8 Dec 2020 15:46:32 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBBEC061794;
        Tue,  8 Dec 2020 12:45:51 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id r24so79928lfm.8;
        Tue, 08 Dec 2020 12:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UTKCDPWyjiFwRGhVTzncsVI4T3AsQKO/caQVAKR1HRw=;
        b=Hm92NW8Nnsn4mDLZe2s1mRBA0RaRNi262g/dH7ZxbAg5KvW4uJtoF5fFamK9S3ELHh
         1CWuTrkgin8zs/JlOHhJfKUyoASCzlRjwNqqk49JlNu6SGVjX334BoN/TlqmD1SvvHvN
         fbhj66JSf1WxxZ+x4PuI0M9tDgqY1EV9ZrQCxDIF0ACABv04TK1TbWbwrznzk9FuUS5Z
         /DU9RQ8Qb896jPPuzG2qv5fvKLHi+dvBxLYRER7HtEPoSVTfOeF+QyPEzXlpFxJwvUKK
         KpjNrut4oEI+4xfdCuFsMq6tSN2DGY7F7zS4FHoLpwYsTeLV+XmNf/1sAlyWYPmfEisr
         kFRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UTKCDPWyjiFwRGhVTzncsVI4T3AsQKO/caQVAKR1HRw=;
        b=qpL9/RqLFlS/g6BOdd6mXivxSmiLOV59wvi1DF8X3llop6sUYSv2kviX1zj492+A6a
         b6WNlT7uzF52HNKujKQw15jSrjijGvihTlIsnrJ+MumgDPnz9ZL4+BkUVK66RIV+IYgV
         oW3tWJdrlqXV4d3k0vAR6K+B/MJ90JuTc2BEK9s14BAQCtYGnmZqLrLvGaQt9WGH2Lno
         iYcPgd+Y8ZXDZHlOZAshbQ7tO8nepekJzzavjc1MMk+8VoXrA/++Z64FHqhohcYuaN65
         VY5ct7+ZMECV85d6xfozQ1mma38W5eyq9Oq6fSBKR7cSPyEcZLC9/AS5s1Zu6NZfhzKe
         Ingw==
X-Gm-Message-State: AOAM530M2yIueq6mh4rHXt7lv0leY96pKCLhubhz5QbDQAXoBBZaz9cG
        /33XgiqcICHhwaREtEYS/7+L6AFPIgo=
X-Google-Smtp-Source: ABdhPJw+cU5lu9i9r88VckUFRK1kuzsZBVFvwGmyaFvNMXwOCiNsiNs1FwAz5HP1CgoMrQOjzM5gXg==
X-Received: by 2002:ac2:5285:: with SMTP id q5mr565820lfm.270.1607460350026;
        Tue, 08 Dec 2020 12:45:50 -0800 (PST)
Received: from [192.168.1.40] (88-114-216-158.elisa-laajakaista.fi. [88.114.216.158])
        by smtp.gmail.com with ESMTPSA id u10sm3344590lfb.151.2020.12.08.12.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 12:45:49 -0800 (PST)
Subject: Re: Creating executable device nodes in /dev?
To:     Andy Lutomirski <luto@kernel.org>
Cc:     =?UTF-8?Q?Zbigniew_J=c4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
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
References: <CALCETrWM2rGPRudtaQ=mn9MRsrbQqFfZDkOGsBbVMsk6mMw_+A@mail.gmail.com>
 <20201119163245.GN7348@in.waw.pl>
 <ff9aaf77-add3-dbeb-d05e-aedd93d41df0@gmail.com>
 <CALCETrW7JUquNf_KaA0UK9VEcswQZ+QMqFEQD_8G=c3JyH1xsQ@mail.gmail.com>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
Date:   Tue, 8 Dec 2020 22:45:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CALCETrW7JUquNf_KaA0UK9VEcswQZ+QMqFEQD_8G=c3JyH1xsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8.12.2020 20.07, Andy Lutomirski wrote:
> On Thu, Nov 19, 2020 at 10:05 AM Topi Miettinen <toiwoton@gmail.com> wrote:
>>
>> On 19.11.2020 18.32, Zbigniew Jędrzejewski-Szmek wrote:
>>> On Thu, Nov 19, 2020 at 08:17:08AM -0800, Andy Lutomirski wrote:
>>>> Hi udev people-
>>>>
>>>> The upcoming Linux SGX driver has a device node /dev/sgx.  User code
>>>> opens it, does various setup things, mmaps it, and needs to be able to
>>>> create PROT_EXEC mappings.  This gets quite awkward if /dev is mounted
>>>> noexec.
>>>>
>>>> Can udev arrange to make a device node executable on distros that make
>>>> /dev noexec?  This could be done by bind-mounting from an exec tmpfs.
>>>> Alternatively, the kernel could probably learn to ignore noexec on
>>>> /dev/sgx, but that seems a little bit evil.
>>>
>>> I'd be inclined to simply drop noexec from /dev by default.
>>> We don't do noexec on either /tmp or /dev/shm (because that causes immediate
>>> problems with stuff like Java and cffi). And if you have those two at your
>>> disposal anyway, having noexec on /dev doesn't seem important.
>>
>> I'd propose to not enable exec globally, but if a service needs SGX, it
>> could use something like MountOptions=/dev:exec only in those cases
>> where it's needed. That way it's possible to disallow writable and
>> executable file systems for most services (which typically don't need
>> /tmp or /dev/shm either). Of course the opposite
>> (MountOptions=/dev:noexec) would be also possible, but I'd expect that
>> this would be needed to be used more often.
>>
> 
> I imagine the opposite would be more sensible.  It seems odd to me
> that we would want any SGX-using service to require both special mount
> options and regular ACL permissions.

How common are thes SGX-using services? Will every service start using 
it without any special measures taken on it's behalf, or perhaps only a 
special SGX control tool needs access? What about unprivileged user 
applications, do they ever want to access SGX? Could something like 
Widevine deep in a browser need to talk to SGX in a DRM scheme?

> As  a further argument, I just did this on a Fedora system:
> 
> $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
> 
> No results.  So making /dev noexec doesn't seem to have any benefit.

It's no surprise that there aren't any executables in /dev since 
removing MAKEDEV ages ago. That's not the issue, which is that /dev is a 
writable directory (for UID=0 but no capabilities are needed) and thus a 
potential location for constructing unapproved executables if it is also 
mounted exec (W^X).

-Topi
