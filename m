Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35882C433FE
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 00:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 016B723A79
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 00:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgLIAEI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Dec 2020 19:04:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730769AbgLIAEH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Dec 2020 19:04:07 -0500
Date:   Wed, 9 Dec 2020 02:03:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607472206;
        bh=6ZtoiGbm9LTLDc88yn4VKW01doz9ouuyDAQaXV0/ShM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=ot+CjBOGH2ZDcSelwhl/klt+T+d/BhOJw/CQNROu7X0MVE8gMmRxB2i8HefOCPYNH
         L9pQRTJpMzqP0WKPQWEHQOdp6RDoWTpaqKIp33Wk2byx4sKB82VNaMGXgBpjepEOFa
         RRmZtTyacN+z84RqAjtmNyC+zfpRNYG+nNPEOgIqe1E+lDoRkkV3nzkP3pzwXSUlh+
         Xbp7NBMa+VSE2I8XY+yVlKATgeuN17UsH12gNLnAp4xw+RG5mJuA6wJdYIelww+5uJ
         CuxIl+0Kvoiel76y1Zf0oREc9YGwe2f2sL3IiKRayK9EXQvjuVM2dZh8UBzXHwGgp3
         UcjaWJQOAhxeg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
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
Subject: Re: Creating executable device nodes in /dev?
Message-ID: <20201209000321.GA62845@kernel.org>
References: <CALCETrWM2rGPRudtaQ=mn9MRsrbQqFfZDkOGsBbVMsk6mMw_+A@mail.gmail.com>
 <20201119163245.GN7348@in.waw.pl>
 <ff9aaf77-add3-dbeb-d05e-aedd93d41df0@gmail.com>
 <CALCETrW7JUquNf_KaA0UK9VEcswQZ+QMqFEQD_8G=c3JyH1xsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrW7JUquNf_KaA0UK9VEcswQZ+QMqFEQD_8G=c3JyH1xsQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 08, 2020 at 10:07:17AM -0800, Andy Lutomirski wrote:
> On Thu, Nov 19, 2020 at 10:05 AM Topi Miettinen <toiwoton@gmail.com> wrote:
> >
> > On 19.11.2020 18.32, Zbigniew Jędrzejewski-Szmek wrote:
> > > On Thu, Nov 19, 2020 at 08:17:08AM -0800, Andy Lutomirski wrote:
> > >> Hi udev people-
> > >>
> > >> The upcoming Linux SGX driver has a device node /dev/sgx.  User code
> > >> opens it, does various setup things, mmaps it, and needs to be able to
> > >> create PROT_EXEC mappings.  This gets quite awkward if /dev is mounted
> > >> noexec.
> > >>
> > >> Can udev arrange to make a device node executable on distros that make
> > >> /dev noexec?  This could be done by bind-mounting from an exec tmpfs.
> > >> Alternatively, the kernel could probably learn to ignore noexec on
> > >> /dev/sgx, but that seems a little bit evil.
> > >
> > > I'd be inclined to simply drop noexec from /dev by default.
> > > We don't do noexec on either /tmp or /dev/shm (because that causes immediate
> > > problems with stuff like Java and cffi). And if you have those two at your
> > > disposal anyway, having noexec on /dev doesn't seem important.
> >
> > I'd propose to not enable exec globally, but if a service needs SGX, it
> > could use something like MountOptions=/dev:exec only in those cases
> > where it's needed. That way it's possible to disallow writable and
> > executable file systems for most services (which typically don't need
> > /tmp or /dev/shm either). Of course the opposite
> > (MountOptions=/dev:noexec) would be also possible, but I'd expect that
> > this would be needed to be used more often.
> >
> 
> I imagine the opposite would be more sensible.  It seems odd to me
> that we would want any SGX-using service to require both special mount
> options and regular ACL permissions.
> 
> As  a further argument, I just did this on a Fedora system:
> 
> $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
> 
> No results.  So making /dev noexec doesn't seem to have any benefit.

Neither does my Ubuntu installation with '-xdev' added (because of
/dev/shm mount).

find /dev -xdev -perm /ugo+x -a \! -type d -a \! -type l

/Jarkko
