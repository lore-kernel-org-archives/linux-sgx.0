Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D559BC433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Nov 2021 08:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B206A6109F
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Nov 2021 08:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhKCIZU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Nov 2021 04:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbhKCIZR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 3 Nov 2021 04:25:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91821601FC;
        Wed,  3 Nov 2021 08:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635927761;
        bh=jB1oQc4X9bCxQYTLeI8yPhECIICcB3cUpkpJwLMffJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ao7JOURoTAIbwPbB/gdZy/Iz4sBaEKGflBxjndFwE5KG5rSOVizLjO09kXoInOoAT
         KPmQRAmL6o0+TzacTvqPV1H8NSDaFnXXa2MUddJsFwOHifHdIaNVfQKq4dinr8wdv+
         7hi+05awpeEyIvj650KmyiQhH634vlbFiZmMah0E=
Date:   Wed, 3 Nov 2021 09:22:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, reinette.chatre@intel.com,
        tony.luck@intel.com, nathaniel@profian.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH v11 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
Message-ID: <YYJGzgkLJs6819t8@kroah.com>
References: <20211103012813.670195-1-jarkko@kernel.org>
 <20211103012813.670195-2-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103012813.670195-2-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 03, 2021 at 03:28:13AM +0200, Jarkko Sakkinen wrote:
> The amount of SGX memory on the system is determined by the BIOS and it
> varies wildly between systems.  It can be from dozens of MB's on desktops
> or VM's, up to many GB's on servers.  Just like for regular memory, it is
> sometimes useful to know the amount of usable SGX memory in the system.
> 
> Introduce CONFIG_HAVE_ARCH_NODE_DEV_GROUP opt-in flag to expose an arch
> specific attribute group, and add an attribute for the amount of SGX
> memory in bytes to each NUMA node:
> 
> /sys/devices/system/node/nodeX/x86/sgx_total_bytes
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> v11:
> * Fix documentation and the commit message.
> 
> v10:
> * Change DEVICE_ATTR_RO() to static (Greg K-H)
> * Change the attribute name as sgx_total_bytes, and attribute group
>   name as "x86" (Dave).
> * Add a new config flag HAVE_ARCH_NODE_DEV_GROUP to identify, whether
>   an arch exports arch specific attribute group for NUMA nodes.
> 
> v9:
> * Fix racy initialization of sysfs attributes:
>   https://lore.kernel.org/linux-sgx/YXOsx8SvFJV5R7lU@kroah.com/
> 
> v8:
> * Fix a bug in sgx_numa_init(): node->dev should be only set after
>   sysfe_create_group().  Otherwise, sysfs_remove_group() will issue a
>   warning in sgx_numa_exit(), when sgx_create_group() is unsuccessful,
>   because the group does not exist.
> 
> v7:
> * Shorten memory_size to size. The prefix makes the name only longer
>   but does not clarify things more than "size" would.
> * Use device_attribute instead of kobj_attribute.
> * Use named attribute group instead of creating raw kobject just for
>   the "sgx" subdirectory.
> 
> v6:
> * Initialize node->size to zero in sgx_setup_epc_section(), when the
>   node is first accessed.
> 
> v5
> * A new patch based on the discussion on
>   https://lore.kernel.org/linux-sgx/3a7cab4115b4f902f3509ad8652e616b91703e1d.camel@kernel.org/T/#t
> ---
>  Documentation/ABI/stable/sysfs-devices-node |  6 ++++
>  arch/Kconfig                                |  4 +++
>  arch/x86/Kconfig                            |  1 +
>  arch/x86/kernel/cpu/sgx/main.c              | 31 +++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h               |  2 ++
>  drivers/base/node.c                         | 13 ++++++++-
>  include/linux/numa.h                        |  4 +++
>  7 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
> index 484fc04bcc25..8db67aa472f1 100644
> --- a/Documentation/ABI/stable/sysfs-devices-node
> +++ b/Documentation/ABI/stable/sysfs-devices-node
> @@ -176,3 +176,9 @@ Contact:	Keith Busch <keith.busch@intel.com>
>  Description:
>  		The cache write policy: 0 for write-back, 1 for write-through,
>  		other or unknown.
> +
> +What:		/sys/devices/system/node/nodeX/x86/sgx_total_bytes
> +Date:		November 2021
> +Contact:	Jarkko Sakkinen <jarkko@kernel.org>
> +Description:
> +		The total amount of SGX physical memory in bytes.
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 98db63496bab..ca5d75b5a427 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -1285,6 +1285,10 @@ config ARCH_HAS_ELFCORE_COMPAT
>  config ARCH_HAS_PARANOID_L1D_FLUSH
>  	bool
>  
> +# Select, if arch has a named attribute group bound to NUMA device nodes.
> +config HAVE_ARCH_NODE_DEV_GROUP
> +	bool
> +
>  source "kernel/gcov/Kconfig"
>  
>  source "scripts/gcc-plugins/Kconfig"
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 421fa9e38c60..8503c3bdf63f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -266,6 +266,7 @@ config X86
>  	select HAVE_ARCH_KCSAN			if X86_64
>  	select X86_FEATURE_NAMES		if PROC_FS
>  	select PROC_PID_ARCH_STATUS		if PROC_FS
> +	select HAVE_ARCH_NODE_DEV_GROUP		if X86_SGX
>  	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>  
>  config INSTRUCTION_DECODER
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index a6e313f1a82d..02ebb233c511 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -714,9 +714,12 @@ static bool __init sgx_page_cache_init(void)
>  			spin_lock_init(&sgx_numa_nodes[nid].lock);
>  			INIT_LIST_HEAD(&sgx_numa_nodes[nid].free_page_list);
>  			node_set(nid, sgx_numa_mask);
> +			sgx_numa_nodes[nid].size = 0;
>  		}
>  
>  		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
> +		sgx_numa_nodes[nid].dev = &node_devices[nid]->dev;

You are saving off a pointer to an object without incrementing the
reference count of it?  What prevents it from going away in the future?

> +		sgx_numa_nodes[nid].size += size;
>  
>  		sgx_nr_epc_sections++;
>  	}
> @@ -790,6 +793,34 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
>  }
>  EXPORT_SYMBOL_GPL(sgx_set_attribute);
>  
> +#ifdef CONFIG_NUMA
> +static ssize_t sgx_total_bytes_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	unsigned long size = 0;
> +	int nid;
> +
> +	for (nid = 0; nid < num_possible_nodes(); nid++) {
> +		if (dev == sgx_numa_nodes[nid].dev) {

Why aren't these values all just part of the device that is being used
here?  You are walking some odd array, with no locking, and no reference
counting on the objects you are looking at, just to find the same object
that you started out with???

That's not the proper thing to do here at all, these values should be
part of the device structure that this attribute lives on, in order to
properly handle all of these reference counting and locking issues
automatically.

Please fix the design of this code first, _before_ adding new
attributes.

thanks,

greg k-h
