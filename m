Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE7BC433F5
	for <linux-sgx@archiver.kernel.org>; Wed, 29 Sep 2021 07:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B2636137A
	for <linux-sgx@archiver.kernel.org>; Wed, 29 Sep 2021 07:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244604AbhI2HYL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 29 Sep 2021 03:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244584AbhI2HYK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 29 Sep 2021 03:24:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 061DF613C8;
        Wed, 29 Sep 2021 07:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632900149;
        bh=zlnCUM3BO/6UMnDjxoW2fr854qNEEH4bo0QWLV1kvz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=afAnU5R9jlfrrpGpElPcWeLFyyP0TB79XQ+0WPRQhL0z1W/Nctm+Zh6yQfCS2PrVg
         hgSRfkx7IU33MSieum9Ejdht9WPgAYT0sxqb1nRObBNTFE6Wdz4sJjuo098NCQMO97
         P1FTaD6IEkVBldimPxK7UMVZ8yaTb8FMyUiQu43A=
Date:   Wed, 29 Sep 2021 09:22:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>, reinette.chatre@intel.com,
        tony.luck@intel.com, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
Message-ID: <YVQUMihamfDgZkAp@kroah.com>
References: <20210928031350.63464-1-jarkko@kernel.org>
 <20210928031350.63464-2-jarkko@kernel.org>
 <YVKgFj7op4YyBxSK@kroah.com>
 <86b22ff01ca550ed74f73d0d463f697728335f29.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86b22ff01ca550ed74f73d0d463f697728335f29.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 28, 2021 at 09:20:41PM +0300, Jarkko Sakkinen wrote:
> On Tue, 2021-09-28 at 06:54 +0200, Greg Kroah-Hartman wrote:
> > On Tue, Sep 28, 2021 at 06:13:50AM +0300, Jarkko Sakkinen wrote:
> > > The amount of SGX memory on the system is determined by the BIOS and it
> > > varies wildly between systems.  It can be from dozens of MB's on desktops
> > > or VM's, up to many GB's on servers.  Just like for regular memory, it is
> > > sometimes useful to know the amount of usable SGX memory in the system.
> > > 
> > > Add an attribute for the amount of SGX memory in bytes to each NUMA
> > > node. The path is /sys/devices/system/node/node[0-9]*/sgx/memory_size.
> > > Calculate these values by summing up EPC section sizes for each node
> > > during the driver initalization.
> > > 
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > ---
> > > 
> > > v6:
> > > * Initialize node->size to zero in sgx_setup_epc_section(), when the
> > >   node is first accessed. The bug report:
> > >   https://lore.kernel.org/linux-sgx/f45245ba-41b8-62ae-38b5-64725a214bad@intel.com/
> > > 
> > > v5:
> > > * A new patch based on the discussion on
> > >   https://lore.kernel.org/linux-sgx/3a7cab4115b4f902f3509ad8652e616b91703e1d.camel@kernel.org/T/#t
> > > 
> > >  Documentation/x86/sgx.rst      | 14 ++++++
> > 
> > sysfs files have to be documented in Documentation/ABI/ so that they can
> > be automatically checked, and added to the documentation output
> > properly.  Please do that here as well.
> 
> Right, I'll document it to sysfs-devices-node.
> 
> > >  arch/x86/kernel/cpu/sgx/main.c | 91 ++++++++++++++++++++++++++++++++++
> > >  arch/x86/kernel/cpu/sgx/sgx.h  |  2 +
> > >  3 files changed, 107 insertions(+)
> > > 
> > > diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> > > index dd0ac96ff9ef..f9d9cfa6dbf9 100644
> > > --- a/Documentation/x86/sgx.rst
> > > +++ b/Documentation/x86/sgx.rst
> > > @@ -250,3 +250,17 @@ user wants to deploy SGX applications both on the host and in guests
> > >  on the same machine, the user should reserve enough EPC (by taking out
> > >  total virtual EPC size of all SGX VMs from the physical EPC size) for
> > >  host SGX applications so they can run with acceptable performance.
> > > +
> > > +Per NUMA node SGX attributes
> > > +============================
> > > +
> > > +NUMA nodes devices expose SGX specific attributes in the following path:
> > > +
> > > +	/sys/devices/system/node/node[0-9]*/sgx/
> > > +
> > > +Attributes
> > > +----------
> > > +
> > > +memory_size
> > > +                Total available physical SGX memory, also known as Enclave
> > > +                Page Cache (EPC), in bytes.
> > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > index a6e313f1a82d..4f1e3b5e3d14 100644
> > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > @@ -714,9 +714,11 @@ static bool __init sgx_page_cache_init(void)
> > >  			spin_lock_init(&sgx_numa_nodes[nid].lock);
> > >  			INIT_LIST_HEAD(&sgx_numa_nodes[nid].free_page_list);
> > >  			node_set(nid, sgx_numa_mask);
> > > +			sgx_numa_nodes[nid].size = 0;
> > >  		}
> > >  
> > >  		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
> > > +		sgx_numa_nodes[nid].size += size;
> > >  
> > >  		sgx_nr_epc_sections++;
> > >  	}
> > > @@ -790,6 +792,87 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
> > >  }
> > >  EXPORT_SYMBOL_GPL(sgx_set_attribute);
> > >  
> > > +#ifdef CONFIG_NUMA
> > > +static void sgx_numa_exit(void)
> > > +{
> > > +	int nid;
> > > +
> > > +	for (nid = 0; nid < num_possible_nodes(); nid++) {
> > > +		if (!sgx_numa_nodes[nid].kobj)
> > > +			continue;
> > > +
> > > +		kobject_put(sgx_numa_nodes[nid].kobj);
> > > +	}
> > > +}
> > > +
> > > +#define SGX_NODE_ATTR_RO(_name) \
> > > +	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
> > 
> > Why are you dealing with a "raw" kobject?  Shouldn't you have a device
> > and use a device attribute?
> > 
> > > +static bool sgx_numa_init(void)
> > > +{
> > > +	struct sgx_numa_node *node;
> > > +	struct device *dev;
> > > +	int nid;
> > > +	int ret;
> > > +
> > > +	for (nid = 0; nid < num_possible_nodes(); nid++) {
> > > +		if (!sgx_numa_nodes[nid].size)
> > > +			continue;
> > > +
> > > +		node = &sgx_numa_nodes[nid];
> > > +		dev = &node_devices[nid]->dev;
> > > +
> > > +		node->kobj = kobject_create_and_add("sgx", &dev->kobj);
> > 
> > You just "broke" the tree by putting a raw kobject below a struct
> > device.  Please do not do that.
> 
> I looked how hugetlb was implemented as a starting point, since it is
> existing mainline code, i.e. in mm/hugetlb.c:
> 
> - hugetlb_register_node()
> - hugetlb_register_all_nodes()
> - HSTATE_ATTR_RO()
> 
> hugetlb code attaches raw kobjects to the node device, by using this
> (perhaps anti)pattern.

Never look at the memory code for how to use sysfs "properly" :)

It deals with raw kobjects as it is not tied into the driver model at
all.  You are, so do not try to route around it, userspace will not be
happy with you if you do so.

> > 
> > > +		if (!node->kobj) {
> > > +			sgx_numa_exit();
> > > +			return false;
> > > +		}
> > > +
> > > +		ret = sysfs_create_group(node->kobj, &sgx_node_attr_group);
> > 
> > And you raced with userspace and lost.
> > 
> > Wait, you have a kobject _just_ for a subdirectory name?  Why?  Use a
> > named attribute group, that's exactly what that is for.
> > 
> > Properly attach your attributes to the device you have, don't do extra
> > work and complex code that you do not have to at all.
> 
> Here the reference was hugetlb_sysfs_init() and hugetlb_sysfs_add_hstate().
> Agreed, that a named group would make a lot more sense.

Again, ignore all sysfs code for the memory subsystem please :)

thanks,

greg k-h
