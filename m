Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4330C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 10 Sep 2021 13:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A8B1611CC
	for <linux-sgx@archiver.kernel.org>; Fri, 10 Sep 2021 13:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbhIJNS5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233253AbhIJNS5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 10 Sep 2021 09:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F2BC61167;
        Fri, 10 Sep 2021 13:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631279866;
        bh=M+SGRiM/ET5iAZ80Cp7a3dW3puaSEQYT3O9A2vlwfec=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OuMFbSpMWru7vQlFsNzzXIDYUq2T/F+B91sW45UKV5uMqlJkfNjTvz0VZvK3mRZaL
         JT5/ulplxQ0K1/wDH5fw5Pe5l+I2lKWOZAQ/vbuZJRWtVzhIbTY+DSc/2PhUrrdzEq
         89s53I8nLOW74rb5PHOkGKcFj+MM1rqQ5RgMubX+v8hWLOuo/WhOQJCzsZmCriXlAu
         Q4dQzeWtft1SBqO5y5jf8CTwYE0rsYH7hTGdmId6d99uXdJpX6aLKXeG4UUfqMe2yc
         v4IgkasGxNoG+nIBIrwwrfbiLhrwQe90l5xzt16Y8fDQaZH+prSN1UHJh5PjBYz2xs
         9mhV5veviPPeQ==
Message-ID: <783594b187e1d4dbeaafe9f186f9a1de8bbf15e4.camel@kernel.org>
Subject: Re: [PATCH v4 1/3] x86/sgx: Report SGX memory in
 /sys/devices/system/node/node*/meminfo
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 10 Sep 2021 16:17:44 +0300
In-Reply-To: <YTsAjCZQ6AaWDjD1@kroah.com>
References: <20210910001726.811497-1-jarkko@kernel.org>
         <YTsAjCZQ6AaWDjD1@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2021-09-10 at 08:51 +0200, Greg Kroah-Hartman wrote:
> On Fri, Sep 10, 2021 at 03:17:24AM +0300, Jarkko Sakkinen wrote:
> > The amount of SGX memory on the system is determined by the BIOS and it
> > varies wildly between systems.  It can be from dozens of MB's on deskto=
ps
> > or VM's, up to many GB's on servers.  Just like for regular memory, it =
is
> > sometimes useful to know the amount of usable SGX memory in the system.
> >=20
> > Add SGX_MemTotal field to /sys/devices/system/node/node*/meminfo,
> > showing the total SGX memory in each NUMA node. The total memory for
> > each NUMA node is calculated by adding the sizes of contained EPC
> > sections together.
> >=20
> > Introduce arch_node_read_meminfo(), which can optionally be rewritten b=
y
> > the arch code, and rewrite it for x86 so it prints SGX_MemTotal.
> >=20
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > v4:
> > * A new patch.
> >  arch/x86/kernel/cpu/sgx/main.c | 14 ++++++++++++++
> >  arch/x86/kernel/cpu/sgx/sgx.h  |  6 ++++++
> >  drivers/base/node.c            | 10 +++++++++-
> >  3 files changed, 29 insertions(+), 1 deletion(-)
>=20
> Where is the Documentation/ABI/ update for this new sysfs file?

It's has been existed for a long time, e.g.

 cat /sys/devices/system/node/node0/meminfo
Node 0 MemTotal:       32706792 kB
Node 0 MemFree:         5382988 kB
Node 0 MemUsed:        27323804 kB
Node 0 SwapCached:            8 kB
Node 0 Active:          3640612 kB
Node 0 Inactive:       21757684 kB
Node 0 Active(anon):    2833772 kB
Node 0 Inactive(anon):    14392 kB
Node 0 Active(file):     806840 kB
Node 0 Inactive(file): 21743292 kB
Node 0 Unevictable:       80640 kB
Node 0 Mlocked:           80640 kB
Node 0 Dirty:                36 kB
Node 0 Writeback:             0 kB
Node 0 FilePages:      22833124 kB
Node 0 Mapped:          1112832 kB
Node 0 AnonPages:       2645812 kB
Node 0 Shmem:            282984 kB
Node 0 KernelStack:       18544 kB
Node 0 PageTables:        46704 kB
Node 0 NFS_Unstable:          0 kB
Node 0 Bounce:                0 kB
Node 0 WritebackTmp:          0 kB
Node 0 KReclaimable:    1311812 kB
Node 0 Slab:            1542220 kB
Node 0 SReclaimable:    1311812 kB
Node 0 SUnreclaim:       230408 kB
Node 0 AnonHugePages:         0 kB
Node 0 ShmemHugePages:        0 kB
Node 0 ShmemPmdMapped:        0 kB
Node 0 FileHugePages:        0 kB
Node 0 FilePmdMapped:        0 kB
Node 0 HugePages_Total:     0
Node 0 HugePages_Free:      0
Node 0 HugePages_Surp:      0

This file is undocumented but the fields seem to reflect what is in
/proc/meminfo, so I added additional patch for documentation:

https://lore.kernel.org/linux-sgx/20210910001726.811497-3-jarkko@kernel.org=
/

I have no idea why things are how they are. I'm just merely trying to follo=
w
the existing patterns. I'm also fully aware of the defacto sysfs pattern, i=
.e.
one value per file.

I figured, since the situation is how it is, that I end up doing this wrong
in a way or another, so this the anti-pattern I picked for my wrong doings
:-) I'm sorry about it.

> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/m=
ain.c
> > index 63d3de02bbcc..4c6da5f4a9d4 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -717,6 +717,7 @@ static bool __init sgx_page_cache_init(void)
> >  		}
> > =20
> >  		sgx_epc_sections[i].node =3D  &sgx_numa_nodes[nid];
> > +		sgx_numa_nodes[nid].size +=3D size;
> > =20
> >  		sgx_nr_epc_sections++;
> >  	}
> > @@ -790,6 +791,19 @@ int sgx_set_attribute(unsigned long *allowed_attri=
butes,
> >  }
> >  EXPORT_SYMBOL_GPL(sgx_set_attribute);
> > =20
> > +ssize_t arch_node_read_meminfo(struct device *dev,
> > +			       struct device_attribute *attr,
> > +			       char *buf, int len)
> > +{
> > +	struct sgx_numa_node *node =3D &sgx_numa_nodes[dev->id];
> > +
> > +	len +=3D sysfs_emit_at(buf, len,
> > +			     "Node %d SGX_MemTotal:   %8lu kB\n",
> > +			     dev->id, node->size);
>=20
> Wait, that is not how sysfs files work.  they are "one value per file"
> Please do not have multiple values in a single sysfs file, that is not
> acceptable at all.

Yeah, I'm wondering what would be the right corrective steps, given the
"established science".

> thanks,
>=20
> greg k-h

/Jarkko

