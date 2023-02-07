Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A6FC636CD
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Feb 2023 23:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBGXad (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Feb 2023 18:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjBGXa1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Feb 2023 18:30:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23C629E0F
        for <linux-sgx@vger.kernel.org>; Tue,  7 Feb 2023 15:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7356BB8198E
        for <linux-sgx@vger.kernel.org>; Tue,  7 Feb 2023 23:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E52C433EF;
        Tue,  7 Feb 2023 23:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675812623;
        bh=CdB0fUk/EyKjLraLYvNHWsewEv9PxfYDdFJYYGZbP5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RlH79H/ZHWwAd+BmC2E3tmj4Vq41Y5UYoFZlJKFlvPRSpsE9pO9/i3SWQBuilvRWs
         4avrJMexZIQXhfZ4quPoC1FCGAVx3YLGW1lAbJBFYxde3LFhf8/R75/LKf1weHA5Yz
         0pNpFtn4dRGxBwvBwxMO+G35kJpUWLNpqGBJ0AsEVQMnImiNoxqepRhAaZXF4It1hn
         lF8iORikr5LiqEBxjdosd9kU8NaGS8WLC9XckPQcS5WAcemTKofVRx6vW1G2CQL4Zb
         5uGrNFvkY1SnC+JsqcYA/gtCMtYjaCnh5f9kH7Zu28cNXuMxDYzafE+7uWUZwXaDiX
         yp11jL9DCCGYg==
Date:   Wed, 8 Feb 2023 01:30:18 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v4 4/4] selftests/sgx: Add test for madvise(...,
 WILLNEED)
Message-ID: <Y+LfCgEHvcCl4Zxj@kernel.org>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
 <20230128045529.15749-4-haitao.huang@linux.intel.com>
 <20230128045529.15749-5-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128045529.15749-5-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jan 27, 2023 at 08:55:29PM -0800, Haitao Huang wrote:
