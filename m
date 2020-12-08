Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511C1C4167B
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Dec 2020 18:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20EF523B54
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Dec 2020 18:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730483AbgLHSIM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Dec 2020 13:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730478AbgLHSIL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Dec 2020 13:08:11 -0500
X-Gm-Message-State: AOAM533nmI5kiKxPyXUZCb0BuzVO/orj8Ccma+VnsiEZoLlfEv98bGNn
        m35FKw7Va0hhnuEVGu7mfDE6LQ39nO7qsFBzRYi79w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607450850;
        bh=4osZf7NwU07dI7yIIEvMpmBjVnDI5oX+mUICtMLoKzU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CMWEYeVvhWszYfb/mcCngvvX4PQvY6sARvLqjAlkMuwP/1W6PRcsm/LTsQCb/hHCe
         Zq70gw+w6P0MXEzHKoOJRZC4MWGjGCmORavJq5+y0BB4TG5GSgcHGlNgVa8K3p8T3p
         fFrGxjHqb4/Ri1xbs7GhhJX5jqm5BmrRXeOoa0VRV6frHsVqO90naG17s8U+tcdzFE
         YYJsEEDbs5ZU1GFAz9QpVrNIFT+WqkpPO5hh3iEk0G6Yb1Da2cBojxBFwNua9XHeEO
         3E/PCGeJPlVB77a8ef6T1iZTfC2L/igHeq4kSwmcJevjzoARQ4qLraX3I1igY9Kp4F
         gNYsQXnyzofiw==
X-Google-Smtp-Source: ABdhPJwxD7GbV/03fC8+VZhyA4LQFTPIikKejyYSIwxW4WNiqGrAhevsJEWEXPqLqk571OEkDq3sWAyMwmwwerduDfc=
X-Received: by 2002:a1c:630b:: with SMTP id x11mr4918938wmb.138.1607450849122;
 Tue, 08 Dec 2020 10:07:29 -0800 (PST)
MIME-Version: 1.0
References: <CALCETrWM2rGPRudtaQ=mn9MRsrbQqFfZDkOGsBbVMsk6mMw_+A@mail.gmail.com>
 <20201119163245.GN7348@in.waw.pl> <ff9aaf77-add3-dbeb-d05e-aedd93d41df0@gmail.com>
In-Reply-To: <ff9aaf77-add3-dbeb-d05e-aedd93d41df0@gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 8 Dec 2020 10:07:17 -0800
X-Gmail-Original-Message-ID: <CALCETrW7JUquNf_KaA0UK9VEcswQZ+QMqFEQD_8G=c3JyH1xsQ@mail.gmail.com>
Message-ID: <CALCETrW7JUquNf_KaA0UK9VEcswQZ+QMqFEQD_8G=c3JyH1xsQ@mail.gmail.com>
Subject: Re: Creating executable device nodes in /dev?
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     =?UTF-8?Q?Zbigniew_J=C4=99drzejewski=2DSzmek?= <zbyszek@in.waw.pl>,
        Andy Lutomirski <luto@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 19, 2020 at 10:05 AM Topi Miettinen <toiwoton@gmail.com> wrote:
>
> On 19.11.2020 18.32, Zbigniew J=C4=99drzejewski-Szmek wrote:
> > On Thu, Nov 19, 2020 at 08:17:08AM -0800, Andy Lutomirski wrote:
> >> Hi udev people-
> >>
> >> The upcoming Linux SGX driver has a device node /dev/sgx.  User code
> >> opens it, does various setup things, mmaps it, and needs to be able to
> >> create PROT_EXEC mappings.  This gets quite awkward if /dev is mounted
> >> noexec.
> >>
> >> Can udev arrange to make a device node executable on distros that make
> >> /dev noexec?  This could be done by bind-mounting from an exec tmpfs.
> >> Alternatively, the kernel could probably learn to ignore noexec on
> >> /dev/sgx, but that seems a little bit evil.
> >
> > I'd be inclined to simply drop noexec from /dev by default.
> > We don't do noexec on either /tmp or /dev/shm (because that causes imme=
diate
> > problems with stuff like Java and cffi). And if you have those two at y=
our
> > disposal anyway, having noexec on /dev doesn't seem important.
>
> I'd propose to not enable exec globally, but if a service needs SGX, it
> could use something like MountOptions=3D/dev:exec only in those cases
> where it's needed. That way it's possible to disallow writable and
> executable file systems for most services (which typically don't need
> /tmp or /dev/shm either). Of course the opposite
> (MountOptions=3D/dev:noexec) would be also possible, but I'd expect that
> this would be needed to be used more often.
>

I imagine the opposite would be more sensible.  It seems odd to me
that we would want any SGX-using service to require both special mount
options and regular ACL permissions.

As  a further argument, I just did this on a Fedora system:

$ find /dev -perm /ugo+x -a \! -type d -a \! -type l

No results.  So making /dev noexec doesn't seem to have any benefit.
