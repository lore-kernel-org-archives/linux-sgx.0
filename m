Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC51C433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Dec 2021 23:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhLQXPq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Dec 2021 18:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhLQXPq (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 Dec 2021 18:15:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FC9C061574
        for <linux-sgx@vger.kernel.org>; Fri, 17 Dec 2021 15:15:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D2B5B82B2B
        for <linux-sgx@vger.kernel.org>; Fri, 17 Dec 2021 23:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB48C36AE2;
        Fri, 17 Dec 2021 23:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639782942;
        bh=bwZM8q8dcdnkaJIHCGAMFbNKGTlaPXxXvdVRnLhTX8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NT6CEP5ADDNvx99pYWJxAG0649Ip2UiOu6OFqS2IcLthIt9U6ZJMrYNxQB1tsy9Qk
         QXEBbqCcsF2ulWuKl7pue7DxXdoNLLj6HkyXk/JlazDTtjF4m6IJW0h40HTMbkGkK8
         tzru5iaOmNxhWQcb2fUGe7no77+2dxAfznhdWP38=
Date:   Sat, 18 Dec 2021 00:15:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Hansen <dave.hansen@linux.intel.com>
Cc:     dave@sr71.net, nathan@kernel.org, jarkko@kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/sgx: Fix NULL pointer dereference on non-SGX systems
Message-ID: <Yb0aHOuXV0L/691i@kroah.com>
References: <20211217223153.837591E0@davehans-spike.ostc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217223153.837591E0@davehans-spike.ostc.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 17, 2021 at 02:31:53PM -0800, Dave Hansen wrote:
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
> Add a check to ensure that SGX has been initialized to the point
> where sgx_numa_nodes[] is allocated, before accessing it.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: linux-sgx@vger.kernel.org
> Cc: x86@kernel.org
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
> 
>  b/arch/x86/kernel/cpu/sgx/main.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff -puN arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr arch/x86/kernel/cpu/sgx/main.c
> --- a/arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr	2021-12-17 13:38:00.217312383 -0800
> +++ b/arch/x86/kernel/cpu/sgx/main.c	2021-12-17 14:00:36.293044390 -0800
> @@ -906,7 +906,13 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
>  #ifdef CONFIG_NUMA
>  static ssize_t sgx_total_bytes_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
> -	return sysfs_emit(buf, "%lu\n", sgx_numa_nodes[dev->id].size);
> +	unsigned long node_bytes = 0;
> +
> +	/* Avoid acccessing sgx_numa_nodes[] when it is not allocated: */
> +	if (!nodes_empty(sgx_numa_mask))
> +		node_bytes = sgx_numa_nodes[dev->id].size;
> +
> +	return sysfs_emit(buf, "%lu\n", node_bytes);
>  }

Why is this file showing up if we do not have sgx_numa_nodes not
allocated?  It shouldn't even be there to access then.

don't return a fake number, just don't present the sysfs file at all.

thanks,

greg k-h