> Measure and compare run time for EAUG'ing different number
> of EPC pages with/without madvise(..., WILLNEED) call.
> 
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  tools/testing/selftests/sgx/main.c | 167 +++++++++++++++++++++++++++++
>  1 file changed, 167 insertions(+)
> 
> diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
> index e457f2d35461..e3432e73af69 100644
> --- a/tools/testing/selftests/sgx/main.c
> +++ b/tools/testing/selftests/sgx/main.c
> @@ -10,6 +10,7 @@
>  #include <stdint.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <time.h>
>  #include <unistd.h>
>  #include <sys/ioctl.h>
>  #include <sys/mman.h>
> @@ -1360,6 +1361,172 @@ TEST_F_TIMEOUT(enclave, augment_via_eaccept_long, TIMEOUT_DEFAULT)
>  	munmap(addr, DYNAMIC_HEAP_SIZE);
>  }
>  
> +static int eaccept_range(struct _test_data_enclave *self, void *addr,
> +			 unsigned long size, uint64_t flags,
> +						struct __test_metadata *_metadata)
> +{
> +	struct encl_op_eaccept eaccept_op;
> +
> +	self->run.exception_vector = 0;
> +	self->run.exception_error_code = 0;
> +	self->run.exception_addr = 0;
> +
> +	/*
> +	 * Run EACCEPT on every page to trigger the #PF->EAUG->EACCEPT(again
> +	 * without a #PF). All should be transparent to userspace.
> +	 */
> +	eaccept_op.flags = flags;
> +	eaccept_op.ret = 0;
> +	eaccept_op.header.type = ENCL_OP_EACCEPT;
> +	eaccept_op.len = size;
> +	eaccept_op.epc_addr = (uint64_t)(addr);
> +
> +	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
> +
> +	EXPECT_EQ(self->run.exception_vector, 0);
> +	EXPECT_EQ(self->run.exception_error_code, 0);
> +	EXPECT_EQ(self->run.exception_addr, 0);
> +	ASSERT_EQ(eaccept_op.ret, 0);
> +	ASSERT_EQ(self->run.function, EEXIT);
> +
> +	return 0;
> +}
> +
> +static int trim_remove_range(struct _test_data_enclave *self, void *addr,
> +			     unsigned long size, struct __test_metadata *_metadata)
> +{
> +	int ret, errno_save;
> +	struct sgx_enclave_remove_pages remove_ioc;
> +	struct sgx_enclave_modify_types modt_ioc;
> +	unsigned long offset;
> +	unsigned long count;
> +
> +	if ((uint64_t)addr <= self->encl.encl_base)
> +		return -1;
> +	offset = (uint64_t)addr - self->encl.encl_base;
> +
> +	memset(&modt_ioc, 0, sizeof(modt_ioc));
> +	modt_ioc.offset = offset;
> +	modt_ioc.length = size;
> +	modt_ioc.page_type = SGX_PAGE_TYPE_TRIM;
> +	count = 0;
> +	do {
> +		ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_MODIFY_TYPES, &modt_ioc);
> +
> +		errno_save = ret == -1 ? errno : 0;
> +		if (errno_save != EAGAIN)
> +			break;
> +		EXPECT_EQ(modt_ioc.result, 0);
> +
> +		count += modt_ioc.count;
> +		modt_ioc.offset += modt_ioc.count;
> +		modt_ioc.length -= modt_ioc.count;
> +		modt_ioc.result = 0;
> +		modt_ioc.count = 0;
> +	} while (modt_ioc.length != 0);
> +
> +	EXPECT_EQ(ret, 0);
> +	EXPECT_EQ(errno_save, 0);
> +	EXPECT_EQ(modt_ioc.result, 0);
> +	count += modt_ioc.count;
> +	EXPECT_EQ(count, size);
> +
> +	EXPECT_EQ(eaccept_range(self, addr, size,
> +				SGX_SECINFO_TRIM | SGX_SECINFO_MODIFIED,
> +				   _metadata), 0);
> +
> +	/* Complete page removal. */
> +	memset(&remove_ioc, 0, sizeof(remove_ioc));
> +	remove_ioc.offset = offset;
> +	remove_ioc.length = size;
> +	count = 0;
> +	do {
> +		ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_REMOVE_PAGES, &remove_ioc);
> +
> +		errno_save = ret == -1 ? errno : 0;
> +		if (errno_save != EAGAIN)
> +			break;
> +
> +		count += remove_ioc.count;
> +		remove_ioc.offset += remove_ioc.count;
> +		remove_ioc.length -= remove_ioc.count;
> +		remove_ioc.count = 0;
> +	} while (remove_ioc.length != 0);
> +
> +	EXPECT_EQ(ret, 0);
> +	EXPECT_EQ(errno_save, 0);
> +	count += remove_ioc.count;
> +	EXPECT_EQ(count, size);
> +
> +	return 0;
> +}
> +
> +/*
> + * Compare performance with and without madvise call before EACCEPT'ing
> + * different size of regions.
> + */
> +TEST_F_TIMEOUT(enclave, augment_via_madvise, TIMEOUT_DEFAULT)
> +{
> +	unsigned long advise_size = PAGE_SIZE;
> +	unsigned long max_advise_size = get_total_epc_mem() * 3UL;
> +	int speed_up_percent;
> +	clock_t start;
> +	double time_used1, time_used2;
> +	size_t total_size = 0;
> +	unsigned long i;
> +	void *addr;
> +
> +	if (!sgx2_supported())
> +		SKIP(return, "SGX2 not supported");
> +
> +	ASSERT_TRUE(setup_test_encl_dynamic(ENCL_HEAP_SIZE_DEFAULT,
> +					    max_advise_size, &self->encl, _metadata));
> +
> +	memset(&self->run, 0, sizeof(self->run));
> +	self->run.tcs = self->encl.encl_base;
> +
> +	for (i = 0; i < self->encl.nr_segments; i++) {
> +		struct encl_segment *seg = &self->encl.segment_tbl[i];
> +
> +		total_size += seg->size;
> +	}
> +
> +	for (i = 1; i < 52 && advise_size < max_advise_size; i++) {
> +		addr = mmap((void *)self->encl.encl_base + total_size, advise_size,
> +			    PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED,
> +					self->encl.fd, 0);
> +		EXPECT_NE(addr, MAP_FAILED);
> +
> +		start = clock();
> +		EXPECT_EQ(eaccept_range(self, addr, advise_size,
> +					SGX_SECINFO_R | SGX_SECINFO_W
> +								| SGX_SECINFO_REG
> +								| SGX_SECINFO_PENDING,
> +								_metadata), 0);
> +		time_used1 = (double)clock() - start;
> +
> +		EXPECT_EQ(trim_remove_range(self, addr, advise_size, _metadata), 0);
> +
> +		start = clock();
> +		EXPECT_EQ(madvise(addr, advise_size, MADV_WILLNEED), 0);
> +		EXPECT_EQ(eaccept_range(self, addr, advise_size,
> +					SGX_SECINFO_R | SGX_SECINFO_W
> +								| SGX_SECINFO_REG
> +								| SGX_SECINFO_PENDING,
> +								_metadata), 0);
> +		time_used2 = (double)clock() - start;
> +
> +		speed_up_percent = (int)((time_used1 - time_used2) / time_used1 * 100);
> +		TH_LOG("madvise speed up for eaug'ing %10ld pages: %d%%",
> +		       advise_size / PAGE_SIZE, speed_up_percent);
> +		EXPECT_GE(speed_up_percent, 0);
> +		EXPECT_EQ(trim_remove_range(self, addr, advise_size, _metadata), 0);
> +	    munmap(addr, advise_size);
> +		advise_size = (advise_size << 1UL);
> +	}
> +	encl_delete(&self->encl);
> +}
> +
>  /*
>   * SGX2 page type modification test in two phases:
>   * Phase 1:
> -- 
> 2.25.1
> 

Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
