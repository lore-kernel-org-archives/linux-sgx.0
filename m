Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0977FC433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Dec 2020 22:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B59CD22D57
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Dec 2020 22:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgLVWPZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Dec 2020 17:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgLVWPZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Dec 2020 17:15:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40CBD22D57;
        Tue, 22 Dec 2020 22:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608675284;
        bh=U1cDDpRsU3GSWvcivFvBi8wr8M8Q1Dj/xFD9f8xNBHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=abkVVJzfV+kr8TlaorVnSnB3sS69mcauzs3UTL9RX+vHJw1YIoe8UNbSNEX0cW1vU
         0Hx1NlYi1lK7XzA/7XHKGrflSvFJDwQAXGUPKRIzz7zl6qGmlTGWzw/Vgw20HwNxIL
         OOkhSLfbrNymVHbFgdRouwHrcQdGgpH7t20cVhwjCedRWpX6TXdc8m0dUklFmlNMIX
         loqTxD+vxYSaHSDeINEy+KCi/7QrSNMGQjpJmBQWHDUFCDIDNGjDtMZcleoGbE/2g3
         8vQRf0kU7z72yRNA0AWjVC5mzbn7PHrb/Mdqglou/shWUPLR0IYmR1sIwiGiItakkv
         UQEtrVq96NhFw==
Date:   Wed, 23 Dec 2020 00:14:37 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        luto@amacapital.net, Ben Hutchings <ben@decadent.org.uk>,
        jethro@fortanix.com, bruce.schlobohm@intel.com,
        kai.svahn@intel.com, luto@kernel.org, haitao.huang@linux.intel.com,
        jarkko.sakkinen@linux.intel.com,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>, casey@schaufler-ca.com,
        sds@tycho.nsa.gov, linux-hotplug@vger.kernel.org,
        linux-sgx@vger.kernel.org
Subject: Re: Antw: [EXT] Re: [systemd-devel] Creating executable device nodes
 in /dev?
Message-ID: <20201222221437.GA13357@kernel.org>
References: <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
 <b1cf9503-0c1c-ab9e-3cc4-ef2b7611b280@gmail.com>
 <20201211104635.GD12091@kernel.org>
 <27796c04-249e-6cf0-c3e1-0fd657a82f9c@gmail.com>
 <5FD7137E020000A10003D81B@gwsmtp.uni-regensburg.de>
 <20201215041903.GA21875@kernel.org>
 <5FD9DB8D020000A10003D8DC@gwsmtp.uni-regensburg.de>
 <815056f6-cb4b-0d48-ea2c-1cde97af45d4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <815056f6-cb4b-0d48-ea2c-1cde97af45d4@gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 16, 2020 at 03:05:05PM +0200, Topi Miettinen wrote:
