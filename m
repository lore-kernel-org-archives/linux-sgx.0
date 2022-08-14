Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF34C25B06
	for <linux-sgx@archiver.kernel.org>; Sun, 14 Aug 2022 19:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiHNTjX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 14 Aug 2022 15:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiHNTjU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 14 Aug 2022 15:39:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E6C17E08
        for <linux-sgx@vger.kernel.org>; Sun, 14 Aug 2022 12:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02A7DB80B52
        for <linux-sgx@vger.kernel.org>; Sun, 14 Aug 2022 19:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514CCC433D6;
        Sun, 14 Aug 2022 19:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660505956;
        bh=WaNjCCpuoevkAUI4dMCV24IFdFZa/WO5/rmDaLX3YYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f8YxInMEtGoUrfCb+VMIMskcZbMTN0qByOOFSq9v8rEY/1JAXG7h1dStgnheJpk9l
         CPfM6+qv9WjbZ8Yt1mhDsbjAfvtDz33WqSqqOI7f/+nEaZ6AegAa6LGE8k5QGX7Ejn
         HurE3hVoJGY/XWqGcjdlVJmrP3f0YicTPRmdhhkbpPidN8Qdg8fycS3cvD+YB72Sb9
         yjoNfAWvxTvOgtRnpUCh+K0+/o4egnQ2F6UQtIFdvM1EAn6NdcnE4NNYyzrrDIztMr
         mVx7pxyjrHUtX5iE102JuoWo+5JI9F4CqG59lPtSeVYfBRWtIewluOUjdAJTudXvu8
         8FdRzYZE9IL5A==
Date:   Sun, 14 Aug 2022 22:39:13 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, reinette.chatre@intel.com,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH] selftests/sgx: retry the ioctls returned with EAGAIN
Message-ID: <YvlPYRvMicz9CPFQ@kernel.org>
References: <20220812201331.18791-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812201331.18791-1-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 12, 2022 at 01:13:31PM -0700, Haitao Huang wrote:
> For EMODT and EREMOVE ioctls with a large range, kernel
> may not finish in one shot and return EAGAIN error code
> and count of bytes of EPC pages on that operations are
> finished successfully.
> 
> Change the unclobbered_vdso_oversubscribed_remove test
> to rerun the ioctls in a loop, updating offset and length
> using the byte count returned in each iteration.
> 
> Signed-off-by: Haitao Huang <haitao.huang@intel.com>
> ---
>  tools/testing/selftests/sgx/main.c | 39 +++++++++++++++++++++++-------
>  1 file changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
> index 9820b3809c69..ff66ce2bbcac 100644
> --- a/tools/testing/selftests/sgx/main.c
> +++ b/tools/testing/selftests/sgx/main.c
> @@ -391,7 +391,7 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
>  	unsigned long total_mem;
>  	int ret, errno_save;
>  	unsigned long addr;
> -	unsigned long i;
> +	unsigned long i, count;
>  
>  	/*
>  	 * Create enclave with additional heap that is as big as all
> @@ -453,16 +453,27 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
>  	modt_ioc.offset = heap->offset;
>  	modt_ioc.length = heap->size;
>  	modt_ioc.page_type = SGX_PAGE_TYPE_TRIM;
> -
> +	count = 0;
>  	TH_LOG("Changing type of %zd bytes to trimmed may take a while ...",
>  	       heap->size);
> -	ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_MODIFY_TYPES, &modt_ioc);
> -	errno_save = ret == -1 ? errno : 0;
> +	do {
> +		ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_MODIFY_TYPES, &modt_ioc);
> +		errno_save = ret == -1 ? errno : 0;
> +		if (errno_save == EAGAIN) {
> +			count += modt_ioc.count;
> +			modt_ioc.offset += modt_ioc.count;
> +			modt_ioc.length -= modt_ioc.count;
> +			modt_ioc.result= 0;
> +			modt_ioc.count = 0;
> +		} else
> +			break;
> +	} while(modt_ioc.length != 0);
>  
>  	EXPECT_EQ(ret, 0);
>  	EXPECT_EQ(errno_save, 0);
>  	EXPECT_EQ(modt_ioc.result, 0);
> -	EXPECT_EQ(modt_ioc.count, heap->size);
> +	count += modt_ioc.count;
> +	EXPECT_EQ(count, heap->size);
>  
>  	/* EACCEPT all removed pages. */
>  	addr = self->encl.encl_base + heap->offset;
> @@ -490,15 +501,25 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
>  
>  	remove_ioc.offset = heap->offset;
>  	remove_ioc.length = heap->size;
> -
> +	count = 0;
>  	TH_LOG("Removing %zd bytes from enclave may take a while ...",
>  	       heap->size);
> -	ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_REMOVE_PAGES, &remove_ioc);
> -	errno_save = ret == -1 ? errno : 0;
> +    do {
> +		ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_REMOVE_PAGES, &remove_ioc);
> +		errno_save = ret == -1 ? errno : 0;
> +		if (errno_save == EAGAIN) {
> +			count += remove_ioc.count;
> +			remove_ioc.offset += remove_ioc.count;
> +			remove_ioc.length -= remove_ioc.count;
> +			remove_ioc.count = 0;
> +		} else
> +			break;
> +	} while(remove_ioc.length != 0);
>  
>  	EXPECT_EQ(ret, 0);
>  	EXPECT_EQ(errno_save, 0);
> -	EXPECT_EQ(remove_ioc.count, heap->size);
> +	count += remove_ioc.count;
> +	EXPECT_EQ(count, heap->size);
>  }
>  
>  TEST_F(enclave, clobbered_vdso)
> -- 
> 2.25.1
> 

Thank you.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
