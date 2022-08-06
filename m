Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03D2C19F2D
	for <linux-sgx@archiver.kernel.org>; Sat,  6 Aug 2022 18:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiHFSSk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 6 Aug 2022 14:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbiHFSSj (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 6 Aug 2022 14:18:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9637AE0E2
        for <linux-sgx@vger.kernel.org>; Sat,  6 Aug 2022 11:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D21361224
        for <linux-sgx@vger.kernel.org>; Sat,  6 Aug 2022 18:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C919C43470;
        Sat,  6 Aug 2022 18:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659809916;
        bh=kvS6PqVN623a4ZtTttUrenuxmYYEmnI3qtBixThMFOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fAbKUjR0AsicW6vxPpBgl8fTMpneswEkgwR6PZBnkUxOC/G2dYOMVc6OxsYk/Okku
         y3wdPp01on9meo1e9jnSw/LT18i7PKkhkGVGzUVdBH8RJgzmFvpo8q3WoyRvoj7hlR
         LCOCDzfz2kqBJE7SBptvAWiUWYjhnCxiSXeg/iI+8VJlB4V7ih47uuV3U5W+fbmeL0
         LMCj+iLXx8It6l9g+4/k04RuLrFYDgNvZNH3fkpoxLAzOZDf9DANZYy8NGY4t7oprU
         pCxDTXJz66or7TqWJeQFr/r0zen3SytAkT4QyIGEe6oQpqKyTPNaIukS3MJU4YgV5S
         KTxJeo5wRmOlg==
Date:   Sat, 6 Aug 2022 21:18:34 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     vijay.dhanraj@intel.com
Cc:     linux-sgx@vger.kernel.org, reinette.chatre@intel.com,
        dave.hansen@linux.intel.com, haitao.huang@intel.com
Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Message-ID: <Yu6wess0J/vKnWTb@kernel.org>
References: <20220804201456.33418-1-vijay.dhanraj@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804201456.33418-1-vijay.dhanraj@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 04, 2022 at 01:14:56PM -0700, vijay.dhanraj@intel.com wrote:
> From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> 
> This commit adds a new test case which is same as `augment_via_eaccept`
> but adds more number of EPC pages to stress test `EAUG` via `EACCEPT`.
> 
> Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>

Thank you. I'll run this with Icelake system.

> ---
>  tools/testing/selftests/sgx/load.c      |   5 +-
>  tools/testing/selftests/sgx/main.c      | 120 +++++++++++++++++++++++-
>  tools/testing/selftests/sgx/main.h      |   3 +-
>  tools/testing/selftests/sgx/sigstruct.c |   2 +-
>  4 files changed, 125 insertions(+), 5 deletions(-)
> 
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
> index 9820b3809c69..65e79682f75e 100644
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
> @@ -1210,6 +1212,122 @@ TEST_F(enclave, augment_via_eaccept)
>  	munmap(addr, PAGE_SIZE);
>  }
>  
> +/*
> + * Test for the addition of large number of pages to an initialized enclave via
> + * a pre-emptive run of EACCEPT on page to be added.
> + */
> +#define TIMEOUT_LONG 900 /* seconds */
> +TEST_F_TIMEOUT(enclave, augment_via_eaccept_long, TIMEOUT_LONG)
> +{
> +	struct encl_op_get_from_addr get_addr_op;
> +	struct encl_op_put_to_addr put_addr_op;
> +	struct encl_op_eaccept eaccept_op;
> +	size_t total_size = 0;
> +	void *addr;
> +	unsigned long i;
> +
> +	if (!sgx2_supported())
> +		SKIP(return, "SGX2 not supported");
> +
> +	ASSERT_TRUE(setup_test_encl(ENCL_HEAP_SIZE_DEFAULT, &self->encl, _metadata));
> +
> +	memset(&self->run, 0, sizeof(self->run));
> +	self->run.tcs = self->encl.encl_base;
> +
> +	for (i = 0; i < self->encl.nr_segments; i++) {
> +		struct encl_segment *seg = &self->encl.segment_tbl[i];
> +
> +		total_size += seg->size;
> +		TH_LOG("test enclave: total_size = %ld, seg->size = %ld", total_size, seg->size);
> +	}
> +
> +	/*
> +	 * Actual enclave size is expected to be larger than the loaded
> +	 * test enclave since enclave size must be a power of 2 in bytes while
> +	 * test_encl does not consume it all.
> +	 */
> +	EXPECT_LT(total_size + edmm_size, self->encl.encl_size);
> +
> +	/*
> +	 * mmap() a page at end of existing enclave to be used for dynamic
> +	 * EPC page.
> +	 *
> +	 * Kernel will allow new mapping using any permissions if it
> +	 * falls into the enclave's address range but not backed
> +	 * by existing enclave pages.
> +	 */
> +	TH_LOG("mmaping pages at end of enclave...");
> +	addr = mmap((void *)self->encl.encl_base + total_size, edmm_size,
> +			PROT_READ | PROT_WRITE | PROT_EXEC, MAP_SHARED | MAP_FIXED,
> +			self->encl.fd, 0);
> +	EXPECT_NE(addr, MAP_FAILED);
> +
> +	self->run.exception_vector = 0;
> +	self->run.exception_error_code = 0;
> +	self->run.exception_addr = 0;
> +
> +	/*
> +	 * Run EACCEPT on new page to trigger the #PF->EAUG->EACCEPT(again
> +	 * without a #PF). All should be transparent to userspace.
> +	 */
> +	TH_LOG("Entering enclave to run EACCEPT for each page of %zd bytes may take a while ...",
> +			edmm_size);
> +	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
> +	eaccept_op.ret = 0;
> +	eaccept_op.header.type = ENCL_OP_EACCEPT;
> +
> +	for (i = 0; i < edmm_size; i += 4096) {
> +		eaccept_op.epc_addr = (uint64_t)(addr + i);
> +
> +		EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
> +		if (self->run.exception_vector == 14 &&
> +			self->run.exception_error_code == 4 &&
> +			self->run.exception_addr == self->encl.encl_base) {
> +			munmap(addr, edmm_size);
> +			SKIP(return, "Kernel does not support adding pages to initialized enclave");
> +		}
> +
> +		EXPECT_EQ(self->run.exception_vector, 0);
> +		EXPECT_EQ(self->run.exception_error_code, 0);
> +		EXPECT_EQ(self->run.exception_addr, 0);
> +		ASSERT_EQ(eaccept_op.ret, 0);
> +		ASSERT_EQ(self->run.function, EEXIT);
> +	}
> +
> +	/*
> +	 * New page should be accessible from within enclave - attempt to
> +	 * write to it.
> +	 */
> +	put_addr_op.value = MAGIC;
> +	put_addr_op.addr = (unsigned long)addr;
> +	put_addr_op.header.type = ENCL_OP_PUT_TO_ADDRESS;
> +
> +	EXPECT_EQ(ENCL_CALL(&put_addr_op, &self->run, true), 0);
> +
> +	EXPECT_EEXIT(&self->run);
> +	EXPECT_EQ(self->run.exception_vector, 0);
> +	EXPECT_EQ(self->run.exception_error_code, 0);
> +	EXPECT_EQ(self->run.exception_addr, 0);
> +
> +	/*
> +	 * Read memory from newly added page that was just written to,
> +	 * confirming that data previously written (MAGIC) is present.
> +	 */
> +	get_addr_op.value = 0;
> +	get_addr_op.addr = (unsigned long)addr;
> +	get_addr_op.header.type = ENCL_OP_GET_FROM_ADDRESS;
> +
> +	EXPECT_EQ(ENCL_CALL(&get_addr_op, &self->run, true), 0);
> +
> +	EXPECT_EQ(get_addr_op.value, MAGIC);
> +	EXPECT_EEXIT(&self->run);
> +	EXPECT_EQ(self->run.exception_vector, 0);
> +	EXPECT_EQ(self->run.exception_error_code, 0);
> +	EXPECT_EQ(self->run.exception_addr, 0);
> +
> +	munmap(addr, edmm_size);
> +}
> +
>  /*
>   * SGX2 page type modification test in two phases:
>   * Phase 1:
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

BR, Jarkko
