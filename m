Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847C2C433F5
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Oct 2021 17:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56A9E60F70
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Oct 2021 17:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhJaRmH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 Oct 2021 13:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhJaRmH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 Oct 2021 13:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A860460E9C;
        Sun, 31 Oct 2021 17:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635701975;
        bh=/jhugDKhW3TbcyVsB5fYxgHwYzrkBypz0AKuKjNbDu0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tXCDQ9dUBp+HSbwmlwHUoEpJIo0pS6cnlXPDYAsmxW9LnzNe8UoVnDIiHXncM/Trp
         DdqwWJv2hBSvb8EZClbgx2wqhUphREGLm4FIcLpGGUJxAz4xrxOZAwrmdvTOtOhbdY
         mswG3eQvTOWbm07z+p6t/4+g4NT0OfBPErKELyCN+piIw/Qr4ZgoOJWNIzqQ9BUTql
         APhou7eRkbRuUZLtRXJ1ofyCL5A3kiFN2IjW23wYenwwhsXF4ztS9SVEE6+BDzsfoR
         ClA3AMUEu/SDnLZkTA5Dt8W5+SclLE38OJhy8K+u26cldlVHl5vKqcDD35PUiavfYa
         SrXr43Rm7Q2Jw==
Message-ID: <f0dc181d435cde51a9b81a70a0f47ff866d8cb91.camel@kernel.org>
Subject: Re: [PATCH v9 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, reinette.chatre@intel.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org
Date:   Sun, 31 Oct 2021 19:39:32 +0200
In-Reply-To: <YXwK7Wdi1VUK+1LS@kroah.com>
References: <20211029121857.477885-1-jarkko@kernel.org>
         <20211029121857.477885-2-jarkko@kernel.org> <YXwK7Wdi1VUK+1LS@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2021-10-29 at 16:53 +0200, Greg Kroah-Hartman wrote:
> On Fri, Oct 29, 2021 at 03:18:57PM +0300, Jarkko Sakkinen wrote:
> > The amount of SGX memory on the system is determined by the BIOS and it
> > varies wildly between systems.=C2=A0 It can be from dozens of MB's on d=
esktops
> > or VM's, up to many GB's on servers.=C2=A0 Just like for regular memory=
, it is
> > sometimes useful to know the amount of usable SGX memory in the system.
> >=20
> > Add an attribute for the amount of SGX memory in bytes to each NUMA
> > node. The path is /sys/devices/system/node/node[0-9]*/sgx/size.
> > Calculate these values by summing up EPC section sizes for each node
> > during the driver initalization.
> >=20
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
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
> > =C2=A0Documentation/ABI/stable/sysfs-devices-node |=C2=A0 7 +++++
> > =C2=A0arch/x86/include/asm/sgx.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +=
+
> > =C2=A0arch/x86/kernel/cpu/sgx/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 31 +++++++++++++++++++++
> > =C2=A0arch/x86/kernel/cpu/sgx/sgx.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 ++
> > =C2=A0drivers/base/node.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 16 ++++++++++-
> > =C2=A05 files changed, 57 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentatio=
n/ABI/stable/sysfs-devices-node
> > index 484fc04bcc25..12dc2149e8e0 100644
> > --- a/Documentation/ABI/stable/sysfs-devices-node
> > +++ b/Documentation/ABI/stable/sysfs-devices-node
> > @@ -176,3 +176,10 @@ Contact:=C2=A0=C2=A0=C2=A0Keith Busch <keith.busch=
@intel.com>
> > =C2=A0Description:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0The cache write policy: 0 for write-back, 1 for =
write-through,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0other or unknown.
> > +
> > +What:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sys/=
devices/system/node/nodeX/sgx/size
> > +Date:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Octob=
er 2021
> > +Contact:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Jarkko Sakkinen <jar=
kko@kernel.org>
> > +Description:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0Total available physical SGX memory, also known as Enc=
lave Page
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0Cache (EPC), in bytes.
> > diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> > index 05f3e21f01a7..43d1ccae6c62 100644
> > --- a/arch/x86/include/asm/sgx.h
> > +++ b/arch/x86/include/asm/sgx.h
> > @@ -365,6 +365,8 @@ struct sgx_sigstruct {
> > =C2=A0 * comment!
> > =C2=A0 */
> > =C2=A0
> > +extern const struct attribute_group sgx_node_group;
> > +
> > =C2=A0#ifdef CONFIG_X86_SGX_KVM
> > =C2=A0int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *=
secs,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int *trapnr);
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/m=
ain.c
> > index a6e313f1a82d..86d6d309ff29 100644
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
> > +static ssize_t size_show(struct device *dev, struct device_attribute *=
attr, char *buf)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long size =3D 0;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int nid;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (nid =3D 0; nid < num_po=
ssible_nodes(); nid++) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (dev =3D=3D sgx_numa_nodes[nid].dev) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0size =
=3D sgx_numa_nodes[nid].size;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0break;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0}
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return sysfs_emit(buf, "%lu\=
n", size);
> > +}
> > +DEVICE_ATTR_RO(size);
>=20
> static?

The named ("sgx") attribute group is exported:

extern const struct attribute_group sgx_node_group;

and added as an additional group of the node device:

static const struct attribute_group node_dev_group =3D {
	.attrs =3D node_dev_attrs,
};

static const struct attribute_group *node_dev_groups[] =3D {
	&node_dev_group,
#ifdef CONFIG_X86_SGX
	&sgx_node_group,
#endif /* CONFIG_X86_SGX */
	NULL,
};
=20
An alternative would to define a helper, e.g.

ssize_t sgx_get_node_size(struct device *dev);

And use this in drivers/base/node.c to implement the attribute. I'm
fine either way...

/Jarkko

