Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3BAC4361B
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Dec 2020 13:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A35CE2339F
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Dec 2020 13:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgLPNFw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Dec 2020 08:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPNFw (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 16 Dec 2020 08:05:52 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A724C061794;
        Wed, 16 Dec 2020 05:05:11 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id u18so48120827lfd.9;
        Wed, 16 Dec 2020 05:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nKwredaM+Cs93jEyA/JViGM9vS7m/aU1tHpyX/pSvYY=;
        b=t9oYoUr13zdBBZIZKk6akY27SPdpRHFpNXH9IbEU2C/jvISuuCdEaha0ycNkYbtfEy
         dYBRa7NFl1c1QPH49l/2MBuH8RWc/E2vOD08o9As4stF7/ErB51+ybaAukDbtPlf/3Ly
         jTmEiRAPMoi+wVjUYu2Qw9AKbvAOHcrK9X5PuT/vHJPLtosxtTdrDnfNFLOt3FLyR7ws
         nV1PBXsBErKH4K0PYiXmHF8pdLympmGbWcpU9Z2eC1AK/oF+fUgiIpRRYQXAdlsC+vNV
         9bnfthWElo2fZ+BCUplQket5yiuRaoNuB3L8lisb26b7jujx7PKWA1j7FMm1OTCvFV5E
         jfwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nKwredaM+Cs93jEyA/JViGM9vS7m/aU1tHpyX/pSvYY=;
        b=J3C5SXH5OsFdcWEd1eRfA+PC+v9b2CSQGNfHof8EndD9TxdxxMibxSW3xylWCvaRT8
         YBrnKxG8J9fpb1Yb9YUqTUVB4o82iQFSww6Xa8aNC96gdLt0/qBaWFJXzALzQ0PVPSFk
         OitW4+e12rnCIbqKB2K/s0LKIxjtIplDFsbPWnlWe9reXz8OVwsWZxXsiDO277Tr+tQk
         /wBzWBpgIxOzs9uadIqzo0APDOXMlBBXipd75SkOvmcESVo+Eaecb9/DrSUvw96+vY1q
         E3n3rAM+C6/OGNM2i/oKL817xqiwSDVGiKCA7v3n8N1kBCFAVUschR6SzyC8Ld1Cvq7H
         wqdA==
X-Gm-Message-State: AOAM533ob4SHLEc7qMyhycHg/3JfA0DKIPYXUNL5yk7cm6uhGvjd1x2J
        57RIjeaxhCUJLJZU2SAZJjZl74qZY7c5aw==
X-Google-Smtp-Source: ABdhPJw/her3Spi1MEdPeMS9bSiW6UUmRoLavZWVBYyARLnVdWpke8YvC9DVIePVX5EyZ8ci69xqKA==
X-Received: by 2002:a19:844c:: with SMTP id g73mr11347772lfd.462.1608123909389;
        Wed, 16 Dec 2020 05:05:09 -0800 (PST)
Received: from [192.168.1.33] (88-114-222-21.elisa-laajakaista.fi. [88.114.222.21])
        by smtp.gmail.com with ESMTPSA id x2sm218439lff.207.2020.12.16.05.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 05:05:08 -0800 (PST)
Subject: Re: Antw: [EXT] Re: [systemd-devel] Creating executable device nodes
 in /dev?
To:     Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>, jarkko@kernel.org
Cc:     luto@amacapital.net, Ben Hutchings <ben@decadent.org.uk>,
        jethro@fortanix.com, bruce.schlobohm@intel.com,
        kai.svahn@intel.com, luto@kernel.org, haitao.huang@linux.intel.com,
        jarkko.sakkinen@linux.intel.com,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>, casey@schaufler-ca.com,
        sds@tycho.nsa.gov, linux-hotplug@vger.kernel.org,
        linux-sgx@vger.kernel.org
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
 <b1cf9503-0c1c-ab9e-3cc4-ef2b7611b280@gmail.com>
 <20201211104635.GD12091@kernel.org>
 <27796c04-249e-6cf0-c3e1-0fd657a82f9c@gmail.com>
 <5FD7137E020000A10003D81B@gwsmtp.uni-regensburg.de>
 <20201215041903.GA21875@kernel.org>
 <5FD9DB8D020000A10003D8DC@gwsmtp.uni-regensburg.de>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <815056f6-cb4b-0d48-ea2c-1cde97af45d4@gmail.com>
Date:   Wed, 16 Dec 2020 15:05:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <5FD9DB8D020000A10003D8DC@gwsmtp.uni-regensburg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 16.12.2020 12.03, Ulrich Windl wrote:
>>>> Jarkko Sakkinen <jarkko@kernel.org> schrieb am 15.12.2020 um 05:19 in
> Nachricht
> <20201215041903.GA21875@kernel.org>:
>> On Mon, Dec 14, 2020 at 08:25:50AM +0100, Ulrich Windl wrote:
>>>>>> Topi Miettinen <toiwoton@gmail.com> schrieb am 11.12.2020 um 12:46 in
>>> Nachricht
>>> <27796c04-249e-6cf0-c3e1-0fd657a82f9c@gmail.com>:
>>>> On 11.12.2020 12.46, Jarkko Sakkinen wrote:
>>>>> On Wed, Dec 09, 2020 at 10:35:21AM +0200, Topi Miettinen wrote:
>>>>>> On 9.12.2020 2.15, Jarkko Sakkinen wrote:
>>>>>>> On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
>>>>>>>>>>> As  a further argument, I just did this on a Fedora system:
>>>>>>>>>>> $ find /dev ‑perm /ugo+x ‑a \! ‑type d ‑a \! ‑type l
>>>>>>>>>>> No results.  So making /dev noexec doesn't seem to have any
> benefit.
>>>>>>>>>>
>>>>>>>>>> It's no surprise that there aren't any executables in /dev since
>>>>>>>>>> removing MAKEDEV ages ago. That's not the issue, which is that
>>>>>>>>>> /dev is a writable directory (for UID=0 but no capabilities are
>>>>>>>>>> needed) and thus a potential location for constructing unapproved
>>>>>>>>>> executables if it is also mounted exec (W^X).
>>>>>>>>>
>>>>>>>>> UID 0 can just change mount options, though, unless SELinux or
> similar
>>> is
>>>> used. And SELinux can protect /dev just fine without noexec.
>>>>>>>>
>>>>>>>> Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also
>>> SELinux
>>>>>>>> is not universal and the policies might not contain all users or
>>> services.
>>>>>>>>
>>>>>>>> ‑Topi
>>>>>>>
>>>>>>> What's the data that supports having noexec /dev anyway? With root
>>>>>>> access I can then just use something else like /dev/shm mount.
>>>>>>>
>>>>>>> Has there been out in the wild real world cases that noexec mount
>>>>>>> of would have prevented?
>>>>>>>
>>>>>>> For me this sounds a lot just something that "feels more secure"
>>>>>>> without any measurable benefit. Can you prove me wrong?
>>>>>>
>>>>>> I don't think security works that way. An attacker has various methods
> to
>>>>>> choose from, some are more interesting than others. The case where
>>> rw,exec
>>>>>> /dev would be interesting would imply that easier or more common
> avenues
>>>>>> would be blocked, for example rw,exec /dev/shm, /tmp, /var/tmp, or
>>>>>> /run/user/$UID/ for user. Also fileless malware with pure ROP/JOP
>>> approach
>>>>>> with no need for any file system access is getting more common. It
> does
>>> not
>>>>>> mean that it would not be prudent to block the relatively easy
> approaches
>>>>>> too, including /dev.
>>>>>
>>>>> What if we add a new mount option "chrexec", which allows exec
>>>>> for character devices (S_IFCHR).
>>>>
>>>> I think devices are a bad match for SGX because devices haven't been
>>>> executable and SGX is actually an operation for memory. So something
>>>> like memfd_create(, MFD_SGX) or mmap(,, PROT_READ|PROT_EXEC|PROT_SGX)
>>>> would be much more natural. Even better would be something that
>>>> conceptully also works for AMD version (either with the same flags or
>>>> MFD_SGX / MFD_whatever_the_AMD_version_is).
>>>
>>> +1
>>
>> SGX reserved memory from kernel's point of view is IO memory.
>>
>> Mapping SGX to memfd would not be a great idea, as it does not map
>> into concept of anonymous file backed by regular memory.
>>
>> A device file is very natural match actually. We have ioctl API for
>> uploading enclave pages during the build procedure to the enclave and
>> custom #PF handler. Conceptually it's a lot like video memory or such
>> special device specific memory area.
>>
>> There's no AMD equivalent of this technology.
> 
> Hi!
> 
> Back to "noexec": AFAIR the execute bit does not make sense for device files,
> and the purpose probably was to avoid execution of non-device files (e.g.
> regular executables) from inside /dev (where they should not be). So in this
> view "noexec" makes sense.
> There were similar arguments for not allowing device files in user
> directories.

PR#17940 (https://github.com/systemd/systemd/pull/17940) was merged, so 
/dev will now on be mounted with "exec" by systemd.

I made issue #17942 (https://github.com/systemd/systemd/issues/17942) to 
discuss related hardening options. I'm leaning towards 
NoExecPaths=/ExecPaths= as it would enable nice hardening by 
allow-listing of all executable content for system services with simple 
directives like:

[Service]
NoExecPaths=/
ExecPaths=/usr/sbin/daemon /lib64/ld-linux-x86-64.so.2 /usr/lib

Then a service infected with malware would not be able to execute a 
shell present in the system or downloaded later, if that was not 
explicitly allowed. /dev would also not have "exec" flag by default, but 
SGX could be allowed with "ExecPaths=/dev/sgx" when needed.

-Topi
