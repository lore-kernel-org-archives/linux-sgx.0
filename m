Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DCEC4361B
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 00:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD5523B4B
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 00:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbgLIAnB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Dec 2020 19:43:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgLIAnB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Dec 2020 19:43:01 -0500
Date:   Wed, 9 Dec 2020 02:42:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607474540;
        bh=LEUPxZ62A/A6xW0kmG0h2CHvA9/k20Dc35s/xNn/Ev4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=X4uz7dVCO+6V6ykdH1BpZuEzp2bNK5mYohiAJZ/7hfG30LJNviPbLEh8We3DA6DEU
         lcvbcA2j3eJLHqMWPXVkL9ZZLzE7ddx+UgoVKMekfVABb7tVJ6gIHxGCtOClR/oiIa
         2Fz3rt++jN8ZVEA3BZIBoHYU4bzLE44dsU+aeFJnsvcDjXbsMiE/zbMdslujSknAYf
         b6lrxyf6zFe4BuxV6TYbVvje6NXKDhNPdttX2sJioKN2C6rGgnByWrT1CjMge33KWJ
         K9nI0/9wQA4UYZXK30ngbIc9SYH9uf4mAwb5oeDh9PlpqcdHdvgG3pN6PHraV0P5Qu
         x4J7SK5mkDilg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
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
Message-ID: <20201209004214.GA64820@kernel.org>
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209001521.GA64007@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 09, 2020 at 02:15:28AM +0200, Jarkko Sakkinen wrote:
> On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
> > > > > As  a further argument, I just did this on a Fedora system:
> > > > > $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
> > > > > No results.  So making /dev noexec doesn't seem to have any benefit.
> > > > 
> > > > It's no surprise that there aren't any executables in /dev since
> > > > removing MAKEDEV ages ago. That's not the issue, which is that
> > > > /dev is a writable directory (for UID=0 but no capabilities are
> > > > needed) and thus a potential location for constructing unapproved
> > > > executables if it is also mounted exec (W^X).
> > > 
> > > UID 0 can just change mount options, though, unless SELinux or similar is used. And SELinux can protect /dev just fine without noexec.
> > 
> > Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also SELinux
> > is not universal and the policies might not contain all users or services.
> > 
> > -Topi
> 
> What's the data that supports having noexec /dev anyway? With root
> access I can then just use something else like /dev/shm mount.
> 
> Has there been out in the wild real world cases that noexec mount
> of would have prevented?

Typo: "of" = "of /dev"

> For me this sounds a lot just something that "feels more secure"
> without any measurable benefit. Can you prove me wrong?

The debate is circled around something not well defined. Of course you
get theoretically more safe system when you decrease priviliges anywhere
in the system. Like you could start do grazy things with stuff that
unprivilged user has access, in order to prevent malware to elevate to
UID 0 in the first place.

I think where this go intellectually wrong is that we are talking about
*default installation* of a distribution. That should have somewhat sane
common sense access control settings. For like a normal desktop user
noexec /dev will not do any possible favor.

Then there is the case when you want to harden installation for an
application, let's' say some server. In that case you will anyway
fine-tune the security settings and go grazy enough with hardening.
When you tailor a server, it's a standard practice to enumerate and
adjust the mount points if needed.

To summarize, I neither understand the intended target audience.

/Jarkko
