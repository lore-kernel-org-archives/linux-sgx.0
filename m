Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BEFC433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Dec 2021 23:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbhL1XEe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 28 Dec 2021 18:04:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42544 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhL1XEd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 28 Dec 2021 18:04:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21576B80E71
        for <linux-sgx@vger.kernel.org>; Tue, 28 Dec 2021 23:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D73C36AEC;
        Tue, 28 Dec 2021 23:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640732670;
        bh=yux5p2nR35X5+Vwid26Kh5Rv3Cd1tYvdQ7r7hl3ND8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ub99nSKBR9x6AclgBRW/QYGO4tpBF+67phGGuNwOQB8s9+E0B1ybZWFhjXgUVaDli
         2ToO9+t9azGCeq8vufyJokKMypH25rR9SoLQyaemKaq0iO8En1pzWNaLB5l1/CvcKX
         i1bvxfs/cMdClZ9wQbRtZmhgchvdAJCyNDIF7bVlN3qpCrrxhFC2HNCxMPakd0JeAt
         8B1KJToJ9eh2+Ru53EghMDXCm2Msmf6SnZuTQaaDY7pPc2YKmZxD1lYcGoJORG5h1o
         nDCk8562O5sAAN3l7qNXbYUTIVUtB/ph3kfy81Dy4XMVocrrmuNZHGP2K8YG3imgJ7
         kHkUxQ6QyLKEg==
Date:   Wed, 29 Dec 2021 01:04:28 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86/sgx: Add accounting for tracking overcommit
Message-ID: <YcuX/DzVsAWvhEBA@iki.fi>
References: <20211220174640.7542-1-kristen@linux.intel.com>
 <20211220174640.7542-2-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211220174640.7542-2-kristen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 20, 2021 at 09:46:39AM -0800, Kristen Carlson Accardi wrote:
