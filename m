Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC927C433F5
	for <linux-sgx@archiver.kernel.org>; Sun,  3 Apr 2022 10:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiDCKPm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 3 Apr 2022 06:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiDCKPl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 3 Apr 2022 06:15:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD43B12AC7
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 03:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F3FF60FFF
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 10:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD22C340ED;
        Sun,  3 Apr 2022 10:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648980826;
        bh=l6T4V/igern6pKJRbRB2VkPCORKw/w5RA2tWYQCOm/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c2brdX6Mvqy9S3PVDD3oWqjbe1fGyTkY0J3fbNJTq/r7BxYT3XrKOKCv5oJqRIWDP
         fNA3Q7bG7mPQSX3rFtiu7pQIFLP+55PGD6A3qHg5IiVSPDNG4Ay02H7U2QYHAinZvd
         kEkSmZIMmg51e029vSp8TXNW1uC7tN6hMUgb5D0BxKbegPQj+Oh5vGpKFG5TEHUHPY
         pwlB91ASzbzcQ7RIsb5ICW3A7bLU1Lk8mnzi2NzyWdE7NyVdz2Y1miX4DyFdt2pRiz
         5WzqKl/DAYlP1kI0esEx2rRcUuSxHpju4WFAJoVzCCGFmPiC+PAZWNUElWQejoHsP3
         Kc5ciOr/ChcHQ==
Date:   Sun, 3 Apr 2022 13:14:56 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com
Subject: Re: [RFC PATCH v3 05/10] x86/sgx: Save the size of each EPC section
Message-ID: <YklzoObeCWk1AX5L@kernel.org>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-6-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401142409.26215-6-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 01, 2022 at 10:24:04PM +0800, Cathy Zhang wrote:
> For SGX CPUSVN update process will check all EPC pages in each
> section to ensure they will be marked as unused, it requires to
> know the size of each EPC section to end the loop.

Why is the size required to end the loop? It's missing.

> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h  | 1 +
>  arch/x86/kernel/cpu/sgx/main.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 0b036f19cca1..45ba6fcabfda 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -63,6 +63,7 @@ struct sgx_epc_section {
>  	void *virt_addr;
>  	struct sgx_epc_page *pages;
>  	struct sgx_numa_node *node;
> +	u64 size;
>  };
>  
>  extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 10360f06c0df..031c1402cd7e 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -665,6 +665,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  	}
>  
>  	section->phys_addr = phys_addr;
> +	section->size = size;
>  	xa_store_range(&sgx_epc_address_space, section->phys_addr,
>  		       phys_addr + size - 1, section, GFP_KERNEL);
>  
> -- 
> 2.17.1
> 

BR, Jarkko
