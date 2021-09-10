Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEA8C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 10 Sep 2021 06:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5503461167
	for <linux-sgx@archiver.kernel.org>; Fri, 10 Sep 2021 06:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhIJGxJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 10 Sep 2021 02:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231223AbhIJGxI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 10 Sep 2021 02:53:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6A3760F9C;
        Fri, 10 Sep 2021 06:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631256718;
        bh=M2BIei3PONXzybAxwQQL8UC7HatLwyKfEKfePJw8s74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d8uobNZ9/6oKqlPUAnGpOBoxKWFQdyKeKGrFb0M4b11/2BniwqgZ7giXr9e77YRKr
         DT0lhCE7KzoJmaHel+Pb4EqB38fSIGaS46NVqx/VwrHW7QDRvEThlmYWAx6tN6NVOB
         i3Y+Wvpj00NUzBrvd7DaEjXxM9shwcdWNWBVWsrI=
Date:   Fri, 10 Sep 2021 08:51:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] x86/sgx: Report SGX memory in
 /sys/devices/system/node/node*/meminfo
Message-ID: <YTsAjCZQ6AaWDjD1@kroah.com>
References: <20210910001726.811497-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910001726.811497-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 10, 2021 at 03:17:24AM +0300, Jarkko Sakkinen wrote:
> The amount of SGX memory on the system is determined by the BIOS and it
> varies wildly between systems.  It can be from dozens of MB's on desktops
> or VM's, up to many GB's on servers.  Just like for regular memory, it is
> sometimes useful to know the amount of usable SGX memory in the system.
> 
> Add SGX_MemTotal field to /sys/devices/system/node/node*/meminfo,
> showing the total SGX memory in each NUMA node. The total memory for
> each NUMA node is calculated by adding the sizes of contained EPC
> sections together.
> 
> Introduce arch_node_read_meminfo(), which can optionally be rewritten by
> the arch code, and rewrite it for x86 so it prints SGX_MemTotal.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> v4:
> * A new patch.
>  arch/x86/kernel/cpu/sgx/main.c | 14 ++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h  |  6 ++++++
>  drivers/base/node.c            | 10 +++++++++-
>  3 files changed, 29 insertions(+), 1 deletion(-)

Where is the Documentation/ABI/ update for this new sysfs file?

> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 63d3de02bbcc..4c6da5f4a9d4 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -717,6 +717,7 @@ static bool __init sgx_page_cache_init(void)
>  		}
>  
>  		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
> +		sgx_numa_nodes[nid].size += size;
>  
>  		sgx_nr_epc_sections++;
>  	}
> @@ -790,6 +791,19 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
>  }
>  EXPORT_SYMBOL_GPL(sgx_set_attribute);
>  
> +ssize_t arch_node_read_meminfo(struct device *dev,
> +			       struct device_attribute *attr,
> +			       char *buf, int len)
> +{
> +	struct sgx_numa_node *node = &sgx_numa_nodes[dev->id];
> +
> +	len += sysfs_emit_at(buf, len,
> +			     "Node %d SGX_MemTotal:   %8lu kB\n",
> +			     dev->id, node->size);

Wait, that is not how sysfs files work.  they are "one value per file"
Please do not have multiple values in a single sysfs file, that is not
acceptable at all.

thanks,

greg k-h
