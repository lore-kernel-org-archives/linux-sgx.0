Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017A7C433E6
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 05:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B510C64F10
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 05:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhCSFn3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Mar 2021 01:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhCSFm6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Mar 2021 01:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9AA164DCC;
        Fri, 19 Mar 2021 05:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616132578;
        bh=eUscbhRfkwQ3BScJNzBWpmoaoPTaH2/CrSy667cXmSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tgqo1fiAkRoibCXJIE+kRXm9B7zHFlQ3ZjkYujbyCmY/dDEE0Jy62q6f9XXHt4iIO
         /p23bnuLpXB29+L+t3a70FztoobrfKvnmT0Bs1saabnWd5AfaTGDAlt8Xo70I0G34/
         d0ZZJZRz+N53xxtXUF/HDClQdzyjJVEmAxDJHb5NYlSFrlPOW0yjOFNNxSi4KpHyz+
         ibM33xZZQNJIerRMOx6TVMCPKGq2OwKzZv63v542d1a1I3cOGUP2Uf2gx+phrVEzcv
         lkgm2gw/7bksxlh3HS+1ofIrAfbfBnso20XPGttISS7t0j3moc6w016C1YOxuSHJZg
         LuaAb2k8uy4Rw==
Date:   Fri, 19 Mar 2021 07:42:31 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Avoid returning NULL in __sgx_alloc_epc_page()
Message-ID: <YFQ5x8cTPIlywDtW@kernel.org>
References: <20210319040602.178558-1-kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319040602.178558-1-kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 19, 2021 at 05:06:02PM +1300, Kai Huang wrote:
> Below kernel bug happened when running simple SGX application when EPC
> is under pressure.  The root cause is with commit 5b8719504e3a
> ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()"),
> __sgx_alloc_epc_page() returns NULL when there's no free EPC page can be
> allocated, while old behavior was it always returned ERR_PTR(-ENOMEM) in
> such case.
> 
> Fix by directly returning the page if __sgx_alloc_epc_page_from_node()
> allocates a valid page in fallback to non-local allocation, and always
> returning ERR_PTR(-ENOMEM) if no EPC page can be allocated.
> 
> [  253.474764] BUG: kernel NULL pointer dereference, address: 0000000000000008
> [  253.500101] #PF: supervisor write access in kernel mode
> [  253.525462] #PF: error_code(0x0002) - not-present page
> ...
> [  254.102041] Call Trace:
> [  254.126699]  sgx_ioc_enclave_add_pages+0x241/0x770
> [  254.151305]  sgx_ioctl+0x194/0x4b0
> [  254.174976]  ? handle_mm_fault+0xd0/0x260
> [  254.198470]  ? do_user_addr_fault+0x1ef/0x570
> [  254.221827]  __x64_sys_ioctl+0x91/0xc0
> [  254.244546]  do_syscall_64+0x38/0x90
> [  254.266728]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  254.289232] RIP: 0033:0x7fdc4cf4031b
> ...
> [  254.711480] CR2: 0000000000000008
> [  254.735494] ---[ end trace 970dce6d4cdf7f64 ]---
> [  254.759915] RIP: 0010:sgx_alloc_epc_page+0x46/0x152
> ...
> 
> Fixes: 5b8719504e3a("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
> Signed-off-by: Kai Huang <kai.huang@intel.com>


Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

> ---
>  arch/x86/kernel/cpu/sgx/main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index fe26e7e91c25..7105e34da530 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -508,10 +508,10 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
>  
>  		page = __sgx_alloc_epc_page_from_node(nid);
>  		if (page)
> -			break;
> +			return page;
>  	}
>  
> -	return page;
> +	return ERR_PTR(-ENOMEM);
>  }
>  
>  /**
> -- 
> 2.30.2
> 
> 

/Jarkko
