Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F68C43219
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 00:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B25238A0
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 00:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732671AbhAUAHP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 19:07:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732384AbhATWdA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Jan 2021 17:33:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D05122473;
        Wed, 20 Jan 2021 22:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611181917;
        bh=IZpZup+7UVJmyznAHqT5zPuIOVNplTanitrN87XcENQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KwC0JeacdrJ9LXB4DLrYNvG1UWPLOKtQNEEHroZ40vf2MbOcwg7s6hpJbLR8Gy3WX
         XZFEYY4qiVIU4t+VPH9r0cDDDV6As1d8Wvt0aj4rBoixMdHeVUTvKsHLuIRGPNSQAk
         ArIZKhC3fvn4kEjz7zGv7kjliP8Ha8wjmrqwlw2cujiDjPvqEDuwjxIZdHB4JIkxpR
         hNxcwCwPhM/xfLC5L+JhXPj3zqYOU0qhTr/T34gD7tshp9okYz9F7uWqgd2FtO9x8m
         Y8llKWlB3aoo0LNjX8RQJsGHhGEAx74KdgSbBMDJKKH3caZZB+lY2ER3UYFXIWFjy2
         kMk9itOxx3uug==
Date:   Thu, 21 Jan 2021 00:31:52 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Subject: Re: [PATCH v2] x86/sgx: Fix free_cnt counting logic in epc section
Message-ID: <YAivWK/b/Mcz39JO@kernel.org>
References: <20210120035320.19709-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120035320.19709-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 20, 2021 at 11:53:20AM +0800, Tianjia Zhang wrote:
> Increase `section->free_cnt` in sgx_sanitize_section() is more
> reasonable, which is called in ksgxd kernel thread, instead of

This is lacking reasoning of why.

/Jarkko

> assigning it to epc section pages number at initialization.
> Although this is unlikely to fail, these pages cannot be
> allocated after initialization, and which need to be reset
> by ksgxd.
> 
> At the same time, taking section->lock could be moved inside
> the !ret flow so that EREMOVE is done without holding the lock.
> it's theoretically possible that ksgxd hasn't finished
> sanitizing the EPC when userspace starts creating enclaves.
> 
> Reported-by: Jia Zhang <zhang.jia@linux.alibaba.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index c519fc5f6948..34a72a147983 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -41,16 +41,18 @@ static void sgx_sanitize_section(struct sgx_epc_section *section)
>  		if (kthread_should_stop())
>  			return;
>  
> -		/* needed for access to ->page_list: */
> -		spin_lock(&section->lock);
> -
>  		page = list_first_entry(&section->init_laundry_list,
>  					struct sgx_epc_page, list);
>  
>  		ret = __eremove(sgx_get_epc_virt_addr(page));
> -		if (!ret)
> +
> +		/* needed for access to ->page_list: */
> +		spin_lock(&section->lock);
> +
> +		if (!ret) {
>  			list_move(&page->list, &section->page_list);
> -		else
> +			section->free_cnt += 1;
> +		} else
>  			list_move_tail(&page->list, &dirty);
>  
>  		spin_unlock(&section->lock);
> @@ -646,7 +648,6 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  		list_add_tail(&section->pages[i].list, &section->init_laundry_list);
>  	}
>  
> -	section->free_cnt = nr_pages;
>  	return true;
>  }
>  
> -- 
> 2.19.1.3.ge56e4f7
> 
> 
