Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4006C4361B
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 00:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C2723B7F
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 00:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgLIAQK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Dec 2020 19:16:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730815AbgLIAQI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Dec 2020 19:16:08 -0500
Date:   Wed, 9 Dec 2020 02:15:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607472927;
        bh=j6WciaYJSxFop1XjtpqdiDWZepE71ebSKm7Oexe8ZU4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=on9EdAShKMtTxcQgLmb3NGsl84E64a41+JRkrOKkpIj4ZLNbp1EX8rIWWcNJa8hsq
         f3mlNJFzJF44/OYmBiaWFygq6Cf8kWbbGhBElaUSjxzXtxnhbCazsMT5knvFGSEmtu
         JBllY49lYwOZnWpF1+dwtflZrxYNwqo2rFcH3EBuAZo2cfk36hhRTR7Vg30bo4LRDT
         De64eaWlCaFx0vI3grIvMnQOaC5iPA54Hnig+qVdhtlxg0y40cWd6GF4OTh9/CqyRV
         nfCKWktq+eHcq14QpWZgNTyuyh3d6Y4w0xV44gQng2QiXexsy0Tyxq+g6o73//GF11
         eiOUZ5y/bo3Fg==
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
Message-ID: <20201209001521.GA64007@kernel.org>
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
> > > > As  a further argument, I just did this on a Fedora system:
> > > > $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
> > > > No results.  So making /dev noexec doesn't seem to have any benefit.
> > > 
> > > It's no surprise that there aren't any executables in /dev since
> > > removing MAKEDEV ages ago. That's not the issue, which is that
> > > /dev is a writable directory (for UID=0 but no capabilities are
> > > needed) and thus a potential location for constructing unapproved
> > > executables if it is also mounted exec (W^X).
> > 
> > UID 0 can just change mount options, though, unless SELinux or similar is used. And SELinux can protect /dev just fine without noexec.
> 
> Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also SELinux
> is not universal and the policies might not contain all users or services.
> 
> -Topi

What's the data that supports having noexec /dev anyway? With root
access I can then just use something else like /dev/shm mount.

Has there been out in the wild real world cases that noexec mount
of would have prevented?

For me this sounds a lot just something that "feels more secure"
without any measurable benefit. Can you prove me wrong?

/Jarkko
