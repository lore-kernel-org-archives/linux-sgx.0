Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A724C433FE
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Nov 2021 21:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3B66113E
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Nov 2021 21:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhKCVwU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Nov 2021 17:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhKCVwU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 3 Nov 2021 17:52:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C9C861108;
        Wed,  3 Nov 2021 21:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635976183;
        bh=SmRyUyP5KOg18MaALrY8w4qrElXiQ7dRqmIWRis2gOI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FvOgEy+aHAPq5w9FY+8mxq3NTG8gv37aq6KsmVZCbB2BxvKYFPKd+yCduej1XYaFw
         1Ly1zCYXqxc77JTlgOfnT5jmHK4rfRUQOP8vV1BnWuhRAl3KYyOMZYY82GVI12RRf9
         fPPp8CD2GJD+Hn8byx7ezZsmM4IVot28XEkFPPGOf4TWvgpzk2Yu+OwkRChgsigLNZ
         IMqyWTVpzcO1s2tkhxqwPPT89J7m4ZjBYNQMCXD6Yo3EwFF/clEBLttaJVuVwx5Zoj
         qL6W9D9r+eF8iHjihNat1iD4k1oRCXBj/0ZyGAiSl7HKISyL+v2nz6pfKQHaoTNPJg
         0FQ+ei6i4FnpA==
