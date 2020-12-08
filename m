Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B11FC433FE
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Dec 2020 21:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE21B23B1A
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Dec 2020 21:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgLHVbQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbgLHVbM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 8 Dec 2020 16:31:12 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9911EC0613D6
        for <linux-sgx@vger.kernel.org>; Tue,  8 Dec 2020 13:30:32 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id t37so13402922pga.7
        for <linux-sgx@vger.kernel.org>; Tue, 08 Dec 2020 13:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=LfpQjkg2vv+Ujc0fflZIEhSpHS9r0ICiVMF8TQ1KaOU=;
        b=wDHYptGutSizOAvxDJMFk4/X0iWKuVti4RZumusWmJnaE1txuQ3o4VseZ5d7JgwcJc
         80vGetr9Lqe2cX326cU5zOA54vJtxGY48l0xegLns5Lx7G1PAB3X9+O6W+Qjr491YyKX
         9g8nx/gEpswHZWeD85G8NZevJN/LkrblB91YyL20qfe0TjhJAARb+tPnZ2igGRPkUCUb
         VgflPv6l5hcwcHQop2QmIUGkVWxJ93VlZMBiwlbvZRCGTyhdv690axkBOhl4IVserOhD
         HrG6LHsHVraaz0IwIeD2e35h5bKAZ3a9/GL2FmxMeeHtpEcHPPxSCNRV1ZNoaNj1ZJ5r
         4cuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=LfpQjkg2vv+Ujc0fflZIEhSpHS9r0ICiVMF8TQ1KaOU=;
        b=irjZmPDyiC/an2JB85+rYeeu/9r+Z8k0pymz9GvjQbn1ElOVNEUILPhyW5zY/PPp/C
         wMx1Wn/egUu5YcdARPklS4x3jdm5YfNgYelhyff1jQODkPL8nD8i/6Mfv2WW3vJ9rt3F
         FQF9VOOph7uyWJr9ZvttzR7zCFyj71mzIgCqTU4JVsgAnKGx//FFAT1b+fMZUE3HqpzL
         6zduLeqD4RN8ZRs4gUbvP6yiB5ymjJMQECaIK4ATnh1FWcFmmFW0t6rf/siFaZgZa7xC
         SnCQgwnpPioWypxQeuizwxGLpvA9A88+CD+cztOXZsPQnuuaX7pTyWZFWdBL9hLSNAdJ
         eSXw==
X-Gm-Message-State: AOAM533Jk3ZeUZJut3r0UzRM2q67h+V3SoxxQidpu6d+Bwvy7buH4Mcc
        JQU+bA3NqhNyuHviEPJSUZxZiw==
X-Google-Smtp-Source: ABdhPJyojDSo4snG6FhmGzYX41WptxNuRoKBIO2EI7a9PfRZcsz7nCzOw5LiBPxpyIP9MSM0ljDfcg==
X-Received: by 2002:a63:ad4a:: with SMTP id y10mr47914pgo.176.1607463032130;
        Tue, 08 Dec 2020 13:30:32 -0800 (PST)
Received: from ?IPv6:2600:1010:b020:7dd:51f8:22c8:74de:21e0? ([2600:1010:b020:7dd:51f8:22c8:74de:21e0])
        by smtp.gmail.com with ESMTPSA id a14sm94250pfl.141.2020.12.08.13.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:30:31 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: Creating executable device nodes in /dev?
Date:   Tue, 8 Dec 2020 13:30:30 -0800
Message-Id: <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        =?utf-8?Q?Zbigniew_J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
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
In-Reply-To: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
To:     Topi Miettinen <toiwoton@gmail.com>
X-Mailer: iPhone Mail (18B121)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Dec 8, 2020, at 12:45 PM, Topi Miettinen <toiwoton@gmail.com> wrote:
>=20
> =EF=BB=BFOn 8.12.2020 20.07, Andy Lutomirski wrote:
>>> On Thu, Nov 19, 2020 at 10:05 AM Topi Miettinen <toiwoton@gmail.com> wro=
te:
>>>=20
>>> On 19.11.2020 18.32, Zbigniew J=C4=99drzejewski-Szmek wrote:
>>>> On Thu, Nov 19, 2020 at 08:17:08AM -0800, Andy Lutomirski wrote:
>>>>> Hi udev people-
>>>>>=20
>>>>> The upcoming Linux SGX driver has a device node /dev/sgx.  User code
>>>>> opens it, does various setup things, mmaps it, and needs to be able to=

>>>>> create PROT_EXEC mappings.  This gets quite awkward if /dev is mounted=

>>>>> noexec.
>>>>>=20
>>>>> Can udev arrange to make a device node executable on distros that make=

>>>>> /dev noexec?  This could be done by bind-mounting from an exec tmpfs.
>>>>> Alternatively, the kernel could probably learn to ignore noexec on
>>>>> /dev/sgx, but that seems a little bit evil.
>>>>=20
>>>> I'd be inclined to simply drop noexec from /dev by default.
>>>> We don't do noexec on either /tmp or /dev/shm (because that causes imme=
diate
>>>> problems with stuff like Java and cffi). And if you have those two at y=
our
>>>> disposal anyway, having noexec on /dev doesn't seem important.
>>>=20
>>> I'd propose to not enable exec globally, but if a service needs SGX, it
>>> could use something like MountOptions=3D/dev:exec only in those cases
>>> where it's needed. That way it's possible to disallow writable and
>>> executable file systems for most services (which typically don't need
>>> /tmp or /dev/shm either). Of course the opposite
>>> (MountOptions=3D/dev:noexec) would be also possible, but I'd expect that=

>>> this would be needed to be used more often.
>>>=20
>> I imagine the opposite would be more sensible.  It seems odd to me
>> that we would want any SGX-using service to require both special mount
>> options and regular ACL permissions.
>=20
> How common are thes SGX-using services? Will every service start using it w=
ithout any special measures taken on it's behalf, or perhaps only a special S=
GX control tool needs access? What about unprivileged user applications, do t=
hey ever want to access SGX? Could something like Widevine deep in a browser=
 need to talk to SGX in a DRM scheme?

I honestly don=E2=80=99t know. Widevine is probably some unholy mess of SGX a=
nd ME crud. But regular user programs may well end up using SGX for little n=
on-evil enclaves, e.g. storing their keys securely.  It would be nice if unp=
rivileged enclaves just work as long as the use has appropriate permissions o=
n the device nodes.

SGX adoption has been severely hampered by the massive series of recent vuln=
erabilities and by Intel=E2=80=99s silly licensing scheme. The latter won=E2=
=80=99t be supported upstream.

>=20
>> As  a further argument, I just did this on a Fedora system:
>> $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
>> No results.  So making /dev noexec doesn't seem to have any benefit.
>=20
> It's no surprise that there aren't any executables in /dev since removing M=
AKEDEV ages ago. That's not the issue, which is that /dev is a writable dire=
ctory (for UID=3D0 but no capabilities are needed) and thus a potential loca=
tion for constructing unapproved executables if it is also mounted exec (W^X=
).

UID 0 can just change mount options, though, unless SELinux or similar is us=
ed. And SELinux can protect /dev just fine without noexec.

>=20
> -Topi
