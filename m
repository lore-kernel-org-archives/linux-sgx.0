Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCC3C636CC
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Feb 2023 23:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBGX3Z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Feb 2023 18:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBGX3Z (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Feb 2023 18:29:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F7B22A22
        for <linux-sgx@vger.kernel.org>; Tue,  7 Feb 2023 15:29:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FC1960F77
        for <linux-sgx@vger.kernel.org>; Tue,  7 Feb 2023 23:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC3FC433D2;
        Tue,  7 Feb 2023 23:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675812562;
        bh=8ZF15C56auaIYk3P9jM5DOiWv8jwZGgoG5qiG/QkGzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ohIsOD7ebv7/Ef7TDPUms9Rgc3LpdmLx61MMxEEMzlOuKneg4izZ9MDEsja7cMTtu
         W3UUy3fy80mHsivAnBMfPziOUgnbgP49aTvf/RCG8O31iL6jDDLsRSGwxyZrV369ua
         nrNhD8Fder4hMeTlPk7IAHNy/KJHTgQ4C75//h5lBBCO7BOoJzkNA5Hb6JU/CB8Mci
         zOWWYI+HMB3Pbxwu1QUJAD+Cc9QI6ry+szhyBo7TKgogtVMD555Y0+lKDSvdjwWQoY
         DW/Cmzm0U0RqEXUvhD//3FMm/tgllG6RIr2bZCwB195ovwV/h2Njk028q+xLkm5yLk
         Em4NFSxHJVFTQ==
Date:   Wed, 8 Feb 2023 01:29:18 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v4 3/4] selftests/sgx: add len field for EACCEPT op
Message-ID: <Y+LezsQyMfqrzGuA@kernel.org>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
 <20230128045529.15749-4-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128045529.15749-4-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jan 27, 2023 at 08:55:28PM -0800, Haitao Huang wrote:
