Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7904CC6379D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 17:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A26D2467A
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 17:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgKSRGc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Nov 2020 12:06:32 -0500
Received: from kawka.in.waw.pl ([178.62.225.244]:51121 "EHLO kawka.in.waw.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgKSRGb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Nov 2020 12:06:31 -0500
X-Greylist: delayed 1891 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Nov 2020 12:06:30 EST
Received: from zbyszek by kawka.in.waw.pl with local (Exim 4.84_2)
        (envelope-from <zbyszek@in.waw.pl>)
        id 1kfmrV-0006wT-O5; Thu, 19 Nov 2020 16:32:45 +0000
Date:   Thu, 19 Nov 2020 16:32:45 +0000
From:   Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     linux-hotplug@vger.kernel.org,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Topi Miettinen <toiwoton@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Creating executable device nodes in /dev?
Message-ID: <20201119163245.GN7348@in.waw.pl>
References: <CALCETrWM2rGPRudtaQ=mn9MRsrbQqFfZDkOGsBbVMsk6mMw_+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWM2rGPRudtaQ=mn9MRsrbQqFfZDkOGsBbVMsk6mMw_+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 19, 2020 at 08:17:08AM -0800, Andy Lutomirski wrote:
> Hi udev people-
> 
> The upcoming Linux SGX driver has a device node /dev/sgx.  User code
> opens it, does various setup things, mmaps it, and needs to be able to
> create PROT_EXEC mappings.  This gets quite awkward if /dev is mounted
> noexec.
> 
> Can udev arrange to make a device node executable on distros that make
> /dev noexec?  This could be done by bind-mounting from an exec tmpfs.
> Alternatively, the kernel could probably learn to ignore noexec on
> /dev/sgx, but that seems a little bit evil.

I'd be inclined to simply drop noexec from /dev by default.
We don't do noexec on either /tmp or /dev/shm (because that causes immediate
problems with stuff like Java and cffi). And if you have those two at your
disposal anyway, having noexec on /dev doesn't seem important.

Afaik, the kernel would refuse execve() on a character or block device
anyway. Thus noexec on /dev matters only for actual binaries copied to
/dev, which requires root privileges in the first place.

Zbyszek
