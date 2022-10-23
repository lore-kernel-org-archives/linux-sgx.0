Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F18C3A59D
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Oct 2022 21:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJWVXk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Oct 2022 17:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJWVXj (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 23 Oct 2022 17:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D30310052
        for <linux-sgx@vger.kernel.org>; Sun, 23 Oct 2022 14:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 980FF60F71
        for <linux-sgx@vger.kernel.org>; Sun, 23 Oct 2022 21:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FC8C433C1;
        Sun, 23 Oct 2022 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666560217;
        bh=Y18IPXPk8t8sNyAva8nuSRktjxeLDr3cy2HG4nljYi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tbq2816qzSGgO1AoZ4fHcvN6CbTpdfxP6yjqE6JcP36IIktZozvI4aA0znongcgbg
         3LYDiexoznArlthOYy4dFozU0/nkd3TU8ueEbLkx2/DDjScYHy04MRLsHEgu0qBZGz
         Qn3URQFCn19qNusSNRjX2m/uC9XXbHe3C/PdWnBttbbqGMSKTL5/mHJ2Mq1RrSUbHc
         GIyMjlntCn4tIcv36my+puIwH+2g9usz1sQoujuikf2wVVMN/WIs/DklBiwVCyBwWw
         MevMHamLWsS3LcZwF7TM7dcDvIuA7ihOFrddyPdajdkuNdjI7XN3laazAKfwTwEAf+
         9kGfb9gku5ozw==
Date:   Mon, 24 Oct 2022 00:23:30 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH 2/4] x86/sgx: Implement support for MADV_WILLNEED
Message-ID: <Y1Ww0vEHcQDitaYJ@kernel.org>
References: <20221019191413.48752-1-haitao.huang@linux.intel.com>
 <20221019191413.48752-2-haitao.huang@linux.intel.com>
 <20221019191413.48752-3-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019191413.48752-3-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 19, 2022 at 12:14:11PM -0700, Haitao Huang wrote:
> Add support for madvise(..., MADV_WILLNEED) by adding
> pages with EAUG. Implement fops->fadvise() callback to
> achieve this behaviour.
> 
> Note this is only done with best effort possible. If any
> errors encountered or EPC is under swapping, the operation
> will stop and return as normal.
> 
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver.c | 81 ++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index aa9b8b868867..54b24897605b 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -2,6 +2,7 @@
>  /*  Copyright(c) 2016-20 Intel Corporation. */
>  
>  #include <linux/acpi.h>
> +#include <linux/fadvise.h>
>  #include <linux/miscdevice.h>
>  #include <linux/mman.h>
>  #include <linux/security.h>
> @@ -9,6 +10,7 @@
>  #include <asm/traps.h>
>  #include "driver.h"
>  #include "encl.h"
> +#include "encls.h"
>  
>  u64 sgx_attributes_reserved_mask;
>  u64 sgx_xfrm_reserved_mask = ~0x3;
> @@ -97,10 +99,88 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
>  	vma->vm_ops = &sgx_vm_ops;
>  	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
>  	vma->vm_private_data = encl;
> +	/* Anchor vm_pgoff to the enclave base.
> +	 * So offset passed back to sgx_fadvise hook
> +	 * is relative to the enclave base
> +	 */
> +	vma->vm_pgoff = (vma->vm_start - encl->base) >> PAGE_SHIFT;
>  
>  	return 0;
>  }
>  
> +/*
> + * Add new pages to the enclave sequentially with ENCLS[EAUG] for the WILLNEED advice.
> + * Only do this to existing VMAs in the same enclave and reject the request.
> + * Returns:	0 if EAUG done with best effort, -EINVAL if any sub-range given
> + * is not in the enclave, or enclave is not initialized..
> + */
> +static int sgx_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
> +{
> +	struct sgx_encl *encl = file->private_data;
> +	unsigned long start, end, pos;
> +	int ret = -EINVAL;
> +	struct vm_area_struct *vma = NULL;
> +
> +	/* Only support WILLNEED */
> +	if (advice != POSIX_FADV_WILLNEED)
> +		return -EINVAL;
> +	if (!encl)
> +		return -EINVAL;
> +	if (!cpu_feature_enabled(X86_FEATURE_SGX2))
> +		return -EINVAL;
> +
> +	if (offset + len < offset)
> +		return -EINVAL;
> +	if (encl->base + offset < encl->base)
> +		return -EINVAL;
> +	start  = offset + encl->base;
> +	end = start + len;
> +	if (end < start)
> +		return -EINVAL;
> +	if (end > encl->base + encl->size)
> +		return -EINVAL;
> +
> +	/* EAUG works only for initialized enclaves. */
> +	if (!test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
> +		return -EINVAL;
> +
> +	mmap_read_lock(current->mm);
> +
> +	vma = find_vma(current->mm, start);
> +	if (!vma)
> +		goto unlock;
> +	if (vma->vm_private_data != encl)
> +		goto unlock;
> +
> +	pos = start;
> +	if (pos < vma->vm_start || end > vma->vm_end) {
> +		/* Don't allow any gaps */
> +		goto unlock;
> +	}
> +	/* Here: vm_start <= pos < end <= vm_end */
> +	while (pos < end) {
> +		if (xa_load(&encl->page_array, PFN_DOWN(pos)))
> +			continue;
> +		if (signal_pending(current)) {
> +			if (pos == start)
> +				ret = -ERESTARTSYS;
> +			else
> +				ret = -EINTR;
> +			goto unlock;
> +		}
> +		ret = sgx_encl_eaug_page(vma, encl, pos);

You should instead just do the export in the previous commit,
and convert the return values here. Less pollution to the
existing code base.

> +		/* It's OK to not finish */
> +		if (ret)
> +			break;
> +		pos = pos + PAGE_SIZE;
> +		cond_resched();
> +	}
> +	ret = 0;
> +unlock:
> +	mmap_read_unlock(current->mm);
> +	return ret;
> +}
> +
>  static unsigned long sgx_get_unmapped_area(struct file *file,
>  					   unsigned long addr,
>  					   unsigned long len,
> @@ -133,6 +213,7 @@ static const struct file_operations sgx_encl_fops = {
>  	.compat_ioctl		= sgx_compat_ioctl,
>  #endif
>  	.mmap			= sgx_mmap,
> +	.fadvise		= sgx_fadvise,
>  	.get_unmapped_area	= sgx_get_unmapped_area,
>  };
>  
> -- 
> 2.25.1
> 
