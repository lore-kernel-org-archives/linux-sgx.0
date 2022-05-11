Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97610C433F5
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 10:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238346AbiEKKjA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 06:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239579AbiEKKi6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 06:38:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC299B1BA
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 03:38:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE9B7B821F4
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 10:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50503C340F0;
        Wed, 11 May 2022 10:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652265502;
        bh=ovkWqNG5N8T68kguNJbjavHrhuA1+4pPpMRG8l7Gq+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rKjAtPgK6K/6IWZdgdxjHJv21InHPvHWHrG9UyzlvZCVoJ3oPJXfa/Bm7vD0lakv0
         UMmxt9OvKzGFmskQWCEBcCdzf2QWkawTCvc9wyWt4Fj0QPX09E3qczeafX7Xd9t1bo
         /uGGDEC3b7xRBUfUZZvOGfNlbU4mXbcPcbfAofofWChy/FvYIvdyDdq0XKu8E/sU4P
         GkMLhE9ASpf10eUl+mHcqgWvLFXQ7gwkKUZopH6FkUZBZIw3o8iugzu2SiIfc6lvtn
         biRSwTaEV6PjnkgWUD3rpm+UpNnrumEwRFJgx59/zCWf8vjJJIYH+ve7HM5ofA1Wjz
         6luihG5g91cIQ==
Date:   Wed, 11 May 2022 13:36:52 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        haitao.huang@intel.com
Subject: Re: [PATCH V2 5/5] x86/sgx: Ensure no data in PCMD page after
 truncate
Message-ID: <YnuRxPqhOkWOAXjk@kernel.org>
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <bca979301e2fbb55c314fed29c06e72e82074fba.1652131695.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bca979301e2fbb55c314fed29c06e72e82074fba.1652131695.git.reinette.chatre@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, May 09, 2022 at 02:48:03PM -0700, Reinette Chatre wrote:
> A PCMD (Paging Crypto MetaData) page contains the PCMD
> structures of enclave pages that have been encrypted and
> moved to the shmem backing store. When all enclave pages
> sharing a PCMD page are loaded in the enclave, there is no
> need for the PCMD page and it can be truncated from the
> backing store.
> 
> A few issues appeared around the truncation of PCMD pages. The
> known issues have been addressed but the PCMD handling code could
> be made more robust by loudly complaining if any new issue appears
> in this area.
> 
> Add a check that will complain once with a WARN if the PCMD page is not
> actually empty after it has been truncated. There should never be data
> in the PCMD page at this point since it is always updated with the
> enclave mutex held.
> 
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index d1d4e8572702..af972dbad965 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -183,12 +183,19 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	kunmap_atomic(pcmd_page);
>  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>  
> +	get_page(b.pcmd);
>  	sgx_encl_put_backing(&b);
>  
>  	sgx_encl_truncate_backing_page(encl, page_index);
>  
> -	if (pcmd_page_empty && !pcmd_page_in_use(encl, pcmd_first_page))
> +	if (pcmd_page_empty && !pcmd_page_in_use(encl, pcmd_first_page)) {
>  		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
> +		pcmd_page = kmap_atomic(b.pcmd);
> +		WARN_ON_ONCE(memchr_inv(pcmd_page, 0, PAGE_SIZE));

Is WARN necessary, or would it make more sense to use pr_warn()?

It would give a better chance to collect information if "panic_on_warn" is
set for the running kernel.

> +		kunmap_atomic(pcmd_page);
> +	}
> +
> +	put_page(b.pcmd);
>  
>  	return ret;
>  }
> -- 
> 2.25.1
> 

BR, Jarkko
