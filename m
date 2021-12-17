Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFADC433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Dec 2021 22:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhLQW5U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Dec 2021 17:57:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49980 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhLQW5U (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 Dec 2021 17:57:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C317562425
        for <linux-sgx@vger.kernel.org>; Fri, 17 Dec 2021 22:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DAAC36AE5;
        Fri, 17 Dec 2021 22:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639781839;
        bh=bhTqfus2J6ultLuDd0zEiq+Q2WkdP91uGxTQyS0ioMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uJaibgS5if1KqmL3YKhDHKP6TOpMlqpJyaV+KbZVwUk2yOQHtTHbZhnTxtmbCi8Sy
         KTRtG11lAwxwoM8dJcCEgO94/NSS/+lmISRuS8kOqOfkGUXhIsH0h7QuynGU1q+e7/
         QfK5HbCyxcpBBxfWQlcUPBYyI6yQ6hZkTs8GHTl3f3a97isIT7nxIUwLOjO1zKIHzl
         DWmnqzanZSu04WRE8dXLe3q4X3PF/oWTLNiHK85h95h2NljMQtlW1oUsnVIIl4J7NL
         awj5lBbRTXyzs9zby3ehxAd1yQ6TXXqHcWw9q1sESSn8hdHx4JEDXw6gihTqvRzOhR
         qulX85LR6q9WQ==
Date:   Fri, 17 Dec 2021 15:57:15 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Dave Hansen <dave.hansen@linux.intel.com>
Cc:     dave@sr71.net, gregkh@linuxfoundation.org, jarkko@kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/sgx: Fix NULL pointer dereference on non-SGX systems
Message-ID: <Yb0Vy2Q2ifugclva@archlinux-ax161>
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

Tested-by: Nathan Chancellor <nathan@kernel.org>

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
>  static DEVICE_ATTR_RO(sgx_total_bytes);
>  
> _