> So we can EACCEPT multiple pages inside enclave without EEXIT,
> preparing for testing with MADV_WILLNEED for ranges bigger than
> a single page.
> 
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  tools/testing/selftests/sgx/defines.h   |  1 +
>  tools/testing/selftests/sgx/main.c      | 15 +++++++++++++++
>  tools/testing/selftests/sgx/test_encl.c | 18 ++++++++++++------
>  3 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
> index d8587c971941..8578e773d3d8 100644
> --- a/tools/testing/selftests/sgx/defines.h
> +++ b/tools/testing/selftests/sgx/defines.h
> @@ -60,6 +60,7 @@ struct encl_op_eaccept {
>  	struct encl_op_header header;
>  	uint64_t epc_addr;
>  	uint64_t flags;
> +	uint64_t len;
>  	uint64_t ret;
>  };
>  
> diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
> index e596b45bc5f8..e457f2d35461 100644
> --- a/tools/testing/selftests/sgx/main.c
> +++ b/tools/testing/selftests/sgx/main.c
> @@ -493,6 +493,7 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, TIMEOUT_DEFAULT)
>  
>  	eaccept_op.flags = SGX_SECINFO_TRIM | SGX_SECINFO_MODIFIED;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
> +	eaccept_op.len = PAGE_SIZE;
>  
>  	TH_LOG("Entering enclave to run EACCEPT for each page of %zd bytes may take a while ...",
>  	       heap->size);
> @@ -916,6 +917,7 @@ TEST_F(enclave, epcm_permissions)
>  	 * EPCM permissions changed from kernel, need to EACCEPT from enclave.
>  	 */
>  	eaccept_op.epc_addr = data_start;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_REG | SGX_SECINFO_PR;
>  	eaccept_op.ret = 0;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
> @@ -1092,6 +1094,7 @@ TEST_F(enclave, augment)
>  	self->run.tcs = self->encl.encl_base + PAGE_SIZE;
>  
>  	eaccept_op.epc_addr = self->encl.encl_base + total_size;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
>  	eaccept_op.ret = 0;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
> @@ -1194,6 +1197,7 @@ TEST_F(enclave, augment_via_eaccept)
>  	 * without a #PF). All should be transparent to userspace.
>  	 */
>  	eaccept_op.epc_addr = self->encl.encl_base + total_size;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
>  	eaccept_op.ret = 0;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
> @@ -1299,6 +1303,7 @@ TEST_F_TIMEOUT(enclave, augment_via_eaccept_long, TIMEOUT_DEFAULT)
>  	 * without a #PF). All should be transparent to userspace.
>  	 */
>  	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.ret = 0;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
>  
> @@ -1451,6 +1456,7 @@ TEST_F(enclave, tcs_create)
>  	 */
>  
>  	eaccept_op.epc_addr = (unsigned long)stack_end;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
>  	eaccept_op.ret = 0;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
> @@ -1471,6 +1477,7 @@ TEST_F(enclave, tcs_create)
>  	EXPECT_EQ(eaccept_op.ret, 0);
>  
>  	eaccept_op.epc_addr = (unsigned long)ssa;
> +	eaccept_op.len = PAGE_SIZE;
>  
>  	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
>  
> @@ -1481,6 +1488,7 @@ TEST_F(enclave, tcs_create)
>  	EXPECT_EQ(eaccept_op.ret, 0);
>  
>  	eaccept_op.epc_addr = (unsigned long)tcs;
> +	eaccept_op.len = PAGE_SIZE;
>  
>  	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
>  
> @@ -1533,6 +1541,7 @@ TEST_F(enclave, tcs_create)
>  
>  	/* EACCEPT new TCS page from enclave. */
>  	eaccept_op.epc_addr = (unsigned long)tcs;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.flags = SGX_SECINFO_TCS | SGX_SECINFO_MODIFIED;
>  	eaccept_op.ret = 0;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
> @@ -1601,6 +1610,7 @@ TEST_F(enclave, tcs_create)
>  	self->run.tcs = self->encl.encl_base;
>  
>  	eaccept_op.epc_addr = (unsigned long)stack_end;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.flags = SGX_SECINFO_TRIM | SGX_SECINFO_MODIFIED;
>  	eaccept_op.ret = 0;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
> @@ -1614,6 +1624,7 @@ TEST_F(enclave, tcs_create)
>  	EXPECT_EQ(eaccept_op.ret, 0);
>  
>  	eaccept_op.epc_addr = (unsigned long)tcs;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.ret = 0;
>  
>  	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
> @@ -1625,6 +1636,7 @@ TEST_F(enclave, tcs_create)
>  	EXPECT_EQ(eaccept_op.ret, 0);
>  
>  	eaccept_op.epc_addr = (unsigned long)ssa;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.ret = 0;
>  
>  	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
> @@ -1653,6 +1665,7 @@ TEST_F(enclave, tcs_create)
>  	 * trigger dynamic add of regular page at that location.
>  	 */
>  	eaccept_op.epc_addr = (unsigned long)tcs;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
>  	eaccept_op.ret = 0;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
> @@ -2022,6 +2035,7 @@ TEST_F(enclave, remove_added_page_invalid_access_after_eaccept)
>  	EXPECT_EQ(ioc.count, 4096);
>  
>  	eaccept_op.epc_addr = (unsigned long)data_start;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.ret = 0;
>  	eaccept_op.flags = SGX_SECINFO_TRIM | SGX_SECINFO_MODIFIED;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
> @@ -2112,6 +2126,7 @@ TEST_F(enclave, remove_untouched_page)
>  	 */
>  
>  	eaccept_op.epc_addr = data_start;
> +	eaccept_op.len = PAGE_SIZE;
>  	eaccept_op.flags = SGX_SECINFO_TRIM | SGX_SECINFO_MODIFIED;
>  	eaccept_op.ret = 0;
>  	eaccept_op.header.type = ENCL_OP_EACCEPT;
> diff --git a/tools/testing/selftests/sgx/test_encl.c b/tools/testing/selftests/sgx/test_encl.c
> index c0d6397295e3..439f1adbd357 100644
> --- a/tools/testing/selftests/sgx/test_encl.c
> +++ b/tools/testing/selftests/sgx/test_encl.c
> @@ -37,12 +37,18 @@ static void do_encl_eaccept(void *_op)
>  	int rax;
>  
>  	secinfo.flags = op->flags;
> -
> -	asm volatile(".byte 0x0f, 0x01, 0xd7"
> -				: "=a" (rax)
> -				: "a" (EACCEPT),
> -				  "b" (&secinfo),
> -				  "c" (op->epc_addr));
> +	for (uint64_t addr = op->epc_addr;
> +			addr < op->epc_addr + op->len; addr += 4096) {
> +		asm volatile(".byte 0x0f, 0x01, 0xd7"
> +					: "=a" (rax)
> +					: "a" (EACCEPT),
> +					  "b" (&secinfo),
> +					  "c" (addr));
> +		if (rax) {
> +			op->ret = rax;
> +			return;
> +		}
> +	}
>  
>  	op->ret = rax;
>  }
> -- 
> 2.25.1
> 

Tested-by: Jarkko Sakkinen <jarkko@kernel.org> # NUC7
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
