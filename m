Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89EDC433FE
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 15:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 733B423AAC
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 15:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgLIPP3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Dec 2020 10:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbgLIPP3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Dec 2020 10:15:29 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0D9C061793
        for <linux-sgx@vger.kernel.org>; Wed,  9 Dec 2020 07:14:48 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id c12so886675pgm.4
        for <linux-sgx@vger.kernel.org>; Wed, 09 Dec 2020 07:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=C1+c1vIp5jvgTJl3OWJaJALJ2mWly8LkzYzyK8Hkh0g=;
        b=xhXUYSZja8mEnNjoHOU4lpE2EnFiB+gMJxWBSi/OLuMbP2HU2EEY3YCtIlq9My2kqo
         wtcvuHIL92chhndfhcF2pdb1hEt4i7lGn/dGx3YK4eW+WNv3A/pPFVL0WJI/BtOm4j3j
         IffJ2Yr0roy63ZN41JXH0qd8reKOhB76qK8gmDgwK7NQWq+UYP6px4ausloyTMiDoM2S
         V86XDOQYKk0+kaO6Xb2C4CcMr9cbsmgTcMi0pmpe5tBh+zlNNAeslGAznRoQbWWBOJJ+
         d4Wf3t25Um5K/huqqtmF7fF67ebBPSGPZfN9hjxHgqDgK5rodm4ZwOQCKw9UXoRujAFo
         E7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=C1+c1vIp5jvgTJl3OWJaJALJ2mWly8LkzYzyK8Hkh0g=;
        b=GYnsVGJ2yRr/6N31zunYpr3A6JZl7UEA0Gn8tPp1pfY5rXr7ZwHPIblfJ+MLXTX7sC
         QFrLxBRImfh1Xl4E+duwKpvpAX/9UcOyuSPytEY8ESgvtpl/jvEI7OlDT2eMt3x+Vqc+
         i08Zba4kUq5raC6XMXnHJbF86lXb64GS++5HsEAbBYOzYkQwTJEQDEiM3MB4R0/icS+L
         NYjtjmeeKl5eAzXELWMegByhaTOliylGBFIZ5Gglm+RSqoCOxVui41vlM3KuwTxOVRnj
         9kMODU83DLa8yKTFs3nnhDUEWvud4q0vd0g3k9ledpXLqR1Ow6/dwkQBMbBTTVFXrU3R
         UOZQ==
X-Gm-Message-State: AOAM532DqjlkAsm4K1fuoFJqnHnqRSEqx+V21nuGodKr0Dvi/iTo5Fue
        D/fm3PM8cba55CVx6gQo2QapKNOV8MBJjA==
X-Google-Smtp-Source: ABdhPJx8Yd6NHNWsDhWHvK4zVsBjD5LjZ9Y8uVJTtdAbEMidsXr4TSFCLCcy22uw4hqGk5+4CGkw6g==
X-Received: by 2002:a63:26c3:: with SMTP id m186mr2365172pgm.209.1607526888388;
        Wed, 09 Dec 2020 07:14:48 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:545f:980e:8061:8113? ([2601:646:c200:1ef2:545f:980e:8061:8113])
        by smtp.gmail.com with ESMTPSA id j20sm2974802pfd.106.2020.12.09.07.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 07:14:47 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: Creating executable device nodes in /dev?
Date:   Wed, 9 Dec 2020 07:14:45 -0800
Message-Id: <308AE66A-F401-4D2D-9D53-17E11EAF68E3@amacapital.net>
References: <f2279f2d-f0a6-a948-9691-96f47a0bd997@gmail.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
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
In-Reply-To: <f2279f2d-f0a6-a948-9691-96f47a0bd997@gmail.com>
To:     Topi Miettinen <toiwoton@gmail.com>
X-Mailer: iPhone Mail (18B121)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Dec 9, 2020, at 12:58 AM, Topi Miettinen <toiwoton@gmail.com> wrote:
>=20
> =EF=BB=BFOn 9.12.2020 2.42, Jarkko Sakkinen wrote:
>>> On Wed, Dec 09, 2020 at 02:15:28AM +0200, Jarkko Sakkinen wrote:
>>> On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
>>>>>>> As  a further argument, I just did this on a Fedora system:
>>>>>>> $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
>>>>>>> No results.  So making /dev noexec doesn't seem to have any benefit.=