> On 16.12.2020 12.03, Ulrich Windl wrote:
> > > > > Jarkko Sakkinen <jarkko@kernel.org> schrieb am 15.12.2020 um 05:19 in
> > Nachricht
> > <20201215041903.GA21875@kernel.org>:
> > > On Mon, Dec 14, 2020 at 08:25:50AM +0100, Ulrich Windl wrote:
> > > > > > > Topi Miettinen <toiwoton@gmail.com> schrieb am 11.12.2020 um 12:46 in
> > > > Nachricht
> > > > <27796c04-249e-6cf0-c3e1-0fd657a82f9c@gmail.com>:
> > > > > On 11.12.2020 12.46, Jarkko Sakkinen wrote:
> > > > > > On Wed, Dec 09, 2020 at 10:35:21AM +0200, Topi Miettinen wrote:
> > > > > > > On 9.12.2020 2.15, Jarkko Sakkinen wrote:
> > > > > > > > On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
> > > > > > > > > > > > As  a further argument, I just did this on a Fedora system:
> > > > > > > > > > > > $ find /dev ‑perm /ugo+x ‑a \! ‑type d ‑a \! ‑type l
> > > > > > > > > > > > No results.  So making /dev noexec doesn't seem to have any
> > benefit.
> > > > > > > > > > > 
> > > > > > > > > > > It's no surprise that there aren't any executables in /dev since
> > > > > > > > > > > removing MAKEDEV ages ago. That's not the issue, which is that
> > > > > > > > > > > /dev is a writable directory (for UID=0 but no capabilities are
> > > > > > > > > > > needed) and thus a potential location for constructing unapproved
> > > > > > > > > > > executables if it is also mounted exec (W^X).
> > > > > > > > > > 
> > > > > > > > > > UID 0 can just change mount options, though, unless SELinux or
> > similar
> > > > is
> > > > > used. And SELinux can protect /dev just fine without noexec.
> > > > > > > > > 
> > > > > > > > > Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also
> > > > SELinux
> > > > > > > > > is not universal and the policies might not contain all users or
> > > > services.
> > > > > > > > > 
> > > > > > > > > ‑Topi
> > > > > > > > 
> > > > > > > > What's the data that supports having noexec /dev anyway? With root
> > > > > > > > access I can then just use something else like /dev/shm mount.
> > > > > > > > 
> > > > > > > > Has there been out in the wild real world cases that noexec mount
> > > > > > > > of would have prevented?
> > > > > > > > 
> > > > > > > > For me this sounds a lot just something that "feels more secure"
> > > > > > > > without any measurable benefit. Can you prove me wrong?
> > > > > > > 
> > > > > > > I don't think security works that way. An attacker has various methods
> > to
> > > > > > > choose from, some are more interesting than others. The case where
> > > > rw,exec
> > > > > > > /dev would be interesting would imply that easier or more common
> > avenues
> > > > > > > would be blocked, for example rw,exec /dev/shm, /tmp, /var/tmp, or
> > > > > > > /run/user/$UID/ for user. Also fileless malware with pure ROP/JOP
> > > > approach
> > > > > > > with no need for any file system access is getting more common. It
> > does
> > > > not
> > > > > > > mean that it would not be prudent to block the relatively easy
> > approaches
> > > > > > > too, including /dev.
> > > > > > 
> > > > > > What if we add a new mount option "chrexec", which allows exec
> > > > > > for character devices (S_IFCHR).
> > > > > 
> > > > > I think devices are a bad match for SGX because devices haven't been
> > > > > executable and SGX is actually an operation for memory. So something
> > > > > like memfd_create(, MFD_SGX) or mmap(,, PROT_READ|PROT_EXEC|PROT_SGX)
> > > > > would be much more natural. Even better would be something that
> > > > > conceptully also works for AMD version (either with the same flags or
> > > > > MFD_SGX / MFD_whatever_the_AMD_version_is).
> > > > 
> > > > +1
> > > 
> > > SGX reserved memory from kernel's point of view is IO memory.
> > > 
> > > Mapping SGX to memfd would not be a great idea, as it does not map
> > > into concept of anonymous file backed by regular memory.
> > > 
> > > A device file is very natural match actually. We have ioctl API for
> > > uploading enclave pages during the build procedure to the enclave and
> > > custom #PF handler. Conceptually it's a lot like video memory or such
> > > special device specific memory area.
> > > 
> > > There's no AMD equivalent of this technology.
> > 
> > Hi!
> > 
> > Back to "noexec": AFAIR the execute bit does not make sense for device files,
> > and the purpose probably was to avoid execution of non-device files (e.g.
> > regular executables) from inside /dev (where they should not be). So in this
> > view "noexec" makes sense.
> > There were similar arguments for not allowing device files in user
> > directories.
> 
> PR#17940 (https://github.com/systemd/systemd/pull/17940) was merged, so /dev
> will now on be mounted with "exec" by systemd.
> 
> I made issue #17942 (https://github.com/systemd/systemd/issues/17942) to
> discuss related hardening options. I'm leaning towards
> NoExecPaths=/ExecPaths= as it would enable nice hardening by allow-listing
> of all executable content for system services with simple directives like:
> 
> [Service]
> NoExecPaths=/
> ExecPaths=/usr/sbin/daemon /lib64/ld-linux-x86-64.so.2 /usr/lib
> 
> Then a service infected with malware would not be able to execute a shell
> present in the system or downloaded later, if that was not explicitly
> allowed. /dev would also not have "exec" flag by default, but SGX could be
> allowed with "ExecPaths=/dev/sgx" when needed.

OK, this sounds relieving, thank you (late resp, I was vacation last
week).


> -Topi


/Jarkko
