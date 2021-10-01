Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE52C433EF
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 14:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80AC861A40
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 14:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354660AbhJAOyc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Oct 2021 10:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354585AbhJAOya (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 1 Oct 2021 10:54:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D585761A0A;
        Fri,  1 Oct 2021 14:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633099962;
        bh=aWcV7X/o9vfJj+yYm+DsbIaF5f9jbq9DkASovtKBnQs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tRMFxvBz3BKO3cJpwDhcUEgX1l2ucCRs9WEaii/ygUOyj4eHQ0UPsoYsS4quuK5QN
         klcwM+OiO+UVId6R/FWq4AATYUYRauSxZ97k8oI6h5a9iaSf47mtilhM57IghMyD0U
         fInpuYF+cMlbhbok+hGp7zDWIp4mkrFLuE7gKIICGGautUE2L/oYLGxW4p1HLsV7W5
         YwIDGpYXsSdxvV1f4tjgJMgHdKmepWRC4T4wSswenwgfAKl9PraqDM3fLabrVcDmdC
         3YQvokREkUqamjbUfTskmboouM6G/n/i/eJbKWYIqqxa32V4R4SUR7G5t1zOKhFSVc
         S3c3iXdF9Komw==
Message-ID: <9d94c72879282ae695933879d0a415ea98c81a65.camel@kernel.org>
Subject: Re: [PATCH v6 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>, reinette.chatre@intel.com,
        tony.luck@intel.com, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Date:   Fri, 01 Oct 2021 17:52:39 +0300
In-Reply-To: <YVQUMihamfDgZkAp@kroah.com>
References: <20210928031350.63464-1-jarkko@kernel.org>
         <20210928031350.63464-2-jarkko@kernel.org> <YVKgFj7op4YyBxSK@kroah.com>
         <86b22ff01ca550ed74f73d0d463f697728335f29.camel@kernel.org>
         <YVQUMihamfDgZkAp@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2021-09-29 at 09:22 +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 28, 2021 at 09:20:41PM +0300, Jarkko Sakkinen wrote:
> > On Tue, 2021-09-28 at 06:54 +0200, Greg Kroah-Hartman wrote:
> > > On Tue, Sep 28, 2021 at 06:13:50AM +0300, Jarkko Sakkinen wrote:
> > > > The amount of SGX memory on the system is determined by the BIOS an=
d it
> > > > varies wildly between systems.  It can be from dozens of MB's on de=
sktops
> > > > or VM's, up to many GB's on servers.  Just like for regular memory,=
 it is
> > > > sometimes useful to know the amount of usable SGX memory in the sys=
tem.
> > > >=20
> > > > Add an attribute for the amount of SGX memory in bytes to each NUMA
> > > > node. The path is /sys/devices/system/node/node[0-9]*/sgx/memory_si=
ze.
> > > > Calculate these values by summing up EPC section sizes for each nod=
e
> > > > during the driver initalization.
> > > >=20
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > > ---
> > > >=20
> > > > v6:
> > > > * Initialize node->size to zero in sgx_setup_epc_section(), when th=
e
> > > >   node is first accessed. The bug report:
> > > >   https://lore.kernel.org/linux-sgx/f45245ba-41b8-62ae-38b5-64725a2=
14bad@intel.com/
> > > >=20
> > > > v5:
> > > > * A new patch based on the discussion on
> > > >   https://lore.kernel.org/linux-sgx/3a7cab4115b4f902f3509ad8652e616=
b91703e1d.camel@kernel.org/T/#t
> > > >=20
> > > >  Documentation/x86/sgx.rst      | 14 ++++++
> > >=20
> > > sysfs files have to be documented in Documentation/ABI/ so that they =
can
> > > be automatically checked, and added to the documentation output
> > > properly.  Please do that here as well.
> >=20
> > Right, I'll document it to sysfs-devices-node.
> >=20
> > > >  arch/x86/kernel/cpu/sgx/main.c | 91 ++++++++++++++++++++++++++++++=
++++
> > > >  arch/x86/kernel/cpu/sgx/sgx.h  |  2 +
> > > >  3 files changed, 107 insertions(+)
> > > >=20
> > > > diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> > > > index dd0ac96ff9ef..f9d9cfa6dbf9 100644
> > > > --- a/Documentation/x86/sgx.rst
> > > > +++ b/Documentation/x86/sgx.rst
> > > > @@ -250,3 +250,17 @@ user wants to deploy SGX applications both on =
the host and in guests
> > > >  on the same machine, the user should reserve enough EPC (by taking=
 out
> > > >  total virtual EPC size of all SGX VMs from the physical EPC size) =
for
> > > >  host SGX applications so they can run with acceptable performance.
> > > > +
> > > > +Per NUMA node SGX attributes
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > > > +
> > > > +NUMA nodes devices expose SGX specific attributes in the following=
 path:
> > > > +
> > > > +	/sys/devices/system/node/node[0-9]*/sgx/
> > > > +
> > > > +Attributes
> > > > +----------
> > > > +
> > > > +memory_size
> > > > +                Total available physical SGX memory, also known as=
 Enclave
> > > > +                Page Cache (EPC), in bytes.
> > > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/s=
gx/main.c
> > > > index a6e313f1a82d..4f1e3b5e3d14 100644
> > > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > > @@ -714,9 +714,11 @@ static bool __init sgx_page_cache_init(void)
> > > >  			spin_lock_init(&sgx_numa_nodes[nid].lock);
> > > >  			INIT_LIST_HEAD(&sgx_numa_nodes[nid].free_page_list);
> > > >  			node_set(nid, sgx_numa_mask);
> > > > +			sgx_numa_nodes[nid].size =3D 0;
> > > >  		}
> > > > =20
> > > >  		sgx_epc_sections[i].node =3D  &sgx_numa_nodes[nid];
> > > > +		sgx_numa_nodes[nid].size +=3D size;
> > > > =20
> > > >  		sgx_nr_epc_sections++;
> > > >  	}
> > > > @@ -790,6 +792,87 @@ int sgx_set_attribute(unsigned long *allowed_a=
ttributes,
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(sgx_set_attribute);
> > > > =20
> > > > +#ifdef CONFIG_NUMA
> > > > +static void sgx_numa_exit(void)
> > > > +{
> > > > +	int nid;
> > > > +
> > > > +	for (nid =3D 0; nid < num_possible_nodes(); nid++) {
> > > > +		if (!sgx_numa_nodes[nid].kobj)
> > > > +			continue;
> > > > +
> > > > +		kobject_put(sgx_numa_nodes[nid].kobj);
> > > > +	}
> > > > +}
> > > > +
> > > > +#define SGX_NODE_ATTR_RO(_name) \
> > > > +	static struct kobj_attribute _name##_attr =3D __ATTR_RO(_name)
> > >=20
> > > Why are you dealing with a "raw" kobject?  Shouldn't you have a devic=
e
> > > and use a device attribute?
> > >=20
> > > > +static bool sgx_numa_init(void)
> > > > +{
> > > > +	struct sgx_numa_node *node;
> > > > +	struct device *dev;
> > > > +	int nid;
> > > > +	int ret;
> > > > +
> > > > +	for (nid =3D 0; nid < num_possible_nodes(); nid++) {
> > > > +		if (!sgx_numa_nodes[nid].size)
> > > > +			continue;
> > > > +
> > > > +		node =3D &sgx_numa_nodes[nid];
> > > > +		dev =3D &node_devices[nid]->dev;
> > > > +
> > > > +		node->kobj =3D kobject_create_and_add("sgx", &dev->kobj);
> > >=20
> > > You just "broke" the tree by putting a raw kobject below a struct
> > > device.  Please do not do that.
> >=20
> > I looked how hugetlb was implemented as a starting point, since it is
> > existing mainline code, i.e. in mm/hugetlb.c:
> >=20
> > - hugetlb_register_node()
> > - hugetlb_register_all_nodes()
> > - HSTATE_ATTR_RO()
> >=20
> > hugetlb code attaches raw kobjects to the node device, by using this
> > (perhaps anti)pattern.
>=20
> Never look at the memory code for how to use sysfs "properly" :)
>=20
> It deals with raw kobjects as it is not tied into the driver model at
> all.  You are, so do not try to route around it, userspace will not be
> happy with you if you do so.
>=20
> > > > +		if (!node->kobj) {
> > > > +			sgx_numa_exit();
> > > > +			return false;
> > > > +		}
> > > > +
> > > > +		ret =3D sysfs_create_group(node->kobj, &sgx_node_attr_group);
> > >=20
> > > And you raced with userspace and lost.
> > >=20
> > > Wait, you have a kobject _just_ for a subdirectory name?  Why?  Use a
> > > named attribute group, that's exactly what that is for.
> > >=20
> > > Properly attach your attributes to the device you have, don't do extr=
a
> > > work and complex code that you do not have to at all.
> >=20
> > Here the reference was hugetlb_sysfs_init() and hugetlb_sysfs_add_hstat=
e().
> > Agreed, that a named group would make a lot more sense.
>=20
> Again, ignore all sysfs code for the memory subsystem please :)

OK, cool, thank you. I can do that.

>=20
> thanks,
>=20
> greg k-h

/Jarkko