>>>>>>=20
>>>>>> It's no surprise that there aren't any executables in /dev since
>>>>>> removing MAKEDEV ages ago. That's not the issue, which is that
>>>>>> /dev is a writable directory (for UID=3D0 but no capabilities are
>>>>>> needed) and thus a potential location for constructing unapproved
>>>>>> executables if it is also mounted exec (W^X).
>>>>>=20
>>>>> UID 0 can just change mount options, though, unless SELinux or similar=
 is used. And SELinux can protect /dev just fine without noexec.
>>>>=20
>>>> Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also SELi=
nux
>>>> is not universal and the policies might not contain all users or servic=
es.
>>>>=20
>>>> -Topi
>>>=20
>>> What's the data that supports having noexec /dev anyway? With root
>>> access I can then just use something else like /dev/shm mount.
>>>=20
>>> Has there been out in the wild real world cases that noexec mount
>>> of would have prevented?
>> Typo: "of" =3D "of /dev"
>>> For me this sounds a lot just something that "feels more secure"
>>> without any measurable benefit. Can you prove me wrong?
>> The debate is circled around something not well defined. Of course you
>> get theoretically more safe system when you decrease priviliges anywhere
>> in the system. Like you could start do grazy things with stuff that
>> unprivilged user has access, in order to prevent malware to elevate to
>> UID 0 in the first place.
>> I think where this go intellectually wrong is that we are talking about
>> *default installation* of a distribution. That should have somewhat sane
>> common sense access control settings. For like a normal desktop user
>> noexec /dev will not do any possible favor.
>> Then there is the case when you want to harden installation for an
>> application, let's' say some server. In that case you will anyway
>> fine-tune the security settings and go grazy enough with hardening.
>> When you tailor a server, it's a standard practice to enumerate and
>> adjust the mount points if needed.
>=20
> I think we agree that there's a need for either way to allow SGX (if defau=
lt is hardened) or a hardening option (in the opposite case). For systemd I s=
ee two approaches:
>=20
> 1. Default noexec /dev, override with something like
> - ExecPaths=3D/dev
> - MountOptions=3D/dev:rw,exec,dev,nosuid
> - or even MountOptions=3D/dev/sgx:rw,exec,dev,nosuid
> - ProtectDev=3Dno
> - AllowSGX=3Dyes
>=20
> 2. Default exec /dev, override with
> - NoExecPaths=3D/dev
> - MountOptions=3D/dev:rw,noexec,dev,nosuid
> - ProtectDev=3Dyes
> - DenySGX=3Dyes
>=20
> I'd prefer 1. but of course 2. would be reasonable.

I would argue for 2, for the following reason.  I absolutely agree that hard=
ening a system by making it impossible to create executable code dynamically=
 is valuable, but I don=E2=80=99t think it=E2=80=99s a good default. By defa=
ult, programs like gcc and clang should work, but so should JITs, and JITs a=
re getting more popular and powerful all the time.  In a default setting tha=
t allows JITs, etc, I see no benefit at all to making /dev noexec. To the co=
ntrary, making /dev noexec seems like plugging a little restricted corner of=
 code creation (because it requires UID=3D0) while allowing the easy ways (/=
tmp, /home, /dev/shm, unshare(2), mmap(), etc).  By all means let admins har=
den this, but I see no reason to apply some of the hardening when the rest i=
s disabled.

>=20
>> To summarize, I neither understand the intended target audience.
>=20
> We have something in common: me neither. What's the target audience for SG=
X? What's the use case? What are the users: browsers, system services? How w=
ould applications use SGX? Should udev rules for /dev/sgx make it available t=
o any logged in users with uaccess tags?
>=20
>=20

I would certainly like it to be available to all software, with the possible=
 exception of extra-hardened systems. Using SGX is not really an interesting=
 attack surface. The main threat is that malware might use SGX to make itsel=
f hard to reverse engineer.

In Intel=E2=80=99s original vision, only specially licensed vendors could cr=
eate SGX software, but Linux pushed back against this quite hard, and new CP=
Us allow unlicensed enclaves. So your Skylake CPUs support SGX, but not on L=
inux.=
