Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E606FC00144
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Aug 2022 16:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiHAQq1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Aug 2022 12:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbiHAQqZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Aug 2022 12:46:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8177BFD1A
        for <linux-sgx@vger.kernel.org>; Mon,  1 Aug 2022 09:46:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FCE260FB9
        for <linux-sgx@vger.kernel.org>; Mon,  1 Aug 2022 16:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297DAC433D6;
        Mon,  1 Aug 2022 16:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659372382;
        bh=cVWmPIixgHl654gby+d1PRKQnPBcRcPsf9p6WUB9NR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gazilAJsQMXe/oeiqeRfesS00BiE7qLmgAdAEvMwBb03XJo4pH226SUxXeWLdEZVR
         73sVS2tqWTYaW+UOVrcHp31fNbYnTpwJN7wNl+S47T0TSE7sTBxGbfFoLLo8siuL1m
         FRJw63tg0+Hs49RatFmq0wpeGBKOQi81qoUmgomB4JthaCkvEGg8bnj5iZy03MWWnS
         LpS/0UKDa5WaOt1GzP6CGcRJN4FFazGSVA4dvtfWca+mgxmmxfYWVNt7K+AOmt/q1a
         jnWi+4/P0xbgSWQoHAxhajUblSOkfyDIydgT6i0XtEYfF8GuiTMv9Mblh87Ikv8Cy8
         GNcIOL80YugDg==