Message-ID: <d3711ca7d612627bb891c10e20c3d569fa6f2bf3.camel@kernel.org>
Subject: Re: [PATCH v11 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, reinette.chatre@intel.com,
        tony.luck@intel.com, nathaniel@profian.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Date:   Wed, 03 Nov 2021 23:49:40 +0200
In-Reply-To: <YYJGzgkLJs6819t8@kroah.com>
References: <20211103012813.670195-1-jarkko@kernel.org>
         <20211103012813.670195-2-jarkko@kernel.org> <YYJGzgkLJs6819t8@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2021-11-03 at 09:22 +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 03, 2021 at 03:28:13AM +0200, Jarkko Sakkinen wrote:
> > The amount of SGX memory on the system is determined by the BIOS and it
> > varies wildly between systems.=C2=A0 It can be from dozens of MB's on d=
esktops
> > or VM's, up to many GB's on servers.=C2=A0 Just like for regular memory=
, it is
> > sometimes useful to know the amount of usable SGX memory in the system.
> >=20
> > Introduce CONFIG_HAVE_ARCH_NODE_DEV_GROUP opt-in flag to expose an arch
> > specific attribute group, and add an attribute for the amount of SGX
> > memory in bytes to each NUMA node:
> >=20
> > /sys/devices/system/node/nodeX/x86/sgx_total_bytes
> >=20
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > v11:
> > * Fix documentation and the commit message.
> >=20
> > v10:
> > * Change DEVICE_ATTR_RO() to static (Greg K-H)
> > * Change the attribute name as sgx_total_bytes, and attribute group
> > =C2=A0 name as "x86" (Dave).
> > * Add a new config flag HAVE_ARCH_NODE_DEV_GROUP to identify, whether
> > =C2=A0 an arch exports arch specific attribute group for NUMA nodes.
> >=20
> > v9:
> > * Fix racy initialization of sysfs attributes:
> > =C2=A0 https://lore.kernel.org/linux-sgx/YXOsx8SvFJV5R7lU@kroah.com/
> >=20
> > v8:
> > * Fix a bug in sgx_numa_init(): node->dev should be only set after
> > =C2=A0 sysfe_create_group().=C2=A0 Otherwise, sysfs_remove_group() will=
 issue a
> > =C2=A0 warning in sgx_numa_exit(), when sgx_create_group() is unsuccess=
ful,
> > =C2=A0 because the group does not exist.
> >=20
> > v7:
> > * Shorten memory_size to size. The prefix makes the name only longer
> > =C2=A0 but does not clarify things more than "size" would.
> > * Use device_attribute instead of kobj_attribute.
> > * Use named attribute group instead of creating raw kobject just for
> > =C2=A0 the "sgx" subdirectory.
> >=20
> > v6:
> > * Initialize node->size to zero in sgx_setup_epc_section(), when the
> > =C2=A0 node is first accessed.
> >=20
> > v5
> > * A new patch based on the discussion on
> > =C2=A0 https://lore.kernel.org/linux-sgx/3a7cab4115b4f902f3509ad8652e61=
6b91703e1d.camel@kernel.org/T/#t
> > ---
> > =C2=A0Documentation/ABI/stable/sysfs-devices-node |=C2=A0 6 ++++
> > =C2=A0arch/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +++
> > =C2=A0arch/x86/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> > =C2=A0arch/x86/kernel/cpu/sgx/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 31 +++++++++++++++++++++
> > =C2=A0arch/x86/kernel/cpu/sgx/sgx.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 ++
> > =C2=A0drivers/base/node.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 13 ++++++++-
> > =C2=A0include/linux/numa.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +++
> > =C2=A07 files changed, 60 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentatio=
n/ABI/stable/sysfs-devices-node
> > index 484fc04bcc25..8db67aa472f1 100644
> > --- a/Documentation/ABI/stable/sysfs-devices-node
> > +++ b/Documentation/ABI/stable/sysfs-devices-node
> > @@ -176,3 +176,9 @@ Contact:=C2=A0=C2=A0=C2=A0=C2=A0Keith Busch <keith.=
busch@intel.com>
> > =C2=A0Description:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0The cache write policy: 0 for write-back, 1 for =
write-through,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0other or unknown.
> > +
> > +What:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sys/=
devices/system/node/nodeX/x86/sgx_total_bytes
> > +Date:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Novem=
ber 2021
> > +Contact:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Jarkko Sakkinen <jar=
kko@kernel.org>
> > +Description:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0The total amount of SGX physical memory in bytes.
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 98db63496bab..ca5d75b5a427 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -1285,6 +1285,10 @@ config ARCH_HAS_ELFCORE_COMPAT
> > =C2=A0config ARCH_HAS_PARANOID_L1D_FLUSH
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bool
> > =C2=A0
> > +# Select, if arch has a named attribute group bound to NUMA device nod=
es.
> > +config HAVE_ARCH_NODE_DEV_GROUP
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bool
> > +
> > =C2=A0source "kernel/gcov/Kconfig"
> > =C2=A0
> > =C2=A0source "scripts/gcc-plugins/Kconfig"
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 421fa9e38c60..8503c3bdf63f 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -266,6 +266,7 @@ config X86
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0select HAVE_ARCH_KCSAN=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if X86_64
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0select X86_FEATURE_NAME=
S=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if PROC_FS
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0select PROC_PID_ARCH_ST=
ATUS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0if PROC_FS
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0select HAVE_ARCH_NODE_DEV_GR=
OUP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if X86_SGX
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0imply IMA_SECURE_AND_OR=
_TRUSTED_BOOT=C2=A0=C2=A0=C2=A0 if EFI
> > =C2=A0
> > =C2=A0config INSTRUCTION_DECODER
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/m=
ain.c
> > index a6e313f1a82d..02ebb233c511 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -714,9 +714,12 @@ static bool __init sgx_page_cache_init(void)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
spin_lock_init(&sgx_numa_nodes[nid].lock);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
INIT_LIST_HEAD(&sgx_numa_nodes[nid].free_page_list);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
node_set(nid, sgx_numa_mask);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_nu=
ma_nodes[nid].size =3D 0;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_epc_sections[i].node =3D=C2=A0 &sgx_numa_nod=
es[nid];
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0sgx_numa_nodes[nid].dev =3D &node_devices[nid]->dev;
>=20
> You are saving off a pointer to an object without incrementing the
> reference count of it?=C2=A0 What prevents it from going away in the futu=
re?

Since the arch specific attribute group is part of the "groups" of that dev=
ice,
I'd presume that when sgx_total_bytes_show() is called the device has not g=
one
away:

static const struct attribute_group *node_dev_groups[] =3D {
	&node_dev_group,
#ifdef CONFIG_HAVE_ARCH_NODE_DEV_GROUP
	&arch_node_dev_group,
#endif
	NULL,
};

I mean the "dev" parameter in sgx_total_bytes_show() is probably valid, whe=
n
sysfs framework calls it, right?

> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0sgx_numa_nodes[nid].size +=3D size;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_nr_epc_sections++;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > @@ -790,6 +793,34 @@ int sgx_set_attribute(unsigned long *allowed_attri=
butes,
> > =C2=A0}
> > =C2=A0EXPORT_SYMBOL_GPL(sgx_set_attribute);
> > =C2=A0
> > +#ifdef CONFIG_NUMA
> > +static ssize_t sgx_total_bytes_show(struct device *dev, struct device_=
attribute *attr, char *buf)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long size =3D 0;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int nid;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (nid =3D 0; nid < num_po=
ssible_nodes(); nid++) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (dev =3D=3D sgx_numa_nodes[nid].dev) {
>=20
> Why aren't these values all just part of the device that is being used
> here?=C2=A0 You are walking some odd array, with no locking, and no refer=
ence
> counting on the objects you are looking at, just to find the same object
> that you started out with???

This code looks up the struct sgx_numa_node instance, and the array is
indexed with NUMA node ID. "dev" is only used as lookup key.

> That's not the proper thing to do here at all, these values should be
> part of the device structure that this attribute lives on, in order to
> properly handle all of these reference counting and locking issues
> automatically.

The attribute group is part of the device structure, so in that sense
it is already like this. And I think that all NUMA node specific data
(most of which is unrelated to device sysfs) is best kept in the private
struct.

> Please fix the design of this code first, _before_ adding new
> attributes.

I sincerely think it is correct now.

>=20
> thanks,
>=20
> greg k-h

/Jarkko

