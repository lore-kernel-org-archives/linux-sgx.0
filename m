Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE17C433FE
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 08:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CE51225AA
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 08:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgLIIgI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Dec 2020 03:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgLIIgH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Dec 2020 03:36:07 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C22C0613CF;
        Wed,  9 Dec 2020 00:35:27 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id m25so1944732lfc.11;
        Wed, 09 Dec 2020 00:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zgQ0iYlwvWT5p+IJPdj9thjYvl7RRBzuaQmTol6QAsE=;
        b=mzj3Nx9sQ1k6H7D7BQVrc2PZFkI/T1nQe13qlkuYn6TOFnlf3S0ScfHr956C2RhopV
         TWfD/gIenQo2UZ8FYTNOZvvc3KjqNs/kAnovyOfSxUxoUy3YAlX7Kxq/1sXFVSuPx0mC
         LUKnWfPAKlXapSVZ78nXBd6PUTJEVo6bWmBis0wXxYNIhBEC6kLtLVfSKGA7asZpa1xo
         MSj3LjSaJmV+eiwCtyfkdm9UL03bZNCKiPN7nTpkRfGAAwtpnL851HI2bAUBtYQ/ld0o
         qMeY/xcHofOwr3acfQEpgnzNH0TEL5PHdoHh8Azy0+rE4wNQTbzGumgXjIUcwXd+ODqp
         gjgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zgQ0iYlwvWT5p+IJPdj9thjYvl7RRBzuaQmTol6QAsE=;
        b=UA4XmwCECft3zm42DRFzy+PU6g7WOHHTLMVid/y1rc8yyzHq+aI7ggtbIF0WWoyuhi
         vcKknAVxrmV/QJ454cu7ofCIZ1jA4wbMdkdX9OBa/kSchma8MnXazNwjIkVmvvZohrza
         NQweiT92Y6nEZa59vIf81kAYbEjoiGmOzuQoPXRADZC4IfFnOYSGFtrdan/IqMxtihli
         dLwZIsn+0RtieAdyQ1IMNlCV0KCxS7SiFwHHP090ZACAAxYNPIX1f3NmIxIMG0m1vlLb
         vh//IE1owORYharwSDLSnCV6Ghz6zQCzdqXj+sHvgrpdBmcCmTkg1mQpJKVXWMetANbz
         cAFA==
X-Gm-Message-State: AOAM530ZRLDHbD28MoxvwmWYaYphLnlOP9N33fuuRXjEXR49lGkOcrLL
        5xgwfo6h2fF9bhe/WCvEq6o=
X-Google-Smtp-Source: ABdhPJwSN4OUoErhR/lIE4R3SkYXO+f6wouOB3qkpy4e6h4UddSZSp389BuPUqZMRRaxQaA9JEem6A==
X-Received: by 2002:ac2:5044:: with SMTP id a4mr604433lfm.583.1607502925804;
        Wed, 09 Dec 2020 00:35:25 -0800 (PST)
Received: from [192.168.1.33] (88-114-222-21.elisa-laajakaista.fi. [88.114.222.21])
        by smtp.gmail.com with ESMTPSA id q14sm93095lfb.281.2020.12.09.00.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 00:35:24 -0800 (PST)
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
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <b1cf9503-0c1c-ab9e-3cc4-ef2b7611b280@gmail.com>
Date:   Wed, 9 Dec 2020 10:35:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209001521.GA64007@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9.12.2020 2.15, Jarkko Sakkinen wrote:
> On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
>>>>> As  a further argument, I just did this on a Fedora system:
>>>>> $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
>>>>> No results.  So making /dev noexec doesn't seem to have any benefit.
>>>>
>>>> It's no surprise that there aren't any executables in /dev since
>>>> removing MAKEDEV ages ago. That's not the issue, which is that
>>>> /dev is a writable directory (for UID=0 but no capabilities are
>>>> needed) and thus a potential location for constructing unapproved
>>>> executables if it is also mounted exec (W^X).
>>>
>>> UID 0 can just change mount options, though, unless SELinux or similar is used. And SELinux can protect /dev just fine without noexec.
>>
>> Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also SELinux
>> is not universal and the policies might not contain all users or services.
>>
>> -Topi
> 
> What's the data that supports having noexec /dev anyway? With root
> access I can then just use something else like /dev/shm mount.
> 
> Has there been out in the wild real world cases that noexec mount
> of would have prevented?
> 
> For me this sounds a lot just something that "feels more secure"
> without any measurable benefit. Can you prove me wrong?

I don't think security works that way. An attacker has various methods 
to choose from, some are more interesting than others. The case where 
rw,exec /dev would be interesting would imply that easier or more common 
avenues would be blocked, for example rw,exec /dev/shm, /tmp, /var/tmp, 
or /run/user/$UID/ for user. Also fileless malware with pure ROP/JOP 
approach with no need for any file system access is getting more common. 
It does not mean that it would not be prudent to block the relatively 
easy approaches too, including /dev.

-Topi
