Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C89C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 10 Sep 2021 15:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA7B611CE
	for <linux-sgx@archiver.kernel.org>; Fri, 10 Sep 2021 15:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhIJPMR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 10 Sep 2021 11:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229749AbhIJPMR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 10 Sep 2021 11:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA07760C40;
        Fri, 10 Sep 2021 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631286666;
        bh=31NP6TNtRfoRDGtACL76zyDmSgxMok7j3+WIl29hAjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QkJ6H8zlb3YM1Qg+3mHP6a41kPSh5bQQGLJt/3jKTgYQAhhjk9sYdQpyRdz4pQHUw
         UONj3zVHXpNhNyncOAqdRAkzApjLqlwUjC/ZvERiTM/O1LW+CBid+HS+RvSIWmJtwV
         sIZlLKOE378t1jTurAOQc0Pb2ugXiB97YVVst3x4=
Date:   Fri, 10 Sep 2021 17:11:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] x86/sgx: Report SGX memory in
 /sys/devices/system/node/node*/meminfo
Message-ID: <YTt1h/JUmOFRAUxp@kroah.com>
References: <20210910001726.811497-1-jarkko@kernel.org>
 <YTsAjCZQ6AaWDjD1@kroah.com>
 <783594b187e1d4dbeaafe9f186f9a1de8bbf15e4.camel@kernel.org>
 <YTtmJAgOllgtsIDh@kroah.com>
 <100c9d193641f2d18b1a5a15d25b9a36f5edb6bc.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <100c9d193641f2d18b1a5a15d25b9a36f5edb6bc.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 10, 2021 at 06:02:59PM +0300, Jarkko Sakkinen wrote:
> On Fri, 2021-09-10 at 16:05 +0200, Greg Kroah-Hartman wrote:
> > On Fri, Sep 10, 2021 at 04:17:44PM +0300, Jarkko Sakkinen wrote:
> > > On Fri, 2021-09-10 at 08:51 +0200, Greg Kroah-Hartman wrote:
> > > > On Fri, Sep 10, 2021 at 03:17:24AM +0300, Jarkko Sakkinen wrote:
> > > > > The amount of SGX memory on the system is determined by the BIOS and it
> > > > > varies wildly between systems.  It can be from dozens of MB's on desktops
> > > > > or VM's, up to many GB's on servers.  Just like for regular memory, it is
> > > > > sometimes useful to know the amount of usable SGX memory in the system.
> > > > > 
> > > > > Add SGX_MemTotal field to /sys/devices/system/node/node*/meminfo,
> > > > > showing the total SGX memory in each NUMA node. The total memory for
> > > > > each NUMA node is calculated by adding the sizes of contained EPC
> > > > > sections together.
> > > > > 
> > > > > Introduce arch_node_read_meminfo(), which can optionally be rewritten by
> > > > > the arch code, and rewrite it for x86 so it prints SGX_MemTotal.
> > > > > 
> > > > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > ---
> > > > > v4:
> > > > > * A new patch.
> > > > >  arch/x86/kernel/cpu/sgx/main.c | 14 ++++++++++++++
> > > > >  arch/x86/kernel/cpu/sgx/sgx.h  |  6 ++++++
> > > > >  drivers/base/node.c            | 10 +++++++++-
> > > > >  3 files changed, 29 insertions(+), 1 deletion(-)
> > > > 
> > > > Where is the Documentation/ABI/ update for this new sysfs file?
> > > 
> > > It's has been existed for a long time, e.g.
> > > 
> > >  cat /sys/devices/system/node/node0/meminfo
> > > Node 0 MemTotal:       32706792 kB
> > > Node 0 MemFree:         5382988 kB
> > > Node 0 MemUsed:        27323804 kB
> > > Node 0 SwapCached:            8 kB
> > > Node 0 Active:          3640612 kB
> > > Node 0 Inactive:       21757684 kB
> > > Node 0 Active(anon):    2833772 kB
> > > Node 0 Inactive(anon):    14392 kB
> > > Node 0 Active(file):     806840 kB
> > > Node 0 Inactive(file): 21743292 kB
> > > Node 0 Unevictable:       80640 kB
> > > Node 0 Mlocked:           80640 kB
> > > Node 0 Dirty:                36 kB
> > > Node 0 Writeback:             0 kB
> > > Node 0 FilePages:      22833124 kB
> > > Node 0 Mapped:          1112832 kB
> > > Node 0 AnonPages:       2645812 kB
> > > Node 0 Shmem:            282984 kB
> > > Node 0 KernelStack:       18544 kB
> > > Node 0 PageTables:        46704 kB
> > > Node 0 NFS_Unstable:          0 kB
> > > Node 0 Bounce:                0 kB
> > > Node 0 WritebackTmp:          0 kB
> > > Node 0 KReclaimable:    1311812 kB
> > > Node 0 Slab:            1542220 kB
> > > Node 0 SReclaimable:    1311812 kB
> > > Node 0 SUnreclaim:       230408 kB
> > > Node 0 AnonHugePages:         0 kB
> > > Node 0 ShmemHugePages:        0 kB
> > > Node 0 ShmemPmdMapped:        0 kB
> > > Node 0 FileHugePages:        0 kB
> > > Node 0 FilePmdMapped:        0 kB
> > > Node 0 HugePages_Total:     0
> > > Node 0 HugePages_Free:      0
> > > Node 0 HugePages_Surp:      0
> 
> This was something also spinned my head a bit, i.e. why hugepages fields
> are not aligned correctly.
> 
> > > 
> > > This file is undocumented but the fields seem to reflect what is in
> > > /proc/meminfo, so I added additional patch for documentation:
> > > 
> > > https://lore.kernel.org/linux-sgx/20210910001726.811497-3-jarkko@kernel.org/
> > > 
> > > I have no idea why things are how they are. I'm just merely trying to follow
> > > the existing patterns. I'm also fully aware of the defacto sysfs pattern, i.e.
> > > one value per file.
> > 
> > Then please do not add anything else to this nightmare of a mess.
> 
> There is already /sys/devices/system/node/node0/hugepages/.
> 
> It has alike data to the contents of meminfo:
> 
> /sys/devices/system/node/node0/hugepages/hugepages-2048kB:
> surplus_hugepages
> nr_hugepages
> free_hugepages
> 
> /sys/devices/system/node/node0/hugepages/hugepages-1048576kB:
> surplus_hugepages
> nr_hugepages
> free_hugepages
> 
> [I'm wondering tho, how the fields in meminfo are supposed to be interpreted,
>  given that there are two types of huge pages, but let's just ignore that
>  for the moment.]
> 
> Following this pattern, I'd perhaps go and create (and document):
> 
> /sys/devices/system/node/node0/sgx/memory_size
> 
> which would have the size in bytes.

If it is one-value-per-file, that's fine with me.

thanks,

greg k-h