Date:   Mon, 1 Aug 2022 19:46:17 +0300
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
Cc:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
Message-ID: <YugDWezt7WtUip9Z@kernel.org>
References: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jul 29, 2022 at 04:01:04PM +0000, Dhanraj, Vijay wrote:
> Hi All,
> 
> I recently tested the V5 version of the patch with Gramine and ran into a seg-fault during EPC allocation that is `EAUG`ing via `EACCEPT`. Allocation worked fine for smaller requests and even up to 2GBs. But when I tried with 4GB allocation I got a seg-fault.
> Huang, Haitao and I created a simple patch to repro this issue using the SGX selftests and we do see the issue when using V5 (5.18.0-rc5) but cannot repro the issue in V4 (5.18.0-rc2). Not sure if this is a driver issue or kernel, can you please check?
> 
> Results with V5 using modified `augment_via_eaccept` test:
> #  RUN           enclave.augment_via_eaccept ...
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 8192, seg->size = 8192
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 12288, seg->size = 4096
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 36864, seg->size = 24576
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 40960, seg->size = 4096
> # main.c:1153:augment_via_eaccept:mmaping pages at end of enclave...
> # main.c:1167:augment_via_eaccept:Entering enclave to run EACCEPT for each page of 8589934592 bytes may take a while ...
> # main.c:1184:augment_via_eaccept:Expected self->run.exception_vector (14) == 0 (0)
> # main.c:1185:augment_via_eaccept:Expected self->run.exception_error_code (4) == 0 (0)
> # main.c:1186:augment_via_eaccept:Expected self->run.exception_addr (140106113478656) == 0 (0)
> # main.c:1188:augment_via_eaccept:Expected self->run.function (3) == EEXIT (4)
> # augment_via_eaccept: Test terminated by assertion
> 
> Results with V4 using modified `augment_via_eaccept` test:
> #  RUN           enclave.augment_via_eaccept ...
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 8192, seg->size = 8192
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 12288, seg->size = 4096
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 36864, seg->size = 24576
> # main.c:1135:augment_via_eaccept:test enclave: total_size = 40960, seg->size = 4096
> # main.c:1153:augment_via_eaccept:mmaping pages at end of enclave...
> # main.c:1167:augment_via_eaccept:Entering enclave to run EACCEPT for each page of 8589934592 bytes may take a while ...
> #            OK  enclave.augment_via_eaccept
> 
> 
> Test Patch:
> diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
> index 94bdeac1cf04..7de1b15c90b1 100644
> --- a/tools/testing/selftests/sgx/load.c
> +++ b/tools/testing/selftests/sgx/load.c
> @@ -171,7 +171,8 @@ uint64_t encl_get_entry(struct encl *encl, const char *symbol)
>  	return 0;
>  }
>  
> -bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
> +bool encl_load(const char *path, struct encl *encl, unsigned long heap_size,
> +			   unsigned long edmm_size)
>  {
>  	const char device_path[] = "/dev/sgx_enclave";
>  	struct encl_segment *seg;
> @@ -300,7 +301,7 @@ bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
>  
>  	encl->src_size = encl->segment_tbl[j].offset + encl->segment_tbl[j].size;
>  
> -	for (encl->encl_size = 4096; encl->encl_size < encl->src_size; )
> +	for (encl->encl_size = 4096; encl->encl_size < encl->src_size + edmm_size;)
>  		encl->encl_size <<= 1;
>  
>  	return true;
> diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
> index 9820b3809c69..8d7ce9389c8f 100644
> --- a/tools/testing/selftests/sgx/main.c
> +++ b/tools/testing/selftests/sgx/main.c
> @@ -25,6 +25,8 @@ static const uint64_t MAGIC = 0x1122334455667788ULL;
>  static const uint64_t MAGIC2 = 0x8877665544332211ULL;
>  vdso_sgx_enter_enclave_t vdso_sgx_enter_enclave;
>  
> +static const unsigned long edmm_size = 8589934592; //8G
> +
>  /*
>   * Security Information (SECINFO) data structure needed by a few SGX
>   * instructions (eg. ENCLU[EACCEPT] and ENCLU[EMODPE]) holds meta-data
> @@ -183,7 +185,7 @@ static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
>  	unsigned int i;
>  	void *addr;
>  
> -	if (!encl_load("test_encl.elf", encl, heap_size)) {
> +	if (!encl_load("test_encl.elf", encl, heap_size, edmm_size)) {
>  		encl_delete(encl);
>  		TH_LOG("Failed to load the test enclave.");
>  		return false;
> @@ -1104,14 +1106,19 @@ TEST_F(enclave, augment)
>   * Test for the addition of pages to an initialized enclave via a
>   * pre-emptive run of EACCEPT on page to be added.
>   */
> -TEST_F(enclave, augment_via_eaccept)
> +/*
> + * Test for the addition of pages to an initialized enclave via a
> + * pre-emptive run of EACCEPT on page to be added.
> + */
> +/*TEST_F(enclave, augment_via_eaccept)*/
> +TEST_F_TIMEOUT(enclave, augment_via_eaccept, 900)
>  {
>  	struct encl_op_get_from_addr get_addr_op;
>  	struct encl_op_put_to_addr put_addr_op;
>  	struct encl_op_eaccept eaccept_op;
>  	size_t total_size = 0;
>  	void *addr;
> -	int i;
> +	unsigned long i;
>  
>  	if (!sgx2_supported())
>  		SKIP(return, "SGX2 not supported");
> @@ -1125,6 +1132,7 @@ TEST_F(enclave, augment_via_eaccept)
>  		struct encl_segment *seg = &self->encl.segment_tbl[i];
>  
>  		total_size += seg->size;
> +		TH_LOG("test enclave: total_size = %ld, seg->size = %ld", total_size, seg->size);
>  	}
>  
>  	/*
> @@ -1132,7 +1140,7 @@ TEST_F(enclave, augment_via_eaccept)
>  	 * test enclave since enclave size must be a power of 2 in bytes while
>  	 * test_encl does not consume it all.
>  	 */
> -	EXPECT_LT(total_size + PAGE_SIZE, self->encl.encl_size);
> +	EXPECT_LT(total_size + edmm_size, self->encl.encl_size);
>  
>  	/*
>  	 * mmap() a page at end of existing enclave to be used for dynamic
> @@ -1142,10 +1150,10 @@ TEST_F(enclave, augment_via_eaccept)
>  	 * falls into the enclave's address range but not backed
>  	 * by existing enclave pages.
>  	 */
> -
> -	addr = mmap((void *)self->encl.encl_base + total_size, PAGE_SIZE,
> -		    PROT_READ | PROT_WRITE | PROT_EXEC, MAP_SHARED | MAP_FIXED,
> -		    self->encl.fd, 0);
> +	TH_LOG("mmaping pages at end of enclave...");
> +	addr = mmap((void *)self->encl.encl_base + total_size, edmm_size,
> +			PROT_READ | PROT_WRITE | PROT_EXEC, MAP_SHARED | MAP_FIXED,
> +			self->encl.fd, 0);
>  	EXPECT_NE(addr, MAP_FAILED);
>  
>  	self->run.exception_vector = 0;
> @@ -1156,25 +1164,29 @@ TEST_F(enclave, augment_via_eaccept)
>  	 * Run EACCEPT on new page to trigger the #PF->EAUG->EACCEPT(again
>  	 * without a #PF). All should be transparent to userspace.
>  	 */
> -	eaccept_op.epc_addr = self->encl.encl_base + total_size;
> +	TH_LOG("Entering enclave to run EACCEPT for each page of %zd bytes may take a while ...",
> +			edmm_size);
>  	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
>  	eaccept_op.ret = 0;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
>  
> -	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
> +	for (i = 0; i < edmm_size; i += 4096) {
> +		eaccept_op.epc_addr = (uint64_t)(addr + i);
>  
> -	if (self->run.exception_vector == 14 &&
> -	    self->run.exception_error_code == 4 &&
> -	    self->run.exception_addr == self->encl.encl_base + total_size) {
> -		munmap(addr, PAGE_SIZE);
> -		SKIP(return, "Kernel does not support adding pages to initialized enclave");
> -	}
> +		EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
> +		if (self->run.exception_vector == 14 &&
> +			self->run.exception_error_code == 4 &&
> +			self->run.exception_addr == self->encl.encl_base) {
> +			munmap(addr, edmm_size);
> +			SKIP(return, "Kernel does not support adding pages to initialized enclave");
> +		}
>  
> -	EXPECT_EEXIT(&self->run);
> -	EXPECT_EQ(self->run.exception_vector, 0);
> -	EXPECT_EQ(self->run.exception_error_code, 0);
> -	EXPECT_EQ(self->run.exception_addr, 0);
> -	EXPECT_EQ(eaccept_op.ret, 0);
> +		EXPECT_EQ(self->run.exception_vector, 0);
> +		EXPECT_EQ(self->run.exception_error_code, 0);
> +		EXPECT_EQ(self->run.exception_addr, 0);
> +		ASSERT_EQ(eaccept_op.ret, 0);
> +		ASSERT_EQ(self->run.function, EEXIT);
> +	}
>  
>  	/*
>  	 * New page should be accessible from within enclave - attempt to
> @@ -1207,7 +1219,7 @@ TEST_F(enclave, augment_via_eaccept)
>  	EXPECT_EQ(self->run.exception_error_code, 0);
>  	EXPECT_EQ(self->run.exception_addr, 0);
>  
> -	munmap(addr, PAGE_SIZE);
> +	munmap(addr, edmm_size);
>  }
>  
>  /*
> diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/sgx/main.h
> index fc585be97e2f..fe5d39ac0e1e 100644
> --- a/tools/testing/selftests/sgx/main.h
> +++ b/tools/testing/selftests/sgx/main.h
> @@ -35,7 +35,8 @@ extern unsigned char sign_key[];
>  extern unsigned char sign_key_end[];
>  
>  void encl_delete(struct encl *ctx);
> -bool encl_load(const char *path, struct encl *encl, unsigned long heap_size);
> +bool encl_load(const char *path, struct encl *encl, unsigned long heap_size,
> +			   unsigned long edmm_size);
>  bool encl_measure(struct encl *encl);
>  bool encl_build(struct encl *encl);
>  uint64_t encl_get_entry(struct encl *encl, const char *symbol);
> diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
> index 50c5ab1aa6fa..6000cf0e4975 100644
> --- a/tools/testing/selftests/sgx/sigstruct.c
> +++ b/tools/testing/selftests/sgx/sigstruct.c
> @@ -343,7 +343,7 @@ bool encl_measure(struct encl *encl)
>  	if (!ctx)
>  		goto err;
>  
> -	if (!mrenclave_ecreate(ctx, encl->src_size))
> +	if (!mrenclave_ecreate(ctx, encl->encl_size))
>  		goto err;
>  
>  	for (i = 0; i < encl->nr_segments; i++) {
> -- 
> 2.17.1
> 
> 
> Thanks,
> -Vijay

Which hardware was used to produce this bug (e.g. /proc/cpuinfo)?

BR, Jarkko
