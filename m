Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC21C433EF
	for <linux-sgx@archiver.kernel.org>; Sun,  3 Apr 2022 10:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347565AbiDCKMC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 3 Apr 2022 06:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiDCKMC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 3 Apr 2022 06:12:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EBF35A90
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 03:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71958B80CD3
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 10:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B24C340ED;
        Sun,  3 Apr 2022 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648980606;
        bh=Kz4SES6mwrwbatcxdMzTXo2ook9M0kNlMY2swQU4qw8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mg8+uIfzrn0ZS0wrXHRxhSHUOWp+5wI0KU2pwBGoR7VbEl+/r7GS3LcJxmm2NqJo/
         umx7DIm9jntvsQHEawAttmqA3lJwlUlPcJPiy4MGksV6/YLrt+j66RBMSOBdv4wTIy
         Y8UP3qqrD/PrSMYPmBiRYICuUI3Az7EegV/yONl3Ei0Oxm+8gyUa59MWRf1UHuBuvG
         /QoBKmGcn88J3QWC3eJHwKS2JXzMyv6E8JbZdn+zd5ig2KNgVJzPZbbQb4rbCb8Jtc
         Eh/SuZ1ig4xbVR9xx7hTFT6LehkS1jQTXvgthUfvcbGY/SrLUE75YMJMzxvZzM5s94
         Cxt+JrTYeNL7g==
Date:   Sun, 3 Apr 2022 13:11:15 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com
Subject: Re: [RFC PATCH v3 04/10] x86/sgx: Keep record for SGX VA and Guest
 page type
Message-ID: <Yklywz249ykoWL5U@kernel.org>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-5-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401142409.26215-5-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 01, 2022 at 10:24:03PM +0800, Cathy Zhang wrote:
> Regular enclave EPC pages have sgx_encl_page as their owner, but
> SGX VA page and KVM guest EPC page are maintained by different
> owner structures.
> 
> SGX CPUSVN update requires to know the EPC page owner's status
> and then decide how to handle the page.
> 
> Keep a record of page type for SGX VA and KVM guest page while
> the other EPC pages already have their type tracked, so that
> CPUSVN update can get EPC page's owner by type and handle it then.
> 
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h  | 4 ++++
>  arch/x86/kernel/cpu/sgx/encl.c | 2 ++
>  arch/x86/kernel/cpu/sgx/virt.c | 2 ++
>  3 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index f8ed9deac18b..0b036f19cca1 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -28,6 +28,10 @@
>  
>  /* Pages on free list */
>  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
> +/* VA page */
> +#define SGX_EPC_PAGE_VA			BIT(2)
> +/* Pages allocated for KVM guest */
> +#define SGX_EPC_PAGE_GUEST		BIT(3)

Please rename this as either SGX_EPC_PAGE_KVM_GUEST or SGX_EPC_PAGE_KVM.
Then it is hard to not remember what it is.

BR, Jarkko
