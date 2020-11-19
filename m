Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62444C6369E
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 18:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F269B21D46
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 18:05:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="foaNyn7N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgKSSFY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Nov 2020 13:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgKSSFY (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 19 Nov 2020 13:05:24 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89F8C0613CF;
        Thu, 19 Nov 2020 10:05:23 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id v20so7224079ljk.8;
        Thu, 19 Nov 2020 10:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/GNvPwktM5S1u2/q/efKSOD/rz5FbOmDcafj4vk5pi8=;
        b=foaNyn7NEOFV3vlJjaE5KACpoyhzmYFvXrifhCV21ZpBHf9ORmt4uXlvx6yI82sfW3
         yQ+FBcLabvYBsLeAS5Hbd/7WT4IE0TPGdLtD02A1+UYrU7wstZfyWSnmxBsBLXyLD3n9
         t+N+aS5OpUIKB/DRhCVqPUqQT6WY8BHZu7i6zO9NT6q18bO1h2LURFGOMaCBsc3KEFMK
         WXUOkuD20uiyFubHDchvw5BjVWlf1JypWOI1nwjACqBu1OSByNrG+6vEFAJJ+GOd8GLz
         CK9xve55nZWyMcyAaWJacGRKJSQ8L56WasDH/lvXHerIOOdNuWacQXsDRfUA3Juf1Cgz
         UhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/GNvPwktM5S1u2/q/efKSOD/rz5FbOmDcafj4vk5pi8=;
        b=QwSsBZI90QetLZgvkr8O0LCNc9Hg1Qbkrc389HbjAmVeAgUZU2X62BhzUdrKSzPYFk
         cTVb0jt+REXFm8vRwLAU09a+YEK5emVl8rgJab9StMa5tA+jiDaPvaKVav6nX//fNVPH
         RiOxFzmT0xujlTmxoC4GGNupZTN0nHTEiqWKnq5sw9vEegIsfjZVUX/V8eB52sdYQ2Q9
         B/bo4+X5b5ocMIczoy9YgANDSA3gCdvG5iUxlg3+DVsndw7xydaWvQO6ilxKUvd4hL7i
         jM1kc1h/lufyva1v1cYfj7KiUH/5jTt7c/aPACXALtO8SrNFcZDtkL1QoLqfpJNsApW+
         KYwQ==
X-Gm-Message-State: AOAM533cUr+BUdQh/rBm9uCEgPjEA72fXObfsy2w3w4teCrTmrqS+Ld4
        ce7y8yVKPqYr0UxYXGQAb/8=
X-Google-Smtp-Source: ABdhPJzOxLoP0uMr5dUDNTSVYQcRoNYJ0RzrH4vdsAlIQOW7D3l7T8kamNwwydc8KB2j0dB+7UG/8Q==
X-Received: by 2002:a2e:9654:: with SMTP id z20mr6867752ljh.267.1605809122418;
        Thu, 19 Nov 2020 10:05:22 -0800 (PST)
Received: from [192.168.1.112] (88-114-211-119.elisa-laajakaista.fi. [88.114.211.119])
        by smtp.gmail.com with ESMTPSA id i4sm38625lfl.131.2020.11.19.10.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 10:05:21 -0800 (PST)
Subject: Re: Creating executable device nodes in /dev?
To:     =?UTF-8?Q?Zbigniew_J=c4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-hotplug@vger.kernel.org,
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
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <ff9aaf77-add3-dbeb-d05e-aedd93d41df0@gmail.com>
Date:   Thu, 19 Nov 2020 20:05:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201119163245.GN7348@in.waw.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 19.11.2020 18.32, Zbigniew Jędrzejewski-Szmek wrote:
> On Thu, Nov 19, 2020 at 08:17:08AM -0800, Andy Lutomirski wrote:
>> Hi udev people-
>>
>> The upcoming Linux SGX driver has a device node /dev/sgx.  User code
>> opens it, does various setup things, mmaps it, and needs to be able to
>> create PROT_EXEC mappings.  This gets quite awkward if /dev is mounted
>> noexec.
>>
>> Can udev arrange to make a device node executable on distros that make
>> /dev noexec?  This could be done by bind-mounting from an exec tmpfs.
>> Alternatively, the kernel could probably learn to ignore noexec on
>> /dev/sgx, but that seems a little bit evil.
> 
> I'd be inclined to simply drop noexec from /dev by default.
> We don't do noexec on either /tmp or /dev/shm (because that causes immediate
> problems with stuff like Java and cffi). And if you have those two at your
> disposal anyway, having noexec on /dev doesn't seem important.

I'd propose to not enable exec globally, but if a service needs SGX, it 
could use something like MountOptions=/dev:exec only in those cases 
where it's needed. That way it's possible to disallow writable and 
executable file systems for most services (which typically don't need 
/tmp or /dev/shm either). Of course the opposite 
(MountOptions=/dev:noexec) would be also possible, but I'd expect that 
this would be needed to be used more often.

-Topi
