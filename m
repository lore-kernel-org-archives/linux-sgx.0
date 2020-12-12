Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FD8C433FE
	for <linux-sgx@archiver.kernel.org>; Sat, 12 Dec 2020 11:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7CEC22CF8
	for <linux-sgx@archiver.kernel.org>; Sat, 12 Dec 2020 11:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438784AbgLLLwc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 12 Dec 2020 06:52:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54768 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438731AbgLLLwc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 12 Dec 2020 06:52:32 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1ko3R6-00045D-6m; Sat, 12 Dec 2020 11:51:40 +0000
Date:   Sat, 12 Dec 2020 12:51:39 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Greg KH <greg@kroah.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-hotplug@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, linux-sgx@vger.kernel.org
Subject: Re: [systemd-devel] Creating executable device nodes in /dev?
Message-ID: <20201212115139.tnelg2oys24a7xy2@wittgenstein>
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
 <b1cf9503-0c1c-ab9e-3cc4-ef2b7611b280@gmail.com>
 <20201211104635.GD12091@kernel.org>
 <X9NYG1+ke6nPwBvO@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X9NYG1+ke6nPwBvO@kroah.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 11, 2020 at 12:29:31PM +0100, Greg KH wrote:
> On Fri, Dec 11, 2020 at 12:46:35PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Dec 09, 2020 at 10:35:21AM +0200, Topi Miettinen wrote:
> > > On 9.12.2020 2.15, Jarkko Sakkinen wrote:
> > > > On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
> > > > > > > > As  a further argument, I just did this on a Fedora system:
> > > > > > > > $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
> > > > > > > > No results.  So making /dev noexec doesn't seem to have any benefit.
> > > > > > > 
> > > > > > > It's no surprise that there aren't any executables in /dev since
> > > > > > > removing MAKEDEV ages ago. That's not the issue, which is that
> > > > > > > /dev is a writable directory (for UID=0 but no capabilities are
> > > > > > > needed) and thus a potential location for constructing unapproved
> > > > > > > executables if it is also mounted exec (W^X).
> > > > > > 
> > > > > > UID 0 can just change mount options, though, unless SELinux or similar is used. And SELinux can protect /dev just fine without noexec.
> > > > > 
> > > > > Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also SELinux
> > > > > is not universal and the policies might not contain all users or services.
> > > > > 
> > > > > -Topi
> > > > 
> > > > What's the data that supports having noexec /dev anyway? With root
> > > > access I can then just use something else like /dev/shm mount.
> > > > 
> > > > Has there been out in the wild real world cases that noexec mount
> > > > of would have prevented?
> > > > 
> > > > For me this sounds a lot just something that "feels more secure"
> > > > without any measurable benefit. Can you prove me wrong?
> > > 
> > > I don't think security works that way. An attacker has various methods to
> > > choose from, some are more interesting than others. The case where rw,exec
> > > /dev would be interesting would imply that easier or more common avenues
> > > would be blocked, for example rw,exec /dev/shm, /tmp, /var/tmp, or
> > > /run/user/$UID/ for user. Also fileless malware with pure ROP/JOP approach
> > > with no need for any file system access is getting more common. It does not
> > > mean that it would not be prudent to block the relatively easy approaches
> > > too, including /dev.
> > 
> > What if we add a new mount option "chrexec", which allows exec
> > for character devices (S_IFCHR).
> 
> Oh please no.

Greg's right. That's very obviously a horrible hack so this is an
instant nak from my side.

Christian
