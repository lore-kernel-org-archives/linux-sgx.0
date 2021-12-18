Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC56C433F5
	for <linux-sgx@archiver.kernel.org>; Sat, 18 Dec 2021 00:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhLRAHj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Dec 2021 19:07:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52202 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhLRAHj (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 Dec 2021 19:07:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F7A462440
        for <linux-sgx@vger.kernel.org>; Sat, 18 Dec 2021 00:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F47C36AE5;
        Sat, 18 Dec 2021 00:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639786058;
        bh=pj8lysYKepAv6hYIG32APepOotYuEsSpbHdpfqXzdbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oN5yQuc9oT2DhB2nmASpKod+HGFvD/Er2NCM9OGo6EpRV5VOrfh2slRnFlqUiok2W
         NnkmBx1IpOyuYvyPWXT4GtJl0geduVzUwZe4CI1KgwIUYOhpPQYxwgqJL3Gi58gJ6c
         2uvTfk4JFYA4ZJyaeiIY5jN+1ZHmA8HEXXpmWDkg=
Date:   Sat, 18 Dec 2021 01:07:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, dave@sr71.net,
        nathan@kernel.org, jarkko@kernel.org, linux-sgx@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH] x86/sgx: Fix NULL pointer dereference on non-SGX systems
Message-ID: <Yb0mR5kZQyACcqXu@kroah.com>
References: <20211217223153.837591E0@davehans-spike.ostc.intel.com>
 <Yb0aHOuXV0L/691i@kroah.com>
 <Yb0dpXI7q0PmABk6@kroah.com>
 <745c9724-531d-8138-801a-2b00e51c1fbf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <745c9724-531d-8138-801a-2b00e51c1fbf@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 17, 2021 at 03:55:44PM -0800, Dave Hansen wrote:
> On 12/17/21 3:30 PM, Greg KH wrote:
> >>>
> >>> diff -puN arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr arch/x86/kernel/cpu/sgx/main.c
> >>> --- a/arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr	2021-12-17 13:38:00.217312383 -0800
> >>> +++ b/arch/x86/kernel/cpu/sgx/main.c	2021-12-17 14:00:36.293044390 -0800
> >>> @@ -906,7 +906,13 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
> >>>  #ifdef CONFIG_NUMA
> >>>  static ssize_t sgx_total_bytes_show(struct device *dev, struct device_attribute *attr, char *buf)
> >>>  {
> >>> -	return sysfs_emit(buf, "%lu\n", sgx_numa_nodes[dev->id].size);
> >>> +	unsigned long node_bytes = 0;
> >>> +
> >>> +	/* Avoid acccessing sgx_numa_nodes[] when it is not allocated: */
> >>> +	if (!nodes_empty(sgx_numa_mask))
> >>> +		node_bytes = sgx_numa_nodes[dev->id].size;
> >>> +
> >>> +	return sysfs_emit(buf, "%lu\n", node_bytes);
> >>>  }
> >> Why is this file showing up if we do not have sgx_numa_nodes not
> >> allocated?  It shouldn't even be there to access then.
> >>
> >> don't return a fake number, just don't present the sysfs file at all.
> > Or, if you _have_ to have the file present, return an error instead of a
> > fake value.
> > 
> > But really, only create the file if the system supports it, that's the
> > rule for sysfs and it makes it very easy to do so (see the is_visible
> > callback for the attribute group for how to do it.)
> 
> Thanks for the suggestion!  That's a lot nicer.  It's also dirt simple
> since we only have one attribute.  Updated patch is attached.
> 
> I'll send this out as a real v2 soon if no other issues pop up.

> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Nathan Chancellor reported an oops when aceessing the
> 'sgx_total_bytes' sysfs file:
> 
> 	https://lore.kernel.org/all/YbzhBrimHGGpddDM@archlinux-ax161/
> 
> The sysfs output code accesses the sgx_numa_nodes[] array
> unconditionally.  However, this array is allocated during SGX
> initialization, which only occurs on systems where SGX is
> supported.
> 
> If the sysfs file is accessed on systems without SGX support,
> sgx_numa_nodes[] is NULL and an oops occurs.
> 
> To fix this, hide the entire nodeX/x86/ attribute group on
> systems without SGX support using the ->is_visible attribute
> group callback.
> 
> Fixes: 50468e431335 ("x86/sgx: Add an attribute for the amount of SGX memory in a NUMA node")
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: linux-sgx@vger.kernel.org
> Cc: x86@kernel.org
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
> 
>  b/arch/x86/kernel/cpu/sgx/main.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff -puN arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr arch/x86/kernel/cpu/sgx/main.c
> --- a/arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr	2021-12-17 13:38:00.217312383 -0800
> +++ b/arch/x86/kernel/cpu/sgx/main.c	2021-12-17 15:48:10.358932505 -0800
> @@ -910,6 +910,13 @@ static ssize_t sgx_total_bytes_show(stru
>  }
>  static DEVICE_ATTR_RO(sgx_total_bytes);
>  
> +static umode_t arch_node_attr_is_visible(struct kobject * kobj,
> +		struct attribute * attr, int idx)
> +{
> +	/* Make all x86/ attributes invisible when SGX is not initialized: */
> +	return !nodes_empty(sgx_numa_mask);

That's a very odd umode_t return value :)

Did you test this?  What was the mode of the sysfs file that is created?

thanks,

greg k-h
