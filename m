Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B75C4361B
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 04:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61CA72073C
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 04:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgLOE2R (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Dec 2020 23:28:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgLOE2I (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Dec 2020 23:28:08 -0500
Date:   Tue, 15 Dec 2020 06:27:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608006445;
        bh=2s/8/NZ46KXadcfTblsrfGQ7prr2OPLEfK8cAWsiAfs=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=bXfpVKnlhdsdjRLRYViug7B+H9HWzWgSieBqjr0vFkvrMSJ/1zMhEuHGpy/KgI5RE
         7STwGAy2VoaviaSbVi9r2PBY3I+Or4oKvj6Q5VTVm1eOdk8obsS4kwQKh2M6r+KPVN
         GOu5TwgCmwY/QbFiP7G+/JRvuLhvFhFo1sQ8d8Dk0rYQ8waswJwOL1x3a6UC4ifszP
         xtmhGhtrH+s3nkf6sIoMGtYq6PnvDhAoZTy3JIXXtKX4ZIGtjBXxjDgOli8y+97IYD
         hz+SkbfjTcChIyHzNHDFGAS6SBVELH8Tf6Ev604wlSMVa8le17WHFNUU2t6ED/bzPQ
         DTNk12Nbjds/w==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc:     toiwoton@gmail.com, luto@amacapital.net,
        Ben Hutchings <ben@decadent.org.uk>, jethro@fortanix.com,
        bruce.schlobohm@intel.com, kai.svahn@intel.com, luto@kernel.org,
        haitao.huang@linux.intel.com, jarkko.sakkinen@linux.intel.com,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>, casey@schaufler-ca.com,
        sds@tycho.nsa.gov, linux-hotplug@vger.kernel.org,
        linux-sgx@vger.kernel.org
Subject: Re: Antw: [EXT] Re: [systemd-devel] Creating executable device nodes
 in /dev?
Message-ID: <20201215042719.GA23937@kernel.org>
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
 <b1cf9503-0c1c-ab9e-3cc4-ef2b7611b280@gmail.com>
 <20201211104635.GD12091@kernel.org>
 <27796c04-249e-6cf0-c3e1-0fd657a82f9c@gmail.com>
 <5FD7137E020000A10003D81B@gwsmtp.uni-regensburg.de>
 <20201215041903.GA21875@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201215041903.GA21875@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 15, 2020 at 06:19:09AM +0200, Jarkko Sakkinen wrote:
> On Mon, Dec 14, 2020 at 08:25:50AM +0100, Ulrich Windl wrote:
> > >>> Topi Miettinen <toiwoton@gmail.com> schrieb am 11.12.2020 um 12:46 in
> > Nachricht
> > <27796c04-249e-6cf0-c3e1-0fd657a82f9c@gmail.com>:
> > > On 11.12.2020 12.46, Jarkko Sakkinen wrote:
> > >> On Wed, Dec 09, 2020 at 10:35:21AM +0200, Topi Miettinen wrote:
> > >>> On 9.12.2020 2.15, Jarkko Sakkinen wrote:
> > >>>> On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
> > >>>>>>>> As  a further argument, I just did this on a Fedora system:
> > >>>>>>>> $ find /dev ‑perm /ugo+x ‑a \! ‑type d ‑a \! ‑type l
> > >>>>>>>> No results.  So making /dev noexec doesn't seem to have any benefit.
> > >>>>>>>
> > >>>>>>> It's no surprise that there aren't any executables in /dev since
> > >>>>>>> removing MAKEDEV ages ago. That's not the issue, which is that
> > >>>>>>> /dev is a writable directory (for UID=0 but no capabilities are
> > >>>>>>> needed) and thus a potential location for constructing unapproved
> > >>>>>>> executables if it is also mounted exec (W^X).
> > >>>>>>
> > >>>>>> UID 0 can just change mount options, though, unless SELinux or similar
> > is 
> > > used. And SELinux can protect /dev just fine without noexec.
> > >>>>>
> > >>>>> Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also
> > SELinux
> > >>>>> is not universal and the policies might not contain all users or
> > services.
> > >>>>>
> > >>>>> ‑Topi
> > >>>>
> > >>>> What's the data that supports having noexec /dev anyway? With root
> > >>>> access I can then just use something else like /dev/shm mount.
> > >>>>
> > >>>> Has there been out in the wild real world cases that noexec mount
> > >>>> of would have prevented?
> > >>>>
> > >>>> For me this sounds a lot just something that "feels more secure"
> > >>>> without any measurable benefit. Can you prove me wrong?
> > >>>
> > >>> I don't think security works that way. An attacker has various methods to
> > >>> choose from, some are more interesting than others. The case where
> > rw,exec
> > >>> /dev would be interesting would imply that easier or more common avenues
> > >>> would be blocked, for example rw,exec /dev/shm, /tmp, /var/tmp, or
> > >>> /run/user/$UID/ for user. Also fileless malware with pure ROP/JOP
> > approach
> > >>> with no need for any file system access is getting more common. It does
> > not
> > >>> mean that it would not be prudent to block the relatively easy approaches
> > >>> too, including /dev.
> > >> 
> > >> What if we add a new mount option "chrexec", which allows exec
> > >> for character devices (S_IFCHR).
> > > 
> > > I think devices are a bad match for SGX because devices haven't been 
> > > executable and SGX is actually an operation for memory. So something 
> > > like memfd_create(, MFD_SGX) or mmap(,, PROT_READ|PROT_EXEC|PROT_SGX) 
> > > would be much more natural. Even better would be something that 
> > > conceptully also works for AMD version (either with the same flags or 
> > > MFD_SGX / MFD_whatever_the_AMD_version_is).
> > 
> > +1
> 
> SGX reserved memory from kernel's point of view is IO memory.
> 
> Mapping SGX to memfd would not be a great idea, as it does not map
> into concept of anonymous file backed by regular memory.
> 
> A device file is very natural match actually. We have ioctl API for
> uploading enclave pages during the build procedure to the enclave and
> custom #PF handler. Conceptually it's a lot like video memory or such
> special device specific memory area.
> 
> There's no AMD equivalent of this technology.

Anyway, I take a not on "PROT_SGX" as one of the ways sort this out in
the future. That would at least fit what we have. Thanks for all the
feedback.

/Jarkko
