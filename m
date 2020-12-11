Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12321C1B0D8
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 10:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D235B23F59
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 10:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393105AbgLKKr1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Dec 2020 05:47:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387586AbgLKKrX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Dec 2020 05:47:23 -0500
Date:   Fri, 11 Dec 2020 12:46:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607683602;
        bh=+KwaZekRWK0kX09eoMsxrBQ38hUp4MBnm0DUPziUaqA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=my1xqrFmiZPYM0tD4z053/WJmjZDXGxFbv1hURfZzS9tx+DuxBh+FULwGXl6+1fLW
         3ufa9/7/O1HgM4Bb1Pp/PJw2Zud5DLvQ3SYTqq2RCpvKR42vVDoUysFcJfRA4uLP7T
         AYBUqB7Jxdmjdbq5S4pTTfJ7HDCsH9kF9i1gOJKaSXfx3qup0yE47E0z5PqKI1XbRG
         ZfLx2ldkjO9dBCbq0RCtU8H7PJeJtzhWcGxaQK6Yvq4ClrpqE5YjN8LgasOaLGDZLD
         4mREx0BnogZKAR47rOCl109p5rBqIUwTY6IwUpc2nCi/jt+HGKbkPEYKGjCgo+q6SZ
         i9Ps9tiBGOAEg==
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
Message-ID: <20201211104635.GD12091@kernel.org>
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
 <b1cf9503-0c1c-ab9e-3cc4-ef2b7611b280@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1cf9503-0c1c-ab9e-3cc4-ef2b7611b280@gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 09, 2020 at 10:35:21AM +0200, Topi Miettinen wrote:
> On 9.12.2020 2.15, Jarkko Sakkinen wrote:
> > On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
> > > > > > As  a further argument, I just did this on a Fedora system:
> > > > > > $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
> > > > > > No results.  So making /dev noexec doesn't seem to have any benefit.
> > > > > 
> > > > > It's no surprise that there aren't any executables in /dev since
> > > > > removing MAKEDEV ages ago. That's not the issue, which is that
> > > > > /dev is a writable directory (for UID=0 but no capabilities are
> > > > > needed) and thus a potential location for constructing unapproved
> > > > > executables if it is also mounted exec (W^X).
> > > > 
> > > > UID 0 can just change mount options, though, unless SELinux or similar is used. And SELinux can protect /dev just fine without noexec.
> > > 
> > > Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also SELinux
> > > is not universal and the policies might not contain all users or services.
> > > 
> > > -Topi
> > 
> > What's the data that supports having noexec /dev anyway? With root
> > access I can then just use something else like /dev/shm mount.
> > 
> > Has there been out in the wild real world cases that noexec mount
> > of would have prevented?
> > 
> > For me this sounds a lot just something that "feels more secure"
> > without any measurable benefit. Can you prove me wrong?
> 
> I don't think security works that way. An attacker has various methods to
> choose from, some are more interesting than others. The case where rw,exec
> /dev would be interesting would imply that easier or more common avenues
> would be blocked, for example rw,exec /dev/shm, /tmp, /var/tmp, or
> /run/user/$UID/ for user. Also fileless malware with pure ROP/JOP approach
> with no need for any file system access is getting more common. It does not
> mean that it would not be prudent to block the relatively easy approaches
> too, including /dev.

What if we add a new mount option "chrexec", which allows exec
for character devices (S_IFCHR).

> -Topi


/Jarkko
