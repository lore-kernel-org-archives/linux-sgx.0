Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E18C433FE
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 18:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C194C6136F
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 18:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbhI1SWX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241488AbhI1SWX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 28 Sep 2021 14:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 311F261359;
        Tue, 28 Sep 2021 18:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632853243;
        bh=124+ge9GvFQedKVTp1//3s4vAlDi/XONJsYE6C6P+bE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=efTvBob3WbQ7naU5ORWMZsARCPMnDmQX6yab4VvD1mGNDOhAE7eoZc2+9brl2tiI9
         OnC3sLWwkQ7kiwGN0QkKCHBoOnsjLNBzQlOiXC6FOny6VYPGv8dCq/u7iKRxynsfTE
         peslhfDBVvKAvvT0wRxugxfPYDvYcvffywHLMWBeUb4x8EgAtvrNeVhhvGQnQsFggW
         RZQaNRbGz/xN/ow6LLm10tkYEtRx4k9f/EjcQXTjBPwXizo6A7HLKtkaQU7pOP3qwX
         FINSqeBxEOl0vu7zmCR9yMzPqKi4u7/OT/yMANsrY8c1Oy9icIiSMfV0QOOeU8Kg9H
         1G72jtlEMViYA==
Message-ID: <86b22ff01ca550ed74f73d0d463f697728335f29.camel@kernel.org>
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
Date:   Tue, 28 Sep 2021 21:20:41 +0300
In-Reply-To: <YVKgFj7op4YyBxSK@kroah.com>
References: <20210928031350.63464-1-jarkko@kernel.org>
         <20210928031350.63464-2-jarkko@kernel.org> <YVKgFj7op4YyBxSK@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2021-09-28 at 06:54 +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 28, 2021 at 06:13:50AM +0300, Jarkko Sakkinen wrote:
> > The amount of SGX memory on the system is determined by the BIOS and it
> > varies wildly between systems.  It can be from dozens of MB's on deskto=
ps
> > or VM's, up to many GB's on servers.  Just like for regular memory, it =
is
> > sometimes useful to know the amount of usable SGX memory in the system.
> >=20
> > Add an attribute for the amount of SGX memory in bytes to each NUMA
> > node. The path is /sys/devices/system/node/node[0-9]*/sgx/memory_size.
> > Calculate these values by summing up EPC section sizes for each node
> > during the driver initalization.
> >=20
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >=20
> > v6:
> > * Initialize node->size to zero in sgx_setup_epc_section(), when the
> >   node is first accessed. The bug report:
> >   https://lore.kernel.org/linux-sgx/f45245ba-41b8-62ae-38b5-64725a214ba=
d@intel.com/
> >=20
> > v5:
> > * A new patch based on the discussion on
> >   https://lore.kernel.org/linux-sgx/3a7cab4115b4f902f3509ad8652e616b917=
03e1d.camel@kernel.org/T/#t
> >=20
> >  Documentation/x86/sgx.rst      | 14 ++++++
>=20
> sysfs files have to be documented in Documentation/ABI/ so that they can
> be automatically checked, and added to the documentation output
> properly.  Please do that here as well.

Right, I'll document it to sysfs-devices-node.

> >  arch/x86/kernel/cpu/sgx/main.c | 91 ++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/sgx/sgx.h  |  2 +
> >  3 files changed, 107 insertions(+)
> >=20
> > diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> > index dd0ac96ff9ef..f9d9cfa6dbf9 100644
> > --- a/Documentation/x86/sgx.rst
> > +++ b/Documentation/x86/sgx.rst
> > @@ -250,3 +250,17 @@ user wants to deploy SGX applications both on the =
host and in guests
> >  on the same machine, the user should reserve enough EPC (by taking out
> >  total virtual EPC size of all SGX VMs from the physical EPC size) for
> >  host SGX applications so they can run with acceptable performance.
> > +
> > +Per NUMA node SGX attributes
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > +
> > +NUMA nodes devices expose SGX specific attributes in the following pat=
h:
> > +
> > +	/sys/devices/system/node/node[0-9]*/sgx/
> > +
> > +Attributes
> > +----------
> > +
> > +memory_size
> > +                Total available physical SGX memory, also known as Enc=
lave
> > +                Page Cache (EPC), in bytes.
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/m=
ain.c
> > index a6e313f1a82d..4f1e3b5e3d14 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -714,9 +714,11 @@ static bool __init sgx_page_cache_init(void)
> >  			spin_lock_init(&sgx_numa_nodes[nid].lock);
> >  			INIT_LIST_HEAD(&sgx_numa_nodes[nid].free_page_list);
> >  			node_set(nid, sgx_numa_mask);
> > +			sgx_numa_nodes[nid].size =3D 0;
> >  		}
> > =20
> >  		sgx_epc_sections[i].node =3D  &sgx_numa_nodes[nid];
> > +		sgx_numa_nodes[nid].size +=3D size;
> > =20
> >  		sgx_nr_epc_sections++;
> >  	}
> > @@ -790,6 +792,87 @@ int sgx_set_attribute(unsigned long *allowed_attri=
butes,
> >  }
> >  EXPORT_SYMBOL_GPL(sgx_set_attribute);
> > =20
> > +#ifdef CONFIG_NUMA
> > +static void sgx_numa_exit(void)
> > +{
> > +	int nid;
> > +
> > +	for (nid =3D 0; nid < num_possible_nodes(); nid++) {
> > +		if (!sgx_numa_nodes[nid].kobj)
> > +			continue;
> > +
> > +		kobject_put(sgx_numa_nodes[nid].kobj);
> > +	}
> > +}
> > +
> > +#define SGX_NODE_ATTR_RO(_name) \
> > +	static struct kobj_attribute _name##_attr =3D __ATTR_RO(_name)
>=20
> Why are you dealing with a "raw" kobject?  Shouldn't you have a device
> and use a device attribute?
>=20
> > +static bool sgx_numa_init(void)
> > +{
> > +	struct sgx_numa_node *node;
> > +	struct device *dev;
> > +	int nid;
> > +	int ret;
> > +
> > +	for (nid =3D 0; nid < num_possible_nodes(); nid++) {
> > +		if (!sgx_numa_nodes[nid].size)
> > +			continue;
> > +
> > +		node =3D &sgx_numa_nodes[nid];
> > +		dev =3D &node_devices[nid]->dev;
> > +
> > +		node->kobj =3D kobject_create_and_add("sgx", &dev->kobj);
>=20
> You just "broke" the tree by putting a raw kobject below a struct
> device.  Please do not do that.

I looked how hugetlb was implemented as a starting point, since it is
existing mainline code, i.e. in mm/hugetlb.c:

- hugetlb_register_node()
- hugetlb_register_all_nodes()
- HSTATE_ATTR_RO()

hugetlb code attaches raw kobjects to the node device, by using this
(perhaps anti)pattern.

>=20
> > +		if (!node->kobj) {
> > +			sgx_numa_exit();
> > +			return false;
> > +		}
> > +
> > +		ret =3D sysfs_create_group(node->kobj, &sgx_node_attr_group);
>=20
> And you raced with userspace and lost.
>=20
> Wait, you have a kobject _just_ for a subdirectory name?  Why?  Use a
> named attribute group, that's exactly what that is for.
>=20
> Properly attach your attributes to the device you have, don't do extra
> work and complex code that you do not have to at all.

Here the reference was hugetlb_sysfs_init() and hugetlb_sysfs_add_hstate().
Agreed, that a named group would make a lot more sense.

> thanks,
>=20
> greg k-h

/Jarkko