> When the system runs out of enclave memory, SGX can reclaim EPC pages
> by swapping to normal RAM. This normal RAM is allocated via a
> per-enclave shared memory area. The shared memory area is not mapped
> into the enclave or the task mapping it, which makes its memory use
> opaque (including to the OOM killer). Having lots of hard to find
> memory around is problematic, especially when there is no limit.
> 
> Introduce a module parameter and a global counter that can be used to limit
> the number of pages that enclaves are able to consume for backing storage.
> This parameter is a percentage value that is used in conjunction with the
> number of EPC pages in the system to set a cap on the amount of backing
> RAM that can be consumed.
> 
> The default for this value is 100, which limits the total number of
> shared memory pages that may be consumed by all enclaves as backing pages
> to the number of EPC pages on the system.
> 
> For example, on an SGX system that has 128MB of EPC, this default would
> cap the amount of normal RAM that SGX consumes for its shared memory
> areas at 128MB.
> 
> If sgx.overcommit_percent is set to a negative value (such as -1),
> SGX will not place any limits on the amount of overcommit that might
> be requested, and SGX will behave as it has previously without the
> overcommit_percent limit.
> 
> SGX may not be built as a module, but the module parameter interface
> is used in order to provide a convenient interface.
> 
> The SGX overcommit_percent works differently than the core VM overcommit
> limit. Enclaves request backing pages one page at a time, and the number
> of in use backing pages that are allowed is a global resource that is
> limited for all enclaves.
> 
> Introduce a pair of functions which can be used by callers when requesting
> backing RAM pages. These functions are responsible for accounting the
> page charges. A request may return an error if the request will cause the
> counter to exceed the backing page cap.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  7 ++
>  Documentation/x86/sgx.rst                     | 16 ++++-
>  arch/x86/kernel/cpu/sgx/Makefile              |  6 +-
>  arch/x86/kernel/cpu/sgx/main.c                | 64 +++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h                 |  2 +
>  5 files changed, 93 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 9725c546a0d4..9d23c05a833b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5165,6 +5165,13 @@
>  
>  	serialnumber	[BUGS=X86-32]
>  
> +	sgx.overcommit_percent=	[X86-64,SGX]
> +			Limits the amount of normal RAM used for backing
> +			storage that may be allocate, expressed as a
> +			percentage of the total number of EPC pages in the
> +			system.
> +			See Documentation/x86/sgx.rst for more information.
> +
>  	shapers=	[NET]
>  			Maximal number of shapers.
>  
> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> index 265568a9292c..4f9a1c68be94 100644
> --- a/Documentation/x86/sgx.rst
> +++ b/Documentation/x86/sgx.rst
> @@ -147,7 +147,21 @@ Page reclaimer
>  
>  Similar to the core kswapd, ksgxd, is responsible for managing the
>  overcommitment of enclave memory.  If the system runs out of enclave memory,
> -*ksgxd* “swaps” enclave memory to normal memory.
> +*ksgxd* “swaps” enclave memory to normal RAM. This normal RAM is allocated
> +via per enclave shared memory. The shared memory area is not mapped into the
> +enclave or the task mapping it, which makes its memory use opaque - including
> +to the system out of memory killer (OOM). This can be problematic when there
> +are no limits in place on the amount an enclave can allocate.
> +
> +At boot time, the module parameter "sgx.overcommit_percent" can be used to
> +place a limit on the number of shared memory backing pages that may be
> +allocated, expressed as a percentage of the total number of EPC pages in the
> +system.  A value of 100 is the default, and represents a limit equal to the
> +number of EPC pages in the system. To disable the limit, set
> +sgx.overcommit_percent to -1. The number of backing pages available to
> +enclaves is a global resource. If the system exceeds the number of allowed
> +backing pages in use, the reclaimer will be unable to swap EPC pages to
> +shared memory.
>  
>  Launch Control
>  ==============
> diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
> index 9c1656779b2a..72f9192a43fe 100644
> --- a/arch/x86/kernel/cpu/sgx/Makefile
> +++ b/arch/x86/kernel/cpu/sgx/Makefile
> @@ -1,6 +1,10 @@
> -obj-y += \
> +# This allows sgx to have module namespace
> +obj-y += sgx.o
> +
> +sgx-y += \
>  	driver.o \
>  	encl.o \
>  	ioctl.o \
>  	main.o
> +
>  obj-$(CONFIG_X86_SGX_KVM)	+= virt.o
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 2857a49f2335..c58ce9d9fd56 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*  Copyright(c) 2016-20 Intel Corporation. */
>  
> +#include <linux/moduleparam.h>
>  #include <linux/file.h>
>  #include <linux/freezer.h>
>  #include <linux/highmem.h>
> @@ -43,6 +44,54 @@ static struct sgx_numa_node *sgx_numa_nodes;
>  
>  static LIST_HEAD(sgx_dirty_page_list);
>  
> +/*
> + * Limits the amount of normal RAM that SGX can consume for EPC
> + * overcommit to the total EPC pages * sgx_overcommit_percent / 100
> + */
> +static int sgx_overcommit_percent = 100;
> +module_param_named(overcommit_percent, sgx_overcommit_percent, int, 0440);
> +MODULE_PARM_DESC(overcommit_percent, "Percentage of overcommit of EPC pages.");
> +
> +/* The number of pages that can be allocated globally for backing storage. */
> +static atomic_long_t sgx_nr_available_backing_pages;
> +static bool sgx_disable_overcommit_tracking;

I don't like the use of word tracking as we already have ETRACK. I'd also
shorten the first global as "sgx_nr_backing_pages".

Couldn't you set "sgx_nr_backing_pages" to -1 when capping is disabled, and
then you would not need that bool in the first place?

> +
> +/**
> + * sgx_charge_mem() - charge for a page used for backing storage
> + *

Please remove this empty line:

https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt

> + * Backing storage usage is capped by the sgx_nr_available_backing_pages.
> + * If the backing storage usage is over the overcommit limit,

Where does this verb "charge" come from?

/Jarkko
